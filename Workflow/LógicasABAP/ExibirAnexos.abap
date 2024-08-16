FORM f_exibir_anexos USING p_wi_id.

  DATA: objkey      TYPE swotobjid-objkey,
        return_code TYPE sy-subrc,
        worklist    TYPE TABLE OF swr_wihdr,
        s_worklist  TYPE swr_wihdr.

  DATA: workitem_id LIKE swr_struct-workitemid.

  IF p_wi_id IS INITIAL. "Caso não exista workitem

    objkey = . "montar chave do objeto

    CALL FUNCTION 'SAP_WAPI_WORKITEMS_TO_OBJECT'
      EXPORTING
        objtype                  = 'ZBUS*****' "Nome do Objeto
        objkey                   = objkey      "Chave do Objeto
        selection_status_variant = 0000
      IMPORTING
        return_code              = return_code
      TABLES
        worklist                 = worklist.

    SORT worklist DESCENDING BY wi_crtts.
    READ TABLE worklist INTO s_worklist INDEX 1.
    workitem_id = s_worklist-wi_id.
  ELSE.
    workitem_id = p_wi_id.
  ENDIF.
  CALL FUNCTION 'SWL_WI_NOTES_DISPLAY'
    EXPORTING
      wi_id                         = workitem_id
*        CHANGING
*     workitem                      = workitem
    EXCEPTIONS
      container_does_not_exist      = 1
      no_notes_in_container         = 2
      wi_header_read_failed         = 3
      object_creation_failed        = 4
      method_calling_failed         = 5
      wi_buffer_refresh_failed      = 6
      container_manipulation_failed = 7
      dialog_failed                 = 8
      OTHERS                        = 9.
  IF sy-subrc <> 0.
*      MESSAGE ID sy-msgid TYPE 'W' NUMBER sy-msgno
*              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    MESSAGE 'Anexos não encontrado(s).' TYPE 'W'.
  ENDIF.


ENDFORM.                    " F_EXIBIR_ANEXOS