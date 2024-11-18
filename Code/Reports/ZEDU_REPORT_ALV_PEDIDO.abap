************************************************************************
* NOME DO PROGRAMA    :  ZEDU_REPORT_ALV_PEDIDO                        *
* TRANSAÇÃO           :                                                *
* TÍTULO DO PROGRAMA  : Report ALV de pedidos                          *
* DESCRIÇÃO           : Refazer o relatório de pedidos usando ALV      *
* PROGRAMADOR         : Eduardo Freitas Moura (EFREITAS)               *
* DATA                : 14.02.2022                                     *
************************************************************************
REPORT zedu_report_alv_pedido MESSAGE-ID zcm_efmoura.

TABLES: ekko, ekpo.

TYPES:
  "Saida com ebeln"
  BEGIN OF tp_saida,
    ebeln TYPE ekko-ebeln,
    ebelp TYPE ekpo-ebelp,
    loekz TYPE ekpo-loekz,
    matnr TYPE ekpo-matnr,
    aedat TYPE ekko-aedat,
    lifnr TYPE ekko-lifnr,
    bsart TYPE ekko-bsart,
    bukrs TYPE ekko-bukrs,
    bstyp TYPE ekko-bstyp, "
    txz01 TYPE ekpo-txz01,
    matkl TYPE ekpo-matkl,
    menge TYPE ekpo-menge,
    meins TYPE ekpo-meins,
    cor   TYPE lvc_t_scol,
  END OF tp_saida,

  BEGIN OF tp_pedido,
    ebeln TYPE ekko-ebeln,
    bsart TYPE ekko-bsart,
    aedat TYPE ekko-aedat,
    bukrs TYPE ekko-bukrs,
    lifnr TYPE ekko-lifnr,
    bstyp TYPE ekko-bstyp, "
  END OF tp_pedido,

  BEGIN OF tp_item,
    ebeln TYPE ekpo-ebeln,
    ebelp TYPE ekpo-ebelp,
    loekz TYPE ekpo-loekz,
    matnr TYPE ekpo-matnr,
    txz01 TYPE ekpo-txz01,
    matkl TYPE ekpo-matkl,
    menge TYPE ekpo-menge,
    meins TYPE ekpo-meins,
  END OF tp_item.

"Tabelas internas principais
DATA: lt_pedido TYPE TABLE OF tp_pedido,
      lt_item   TYPE TABLE OF tp_item,
      lt_saida  TYPE TABLE OF tp_saida.

"Estrututas principais
DATA: ls_pedido TYPE tp_pedido,
      ls_item   TYPE tp_item,
      ls_saida  TYPE tp_saida.

"Fieldcat
TYPE-POOLS: slis.
DATA : it_fcat TYPE slis_t_fieldcat_alv,
       wa_fcat LIKE LINE OF it_fcat.

"Layout
DATA:       ls_layout TYPE slis_layout_alv.

"Ordenação
DATA: it_sort TYPE slis_t_sortinfo_alv, "tabela
      wa_sort TYPE slis_sortinfo_alv. "estrutura

"Eventos
DATA: gt_events TYPE slis_t_event,
      wa_events LIKE LINE OF gt_events.

"Variantes de Layout
DATA: v_variant TYPE disvariant,
      e_variant LIKE disvariant.

"Exclusão de icones
DATA: it_exclui TYPE slis_t_extab,
      s_exclui  TYPE slis_extab.

"cell color
DATA: wa_cor TYPE lvc_s_scol.
"Numero total de pedidos
DATA: vl_linha TYPE i.
"Definir o tipo do relatório no cabeçalho
DATA: tipo_relat(30) TYPE c.


"-----------------TELA DE SELEÇÂO--------------"
SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-001.

  SELECT-OPTIONS: s_nump  FOR ekko-ebeln,
                  s_forn  FOR ekko-lifnr.

SELECTION-SCREEN END OF BLOCK b01.

SELECTION-SCREEN BEGIN OF BLOCK b02 WITH FRAME TITLE TEXT-002.

  PARAMETERS:
    p_ebeln RADIOBUTTON GROUP grp1,
    p_matnr RADIOBUTTON GROUP grp1,
    p_matkl RADIOBUTTON GROUP grp1.

  SELECTION-SCREEN SKIP 1.

  PARAMETERS: p_varian LIKE ltdx-variant MODIF ID id1.

SELECTION-SCREEN END OF BLOCK b02.

"----------------------------------------------"

AT SELECTION-SCREEN.
  IF s_nump AND s_forn IS INITIAL.
    MESSAGE e002. "Mensagem de erro impede continuação da seleção"
  ENDIF.

  IF p_varian IS NOT INITIAL.
    e_variant-variant = p_varian.
    e_variant-report  = sy-repid.
    CALL FUNCTION 'REUSE_ALV_VARIANT_DEFAULT_GET'
      EXPORTING
        i_save        = 'A'
      CHANGING
        cs_variant    = e_variant
      EXCEPTIONS
        wrong_input   = 1
        not_found     = 2
        program_error = 3
        OTHERS        = 4.
    IF sy-subrc <> 0.
      MESSAGE: e011.
    ENDIF.
  ENDIF.

  "&ETA





AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_varian.
  v_variant-report = sy-repid.

  CALL FUNCTION 'REUSE_ALV_VARIANT_F4'
    EXPORTING
      is_variant    = v_variant
*     I_TABNAME_HEADER          =
*     I_TABNAME_ITEM            =
*     IT_DEFAULT_FIELDCAT       =
      i_save        = 'A'
*     I_DISPLAY_VIA_GRID        = ' '
    IMPORTING
*     E_EXIT        =
      es_variant    = e_variant
    EXCEPTIONS
      not_found     = 1
      program_error = 2
      OTHERS        = 3.
  IF sy-subrc <> 0.
    MESSAGE s010(Ok).
  ELSE.
    p_varian = e_variant-variant.
  ENDIF.

  "----------------------------------------------"

START-OF-SELECTION.


  PERFORM zf_select_dados.
  PERFORM zf_preenche_saida.
  PERFORM zf_build_fcat.
  PERFORM zf_build_layout.
  PERFORM zf_build_events.
  PERFORM zf_display_alv.



*&---------------------------------------------------------------------*
*& zf_select_dados. Selecionar Dados
*&---------------------------------------------------------------------*
FORM zf_select_dados.
  "Open SLQ - FOR ALL ENTRIES"
  SELECT ekko~ebeln
         ekko~bsart
         ekko~aedat
         ekko~bukrs
         ekko~lifnr
         ekko~bstyp
  FROM ekko
  INTO TABLE lt_pedido[]
  WHERE ekko~ebeln IN s_nump AND ekko~lifnr IN s_forn.

  DESCRIBE TABLE lt_pedido LINES vl_linha.

  IF sy-subrc = 0.
    SELECT
          ekpo~ebeln
          ekpo~ebelp
          ekpo~loekz
          ekpo~matnr
          ekpo~txz01
          ekpo~matkl
          ekpo~menge
          ekpo~meins
    FROM ekpo
    INTO TABLE lt_item[]
    FOR ALL ENTRIES IN lt_pedido
    WHERE ebeln = lt_pedido-ebeln.

  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*& zf_preenche_saida. Preenche saída
*&---------------------------------------------------------------------*
FORM zf_preenche_saida.

  IF lt_item[] IS INITIAL.
    MESSAGE e001.
  ELSE.
    DELETE lt_item WHERE matnr IS INITIAL.

    LOOP AT lt_item INTO ls_item.
      READ TABLE lt_pedido INTO ls_pedido WITH KEY ebeln = ls_item-ebeln.

      ls_saida-ebeln = ls_pedido-ebeln.
      ls_saida-bsart = ls_pedido-bsart.
      ls_saida-aedat = ls_pedido-aedat.
      ls_saida-bukrs = ls_pedido-bukrs.
      ls_saida-lifnr = ls_pedido-lifnr.
      ls_saida-bstyp = ls_pedido-bstyp.
      ls_saida-ebelp = ls_item-ebelp.
      ls_saida-loekz = ls_item-loekz.
      ls_saida-matnr = ls_item-matnr.
      ls_saida-txz01 = ls_item-txz01.
      ls_saida-matkl = ls_item-matkl.
      ls_saida-menge = ls_item-menge.
      ls_saida-meins = ls_item-meins.

      IF ls_item-loekz = 'L'.
* Populate color variable with colour properties
* Char 1 = C (This is a color property)
* Char 2 = 3 (Color codes: 1 - 7)
* Char 3 = Intensified on/off ( 1 or 0 )
* Char 4 = Inverse display on/off ( 1 or 0 )
*        ls_saida-cor = 'C600'.
        wa_cor-fname = 'LOEKZ'.
        wa_cor-color-col = '6'.
        wa_cor-color-int = '0'.  "1 = Intensified on, 0 = Intensified off
        wa_cor-color-inv = '0'.  "1 = text colour, 0 = background colour

        APPEND wa_cor TO ls_saida-cor.

      ENDIF.

      APPEND ls_saida TO lt_saida.
      CLEAR : ls_saida.
    ENDLOOP.
  ENDIF.

  SORT lt_saida ASCENDING BY ebeln.

ENDFORM.


*&---------------------------------------------------------------------*
*& Montar fieldcat
*&---------------------------------------------------------------------*
FORM zf_build_fcat .

*--------------------------------------*
  wa_fcat-col_pos = '1' .
  wa_fcat-fieldname = 'EBELN' .
  wa_fcat-tabname = 'LT_SAIDA' .
  wa_fcat-seltext_m = 'PEDIDO' .
  wa_fcat-key = 'X' .
  wa_fcat-outputlen = 10.
  wa_fcat-hotspot = 'X'.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '2' .
  wa_fcat-fieldname = 'EBELP' .
  wa_fcat-tabname = 'LT_SAIDA' .
  wa_fcat-seltext_m = 'ITEM' .
  wa_fcat-outputlen = 8.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '3' .
  wa_fcat-fieldname = 'LOEKZ' .
  wa_fcat-tabname = 'LT_SAIDA' .
  wa_fcat-seltext_m = 'ELIMINADO' .
  wa_fcat-outputlen = 10.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '4' .
  wa_fcat-fieldname = 'MATNR' .
  wa_fcat-tabname = 'LT_SAIDA' .
  wa_fcat-seltext_m = 'MATERIAL' .
  wa_fcat-outputlen = 15.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '5' .
  wa_fcat-fieldname = 'AEDAT' .
  wa_fcat-tabname = 'LT_SAIDA' .
  wa_fcat-seltext_m = 'DATA REGISTRO' .
  wa_fcat-outputlen = 15.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '6' .
  wa_fcat-fieldname = 'LIFNR' .
  wa_fcat-tabname = 'LT_SAIDA' .
  wa_fcat-seltext_m = 'FORNECEDOR' .
  wa_fcat-outputlen = 15.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '7' .
  wa_fcat-fieldname = 'BSART' .
  wa_fcat-tabname = 'LT_SAIDA' .
  wa_fcat-seltext_m = 'TIPO COMPRA' .
  wa_fcat-outputlen = 12.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '8' .
  wa_fcat-fieldname = 'BUKRS' .
  wa_fcat-tabname = 'LT_SAIDA' .
  wa_fcat-seltext_m = 'EMPRESA' .
  wa_fcat-outputlen = 10.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '9' .
  wa_fcat-fieldname = 'BSTYP' .
  wa_fcat-tabname = 'LT_SAIDA' .
  wa_fcat-seltext_m = 'CTG DOC' .
  wa_fcat-outputlen = 8.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '10' .
  wa_fcat-fieldname = 'TXZ01' .
  wa_fcat-tabname = 'LT_SAIDA' .
  wa_fcat-seltext_m = 'DESCRICAO BREVE' .
  wa_fcat-outputlen = 30.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '11' .
  wa_fcat-fieldname = 'MATKL' .
  wa_fcat-tabname = 'LT_SAIDA' .
  wa_fcat-seltext_m = 'GRUPO_MERC' .
  wa_fcat-outputlen = 15.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '12' .
  wa_fcat-fieldname = 'MENGE' .
  wa_fcat-tabname = 'LT_SAIDA' .
  wa_fcat-seltext_m = 'QUANTIDADE' .
  wa_fcat-outputlen = 15.
  wa_fcat-do_sum = 'X'.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '13' .
  wa_fcat-fieldname = 'MEINS' .
  wa_fcat-tabname = 'LT_SAIDA' .
  wa_fcat-seltext_m = 'MEDIDA' .
  wa_fcat-outputlen = 10.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*

  CASE 'X'.
    WHEN p_ebeln.
      tipo_relat = 'POR PEDIDO'.
      wa_sort-spos      = 1.
      wa_sort-fieldname = 'EBELN'.
      wa_sort-up        = 'X'.
      wa_sort-subtot    = 'X'.
      APPEND wa_sort TO it_sort.

    WHEN p_matnr.
      tipo_relat = 'POR MATERIAL'.
      wa_sort-spos      = 1.
      wa_sort-fieldname = 'MATNR'.
      wa_sort-up        = 'X'.
      wa_sort-subtot    = 'X'.
      APPEND wa_sort TO it_sort.

    WHEN p_matkl.
      tipo_relat = 'POR GRP-MERCADORIA'.
      wa_sort-spos      = 1.
      wa_sort-fieldname = 'MATKL'.
      wa_sort-up        = 'X'.
      wa_sort-subtot    = 'X'.
      APPEND wa_sort TO it_sort.

  ENDCASE.
*--------------------------------------*

ENDFORM.


*&---------------------------------------------------------------------*
*&  zf_build_layout. Monta Layout
*&---------------------------------------------------------------------*
FORM zf_build_layout .
*  ls_layout-colwidth_optimize = 'X'.
  ls_layout-zebra             = 'X'.
*  ls_layout-info_fieldname = 'COR'.
  ls_layout-coltab_fieldname = 'COR'.
ENDFORM.


*&---------------------------------------------------------------------*
*&  zf_build_events. Monta eventos
*&---------------------------------------------------------------------*
FORM zf_build_events. "Usar quando na chamada do ALV não possui oq queremos

  DATA: vl_index  LIKE sy-tabix.

  CALL FUNCTION 'REUSE_ALV_EVENTS_GET'
    EXPORTING
      i_list_type = 0
    IMPORTING
      et_events   = gt_events[].

  READ TABLE gt_events INTO wa_events WITH KEY name =  slis_ev_end_of_list.

  IF sy-subrc = 0.

    vl_index = sy-tabix.
    wa_events-form = 'END-OF-LIST'.
    MODIFY gt_events FROM wa_events INDEX vl_index.

  ENDIF.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form zf_top-of-page
*&---------------------------------------------------------------------*
FORM top-of-page.
* Declarações locais do cabeçalho do ALV
  DATA: it_header     TYPE slis_t_listheader,
        st_header     TYPE slis_listheader,
        ld_linesc(80) TYPE c.

  DATA: vl_data(8) TYPE c,
        vl_ano(2)  TYPE c, "só os ultimos 2 digitos
        vl_mes(2)  TYPE c,
        vl_dia(2)  TYPE c.

  vl_ano = sy-datum+2(2).
  vl_mes = sy-datum+4(2).
  vl_dia = sy-datum+6(2).

  CONCATENATE 'RELATÓRIO DE PEDIDOS' tipo_relat INTO ld_linesc SEPARATED BY space.
  st_header-typ  = 'H'. "H = Header, S = Selection, A = Action
  st_header-info = ld_linesc.
  APPEND st_header TO it_header.
  CLEAR st_header.

  CONCATENATE vl_dia vl_mes vl_ano INTO vl_data SEPARATED BY '/'.
  st_header-typ = 'S'.
  st_header-key = 'DATA'.
  WRITE vl_data TO st_header-info.
  APPEND st_header TO it_header.
  CLEAR st_header.

  st_header-typ = 'S'.
  st_header-key = 'HORA'.
  WRITE sy-uzeit TO st_header-info.
  APPEND st_header TO it_header.
  CLEAR st_header.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = it_header.
*     I_LOGO                   =
*     I_END_OF_LIST_GRID       =
*     i_alv_form               = 'X'

*  REFRESH it_header.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form zf_display_alv. Display ALV GRID
*&---------------------------------------------------------------------*
FORM zf_display_alv .
  DATA vl_repid LIKE sy-repid.
  vl_repid = sy-repid.

  s_exclui-fcode = '&INFO'.
  APPEND s_exclui TO it_exclui.
  s_exclui-fcode = '&ETA'.
  APPEND s_exclui TO it_exclui.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK       = ' '
*     I_BYPASSING_BUFFER      = ' '
*     I_BUFFER_ACTIVE         = ' '
      i_callback_program      = vl_repid
*     I_CALLBACK_PF_STATUS_SET          = ' '
      i_callback_user_command = 'ZF_USER_COMMAND'
      i_callback_top_of_page  = 'TOP-OF-PAGE'
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME        =
*     I_BACKGROUND_ID         = ' '
*     I_GRID_TITLE            =
*     I_GRID_SETTINGS         =
      is_layout               = ls_layout
      it_fieldcat             = it_fcat
      it_excluding            = it_exclui
*     IT_SPECIAL_GROUPS       =
      it_sort                 = it_sort
*     IT_FILTER               =
*     IS_SEL_HIDE             =
*     I_DEFAULT               = 'X'
      i_save                  = 'A'
      is_variant              = e_variant
      it_events               = gt_events
*     IT_EVENT_EXIT           =
*     IS_PRINT                =
*     IS_REPREP_ID            =
*     I_SCREEN_START_COLUMN   = 0
*     I_SCREEN_START_LINE     = 0
*     I_SCREEN_END_COLUMN     = 0
*     I_SCREEN_END_LINE       = 0
*     I_HTML_HEIGHT_TOP       = 0
*     I_HTML_HEIGHT_END       = 0
*     IT_ALV_GRAPHICS         =
*     IT_HYPERLINK            =
*     IT_ADD_FIELDCAT         =
*     IT_EXCEPT_QINFO         =
*     IR_SALV_FULLSCREEN_ADAPTER        =
*     O_PREVIOUS_SRAL_HANDLER =
* IMPORTING
*     E_EXIT_CAUSED_BY_CALLER =
*     ES_EXIT_CAUSED_BY_USER  =
    TABLES
      t_outtab                = lt_saida.
* EXCEPTIONS
*   PROGRAM_ERROR                     = 1
*   OTHERS                            = 2
ENDFORM.

FORM zf_user_command USING vl_ucomm LIKE sy-ucomm
                           rs_campo TYPE slis_selfield.

  CASE vl_ucomm.
    WHEN '&IC1'. "clique do usuário

      IF rs_campo-fieldname = 'EBELN'. "Field to be clicked

        READ TABLE lt_saida ASSIGNING FIELD-SYMBOL(<fs_it>) INDEX rs_campo-tabindex.

        IF <fs_it>-bstyp = 'F'.

          SET PARAMETER ID 'BES' FIELD <fs_it>-ebeln.
          CALL TRANSACTION 'ME23N'. " AND SKIP FIRST SCREEN.

        ELSEIF <fs_it>-bstyp = 'K'.

          SET PARAMETER ID 'CTR' FIELD <fs_it>-ebeln.
          CALL TRANSACTION 'ME33K' AND SKIP FIRST SCREEN.

        ENDIF.
      ENDIF.

    WHEN OTHERS.
  ENDCASE.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form zf_end-of-list
*&---------------------------------------------------------------------*
FORM end-of-list.
* Declarações locais do cabeçalho do ALV
  DATA: st_footer TYPE slis_listheader,
        it_footer TYPE slis_t_listheader.

  st_footer-typ = 'S'.
  st_footer-key = 'Num. Pedidos'.
  WRITE vl_linha TO st_footer-info.
  APPEND st_footer TO it_footer.
  CLEAR st_footer.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = it_footer.

ENDFORM.