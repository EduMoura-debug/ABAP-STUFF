*&---------------------------------------------------------------------*
*&      Form  F_CHAMAR_WF_REPROVAR_TARIFA
*&---------------------------------------------------------------------*
FORM f_chamar_wf_reprovar_tarifa.

    gv_objtype      = 'ZBUSXXXX'. "Business Object
    gv_decision_key = '0002'. "Reprovar
  
    LOOP AT lt_registro INTO ls_registro.
  
      REFRESH: gt_worklist, gt_items_worklist, gt_message_lines, gt_message_struct.
      CLEAR: gv_objkey, gv_workitem_id, gv_return_object, gv_return_complete.
  
      IF ls_registro-wi_id IS NOT INITIAL.
        gv_workitem_id = ls_registro-wi_id. "wi_id é o workitem pai
      ELSE.
        CONTINUE.
      ENDIF.
  
      PERFORM f_trata_worklist. "Atualizar gv_workitem_id para o mais workitem mais recente
  
      IF gv_workitem_id IS NOT INITIAL.
  
        CALL FUNCTION 'SAP_WAPI_DECISION_COMPLETE'
          EXPORTING
            workitem_id    = gv_workitem_id
            language       = sy-langu
            user           = 'WF-BATCH'
            decision_key   = gv_decision_key
          IMPORTING
            return_code    = gv_return_complete
          TABLES
            message_lines  = gt_message_lines
            message_struct = gt_message_struct.
  
        IF gv_return_complete IS INITIAL.
**** Atualizar tabela REPROVAÇÃO
  
*        CLEAR lv_mensagem.
*        MESSAGE e003(zwf) INTO lv_mensagem.
*
*        UPDATE zsdt_avk11 SET msgerro = lv_mensagem
*                  WHERE numdoc = ls_registro-numdoc.
*
* Eliminar Registros já aprovados da visão do relatório.
          DELETE gt_saida WHERE numdoc EQ ls_registro-numdoc AND nomtab EQ ls_registro-nomtab AND wi_id EQ ls_registro-wi_id.
***
          COMMIT WORK AND WAIT.
  
        ELSE.
*     Falha na função de decisão para reprovação - Analisar Log
  
          CLEAR s_message_struct.
          READ TABLE gt_message_struct INTO s_message_struct INDEX 1.
          CALL FUNCTION 'BALW_BAPIRETURN_GET2'
            EXPORTING
              type   = s_message_struct-msgty
              cl     = s_message_struct-msgid
              number = s_message_struct-msgno
              par1   = s_message_struct-msgv1
              par2   = s_message_struct-msgv2
              par3   = s_message_struct-msgv3
              par4   = s_message_struct-msgv4
            IMPORTING
              return = s_return.
          APPEND s_return TO t_return.
          CLEAR s_return.
  
        ENDIF.
      ELSE. "Não encontrou workitem de decisão.
  
        CLEAR s_message_struct.
        READ TABLE gt_message_struct INTO s_message_struct INDEX 1.
        CALL FUNCTION 'BALW_BAPIRETURN_GET2'
          EXPORTING
            type   = s_message_struct-msgty
            cl     = s_message_struct-msgid
            number = s_message_struct-msgno
            par1   = s_message_struct-msgv1
            par2   = s_message_struct-msgv2
            par3   = s_message_struct-msgv3
            par4   = s_message_struct-msgv4
          IMPORTING
            return = s_return.
        APPEND s_return TO t_return.
        CLEAR s_return.
      ENDIF.
    ENDLOOP.
  
  ENDFORM.                    " F_CHAMAR_WF_REPROVAR_TARIFA