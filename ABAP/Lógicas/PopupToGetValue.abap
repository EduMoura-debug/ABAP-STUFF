DATA : t_sval TYPE TABLE OF  sval,
       s_sval TYPE sval.

s_sval-tabname   = 'KNA1'.  " Find a table which has type I field
s_sval-fieldname = 'KUNNR'. " Pass the Field here
APPEND s_sval TO t_sval.

CALL FUNCTION 'POPUP_GET_VALUES'
  EXPORTING
*   NO_VALUE_CHECK  = ' '
    popup_title     = 'Entre um valor'
    start_column    = '5'
    start_row       = '5'
*  IMPORTING
*    returncode      = 
  TABLES
    fields          = t_sval
  EXCEPTIONS
    error_in_fields = 1
    OTHERS          = 2.

READ TABLE t_sval INTO s_sval INDEX 1.
IF sy-subrc EQ 0.
  l_value = s_sval-value.
ENDIF.
