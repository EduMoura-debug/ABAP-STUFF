
* Criar uma classe com a interface IF_SWF_IFS_WORKITEM_EXIT para ser colocada como exit de programação na tarefa

METHOD if_swf_ifs_workitem_exit~event_raised.

    DATA: re_cont          TYPE REF TO if_swf_ifs_parameter_container,

          lv_wi            TYPE sww_wiid,
          lv_purchaseorder TYPE ebeln,
          lv_releasecode   TYPE t16fc-frgco.

    IF sy-tcode EQ 'SBWP'.

      TRY.
          re_cont = im_workitem_context->get_wi_container( ).
*      re_cont->get( EXPORTING name = '_WI_RESULT' IMPORTING value = v_result ).
          re_cont->get( EXPORTING name = 'ID_PEDIDO' IMPORTING value = lv_purchaseorder ).
          re_cont->get( EXPORTING name = 'REL_CODE' IMPORTING value = lv_releasecode ).
        CATCH cx_swf_cnt_cont_access_denied.
        CATCH cx_swf_cnt_elem_access_denied.
        CATCH cx_swf_cnt_elem_not_found.
        CATCH cx_swf_cnt_elem_type_conflict.
        CATCH cx_swf_cnt_unit_type_conflict.
        CATCH cx_swf_cnt_elem_def_invalid.
        CATCH cx_swf_cnt_container.
      ENDTRY.

      CASE im_event_name .

        WHEN 'AFT_EXEC'.
          TRY.
              lv_wi = im_workitem_context->get_workitem_id( ).

              CALL METHOD zvalida_purchaseorder "Método privado de bloqueio
                EXPORTING
                  wi            = lv_wi
                  purchaseorder = lv_purchaseorder
                  releasecode   = lv_releasecode.

            CATCH cx_swf_ifs_workitem_exit_error.
          ENDTRY.
      ENDCASE.
    ENDIF.

  ENDMETHOD.


METHOD zvalida_purchaseorder.

    DATA: lv_message TYPE string.

*---------------------------------------------------------------------
*----------------& Checar se PO está bloqueado *----------------------
*---------------------------------------------------------------------

    CALL FUNCTION 'ENQUEUE_EMEKKOE' "ENQUEUE_READ "ENQUEUE_EMEBANE "ENQUEUE_EFBKPF
      EXPORTING
        ebeln          = purchaseorder
      EXCEPTIONS
        foreign_lock   = 1
        system_failure = 2
        OTHERS         = 3.
    IF sy-subrc <> 0.
      IF sy-subrc EQ 1.
        CLEAR lv_message.
        CONCATENATE 'Usuário' sy-msgv1 'já está processando o pedido' purchaseorder
               INTO lv_message SEPARATED BY space.
*        MESSAGE lv_message TYPE 'E' DISPLAY LIKE 'I'.
*        MESSAGE ID 'ME' TYPE 'E' NUMBER '006'
*         WITH sy-msgv1 DISPLAY LIKE 'I'.
      ELSE.
        CLEAR lv_message.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4
              INTO lv_message.
*        MESSAGE lv_message TYPE 'E' DISPLAY LIKE 'I'.
      ENDIF.
    ENDIF.

    CALL FUNCTION 'DEQUEUE_EMEKKOE' "DEQUEUE_EMEBANE "DEQUEUE_EFBKPF
      EXPORTING
        ebeln = purchaseorder.

    IF lv_message IS NOT INITIAL.
      MESSAGE lv_message TYPE 'E' DISPLAY LIKE 'I'.
    ENDIF.

*---------------------------------------------------------------------
*----------------------& Outras Validações *--------------------------
*---------------------------------------------------------------------
*
*
*



  ENDMETHOD.