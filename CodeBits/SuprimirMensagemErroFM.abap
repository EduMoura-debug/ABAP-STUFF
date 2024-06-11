DO 5 TIMES.

  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      id       = lv_id
      language = sy-langu
      name     = lv_name
      object   = 'VBBK'
    TABLES
      lines    = it_texto_ordem "tabela de textos

"""""" Essa exceção faz com que qualquer erro da READ_TEXT se converta em sy-subrc = 0 
      EXCEPTIONS
        ERROR_MESSAGE = 4. 
""""""


  IF it_texto_ordem IS INITIAL.
    WAIT UP TO 5 SECONDS.
    ELSE.
      EXIT.
    ENDIF.

ENDDO.