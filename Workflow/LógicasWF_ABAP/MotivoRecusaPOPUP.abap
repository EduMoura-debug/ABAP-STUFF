DO.
    REFRESH it_comentario.
    CALL FUNCTION 'ZCATSXT_SIMPLE_TEXT_EDITOR'
      EXPORTING
        im_title = 'Comentário Aprovador'
      IMPORTING
        bt_code  = lv_okcode
      CHANGING
        ch_text  = it_comentario.
  
    IF it_comentario IS INITIAL OR lv_okcode = 'CX_CANC'.
  
      CALL FUNCTION 'EWB_POPUP_MESSAGE'
        EXPORTING
          messagetext1 = 'Por favor, preencha o comentário'
          titel        = 'Atenção'.
  
    ELSE.
      EXIT.
    ENDIF.
  ENDDO.