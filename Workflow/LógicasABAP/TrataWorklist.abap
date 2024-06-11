*&---------------------------------------------------------------------*
*&      Form  F_TRATA_WORKLIST
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_trata_worklist .

  CALL FUNCTION 'SAP_WAPI_GET_DEPENDENT_WIS'
    EXPORTING
      workitem_id    = gv_workitem_id
    TABLES
      items          = gt_items_worklist
      message_lines  = gt_message_lines
      message_struct = gt_message_struct.

* Buscar o workitem de aprovação mais recente
* DELETE gt_items_worklist WHERE wi_rh_task NE 'TS*'. "Caso precise de uma TAREFA especifica 
  SORT gt_items_worklist DESCENDING BY wi_crtts.
  READ TABLE gt_items_worklist INTO DATA(ls_items) INDEX 1.

  CLEAR gv_workitem_id.
  gv_workitem_id = ls_items-wi_id. "Atualizar com o workitem da tarefa de decisão

ENDFORM.                    " F_TRATA_WORKLIST