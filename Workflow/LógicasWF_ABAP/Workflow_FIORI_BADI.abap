* Busca de validação e justificativa pelo FIORI... BADI: /IWWRK/BADI_WF_BEFORE_UPD_IB

METHOD /iwwrk/if_wf_wi_before_upd_ib~before_update.

    DATA: ls_object    TYPE swr_obj_2.
    DATA: lw_container TYPE TABLE OF swr_cont.
    DATA: ls_container TYPE swr_cont.

    DATA: ls_wf_container TYPE swr_cont.

    DATA: lt_lines TYPE trtexts.
    DATA  ls_lines LIKE LINE OF lt_lines.

    DATA: l_numero TYPE i.

    DATA ls_formabs    TYPE swxformabs.
    DATA lv_formnumber TYPE swxformabs-formnumber.

    CALL FUNCTION 'SAP_WAPI_GET_OBJECTS'
      EXPORTING
        workitem_id      = is_wi_details-wi_id
      IMPORTING
        leading_object_2 = ls_object.

    MOVE ls_object-instid TO lv_formnumber.

    CALL FUNCTION 'SAP_WAPI_READ_CONTAINER'
      EXPORTING
        workitem_id      = is_wi_details-wi_id
      TABLES
        simple_container = lw_container.

    SELECT SINGLE * FROM swxformabs INTO ls_formabs WHERE formnumber = lv_formnumber.

    CASE iv_decision_key.
      WHEN 0001. "Aprovado
        ls_container-value = '0001'.
        ls_formabs-procstate = 'A'.
      WHEN 0002.
        ls_container-value = '0002'.
        ls_formabs-procstate = 'R'.
    ENDCASE.

    MODIFY lw_container FROM ls_container TRANSPORTING value WHERE element = '_WI_RESULT'.

    IF iv_decision_key EQ '0002'.

      READ TABLE it_wf_container_tab INTO ls_wf_container WITH KEY element = 'ACTION_COMMENTS'.

      IF ls_wf_container-value IS NOT INITIAL.

        CLEAR ls_container.

        READ TABLE lw_container INTO ls_container WITH KEY element = 'FIORI'.

        IF sy-subrc = 0.

          ls_container-value = abap_true.
          MODIFY lw_container FROM ls_container TRANSPORTING value WHERE element = 'FIORI'.

        ELSE.

          ls_container-element = 'Fiori'.
          ls_container-value = abap_true.
          APPEND ls_container TO lw_container.

        ENDIF.

        CALL FUNCTION 'TR_SPLIT_TEXT'
          EXPORTING
            iv_text  = ls_wf_container-value
            iv_len   = 72
          IMPORTING
            et_lines = lt_lines.

        CLEAR ls_container.

        READ TABLE lw_container INTO ls_container WITH KEY element = 'Justificativa_fiori'.

        IF sy-subrc = 0.

          LOOP AT lt_lines INTO ls_lines.

            IF sy-tabix EQ 1.

              ls_container-value = ls_lines.
              MODIFY lw_container FROM ls_container TRANSPORTING value WHERE element = 'Justificativa_fiori'.

            ELSE.

              ls_container-element = 'Justificativa_fiori'.
              ls_container-value = ls_lines.
              APPEND ls_container TO lw_container.

            ENDIF.

          ENDLOOP.

        ELSE.

          LOOP AT lt_lines INTO ls_lines.

            ls_container-element = 'Justificativa_fiori'.
            ls_container-value = ls_lines.
            APPEND ls_container TO lw_container.

          ENDLOOP.

        ENDIF.

      ENDIF.

    ENDIF.

    CALL FUNCTION 'SAP_WAPI_WRITE_CONTAINER'
      EXPORTING
        workitem_id      = is_wi_details-wi_id
      TABLES
        simple_container = lw_container.

    CALL FUNCTION 'SAP_WAPI_WORKITEM_CONFIRM'
      EXPORTING
        workitem_id = is_wi_details-wi_id
        do_commit   = 'X'.

  ENDMETHOD.
