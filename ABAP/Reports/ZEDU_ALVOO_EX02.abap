***********************************************************************
* NOME DO PROGRAMA    : ZEDU_ALVOO_EX02                               *
* TRANSAÇÃO           :                                               *
* TÍTULO DO PROGRAMA  : Exemplo 2 ALV OO                              *
* DESCRIÇÃO           : Teste com botões e eventos                    *
* PROGRAMADOR         : Eduardo Freitas Moura (EMOURA)                *
* DATA                : 07.04.2022                                    *
***********************************************************************
REPORT zedu_alvoo_ex02.

TABLES: ekko, ekpo.

"---------------------TIPOS----------------------"
TYPES: BEGIN OF tp_saida,
         ebeln TYPE ekko-ebeln,
         ebelp TYPE ekpo-ebelp,
         matnr TYPE ekpo-matnr,
         aedat TYPE ekko-aedat,
         lifnr TYPE ekko-lifnr,
         bsart TYPE ekko-bsart,
         bukrs TYPE ekko-bukrs,
         bstyp TYPE ekko-bstyp,
         txz01 TYPE ekpo-txz01,
         matkl TYPE ekpo-matkl,
         menge TYPE ekpo-menge,
         meins TYPE ekpo-meins,
         cell  TYPE lvc_t_STYL,
       END OF tp_saida,

       BEGIN OF tp_pedido,
         ebeln TYPE ekko-ebeln,
         bsart TYPE ekko-bsart,
         aedat TYPE ekko-aedat,
         bukrs TYPE ekko-bukrs,
         lifnr TYPE ekko-lifnr,
         bstyp TYPE ekko-bstyp,
       END OF tp_pedido,

       BEGIN OF tp_item,
         ebeln TYPE ekpo-ebeln,
         ebelp TYPE ekpo-ebelp,
         matnr TYPE ekpo-matnr,
         txz01 TYPE ekpo-txz01,
         matkl TYPE ekpo-matkl,
         menge TYPE ekpo-menge,
         meins TYPE ekpo-meins,
       END OF tp_item.

"--------------TABELAS E ESTRUTURAS--------------"
"-----DADOS SELECT-----"
DATA: it_pedido TYPE TABLE OF tp_pedido,
      it_item   TYPE TABLE OF tp_item,
      it_saida  TYPE TABLE OF tp_saida,

      wa_pedido TYPE tp_pedido,
      wa_item   TYPE tp_item,
      wa_saida  TYPE tp_saida.

"-------OBJETOS-------"
DATA : gr_table TYPE REF TO cl_salv_table, "ESSE TIPO DE CLASSE DE ALV NÃO PODE SER EDITADA
       events   TYPE REF TO cl_salv_events_table.

"----------------OUTROS GLOBAIS------------------"



"-------------------CLASSES----------------------"
CLASS lcl_alv_handler DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS: handle_click FOR EVENT double_click OF cl_salv_events_table
      IMPORTING row column.

    CLASS-METHODS: added_function FOR EVENT added_function OF cl_salv_events_table
      IMPORTING e_salv_function.
ENDCLASS.

CLASS lcl_alv_handler IMPLEMENTATION.
  METHOD handle_click.

    READ TABLE it_saida INDEX row INTO wa_saida.

    IF column = 'EBELN'.
      DATA: id_pedido1 TYPE ekko-ebeln.

      id_pedido1 = sy-lisel+2(10).
      SET PARAMETER ID 'BES' FIELD id_pedido1. "VRT se K
      CALL TRANSACTION 'ME23N' AND SKIP FIRST SCREEN. "ME33K

    ENDIF.
  ENDMETHOD.

  METHOD added_function.
    MESSAGE e_salv_function TYPE 'I'.

    CASE e_salv_function.
      WHEN 'EDIT'.

        PERFORM zf_edit_alv.

*        IF ls_layout-edit = 'X'.
*          ls_layout-edit = ''.
*        ELSE.
*          ls_layout-edit = 'X'.
*        ENDIF.

      WHEN 'ADD'.

        APPEND wa_saida TO it_saida.
        gr_table->refresh( ).

      WHEN 'DEL'.

        DELETE it_saida INDEX 1.
        gr_table->refresh( ).

      WHEN '&SAVE_DATA' OR 'SAVE'.
        DATA: rows TYPE salv_t_row,
              row  TYPE i.

        rows = gr_table->get_selections( )->get_selected_rows( ).
        READ TABLE rows INTO row INDEX 1.
        READ TABLE it_saida INTO wa_saida INDEX row.

        MODIFY it_saida FROM wa_saida INDEX row.
        gr_table->refresh( ).

    ENDCASE.
  ENDMETHOD.

ENDCLASS.


"-----------------TELA DE SELEÇÂO-----------------"
SELECTION-SCREEN: BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-001.

  SELECT-OPTIONS: s_nump  FOR ekko-ebeln,
                  s_forn  FOR ekko-lifnr.

SELECTION-SCREEN: END OF BLOCK b01.


"----------------VALIDAÇÃO DE TELA----------------"

AT SELECTION-SCREEN.
  IF s_nump AND s_forn IS INITIAL.
    MESSAGE e002(zcm_efmoura).
  ENDIF.



  "----------------INICIO_DA_SELEÇÃO----------------"

START-OF-SELECTION.

  PERFORM: zf_select_dados,
           zf_preenche_saida,
           zf_monta_alv,
           zf_display_alv.


*&---------------------------------------------------------------------*
*& Form zf_select_dados
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM zf_select_dados .

  SELECT ekko~ebeln
         ekko~bsart
         ekko~aedat
         ekko~bukrs
         ekko~lifnr
         ekko~bstyp
  FROM ekko
  INTO TABLE it_pedido[]
  WHERE ekko~ebeln IN s_nump AND ekko~lifnr IN s_forn.

  IF sy-subrc = 0.
    SELECT
          ekpo~ebeln
          ekpo~ebelp
          ekpo~matnr
          ekpo~txz01
          ekpo~matkl
          ekpo~menge
          ekpo~meins
    FROM ekpo
    INTO TABLE it_item[]
    FOR ALL ENTRIES IN it_pedido
    WHERE ebeln = it_pedido-ebeln.

  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form zf_preenche_saída
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM zf_preenche_saida .

  IF it_item[] IS INITIAL.
    MESSAGE e001(zcm_efmoura).
  ELSE.

    SORT it_item ASCENDING BY ebeln ebelp.
    DELETE it_item WHERE matnr IS INITIAL.

    LOOP AT it_item INTO wa_item.

      READ TABLE it_pedido INTO wa_pedido  WITH KEY ebeln = wa_item-ebeln.

      wa_saida-ebeln = wa_pedido-ebeln.
      wa_saida-bsart = wa_pedido-bsart.
      wa_saida-aedat = wa_pedido-aedat.
      wa_saida-bukrs = wa_pedido-bukrs.
      wa_saida-lifnr = wa_pedido-lifnr.
      wa_saida-bstyp = wa_pedido-bstyp.
      wa_saida-ebelp = wa_item-ebelp.
      wa_saida-matnr = wa_item-matnr.
      wa_saida-txz01 = wa_item-txz01.
      wa_saida-matkl = wa_item-matkl.
      wa_saida-menge = wa_item-menge.
      wa_saida-meins = wa_item-meins.

      APPEND wa_saida TO it_saida.
      CLEAR : wa_saida.
    ENDLOOP.
  ENDIF.

  SORT it_saida ASCENDING BY ebeln ebelp.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form zf_monta_alv
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM zf_monta_alv .

  TRY.
      cl_salv_table=>factory(  IMPORTING    r_salv_table = gr_table
                               CHANGING     t_table      = it_saida ).


*      PERFORM zf_layout_def.

    CATCH cx_salv_msg.
  ENDTRY.

  gr_table->set_screen_status(
    EXPORTING
      report        = sy-repid
      pfstatus      = 'ZSTATUS2'
      set_functions = cl_salv_table=>c_functions_all ).


  events = gr_table->get_event( ).
  SET HANDLER  lcl_alv_handler=>handle_click FOR events.
  SET HANDLER  lcl_alv_handler=>added_function FOR events.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form zf_display_alv
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM zf_display_alv .

  gr_table->display( ).

ENDFORM.


*&---------------------------------------------------------------------*
*& Form zf_layout_def
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM zf_layout_def .  "Não funciona com STATUS GUI

*  DATA layout_settings TYPE REF TO cl_salv_layout.
*  DATA layout_key      TYPE salv_s_layout_key.
*
*  layout_settings = gr_table->get_layout( ).
*
*  layout_key-report = sy-repid.
*  layout_settings->set_key( layout_key ).
*
*  layout_settings->set_save_restriction( if_salv_c_layout=>restrict_none ).

ENDFORM.


*&---------------------------------------------------------------------*
*& Form zf_edit_alv
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM zf_edit_alv .

*  IF gr_table->is_ready_for_input( ) EQ 0.
*    CALL METHOD gr_table->set_ready_for_input
*      EXPORTING
*        i_ready_for_input = 1.
*
*  ELSE.
*    CALL METHOD gr_table->set_ready_for_input
*      EXPORTING
*        i_ready_for_input = 0.
*  ENDIF.

ENDFORM.