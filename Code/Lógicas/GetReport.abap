DATA: t_relatorio     TYPE TABLE OF tp_relatorio,
      lt_selscreen     TYPE TABLE OF rsparams,
      wa_selscreen     TYPE rsparams.

FIELD-SYMBOLS <lt_data>   TYPE ANY TABLE.
DATA lr_data              TYPE REF TO data.

*Buscar dados relatório
cl_salv_bs_runtime_info=>set(
    EXPORTING display  = abap_false
              metadata = abap_false
              data     = abap_true ).

* Executa o relatório e importa a tabela de saida
  SUBMIT zreport
    WITH SELECTION-TABLE lt_selscreen
    AND RETURN.
  TRY.
      cl_salv_bs_runtime_info=>get_data_ref(
        IMPORTING r_data = lr_data ).
      ASSIGN lr_data->* TO <lt_data>.
    CATCH cx_salv_bs_sc_runtime_info.
      MESSAGE 'Não é possível recuperar os dados do relatório' TYPE 'E'.

  ENDTRY.

  IF <lt_data> IS ASSIGNED.
    MOVE-CORRESPONDING <lt_data> TO t_relatorio.
    UNASSIGN <lt_data>.
  ENDIF.

  cl_salv_bs_runtime_info=>clear_all( ).