************************************************************************
* NOME DO PROGRAMA    :  ZEDU_MENU_HORTI                               *
* TRANSAÇÃO           :                                                *
* TÍTULO DO PROGRAMA  : Menu Hortifruti                                *
* DESCRIÇÃO           : Report para mostrar o menu de relatórios e     *
*                       programas de manutenção                        *
* PROGRAMADOR         : Eduardo Freitas Moura (EFREITAS)               *
* DATA                : 21.02.2022                                     *
************************************************************************
REPORT zedu_menu_horti MESSAGE-ID zcm_efmoura.

"------------------TELA DE SELEÇÂO---------------"

SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_btn1 RADIOBUTTON GROUP gr1 USER-COMMAND click DEFAULT 'X',
              p_btn2 RADIOBUTTON GROUP gr1,
              p_btn3 RADIOBUTTON GROUP gr1.

SELECTION-SCREEN END OF BLOCK b01.

SELECTION-SCREEN BEGIN OF BLOCK b02 WITH FRAME TITLE TEXT-002.
  PARAMETERS: p_relatf RADIOBUTTON GROUP gr2 MODIF ID id1, "Relatório Fruta
              p_relatp RADIOBUTTON GROUP gr2 MODIF ID id1. "Relatório Produtor
SELECTION-SCREEN END OF BLOCK b02.

SELECTION-SCREEN BEGIN OF BLOCK b03 WITH FRAME TITLE TEXT-003.
  PARAMETERS: p_manutf RADIOBUTTON GROUP gr3 MODIF ID id2, "Manutenção Frutas
              p_manutp RADIOBUTTON GROUP gr3 MODIF ID id2. "Manutenção de Produtor
SELECTION-SCREEN END OF BLOCK b03.

SELECTION-SCREEN BEGIN OF BLOCK b04 WITH FRAME TITLE TEXT-004.
  PARAMETERS: p_cargaf RADIOBUTTON GROUP gr4 MODIF ID id3, "Carga de Frutas
              p_cargap RADIOBUTTON GROUP gr4 MODIF ID id3. "Carga de Produtor
SELECTION-SCREEN END OF BLOCK b04.
"-------------------------------------------------"


AT SELECTION-SCREEN OUTPUT.

*DATA wa_screen TYPE screen.

    CASE 'X'.
      WHEN p_btn1.
        LOOP AT SCREEN.
        IF screen-group1 = 'ID2'.
          screen-active = '0'.
          MODIFY SCREEN FROM screen.
        ENDIF.
        IF screen-group1 = 'ID3'.
          screen-active = '0'.
          MODIFY SCREEN FROM screen.
        ENDIF.
        ENDLOOP.
      WHEN p_btn2.

        LOOP AT SCREEN.
        IF screen-group1 = 'ID1'.
          screen-active = '0'.
          MODIFY SCREEN FROM screen.
        ENDIF.
        IF screen-group1 = 'ID3'.
          screen-active = '0'.
          MODIFY SCREEN FROM screen.
        ENDIF.
        ENDLOOP.

      WHEN p_btn3.

        LOOP AT SCREEN.
        IF screen-group1 = 'ID1'.
          screen-active = '0'.
          MODIFY SCREEN FROM screen.
        ENDIF.
        IF screen-group1 = 'ID2'.
          screen-active = '0'.
          MODIFY SCREEN FROM screen.
        ENDIF.
        ENDLOOP.
    ENDCASE.

  "-------------INICIO_DA_SELEÇÃO---------------"

START-OF-SELECTION.

  CASE 'X'.
    WHEN p_btn1.

      IF p_relatf = 'X'.
        SUBMIT zedu_relat_fruta VIA SELECTION-SCREEN AND RETURN.
      ELSEIF p_relatp = 'X'.
        SUBMIT zedu_relat_produtor VIA SELECTION-SCREEN AND RETURN.
      ENDIF.

    WHEN p_btn2.

      IF p_manutf = 'X'.
        SUBMIT zedu_manut_frutas VIA SELECTION-SCREEN AND RETURN.
      ELSEIF p_manutp = 'X'.
        SUBMIT zedu_manut_produtor VIA SELECTION-SCREEN AND RETURN.
      ENDIF.

    WHEN p_btn3.

      IF p_cargaf = 'X'.
        SUBMIT zedu_carga_frutas VIA SELECTION-SCREEN AND RETURN.
      ELSEIF p_cargap = 'X'.
        SUBMIT zedu_carga_produtor VIA SELECTION-SCREEN AND RETURN.
      ENDIF.

  ENDCASE.



************************************************************************
* NOME DO PROGRAMA    :  ZEDU_RELAT_HORTI                              *
* TRANSAÇÃO           :                                                *
* TÍTULO DO PROGRAMA  : Relatório Hortifruti                           *
* DESCRIÇÃO           : Report para mostrar o relatórios do projeto    *
*                       Hortifruti                                     *
* PROGRAMADOR         : Eduardo Freitas Moura (EFREITAS)               *
* DATA                : 21.02.2022                                     *
************************************************************************
REPORT zedu_relat_fruta MESSAGE-ID zcm_efmoura.

TABLES: zfruta_aluno07, zprod_aluno07.

"----------TIPOS---------"
TYPES:
  BEGIN OF tp_relat,
    id_fruta    TYPE zfruta_aluno07-id_fruta,
*     id_fruta(10)    TYPE c,
    id_produtor TYPE zfruta_aluno07-id_produtor,
    nome_fruta  TYPE zfruta_aluno07-nome_fruta,
    nome_prod   TYPE zprod_aluno07-nome_produtor,
    tp_fruta    TYPE zfruta_aluno07-tp_fruta,
    safra_fruta TYPE zfruta_aluno07-safra_fruta,
    qtde_fruta  TYPE zfruta_aluno07-qtde_fruta,
    unmed_fruta TYPE zfruta_aluno07-unmed_fruta,
    punit_fruta TYPE zfruta_aluno07-punit_fruta,
    moeda_fruta TYPE zfruta_aluno07-moeda_fruta,
  END OF tp_relat.

"---TABELAS_INTERNAS---"
DATA: lt_relat TYPE TABLE OF tp_relat.

"------ESTRUTURAS------"
DATA: ls_relat    TYPE tp_relat,
      ls_produtor TYPE zprod_aluno07.

"-------FIELDCAT-------"
TYPE-POOLS: slis.
DATA: it_fcat TYPE slis_t_fieldcat_alv,
      wa_fcat LIKE LINE OF it_fcat.

"--------LAYOUT--------"
DATA:  ls_layout TYPE slis_layout_alv.

"------ORDENAÇÃO-------"
DATA: it_sort TYPE slis_t_sortinfo_alv, "tabela
      wa_sort TYPE slis_sortinfo_alv. "estrutura

"-------EVENTOS--------"
DATA: gt_events    TYPE slis_t_event,
      it_excluding TYPE slis_t_extab,
      s_excluding  TYPE slis_extab.

"----OUTRAS_GLOBAIS----"
FIELD-SYMBOLS: <fs_it> TYPE tp_relat.


"---------------TELA DE SELEÇÂO------------"
SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-001.

  SELECT-OPTIONS: s_idfrut  FOR zfruta_aluno07-id_fruta,
                  s_idprod  FOR zfruta_aluno07-id_produtor.

SELECTION-SCREEN END OF BLOCK b01.


"----------------VALIDAÇÃO DE TELA----------------"

AT SELECTION-SCREEN.
  IF s_idfrut AND s_idprod IS INITIAL.
    MESSAGE e002. "Mensagem de erro impede continuação da seleção"
  ENDIF.



"-------------INICIO_DA_SELEÇÃO---------------"

START-OF-SELECTION.

  PERFORM zf_select.
*  PERFORM zf_preenche_saida.
  PERFORM zf_build_fcat.
  PERFORM zf_build_layout.
  PERFORM zf_build_events.
  PERFORM zf_display_alv.


*&---------------------------------------------------------------------*
*& Form zf_select
*&---------------------------------------------------------------------*
FORM zf_select .

  "OPEN SQL"
  SELECT zfruta_aluno07~id_fruta
         zfruta_aluno07~id_produtor
         zfruta_aluno07~nome_fruta
         zprod_aluno07~nome_produtor
         zfruta_aluno07~tp_fruta
         zfruta_aluno07~safra_fruta
         zfruta_aluno07~qtde_fruta
         zfruta_aluno07~unmed_fruta
         zfruta_aluno07~punit_fruta
         zfruta_aluno07~moeda_fruta
    FROM zfruta_aluno07
    LEFT JOIN zprod_aluno07 ON zprod_aluno07~cod_produtor = zfruta_aluno07~id_produtor
    INTO TABLE lt_relat[]
    WHERE zfruta_aluno07~id_fruta IN s_idfrut AND zfruta_aluno07~id_produtor IN s_idprod.

  SORT lt_relat[] ASCENDING BY id_fruta id_produtor.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form zf_build_fcat
*&---------------------------------------------------------------------*
FORM zf_build_fcat .

*--------------------------------------*
  wa_fcat-col_pos = '1' .
  wa_fcat-fieldname = 'ID_FRUTA' .
  wa_fcat-tabname = 'LT_RELAT' .
  wa_fcat-seltext_m = 'ID_FRUTA' .
  wa_fcat-key = 'X' .
  wa_fcat-outputlen = 10.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '2' .
  wa_fcat-fieldname = 'ID_PRODUTOR' .
  wa_fcat-tabname = 'LT_RELAT' .
  wa_fcat-seltext_m = 'ID_PRODUTOR' .
  wa_fcat-key = 'X' .
  wa_fcat-outputlen = 12.
  wa_fcat-hotspot = 'X'.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '3' .
  wa_fcat-fieldname = 'NOME_FRUTA' .
  wa_fcat-tabname = 'LT_RELAT' .
  wa_fcat-seltext_m = 'NOME FRUTA' .
  wa_fcat-outputlen = 15.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '4' .
  wa_fcat-fieldname = 'NOME_PROD' .
  wa_fcat-tabname = 'LT_RELAT' .
  wa_fcat-seltext_m = 'NOME PRODUTOR' .
  wa_fcat-outputlen = 25.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '5' .
  wa_fcat-fieldname = 'TP_FRUTA' .
  wa_fcat-tabname = 'LT_RELAT' .
  wa_fcat-seltext_m = 'TIPO' .
  wa_fcat-outputlen = 15.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '6' .
  wa_fcat-fieldname = 'SAFRA_FRUTA' .
  wa_fcat-tabname = 'LT_RELAT' .
  wa_fcat-seltext_m = 'SAFRA' .
  wa_fcat-outputlen = 20.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '7' .
  wa_fcat-fieldname = 'QTDE_FRUTA' .
  wa_fcat-tabname = 'LT_RELAT' .
  wa_fcat-seltext_m = 'QUANTIDADE' .
  wa_fcat-outputlen = 15.
*  wa_fcat-do_sum = 'X'.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '8' .
  wa_fcat-fieldname = 'UNMED_FRUTA' .
  wa_fcat-tabname = 'LT_RELAT' .
  wa_fcat-seltext_m = 'MEDIDA' .
  wa_fcat-outputlen = 10.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '9' .
  wa_fcat-fieldname = 'PUNIT_FRUTA' .
  wa_fcat-tabname = 'LT_RELAT' .
  wa_fcat-seltext_m = 'PREÇO' .
  wa_fcat-outputlen = 10.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '10' .
  wa_fcat-fieldname = 'MOEDA_FRUTA' .
  wa_fcat-tabname = 'LT_RELAT' .
  wa_fcat-seltext_m = 'MOEDA' .
  wa_fcat-outputlen = 8.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
*  wa_sort-spos      = 1.
*  wa_sort-fieldname = 'ID_FRUTA'.
*  wa_sort-up        = 'X'.
*  wa_sort-subtot    = 'X'.
*  APPEND wa_sort TO it_sort.
*--------------------------------------*
ENDFORM.


*&---------------------------------------------------------------------*
*& Form zf_build_layout
*&---------------------------------------------------------------------*
FORM zf_build_layout .
*  ls_layout-colwidth_optimize = 'X'.
  ls_layout-zebra             = 'X'.
*  ls_layout-info_fieldname = 'COR'.
*  ls_layout-coltab_fieldname = 'COR'.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form zf_build_events
*&---------------------------------------------------------------------*
FORM zf_build_events.
  DATA: vl_index  LIKE sy-tabix,
        wa_events LIKE LINE OF gt_events.

*  CALL FUNCTION 'REUSE_ALV_EVENTS_GET'
*    EXPORTING
*      i_list_type = 0
*    IMPORTING
*      et_events   = gt_events[].
*
*  READ TABLE gt_events INTO wa_events WITH KEY name =  slis_ev_pf_status_set.
*
*  IF sy-subrc = 0.
*
*    vl_index = sy-tabix.
*    wa_events-form = 'ZPF_STATUS'.
*    MODIFY gt_events FROM wa_events INDEX vl_index.
*
*  ENDIF.
*
*  s_excluding-fcode = '&INFO'.
*  APPEND s_excluding TO it_excluding.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form zf_display_alv
*&---------------------------------------------------------------------*
FORM zf_display_alv .

  DATA vl_repid LIKE sy-repid.
  vl_repid = sy-repid.

  DATA ls_grid_settings TYPE lvc_s_glay.
  ls_grid_settings-edt_cll_cb = 'X'.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK       = ' '
*     I_BYPASSING_BUFFER      = ' '
*     I_BUFFER_ACTIVE         = ' '
      i_callback_program      = vl_repid
*     i_callback_pf_status_set = 'ZPF_STATUS'
      i_callback_user_command = 'ZF_USER_COMMAND'
*     I_CALLBACK_TOP_OF_PAGE  = ' '
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME        =
*     I_BACKGROUND_ID         = ' '
*     I_GRID_TITLE            =
      i_grid_settings         = ls_grid_settings
      is_layout               = ls_layout
      it_fieldcat             = it_fcat
      it_excluding            = it_excluding[]
*     IT_SPECIAL_GROUPS       =
      it_sort                 = it_sort
*     IT_FILTER               =
*     IS_SEL_HIDE             =
*     I_DEFAULT               = 'X'
      i_save                  = 'A'
*     IS_VARIANT              =
      it_events               = gt_events[]
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
*   IMPORTING
*     E_EXIT_CAUSED_BY_CALLER =
*     ES_EXIT_CAUSED_BY_USER  =
    TABLES
      t_outtab                = lt_relat
*   EXCEPTIONS
*     PROGRAM_ERROR           = 1
*     OTHERS                  = 2
    .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.


FORM zf_user_command USING vl_ucomm LIKE sy-ucomm
                           rs_selfield TYPE slis_selfield.
  CASE vl_ucomm.
    WHEN '&IC1'. "clique do usuário

      IF rs_selfield-fieldname = 'ID_PRODUTOR'. "Field to be clicked

        READ TABLE lt_relat ASSIGNING <fs_it> INDEX rs_selfield-tabindex.
*        SUBMIT ZEDU_MANUT_PRODUTOR USING SELECTION-SETS OF PROGRAM s_idprod WITH <fs_it>-id_produtor IN s_idprod.
*        SUBMIT ZEDU_MANUT_PRODUTOR.
        CALL SCREEN 100. "chama tela 100


      ENDIF.

    WHEN OTHERS.
  ENDCASE.
ENDFORM.
*
*FORM zpf_status USING icon_extab.
*  SET PF-STATUS 'ZMENU_FRUTAS' EXCLUDING icon_extab.
*ENDFORM.

INCLUDE zedu_relat_fruta_pbo.

INCLUDE zedu_relat_fruta_pai.


*----------------------------------------------------------------------*
***INCLUDE ZEDU_RELAT_HORTI_PBO.
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
 SET PF-STATUS '0100'.
 SET TITLEBAR '100'.
ENDMODULE.

*&---------------------------------------------------------------------*
*& Module SELECIONA_FORNECEDOR OUTPUT
*&---------------------------------------------------------------------*
MODULE seleciona_produtor OUTPUT.
*  <fs_it>-id_produtor
    SELECT *
      FROM zprod_aluno07
      INTO ls_produtor
      WHERE cod_produtor = <fs_it>-id_produtor.
    ENDSELECT.


ENDMODULE.

*----------------------------------------------------------------------*
***INCLUDE ZEDU_RELAT_HORTI_PAI.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE sy-ucomm.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN 'CANC'.
      LEAVE PROGRAM.
    WHEN 'ENDE'.
      LEAVE PROGRAM.
    WHEN OTHERS.
  ENDCASE.
ENDMODULE.



************************************************************************
* NOME DO PROGRAMA    : ZEDU_RELAT_PRODUTOR                            *
* TRANSAÇÃO           :                                                *
* TÍTULO DO PROGRAMA  : Relatório Hortifruti Hierárquico               *
* DESCRIÇÃO           : Report para mostrar o relatórios do projeto    *
*                       Hortifruti em ALV hierárquico                  *
* PROGRAMADOR         : Eduardo Freitas Moura (EFREITAS)               *
* DATA                : 02.03.2022                                     *
************************************************************************
REPORT zedu_relat_produtor MESSAGE-ID zcm_efmoura.

TABLES: zfruta_aluno07, zprod_aluno07.

"----------TIPOS---------"
TYPES:
  BEGIN OF tp_head,
    id_produtor TYPE zprod_aluno07-cod_produtor,
    nome_prod   TYPE zprod_aluno07-nome_produtor,
*    expand,
  END OF tp_head,

  BEGIN OF tp_relat,
    id_produtor TYPE zprod_aluno07-cod_produtor,
    nome_prod   TYPE zprod_aluno07-nome_produtor,
    id_fruta    TYPE zfruta_aluno07-id_fruta,
    nome_fruta  TYPE zfruta_aluno07-nome_fruta,
    tp_fruta    TYPE zfruta_aluno07-tp_fruta,
    safra_fruta TYPE zfruta_aluno07-safra_fruta,
    qtde_fruta  TYPE zfruta_aluno07-qtde_fruta,
    unmed_fruta TYPE zfruta_aluno07-unmed_fruta,
    punit_fruta TYPE zfruta_aluno07-punit_fruta,
    moeda_fruta TYPE zfruta_aluno07-moeda_fruta,
*    expand,
  END OF tp_relat.

"---TABELAS_INTERNAS---"
DATA: lt_relat TYPE TABLE OF tp_relat,
      lt_head  TYPE TABLE OF tp_head.

"------ESTRUTURAS------"
DATA: ls_relat    TYPE tp_relat,
      ls_produtor TYPE zprod_aluno07.

"-------FIELDCAT-------"
TYPE-POOLS: slis.
DATA: it_fcat TYPE slis_t_fieldcat_alv,
      wa_fcat LIKE LINE OF it_fcat.

"--------LAYOUT--------"
DATA:  ls_layout TYPE slis_layout_alv.

"------ORDENAÇÃO-------"
DATA: it_sort TYPE slis_t_sortinfo_alv, "tabela
      wa_sort TYPE slis_sortinfo_alv. "estrutura

"-------EVENTOS--------"
DATA: gt_events    TYPE slis_t_event,
      it_excluding TYPE slis_t_extab,
      s_excluding  TYPE slis_extab.

"----OUTRAS_GLOBAIS----"
FIELD-SYMBOLS: <fs_it> TYPE tp_relat.
DATA vl_repid LIKE sy-repid.
vl_repid = sy-repid.

DATA: "g_expandname    TYPE slis_fieldname VALUE  'EXPAND',
      g_tabname_head  TYPE slis_tabname,
      g_tabname_relat TYPE slis_tabname.

"---------------TELA DE SELEÇÂO------------"
SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-001.

  SELECT-OPTIONS: s_nome    FOR zprod_aluno07-nome_produtor,
                  s_idprod  FOR zprod_aluno07-cod_produtor.

SELECTION-SCREEN END OF BLOCK b01.


"----------------VALIDAÇÃO DE TELA----------------"

AT SELECTION-SCREEN.
  IF s_nome AND s_idprod IS INITIAL.
    MESSAGE e002. "Mensagem de erro impede continuação da seleção"
  ENDIF.




"-------------INICIO_DA_SELEÇÃO---------------"

START-OF-SELECTION.

  PERFORM zf_select.
  PERFORM zf_build_fcat.
  PERFORM zf_build_layout.
  PERFORM zf_build_events.
  PERFORM zf_display_alv.


*&---------------------------------------------------------------------*
*& Form zf_select
*&---------------------------------------------------------------------*
FORM zf_select .

  "OPEN SQL"
  SELECT zprod_aluno07~cod_produtor
         zprod_aluno07~nome_produtor
    FROM zprod_aluno07
    INTO TABLE lt_head[]
    WHERE zprod_aluno07~nome_produtor IN s_nome AND zprod_aluno07~cod_produtor IN s_idprod.

  SORT lt_head ASCENDING BY id_produtor.

  SELECT zfruta_aluno07~id_produtor
         zprod_aluno07~nome_produtor
         zfruta_aluno07~id_fruta
         zfruta_aluno07~nome_fruta
         zfruta_aluno07~tp_fruta
         zfruta_aluno07~safra_fruta
         zfruta_aluno07~qtde_fruta
         zfruta_aluno07~unmed_fruta
         zfruta_aluno07~punit_fruta
         zfruta_aluno07~moeda_fruta
       FROM zfruta_aluno07
       INNER JOIN zprod_aluno07 ON zfruta_aluno07~id_produtor =  zprod_aluno07~cod_produtor
       INTO TABLE lt_relat[]
       WHERE zprod_aluno07~nome_produtor IN s_nome AND zprod_aluno07~cod_produtor IN s_idprod.

  SORT lt_relat ASCENDING BY id_fruta.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form zf_build_fcat
*&---------------------------------------------------------------------*
FORM zf_build_fcat .

*--------------------------------------*
  wa_fcat-col_pos = '1' .
  wa_fcat-fieldname = 'ID_PRODUTOR' .
  wa_fcat-tabname = 'LT_HEAD' .
  wa_fcat-seltext_m = 'ID_PRODUTOR' .
  wa_fcat-key = 'X' .
  wa_fcat-outputlen = 10.
*  wa_fcat-hotspot = 'X'.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '2' .
  wa_fcat-fieldname = 'NOME_PROD' .
  wa_fcat-tabname = 'LT_HEAD' .
  wa_fcat-seltext_m = 'NOME PRODUTOR' .
  wa_fcat-outputlen = 40.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*

  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
      i_program_name     = vl_repid
      i_internal_tabname = 'LT_RELAT' "g_tabname_relat
      i_structure_name   = 'ZFRUTA_ALUNO07' "'TP_RELAT'
    CHANGING
      ct_fieldcat        = it_fcat[]
   EXCEPTIONS
     INCONSISTENT_INTERFACE       = 1
     PROGRAM_ERROR      = 2
     OTHERS             = 3.

  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.


ENDFORM.


*&---------------------------------------------------------------------*
*& Form zf_build_layout
*&---------------------------------------------------------------------*
FORM zf_build_layout .
*  ls_layout-colwidth_optimize = 'X'.
  ls_layout-zebra             = 'X'.
*  ls_layout-info_fieldname = 'COR'.
*  ls_layout-coltab_fieldname = 'COR'.
*  ls_layout-expand_fieldname     = g_expandname.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form zf_build_events
*&---------------------------------------------------------------------*
FORM zf_build_events.
  DATA: vl_index  LIKE sy-tabix,
        wa_events LIKE LINE OF gt_events.

*  CALL FUNCTION 'REUSE_ALV_EVENTS_GET'
*    EXPORTING
*      i_list_type = 0
*    IMPORTING
*      et_events   = gt_events[].
*
*  READ TABLE gt_events INTO wa_events WITH KEY name =  slis_ev_pf_status_set.
*
*  IF sy-subrc = 0.
*
*    vl_index = sy-tabix.
*    wa_events-form = 'ZPF_STATUS'.
*    MODIFY gt_events FROM wa_events INDEX vl_index.
*
*  ENDIF.
*
*  s_excluding-fcode = '&INFO'.
*  APPEND s_excluding TO it_excluding.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form zf_display_alv
*&---------------------------------------------------------------------*
FORM zf_display_alv .

  DATA ls_grid_settings TYPE lvc_s_glay.
  ls_grid_settings-edt_cll_cb = 'X'.


  DATA: s_keyinfo TYPE slis_keyinfo_alv.
  s_keyinfo-header01 = 'ID_PRODUTOR'.
  s_keyinfo-item01   = 'ID_PRODUTOR'.
  s_keyinfo-item02   = 'NOME_PROD'.

  CALL FUNCTION 'REUSE_ALV_HIERSEQ_LIST_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK  = ' '
      i_callback_program = vl_repid
*     I_CALLBACK_PF_STATUS_SET       = ' '
*     i_callback_user_command = 'ZF_USER_COMMAND'
      is_layout          = ls_layout
      it_fieldcat        = it_fcat
      it_excluding       = it_excluding[]
*     IT_SPECIAL_GROUPS  =
*     IT_SORT            = it_sort
*     IT_FILTER          =
*     IS_SEL_HIDE        =
*     I_SCREEN_START_COLUMN   = 0
*     I_SCREEN_START_LINE     = 0
*     I_SCREEN_END_COLUMN     = 0
*     I_SCREEN_END_LINE  = 0
*     I_DEFAULT          = 'X'
      i_save             = 'A'
*     IS_VARIANT         =
      it_events          = gt_events[]
*     IT_EVENT_EXIT      =
      i_tabname_header   = 'LT_HEAD'  "g_tabname_head
      i_tabname_item     = 'LT_RELAT' "g_tabname_relat
*     I_STRUCTURE_NAME_HEADER =
*     I_STRUCTURE_NAME_ITEM   =
      is_keyinfo         = s_keyinfo
*     IS_PRINT           =
*     IS_REPREP_ID       =
*     I_BYPASSING_BUFFER =
*     I_BUFFER_ACTIVE    =
*     IR_SALV_HIERSEQ_ADAPTER =
*     IT_EXCEPT_QINFO    =
*     I_SUPPRESS_EMPTY_DATA   = ABAP_FALSE
*   IMPORTING
*     E_EXIT_CAUSED_BY_CALLER =
*     ES_EXIT_CAUSED_BY_USER  =
    TABLES
      t_outtab_header    = lt_head
      t_outtab_item      = lt_relat
*   EXCEPTIONS
*     PROGRAM_ERROR      = 1
*     OTHERS             = 2
    .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.



ENDFORM.


*FORM zf_user_command USING vl_ucomm LIKE sy-ucomm
*                           rs_selfield TYPE slis_selfield.
*  CASE vl_ucomm.
*    WHEN '&IC1'. "clique do usuário
*
*      IF rs_selfield-fieldname = 'ID_PRODUTOR'. "Field to be clicked
*
*        READ TABLE lt_relat ASSIGNING <fs_it> INDEX rs_selfield-tabindex.
**        SUBMIT ZEDU_MANUT_PRODUTOR USING SELECTION-SETS OF PROGRAM s_idprod WITH <fs_it>-id_produtor IN s_idprod.
**        SUBMIT ZEDU_MANUT_PRODUTOR.
*        CALL SCREEN 100. "chama tela 100
*
*
*      ENDIF.
*
*    WHEN OTHERS.
*  ENDCASE.
*ENDFORM.
*
*FORM zpf_status USING icon_extab.
*  SET PF-STATUS 'ZMENU_FRUTAS' EXCLUDING icon_extab.
*ENDFORM.

INCLUDE zedu_relat_horti_pbo.

INCLUDE zedu_relat_horti_pai.


*----------------------------------------------------------------------*
***INCLUDE ZEDU_RELAT_HORTI_PBO.
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
 SET PF-STATUS '0100'.
 SET TITLEBAR '100'.
ENDMODULE.

*&---------------------------------------------------------------------*
*& Module SELECIONA_FORNECEDOR OUTPUT
*&---------------------------------------------------------------------*
MODULE seleciona_produtor OUTPUT.
*  <fs_it>-id_produtor
    SELECT *
      FROM zprod_aluno07
      INTO ls_produtor
      WHERE cod_produtor = <fs_it>-id_produtor.
    ENDSELECT.


ENDMODULE.

*----------------------------------------------------------------------*
***INCLUDE ZEDU_RELAT_HORTI_PAI.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE sy-ucomm.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN 'CANC'.
      LEAVE PROGRAM.
    WHEN 'ENDE'.
      LEAVE PROGRAM.
    WHEN OTHERS.
  ENDCASE.
ENDMODULE.


************************************************************************
* NOME DO PROGRAMA    :  ZEDU_FRUTAS_ALV_EDIT                          *
* TRANSAÇÃO           :                                                *
* TÍTULO DO PROGRAMA  : Manutenção de frutas                           *
* DESCRIÇÃO           : Report usando a tabela Frutas (zfruta_aluno07) *
*                       para demonstrar ALV editável                   *
* PROGRAMADOR         : Eduardo Freitas Moura (EFREITAS)               *
* DATA                : 16.02.2022                                     *
************************************************************************
REPORT zedu_manut_frutas MESSAGE-ID zcm_efmoura.

TABLES: zfruta_aluno07.

"----------TIPOS---------"
TYPES:
  BEGIN OF tp_fruta,
    id_fruta    TYPE zfruta_aluno07-id_fruta,
    id_produtor TYPE zfruta_aluno07-id_produtor,
    nome_fruta  TYPE zfruta_aluno07-nome_fruta,
    tp_fruta    TYPE zfruta_aluno07-tp_fruta,
    safra_fruta TYPE zfruta_aluno07-safra_fruta,
    qtde_fruta  TYPE zfruta_aluno07-qtde_fruta,
    unmed_fruta TYPE zfruta_aluno07-unmed_fruta,
    punit_fruta TYPE zfruta_aluno07-punit_fruta,
    moeda_fruta TYPE zfruta_aluno07-moeda_fruta,
    checkbox    TYPE flag,
  END OF tp_fruta.

"---TABELAS_INTERNAS---"
DATA: lt_fruta TYPE TABLE OF tp_fruta.

"------ESTRUTURAS------"
DATA: ls_fruta TYPE tp_fruta.

"-------FIELDCAT-------"
TYPE-POOLS: slis.
DATA: it_fcat TYPE slis_t_fieldcat_alv,
      wa_fcat LIKE LINE OF it_fcat.

"--------LAYOUT--------"
DATA:  ls_layout TYPE slis_layout_alv.

"------ORDENAÇÃO-------"
DATA: it_sort TYPE slis_t_sortinfo_alv, "tabela
      wa_sort TYPE slis_sortinfo_alv. "estrutura

"-------EVENTOS--------"
DATA: gt_events    TYPE slis_t_event,
      it_excluding TYPE slis_t_extab,
      s_excluding  TYPE slis_extab.

"----OUTRAS_GLOBAIS----"
DATA: file TYPE string.


"---------------TELA DE SELEÇÂO------------"
SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-001.

  SELECT-OPTIONS: s_idfrut  FOR zfruta_aluno07-id_fruta,
                  s_nomef   FOR zfruta_aluno07-nome_fruta.

SELECTION-SCREEN END OF BLOCK b01.

"--------------------------------------------"

AT SELECTION-SCREEN.
  IF s_idfrut AND s_nomef  IS INITIAL.
    MESSAGE e002. "Mensagem de erro impede continuação da seleção"
  ENDIF.




  "-------------INICIO_DA_SELEÇÃO---------------"

START-OF-SELECTION.

  PERFORM zf_select.
*  PERFORM zf_preenche_saida.
  PERFORM zf_build_fcat.
  PERFORM zf_build_layout.
  PERFORM zf_build_events.
  PERFORM zf_display_alv.


*&---------------------------------------------------------------------*
*& Form zf_select
*&---------------------------------------------------------------------*
FORM zf_select .

  "OPEN SQL"
  SELECT zfruta_aluno07~id_fruta
         zfruta_aluno07~id_produtor
         zfruta_aluno07~nome_fruta
         zfruta_aluno07~tp_fruta
         zfruta_aluno07~safra_fruta
         zfruta_aluno07~qtde_fruta
         zfruta_aluno07~unmed_fruta
         zfruta_aluno07~punit_fruta
         zfruta_aluno07~moeda_fruta
    FROM zfruta_aluno07
    INTO TABLE lt_fruta[]
    WHERE zfruta_aluno07~id_fruta    IN s_idfrut AND
  zfruta_aluno07~nome_fruta  IN s_nomef.

  SORT lt_fruta[] ASCENDING BY id_fruta id_produtor.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form zf_build_fcat
*&---------------------------------------------------------------------*
FORM zf_build_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '0' .
  wa_fcat-fieldname = 'CHECKBOX' .
  wa_fcat-tabname = 'LT_FRUTA' .
  wa_fcat-seltext_m = 'SELECT' .
  wa_fcat-checkbox = 'X' .
  wa_fcat-edit = 'X' .
  wa_fcat-outputlen = 8.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '1' .
  wa_fcat-fieldname = 'ID_FRUTA' .
  wa_fcat-tabname = 'LT_FRUTA' .
  wa_fcat-seltext_m = 'ID_FRUTA' .
  wa_fcat-key = 'X' .
  wa_fcat-outputlen = 10.
*  wa_fcat-edit = 'X' .
*  wa_fcat-hotspot = 'X'.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '2' .
  wa_fcat-fieldname = 'ID_PRODUTOR' .
  wa_fcat-tabname = 'LT_FRUTA' .
  wa_fcat-seltext_m = 'ID_PRODUTOR' .
  wa_fcat-key = 'X' .
  wa_fcat-outputlen = 12.
*  wa_fcat-edit = 'X' .
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '3' .
  wa_fcat-fieldname = 'NOME_FRUTA' .
  wa_fcat-tabname = 'LT_FRUTA' .
  wa_fcat-seltext_m = 'NOME' .
  wa_fcat-outputlen = 15.
  wa_fcat-edit = 'X'.
  wa_fcat-lowercase = 'X'.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '4' .
  wa_fcat-fieldname = 'TP_FRUTA' .
  wa_fcat-tabname = 'LT_FRUTA' .
  wa_fcat-seltext_m = 'TIPO' .
  wa_fcat-outputlen = 15.
  wa_fcat-edit = 'X'.
  wa_fcat-lowercase = 'X'.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '5' .
  wa_fcat-fieldname = 'SAFRA_FRUTA' .
  wa_fcat-tabname = 'LT_FRUTA' .
  wa_fcat-seltext_m = 'SAFRA' .
  wa_fcat-outputlen = 20.
  wa_fcat-edit = 'X'.
  wa_fcat-lowercase = 'X'.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '6' .
  wa_fcat-fieldname = 'QTDE_FRUTA' .
  wa_fcat-tabname = 'LT_FRUTA' .
  wa_fcat-seltext_m = 'QUANTIDADE' .
  wa_fcat-outputlen = 15.
  wa_fcat-edit = 'X'.
  wa_fcat-lowercase = 'X'.
*  wa_fcat-do_sum = 'X'.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '7' .
  wa_fcat-fieldname = 'UNMED_FRUTA' .
  wa_fcat-tabname = 'LT_FRUTA' .
  wa_fcat-seltext_m = 'MEDIDA' .
  wa_fcat-outputlen = 10.
  wa_fcat-edit = 'X'.
  wa_fcat-lowercase = 'X'.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '8' .
  wa_fcat-fieldname = 'PUNIT_FRUTA' .
  wa_fcat-tabname = 'LT_FRUTA' .
  wa_fcat-seltext_m = 'PREÇO' .
  wa_fcat-outputlen = 10.
  wa_fcat-edit = 'X'.
  wa_fcat-lowercase = 'X'.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '9' .
  wa_fcat-fieldname = 'MOEDA_FRUTA' .
  wa_fcat-tabname = 'LT_FRUTA' .
  wa_fcat-seltext_m = 'MOEDA' .
  wa_fcat-outputlen = 8.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
*  wa_sort-spos      = 1.
*  wa_sort-fieldname = 'ID_FRUTA'.
*  wa_sort-up        = 'X'.
*  wa_sort-subtot    = 'X'.
*  APPEND wa_sort TO it_sort.
*--------------------------------------*
ENDFORM.


*&---------------------------------------------------------------------*
*& Form zf_build_layout
*&---------------------------------------------------------------------*
FORM zf_build_layout .
*  ls_layout-colwidth_optimize = 'X'.
  ls_layout-zebra             = 'X'.
*  ls_layout-info_fieldname = 'COR'.
*  ls_layout-coltab_fieldname = 'COR'.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form zf_build_events
*&---------------------------------------------------------------------*
FORM zf_build_events.
  DATA: vl_index  LIKE sy-tabix,
        wa_events LIKE LINE OF gt_events.

  CALL FUNCTION 'REUSE_ALV_EVENTS_GET'
    EXPORTING
      i_list_type = 0
    IMPORTING
      et_events   = gt_events[].

  READ TABLE gt_events INTO wa_events WITH KEY name =  slis_ev_pf_status_set.

  IF sy-subrc = 0.

    vl_index = sy-tabix.
    wa_events-form = 'ZPF_STATUS'.
    MODIFY gt_events FROM wa_events INDEX vl_index.

  ENDIF.

  s_excluding-fcode = '&INFO'.
  APPEND s_excluding TO it_excluding.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form zf_display_alv
*&---------------------------------------------------------------------*
FORM zf_display_alv .

  DATA vl_repid LIKE sy-repid.
  vl_repid = sy-repid.

  DATA ls_grid_settings TYPE lvc_s_glay.
  ls_grid_settings-edt_cll_cb = 'X'.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK        = ' '
*     I_BYPASSING_BUFFER       = ' '
*     I_BUFFER_ACTIVE          = ' '
      i_callback_program       = vl_repid
      i_callback_pf_status_set = 'ZPF_STATUS'
      i_callback_user_command  = 'ZF_USER_COMMAND'
*     I_CALLBACK_TOP_OF_PAGE   = ' '
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME         =
*     I_BACKGROUND_ID          = ' '
*     I_GRID_TITLE             =
      i_grid_settings          = ls_grid_settings
      is_layout                = ls_layout
      it_fieldcat              = it_fcat
      it_excluding             = it_excluding[]
*     IT_SPECIAL_GROUPS        =
      it_sort                  = it_sort
*     IT_FILTER                =
*     IS_SEL_HIDE              =
*     I_DEFAULT                = 'X'
      i_save                   = 'A'
*     IS_VARIANT               =
      it_events                = gt_events[]
*     IT_EVENT_EXIT            =
*     IS_PRINT                 =
*     IS_REPREP_ID             =
*     I_SCREEN_START_COLUMN    = 0
*     I_SCREEN_START_LINE      = 0
*     I_SCREEN_END_COLUMN      = 0
*     I_SCREEN_END_LINE        = 0
*     I_HTML_HEIGHT_TOP        = 0
*     I_HTML_HEIGHT_END        = 0
*     IT_ALV_GRAPHICS          =
*     IT_HYPERLINK             =
*     IT_ADD_FIELDCAT          =
*     IT_EXCEPT_QINFO          =
*     IR_SALV_FULLSCREEN_ADAPTER        =
*     O_PREVIOUS_SRAL_HANDLER  =
*   IMPORTING
*     E_EXIT_CAUSED_BY_CALLER  =
*     ES_EXIT_CAUSED_BY_USER   =
    TABLES
      t_outtab                 = lt_fruta
*   EXCEPTIONS
*     PROGRAM_ERROR            = 1
*     OTHERS                   = 2
    .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form zf_user_command
*&---------------------------------------------------------------------*
FORM zf_user_command USING vl_ucomm LIKE sy-ucomm
                           rs_selfield TYPE slis_selfield.

  DATA: ref_grid TYPE REF TO cl_gui_alv_grid.

  IF ref_grid IS INITIAL.
    CALL FUNCTION 'GET_GLOBALS_FROM_SLVC_FULLSCR'
      IMPORTING
        e_grid = ref_grid.
  ENDIF.

  IF NOT ref_grid IS INITIAL.
    CALL METHOD ref_grid->check_changed_data.
  ENDIF.

  CASE vl_ucomm.
    WHEN 'INS'. "Insere Registro

      CALL SCREEN 100.

    WHEN 'DEL'. "Ao apertar o botão de Delete

      PERFORM zf_delete.

    WHEN '&DATA_SAVE' OR 'SAVE'. "Ao clicar no botão de salvar

      PERFORM zf_save_data.

    WHEN '&REFRESH'. "Ao clicar no botão de refresh

      PERFORM zf_select.

    WHEN 'CSV'.

      PERFORM zf_download_csv.

    WHEN OTHERS.
  ENDCASE.
  PERFORM zf_select.
  rs_selfield-refresh = 'X'.
  rs_selfield-row_stable = 'X'.
  rs_selfield-col_stable = 'X'.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form zpf_status
*&---------------------------------------------------------------------*
FORM zpf_status USING icon_extab.
  SET PF-STATUS 'ZMENU_FRUTAS' EXCLUDING icon_extab.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form zf_delete
*&---------------------------------------------------------------------*
FORM zf_delete.

  DATA ans TYPE c.
  LOOP AT lt_fruta INTO ls_fruta.
    IF ls_fruta-checkbox = 'X'.

      CALL FUNCTION 'POPUP_TO_CONFIRM'
        EXPORTING
          titlebar              = 'Confirmação Delete'
          text_question         = 'Proseguir com Remoção?'
          text_button_1         = 'PROSSEGUIR'
          icon_button_1         = 'ICON_CHECKED'
          text_button_2         = 'CANCELAR'
          icon_button_2         = 'ICON_CANCEL'
          display_cancel_button = ' '
          popup_type            = 'ICON_MESSAGE_ERROR'
        IMPORTING
          answer                = ans.
      IF ans = 2.
        MESSAGE i000 WITH 'Remoção de Fruta cancelada'.
        EXIT.
      ELSE.


        DELETE FROM zfruta_aluno07
        WHERE id_fruta = ls_fruta-id_fruta AND id_produtor = ls_fruta-id_produtor.

        IF sy-subrc = 0.
          COMMIT WORK AND WAIT.
          MESSAGE i000 WITH 'Fruta eliminada com sucesso'.

        ELSE.
          ROLLBACK WORK.
          MESSAGE i000 WITH 'Fruta não foi eliminado'.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDLOOP.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form zf_save_data
*&---------------------------------------------------------------------*
FORM zf_save_data.

  LOOP AT lt_fruta INTO ls_fruta.
    IF ls_fruta-checkbox = 'X'.

      UPDATE zfruta_aluno07
      SET id_fruta = ls_fruta-id_fruta
          id_produtor = ls_fruta-id_produtor
          nome_fruta = ls_fruta-nome_fruta
          tp_fruta = ls_fruta-tp_fruta
          safra_fruta = ls_fruta-safra_fruta
          qtde_fruta = ls_fruta-qtde_fruta
          unmed_fruta = ls_fruta-unmed_fruta
          punit_fruta = ls_fruta-punit_fruta
          moeda_fruta = ls_fruta-moeda_fruta
      WHERE id_fruta = ls_fruta-id_fruta AND id_produtor = ls_fruta-id_produtor.

      IF sy-subrc = 0.
        COMMIT WORK AND WAIT.
        MESSAGE i000 WITH 'Alterado com sucesso'.

      ELSE.
        ROLLBACK WORK.
        MESSAGE i000 WITH 'Não foi alterado'.
      ENDIF.
    ENDIF.
    ls_fruta-checkbox = ''.
  ENDLOOP.

ENDFORM.

INCLUDE zedu_manut_frutas_pbo.
INCLUDE zedu_manut_frutas_pai.


*&---------------------------------------------------------------------*
*& Form zf_download_csv
*&---------------------------------------------------------------------*
FORM zf_download_csv .
  DATA lt_fruta_csv TYPE truxs_t_text_data.

  PERFORM zf_caminho_local.

  CALL FUNCTION 'SAP_CONVERT_TO_CSV_FORMAT'
    EXPORTING
      i_field_seperator    = ';'
*     I_LINE_HEADER        =
*     I_FILENAME           =
*     I_APPL_KEEP          = ' '
    TABLES
      i_tab_sap_data       = lt_fruta
    CHANGING
      i_tab_converted_data = lt_fruta_csv
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
    MESSAGE: i000 WITH 'Falha ao converter'.
  ELSE.
    CALL FUNCTION 'GUI_DOWNLOAD'
      EXPORTING
        "Precisa ser um arquivo no seu computador"
        "Mudar para o usuário escolher"
        filename = file
      TABLES
        data_tab = lt_fruta_csv
      EXCEPTIONS
        OTHERS   = 1.
    IF sy-subrc <> 0.
      MESSAGE: i000 WITH 'Falha ao baixar'.
    ELSE.
      MESSAGE: i000 WITH 'Arquivo baixado'.
    ENDIF.
  ENDIF.
ENDFORM.



*&---------------------------------------------------------------------*
*& Form zf_caminho_local
*&---------------------------------------------------------------------*
FORM zf_caminho_local .

  DATA: vl_caminho TYPE string.
  DATA: tp_file TYPE string.
  tp_file = '.csv'.

  CALL METHOD cl_gui_frontend_services=>directory_browse
    EXPORTING
      window_title    = 'Escolha uma pasta'
      initial_folder  = 'C:\'
    CHANGING
      selected_folder = vl_caminho
    EXCEPTIONS
      cntl_error      = 1
      error_no_gui    = 2
      OTHERS          = 3.

  IF sy-subrc <> 0.
    MESSAGE i000 WITH 'Falha ao buscar caminho'.
  ENDIF.

  CONCATENATE vl_caminho '\Frutas_' sy-datum tp_file INTO file.

ENDFORM.


************************************************************************
* NOME DO PROGRAMA    :  ZEDU_PRODUTOR_ALV_EDIT                        *
* TRANSAÇÃO           :                                                *
* TÍTULO DO PROGRAMA  : Manutenção de Produtor                         *
* DESCRIÇÃO           : Report usando a tabela zprod_aluno07 para      *
*                       demonstrar ALV editável                        *
* PROGRAMADOR         : Eduardo Freitas Moura (EFREITAS)               *
* DATA                : 18.02.2022                                     *
************************************************************************
REPORT zedu_PRODUTOR_alv_edit MESSAGE-ID zcm_efmoura.

TABLES: zprod_aluno07.

"----------TIPOS---------"
TYPES:
  BEGIN OF tp_produtor,
    cod_produtor    TYPE zprod_aluno07-cod_produtor,
    nome_produtor   TYPE zprod_aluno07-nome_produtor,
    logradouro      TYPE zprod_aluno07-logradouro,
    numero          TYPE zprod_aluno07-numero,
    bairro          TYPE zprod_aluno07-bairro,
    cidade          TYPE zprod_aluno07-cidade,
    estado          TYPE zprod_aluno07-estado,
    telefone        TYPE zprod_aluno07-telefone,
    cnpj_produtor   TYPE zprod_aluno07-cnpj_produtor,
    data_registro   TYPE zprod_aluno07-data_registro,
    analise_credito TYPE zprod_aluno07-analise_credito,
    checkbox        TYPE c,
  END OF tp_produtor.

"---TABELAS_INTERNAS---"
DATA: lt_produtor TYPE TABLE OF tp_produtor.

"------ESTRUTURAS------"
DATA: ls_produtor TYPE tp_produtor.

"-------FIELDCAT-------"
TYPE-POOLS: slis.
DATA: it_fcat TYPE slis_t_fieldcat_alv,
      wa_fcat LIKE LINE OF it_fcat.

"--------LAYOUT--------"
DATA:  ls_layout TYPE slis_layout_alv.

"------ORDENAÇÃO-------"
DATA: it_sort TYPE slis_t_sortinfo_alv, "tabela
      wa_sort TYPE slis_sortinfo_alv. "estrutura

"-------EVENTOS--------"
DATA: gt_events    TYPE slis_t_event,
      it_excluding TYPE slis_t_extab,
      s_excluding  TYPE slis_extab.

"----OUTRAS_GLOBAIS----"
DATA: file TYPE string.


"---------------TELA DE SELEÇÂO------------"
SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-001.

  SELECT-OPTIONS: s_idprod  FOR zprod_aluno07-cod_produtor,
                  s_nomep   FOR zprod_aluno07-nome_produtor.

SELECTION-SCREEN END OF BLOCK b01.

"--------------------------------------------"

AT SELECTION-SCREEN.
  IF s_nomep AND s_idprod IS INITIAL.
    MESSAGE e002. "Mensagem de erro impede continuação da seleção"
  ENDIF.


  "-------------INICIO_DA_SELEÇÃO---------------"

START-OF-SELECTION.

  PERFORM zf_select.
*  PERFORM zf_preenche_saida.
  PERFORM zf_build_fcat.
  PERFORM zf_build_layout.
  PERFORM zf_build_events.
  PERFORM zf_display_alv.


*&---------------------------------------------------------------------*
*& Form zf_select
*&---------------------------------------------------------------------*
FORM zf_select .

  "OPEN SQL"
  SELECT  zprod_aluno07~cod_produtor
          zprod_aluno07~nome_produtor
          zprod_aluno07~logradouro
          zprod_aluno07~numero
          zprod_aluno07~bairro
          zprod_aluno07~cidade
          zprod_aluno07~estado
          zprod_aluno07~telefone
          zprod_aluno07~cnpj_produtor
    zprod_aluno07~data_registro
    zprod_aluno07~analise_credito
    FROM zprod_aluno07
    INTO TABLE lt_produtor[]
    WHERE zprod_aluno07~cod_produtor IN s_idprod AND
          zprod_aluno07~nome_produtor IN s_nomep.

  SORT lt_produtor[] ASCENDING BY cod_produtor cnpj_produtor.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form zf_build_fcat
*&---------------------------------------------------------------------*
FORM zf_build_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '0' .
  wa_fcat-fieldname = 'CHECKBOX' .
  wa_fcat-tabname = 'LT_PRODUTOR' .
  wa_fcat-seltext_m = 'SELECT' .
  wa_fcat-checkbox = 'X' .
  wa_fcat-edit = 'X' .
  wa_fcat-outputlen = 8.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '1' .
  wa_fcat-fieldname = 'COD_PRODUTOR' .
  wa_fcat-tabname = 'LT_PRODUTOR' .
  wa_fcat-seltext_m = 'ID_PRODUTOR' .
  wa_fcat-key = 'X' .
  wa_fcat-outputlen = 12.
  wa_fcat-lowercase = 'X'.
*  wa_fcat-edit = 'X' .
*  wa_fcat-hotspot = 'X'.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '2' .
  wa_fcat-fieldname = 'NOME_PRODUTOR' .
  wa_fcat-tabname = 'LT_PRODUTOR' .
  wa_fcat-seltext_m = 'NOME' .
  wa_fcat-outputlen = 20.
  wa_fcat-edit = 'X' .
  wa_fcat-lowercase = 'X'.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '3' .
  wa_fcat-fieldname = 'LOGRADOURO' .
  wa_fcat-tabname = 'LT_PRODUTOR' .
  wa_fcat-seltext_m = 'LOGRADOURO' .
  wa_fcat-outputlen = 25.
  wa_fcat-edit = 'X'.
  wa_fcat-lowercase = 'X'.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '4' .
  wa_fcat-fieldname = 'NUMERO' .
  wa_fcat-tabname = 'LT_PRODUTOR' .
  wa_fcat-seltext_m = 'NUMERO' .
  wa_fcat-outputlen = 8.
  wa_fcat-edit = 'X'.
  wa_fcat-lowercase = 'X'.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '5' .
  wa_fcat-fieldname = 'BAIRRO' .
  wa_fcat-tabname = 'LT_PRODUTOR' .
  wa_fcat-seltext_m = 'BAIRRO' .
  wa_fcat-outputlen = 20.
  wa_fcat-edit = 'X'.
  wa_fcat-lowercase = 'X'.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '6' .
  wa_fcat-fieldname = 'CIDADE' .
  wa_fcat-tabname = 'LT_PRODUTOR' .
  wa_fcat-seltext_m = 'CIDADE' .
  wa_fcat-outputlen = 20.
  wa_fcat-edit = 'X'.
  wa_fcat-lowercase = 'X'.
*  wa_fcat-do_sum = 'X'.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '7' .
  wa_fcat-fieldname = 'ESTADO' .
  wa_fcat-tabname = 'LT_PRODUTOR' .
  wa_fcat-seltext_m = 'ESTADO' .
  wa_fcat-outputlen = 8.
  wa_fcat-edit = 'X'.
  wa_fcat-lowercase = 'X'.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '8' .
  wa_fcat-fieldname = 'TELEFONE' .
  wa_fcat-tabname = 'LT_PRODUTOR' .
  wa_fcat-seltext_m = 'TELEFONE' .
  wa_fcat-outputlen = 12.
  wa_fcat-edit = 'X'.
  wa_fcat-lowercase = 'X'.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '9' .
  wa_fcat-fieldname = 'CNPJ_PRODUTOR' .
  wa_fcat-tabname = 'LT_PRODUTOR' .
  wa_fcat-seltext_m = 'CNPJ' .
  wa_fcat-outputlen = 18.
  wa_fcat-edit = 'X'.
  wa_fcat-lowercase = 'X'.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '10' .
  wa_fcat-fieldname = 'DATA_REGISTRO' .
  wa_fcat-tabname = 'LT_PRODUTOR' .
  wa_fcat-seltext_m = 'DATA REGISTRO' .
  wa_fcat-outputlen = 15.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '11' .
  wa_fcat-fieldname = 'ANALISE_CREDITO' .
  wa_fcat-tabname = 'LT_PRODUTOR' .
  wa_fcat-seltext_m = 'ANALISE' .
  wa_fcat-outputlen = 8.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
*  wa_sort-spos      = 1.
*  wa_sort-fieldname = 'COD_PRODUTOR'.
*  wa_sort-up        = 'X'.
*  wa_sort-subtot    = 'X'.
*  APPEND wa_sort TO it_sort.
*--------------------------------------*
ENDFORM.


*&---------------------------------------------------------------------*
*& Form zf_build_layout
*&---------------------------------------------------------------------*
FORM zf_build_layout .
*  ls_layout-colwidth_optimize = 'X'.
  ls_layout-zebra             = 'X'.
*  ls_layout-info_fieldname = 'COR'.
*  ls_layout-coltab_fieldname = 'COR'.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form zf_build_events
*&---------------------------------------------------------------------*
FORM zf_build_events.
  DATA: vl_index  LIKE sy-tabix,
        wa_events LIKE LINE OF gt_events.

  CALL FUNCTION 'REUSE_ALV_EVENTS_GET'
    EXPORTING
      i_list_type = 0
    IMPORTING
      et_events   = gt_events[].

  READ TABLE gt_events INTO wa_events WITH KEY name =  slis_ev_pf_status_set.

  IF sy-subrc = 0.

    vl_index = sy-tabix.
    wa_events-form = 'ZPF_STATUS'.
    MODIFY gt_events FROM wa_events INDEX vl_index.

  ENDIF.

  s_excluding-fcode = '&INFO'.
  APPEND s_excluding TO it_excluding.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form zf_display_alv
*&---------------------------------------------------------------------*
FORM zf_display_alv .

  DATA vl_repid LIKE sy-repid.
  vl_repid = sy-repid.

  DATA ls_grid_settings TYPE lvc_s_glay.
  ls_grid_settings-edt_cll_cb = 'X'.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK        = ' '
*     I_BYPASSING_BUFFER       = ' '
*     I_BUFFER_ACTIVE          = ' '
      i_callback_program       = vl_repid
      i_callback_pf_status_set = 'ZPF_STATUS'
      i_callback_user_command  = 'ZF_USER_COMMAND'
*     I_CALLBACK_TOP_OF_PAGE   = ' '
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME         =
*     I_BACKGROUND_ID          = ' '
*     I_GRID_TITLE             =
      i_grid_settings          = ls_grid_settings
      is_layout                = ls_layout
      it_fieldcat              = it_fcat
      it_excluding             = it_excluding[]
*     IT_SPECIAL_GROUPS        =
      it_sort                  = it_sort
*     IT_FILTER                =
*     IS_SEL_HIDE              =
*     I_DEFAULT                = 'X'
      i_save                   = 'A'
*     IS_VARIANT               =
      it_events                = gt_events[]
*     IT_EVENT_EXIT            =
*     IS_PRINT                 =
*     IS_REPREP_ID             =
*     I_SCREEN_START_COLUMN    = 0
*     I_SCREEN_START_LINE      = 0
*     I_SCREEN_END_COLUMN      = 0
*     I_SCREEN_END_LINE        = 0
*     I_HTML_HEIGHT_TOP        = 0
*     I_HTML_HEIGHT_END        = 0
*     IT_ALV_GRAPHICS          =
*     IT_HYPERLINK             =
*     IT_ADD_FIELDCAT          =
*     IT_EXCEPT_QINFO          =
*     IR_SALV_FULLSCREEN_ADAPTER        =
*     O_PREVIOUS_SRAL_HANDLER  =
*   IMPORTING
*     E_EXIT_CAUSED_BY_CALLER  =
*     ES_EXIT_CAUSED_BY_USER   =
    TABLES
      t_outtab                 = lt_produtor
*   EXCEPTIONS
*     PROGRAM_ERROR            = 1
*     OTHERS                   = 2
    .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form zf_user_command
*&---------------------------------------------------------------------*
FORM zf_user_command USING vl_ucomm LIKE sy-ucomm
                           rs_selfield TYPE slis_selfield.

  DATA: ref_grid TYPE REF TO cl_gui_alv_grid.

  IF ref_grid IS INITIAL.
    CALL FUNCTION 'GET_GLOBALS_FROM_SLVC_FULLSCR'
      IMPORTING
        e_grid = ref_grid.
  ENDIF.

  IF NOT ref_grid IS INITIAL.
    CALL METHOD ref_grid->check_changed_data.
  ENDIF.

  CASE vl_ucomm.
    WHEN 'INS'. "Insere linha

      CALL SCREEN 100.

    WHEN 'DEL'. "Ao apertar o botão de Delete

      PERFORM zf_delete.

    WHEN '&DATA_SAVE' OR 'SAVE'. "Ao clicar no botão de salvar

      PERFORM zf_save_data.

    WHEN '&REFRESH'. "Ao clicar no botão de refresh

      PERFORM zf_select.

    WHEN 'CSV'.

      PERFORM zf_download_csv.

    WHEN OTHERS.
  ENDCASE.
  PERFORM zf_select.
  rs_selfield-refresh = 'X'.
  rs_selfield-row_stable = 'X'.
  rs_selfield-col_stable = 'X'.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form zpf_status
*&---------------------------------------------------------------------*
FORM zpf_status USING icon_extab.
  SET PF-STATUS 'ZMENU_PRODUTOR' EXCLUDING icon_extab.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form zf_delete
*&---------------------------------------------------------------------*
FORM zf_delete.

  DATA ans TYPE c.
  LOOP AT lt_produtor INTO ls_produtor.
    IF ls_produtor-checkbox = 'X'.

      CALL FUNCTION 'POPUP_TO_CONFIRM'
        EXPORTING
          titlebar              = 'Confirmação Delete'
          text_question         = 'Proseguir com Remoção?'
          text_button_1         = 'PROSSEGUIR'
          icon_button_1         = 'ICON_CHECKED'
          text_button_2         = 'CANCELAR'
          icon_button_2         = 'ICON_CANCEL'
          display_cancel_button = ' '
          popup_type            = 'ICON_MESSAGE_ERROR'
        IMPORTING
          answer                = ans.
      IF ans = 2.
        MESSAGE i000 WITH 'Remoção cancelada'.
        EXIT.
      ELSE.

        DELETE FROM zprod_aluno07
          WHERE cod_produtor = ls_produtor-cod_produtor AND cnpj_produtor = ls_produtor-cnpj_produtor.

        IF sy-subrc = 0.
          COMMIT WORK AND WAIT.
          MESSAGE i000 WITH 'Eliminado com sucesso'.

        ELSE.
          ROLLBACK WORK.
          MESSAGE i000 WITH 'Não conseguiu eliminar'.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDLOOP.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form zf_save_data
*&---------------------------------------------------------------------*
FORM zf_save_data.

  LOOP AT lt_produtor INTO ls_produtor.
    IF ls_produtor-checkbox = 'X'.

      UPDATE zprod_aluno07
      SET cod_produtor    = ls_produtor-cod_produtor
          nome_produtor   = ls_produtor-nome_produtor
          logradouro      = ls_produtor-logradouro
          numero          = ls_produtor-numero
          bairro          = ls_produtor-bairro
          cidade          = ls_produtor-cidade
          estado          = ls_produtor-estado
          telefone        = ls_produtor-telefone
          cnpj_produtor   = ls_produtor-cnpj_produtor
          data_registro   = ls_produtor-data_registro
          analise_credito = ls_produtor-analise_credito
       WHERE cod_produtor = ls_produtor-cod_produtor AND cnpj_produtor = ls_produtor-cnpj_produtor.

      IF sy-subrc = 0.
        COMMIT WORK AND WAIT.
        MESSAGE i000 WITH 'Alterado com sucesso'.
      ELSE.
        ROLLBACK WORK.
        MESSAGE i000 WITH 'Não foi alterado'.
      ENDIF.

    ENDIF.
    ls_produtor-checkbox = ''.
  ENDLOOP.

ENDFORM.

INCLUDE zedu_manut_produtor_pbo.
INCLUDE zedu_manut_produtor_pai.


*&---------------------------------------------------------------------*
*& Form zf_download_csv
*&---------------------------------------------------------------------*
FORM zf_download_csv .

  DATA lt_prod_csv TYPE truxs_t_text_data.

  PERFORM zf_caminho_local.

  CALL FUNCTION 'SAP_CONVERT_TO_CSV_FORMAT'
    EXPORTING
      i_field_seperator    = ';'
*     I_LINE_HEADER        =
*     I_FILENAME           =
*     I_APPL_KEEP          = ' '
    TABLES
      i_tab_sap_data       = lt_produtor
    CHANGING
      i_tab_converted_data = lt_prod_csv
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
    MESSAGE: i000 WITH 'Falha ao converter'.
  ELSE.
    CALL FUNCTION 'GUI_DOWNLOAD'
      EXPORTING
        "Precisa ser um arquivo no seu computador"
        "Mudar para o usuário escolher"
        filename = file
      TABLES
        data_tab = lt_prod_csv
      EXCEPTIONS
        OTHERS   = 1.
    IF sy-subrc <> 0.
      MESSAGE: i000 WITH 'Falha ao baixar'.
    ELSE.
      MESSAGE: i000 WITH 'Arquivo baixado'.
    ENDIF.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form zf_caminho_local
*&---------------------------------------------------------------------*
FORM zf_caminho_local .

  DATA: vl_caminho TYPE string.
  DATA: tp_file TYPE string.
  tp_file = '.csv'.

  CALL METHOD cl_gui_frontend_services=>directory_browse
    EXPORTING
      window_title    = 'Escolha uma pasta'
      initial_folder  = 'C:\'
    CHANGING
      selected_folder = vl_caminho
    EXCEPTIONS
      cntl_error      = 1
      error_no_gui    = 2
      OTHERS          = 3.

  IF sy-subrc <> 0.
    MESSAGE i000 WITH 'Falha ao buscar caminho'.
  ENDIF.

  CONCATENATE vl_caminho '\Produtores_' sy-datum tp_file INTO file.

ENDFORM.


************************************************************************
* NOME DO PROGRAMA    :  ZEDU_CARGA_FRUTAS                             *
* TRANSAÇÃO           :                                                *
* TÍTULO DO PROGRAMA  : Carga em massa frutas                          *
* DESCRIÇÃO           : Carregar arquivo local ou em rede para inserir *
*                       na tabela ZFRUTA_ALUNO07                       *
* PROGRAMADOR         : Eduardo Freitas Moura (EFREITAS)               *
* DATA                : 24.02.2022                                     *
************************************************************************
REPORT zedu_carga_frutas MESSAGE-ID zcm_efmoura.

TABLES: zfruta_aluno07, zprod_aluno07, tcurc.

"----------TIPOS---------"
TYPES:
  BEGIN OF tp_linha,
    linha(500) TYPE c,
  END OF tp_linha,

  BEGIN OF tp_codprod,
    cod_produtor TYPE zprod_aluno07-cod_produtor,
  END OF tp_codprod,

  BEGIN OF tp_moedas,
    waers TYPE tcurc-waers,
  END OF tp_moedas,

  BEGIN OF tp_download,
    id_produtor(10) TYPE c,
    nome_fruta(40)  TYPE c,
    tp_fruta(20)    TYPE c,
    safra_fruta(8)  TYPE c,
    qtde_fruta(13)  TYPE c,
    unmed_fruta(3)  TYPE c,
    punit_fruta(13) TYPE c,
    moeda_fruta(5)  TYPE c,
  END OF tp_download.

"---TABELAS_INTERNAS---"
DATA: lt_linha    TYPE STANDARD TABLE OF tp_linha WITH HEADER LINE,
      lt_download TYPE TABLE OF tp_download,
      lt_xlsxload TYPE TABLE OF alsmex_tabline,
      lt_codprod  TYPE TABLE OF tp_codprod,
      lt_moedas   TYPE TABLE OF tp_moedas.

"------ESTRUTURAS------"
DATA: ls_linha    TYPE tp_linha,
      ls_download TYPE tp_download,
      ls_xlsxload TYPE alsmex_tabline.

"--------GLOBAIS-------"
DATA: lv_max(10) TYPE c,
      currline   TYPE i,
      data(10)   TYPE c.


"-----------------TELA DE SELEÇÂO-----------------"
SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-001.

  PARAMETERS: p_carga LIKE rlgrap-filename.

SELECTION-SCREEN END OF BLOCK b01.
SELECTION-SCREEN SKIP 1.
SELECTION-SCREEN BEGIN OF BLOCK b02 WITH FRAME TITLE TEXT-002.

  PARAMETERS: p_csv  RADIOBUTTON GROUP grp2,
              p_xlsx RADIOBUTTON GROUP grp2.

SELECTION-SCREEN END OF BLOCK b02.
SELECTION-SCREEN SKIP 1.
SELECTION-SCREEN BEGIN OF BLOCK b03 WITH FRAME TITLE TEXT-003.

  PARAMETERS: p_local RADIOBUTTON GROUP grp1,
              p_rede  RADIOBUTTON GROUP grp1.
SELECTION-SCREEN END OF BLOCK b03.

"----------------VALIDAÇÃO DE TELA----------------"

AT SELECTION-SCREEN.
  IF p_carga IS INITIAL.
    MESSAGE e002. "Mensagem de erro impede continuação da seleção"
  ENDIF.


AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_carga.

  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      program_name  = syst-cprog
      dynpro_number = syst-dynnr
      field_name    = ' '
    IMPORTING
      file_name     = p_carga.

*      CALL FUNCTION 'F4_DXFILENAME_TOPRECURSION'


  "----------------INICIO_DA_SELEÇÃO----------------"

START-OF-SELECTION.

  IF p_local = 'X'.
    PERFORM zf_leitura_local.
  ELSEIF p_rede = 'X'.
    PERFORM zf_leitura_rede.
  ENDIF.

  PERFORM zf_valida_dados.


*&---------------------------------------------------------------------*
*& Form zf_leitura_local
*&---------------------------------------------------------------------*
FORM zf_leitura_local .
  CASE 'X'.
    WHEN p_csv.
      PERFORM zf_local_csv.

    WHEN p_xlsx.
      PERFORM zf_local_xlsx.
  ENDCASE.
ENDFORM.

FORM zf_local_csv.
  DATA: lv_arq TYPE string.
  lv_arq = p_carga.

  CALL FUNCTION 'GUI_UPLOAD'
    EXPORTING
      filename        = lv_arq
      filetype        = 'ASC'
    TABLES
      data_tab        = lt_linha
    EXCEPTIONS
      file_open_error = 1
      OTHERS          = 2.
  IF sy-subrc <> 0.
    MESSAGE e001.
  ENDIF.

  LOOP AT lt_linha INTO ls_linha.
    SPLIT ls_linha AT ';' INTO
          ls_download-id_produtor
          ls_download-nome_fruta
          ls_download-tp_fruta
*          ls_download-safra_fruta
          data
          ls_download-qtde_fruta
          ls_download-unmed_fruta
          ls_download-punit_fruta
          ls_download-moeda_fruta.


    PERFORM zf_date_transformation.

    APPEND ls_download TO lt_download.
  ENDLOOP.

ENDFORM.

FORM zf_local_xlsx.
  CALL FUNCTION 'ALSM_EXCEL_TO_INTERNAL_TABLE' "Só pega os 3 primeiros registros
    EXPORTING
      filename                = p_carga
      i_begin_col             = 1
      i_begin_row             = 1
      i_end_col               = 8
      i_end_row               = 3
    TABLES
      intern                  = lt_xlsxload
    EXCEPTIONS
      inconsistent_parameters = 1
      upload_ole              = 2
      OTHERS                  = 3.
  IF sy-subrc <> 0.
    MESSAGE e001.
  ENDIF.

* Carrega dados na tabela interna
  currline = 0.
  LOOP AT lt_xlsxload INTO ls_xlsxload.

    IF currline = 0.
      currline = ls_xlsxload-row.
    ENDIF.

    IF currline <> ls_xlsxload-row.
      currline = ls_xlsxload-row.
      APPEND ls_download TO lt_download.
    ENDIF.

    CASE ls_xlsxload-col.
      WHEN 1.
        ls_download-id_produtor = ls_xlsxload-value.
      WHEN 2.
        ls_download-nome_fruta = ls_xlsxload-value.
      WHEN 3.
        ls_download-tp_fruta = ls_xlsxload-value.
      WHEN 4.
        data = ls_xlsxload-value.
        PERFORM zf_date_transformation.
      WHEN 5.
        ls_download-qtde_fruta = ls_xlsxload-value.
      WHEN 6.
        ls_download-unmed_fruta = ls_xlsxload-value.
      WHEN 7.
        ls_download-punit_fruta = ls_xlsxload-value.
      WHEN 8.
        ls_download-moeda_fruta = ls_xlsxload-value.
      WHEN OTHERS.
    ENDCASE.

  ENDLOOP.

  APPEND ls_download TO lt_download.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form zf_leitura_rede
*&---------------------------------------------------------------------*
FORM zf_leitura_rede .

  OPEN DATASET p_carga FOR INPUT IN TEXT MODE ENCODING DEFAULT.

  IF sy-subrc = 0.
    DO.
      READ DATASET p_carga INTO lt_linha.
      IF sy-subrc <> 0.
        EXIT.
      ENDIF.
      SPLIT ls_linha AT ';' INTO
            ls_download-id_produtor
            ls_download-nome_fruta
            ls_download-tp_fruta
            data
            ls_download-qtde_fruta
            ls_download-unmed_fruta
            ls_download-punit_fruta
            ls_download-moeda_fruta.

      PERFORM zf_date_transformation.
      APPEND ls_download TO lt_download.
    ENDDO.
    CLOSE DATASET p_carga.
  ELSE.
    MESSAGE e001.
  ENDIF.


ENDFORM.

FORM zf_date_transformation.


   CALL FUNCTION 'CONVERSION_EXIT_PDATE_INPUT'
     EXPORTING
       input              = data
    IMPORTING
      OUTPUT             = ls_download-safra_fruta
    EXCEPTIONS
      INVALID_DATE       = 1
      OTHERS             = 2
             .
   IF sy-subrc <> 0.
* Implement suitable error handling here
   ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form zf_valida_dados
*&---------------------------------------------------------------------*
FORM zf_valida_dados .


  "Buscar maior valor de id_fruta
  SELECT MAX( id_fruta )
    FROM zfruta_aluno07
    INTO lv_max.


  SELECT zprod_aluno07~cod_produtor
    FROM zprod_aluno07
    INTO TABLE lt_codprod[].

  SELECT tcurc~waers
    FROM tcurc
    INTO TABLE lt_moedas[].

  LOOP AT lt_download INTO ls_download.

    lv_max += 1.

    "Validação do Produtor
    READ TABLE lt_codprod TRANSPORTING NO FIELDS WITH KEY cod_produtor = ls_download-id_produtor.
    IF sy-subrc <> 0.
      lv_max -= 1.
      CONTINUE.
    ENDIF.

    "Validação de unidade de medida
    CALL FUNCTION 'CONVERSION_EXIT_CUNIT_INPUT'
      EXPORTING
        input          = ls_download-unmed_fruta
        language       = sy-langu
      IMPORTING
        output         = ls_download-unmed_fruta
      EXCEPTIONS
        unit_not_found = 1
      .  "  CONVERSION_EXIT_CUNIT_INPUT
    IF sy-subrc <> 0.
      lv_max -= 1.
      CONTINUE.
    ENDIF.

    "Validação de valor -> mudar vírgula por ponto
    REPLACE ALL OCCURRENCES OF ',' IN ls_download-punit_fruta WITH '.'.
    IF sy-subrc <> 0.
      lv_max -= 1.
      CONTINUE.
    ENDIF.

    "Validação de moeda
    READ TABLE lt_moedas TRANSPORTING NO FIELDS WITH KEY waers = ls_download-moeda_fruta.
    IF sy-subrc <> 0.
      lv_max -= 1.
      CONTINUE.
    ENDIF.

    "Inserir na tabela
    PERFORM zf_insert.

  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form zf_update
*&---------------------------------------------------------------------*
FORM zf_insert .

  zfruta_aluno07-id_fruta     = lv_max.
  zfruta_aluno07-id_produtor  = ls_download-id_produtor.
  zfruta_aluno07-nome_fruta   = ls_download-nome_fruta.
  zfruta_aluno07-tp_fruta     = ls_download-tp_fruta.
  zfruta_aluno07-safra_fruta  = ls_download-safra_fruta.
  zfruta_aluno07-qtde_fruta   = ls_download-qtde_fruta.
  zfruta_aluno07-unmed_fruta  = ls_download-unmed_fruta.
  zfruta_aluno07-punit_fruta  = ls_download-punit_fruta.
  zfruta_aluno07-moeda_fruta  = ls_download-moeda_fruta.

  INSERT zfruta_aluno07.
  IF sy-subrc = 0.
    COMMIT WORK AND WAIT.
    WRITE: / ls_download-nome_fruta, 40 'Foi Adicionado.'.
  ELSE.
    WRITE: / ls_download-nome_fruta, 40 'Não Adicionado.'.
  ENDIF.
ENDFORM.


************************************************************************
* NOME DO PROGRAMA    :  ZEDU_CARGA_PRODUTOR                           *
* TRANSAÇÃO           :                                                *
* TÍTULO DO PROGRAMA  : Carga em massa produtor                        *
* DESCRIÇÃO           : Carregar arquivo local ou em rede para inserir *
*                       na tabela ZPROD_ALUNO07                        *
* PROGRAMADOR         : Eduardo Freitas Moura (EFREITAS)               *
* DATA                : 23.02.2022                                     *
************************************************************************
REPORT zedu_carga_produtor MESSAGE-ID zcm_efmoura.

TABLES: zfruta_aluno07, zprod_aluno07, t005u, zcad_ddd.

"----------TIPOS---------"
TYPES:
  BEGIN OF tp_linha,
    linha(500) TYPE c,
  END OF tp_linha,

  BEGIN OF tp_estado,
    estado TYPE t005u-bland,
  END OF tp_estado,

  BEGIN OF tp_ddd,
    ddd_bland TYPE zcad_ddd-ddd_bland,
  END OF tp_ddd,

  BEGIN OF tp_download,
    nome_produtor(40)  TYPE c,
    logradouro(80)     TYPE c,
    numero(5)          TYPE c,
    bairro(30)         TYPE c,
    cidade(30)         TYPE c,
    estado(2)          TYPE c,
    telefone(15)       TYPE c,
    cnpj_produtor(18)  TYPE c,
*   data_registro(8)   TYPE c,
    analise_credito(1) TYPE c,
  END OF tp_download.

"---TABELAS_INTERNAS---"
DATA: lt_linha    TYPE STANDARD TABLE OF tp_linha WITH HEADER LINE,
      lt_download TYPE TABLE OF tp_download,
      lt_xlsxload TYPE TABLE OF alsmex_tabline,
      lt_estados  TYPE TABLE OF tp_estado,
      lt_ddd      TYPE TABLE OF tp_ddd.

"------ESTRUTURAS------"
DATA: ls_linha    TYPE tp_linha,
      ls_download TYPE tp_download,
      ls_xlsxload TYPE alsmex_tabline.

"--------GLOBAIS-------"
DATA: lv_max   TYPE zprod_aluno07-cod_produtor,
      currline TYPE i.


"-----------------TELA DE SELEÇÂO-----------------"
SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-001.

  PARAMETERS: p_carga LIKE rlgrap-filename.

SELECTION-SCREEN END OF BLOCK b01.
SELECTION-SCREEN SKIP 1.
SELECTION-SCREEN BEGIN OF BLOCK b02 WITH FRAME TITLE TEXT-002.

  PARAMETERS: p_csv  RADIOBUTTON GROUP grp2,
              p_xlsx RADIOBUTTON GROUP grp2.

SELECTION-SCREEN END OF BLOCK b02.
SELECTION-SCREEN SKIP 1.
SELECTION-SCREEN BEGIN OF BLOCK b03 WITH FRAME TITLE TEXT-003.

  PARAMETERS: p_local RADIOBUTTON GROUP grp1,
              p_rede  RADIOBUTTON GROUP grp1.
SELECTION-SCREEN END OF BLOCK b03.

"----------------VALIDAÇÃO DE TELA----------------"

AT SELECTION-SCREEN.
  IF p_carga IS INITIAL.
    MESSAGE e002. "Mensagem de erro impede continuação da seleção"
  ENDIF.


AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_carga.

  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      program_name  = syst-cprog
      dynpro_number = syst-dynnr
      field_name    = ' '
    IMPORTING
      file_name     = p_carga.


  "----------------INICIO_DA_SELEÇÃO----------------"

START-OF-SELECTION.

  IF p_local = 'X'.
    PERFORM zf_leitura_local.
  ELSEIF p_rede = 'X'.
    PERFORM zf_leitura_rede.
  ENDIF.

  PERFORM zf_valida_dados.


*&---------------------------------------------------------------------*
*& Form zf_leitura_local
*&---------------------------------------------------------------------*
FORM zf_leitura_local .

  CASE 'X'.
    WHEN p_csv.
      PERFORM zf_local_csv.

    WHEN p_xlsx.
      PERFORM zf_local_xlsx.
  ENDCASE.


ENDFORM.

FORM zf_local_csv.
  DATA: lv_arq TYPE string.
  lv_arq = p_carga.

  CALL FUNCTION 'GUI_UPLOAD'
    EXPORTING
      filename        = lv_arq
      filetype        = 'ASC'
    TABLES
      data_tab        = lt_linha
    EXCEPTIONS
      file_open_error = 1
      OTHERS          = 2.

  LOOP AT lt_linha INTO ls_linha.
    SPLIT ls_linha AT ';' INTO
*         ls_prodcarga-cod_produtor
          ls_download-nome_produtor
          ls_download-logradouro
          ls_download-numero
          ls_download-bairro
          ls_download-cidade
          ls_download-estado
          ls_download-telefone
          ls_download-cnpj_produtor
*         ls_pdownload-data_registro
          ls_download-analise_credito.
    APPEND ls_download TO lt_download.
  ENDLOOP.

ENDFORM.

FORM zf_local_xlsx.
  CALL FUNCTION 'ALSM_EXCEL_TO_INTERNAL_TABLE' "Só pega os 3 primeiros registros
    EXPORTING
      filename                = p_carga
      i_begin_col             = 1
      i_begin_row             = 1
      i_end_col               = 9
      i_end_row               = 3
    TABLES
      intern                  = lt_xlsxload
    EXCEPTIONS
      inconsistent_parameters = 1
      upload_ole              = 2
      OTHERS                  = 3.
  IF sy-subrc <> 0.
    MESSAGE e001.
  ENDIF.

* Carrega dados na tabela interna
  currline = 0.
  LOOP AT lt_xlsxload INTO ls_xlsxload.

    IF currline = 0.
      currline = ls_xlsxload-row.
    ENDIF.

    IF currline <> ls_xlsxload-row.
      currline = ls_xlsxload-row.
      APPEND ls_download TO lt_download.
    ENDIF.

    CASE ls_xlsxload-col.
      WHEN 1.
        ls_download-nome_produtor = ls_xlsxload-value.
      WHEN 2.
        ls_download-logradouro = ls_xlsxload-value.
      WHEN 3.
        ls_download-numero = ls_xlsxload-value.
      WHEN 4.
        ls_download-bairro = ls_xlsxload-value.
      WHEN 5.
        ls_download-cidade = ls_xlsxload-value.
      WHEN 6.
        ls_download-estado = ls_xlsxload-value.
      WHEN 7.
        ls_download-telefone = ls_xlsxload-value.
      WHEN 8.
        ls_download-cnpj_produtor = ls_xlsxload-value.
      WHEN 9.
        ls_download-analise_credito = ls_xlsxload-value.
      WHEN OTHERS.
    ENDCASE.

  ENDLOOP.

  APPEND ls_download TO lt_download.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form zf_leitura_rede
*&---------------------------------------------------------------------*
FORM zf_leitura_rede .

  CASE 'X'.
    WHEN p_csv.
      PERFORM zf_leitura_rede_csv.

    WHEN p_xlsx.
      PERFORM zf_leitura_rede_xlsx.
  ENDCASE.


ENDFORM.


FORM zf_leitura_rede_csv.
  OPEN DATASET p_carga FOR INPUT IN TEXT MODE ENCODING DEFAULT.

  IF sy-subrc = 0.
    DO.
      READ DATASET p_carga INTO lt_linha.
      IF sy-subrc <> 0.
        EXIT.
      ENDIF.
      SPLIT lt_linha AT ';' INTO
*               ls_prodcarga-cod_produtor
                ls_download-nome_produtor
                ls_download-logradouro
                ls_download-numero
                ls_download-bairro
                ls_download-cidade
                ls_download-estado
                ls_download-telefone
                ls_download-cnpj_produtor
*               ls_download-data_registro
                ls_download-analise_credito.
      APPEND ls_download TO lt_download.
    ENDDO.
    CLOSE DATASET p_carga.
  ELSE.
    MESSAGE e001.
  ENDIF.
ENDFORM.


FORM zf_leitura_rede_xlsx.
  OPEN DATASET p_carga FOR INPUT IN TEXT MODE ENCODING DEFAULT.

  IF sy-subrc = 0.
    DO.
      READ DATASET p_carga INTO lt_linha.
      IF sy-subrc <> 0.
        EXIT.
      ENDIF.
      SPLIT lt_linha AT '|' INTO
*                     ls_prodcarga-cod_produtor
                      ls_download-nome_produtor
                      ls_download-logradouro
                      ls_download-numero
                      ls_download-bairro
                      ls_download-cidade
                      ls_download-estado
                      ls_download-telefone
                      ls_download-cnpj_produtor
*                     ls_download-data_registro
                      ls_download-analise_credito.
      APPEND ls_download TO lt_download.
    ENDDO.
    CLOSE DATASET p_carga.
  ELSE.
    MESSAGE e001.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form zf_valida_dados
*&---------------------------------------------------------------------*
FORM zf_valida_dados .

  "Buscar maior valor de cod_produtor
  SELECT MAX( cod_produtor )
    FROM zprod_aluno07
    INTO lv_max.

  SELECT t005u~bland
    FROM t005u
    INTO TABLE lt_estados[]
    WHERE t005u~land1 = 'BR'
    GROUP BY bland.

  SELECT ddd_bland
    FROM zcad_ddd
    INTO TABLE lt_ddd.

  LOOP AT lt_download INTO ls_download.

    lv_max += 1.

    "Conversão e Validação do CNPJ
    CALL FUNCTION 'CONVERSION_EXIT_CGCBR_INPUT' "Conversion Function for CGC - Screen -> Internal Data
      EXPORTING
        input     = ls_download-cnpj_produtor       "   CNPJ in screen format (99.999.999/9999-99)
      IMPORTING
        output    = ls_download-cnpj_produtor       "  CNPJ in internal format (NUMC 14)
      EXCEPTIONS
        not_valid = 1.
    IF sy-subrc = 1.
      lv_max -= 1.
      CONTINUE.
    ENDIF.

"    validar ddd"
    READ TABLE lt_ddd TRANSPORTING NO FIELDS WITH KEY ddd_bland = zprod_aluno07-telefone+1(2).
    IF sy-subrc = 0.
      lv_max -= 1.
      CONTINUE.
    ENDIF.

    "Validação do Estado
    READ TABLE lt_estados TRANSPORTING NO FIELDS WITH KEY estado = ls_download-estado.
    IF sy-subrc <> 0.
      lv_max -= 1.
      CONTINUE.
    ENDIF.

    PERFORM zf_insert.

  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form zf_update
*&---------------------------------------------------------------------*
FORM zf_insert .

  zprod_aluno07-cod_produtor  = lv_max.
  zprod_aluno07-nome_produtor = ls_download-nome_produtor.
  zprod_aluno07-logradouro    = ls_download-logradouro.
  zprod_aluno07-numero        = ls_download-numero.
  zprod_aluno07-bairro        = ls_download-bairro.
  zprod_aluno07-cidade        = ls_download-cidade.
  zprod_aluno07-estado        = ls_download-estado.
  zprod_aluno07-telefone      = ls_download-telefone.
  zprod_aluno07-cnpj_produtor = ls_download-cnpj_produtor.
  zprod_aluno07-data_registro = sy-datum.
  zprod_aluno07-analise_credito = ls_download-analise_credito.

  INSERT zprod_aluno07.

  IF sy-subrc = 0.
    COMMIT WORK AND WAIT.
    WRITE: / ls_download-nome_produtor, 40 'Foi Adicionado.'.
  ELSE.
    WRITE: / ls_download-nome_produtor, 40 'Não Adicionado.'.
  ENDIF.
ENDFORM.
