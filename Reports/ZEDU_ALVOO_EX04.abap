***********************************************************************
* NOME DO PROGRAMA    : ZEDU_ALVOO_EX04                               *
* TRANSAÇÃO           :                                               *
* TÍTULO DO PROGRAMA  : Exemplo 3 ALV OO                              *
* DESCRIÇÃO           : Report para alv OO editável inserir deletar e *
*                       atualizar uma tabela transparente             *
* PROGRAMADOR         : Eduardo Freitas Moura (EMOURA)                *
* DATA                : 08.04.2022                                    *
***********************************************************************
REPORT zedu_alvoo_ex04.

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
         check       TYPE flag,
*         cell        TYPE lvc_t_STYL,
       END OF tp_veiculo.


"--------------TABELAS E ESTRUTURAS--------------"
"-----DADOS SELECT-----"
DATA: it_veiculo TYPE TABLE OF tp_veiculo,
      wa_veiculo TYPE tp_veiculo.

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
    "Botão de DELETE dentro do container do alv
    is_btn-function = 'DEL'.
    is_btn-icon = icon_delete.
    is_btn-text = 'DEL'.
    is_btn-quickinfo = 'DEL'.
    is_btn-disabled = ' '.
    APPEND is_btn TO e_object->mt_toolbar.
    "Botão de ADD dentro do container do alv
    is_btn-function = 'ADD'.
    is_btn-icon = icon_set_state.
    is_btn-text = 'ADD'.
    is_btn-quickinfo = 'ADD'.
    is_btn-disabled = ' '.
    APPEND is_btn TO e_object->mt_toolbar.
  ENDMETHOD.

  METHOD handle_user_command .
    "user_command da toolbar do alv dentro do container
    CASE e_ucomm.
      WHEN 'SAVE'.
        PERFORM zf_data_update.
      WHEN 'DEL'.
        PERFORM zf_data_delete.
      WHEN 'ADD'.
        PERFORM zf_data_insert.
    ENDCASE.
  ENDMETHOD.
ENDCLASS.


"-----------------TELA DE SELEÇÂO-----------------"
SELECTION-SCREEN: BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-001.

  SELECT-OPTIONS: s_idveic FOR ztbedu_veiculos-id_veiculo,
                  s_mont   FOR ztbedu_veiculos-montadora,
                  s_marca  FOR ztbedu_veiculos-marca,
                  s_situ   FOR ztbedu_veiculos-situacao,
                  s_elim   FOR ztbedu_veiculos-eliminado.

SELECTION-SCREEN: END OF BLOCK b01.


"----------------VALIDAÇÃO DE TELA----------------"

AT SELECTION-SCREEN.
  IF s_idveic AND s_mont AND s_marca AND s_situ AND s_elim IS INITIAL.
    MESSAGE e002(zcm_efmoura).
  ENDIF.


"----------------INICIO_DA_SELEÇÃO----------------"

START-OF-SELECTION.

  PERFORM: zf_select_dados,
*           zf_preenche_saida,
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
    INTO TABLE it_veiculo[]
    WHERE id_veiculo IN s_idveic AND
          montadora  IN s_mont   AND
          marca      IN s_marca  AND
          situacao   IN s_situ   AND
          eliminado  IN s_elim.

  SORT it_veiculo ASCENDING BY id_veiculo.

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
  wa_fcat-tabname = 'IT_VEICULO'.
  wa_fcat-scrtext_l = 'CHECK'.
  wa_fcat-checkbox = 'X'.
  wa_fcat-edit = 'X'.
  wa_fcat-outputlen = 5.
  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.
*-------------------------------------*
  wa_fcat-col_pos = 1 .
  wa_fcat-fieldname = 'ID_VEICULO'.
  wa_fcat-tabname = 'IT_VEICULO'.
  wa_fcat-scrtext_l = 'ID Veiculo'.
  wa_fcat-key = 'X'.
  wa_fcat-outputlen = 10.
  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.
*-------------------------------------*
  wa_fcat-col_pos = 2 .
  wa_fcat-fieldname = 'MONTADORA'.
  wa_fcat-tabname = 'IT_VEICULO'.
  wa_fcat-scrtext_l = 'Montadora'.
  wa_fcat-outputlen = 15.
  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.
*-------------------------------------*
  wa_fcat-col_pos = 3 .
  wa_fcat-fieldname = 'MARCA'.
  wa_fcat-tabname = 'IT_VEICULO'.
  wa_fcat-scrtext_l = 'Marca'.
  wa_fcat-outputlen = 15.
  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.
*-------------------------------------*
  wa_fcat-col_pos = 6 .
  wa_fcat-fieldname = 'PLACA'.
  wa_fcat-tabname = 'IT_VEICULO'.
  wa_fcat-scrtext_l = 'Placa'.
  wa_fcat-edit = 'X'.
  wa_fcat-outputlen = 10.
  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.
*-------------------------------------*
  wa_fcat-col_pos = 4 .
  wa_fcat-fieldname = 'ANO'.
  wa_fcat-tabname = 'IT_VEICULO'.
  wa_fcat-scrtext_l = 'Ano'.
*  wa_fcat-edit = 'X'.
  wa_fcat-outputlen = 4.
  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.
*-------------------------------------*
  wa_fcat-col_pos = 7 .
  wa_fcat-fieldname = 'COR'.
  wa_fcat-tabname = 'IT_VEICULO'.
  wa_fcat-scrtext_l = 'Cor'.
  wa_fcat-edit = 'X'.
  wa_fcat-outputlen = 10.
  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.
*-------------------------------------*
  wa_fcat-col_pos = 5 .
  wa_fcat-fieldname = 'DATA_COMPRA'.
  wa_fcat-tabname = 'IT_VEICULO'.
  wa_fcat-scrtext_l = 'Data Compra'.
*  wa_fcat-edit = 'X'.
  wa_fcat-outputlen = 10.
  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.
*-------------------------------------*
  wa_fcat-col_pos = 8 .
  wa_fcat-fieldname = 'SITUACAO'.
  wa_fcat-tabname = 'IT_VEICULO'.
  wa_fcat-scrtext_l = 'Situação'.
  wa_fcat-edit = 'X'.
  wa_fcat-outputlen = 8.
  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.
*-------------------------------------*
  wa_fcat-col_pos = 9 .
  wa_fcat-fieldname = 'OBS'.
  wa_fcat-tabname = 'IT_VEICULO'.
  wa_fcat-scrtext_l = 'Observações'.
  wa_fcat-edit = 'X'.
  wa_fcat-outputlen = 40.
  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.
*-------------------------------------*
  wa_fcat-col_pos = 10 .
  wa_fcat-fieldname = 'ELIMINADO'.
  wa_fcat-tabname = 'IT_VEICULO'.
  wa_fcat-scrtext_l = 'Eliminado'.
  wa_fcat-edit = 'X'.
  wa_fcat-outputlen = 10.
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
        it_outtab       = it_VEICULO
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
      PERFORM zf_switch_edit_mode.
    WHEN 'SAVE'.
      PERFORM zf_data_update.
    WHEN OTHERS.
  ENDCASE.

ENDMODULE.


*&---------------------------------------------------------------------*
*&      Form  ZF_SWITCH_EDIT_MODE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM zf_switch_edit_mode.

  IF lo_alv->is_ready_for_input( ) EQ 0.
    CALL METHOD lo_alv->set_ready_for_input
      EXPORTING
        i_ready_for_input = 1.

  ELSE.
    CALL METHOD lo_alv->set_ready_for_input
      EXPORTING
        i_ready_for_input = 0.
  ENDIF.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form zf_data_update
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM zf_data_update .

  LOOP AT it_veiculo INTO wa_veiculo.
    IF wa_veiculo-check = 'X'.

      UPDATE ztbedu_veiculos
      SET id_veiculo  = wa_veiculo-id_veiculo
          montadora   = wa_veiculo-montadora
          marca       = wa_veiculo-marca
          placa       = wa_veiculo-placa
          ano         = wa_veiculo-ano
          cor         = wa_veiculo-cor
          data_compra = wa_veiculo-data_compra
          situacao    = wa_veiculo-situacao
          obs         = wa_veiculo-obs
          eliminado   = wa_veiculo-eliminado
       WHERE id_veiculo = wa_veiculo-id_veiculo.

      IF sy-subrc = 0.
        COMMIT WORK AND WAIT.
        MESSAGE i000(zcm_efmoura) WITH 'Alterado com sucesso'.
      ELSE.
        ROLLBACK WORK.
        MESSAGE i000(zcm_efmoura) WITH 'Não foi alterado'.
      ENDIF.
    ENDIF.
*    wa_veiculo-check = ''.
  ENDLOOP.

  PERFORM zf_select_dados.
  CALL METHOD lo_alv->refresh_table_display.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form zf_data_delete
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM zf_data_delete .

  DATA ans TYPE c.

  LOOP AT it_veiculo INTO wa_veiculo.
    IF wa_veiculo-check = 'X'.

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
        MESSAGE i000(zcm_efmoura) WITH 'Remoção cancelada'.
        EXIT.
      ELSE.

        DELETE FROM ztbedu_veiculos
          WHERE id_veiculo = wa_veiculo-id_veiculo.

        IF sy-subrc = 0.
          COMMIT WORK AND WAIT.
          MESSAGE i000(zcm_efmoura) WITH 'Eliminado com sucesso'.

        ELSE.
          ROLLBACK WORK.
          MESSAGE i000(zcm_efmoura) WITH 'Não conseguiu eliminar'.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDLOOP.

  PERFORM zf_select_dados.
  CALL METHOD lo_alv->refresh_table_display.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form zf_data_insert
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM zf_data_insert .

  DATA: lv_max TYPE zed_idveiculo.

  DATA: tab_pop TYPE TABLE OF sval,
        wa_pop  TYPE sval.

  wa_pop-tabname   = 'ZTBEDU_VEICULOS'.
  wa_pop-fieldname = 'MONTADORA'.
  APPEND wa_pop TO tab_pop.
  wa_pop-tabname   = 'ZTBEDU_VEICULOS'.
  wa_pop-fieldname = 'MARCA'.
  APPEND wa_pop TO tab_pop.
  wa_pop-tabname   = 'ZTBEDU_VEICULOS'.
  wa_pop-fieldname = 'PLACA'.
  APPEND wa_pop TO tab_pop.
  wa_pop-tabname   = 'ZTBEDU_VEICULOS'.
  wa_pop-fieldname = 'ANO'.
  APPEND wa_pop TO tab_pop.
  wa_pop-tabname   = 'ZTBEDU_VEICULOS'.
  wa_pop-fieldname = 'COR'.
  APPEND wa_pop TO tab_pop.
  wa_pop-tabname   = 'ZTBEDU_VEICULOS'.
  wa_pop-fieldname = 'OBS'.
  APPEND wa_pop TO tab_pop.

  CALL FUNCTION 'POPUP_GET_VALUES'
    EXPORTING
      popup_title     = 'Enter input:'
*     START_COLUMN    = '1'
*     START_ROW       = '1'
    TABLES
      fields          = tab_pop
    EXCEPTIONS
      error_in_fields = 1
      OTHERS          = 2.

  LOOP AT tab_pop INTO wa_pop.

    CASE wa_pop-fieldname.
      WHEN 'MONTADORA'.
        ztbedu_veiculos-montadora = wa_pop-value.
      WHEN 'MARCA'.
        ztbedu_veiculos-marca = wa_pop-value.
      WHEN 'PLACA'.
        ztbedu_veiculos-placa = wa_pop-value.
      WHEN 'ANO'.
        ztbedu_veiculos-ano = wa_pop-value.
      WHEN 'COR'.
        ztbedu_veiculos-cor = wa_pop-value.
      WHEN 'OBS'.
        ztbedu_veiculos-obs = wa_pop-value.
    ENDCASE.

  ENDLOOP.

  CALL FUNCTION 'NUMBER_GET_NEXT'
    EXPORTING
      nr_range_nr             = '01'
      object                  = 'ZNREDU_1'
    IMPORTING
      number                  = lv_max
    EXCEPTIONS
      interval_not_found      = 1
      number_range_not_intern = 2
      object_not_found        = 3
      quantity_is_0           = 4
      quantity_is_not_1       = 5
      interval_overflow       = 6
      buffer_overflow         = 7
      OTHERS                  = 8.
  IF sy-subrc <> 0.
   MESSAGE i000(zcm_efmoura) WITH 'Number Range problem'.
   EXIT.
  ENDIF.

  ztbedu_veiculos-id_veiculo  = lv_max.
  ztbedu_veiculos-data_compra = sy-datum.
  ztbedu_veiculos-situacao    = 'P'.

  INSERT ztbedu_veiculos.
  IF sy-subrc = 0.
    COMMIT WORK AND WAIT.
    MESSAGE i000(zcm_efmoura) WITH 'Adicionado'.
  ELSE.
    ROLLBACK WORK.
    MESSAGE i000(zcm_efmoura) WITH 'Não Adicionado'.
  ENDIF.

  CLEAR ztbedu_veiculos.

  PERFORM zf_select_dados.
  CALL METHOD lo_alv->refresh_table_display.

ENDFORM.