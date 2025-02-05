  DEFINE ADD_MSG.
    LS_RETURN-TYPE = &1.
    LS_RETURN-ID = &2.
    LS_RETURN-NUMBER = &3.
    LS_RETURN-MESSAGE_V1 = &4.
    LS_RETURN-MESSAGE_V2 = &5.
    LS_RETURN-MESSAGE_V3 = &6.
    LS_RETURN-MESSAGE_V4 = &7.
    MESSAGE ID LS_RETURN-ID TYPE LS_RETURN-TYPE NUMBER LS_RETURN-NUMBER WITH LS_RETURN-MESSAGE_V1 LS_RETURN-MESSAGE_V2 LS_RETURN-MESSAGE_V3 LS_RETURN-MESSAGE_V4 INTO LS_RETURN-MESSAGE.
    APPEND LS_RETURN TO RETURN.
  END-OF-DEFINITION.

ADD_MSG 'W' 'ZBCMAILSEND_MESSAGES' 001 '' '' '' ''.

* CLASSES IMPORTANTES *.

"Exibe uma tabela bapiret2 em popup
cl_rmsl_message=>display( it_return )

"Preenche uma estrutura bapiret2 com uma mensagem
CALL FUNCTION 'BALW_BAPIRETURN_GET2' 
        EXPORTING
          type   = 'E'
          cl     = 'ZSD'
          number = 102
          par1   = ''
          par2   = ''
          par3   = ''
          par4   = ''
        IMPORTING
          return = E_RETURN.


      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno 
         WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4
         INTO lv_message.