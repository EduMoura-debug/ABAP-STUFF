***********************************************************************
* NOME DO PROGRAMA    : ZEDU_ALVOO_EX01                               *
* TRANSAÇÃO           :                                               *
* TÍTULO DO PROGRAMA  : Exemplo 1 ALV OO                              *
* DESCRIÇÃO           : Report para exemplo prático e aprendizado     *
* PROGRAMADOR         : Eduardo Freitas Moura (EMOURA)                *
* DATA                : 30.03.2022                                    *
***********************************************************************
REPORT zedu_alvoo_ex01.

DATA : gr_table TYPE REF TO cl_salv_table,
       events   TYPE REF TO cl_salv_events_table,
       it_mara  TYPE TABLE OF mara,
       wa_mara  TYPE mara.

CLASS lcl_alv_handler DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS: handle_click FOR EVENT double_click OF cl_salv_events_table
      IMPORTING row column.

    CLASS-METHODS: added_function FOR EVENT added_function OF cl_salv_events_table
      IMPORTING e_salv_function.
ENDCLASS.

CLASS lcl_alv_handler IMPLEMENTATION.
  METHOD handle_click.
*    MESSAGE sy-ucomm TYPE 'I'.
    READ TABLE it_mara INDEX row INTO wa_mara.
    DATA: msg TYPE string.

    IF column = 'MATNR'.
      msg = 'Selecionou MATNR' && '-->' && wa_mara-matnr.
      MESSAGE msg TYPE 'I'.
    ENDIF.
  ENDMETHOD.

  METHOD added_function.
    IF e_salv_function = '&VIEW'.
    MESSAGE e_salv_function TYPE 'I'.
    ENDIF.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.

  SELECT *
    FROM mara
    INTO TABLE it_mara
    UP TO 100 ROWS.

  TRY.
      cl_salv_table=>factory(  IMPORTING    r_salv_table = gr_table
                               CHANGING     t_table      = it_mara ).
    CATCH cx_salv_msg.
  ENDTRY.

  gr_table->set_screen_status(  "Definir o PFSTATUS
    EXPORTING
      report        = sy-repid
      pfstatus      = 'ZSTATUS'
      set_functions = cl_salv_table=>c_functions_all ).


  events = gr_table->get_event( ).
  SET HANDLER  lcl_alv_handler=>handle_click FOR events.
  SET HANDLER  lcl_alv_handler=>added_function FOR events.

  gr_table->display( ).