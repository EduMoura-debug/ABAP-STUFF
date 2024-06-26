DATA:
      emails TYPE adr6-smtp_addr OCCURS 0.

CONSTANTS: c_sender LIKE sy-uname VALUE 'SAP_WFRT'.

DATA: lv_sent_to_all TYPE os_boolean,
      lv_string_text TYPE string,
      lt_text        TYPE bcsy_text,
      lv_sendto      TYPE ad_smtpadr.
* Object References
DATA: lo_bcs         TYPE REF TO cl_bcs,
      lo_doc_bcs     TYPE REF TO cl_document_bcs,
      lo_recep       TYPE REF TO if_recipient_bcs,
      lo_sapuser_bcs TYPE REF TO cl_sapuser_bcs,
      lo_cx_bcx      TYPE REF TO cx_bcs.

DATA: l_subject         TYPE so_obj_des.
DATA: l_attach_name     TYPE so_obj_des.

PARAMETERS p_ebeln TYPE ekko-ebeln.

TRY.
*     -------- create persistent send request ------------------------
    lo_bcs = cl_bcs=>create_persistent( ).

    "Assunto
    CONCATENATE sy-sysid sy-mandt '- [FLASAP] -' p_ebeln 'APROVADO.'
                INTO l_subject
                SEPARATED BY space.


    CONCATENATE '<html>' '<body>' INTO lv_string_text.
*      APPEND lv_string_text TO lt_text.

*      CLEAR lv_string_text.
    CONCATENATE lv_string_text '<p>Prezado(s),' '</p>'
                cl_abap_char_utilities=>newline INTO lv_string_text
                SEPARATED BY space.
*      APPEND lv_string_text TO lt_text.

    CONCATENATE lv_string_text '<p></p>' cl_abap_char_utilities=>newline INTO lv_string_text.

    CONCATENATE lv_string_text '<p>Informamos que o documento SAP abaixo foi completamente aprovado.</p>' INTO lv_string_text.

    CONCATENATE lv_string_text '<p></p>' cl_abap_char_utilities=>newline INTO lv_string_text.

    CONCATENATE lv_string_text '<p>Pedido:' p_ebeln '</p>' INTO lv_string_text.

*      CLEAR lv_string_text.
    CONCATENATE lv_string_text '</body>' '<html>' INTO lv_string_text.
*      APPEND lv_string_text TO lt_text.

    CALL FUNCTION 'SCMS_STRING_TO_FTEXT'
      EXPORTING
        text      = lv_string_text
*       IMPORTING
*       LENGTH    =
      TABLES
        ftext_tab = lt_text.

*---------------------------------------------------------------------
*-----------------&      Create Document     *------------------------
*---------------------------------------------------------------------
    lo_doc_bcs = cl_document_bcs=>create_document(
                    i_type    = 'HTM'
                    i_text    = lt_text[]
*                      i_length  = '12'
                    i_subject = l_subject ).   "Subject of the Email


*---------------------------------------------------------------------
*-----------------&   Add attachment to document     *----------------
*---------------------------------------------------------------------
*     BCS expects document content here e.g. from document upload
*     binary_content = ...
*    CONCATENATE 'Pedido' object-key-purchaseorder INTO l_attach_name  SEPARATED BY space.

*    CALL METHOD lo_doc_bcs->add_attachment
*      EXPORTING
*        i_attachment_type    = 'PDF'
*        i_attachment_size    = lv_bin_filesize
*        i_attachment_subject = l_attach_name
*        i_att_content_hex    = lt_binary_content.
*
*     add document to send request
    CALL METHOD lo_bcs->set_document( lo_doc_bcs ).

*---------------------------------------------------------------------
*------------------------&   Set Sender     *-------------------------
*---------------------------------------------------------------------

    lo_sapuser_bcs = cl_sapuser_bcs=>create( c_sender ).
    CALL METHOD lo_bcs->set_sender
      EXPORTING
        i_sender = lo_sapuser_bcs.

    LOOP AT emails INTO DATA(s_mails).
      CLEAR lv_sendto.
      lv_sendto = s_mails.
      lo_recep = cl_cam_address_bcs=>create_internet_address( lv_sendto ).

      "Add recipient with its respective attributes to send request
      CALL METHOD lo_bcs->add_recipient
        EXPORTING
          i_recipient = lo_recep
          i_express   = 'X'.

    ENDLOOP.
*    CALL METHOD lo_bcs->set_send_immediately
*      EXPORTING
*        i_send_immediately = 'X'.

*---------------------------------------------------------------------
*-----------------&   Send the email    *-----------------------------
*---------------------------------------------------------------------
    CALL METHOD lo_bcs->send(
      EXPORTING
        i_with_error_screen = 'X'
      RECEIVING
        result              = lv_sent_to_all ).

    IF lv_sent_to_all IS NOT INITIAL.
      COMMIT WORK.
    ENDIF.
*---------------------------------------------------------------------
*-----------------&   Exception Handling     *------------------------
*---------------------------------------------------------------------
  CATCH cx_bcs INTO lo_cx_bcx.
    "Appropriate Exception Handling
    WRITE: 'Exception:', lo_cx_bcx->error_type.
ENDTRY.