***********************************************************************
* NOME DO PROGRAMA    : ZEDU_ALVOO_EX03                               *
* TRANSAÇÃO           :                                               *
* TÍTULO DO PROGRAMA  : Exemplo 3 ALV OO                              *
* DESCRIÇÃO           : Report para alv OO editável                   *
* PROGRAMADOR         : Eduardo Freitas Moura (EMOURA)                *
* DATA                : 7.04.2022                                     *
***********************************************************************
REPORT zedu_alvoo_ex03.

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
         check TYPE flag,
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

"------DADOS ALV------"
DATA : lo_alv    TYPE REF TO cl_gui_alv_grid,
       lo_custom TYPE REF TO cl_gui_custom_container,

       it_fcat   TYPE lvc_t_fcat,
       wa_fcat   TYPE lvc_s_fcat,

       wa_layout TYPE lvc_s_layo.

"----------------OUTROS GLOBAIS------------------"



"-------------------CLASSES----------------------"
CLASS  handle_event DEFINITION.

   PUBLIC SECTION.
    CLASS-METHODS : handle_toolbar
                    FOR EVENT toolbar OF cl_gui_alv_grid
                    IMPORTING e_object
                              e_interactive.

    CLASS-METHODS : handle_user_command
                    FOR EVENT user_command OF cl_gui_alv_grid
                    IMPORTING e_ucomm.

ENDCLASS.

CLASS  handle_event IMPLEMENTATION.

  METHOD handle_toolbar.
    DATA : is_btn TYPE stb_button.

  "Botão de SAVE dentro do container do alv
    is_btn-function = 'SAVE'.
    is_btn-icon = icon_system_save.
    is_btn-text = 'SAVE'.
    is_btn-quickinfo = 'SAVE'.
    is_btn-disabled = ' '.
    APPEND is_btn TO e_object->mt_toolbar.

  ENDMETHOD.

  METHOD handle_user_command .
  "user_command da toolbar do alv dentro do container
    CASE e_ucomm.
      WHEN 'SAVE'.
*        PERFORM data_update.
        MESSAGE: 'SAVE' TYPE 'I'.
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
           zf_monta_layout,
           zf_monta_fcat.

  CALL SCREEN 100.

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
*& Form zf_monta_layout
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM zf_monta_layout .

*  wa_layout-col_opt = 'X'.
  wa_layout-zebra   = 'X'.
*  wa_layout-edit = 'X'. ” Todos os campos são editáveis

ENDFORM.


*&---------------------------------------------------------------------*
*& Form zf_monta_fcat
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM zf_monta_fcat .

*-------------------------------------*
  wa_fcat-col_pos = 0.
  wa_fcat-fieldname = 'CHECK'.
  wa_fcat-tabname = 'IT_SAIDA'.
  wa_fcat-scrtext_l = 'CHECK'.
  wa_fcat-checkbox = 'X'.
  wa_fcat-edit = 'X'.
  wa_fcat-outputlen = 5.
  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.
*-------------------------------------*
  wa_fcat-col_pos = 1 .
  wa_fcat-fieldname = 'EBELN'.
  wa_fcat-tabname = 'IT_SAIDA'.
  wa_fcat-scrtext_l = 'Pedido'.
  wa_fcat-key = 'X'.
  wa_fcat-outputlen = 10.
  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.
*-------------------------------------*
  wa_fcat-col_pos = 2 .
  wa_fcat-fieldname = 'EBELP'.
  wa_fcat-tabname = 'IT_SAIDA'.
  wa_fcat-scrtext_l = 'Item'.
  wa_fcat-key = 'X'.
  wa_fcat-outputlen = 10.
  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.
*-------------------------------------*
  wa_fcat-col_pos = 3 .
  wa_fcat-fieldname = 'MATNR'.
  wa_fcat-tabname = 'IT_SAIDA'.
  wa_fcat-scrtext_l = 'Material'.
  wa_fcat-edit = 'X'.
  wa_fcat-outputlen = 20.
  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.
*-------------------------------------*
  wa_fcat-col_pos = 4 .
  wa_fcat-fieldname = 'AEDAT'.
  wa_fcat-tabname = 'IT_SAIDA'.
  wa_fcat-scrtext_l = 'DATA'.
  wa_fcat-edit = 'X'.
  wa_fcat-outputlen = 10.
  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.
*-------------------------------------*
  wa_fcat-col_pos = 5 .
  wa_fcat-fieldname = 'LIFNR'.
  wa_fcat-tabname = 'IT_SAIDA'.
  wa_fcat-scrtext_l = 'Fornecedor'.
  wa_fcat-edit = 'X'.
  wa_fcat-outputlen = 15.
  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.
*-------------------------------------*
  wa_fcat-col_pos = 6 .
  wa_fcat-fieldname = 'BSART'.
  wa_fcat-tabname = 'IT_SAIDA'.
  wa_fcat-scrtext_l = 'Tipo Doc.'.
  wa_fcat-edit = 'X'.
  wa_fcat-outputlen = 10.
  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.
*-------------------------------------*
  wa_fcat-col_pos = 7 .
  wa_fcat-fieldname = 'BUKRS'.
  wa_fcat-tabname = 'IT_SAIDA'.
  wa_fcat-scrtext_l = 'Empresa'.
  wa_fcat-edit = 'X'.
  wa_fcat-outputlen = 15.
  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.
*-------------------------------------*
  wa_fcat-col_pos = 8 .
  wa_fcat-fieldname = 'BSTYP'.
  wa_fcat-tabname = 'IT_SAIDA'.
  wa_fcat-scrtext_l = 'Ctg. Doc.'.
  wa_fcat-edit = 'X'.
  wa_fcat-outputlen = 8.
  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.
*-------------------------------------*
  wa_fcat-col_pos = 9 .
  wa_fcat-fieldname = 'TXZ01'.
  wa_fcat-tabname = 'IT_SAIDA'.
  wa_fcat-scrtext_l = 'Desc. Breve'.
  wa_fcat-edit = 'X'.
  wa_fcat-outputlen = 40.
  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.
*-------------------------------------*
  wa_fcat-col_pos = 10 .
  wa_fcat-fieldname = 'MATKL'.
  wa_fcat-tabname = 'IT_SAIDA'.
  wa_fcat-scrtext_l = 'Grp. Merc'.
  wa_fcat-edit = 'X'.
  wa_fcat-outputlen = 15.
  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.
*-------------------------------------*
  wa_fcat-col_pos = 11 .
  wa_fcat-fieldname = 'MENGE'.
  wa_fcat-tabname = 'IT_SAIDA'.
  wa_fcat-scrtext_l = 'Quantidade'.
  wa_fcat-edit = 'X'.
  wa_fcat-outputlen = 20.
  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.
*-------------------------------------*
  wa_fcat-col_pos = 12 .
  wa_fcat-fieldname = 'MEINS'.
  wa_fcat-tabname = 'IT_SAIDA'.
  wa_fcat-scrtext_l = 'Unidade'.
  wa_fcat-outputlen = 8.
  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.
*-------------------------------------*

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

  IF lo_custom IS NOT BOUND.
    CREATE OBJECT lo_custom
      EXPORTING
        container_name = 'CT1'.
  ENDIF.

  IF lo_alv IS NOT BOUND.
    CREATE OBJECT lo_alv
      EXPORTING
        i_parent = lo_custom.

    SET HANDLER handle_event=>handle_toolbar      FOR lo_alv.
    SET HANDLER handle_event=>handle_user_command FOR lo_alv.

    CALL METHOD lo_alv->set_ready_for_input
      EXPORTING
        i_ready_for_input = 0.


    CALL METHOD lo_alv->set_table_for_first_display
      EXPORTING
        is_layout       = wa_layout
      CHANGING
        it_outtab       = it_saida
        it_fieldcatalog = it_fcat.

    CALL METHOD lo_alv->set_toolbar_interactive.
    CALL METHOD lo_alv->refresh_table_display.
  ENDIF.

ENDFORM.


*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'ZSTATUS'.
* SET TITLEBAR 'xxx'.

  PERFORM zf_display_alv.

ENDMODULE.

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE sy-ucomm.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
    WHEN 'CANCEL'.
      LEAVE PROGRAM.
    WHEN 'EDIT'.
      PERFORM switch_edit_mode.
    WHEN 'SAVE'.
*      PERFORM data_update.
    WHEN OTHERS.
  ENDCASE.

ENDMODULE.


*&---------------------------------------------------------------------*
*&      Form  SWITCH_EDIT_MODE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM switch_edit_mode.

  IF lo_alv->is_ready_for_input( ) EQ 0.
    CALL METHOD lo_alv->set_ready_for_input
      EXPORTING
        i_ready_for_input = 1.

  ELSE.
    CALL METHOD lo_alv->set_ready_for_input
      EXPORTING
        i_ready_for_input = 0.
  ENDIF.

ENDFORM.                               " SWITCH_EDIT_MODE