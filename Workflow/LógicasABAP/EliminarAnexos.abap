*&---------------------------------------------------------------------*
*&      Form  F_ELIMINAR_ARQUIVO_WF
*&---------------------------------------------------------------------*
FORM f_eliminar_arquivo_wf .

    DATA: lt_attachments TYPE TABLE OF swr_object,
          gs_object_ref  TYPE swotobjid.
  
    LOOP AT lt_registro INTO ls_registro.
  
      REFRESH: gt_message_lines, gt_message_struct, gt_items_worklist.
      CLEAR: gv_return_code, gv_workitem_id.
  
      IF ls_registro-wi_id IS NOT INITIAL.
        gv_workitem_id = ls_registro-wi_id.
      ELSE.
        CONTINUE.
      ENDIF.
  
      IF gv_workitem_id IS NOT INITIAL.
  
        PERFORM f_trata_worklist. "Atualizar gv_workitem_id para o mais workitem de decisão mais recente
  
        CALL FUNCTION 'SAP_WAPI_GET_ATTACHMENTS'
          EXPORTING
            workitem_id    = gv_workitem_id
            user           = sy-uname
          IMPORTING
            return_code    = gv_return_code
          TABLES
            attachments    = lt_attachments
            message_lines  = gt_message_lines
            message_struct = gt_message_struct.
  
        IF gv_return_code IS INITIAL.
  
          LOOP AT lt_attachments INTO DATA(ls_attach).
  
            CLEAR: gs_att_id, gv_return_code.
            CONDENSE ls_attach-object_id.
            gs_att_id-doc_id = ls_attach-object_id+5.
  
*  Deletar os Anexos dessa Etapa de Decisão
            CALL FUNCTION 'SAP_WAPI_ATTACHMENT_DELETE'
              EXPORTING
                workitem_id     = gv_workitem_id
                att_id          = gs_att_id
                do_commit       = 'X'
                delete_document = 'X'
              IMPORTING
                return_code     = gv_return_code
              TABLES
                message_lines   = gt_message_lines
                message_struct  = gt_message_struct.
            IF gv_return_code IS NOT INITIAL.
*          Limpar Container de Attachments
*          ( Anexo inserido em outra etapa por provavelmente outra pessoa)
  
              CLEAR gs_object_ref.
              gs_object_ref-objtype = 'SOFM'.
              gs_object_ref-objkey  = gs_att_id-doc_id.
  
              CALL FUNCTION 'SWW_WI_OBJECTHANDLE_DELETE'
                EXPORTING
                  wi_id         = gv_workitem_id
                  object_id     = gs_object_ref
*               element_name  = '_Attach_Objects'
                  do_commit     = 'X'
*               object_handle = object_handle
*             CHANGING
*               WI_HEADER     = ' '
*               WI_CONTAINER_HANDLE       =
                EXCEPTIONS
                  delete_failed = 1
                  OTHERS        = 2.
  
            ENDIF.
          ENDLOOP.
        ENDIF.
      ELSE.
        "Não achou anexos
      ENDIF.
    ENDLOOP.
  
  ENDFORM.                    " F_ELIMINAR_ARQUIVO_WF