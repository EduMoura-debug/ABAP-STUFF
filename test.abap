LOOP AT it_keys ASSIGNING FIELD-SYMBOL(<fs_keys>).

      lo_bo_manag_prd = /scwm/cl_dlv_management_prd=>get_instance( ).
      lo_sp = lo_bo_manag_prd->get_service_provider( iv_doccat = 'PDO' ).

      lo_bo_manag = /scdl/cl_bo_management=>get_instance( ).
      lo_bo = lo_bo_manag->get_bo_by_id( iv_docid = <fs_keys>-docid ).

*    ENDLOOP "ALT

    CHECK lo_sp IS BOUND AND lo_bo IS BOUND.

    REFRESH lt_item_aux[]. "ALT

    TRY.
        CALL METHOD lo_bo->get_item_tab
          EXPORTING
            iv_objectstate = /scdl/if_dl_object_c=>sc_object_state_curr " Object State
          IMPORTING
            et_item        = lt_item_aux.                                     " Item Table
    ENDTRY.

    IF lt_item_aux[] IS NOT INITIAL.
      APPEND ALL LINES OF lt_item_aux TO lt_item.
    ENDIF.

  ENDLOOP. "ALT

    LOOP AT lt_item ASSIGNING FIELD-SYMBOL(<fs_item>).
      lw_refdocid = <fs_item>-item->get_refdoc_key( ).

      lw_docid-itemid = lw_refdocid-refitemid.
      lw_docid-docid  = lw_refdocid-refdocid.
      lw_docid-doccat = lw_refdocid-refdoccat.
      APPEND lw_docid TO lt_docid.

    ENDLOOP.

    IF lt_docid IS NOT INITIAL.

      TRY.
          lo_bo_manag_prd->query(
              EXPORTING
                it_docid                    = lt_docid                " Order Document Identification with ID and Category
                iv_doccat                   = iv_doccat                 " Document Category
              IMPORTING
                et_headers                  = lt_header                 " Delivery Header (PRD) for Read Operations
                et_items                    = lt_item_out                 " Delivery Item (PRD) for Read Operations
                eo_message                  = lo_msg                  " Messages
          ).
        CATCH /scdl/cx_delivery. " Exception Class of Delivery
      ENDTRY.

    ENDIF.

*    BREAK-POINT.

    CHECK lt_header IS NOT INITIAL.

*    READ TABLE lt_header ASSIGNING FIELD-SYMBOL(<fs_header>) INDEX 1.
    LOOP AT lt_header ASSIGNING FIELD-SYMBOL(<fs_header>).


      CLEAR: vbco3, tvko, vbdkl, wvbdpl, ls_outputform.
      REFRESH: tvbdpl, lt_vbdpl, tkombat, lt_conf_out, tkomser, lt_komser_print, lt_komser.

"Comparar HEADER E ITEM 

    READ TABLE <fs_header>-partyloc ASSIGNING FIELD-SYMBOL(<fs_partyloc>) WITH KEY role_cat = 'BP'.

**********************************************************************
*** ASSEMBLE VBCO3 FOR RECOVERY OF DATA OF VBDPL

    SHIFT lw_refdocid-refdocno LEFT DELETING LEADING '0'.

    vbco3-vbeln = lw_refdocid-refdocno. "Substituto ou READ TABLE LT_DOCID
    vbco3-kunde = <fs_partyloc>-partyno.

    SELECT SINGLE spras
      FROM kna1
      INTO vbco3-spras
      WHERE kunnr EQ <fs_partyloc>-partyno.

    SELECT SINGLE parvw
      FROM vbpa
      INTO vbco3-parvw
      WHERE vbeln EQ  lw_refdocid-refdocno "vbco3-vbeln
      AND   parvw EQ 'WE'.


    SELECT *
      FROM tvko
      INTO tvko
      UP TO 1 ROWS
      FOR ALL ENTRIES IN lt_item_out "A
      WHERE kunnr EQ lt_item_out-stock-stock_owner. "A
    ENDSELECT.

    CALL FUNCTION 'RV_DELIVERY_PRINT_VIEW'
      EXPORTING
        comwa = vbco3
      IMPORTING
        kopf  = vbdkl
      TABLES
        pos   = tvbdpl.

    LOOP AT tvbdpl INTO wvbdpl.
      MOVE-CORRESPONDING wvbdpl TO ls_vbdpl.
      APPEND ls_vbdpl TO lt_vbdpl.
      CLEAR ls_vbdpl.
    ENDLOOP.

**********************************************************************
*** RETURN ARC CODES IF ANY
    cl_shp_emcs=>factory( )->get_arc_codes( CHANGING cs_vbdkl = vbdkl ct_emcs_arcs = emcs_arcs_tab ).

**********************************************************************
*** CHOOSE BETWEEN DOCUMENT FOR OTHER COUNTRIES OR PORTUGAL EXCLUSIVE
    IF vbdkl-land1 NE 'PT'.
      lv_form = 'ZAF_OTC_RVDELNOTE'.
    ELSE.
      lv_form = 'ZAF_OTC_RVDELNOTE_PT'.
    ENDIF.

**********************************************************************
*** GET THE SFP FORM NAME
    CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
      EXPORTING
        i_name     = lv_form
      IMPORTING
        e_funcname = lv_fm_name.

**********************************************************************
*** SET UP CONF OUT
    LOOP AT tvbdpl INTO vbdpl.

      CALL FUNCTION 'VB_BATCH_VALUES_FOR_OUTPUT'
        EXPORTING
          material               = vbdpl-matnr
          plant                  = vbdpl-werks
          batch                  = vbdpl-charg
          language               = vbco3-spras
        TABLES
          classification         = tkombat
        EXCEPTIONS
          no_classification_data = 1
          OTHERS                 = 2.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.

      LOOP AT tkombat INTO wkombat.
        conf_out = wkombat.
        MOVE-CORRESPONDING conf_out TO ls_conf_out.
        MOVE-CORRESPONDING wvbdpl TO ls_conf_out.
        APPEND ls_conf_out TO lt_conf_out.
        CLEAR ls_conf_out.
      ENDLOOP.

      CALL FUNCTION 'SERIAL_LS_PRINT'
        EXPORTING
          vbeln  = vbdkl-vbeln
          posnr  = vbdpl-posnr
        TABLES
          iserls = tkomser.

    ENDLOOP.

    CALL FUNCTION 'PROCESS_SERIALS_FOR_PRINT'
      EXPORTING
        i_boundary_left             = '(_'
        i_boundary_right            = '_)'
        i_sep_char_strings          = ',_'
        i_sep_char_interval         = '_-_'
        i_use_interval              = 'X'
        i_boundary_method           = 'C'
        i_line_length               = 50
        i_no_zero                   = 'X'
        i_alphabet                  = sy-abcde
        i_digits                    = '0123456789'
        i_special_chars             = '-'
        i_with_second_digit         = ' '
        i_allow_special_chars       = 'X'
      TABLES
        serials                     = tkomser
        serials_print               = lt_komser_print
      EXCEPTIONS
        string_with_wrong_char      = 1
        two_equal_strings           = 2
        wrong_string                = 3
        boundary_missing            = 4
        interval_separation_missing = 5
        length_to_small             = 6
        internal_error              = 7
        wrong_method                = 8
        wrong_serial                = 9
        two_equal_serials           = 10
        serial_with_wrong_char      = 11
        serial_separation_missing   = 12
        OTHERS                      = 13.
    IF sy-subrc <> 0.
*  Implement suitable error handling here
    ENDIF.

    LOOP AT lt_komser_print INTO ls_komser_print.
      MOVE-CORRESPONDING ls_komser_print TO ls_komser.
      MOVE-CORRESPONDING wvbdpl          TO ls_komser.
      APPEND ls_komser TO lt_komser.
      CLEAR ls_komser.
    ENDLOOP.

**********************************************************************
*** SET UP DOCUMENT PARAMETERS FOR PDF RETURN
    ls_outputparams-nodialog  = abap_true.
    ls_outputparams-nopreview = abap_true.
    ls_outputparams-noprint   = abap_true.
    ls_outputparams-getpdf    = abap_true.

    CALL FUNCTION 'FP_JOB_OPEN'
      CHANGING
        ie_outputparams = ls_outputparams
      EXCEPTIONS
        cancel          = 1
        usage_error     = 2
        system_error    = 3
        internal_error  = 4
        OTHERS          = 5.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

*NOTE: It is possible that some of the parameters in the function may
*      act like placeholders for not having any data in RVADDN01

    IF lv_fm_name IS NOT INITIAL.

      CALL FUNCTION lv_fm_name
        EXPORTING
          /1bcdwb/docparams  = ls_outputdocs
          vbdpl              = lt_vbdpl
          deliveryheader     = vbdkl
          conf_out           = lt_conf_out
          rdgtxtprt          = lt_rdgtxtprt "This serves nothing btw lol
          komser             = lt_komser
          include_text       = tvko
          repeat             = '1'
          dg_text            = lt_dg
          emcs_arcs          = emcs_arcs_tab
        IMPORTING
          /1bcdwb/formoutput = ls_outputform
        EXCEPTIONS
          usage_error        = 1
          system_error       = 2
          internal_error     = 3
          OTHERS             = 4.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.

    ENDIF.

    CALL FUNCTION 'FP_JOB_CLOSE'
      EXCEPTIONS
        usage_error    = 1
        system_error   = 2
        internal_error = 3
        OTHERS         = 4.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

**********************************************************************
*** BUILD E-MAIL FOR SENDING PDF FILE
**********************************************************************

**********************************************************************
*** GET E-MAIL

    CLEAR: lv_emailaddr.
    
    SELECT SINGLE smtp_addr
      FROM adr6
      INTO lv_emailaddr
      WHERE addrnumber EQ <fs_partyloc>-addressid_md.

    IF lv_emailaddr IS NOT INITIAL.

      ls_text-line = 'Dear recipient.' .
      APPEND ls_text TO lt_text.
      ls_text-line = cl_abap_char_utilities=>newline.
      APPEND ls_text TO lt_text.
      ls_text-line = 'The Post Goods Issue document is ready, please refer to the attached document.'.
      APPEND ls_text TO lt_text.

      DO 3 TIMES.
        ls_text-line = cl_abap_char_utilities=>newline.
        APPEND ls_text TO lt_text.
      ENDDO.

      ls_text-line = 'This e-mail has been sent automatically, please do not respond.'.
      APPEND ls_text TO lt_text.

*   ---------- create persistent send request ----------------------
      TRY.
          send_request = cl_bcs=>create_persistent( ).
        CATCH cx_send_req_bcs.
      ENDTRY.

*   ---------- add document ----------------------------------------
*   get PDF xstring and convert it to BCS format
      CLEAR: lp_pdf_size, lv_pdf_cont, lv_subject.

      lp_pdf_size = xstrlen( ls_outputform-pdf ).
      lv_pdf_cont = cl_document_bcs=>xstring_to_solix( ip_xstring = ls_outputform-pdf  ).
      lv_subject = |[MOOVE] Post Good Issue: { vbdkl-vbeln }|.

      TRY.
          document = cl_document_bcs=>create_document(
                i_type    = 'RAW' " cf. RAW, DOC
                i_text    = lt_text
                i_length  = lp_pdf_size
                i_subject = lv_subject ).                   "#EC NOTEXT
        CATCH cx_document_bcs.
      ENDTRY.

      TRY.
          document->add_attachment(
            EXPORTING
              i_attachment_type     = 'PDF'                     " Document Class for Attachment
              i_attachment_subject  = |PGI_{ vbdkl-vbeln }.pdf| " Attachment Title
              i_attachment_size     = lp_pdf_size               " Size of Document Content
              i_att_content_hex     = lv_pdf_cont               " Content (Binary)
          ).
        CATCH cx_document_bcs. " BCS: Document Exceptions
      ENDTRY.

*   add document to send request
      TRY.
          send_request->set_document( document ).
        CATCH cx_address_bcs.
        CATCH cx_send_req_bcs.
      ENDTRY.

*  add recipient (e-mail address)
      TRY.
          recipient = cl_cam_address_bcs=>create_internet_address( i_address_string = lv_emailaddr ).
        CATCH cx_address_bcs.
      ENDTRY.

* add recipient to send request.
      TRY.
          send_request->add_recipient( i_recipient = recipient ).
        CATCH cx_send_req_bcs.
      ENDTRY.

*   ---------- send document ---------------------------------------
      TRY.
          lv_sent_to_all = send_request->send(
              i_with_error_screen = 'X' ).
        CATCH cx_send_req_bcs.
      ENDTRY.

      

    ENDLOOP.

    ENDIF.