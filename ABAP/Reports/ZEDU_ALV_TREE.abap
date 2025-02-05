***********************************************************************
* NOME DO PROGRAMA    : ZEDU_ALV_TREE                                 *
* TRANSAÇÃO           :                                               *
* TÍTULO DO PROGRAMA  : Exemplo ALV Tree                              *
* DESCRIÇÃO           : Report para display alv em árvore baseado em  *
*                       BCALV_TREE_04                                 *
* PROGRAMADOR         : Eduardo Freitas Moura (EMOURA)                *
* DATA                : 08.04.2022                                    *
***********************************************************************
REPORT zedu_alv_tree.

TABLES: ztbedu_veiculos.

"---------------------TIPOS----------------------"
TYPES: BEGIN OF tp_veiculo,
         id_veiculo  TYPE ztbedu_veiculos-id_veiculo,
         montadora   TYPE ztbedu_veiculos-montadora,
         marca       TYPE ztbedu_veiculos-marca,
         placa       TYPE ztbedu_veiculos-placa,
         ano         TYPE ztbedu_veiculos-ano,
         cor         TYPE ztbedu_veiculos-cor,
         data_compra TYPE ztbedu_veiculos-data_compra,
         situacao    TYPE ztbedu_veiculos-situacao,
         obs         TYPE ztbedu_veiculos-obs,
         eliminado   TYPE ztbedu_veiculos-eliminado,
       END OF tp_veiculo.


"--------------TABELAS E ESTRUTURAS--------------"
"-----DADOS SELECT-----"
DATA: it_veiculo TYPE TABLE OF tp_veiculo.
*      wa_veiculo TYPE tp_veiculo.

"------DADOS ALV------"
DATA: g_alv_tree TYPE REF TO cl_gui_alv_tree,
      g_custom   TYPE REF TO cl_gui_custom_container,
      g_toolbar  TYPE REF TO cl_gui_toolbar,

      it_fcat    TYPE lvc_t_fcat,
      wa_fcat    TYPE lvc_s_fcat,

      ok_code    LIKE sy-ucomm,
      save_ok    LIKE sy-ucomm.

"----------------OUTROS GLOBAIS------------------"



"-------------------CLASSES----------------------"
CLASS lcl_toolbar_event_receiver DEFINITION.

  PUBLIC SECTION.
    METHODS: on_function_selected
      FOR EVENT function_selected OF cl_gui_toolbar
      IMPORTING fcode.

ENDCLASS.

CLASS lcl_toolbar_event_receiver IMPLEMENTATION.

  METHOD on_function_selected.
    DATA: lt_selected_nodes TYPE lvc_t_nkey,
          l_selected_node   TYPE lvc_nkey,
          ans               TYPE c.

    CASE fcode.
      WHEN 'DELETE'.

        CALL METHOD g_alv_tree->get_selected_nodes
          CHANGING
            ct_selected_nodes = lt_selected_nodes.

        CALL METHOD cl_gui_cfw=>flush.

        READ TABLE lt_selected_nodes INTO l_selected_node INDEX 1.
        IF sy-subrc EQ 0.
          CALL FUNCTION 'POPUP_TO_CONFIRM_STEP'
            EXPORTING
              textline1      = 'Tem certeza que quer deletar?'
              textline2      = 'Esse nó e todos os abaixo dele?'
              titel          = 'Confirmação'
              cancel_display = ' '
            IMPORTING
              answer         = ans.

          IF ans EQ 'J'.

            CALL METHOD g_alv_tree->delete_subtree
              EXPORTING
                i_node_key = l_selected_node.

            CALL METHOD g_alv_tree->frontend_update.

          ENDIF.
        ELSE.
          MESSAGE i000(zcm_efmoura) WITH 'Selecione uma pasta ou um nó.'.
        ENDIF.
    ENDCASE.
  ENDMETHOD.

ENDCLASS.

"----------------INICIO_DA_SELEÇÃO----------------"

START-OF-SELECTION.

  CALL SCREEN 100.


*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'STREE'.
* SET TITLEBAR 'xxx'.

  IF g_alv_tree IS INITIAL.
    PERFORM cria_tree.

*    CALL METHOD cl_gui_cfw=>flush
*      EXCEPTIONS
*        cntl_system_error = 1
*        cntl_error        = 2.
*    IF sy-subrc NE 0.
*      CALL FUNCTION 'POPUP_TO_INFORM'
*        EXPORTING
*          titel = 'Automation Queue failure'(801)
*          txt1  = 'Internal error:'(802)
*          txt2  = 'A method in the automation queue'(803)
*          txt3  = 'caused a failure.'(804).
*    ENDIF.
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
    WHEN 'EXIT'.
      LEAVE PROGRAM.
    WHEN 'CANCEL'.
      LEAVE PROGRAM.
    WHEN OTHERS.
  ENDCASE.


ENDMODULE.


*&---------------------------------------------------------------------*
*& Form cria_tree
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM cria_tree .

  CREATE OBJECT g_custom
    EXPORTING
      container_name              = 'CT1'
    EXCEPTIONS
      cntl_error                  = 1
      cntl_system_error           = 2
      create_error                = 3
      lifetime_error              = 4
      lifetime_dynpro_dynpro_link = 5.

  CREATE OBJECT g_alv_tree
    EXPORTING
      parent                      = g_custom
      node_selection_mode         = cl_gui_column_tree=>node_sel_mode_single
      item_selection              = ' '
      no_html_header              = 'X'
      no_toolbar                  = ''
    EXCEPTIONS
      cntl_error                  = 1
      cntl_system_error           = 2
      create_error                = 3
      lifetime_error              = 4
      illegal_node_selection_mode = 5
      failed                      = 6
      illegal_column_name         = 7.


  DATA l_hierarchy_header TYPE treev_hhdr.
  PERFORM: build_hierarchy_header CHANGING l_hierarchy_header,
           build_fieldcatalog.


  CALL METHOD g_alv_tree->set_table_for_first_display
    EXPORTING
      is_hierarchy_header = l_hierarchy_header
    CHANGING
      it_fieldcatalog     = it_fcat
      it_outtab           = it_veiculo.

  PERFORM: create_hierarchy,
           change_toolbar,
           register_events.

  CALL METHOD g_alv_tree->update_calculations.
  CALL METHOD g_alv_tree->frontend_update.


ENDFORM.


*&---------------------------------------------------------------------*
*& Form build_hierarchy_header
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- L_HIERARCHY_HEADER
*&---------------------------------------------------------------------*
FORM build_hierarchy_header CHANGING
                               p_hierarchy_header TYPE treev_hhdr.

  p_hierarchy_header-heading = 'Montadora/Modelo'(300).
  p_hierarchy_header-tooltip = 'Marcas de Veículos'(400).
  p_hierarchy_header-width = 35.
  p_hierarchy_header-width_pix = ''.


ENDFORM.


*&---------------------------------------------------------------------*
*& Form build_fieldcatalog
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM build_fieldcatalog .

  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name = 'ZTBEDU_VEICULOS'
    CHANGING
      ct_fieldcat      = it_fcat.


ENDFORM.


*&---------------------------------------------------------------------*
*& Form create_hierarchy
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM create_hierarchy .
  DATA: lt_veiculo TYPE TABLE OF tp_veiculo,
        ls_veiculo TYPE tp_veiculo.

  DATA: montadora_key  TYPE lvc_nkey,
        marca_key      TYPE lvc_nkey,
        l_top_key      TYPE lvc_nkey,

        last_montadora TYPE zed_montadora.

  SELECT id_veiculo
       montadora
       marca
       placa
       ano
       cor
       data_compra
       situacao
       obs
       eliminado
  FROM ztbedu_veiculos
INTO TABLE lt_veiculo[]
  UP TO 100 ROWS.

  SORT lt_veiculo ASCENDING BY montadora.


  CALL METHOD g_alv_tree->add_node
    EXPORTING
      i_relat_node_key = ''
      i_relationship   = cl_gui_column_tree=>relat_last_child
      i_node_text      = 'Veículos'
    IMPORTING
      e_new_node_key   = l_top_key.

  LOOP AT lt_veiculo INTO ls_veiculo.

    IF ls_veiculo-montadora <> last_montadora.      "on change of l_carrid
      last_montadora = ls_veiculo-montadora.
      PERFORM add_montadora USING ls_veiculo-montadora l_top_key
                              CHANGING montadora_key.
    ENDIF.

    PERFORM add_marca USING ls_veiculo montadora_key
                       CHANGING marca_key.
  ENDLOOP.


  CALL METHOD g_alv_tree->expand_node
    EXPORTING
      i_node_key = l_top_key.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form change_toolbar
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM change_toolbar .

  CALL METHOD g_alv_tree->get_toolbar_object
    IMPORTING
      er_toolbar = g_toolbar.

  CHECK NOT g_toolbar IS INITIAL.

  CALL METHOD g_toolbar->add_button
    EXPORTING
      fcode     = ''
      icon      = ''
      butn_type = cntb_btype_sep.

  CALL METHOD g_toolbar->add_button
    EXPORTING
      fcode     = 'DELETE'
      icon      = '@11@'
      butn_type = cntb_btype_button
      text      = ''
      quickinfo = 'Deletar Nó/Pasta'.

  CALL METHOD g_toolbar->add_button
    EXPORTING
      fcode     = 'ADD'
      icon      = icon_set_state
      butn_type = cntb_btype_button
      text      = ''
      quickinfo = 'Adicionar Nó'.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form register_events
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM register_events .

  DATA: lt_events        TYPE cntl_simple_events,
        l_event          TYPE cntl_simple_event,
        l_event_receiver TYPE REF TO lcl_toolbar_event_receiver.

  CALL METHOD g_alv_tree->get_registered_events
    IMPORTING
      events = lt_events.

  CALL METHOD g_alv_tree->set_registered_events
    EXPORTING
      events                    = lt_events
    EXCEPTIONS
      cntl_error                = 1
      cntl_system_error         = 2
      illegal_event_combination = 3.
  IF sy-subrc <> 0.
  ENDIF.

  CREATE OBJECT l_event_receiver.
  SET HANDLER l_event_receiver->on_function_selected FOR g_toolbar.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form add_montadora
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> WA_VEICULO
*&      --> L_TOP_KEY
*&      <-- MONTADORA_KEY
*&---------------------------------------------------------------------*
FORM add_montadora USING p_montadora TYPE zed_montadora p_relat_key TYPE lvc_nkey CHANGING p_node_key TYPE lvc_nkey.

  DATA: node_text  TYPE lvc_value,
        ls_veiculo TYPE tp_veiculo.

  node_text = p_montadora.
  CALL METHOD g_alv_tree->add_node
    EXPORTING
      i_relat_node_key = p_relat_key
      i_relationship   = cl_gui_column_tree=>relat_last_child
      i_node_text      = node_text
      is_outtab_line   = ls_veiculo
    IMPORTING
      e_new_node_key   = p_node_key.


ENDFORM.

*&---------------------------------------------------------------------*
*& Form add_mara
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> WA_VEICULO
*&      --> MONTADORA_KEY
*&      <-- MARCA_KEY
*&---------------------------------------------------------------------*
FORM add_marca USING p_veiculo TYPE tp_veiculo p_relat_key TYPE lvc_nkey CHANGING p_node_key TYPE lvc_nkey.

  DATA: l_node_text TYPE lvc_value.

  WRITE p_veiculo-marca TO l_node_text.

  CALL METHOD g_alv_tree->add_node
    EXPORTING
      i_relat_node_key = p_relat_key
      i_relationship   = cl_gui_column_tree=>relat_last_child
      is_outtab_line   = p_veiculo
      i_node_text      = l_node_text
    IMPORTING
      e_new_node_key   = p_node_key.


ENDFORM.