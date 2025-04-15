FORM executalog USING p_wi_id.

    DATA: objkey      TYPE swotobjid-objkey,
          return_code TYPE sy-subrc,
          worklist    TYPE TABLE OF swr_wihdr,
          s_worklist  TYPE swr_wihdr.
  
    IF p_wi_id IS INITIAL.
  
      objkey = . "monta chave do objeto
  
      CALL FUNCTION 'SAP_WAPI_WORKITEMS_TO_OBJECT'
        EXPORTING
          objtype                  = 'ZBUS******' "Objeto
          objkey                   = objkey "Chave do Objeto
          selection_status_variant = 0000
        IMPORTING
          return_code              = return_code
        TABLES
          worklist                 = worklist.
  
  
      READ TABLE worklist INTO s_worklist INDEX 1.
  
    ELSE.
      s_worklist-wi_id = p_wi_id.
    ENDIF.
  
  ** Apresenta LOG como na SWIA
    CALL FUNCTION 'SWL_WI_DISPATCH'
      EXPORTING
        wi_id                    = s_worklist-wi_id
        wi_first_time            = 'X'
        wi_function              = 'WIFI'
      EXCEPTIONS
        function_cancelled       = 1
        function_not_implemented = 2
        function_failed          = 3
        OTHERS                   = 4.
    IF sy-subrc <> 0.
  *      MESSAGE ID sy-msgid TYPE 'W' NUMBER sy-msgno
  *              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      MESSAGE 'Log não encontrado.' TYPE 'W'.
    ENDIF.
  
  ENDFORM.                    " EXECUTALOG