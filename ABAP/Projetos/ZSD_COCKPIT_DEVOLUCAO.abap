***********************************************************************
* NOME DO PROGRAMA    : ZSD_COCKPIT_DEVOLUCAO                         *
* TRANSAÇÃO           :                                               *
* TÍTULO DO PROGRAMA  : Cockpit devolução                             *
* PROGRAMADOR         : Eduardo Freitas Moura (EMOURA)                *
* DATA                : 08.04.2022                                    *
***********************************************************************
REPORT zsd_cockpit_devolucao.

INCLUDE zf_cockpit_devolucao_top.
INCLUDE zf_cockpit_devolucao_lcl.

"----------------INICIO_DA_SELEÇÃO----------------"
START-OF-SELECTION.

  CALL SCREEN 100.

  "Include com todos os forms de criação da alv tree
  INCLUDE zf_menu_tree_forms.
  "Include com todos os forms de criação da alv ordem
  INCLUDE zf_alv_ordem_forms.
  "Include com todos os forms de criação da alv remessa
  INCLUDE zf_alv_remessa_forms.
  "Include com todos os forms de criação da alv fatura
  INCLUDE zf_alv_fatura_forms.

*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'ZSTATUS_0100'.
* SET TITLEBAR 'xxx'.

  PERFORM zf_init_dragdrop.

  wa_layout-no_toolbar = 'X'.
*  wa_layout-cwidth_opt = 'X'.
  wa_layout-s_dragdrop-row_ddid = g_handle_alv.

  IF g_menu_tree IS INITIAL.
    PERFORM zf_menu_tree.
  ENDIF.
  IF g_menu_ordem IS INITIAL.
    PERFORM zf_alv_ordem.
  ENDIF.
  IF g_menu_remessa IS INITIAL.
    PERFORM zf_alv_remessa.
  ENDIF.
  IF g_menu_fatura IS INITIAL.
    PERFORM zf_alv_fatura.
  ENDIF.
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
    WHEN 'CANC' OR 'ENDE'.
      CALL METHOD g_menu_ordem->free.
      CALL METHOD g_menu_tree->free.
      CALL METHOD g_custom01->free.
      CALL METHOD g_custom02->free.
      LEAVE PROGRAM.

    WHEN OTHERS.
  ENDCASE.

ENDMODULE.

*&---------------------------------------------------------------------*
*& Form zf_init_dragdrop
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM zf_init_dragdrop.

  g_effect = cl_dragdrop=>move + cl_dragdrop=>copy.

  CREATE OBJECT dragdrop_tree.
  CALL METHOD dragdrop_tree->add
    EXPORTING
      flavor     = 'LINE'
      dragsrc    = 'X'
      droptarget = 'X'
      effect     = g_effect.
  CALL METHOD dragdrop_tree->get_handle
    IMPORTING
      handle = g_handle_tree.

  CREATE OBJECT dragdrop_alv.
  CALL METHOD dragdrop_alv->add
    EXPORTING
      flavor     = 'LINE'
      dragsrc    = 'X'
      droptarget = 'X'
      effect     = g_effect.
  CALL METHOD dragdrop_alv->get_handle
    IMPORTING
      handle = g_handle_alv.

ENDFORM.

*&---------------------------------------------------------------------*
*& Include          ZF_COCKPIT_DEVOLUCAO_TOP
*&---------------------------------------------------------------------*

"--------------------TABELAS---------------------"
TABLES: vbap, vbak.

"---------------------TIPOS----------------------"
TYPES:
  BEGIN OF tp_ordem,
    vbeln     TYPE vbrp-vbeln,
    posnr     TYPE vbrp-posnr,
    matnr     TYPE vbrp-matnr,
    arktx     TYPE vbrp-arktx,
    fkimg     TYPE vbrp-fkimg,
    meins     TYPE vbrp-meins,
    netwr     TYPE vbrp-netwr,
    ordem(10) TYPE n,
    item(6)   TYPE n,
    depot(4)  TYPE c,
  END OF tp_ordem,

  BEGIN OF tp_remessa,
    ordem(10)   TYPE n,
    item(6)     TYPE n,
    matnr       TYPE vbrp-matnr,
    arktx       TYPE vbrp-arktx,
    fkimg       TYPE vbrp-fkimg,
    meins       TYPE vbrp-meins,
    remessa(10) TYPE n,
  END OF tp_remessa,

  BEGIN OF tp_fatura,
    ordem(10)   TYPE n,
    remessa(10) TYPE n,
  END OF tp_fatura,

  BEGIN OF tp_devolucao,
    vbeln TYPE vbrk-vbeln,
    fkart TYPE vbrk-fkart,
    xblnr TYPE vbrk-xblnr,
    posnr TYPE vbrp-posnr,
  END OF tp_devolucao.


"--------------TABELAS E ESTRUTURAS--------------"
"------DADOS------"
DATA: it_devol TYPE TABLE OF tp_devolucao,
      wa_devol TYPE tp_devolucao.

DATA: it_ordem TYPE TABLE OF tp_ordem,
      wa_ordem TYPE tp_ordem.

DATA: it_remessa TYPE TABLE OF tp_remessa,
      wa_remessa TYPE tp_remessa.

DATA: it_fatura TYPE TABLE OF tp_fatura,
      wa_fatura TYPE tp_fatura.

"---OBJETOS ALV---"
DATA: g_menu_tree    TYPE REF TO cl_gui_alv_tree,
      g_menu_ordem   TYPE REF TO cl_gui_alv_grid,
      g_menu_remessa TYPE REF TO cl_gui_alv_grid,
      g_menu_fatura  TYPE REF TO cl_gui_alv_grid.

"---CONTAINER---"
DATA: g_custom01 TYPE REF TO cl_gui_custom_container,
      g_custom02 TYPE REF TO cl_gui_custom_container,
      g_custom03 TYPE REF TO cl_gui_custom_container,
      g_custom04 TYPE REF TO cl_gui_custom_container.

"--FIELDCATALOG--"
DATA: it_fcat_01 TYPE lvc_t_fcat,
      it_fcat_02 TYPE lvc_t_fcat,
      it_fcat_03 TYPE lvc_t_fcat,
      it_fcat_04 TYPE lvc_t_fcat,

      wa_fcat    TYPE  lvc_s_fcat.

"-----LAYOUT-----"
DATA: wa_layout  TYPE lvc_s_layo.

"--------------------EVENTOS----------------------"
DATA: dragdrop_tree TYPE REF TO cl_dragdrop,
      dragdrop_alv  TYPE REF TO cl_dragdrop,

      ok_code       LIKE sy-ucomm,
      save_ok       LIKE sy-ucomm.

DATA: g_handle_alv  TYPE i,
      g_handle_tree TYPE i,
      g_effect      TYPE i.


"---------------------BAPI------------------------"
"ORDEM"
DATA: v_vbeln          LIKE vbak-vbeln,
      header           LIKE bapisdhd1,
      headerx          LIKE bapisdhd1x,
      item             LIKE bapisditm OCCURS 0 WITH HEADER LINE,
      itemx            LIKE bapisditmx OCCURS 0 WITH HEADER LINE,
      partner          LIKE bapiparnr OCCURS 0 WITH HEADER LINE,
      lt_schedules_in  TYPE STANDARD TABLE OF bapischdl WITH HEADER LINE,
      lt_schedules_inx TYPE STANDARD TABLE OF bapischdlx WITH HEADER LINE.

"REMESSA"
DATA: delivery       TYPE bapishpdelivnumb-deliv_numb,
      it_sales_items TYPE STANDARD TABLE OF bapidlvreftosalesorder,
      wa_sales_items LIKE LINE OF it_sales_items.

"RETORNO"
DATA: return LIKE bapiret2 OCCURS 0 WITH HEADER LINE,
      msg    TYPE string..

"------------------AUXILIARES---------------------"
*DATA: c_source_text TYPE lvc_value,
*      c_target_text TYPE lvc_value,
*      c_node_key    TYPE lvc_nkey,
*      index(10)     TYPE c.

"-----------------TELA DE SELEÇÂO-----------------"
SELECTION-SCREEN: BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-001.

  PARAMETERS: p_matnr TYPE vbap-matnr OBLIGATORY DEFAULT '8654',
              p_werks TYPE vbap-werks OBLIGATORY DEFAULT 'L005',
              p_kunnr TYPE vbak-kunnr OBLIGATORY DEFAULT '263'.

SELECTION-SCREEN: END OF BLOCK b01.


*&---------------------------------------------------------------------*
*& Include          ZF_COCKPIT_DEVOLUCAO_LCL
*&---------------------------------------------------------------------*
*****************************************************
"--------------------DEFINITION---------------------"
*****************************************************

CLASS cl_auxiliar_data DEFINITION.
  PUBLIC SECTION.
    DATA: c_source_text TYPE lvc_value,
          c_target_text TYPE lvc_value,
          c_node_key    TYPE lvc_nkey,
          row_index(10) TYPE n,
          index(10)     TYPE c.
ENDCLASS.

CLASS cl_ordem_receiver DEFINITION.
  PUBLIC SECTION.
    DATA: ucomm TYPE sy-ucomm.
    DATA: selfield TYPE slis_selfield.

    METHODS handle_user_command
      FOR EVENT user_command OF cl_gui_alv_grid
      IMPORTING e_ucomm.

    METHODS handle_context_menu
      FOR EVENT context_menu_request OF cl_gui_alv_grid
      IMPORTING e_object.

    METHODS handle_double_click
      FOR EVENT double_click OF cl_gui_alv_grid
      IMPORTING e_row e_column.


    METHODS handle_on_drag
      FOR EVENT ondrag OF cl_gui_alv_grid
      IMPORTING e_row
                e_column
                e_dragdropobj.

    METHODS handle_on_drop
      FOR EVENT ondrop OF cl_gui_alv_grid
      IMPORTING e_row
                e_column
                e_dragdropobj.
  PRIVATE SECTION.
ENDCLASS.

CLASS cl_remessa_receiver DEFINITION.
  PUBLIC SECTION.
    DATA: ucomm TYPE sy-ucomm.
    DATA: selfield TYPE slis_selfield.

    METHODS handle_user_command
      FOR EVENT user_command OF cl_gui_alv_grid
      IMPORTING e_ucomm.

    METHODS handle_context_menu
      FOR EVENT context_menu_request OF cl_gui_alv_grid
      IMPORTING e_object.

    METHODS handle_double_click
      FOR EVENT double_click OF cl_gui_alv_grid
      IMPORTING e_row e_column.

    METHODS handle_on_drag
      FOR EVENT ondrag OF cl_gui_alv_grid
      IMPORTING e_row
                e_column
                e_dragdropobj.

    METHODS handle_on_drop
      FOR EVENT ondrop OF cl_gui_alv_grid
      IMPORTING e_row
                e_column
                e_dragdropobj.
  PRIVATE SECTION.
ENDCLASS.

CLASS cl_fatura_receiver DEFINITION.
  PUBLIC SECTION.
    DATA: ucomm TYPE sy-ucomm.
    DATA: selfield TYPE slis_selfield.

    METHODS handle_user_command
      FOR EVENT user_command OF cl_gui_alv_grid
      IMPORTING e_ucomm.

    METHODS handle_context_menu
      FOR EVENT context_menu_request OF cl_gui_alv_grid
      IMPORTING e_object.

    METHODS handle_double_click
      FOR EVENT double_click OF cl_gui_alv_grid
      IMPORTING e_row e_column.


    METHODS handle_on_drag
      FOR EVENT ondrag OF cl_gui_alv_grid
      IMPORTING e_row
                e_column
                e_dragdropobj.

    METHODS handle_on_drop
      FOR EVENT ondrop OF cl_gui_alv_grid
      IMPORTING e_row
                e_column
                e_dragdropobj.
  PRIVATE SECTION.
ENDCLASS.

CLASS cl_tree_event_receiver DEFINITION.

  PUBLIC SECTION.

    METHODS handle_double_click
      FOR EVENT node_double_click OF cl_gui_alv_tree
      IMPORTING node_key.

    METHODS handle_on_drag
      FOR EVENT on_drag OF cl_gui_alv_tree
      IMPORTING drag_drop_object
                fieldname
                node_key.

    METHODS handle_on_drop
      FOR EVENT on_drop OF cl_gui_alv_tree
      IMPORTING drag_drop_object
                node_key.

  PRIVATE SECTION.
ENDCLASS.


*****************************************************
"------------------IMPLEMENTATION-------------------"
*****************************************************

CLASS cl_ordem_receiver IMPLEMENTATION.

  METHOD handle_user_command.
    CASE e_ucomm.
      WHEN 'ORDER'.
        PERFORM zf_criar_ordem.
      WHEN OTHERS.
    ENDCASE.
  ENDMETHOD.

  METHOD handle_context_menu.
    CALL METHOD e_object->clear.
    CALL METHOD e_object->add_function
      EXPORTING
        fcode = 'ORDER'
        text  = 'Criar Ordem'.

  ENDMETHOD.

  METHOD handle_double_click.
    IF e_column = 'ORDEM'.
      PERFORM zf_call_va03 USING e_row.
    ENDIF.
  ENDMETHOD.

  METHOD handle_on_drag.
    DATA: aux_data TYPE REF TO cl_auxiliar_data.
    CREATE OBJECT aux_data.
*     aux_data ?= e_dragdropobj->object.

    READ TABLE it_ordem INTO wa_ordem INDEX e_row.
    aux_data->c_target_text = 'G_ALV_REMESSA'.
    aux_data->c_source_text = 'G_ALV_ORDEM'.
    aux_data->index = wa_ordem-ordem.
    aux_data->row_index = e_row-index.
    e_dragdropobj->object = aux_data.


*      PERFORM remove_ordem_row USING e_row.

  ENDMETHOD.

  METHOD handle_on_drop.
    DATA: aux_data TYPE REF TO cl_auxiliar_data.
*    CREATE OBJECT aux_data.
    aux_data ?= e_dragdropobj->object.

    IF aux_data->c_source_text = 'G_MENU_TREE' AND aux_data->c_target_text = 'G_ALV_ORDEM'.
      PERFORM display_ordem USING aux_data->c_node_key.
      aux_data->c_target_text = 'G_ALV_REMESSA'.
      aux_data->c_source_text = 'G_ALV_ORDEM'.

    ENDIF.

  ENDMETHOD.
ENDCLASS.

CLASS cl_remessa_receiver IMPLEMENTATION.

  METHOD handle_user_command.
    CASE e_ucomm.
      WHEN 'REMESSA'.
        PERFORM zf_criar_remessa.
      WHEN 'SAIR_REMESSA'.
        PERFORM zf_sair_remessa.
      WHEN OTHERS.
    ENDCASE.
  ENDMETHOD.

  METHOD handle_context_menu.
    CALL METHOD e_object->clear.

    DATA: lv_row TYPE i.

    CALL METHOD g_menu_remessa->get_current_cell
      IMPORTING
        e_row = lv_row.

    READ TABLE it_remessa INTO wa_remessa INDEX lv_row.
    IF sy-subrc = 0.
      IF wa_remessa-remessa IS INITIAL.
        CALL METHOD e_object->add_function
          EXPORTING
            fcode = 'REMESSA'
            text  = 'Criar Remessa'.
      ELSE.
        CALL METHOD e_object->add_function
          EXPORTING
            fcode = 'SAIR_REMESSA'
            text  = 'Sair Remessa'.
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD handle_double_click.
    IF e_column = 'REMESSA'.
      CLEAR wa_remessa.
      READ TABLE it_remessa INTO wa_remessa INDEX e_row.

      SET PARAMETER ID 'VL' FIELD wa_remessa-remessa.
      CALL TRANSACTION 'VL03N' AND SKIP FIRST SCREEN.
    ENDIF.
  ENDMETHOD.

  METHOD handle_on_drag.

    DATA: aux_data TYPE REF TO cl_auxiliar_data.
    CREATE OBJECT aux_data.

    CLEAR wa_remessa.
    READ TABLE it_remessa INTO wa_remessa INDEX e_row.
    aux_data->c_target_text = 'G_ALV_FATURA'.
    aux_data->c_source_text = 'G_ALV_REMESSA'.
    aux_data->index = wa_remessa-remessa.
    aux_data->row_index = e_row-index.

    e_dragdropobj->object = aux_data.

  ENDMETHOD.

  METHOD handle_on_drop.
    DATA: aux_data TYPE REF TO cl_auxiliar_data.
*    CREATE OBJECT aux_data.
    aux_data ?= e_dragdropobj->object.

    IF aux_data->index IS INITIAL OR aux_data->index EQ 0000000000.
      MESSAGE: s000(zcm_efmoura) WITH 'Ordem Não criada' DISPLAY LIKE 'E'.
    ELSE.
      IF aux_data->c_source_text = 'G_ALV_ORDEM' AND aux_data->c_target_text = 'G_ALV_REMESSA'.

        PERFORM display_remessa USING aux_data->index.
*        aux_data->c_target_text = 'G_ALV_FATURA'.
*        aux_data->c_source_text = 'G_ALV_REMESSA'.
*
*        e_dragdropobj->object = aux_data.
      ENDIF.
    ENDIF.
  ENDMETHOD.
ENDCLASS.


CLASS cl_fatura_receiver IMPLEMENTATION.

  METHOD handle_user_command.
    CASE e_ucomm.
*      WHEN 'ORDER'.
*        PERFORM zf_criar_ordem.
      WHEN OTHERS.
    ENDCASE.
  ENDMETHOD.

  METHOD handle_context_menu.
    CALL METHOD e_object->clear.
*    CALL METHOD e_object->add_function
*      EXPORTING
*        fcode = 'ORDER'
*        text  = 'Criar Ordem'.

  ENDMETHOD.

  METHOD handle_double_click.

  ENDMETHOD.

  METHOD handle_on_drag.
*    DATA: data_aux TYPE REF TO cl_auxiliar_data.
*    data_aux ?= e_dragdropobj->object.
*
*    IF data_aux->c_target_text = 'G_MENU_TREE' AND data_aux->c_source_text = 'G_ALV_ORDEM'.
*    PERFORM remove_ordem_row USING e_row.
*    ENDIF.
  ENDMETHOD.

  METHOD handle_on_drop.
    DATA: aux_data TYPE REF TO cl_auxiliar_data.
*    CREATE OBJECT aux_data.
    aux_data ?= e_dragdropobj->object.

    IF aux_data->index IS INITIAL OR aux_data->index EQ 0000000000.
      MESSAGE: s000(zcm_efmoura) WITH 'Remessa Não criada' DISPLAY LIKE 'E'.
    ELSE.
      IF aux_data->c_source_text = 'G_ALV_REMESSA' AND aux_data->c_target_text = 'G_ALV_FATURA'.
        MESSAGE: i000(zcm_efmoura) WITH  aux_data->index.
      ENDIF.
    ENDIF.
  ENDMETHOD.
ENDCLASS.

CLASS cl_tree_event_receiver IMPLEMENTATION.

  METHOD handle_double_click.
    CHECK NOT node_key IS INITIAL.

    CALL METHOD g_menu_tree->get_outtab_line
      EXPORTING
        i_node_key    = node_key
      IMPORTING
        e_outtab_line = wa_devol.

    SET PARAMETER ID 'VF' FIELD wa_devol-vbeln.
    CALL TRANSACTION 'VF03' AND SKIP FIRST SCREEN.
*    PERFORM zf_call_vf03 USING node_key.

  ENDMETHOD.

  METHOD handle_on_drag.
    CHECK NOT node_key IS INITIAL.

    DATA: aux_data TYPE REF TO cl_auxiliar_data.
    CREATE OBJECT aux_data.
    aux_data->c_source_text = 'G_MENU_TREE'.
    aux_data->c_target_text = 'G_ALV_ORDEM'.
    aux_data->c_node_key = node_key.

    drag_drop_object->object = aux_data.

  ENDMETHOD.

  METHOD handle_on_drop.
*    PERFORM remove_ordem_row USING e_row.
    DATA: aux_data TYPE REF TO cl_auxiliar_data.
*    CREATE OBJECT aux_data.
    aux_data ?= drag_drop_object->object.
    IF aux_data->index IS INITIAL OR aux_data->index EQ 0000000000.
      PERFORM remove_ordem_row USING aux_data->row_index.
    ELSE.
      MESSAGE s000(zcm_efmoura) WITH 'Não há como eliminar uma ordem já preenchida' DISPLAY LIKE 'E'.
    ENDIF.
  ENDMETHOD.

ENDCLASS.

DATA: fatura_receiver  TYPE REF TO cl_fatura_receiver,
      remessa_receiver TYPE REF TO cl_remessa_receiver,
      ordem_receiver   TYPE REF TO cl_ordem_receiver,
      tree_receiver    TYPE REF TO cl_tree_event_receiver.

*&---------------------------------------------------------------------*
*& Form menu_tree
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM zf_menu_tree.

  CREATE OBJECT g_custom01
    EXPORTING
      container_name              = 'CT1'
    EXCEPTIONS
      cntl_error                  = 1
      cntl_system_error           = 2
      create_error                = 3
      lifetime_error              = 4
      lifetime_dynpro_dynpro_link = 5.

  CREATE OBJECT g_menu_tree
    EXPORTING
      parent                      = g_custom01
      node_selection_mode         = cl_gui_column_tree=>node_sel_mode_single
      item_selection              = ' '
      no_html_header              = 'X'
      no_toolbar                  = 'X'
    EXCEPTIONS
      cntl_error                  = 1
      cntl_system_error           = 2
      create_error                = 3
      lifetime_error              = 4
      illegal_node_selection_mode = 5
      failed                      = 6
      illegal_column_name         = 7.

  CREATE OBJECT tree_receiver.

  DATA l_hierarchy_header TYPE treev_hhdr.
  PERFORM: build_hierarchy_header CHANGING l_hierarchy_header,
           build_fcat_01.

  CALL METHOD g_menu_tree->set_table_for_first_display
    EXPORTING
      is_hierarchy_header = l_hierarchy_header
*     is_layout           = wa_layout
    CHANGING
      it_fieldcatalog     = it_fcat_01
      it_outtab           = it_devol.

  PERFORM: create_hierarchy,
           register_events.

  SET HANDLER tree_receiver->handle_double_click FOR g_menu_tree.
  SET HANDLER tree_receiver->handle_on_drag FOR g_menu_tree.
  SET HANDLER tree_receiver->handle_on_drop FOR g_menu_tree.


*  CALL METHOD g_menu_tree->update_calculations.
  CALL METHOD g_menu_tree->frontend_update.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form build_hierarchy_header
*&---------------------------------------------------------------------*
*& Detalhes do Cabeçalho
*&---------------------------------------------------------------------*
*&      <-- L_HIERARCHY_HEADER
*&---------------------------------------------------------------------*
FORM build_hierarchy_header CHANGING l_hierarchy_header TYPE treev_hhdr.

  l_hierarchy_header-heading = 'Fatura/Nº da Nota'(300).
  l_hierarchy_header-tooltip = 'Notas de Fatura'(400).
  l_hierarchy_header-width = 27.
  l_hierarchy_header-width_pix = ''.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form build_fcat_01
*&---------------------------------------------------------------------*
*& Montagem fieldcatalog do alv tree
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM build_fcat_01 .
*--------------------------------------*
*  wa_fcat-col_pos = '1'.
*  wa_fcat-fieldname = 'VBELN'.
*  wa_fcat-tabname = 'IT_DEVOL'.
*  wa_fcat-outputlen = 10.
*  APPEND wa_fcat TO it_fcat.
*  CLEAR wa_fcat.
**--------------------------------------*
*  wa_fcat-col_pos = '2'.
*  wa_fcat-fieldname = 'FKART'.
*  wa_fcat-tabname = 'IT_DEVOL'.
*  wa_fcat-outputlen = 5.
*  APPEND wa_fcat TO it_fcat.
*  CLEAR wa_fcat.
*--------------------------------------*
  wa_fcat-col_pos = '1' .
  wa_fcat-fieldname = 'XBLNR'.
  wa_fcat-tabname = 'IT_DEVOL'.
  wa_fcat-coltext = 'Nº documento'.
  wa_fcat-outputlen = 25.
  APPEND wa_fcat TO it_fcat_01.
  CLEAR wa_fcat.
*--------------------------------------*
ENDFORM.

*&---------------------------------------------------------------------*
*& Form create_hierarchy
*&---------------------------------------------------------------------*
*& Ciração da hierarquia de Nós
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM create_hierarchy .

  DATA: lt_devol TYPE TABLE OF tp_devolucao,
        ls_devol TYPE tp_devolucao.

  DATA: fkart_key  TYPE lvc_nkey,
        vbeln_key  TYPE lvc_nkey,
        l_top_key  TYPE lvc_nkey,

        last_fkart TYPE fkart.

  SELECT vbrk~vbeln vbrk~fkart vbrk~xblnr vbrp~posnr
    FROM vbrk INNER JOIN vbrp ON vbrk~vbeln = vbrp~vbeln
    INTO TABLE lt_devol[]
    WHERE  vbrp~matnr = p_matnr AND
           vbrp~werks = p_werks AND
           vbrk~kunag = p_kunnr.

  SORT lt_devol ASCENDING BY fkart vbeln.


  CALL METHOD g_menu_tree->add_node
    EXPORTING
      i_relat_node_key = ''
      i_relationship   = cl_gui_column_tree=>relat_last_child
      i_node_text      = 'Faturas'
    IMPORTING
      e_new_node_key   = l_top_key.

  LOOP AT lt_devol INTO ls_devol.

    IF ls_devol-fkart <> last_fkart.
      last_fkart = ls_devol-fkart.
      PERFORM add_fkart USING ls_devol-fkart l_top_key
                              CHANGING fkart_key.
    ENDIF.

    PERFORM add_vbeln USING ls_devol fkart_key
                       CHANGING vbeln_key.
  ENDLOOP.


  CALL METHOD g_menu_tree->expand_node
    EXPORTING
      i_node_key = l_top_key.


ENDFORM.

*&---------------------------------------------------------------------*
*& Form add_fkart
*&---------------------------------------------------------------------*
*& Nós fkart (fatura)
*&---------------------------------------------------------------------*
*&      --> LS_DEVOL_FKART
*&      --> L_TOP_KEY
*&      <-- MONTADORA_KEY
*&---------------------------------------------------------------------*
FORM add_fkart USING ls_devol_fkart p_top_key CHANGING p_fkart_key.

  DATA: node_text TYPE lvc_value,
        ls_devol  TYPE tp_devolucao.

  node_text = ls_devol_fkart.
  CALL METHOD g_menu_tree->add_node
    EXPORTING
      i_relat_node_key = p_top_key
      i_relationship   = cl_gui_column_tree=>relat_last_child
      i_node_text      = node_text
      is_outtab_line   = ls_devol
    IMPORTING
      e_new_node_key   = p_fkart_key.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form add_vbeln
*&---------------------------------------------------------------------*
*& Nós folha vbeln (nota)
*&---------------------------------------------------------------------*
*&      --> LS_DEVOL
*&      --> FKART_KEY
*&      <-- VBELN_KEY
*&---------------------------------------------------------------------*
FORM add_vbeln USING ls_devol TYPE tp_devolucao p_fkart_key CHANGING p_vbeln_key.

  DATA: l_node_text    TYPE lvc_value,
        ls_node_layout TYPE lvc_s_layn..

  WRITE ls_devol-vbeln TO l_node_text.



  ls_node_layout-dragdropid = g_handle_tree.

  CALL METHOD g_menu_tree->add_node
    EXPORTING
      i_relat_node_key = p_fkart_key
      i_relationship   = cl_gui_column_tree=>relat_last_child
      is_outtab_line   = ls_devol
      is_node_layout   = ls_node_layout
      i_node_text      = l_node_text
    IMPORTING
      e_new_node_key   = p_vbeln_key.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form register_events
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM register_events.

  DATA: lt_events TYPE cntl_simple_events,
        ls_event   TYPE cntl_simple_event.

  CLEAR ls_event.
  ls_event-eventid = cl_gui_column_tree=>eventid_node_double_click.
  ls_event-appl_event = 'X'.
  APPEND ls_event TO lt_events.
  CLEAR ls_event.
  ls_event-eventid = cl_gui_column_tree=>eventid_expand_no_children.
  APPEND ls_event TO lt_events.
  CLEAR ls_event.
  ls_event-eventid = cl_gui_column_tree=>eventid_header_click.
  APPEND ls_event TO lt_events.
  CLEAR ls_event.

  CALL METHOD g_menu_tree->set_registered_events
    EXPORTING
      events                    = lt_events
    EXCEPTIONS
      cntl_error                = 1
      cntl_system_error         = 2
      illegal_event_combination = 3.
  IF sy-subrc <> 0.

  ENDIF.

ENDFORM.

*----------------------------------------------------------------------*
***INCLUDE ZF_ALV_ORDEM_FORMS.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form zf_alv_ordem
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM zf_alv_ordem .

  IF g_custom02 IS INITIAL.
    CREATE OBJECT g_custom02
      EXPORTING
        container_name              = 'CT2'
      EXCEPTIONS
        cntl_error                  = 1
        cntl_system_error           = 2
        create_error                = 3
        lifetime_error              = 4
        lifetime_dynpro_dynpro_link = 5.
  ENDIF.

  CREATE OBJECT g_menu_ordem
    EXPORTING
      i_appl_events = 'X'
      i_parent      = g_custom02.

  CREATE OBJECT ordem_receiver.

  CLEAR wa_ordem.
  APPEND wa_ordem TO it_ordem.

  PERFORM build_fcat_02.

  SET HANDLER ordem_receiver->handle_user_command FOR g_menu_ordem.
  SET HANDLER ordem_receiver->handle_context_menu FOR g_menu_ordem.
  SET HANDLER ordem_receiver->handle_double_click FOR g_menu_ordem.
  SET HANDLER ordem_receiver->handle_on_drag FOR g_menu_ordem.
  SET HANDLER ordem_receiver->handle_on_drop FOR g_menu_ordem.

  CALL METHOD g_menu_ordem->set_table_for_first_display
    EXPORTING
      is_layout       = wa_layout
    CHANGING
      it_outtab       = it_ordem
      it_fieldcatalog = it_fcat_02.


  CALL METHOD cl_gui_control=>set_focus
    EXPORTING
      control = g_menu_ordem.
  CALL METHOD cl_gui_cfw=>flush.

  CALL METHOD g_menu_ordem->refresh_table_display.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form build_fcat_02
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM build_fcat_02 .

*--------------------------------------*
  wa_fcat-col_pos = '1' .
  wa_fcat-fieldname = 'VBELN'.
  wa_fcat-tabname = 'IT_ORDEM'.
  wa_fcat-coltext = 'Nota'.
  wa_fcat-outputlen = 10.
  APPEND wa_fcat TO it_fcat_02.
  CLEAR wa_fcat.
*--------------------------------------*
  wa_fcat-col_pos = '2' .
  wa_fcat-fieldname = 'MATNR'.
  wa_fcat-tabname = 'IT_ORDEM'.
  wa_fcat-coltext = 'Material'.
  wa_fcat-outputlen = 20.
  APPEND wa_fcat TO it_fcat_02.
  CLEAR wa_fcat.
*--------------------------------------*
  wa_fcat-col_pos = '3' .
  wa_fcat-fieldname = 'ARKTX'.
  wa_fcat-tabname = 'IT_ORDEM'.
  wa_fcat-coltext = 'Desc. Material'.
  wa_fcat-outputlen = 35.
  APPEND wa_fcat TO it_fcat_02.
  CLEAR wa_fcat.
*--------------------------------------*
  wa_fcat-col_pos = '4' .
  wa_fcat-fieldname = 'FKIMG'.
  wa_fcat-tabname = 'IT_ORDEM'.
  wa_fcat-coltext = 'Quantidade'.
  wa_fcat-edit = 'X'.
  wa_fcat-outputlen = 15.
  APPEND wa_fcat TO it_fcat_02.
  CLEAR wa_fcat.
*--------------------------------------*
  wa_fcat-col_pos = '5' .
  wa_fcat-fieldname = 'MEINS'.
  wa_fcat-tabname = 'IT_ORDEM'.
  wa_fcat-coltext = 'Medida'.
  wa_fcat-outputlen = 6.
  APPEND wa_fcat TO it_fcat_02.
  CLEAR wa_fcat.
*--------------------------------------*
  wa_fcat-col_pos = '6' .
  wa_fcat-fieldname = 'NETWR'.
  wa_fcat-tabname = 'IT_ORDEM'.
  wa_fcat-coltext = 'Valor Líquido'.
  wa_fcat-outputlen = 15.
  APPEND wa_fcat TO it_fcat_02.
  CLEAR wa_fcat.
*--------------------------------------*
  wa_fcat-col_pos = '7' .
  wa_fcat-fieldname = 'DEPOT'.
  wa_fcat-tabname = 'IT_ORDEM'.
  wa_fcat-coltext = 'Depósito'.
  wa_fcat-outputlen = 10.
  wa_fcat-edit = 'X'.
  APPEND wa_fcat TO it_fcat_02.
  CLEAR wa_fcat.
*--------------------------------------*
  wa_fcat-col_pos = '8' .
  wa_fcat-fieldname = 'ORDEM'.
  wa_fcat-tabname = 'IT_ORDEM'.
  wa_fcat-coltext = 'Ordem'.
  wa_fcat-outputlen = 10.
  wa_fcat-hotspot = 'X'.
  APPEND wa_fcat TO it_fcat_02.
  CLEAR wa_fcat.
*--------------------------------------*
  wa_fcat-col_pos = '9' .
  wa_fcat-fieldname = 'ITEM'.
  wa_fcat-tabname = 'IT_ORDEM'.
  wa_fcat-coltext = 'Item'.
  wa_fcat-outputlen = 6.
  APPEND wa_fcat TO it_fcat_02.
  CLEAR wa_fcat.
*--------------------------------------*
ENDFORM.

*&---------------------------------------------------------------------*
*& Form display_ordem
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> NODE_KEY
*&---------------------------------------------------------------------*
FORM display_ordem USING p_node_key TYPE lvc_nkey.
  DATA: ls_devol TYPE tp_devolucao,
        ls_ordem TYPE tp_ordem.

*  REFRESH it_ordem.

  CALL METHOD g_menu_tree->get_outtab_line
    EXPORTING
      i_node_key    = p_node_key
    IMPORTING
      e_outtab_line = ls_devol.

  READ TABLE it_ordem INTO ls_ordem WITH KEY vbeln = ls_devol-vbeln.
  IF sy-subrc = 0.
    MESSAGE: s000(zcm_efmoura) WITH 'Nota já exibida' DISPLAY LIKE 'E'.
  ELSE.
    SELECT vbeln
           posnr
           matnr
           arktx
           fkimg
           meins
           netwr
      FROM vbrp
      APPENDING TABLE it_ordem
      WHERE vbeln = ls_devol-vbeln.

    DELETE it_ordem WHERE matnr IS INITIAL.

    IF it_ordem IS INITIAL.
      MESSAGE: s000(zcm_efmoura) WITH 'Não encontrado' DISPLAY LIKE 'E'.
    ELSE.
      CALL METHOD g_menu_ordem->refresh_table_display.
    ENDIF.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form remove_ordem_row
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p_row     text
*&---------------------------------------------------------------------*
FORM remove_ordem_row USING p_row.
  DATA: ls_aux_ordem TYPE tp_ordem.

  READ TABLE it_ordem INTO ls_aux_ordem INDEX p_row.

  DELETE it_ordem WHERE vbeln = ls_aux_ordem-vbeln.
  IF it_ordem IS INITIAL.
    CLEAR ls_aux_ordem.
    APPEND ls_aux_ordem TO it_ordem.
  ENDIF.
  CALL METHOD g_menu_ordem->refresh_table_display.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form zf_criar_ordem
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM zf_criar_ordem.

  DATA: lv_item_number TYPE posnr_va,
        continue       TYPE i.

  continue = 1.

  REFRESH: item, itemx, lt_schedules_in, lt_schedules_inx.

*********HEADER********
  header-doc_type    = 'ZSSD'.
  header-sales_org   = '1000'.
  header-distr_chan  = '01'.
  header-division    = '05'.
  header-doc_date    = sy-datum.
  header-bill_date   = sy-datum.
  header-fix_val_dy  = sy-datum.

  headerx-updateflag = 'I'.
  headerx-doc_type   = 'X'.
  headerx-sales_org  = 'X'.
  headerx-distr_chan = 'X'.
  headerx-division   = 'X'.
  headerx-doc_date   = 'X'.
  headerx-bill_date  = 'X'.
  headerx-fix_val_dy = 'X'.


  LOOP AT it_ordem INTO wa_ordem.

    IF wa_ordem-depot IS INITIAL.
      MESSAGE: s000(zcm_efmoura) WITH 'Preencher Depósito' DISPLAY LIKE 'E'.
      continue = 0.
      EXIT.
    ELSE.

      IF wa_ordem-ordem IS INITIAL.

        lv_item_number += 10.
        wa_ordem-item = lv_item_number.
        MODIFY it_ordem FROM wa_ordem INDEX sy-tabix TRANSPORTING item depot.

        READ TABLE it_devol INTO wa_devol WITH KEY vbeln = wa_ordem-vbeln.

*********ITEM*********
        item-itm_number = lv_item_number.
        item-material   = wa_ordem-matnr.
        item-item_categ = 'ZSSD'.
        item-short_text = wa_ordem-arktx.
        item-target_qty = wa_ordem-fkimg.
        item-target_qu  = wa_ordem-meins.
        item-plant      = p_werks.
        item-ref_doc    = wa_ordem-vbeln.
        item-ref_doc_it = wa_ordem-posnr.
        item-ref_doc_ca = 'O'.
        item-store_loc  = wa_ordem-depot.
        item-batch      = '263'.
        APPEND item.

        itemx-updateflag = 'I'.
        itemx-itm_number = lv_item_number.
        itemx-material   = 'X'.
        itemx-item_categ = 'X'.
        itemx-short_text = 'X'.
        itemx-target_qty = 'X'.
        itemx-target_qu  = 'X'.
        itemx-plant      = 'X'.
        itemx-ref_doc    = 'X'.
        itemx-ref_doc_it = 'X'.
        itemx-ref_doc_ca = 'X'.
        itemx-store_loc  = 'X'.
        itemx-batch      = 'X'.
        APPEND itemx.

*******SCHEDULE*******
        lt_schedules_in-itm_number = lv_item_number.
        lt_schedules_in-sched_line = '0001'.
        lt_schedules_in-req_qty = wa_ordem-fkimg.
*      lt_schedules_in-req_date = '20220425'.
        APPEND lt_schedules_in.

        lt_schedules_inx-updateflag = 'I'.
        lt_schedules_inx-itm_number = lv_item_number.
        lt_schedules_inx-sched_line = '0001'.
        lt_schedules_inx-req_qty = 'X'.
*      lt_schedules_in-req_date = 'X'.
        APPEND lt_schedules_inx.

      ENDIF.
    ENDIF.
  ENDLOOP.

********PARTNER********
  CALL FUNCTION 'CONVERSION_EXIT_PARVW_INPUT'
    EXPORTING
      input  = 'EO'
    IMPORTING
      output = partner-partn_role.
  partner-partn_numb = '0000000263'.
  APPEND partner.

  CALL FUNCTION 'CONVERSION_EXIT_PARVW_INPUT'
    EXPORTING
      input  = 'RF'
    IMPORTING
      output = partner-partn_role.
  partner-partn_numb = '0000000263'.
  APPEND partner.

  CALL FUNCTION 'CONVERSION_EXIT_PARVW_INPUT'
    EXPORTING
      input  = 'PG'
    IMPORTING
      output = partner-partn_role.
  partner-partn_numb = '0000000263'.
  APPEND partner.

  CALL FUNCTION 'CONVERSION_EXIT_PARVW_INPUT'
    EXPORTING
      input  = 'RM'
    IMPORTING
      output = partner-partn_role.
  partner-partn_numb = '0000000263'.
  APPEND partner.

**********************
  IF continue = 1.
    CALL FUNCTION 'BAPI_SALESORDER_CREATEFROMDAT2'
      EXPORTING
*       SALESDOCUMENTIN     =
        order_header_in     = header
        order_header_inx    = headerx
*       SENDER              =
*       BINARY_RELATIONSHIPTYPE       =
*       INT_NUMBER_ASSIGNMENT         =
*       BEHAVE_WHEN_ERROR   =
*       LOGIC_SWITCH        =
*       TESTRUN             =
*       CONVERT             = ' '
      IMPORTING
        salesdocument       = v_vbeln
      TABLES
        return              = return
        order_items_in      = item
        order_items_inx     = itemx
        order_partners      = partner
        order_schedules_in  = lt_schedules_in
        order_schedules_inx = lt_schedules_inx
*       ORDER_CONDITIONS_IN =
*       ORDER_CONDITIONS_INX =
*       ORDER_CFGS_REF      =
*       ORDER_CFGS_INST     =
*       ORDER_CFGS_PART_OF  =
*       ORDER_CFGS_VALUE    =
*       ORDER_CFGS_BLOB     =
*       ORDER_CFGS_VK       =
*       ORDER_CFGS_REFINST  =
*       ORDER_CCARD         =
*       ORDER_TEXT          =
*       ORDER_KEYS          =
*       EXTENSIONIN         =
*       PARTNERADDRESSES    =
*       EXTENSIONEX         =
*       NFMETALLITMS        =
      .

    IF NOT v_vbeln IS INITIAL.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = 'X'.
**** Success ****

      MESSAGE: s000(zcm_efmoura) WITH v_vbeln.

      wa_ordem-ordem = v_vbeln.
      MODIFY it_ordem FROM wa_ordem TRANSPORTING ordem depot WHERE ordem IS INITIAL.
      CALL METHOD g_menu_ordem->refresh_table_display.

    ELSE.
      LOOP AT return WHERE type = 'E' OR type = 'A'.
**** Failure ****
*      msg = return-message.
*      MESSAGE: i000(zcm_efmoura) WITH msg DISPLAY LIKE 'E'.

      ENDLOOP.
    ENDIF.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form zf_call_va03
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM zf_call_va03 USING p_row.
  DATA: ls_ordem TYPE tp_ordem.

  READ TABLE it_ordem INTO ls_ordem INDEX p_row.
  IF sy-subrc = 0.

    SET PARAMETER ID 'AUN' FIELD ls_ordem-ordem.
    CALL TRANSACTION 'VA03' AND SKIP FIRST SCREEN.

  ENDIF.
ENDFORM.

*----------------------------------------------------------------------*
***INCLUDE ZF_ALV_REMESSA_FORMS.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form zf_alv_remessa
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM zf_alv_remessa .

  CREATE OBJECT g_custom03
    EXPORTING
      container_name              = 'CT3'
    EXCEPTIONS
      cntl_error                  = 1
      cntl_system_error           = 2
      create_error                = 3
      lifetime_error              = 4
      lifetime_dynpro_dynpro_link = 5.

  CREATE OBJECT g_menu_remessa
    EXPORTING
      i_parent = g_custom03.

  CREATE OBJECT remessa_receiver.

  CLEAR wa_remessa.
  APPEND wa_remessa TO it_remessa.

  PERFORM build_fcat_03.

  SET HANDLER remessa_receiver->handle_user_command FOR g_menu_remessa.
  SET HANDLER remessa_receiver->handle_context_menu FOR g_menu_remessa.
  SET HANDLER remessa_receiver->handle_double_click FOR g_menu_remessa.
  SET HANDLER remessa_receiver->handle_on_drag FOR g_menu_remessa.
  SET HANDLER remessa_receiver->handle_on_drop FOR g_menu_remessa.

  CALL METHOD g_menu_remessa->set_table_for_first_display
    EXPORTING
      is_layout       = wa_layout
    CHANGING
      it_outtab       = it_remessa
      it_fieldcatalog = it_fcat_03.

  CALL METHOD cl_gui_control=>set_focus
    EXPORTING
      control = g_menu_remessa.
  CALL METHOD cl_gui_cfw=>flush.

  CALL METHOD g_menu_remessa->refresh_table_display.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form build_fcat_03
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM build_fcat_03 .

*--------------------------------------*
  wa_fcat-col_pos = '1' .
  wa_fcat-fieldname = 'ORDEM'.
  wa_fcat-tabname = 'IT_REMESSA'.
  wa_fcat-coltext = 'Ordem'.
  wa_fcat-outputlen = 10.
  APPEND wa_fcat TO it_fcat_03.
  CLEAR wa_fcat.
*--------------------------------------*
  wa_fcat-col_pos = '2' .
  wa_fcat-fieldname = 'ITEM'.
  wa_fcat-tabname = 'IT_REMESSA'.
  wa_fcat-coltext = 'Item'.
  wa_fcat-outputlen = 6.
  APPEND wa_fcat TO it_fcat_03.
  CLEAR wa_fcat.
*--------------------------------------*
  wa_fcat-col_pos = '3' .
  wa_fcat-fieldname = 'MATNR'.
  wa_fcat-tabname = 'IT_REMESSA'.
  wa_fcat-coltext = 'Material'.
  wa_fcat-outputlen = 20.
  APPEND wa_fcat TO it_fcat_03.
  CLEAR wa_fcat.
*--------------------------------------*
  wa_fcat-col_pos = '4' .
  wa_fcat-fieldname = 'ARKTX'.
  wa_fcat-tabname = 'IT_REMESSA'.
  wa_fcat-coltext = 'Descrição do Material'.
  wa_fcat-outputlen = 30.
  APPEND wa_fcat TO it_fcat_03.
  CLEAR wa_fcat.
*--------------------------------------*
  wa_fcat-col_pos = '5'.
  wa_fcat-fieldname = 'FKIMG'.
  wa_fcat-tabname = 'IT_REMESSA'.
  wa_fcat-coltext = 'Quantidade'.
  wa_fcat-outputlen = 13.
  APPEND wa_fcat TO it_fcat_03.
  CLEAR wa_fcat.
*--------------------------------------*
  wa_fcat-col_pos = '6'.
  wa_fcat-fieldname = 'MEINS'.
  wa_fcat-tabname = 'IT_REMESSA'.
  wa_fcat-coltext = 'Unidade'.
  wa_fcat-outputlen = 8.
  APPEND wa_fcat TO it_fcat_03.
  CLEAR wa_fcat.
*--------------------------------------*
*  wa_fcat-col_pos = '7'.
*  wa_fcat-fieldname = 'DEPOT'.
*  wa_fcat-tabname = 'IT_REMESSA'.
*  wa_fcat-coltext = 'Depósito'.
*  wa_fcat-outputlen = 10.
*  wa_fcat-edit  = 'X'.
*  APPEND wa_fcat TO it_fcat_03.
*  CLEAR wa_fcat.
*--------------------------------------*
*  wa_fcat-col_pos = '8'.
*  wa_fcat-fieldname = ''.
*  wa_fcat-tabname = 'IT_REMESSA'.
*  wa_fcat-coltext = ''.
*  wa_fcat-outputlen = 10.
*  APPEND wa_fcat TO it_fcat_03.
*  CLEAR wa_fcat.
*--------------------------------------*
  wa_fcat-col_pos = '9'.
  wa_fcat-fieldname = 'REMESSA'.
  wa_fcat-tabname = 'IT_REMESSA'.
  wa_fcat-coltext = 'Remessa'.
  wa_fcat-outputlen = 10.
  wa_fcat-hotspot   = 'X'.
  APPEND wa_fcat TO it_fcat_03.
  CLEAR wa_fcat.
*--------------------------------------*

ENDFORM.

*&---------------------------------------------------------------------*
*& Form display_remessa
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> DATA_AUX_>INDEX
*&---------------------------------------------------------------------*
FORM display_remessa USING p_index.
  DATA: ls_ordem   TYPE tp_ordem,
        ls_remessa TYPE tp_remessa.


  READ TABLE it_remessa INTO ls_remessa WITH KEY ordem = p_index.
  IF sy-subrc = 0.
    MESSAGE: s000(zcm_efmoura) WITH 'Ordem já exibida' DISPLAY LIKE 'E'.
  ELSE.
    LOOP AT it_ordem INTO ls_ordem WHERE ordem = p_index.

      ls_remessa-ordem = p_index.
      ls_remessa-item  = ls_ordem-item.
      ls_remessa-matnr = ls_ordem-matnr.
      ls_remessa-arktx = ls_ordem-arktx.
      ls_remessa-fkimg = ls_ordem-fkimg.
      ls_remessa-meins = ls_ordem-meins.

      APPEND ls_remessa TO it_remessa.

      DELETE it_remessa WHERE ordem IS INITIAL.

      CALL METHOD g_menu_remessa->refresh_table_display.
    ENDLOOP.

  ENDIF.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form zf_criar_remessa
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM zf_criar_remessa.

*  DATA: lv_data TYPE dats.

  REFRESH: return, it_sales_items.
*  CLEAR: lv_data.

  LOOP AT it_remessa INTO wa_remessa.
    IF wa_remessa-remessa IS INITIAL.

      wa_sales_items-ref_doc    = wa_remessa-ordem.
      wa_sales_items-ref_item   = wa_remessa-item.
      wa_sales_items-dlv_qty    = wa_remessa-fkimg.
      wa_sales_items-sales_unit = wa_remessa-meins.
      APPEND wa_sales_items TO it_sales_items.

*      IF wa_remessa-data IS NOT INITIAL.

      CALL FUNCTION 'BAPI_OUTB_DELIVERY_CREATE_SLS'
        EXPORTING
          ship_point        = p_werks
          due_date          = sy-datum
*         debug_flg         =
          no_dequeue        = ''
        IMPORTING
          delivery          = delivery
*         num_deliveries    =
        TABLES
          sales_order_items = it_sales_items
*         serial_numbers    =
*         extension_in      =
*         deliveries        =
*         created_items     =
*         extension_out     =
          return            = return.

      IF NOT delivery IS INITIAL.
        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            wait = 'X'.
**** Success ****

        MESSAGE: s000(zcm_efmoura) WITH delivery.

        wa_remessa-remessa = delivery.
*        wa_remessa-data    = wa_remessa-data.
        MODIFY it_remessa FROM wa_remessa TRANSPORTING remessa WHERE remessa IS INITIAL.
        CALL METHOD g_menu_remessa->refresh_table_display.

      ELSE.
        LOOP AT return WHERE type = 'E' OR type = 'A'.
**** Failure ****
*      msg = return-message.
*      MESSAGE: i000(zcm_efmoura) WITH msg DISPLAY LIKE 'E'.

        ENDLOOP.
      ENDIF.
*      ELSE.
*        MESSAGE: s000(zcm_efmoura) WITH 'Preencha o campo de data' DISPLAY LIKE 'E'.
*    ENDIF.
    ENDIF.
  ENDLOOP.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form zf_sair_remessa
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM zf_sair_remessa.

  DATA: it_prot  TYPE TABLE OF prott,
        wa_prot  TYPE  prott,
        wa_vbkok LIKE  vbkok,
        delivery LIKE  likp-vbeln.

  wa_vbkok-kzwad     = 'X'.
  wa_vbkok-wadat     = sy-datum.
  wa_vbkok-wabuc     = 'X'.

  CLEAR wa_remessa.
  REFRESH: it_prot.

  LOOP AT it_remessa INTO wa_remessa.

    IF wa_remessa-remessa IS NOT INITIAL.

      delivery = wa_remessa-remessa.
      wa_vbkok-vbeln_vl  =  delivery.


      wa_prot-vbeln = delivery.
      wa_prot-posnr = wa_remessa-item.
      wa_prot-matnr = wa_remessa-matnr.
      wa_prot-arktx = wa_remessa-arktx.
      wa_prot-lfimg = wa_remessa-fkimg.
      wa_prot-vrkme = wa_remessa-meins.
      wa_prot-charg = '263'.
      APPEND wa_prot TO it_prot.

      CALL FUNCTION 'WS_DELIVERY_UPDATE'
        EXPORTING
          vbkok_wa = wa_vbkok
          commit   = 'X'
          delivery = delivery
        TABLES
          prot     = it_prot.

    ENDIF.
  ENDLOOP.

ENDFORM.

*----------------------------------------------------------------------*
***INCLUDE ZF_ALV_FATURA_FORMS.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form zf_alv_fatura
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM zf_alv_fatura .

  CREATE OBJECT g_custom04
    EXPORTING
      container_name              = 'CT4'
    EXCEPTIONS
      cntl_error                  = 1
      cntl_system_error           = 2
      create_error                = 3
      lifetime_error              = 4
      lifetime_dynpro_dynpro_link = 5.

    CREATE OBJECT g_menu_fatura
    EXPORTING
      i_parent = g_custom04.

  CREATE OBJECT fatura_receiver.

  CLEAR wa_fatura.
  APPEND wa_fatura TO it_fatura.

  PERFORM build_fcat_04.

  SET HANDLER fatura_receiver->handle_user_command FOR g_menu_fatura.
  SET HANDLER fatura_receiver->handle_context_menu FOR g_menu_fatura.
  SET HANDLER fatura_receiver->handle_double_click FOR g_menu_fatura.
  SET HANDLER fatura_receiver->handle_on_drag FOR g_menu_fatura.
  SET HANDLER fatura_receiver->handle_on_drop FOR g_menu_fatura.


  CALL METHOD g_menu_fatura->set_table_for_first_display
    EXPORTING
      is_layout       = wa_layout
    CHANGING
      it_outtab       = it_fatura
      it_fieldcatalog = it_fcat_04.

  CALL METHOD g_menu_fatura->refresh_table_display.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form build_fcat_04
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM build_fcat_04 .

*--------------------------------------*
  wa_fcat-col_pos = '1'.
  wa_fcat-fieldname = 'ORDEM'.
  wa_fcat-tabname = 'IT_FATURA'.
  wa_fcat-coltext = 'Ordem'.
  wa_fcat-outputlen = 10.
  APPEND wa_fcat TO it_fcat_04.
  CLEAR wa_fcat.
*--------------------------------------*
  wa_fcat-col_pos = '2'.
  wa_fcat-fieldname = 'REMESSA'.
  wa_fcat-tabname = 'IT_FATURA'.
  wa_fcat-coltext = 'Remessa'.
  wa_fcat-outputlen = 10.
  APPEND wa_fcat TO it_fcat_04.
  CLEAR wa_fcat.
*--------------------------------------*

ENDFORM.