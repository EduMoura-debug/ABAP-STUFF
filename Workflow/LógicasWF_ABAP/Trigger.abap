
DATA: lv_objkey TYPE swoobjkey,
      lv_event_id TYPE sweeventid,
      lt_return TYPE STANDARD TABLE OF bapiret2.

FORM zf_trigger
  USING iv_objtype TYPE swoobjtype
        iv_event   TYPE sweeventid
        iv_objkey  TYPE swoobjkey
  CHANGING
    cv_event_id TYPE sweeventid.

  CALL FUNCTION 'SAP_WAPI_CREATE_EVENT'
    EXPORTING
      object_type             = iv_objtype 
      object_key              = iv_objkey  
      event                   = iv_event   
      commit_work             = 'X'        
      security_check          = ' '        
    IMPORTING
      event_id                = cv_event_id 
    TABLES
      message_lines           = lt_return  
    EXCEPTIONS
      event_unknown           = 1
      objtype_unknown         = 2
      no_times_for_event      = 3
      OTHERS                  = 4.

  IF sy-subrc = 0.
    MESSAGE 'Workflow disparado. ID Evento:' && cv_event_id TYPE 'S'.
  ELSE.
* Tratar erros da BAPI
    
  ENDIF.

ENDFORM. " zf_trigger