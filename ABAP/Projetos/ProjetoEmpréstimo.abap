************************************************************************
* NOME DO PROGRAMA    :  ZMPEDU_EMPREST                                *
* TRANSAÇÃO           :                                                *
* TÍTULO DO PROGRAMA  : Empréstimo de Veículos                         *
* DESCRIÇÃO           : Pool de módulos para empréstimos de veículos   *
* PROGRAMADOR         : Eduardo Freitas Moura (EFREITAS)               *
* DATA                : 18.03.2022                                     *
************************************************************************
PROGRAM zmpedu_emprest.

  " Reports Aparecem apenas o símbolo de situação e status, não o nome fixo
  " Consertar perfoms genéricos

"-----------Includes-------------"
"Tela Inicial
INCLUDE zmpedu_emprest_pbo_00.
INCLUDE zmpedu_emprest_pai_00.

"Tela Cadastro
INCLUDE zmpedu_emprest_pbo_01.
INCLUDE zmpedu_emprest_pai_01.

"Tela Solicitação
INCLUDE zmpedu_emprest_pbo_02.
INCLUDE zmpedu_emprest_pai_02.

"Tela Aprovação, Essa talvez eu não tenha precisado usar outra tela
INCLUDE zmpedu_emprest_pbo_03.
INCLUDE zmpedu_emprest_pai_03.

"Tela Retirada e Devolução, mesmo caso que a de cima
INCLUDE zmpedu_emprest_pbo_04.
INCLUDE zmpedu_emprest_pai_04.

"Tela de reports
INCLUDE zmpedu_emprest_pbo_05.
INCLUDE zmpedu_emprest_pai_05.

"Tela de emissão de recibos
INCLUDE zmpedu_emprest_pbo_06.
INCLUDE zmpedu_emprest_pai_06.


*----------------------------------------------------------------------*
***INCLUDE ZMPEDU_EMPREST_PBO_00.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
 SET PF-STATUS 'ZSTATUS_EMPREST'.
* SET TITLEBAR 'xxx'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module SELECIONA_DADOS00 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE seleciona_dados00 OUTPUT.
  TABLES: ztbedu_emprest, ztbedu_empregado, ztbedu_veiculos .

"Tela 101
  TYPES: BEGIN OF tp_dados,
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
         END OF tp_dados.

"Tela 102
TYPES: BEGIN OF tp_dados_veiculo,
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
         END OF tp_dados_veiculo.

"Tela 103
  TYPES:
    BEGIN OF tp_emprg,
      id_empregado   TYPE ztbedu_empregado-id_empregado,
      nome_empregado TYPE ztbedu_empregado-nome_empregado,
    END OF tp_emprg,

    BEGIN OF tp_veic,
      id_veiculo TYPE ztbedu_veiculos-id_veiculo,
      montadora  TYPE ztbedu_veiculos-montadora,
      marca      TYPE ztbedu_veiculos-marca,
    END OF tp_veic,


    BEGIN OF tp_emprest,
      id_emprestimo  TYPE ztbedu_emprest-id_emprestimo,
      id_veiculo     TYPE ztbedu_emprest-id_veiculo,
      id_empregado   TYPE ztbedu_emprest-id_empregado,
      dt_ini_emprest TYPE ztbedu_emprest-dt_ini_emprest,
      dt_fim_emprest TYPE ztbedu_emprest-dt_fim_emprest,
      status         TYPE ztbedu_emprest-status,
      obs            TYPE ztbedu_emprest-obs,
    END OF tp_emprest,


    BEGIN OF tp_aprov,
      id_emprestimo  TYPE ztbedu_emprest-id_emprestimo,
      id_veiculo     TYPE ztbedu_emprest-id_veiculo,
      montadora      TYPE ztbedu_veiculos-montadora,
      marca          TYPE ztbedu_veiculos-marca,
      id_empregado   TYPE ztbedu_emprest-id_empregado,
      nome_empregado TYPE ztbedu_empregado-nome_empregado,
      dt_ini_emprest TYPE ztbedu_emprest-dt_ini_emprest,
      dt_fim_emprest TYPE ztbedu_emprest-dt_fim_emprest,
      total_dias(3)  TYPE c,
      status         TYPE ztbedu_emprest-status,
      obs            TYPE ztbedu_emprest-obs,
      cor            TYPE lvc_t_scol,
    END OF tp_aprov.

ENDMODULE.

*----------------------------------------------------------------------*
***INCLUDE ZMPEDU_EMPREST_PAI_00.
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
    WHEN 'BT1'.
      LEAVE TO SCREEN '0101'.
    WHEN 'BT2'.
      LEAVE TO SCREEN '0102'.
    WHEN 'BT3'.
      LEAVE TO SCREEN '0103'.
    WHEN 'BT4'.
      LEAVE TO SCREEN '0104'.
    WHEN 'BT5'.
      LEAVE TO SCREEN '0106'.
    WHEN 'BT6'.
      LEAVE TO SCREEN '0105'.
    WHEN OTHERS.
  ENDCASE.

ENDMODULE.


*----------------------------------------------------------------------*
***INCLUDE ZMPEDU_EMPREST_PBO_01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0101 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0101 OUTPUT.
  SET PF-STATUS 'ZSTATUS_EMPREST'.
  SET TITLEBAR 'Tela de Cadastro'.
ENDMODULE.


*&---------------------------------------------------------------------*
*& Module SELECIONA_DADOS OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE seleciona_dados01 OUTPUT.

  DATA: lt_dados TYPE TABLE OF tp_dados,
        ls_dados TYPE tp_dados.


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
    INTO TABLE lt_dados[].

  SORT lt_dados ASCENDING BY id_veiculo.

ENDMODULE.



*&---------------------------------------------------------------------*
*& Module SCREEN_MODIFY OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE screen_modify OUTPUT.
  LOOP AT SCREEN.
    IF ztbedu_veiculos-eliminado = 'X'.

      IF screen-name = 'ZTBEDU_VEICULOS-MONTADORA'.
        screen-input    = '0'.
        MODIFY SCREEN FROM screen.
      ENDIF.

      IF screen-name = 'ZTBEDU_VEICULOS-MARCA'.
        screen-input    = '0'.
        MODIFY SCREEN FROM screen.
      ENDIF.

      IF screen-name = 'ZTBEDU_VEICULOS-PLACA'.
        screen-input    = '0'.
        MODIFY SCREEN FROM screen.
      ENDIF.

      IF screen-name = 'ZTBEDU_VEICULOS-ANO'.
        screen-input    = '0'.
        MODIFY SCREEN FROM screen.
      ENDIF.

      IF screen-name = 'ZTBEDU_VEICULOS-COR'.
        screen-input    = '0'.
        MODIFY SCREEN FROM screen.
      ENDIF.

      IF screen-name = 'ZTBEDU_VEICULOS-DATA_COMPRA'.
        screen-input    = '0'.
        MODIFY SCREEN FROM screen.
      ENDIF.

      IF screen-name = 'ZTBEDU_VEICULOS-OBS'.
        screen-input    = '0'.
        MODIFY SCREEN FROM screen.
      ENDIF.

    ENDIF.
  ENDLOOP.
ENDMODULE.

*----------------------------------------------------------------------*
***INCLUDE ZMPEDU_EMPREST_PAI_01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0101  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0101 INPUT.
  CASE sy-ucomm.
    WHEN 'BACK'.
      CLEAR ztbedu_veiculos.
      LEAVE TO SCREEN '0100'.
    WHEN 'CANC'.
      LEAVE PROGRAM.
    WHEN 'ENDE'.
      LEAVE PROGRAM.
    WHEN 'SAVE'.
      READ TABLE lt_dados INTO ls_dados WITH KEY id_veiculo = ztbedu_veiculos-id_veiculo.
      IF sy-subrc <> 0.
        PERFORM zf_cadastra_veiculo.
      ELSE.
        PERFORM zf_atualiza_veiculo.
      ENDIF.
    WHEN 'BT12'.
      PERFORM zf_elimina_veiculo.
    WHEN 'ENTR' .
      PERFORM zf_refresh_data.
    WHEN 'BT11'.
      CLEAR ztbedu_veiculos.
    WHEN 'BT13'.
      CLEAR ztbedu_veiculos.
      SUBMIT zedu_carga_veiculos VIA SELECTION-SCREEN AND RETURN.
    WHEN OTHERS.
  ENDCASE.
ENDMODULE.

*&---------------------------------------------------------------------*
*& Form zf_cadastra_veiculo
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM zf_cadastra_veiculo.

  DATA: lv_max TYPE zed_idveiculo.

  CALL FUNCTION 'NUMBER_GET_NEXT'
    EXPORTING
      nr_range_nr             = '01'
      object                  = 'ZNR_IDVEIC'
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
* Implement suitable error handling here
  ELSE.


    IF  ztbedu_veiculos-montadora   = ' ' OR
        ztbedu_veiculos-marca       = ' ' OR
        ztbedu_veiculos-placa       = ' ' OR
        ztbedu_veiculos-ano         = ' ' OR
        ztbedu_veiculos-cor         = ' ' OR
        ztbedu_veiculos-data_compra = ' '.

      MESSAGE 'Preencha todos os campos necessários' TYPE 'I'.

    ELSE.

      ztbedu_veiculos-id_veiculo = lv_max.
      ztbedu_veiculos-situacao = 'P'.
      ztbedu_veiculos-eliminado = ''.

      INSERT ztbedu_veiculos.
      IF sy-subrc = 0.
        MESSAGE: i005(zcm_efmoura) WITH ztbedu_veiculos-id_veiculo.
      ENDIF.

    ENDIF.
  ENDIF.


ENDFORM.

*&---------------------------------------------------------------------*
*& Form zf_atualiza_veiculo
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM zf_atualiza_veiculo .

  IF     ztbedu_veiculos-id_veiculo  = ' ' OR
         ztbedu_veiculos-montadora   = ' ' OR
         ztbedu_veiculos-marca       = ' ' OR
         ztbedu_veiculos-placa       = ' ' OR
         ztbedu_veiculos-ano         = ' ' OR
         ztbedu_veiculos-cor         = ' ' OR
         ztbedu_veiculos-data_compra = ' '.
    MESSAGE 'Preencha todos os campos necessários' TYPE 'I'.
  ELSE.
*    READ TABLE lt_dados INTO ls_dados WITH KEY id_veiculo = ztbedu_veiculos-id_veiculo.

    IF ls_dados-situacao = 'E'.
      MESSAGE: 'Situações tipos E não podem ser alteradas' TYPE 'I'.

    ELSE.
      UPDATE ztbedu_veiculos
        SET id_veiculo  = ztbedu_veiculos-id_veiculo
            montadora   = ztbedu_veiculos-montadora
            marca       = ztbedu_veiculos-marca
            placa       = ztbedu_veiculos-placa
            ano         = ztbedu_veiculos-ano
            cor         = ztbedu_veiculos-cor
            data_compra = ztbedu_veiculos-data_compra
*            situacao    = ztbedu_veiculos-situacao
            obs         = ztbedu_veiculos-obs
            eliminado   = ztbedu_veiculos-eliminado
       WHERE id_veiculo = ztbedu_veiculos-id_veiculo.
      IF sy-subrc = 0.
        MESSAGE: i007(zcm_efmoura) WITH ztbedu_veiculos-id_veiculo.
        PERFORM zf_preenche_log.
      ENDIF.
    ENDIF.
    CLEAR ls_dados.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form zf_elimina_veiculo
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM zf_elimina_veiculo .

  DATA ans TYPE c.

  IF ztbedu_veiculos-id_veiculo IS NOT INITIAL.

    CALL FUNCTION 'POPUP_TO_CONFIRM'
      EXPORTING
        titlebar              = 'Confirmação Eliminação'
        text_question         = 'Prosseguir com Eliminação?'
        text_button_1         = 'PROSSEGUIR'
        icon_button_1         = 'ICON_CHECKED'
        text_button_2         = 'CANCELAR'
        icon_button_2         = 'ICON_CANCEL'
        display_cancel_button = ' '
        popup_type            = 'ICON_MESSAGE_ERROR'
      IMPORTING
        answer                = ans.
    IF ans = 2.
      MESSAGE 'Eliminação cancelada' TYPE 'I'.
      EXIT.
    ELSE.

      READ TABLE lt_dados INTO ls_dados WITH KEY id_veiculo = ztbedu_veiculos-id_veiculo.
      ls_dados-eliminado = 'X'.

      UPDATE ztbedu_veiculos
      SET eliminado = ls_dados-eliminado
      WHERE id_veiculo = ls_dados-id_veiculo.
      IF sy-subrc = 0.
        MESSAGE: i006(zcm_efmoura) WITH ztbedu_veiculos-id_veiculo.
        PERFORM zf_log_eliminado.
      ENDIF.
      CLEAR ls_dados.
    ENDIF.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form zf_refresh_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM zf_refresh_data .

  IF ztbedu_veiculos-id_veiculo IS NOT INITIAL.

    READ TABLE lt_dados INTO ls_dados WITH KEY id_veiculo = ztbedu_veiculos-id_veiculo.
    ztbedu_veiculos-id_veiculo  = ls_dados-id_veiculo.
    ztbedu_veiculos-montadora   = ls_dados-montadora.
    ztbedu_veiculos-marca       = ls_dados-marca.
    ztbedu_veiculos-placa       = ls_dados-placa.
    ztbedu_veiculos-ano         = ls_dados-ano.
    ztbedu_veiculos-cor         = ls_dados-cor.
    ztbedu_veiculos-data_compra = ls_dados-data_compra.
    ztbedu_veiculos-situacao    = ls_dados-situacao.
    ztbedu_veiculos-obs         = ls_dados-obs.
    ztbedu_veiculos-eliminado   = ls_dados-eliminado.

    CLEAR ls_dados.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form zf_preenche_log
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM zf_preenche_log.

  IF ztbedu_veiculos-montadora NE ls_dados-montadora .
    PERFORM zf_log_update USING 'MONTADORA' ls_dados-montadora ztbedu_veiculos-montadora  .

  ELSEIF ztbedu_veiculos-marca  NE ls_dados-marca .
    PERFORM zf_log_update USING 'MARCA' ls_dados-marca ztbedu_veiculos-marca.

  ELSEIF ztbedu_veiculos-placa  NE ls_dados-placa .
    PERFORM zf_log_update USING 'PLACA' ls_dados-placa ztbedu_veiculos-placa .

  ELSEIF ztbedu_veiculos-ano NE ls_dados-ano .
    PERFORM zf_log_update USING 'ANO' ls_dados-ano ztbedu_veiculos-ano  .

  ELSEIF ztbedu_veiculos-cor NE ls_dados-cor .
    PERFORM zf_log_update USING 'COR' ls_dados-cor ztbedu_veiculos-cor .

  ELSEIF ztbedu_veiculos-data_compra NE ls_dados-data_compra.
    PERFORM zf_log_update USING 'DATA_COMPRA' ls_dados-data_compra ztbedu_veiculos-data_compra.

  ELSEIF ztbedu_veiculos-situacao NE ls_dados-situacao .
    PERFORM zf_log_update USING 'STUACAO' ls_dados-situacao ztbedu_veiculos-situacao.

  ELSEIF ztbedu_veiculos-obs  NE ls_dados-obs.
    PERFORM zf_log_update USING 'OBS' ls_dados-obs ztbedu_veiculos-obs .

  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form zf_log_update
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
FORM zf_log_update  USING  VALUE(p_campo) p_old p_new.

  DATA: id  TYPE zed_id_empregado,
        old TYPE zed_valor_antigo,
        new TYPE zed_valor_novo.

  id =  0.
  old = p_old.
  new = p_new.

  CALL FUNCTION 'ZFM_PREENCHE_LOG'
    EXPORTING
      i_idempregado  = id
      i_info_campo   = p_campo
      i_valor_antigo = old
      i_valor_novo   = new
    EXCEPTIONS
      id_not_found   = 1
      valor_negativo = 2
      OTHERS         = 3.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form zf_log_eliminado
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM zf_log_eliminado .

  DATA: id  TYPE zed_id_empregado.

  id =  0.

  CALL FUNCTION 'ZFM_PREENCHE_LOG'
    EXPORTING
      i_idempregado  = id
      i_info_campo   = 'Eiminar Veículo'
      i_valor_antigo = ' '
      i_valor_novo   = 'X'
    EXCEPTIONS
      id_not_found   = 1
      valor_negativo = 2
      OTHERS         = 3.


ENDFORM.


*----------------------------------------------------------------------*
***INCLUDE ZMPEDU_EMPREST_PBO_02.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0102 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0102 OUTPUT.
  SET PF-STATUS 'ZSTATUS_EMPREST'.
* SET TITLEBAR 'xxx'.
ENDMODULE.

*&---------------------------------------------------------------------*
*& Module SELECIONA_DADOS02 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE seleciona_dados02 OUTPUT.


  DATA: lt_aux TYPE TABLE OF tp_dados_veiculo,
        ls_aux TYPE tp_dados_veiculo.

  DATA: lt_aux_emprg TYPE TABLE OF tp_emprest,
        ls_aux_emprg TYPE tp_emprest.


ENDMODULE.


*----------------------------------------------------------------------*
***INCLUDE ZMPEDU_EMPREST_PAI_02.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0102  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0102 INPUT.
  CASE sy-ucomm.
    WHEN 'BACK'.
      CLEAR ztbedu_emprest.
      LEAVE TO SCREEN '0100'.

    WHEN 'CANC'.
      LEAVE PROGRAM.

    WHEN 'ENDE'.
      LEAVE PROGRAM.

    WHEN 'SAVE'.
      PERFORM zf_solicitation_validation.

    WHEN 'BT21'.
      CLEAR ztbedu_emprest.

    WHEN OTHERS.
  ENDCASE.
ENDMODULE.

*&---------------------------------------------------------------------*
*& Form zf_solicitation_validation
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM zf_solicitation_validation .

  SELECT SINGLE
           id_veiculo
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
      INTO  ls_aux
      WHERE id_veiculo = ztbedu_emprest-id_veiculo.

  SELECT SINGLE
    id_emprestimo
    id_veiculo
    id_empregado
    dt_ini_emprest
    dt_fim_emprest
    status
    obs
    FROM ztbedu_emprest
    INTO ls_aux_emprg
    WHERE id_empregado = ztbedu_emprest-id_empregado AND
          status NE 'E'.
  IF sy-subrc <> 0.
    IF ls_aux-situacao NE 'P'.
      MESSAGE 'O veículo não pode ser emprestado' TYPE 'I'.
    ELSE.
      IF ls_aux-eliminado = 'X'.
        MESSAGE 'Não pode ser emprestado um veículo eliminado' TYPE 'I'.  "TA AQUI"
      ELSE.
        IF + ztbedu_emprest-dt_fim_emprest >= ( + ztbedu_emprest-dt_ini_emprest ) AND
           + ztbedu_emprest-dt_ini_emprest >= sy-datum + 3.

          PERFORM zf_solicitation.

        ELSE.
          MESSAGE 'Não é possível solicitar um carro: menos de 3 dias de antecedência ou data fim menor que a início' TYPE 'I'.
        ENDIF.
      ENDIF.
    ENDIF.
  ELSE.
    MESSAGE 'Empregado com solicitação em aberto' TYPE 'I'.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form zf_solicitation
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM zf_solicitation .


  DATA: lv_max TYPE zed_idemprest.

  CALL FUNCTION 'NUMBER_GET_NEXT'
    EXPORTING
      nr_range_nr             = '01'
      object                  = 'ZNR_IDEMPT'
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


  ztbedu_emprest-id_emprestimo = lv_max.
  ztbedu_emprest-status = 'H'. "Aguardando Aprovação"
  ztbedu_emprest-dt_reg_empres = sy-datum.
  ztbedu_emprest-hr_reg_empres = sy-timlo.
  ztbedu_emprest-usu_reg_empres = sy-uname.


  INSERT ztbedu_emprest.
  IF sy-subrc = 0.
    MESSAGE 'Empréstimo solicitado' TYPE 'I'.
    PERFORM zf_update_situacao.
  ELSE.
    MESSAGE 'Não foi possível concluir a solicitação' TYPE 'I'.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form zf_update_situacao
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM zf_update_situacao .

  UPDATE ztbedu_veiculos
  SET situacao = 'S'
  WHERE id_veiculo = ls_aux-id_veiculo.

ENDFORM.



*&---------------------------------------------------------------------*
*& Form zf_log_situacao
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM zf_log_situacao .

  DATA: id   TYPE zed_id_empregado,
        old  TYPE zed_valor_antigo,
        novo TYPE zed_valor_novo.

  id =  0.
  old = 'Pátio'.
  novo = 'Solicitado'.

  CALL FUNCTION 'ZFM_PREENCHE_LOG'
    EXPORTING
      i_idempregado  = id
      i_info_campo   = 'SITUACAO'
      i_valor_antigo = old
      i_valor_novo   = novo
    EXCEPTIONS
      id_not_found   = 1
      valor_negativo = 2
      OTHERS         = 3.

ENDFORM.

*----------------------------------------------------------------------*
***INCLUDE ZMPEDU_EMPREST_PBO_03.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0103 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0103 OUTPUT.
  SET PF-STATUS 'ZSTATUS_EMPREST'.
* SET TITLEBAR 'xxx'.
ENDMODULE.

*&---------------------------------------------------------------------*
*& Module SELECIONA_DADOS3 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

MODULE seleciona_dados03 OUTPUT.

  "---TABELAS_INTERNAS---"
  DATA: lt_aprov   TYPE TABLE OF tp_aprov,
        lt_emprest TYPE TABLE OF tp_emprest,
        lt_veic    TYPE TABLE OF tp_veic,
        lt_emprg   TYPE TABLE OF tp_emprg.

  "------ESTRUTURAS------"
  DATA: ls_aprov   TYPE tp_aprov,
        ls_emprest TYPE tp_emprest,
        ls_veic    TYPE tp_veic,
        ls_emprg   TYPE tp_emprg.

  "-------FIELDCAT-------"
  TYPE-POOLS: slis.
  DATA: it_fcat TYPE slis_t_fieldcat_alv,
        wa_fcat LIKE LINE OF it_fcat.

  "--------LAYOUT--------"
  DATA:  ls_layout TYPE slis_layout_alv.

  "------CELL_COLOR------"
  DATA: wa_cor TYPE lvc_s_scol.


  "----------------------------------------------------------"

  PERFORM zf_select_aprov.
  PERFORM zf_monta_aprov_fcat.
  PERFORM zf_display_aprov.   "Solução ao me ver malandra
  LEAVE TO SCREEN '0100'.
ENDMODULE.


*&---------------------------------------------------------------------*
*& Form zf_select_aprov
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM zf_select_aprov.

  SELECT   id_emprestimo
           id_veiculo
           id_empregado
           dt_ini_emprest
           dt_fim_emprest
           status
           obs
      FROM ztbedu_emprest
      INTO TABLE lt_emprest
      WHERE status = 'H'.

  SELECT id_veiculo
         montadora
         marca
    FROM ztbedu_veiculos
    INTO TABLE lt_veic.

  SELECT id_empregado
         nome_empregado
    FROM ztbedu_empregado
    INTO TABLE lt_emprg.


  LOOP AT lt_emprest INTO ls_emprest.

    READ TABLE lt_veic  INTO ls_veic   WITH KEY id_veiculo = ls_emprest-id_veiculo.
    READ TABLE lt_emprg INTO ls_emprg WITH KEY id_empregado = ls_emprest-id_empregado.

    ls_aprov-id_emprestimo  = ls_emprest-id_emprestimo.
    ls_aprov-id_veiculo     = ls_emprest-id_veiculo.
    ls_aprov-montadora      = ls_veic-montadora.
    ls_aprov-marca          = ls_veic-marca.
    ls_aprov-id_empregado   = ls_emprest-id_empregado.
    ls_aprov-nome_empregado = ls_emprg-nome_empregado.
    ls_aprov-dt_ini_emprest = ls_emprest-dt_ini_emprest.
    ls_aprov-dt_fim_emprest = ls_emprest-dt_fim_emprest.
    ls_aprov-total_dias     = ls_emprest-dt_fim_emprest - ls_emprest-dt_ini_emprest.
    ls_aprov-status         = ls_emprest-status.
    ls_aprov-obs            = ls_emprest-obs.


    wa_cor-fname = 'STATUS'.
    wa_cor-color-col = '3'.
    wa_cor-color-int = '1'.  "1 = Intensified on, 0 = Intensified off
    wa_cor-color-inv = '0'.  "1 = text colour, 0 = background colour
    APPEND wa_cor TO ls_aprov-cor.

    APPEND ls_aprov TO lt_aprov.
    CLEAR ls_aprov.

  ENDLOOP.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form zf_monta_aprov_fcat
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM zf_monta_aprov_fcat .

*--------------------------------------*
  wa_fcat-col_pos = '1' .
  wa_fcat-fieldname = 'ID_EMPRESTIMO' .
  wa_fcat-tabname = 'LT_APROV' .
  wa_fcat-seltext_m = 'ID_EMPREST' .
  wa_fcat-key = 'X' .
  wa_fcat-outputlen = 12.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '2' .
  wa_fcat-fieldname = 'ID_VEICULO' .
  wa_fcat-tabname = 'LT_APROV' .
  wa_fcat-seltext_m = 'ID_VEICULO' .
  wa_fcat-outputlen = 12.
*  wa_fcat-edit = 'X' .
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '3' .
  wa_fcat-fieldname = 'MONTADORA' .
  wa_fcat-tabname = 'LT_APROV' .
  wa_fcat-seltext_m = 'MONTADORA' .
  wa_fcat-outputlen = 20.
*  wa_fcat-edit = 'X' .
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '4' .
  wa_fcat-fieldname = 'MARCA' .
  wa_fcat-tabname = 'LT_APROV' .
  wa_fcat-seltext_m = 'MARCA' .
  wa_fcat-outputlen = 15.
*  wa_fcat-edit = 'X' .
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '5' .
  wa_fcat-fieldname = 'ID_EMPREGADO' .
  wa_fcat-tabname = 'LT_APROV' .
  wa_fcat-seltext_m = 'ID_EMPRG' .
  wa_fcat-outputlen = 10.
*  wa_fcat-edit = 'X' .
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '6' .
  wa_fcat-fieldname = 'NOME_EMPREGADO' .
  wa_fcat-tabname = 'LT_APROV' .
  wa_fcat-seltext_m = 'NOME_EMPRG' .
  wa_fcat-outputlen = 25.
*  wa_fcat-edit = 'X' .
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '7' .
  wa_fcat-fieldname = 'DT_INI_EMPREST' .
  wa_fcat-tabname = 'LT_APROV' .
  wa_fcat-seltext_m = 'DT_INI_EMPREST' .
  wa_fcat-outputlen = 12.
*  wa_fcat-edit = 'X' .
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '8' .
  wa_fcat-fieldname = 'DT_FIM_EMPREST' .
  wa_fcat-tabname = 'LT_APROV' .
  wa_fcat-seltext_m = 'DT_FIM_EMPREST' .
  wa_fcat-outputlen = 12.
*  wa_fcat-edit = 'X' .
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '9' .
  wa_fcat-fieldname = 'TOTAL_DIAS' .
  wa_fcat-tabname = 'LT_APROV' .
  wa_fcat-seltext_m = 'TOTAL DIAS' .
  wa_fcat-outputlen = 10.
*  wa_fcat-edit = 'X' .
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '10' .
  wa_fcat-fieldname = 'STATUS' .
  wa_fcat-tabname = 'LT_APROV' .
  wa_fcat-seltext_m = 'STATUS' .
  wa_fcat-outputlen = 15.
  wa_fcat-ref_fieldname = 'STATUS'.
  wa_fcat-ref_tabname = 'ZTBEDU_EMPREST'.
  wa_fcat-edit = 'X' .
*  wa_fcat-f4availabl = 'X'.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '11' .
  wa_fcat-fieldname = 'OBS' .
  wa_fcat-tabname = 'LT_APROV' .
  wa_fcat-seltext_m = 'OBS' .
  wa_fcat-outputlen = 50.
*  wa_fcat-edit = 'X' .
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*

ENDFORM.

*----------------------------------------------------------------------*
***INCLUDE ZMPEDU_EMPREST_PAI_03.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0103  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0103 INPUT.
  CASE sy-ucomm.
    WHEN 'BACK'.
      LEAVE TO SCREEN '0100'.
    WHEN 'CANC'.
      LEAVE PROGRAM.
    WHEN 'ENDE'.
      LEAVE PROGRAM.
    WHEN 'BT1'.
      PERFORM zf_display_aprov.
    WHEN OTHERS.
  ENDCASE.
ENDMODULE.




*&---------------------------------------------------------------------*
*& Form zf_display_aprov
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM zf_display_aprov .

  ls_layout-coltab_fieldname = 'COR'.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program      = sy-repid
      i_callback_user_command = 'ZF_USER_COMMAND1'
      is_layout               = ls_layout
      it_fieldcat             = it_fcat
      i_save                  = 'A'
    TABLES
      t_outtab                = lt_aprov
    EXCEPTIONS
      program_error           = 1
      OTHERS                  = 2.
  IF sy-subrc <> 0.

  ENDIF.

  CLEAR: lt_aprov, lt_emprest, lt_emprg, lt_veic, it_fcat.

ENDFORM.

FORM zf_user_command1 USING vl_ucomm LIKE sy-ucomm
                           rs_selfield TYPE slis_selfield.

  CASE vl_ucomm.
    WHEN '&DATA_SAVE'.
      PERFORM zf_save_status.
    WHEN OTHERS.
  ENDCASE.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form zf_save_status
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM zf_save_status .

  LOOP AT lt_aprov INTO ls_aprov.

  READ TABLE lt_emprest INTO ls_emprest WITH KEY id_emprestimo = ls_emprest-id_emprestimo.

  IF ls_aprov-status NE ls_emprest-status AND ls_aprov-status NE 'W' AND ls_aprov-status NE 'E'.

    UPDATE ztbedu_emprest
    SET status = ls_aprov-status
        dt_alt_emprest = sy-datum
        hr_alt_emprest = sy-timlo
        usu_alt_emprest = sy-uname
    WHERE id_emprestimo = ls_aprov-id_emprestimo.
    IF sy-subrc = 0 .
      PERFORM zf_log_status.
    ENDIF.

   ENDIF.
  ENDLOOP.

  MESSAGE: 'Dados Salvos' TYPE 'I'.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form zf_log_status
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM zf_log_status .

  DATA: id   TYPE zed_id_empregado,
      old TYPE zed_valor_antigo,
      novo TYPE zed_valor_novo.

  id =  0.
  old = 'Aguardando Aprovação'.
    IF ls_emprest-status = 'H' AND ls_aprov-status = 'R'.
    novo = 'Reprovado'.
  ELSEIF ls_emprest-status = 'H' AND ls_aprov-status = 'A'.
    novo = 'Aprovado'.
  ENDIF.

  CALL FUNCTION 'ZFM_PREENCHE_LOG'
    EXPORTING
      i_idempregado  = id
      i_info_campo   = 'STATUS'
      i_valor_antigo = old
      i_valor_novo   = novo
    EXCEPTIONS
      id_not_found   = 1
      valor_negativo = 2
      OTHERS         = 3.

ENDFORM.

*----------------------------------------------------------------------*
***INCLUDE ZMPEDU_EMPREST_PBO_04.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0104 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0104 OUTPUT.
  SET PF-STATUS 'ZSTATUS_EMPREST'.
* SET TITLEBAR 'xxx'.
ENDMODULE.

*&---------------------------------------------------------------------*
*& Module SELECIONA_DADOS04 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE seleciona_dados04 OUTPUT.

  "---TABELAS_INTERNAS---"
  DATA: lt_aprov2   TYPE TABLE OF tp_aprov,
        lt_emprest2 TYPE TABLE OF tp_emprest,
        lt_veic2    TYPE TABLE OF tp_veic,
        lt_emprg2   TYPE TABLE OF tp_emprg.

  "------ESTRUTURAS------"
  DATA: ls_aprov2   TYPE tp_aprov,
        ls_emprest2 TYPE tp_emprest,
        ls_veic2    TYPE tp_veic,
        ls_emprg2   TYPE tp_emprg.

  "-------FIELDCAT-------"
  TYPE-POOLS: slis.
  DATA: it_fcat2 TYPE slis_t_fieldcat_alv,
        wa_fcat2 LIKE LINE OF it_fcat.

  SELECT   id_emprestimo
           id_veiculo
           id_empregado
           dt_ini_emprest
           dt_fim_emprest
           status
           obs
      FROM ztbedu_emprest
      INTO TABLE lt_emprest2
      WHERE status = 'A' OR status = 'W'.

  SELECT id_veiculo
         montadora
         marca
    FROM ztbedu_veiculos
    INTO TABLE lt_veic2.

  SELECT id_empregado
         nome_empregado
    FROM ztbedu_empregado
    INTO TABLE lt_emprg2.


  LOOP AT lt_emprest2 INTO ls_emprest2.

    READ TABLE lt_veic2  INTO ls_veic2   WITH KEY id_veiculo = ls_emprest2-id_veiculo.
    READ TABLE lt_emprg2 INTO ls_emprg2  WITH KEY id_empregado = ls_emprest2-id_empregado.

    ls_aprov2-id_emprestimo  = ls_emprest2-id_emprestimo.
    ls_aprov2-id_veiculo     = ls_emprest2-id_veiculo.
    ls_aprov2-montadora      = ls_veic2-montadora.
    ls_aprov2-marca          = ls_veic2-marca.
    ls_aprov2-id_empregado   = ls_emprest2-id_empregado.
    ls_aprov2-nome_empregado = ls_emprg2-nome_empregado.
    ls_aprov2-dt_ini_emprest = ls_emprest2-dt_ini_emprest.
    ls_aprov2-dt_fim_emprest = ls_emprest2-dt_fim_emprest.
    ls_aprov2-total_dias     = ls_emprest2-dt_fim_emprest - ls_emprest2-dt_ini_emprest.
    ls_aprov2-status         = ls_emprest2-status.
    ls_aprov2-obs            = ls_emprest2-obs.


    wa_cor-fname = 'STATUS'.
    wa_cor-color-col = '3'.
    wa_cor-color-int = '1'.  "1 = Intensified on, 0 = Intensified off
    wa_cor-color-inv = '0'.  "1 = text colour, 0 = background colour
    APPEND wa_cor TO ls_aprov2-cor.

    APPEND ls_aprov2 TO lt_aprov2.
    CLEAR ls_aprov2.

  ENDLOOP.

  PERFORM zf_monta_aprov_fcat2.
  PERFORM zf_display_retdev.
  LEAVE TO SCREEN '0100'.

ENDMODULE.


*&---------------------------------------------------------------------*
*& Form zf_monta_aprov_fcat2
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM zf_monta_aprov_fcat2 .

*--------------------------------------*
  wa_fcat2-col_pos = '1' .
  wa_fcat2-fieldname = 'ID_EMPRESTIMO' .
  wa_fcat2-tabname = 'LT_APROV2' .
  wa_fcat2-seltext_m = 'ID_EMPREST' .
  wa_fcat2-key = 'X' .
  wa_fcat2-outputlen = 12.
  APPEND wa_fcat2 TO it_fcat2 .
  CLEAR wa_fcat2 .
*--------------------------------------*
  wa_fcat2-col_pos = '2' .
  wa_fcat2-fieldname = 'ID_VEICULO' .
  wa_fcat2-tabname = 'LT_APROV2' .
  wa_fcat2-seltext_m = 'ID_VEICULO' .
  wa_fcat2-outputlen = 12.
*  wa_fcat-edit = 'X' .
  APPEND wa_fcat2 TO it_fcat2 .
  CLEAR wa_fcat2 .
*--------------------------------------*
  wa_fcat2-col_pos = '3' .
  wa_fcat2-fieldname = 'MONTADORA' .
  wa_fcat2-tabname = 'LT_APROV2' .
  wa_fcat2-seltext_m = 'MONTADORA' .
  wa_fcat2-outputlen = 20.
*  wa_fcat-edit = 'X' .
  APPEND wa_fcat2 TO it_fcat2 .
  CLEAR wa_fcat2 .
*--------------------------------------*
  wa_fcat2-col_pos = '4' .
  wa_fcat2-fieldname = 'MARCA' .
  wa_fcat2-tabname = 'LT_APROV2' .
  wa_fcat2-seltext_m = 'MARCA' .
  wa_fcat2-outputlen = 15.
*  wa_fcat-edit = 'X' .
  APPEND wa_fcat2 TO it_fcat2 .
  CLEAR wa_fcat2 .
*--------------------------------------*
  wa_fcat2-col_pos = '5' .
  wa_fcat2-fieldname = 'ID_EMPREGADO' .
  wa_fcat2-tabname = 'LT_APROV2' .
  wa_fcat2-seltext_m = 'ID_EMPRG' .
  wa_fcat2-outputlen = 10.
*  wa_fcat-edit = 'X' .
  APPEND wa_fcat2 TO it_fcat2 .
  CLEAR wa_fcat2 .
*--------------------------------------*
  wa_fcat2-col_pos = '6' .
  wa_fcat2-fieldname = 'NOME_EMPREGADO' .
  wa_fcat2-tabname = 'LT_APROV2' .
  wa_fcat2-seltext_m = 'NOME_EMPRG' .
  wa_fcat2-outputlen = 25.
*  wa_fcat-edit = 'X' .
  APPEND wa_fcat2 TO it_fcat2 .
  CLEAR wa_fcat2 .
*--------------------------------------*
  wa_fcat2-col_pos = '7' .
  wa_fcat2-fieldname = 'DT_INI_EMPREST' .
  wa_fcat2-tabname = 'LT_APROV2' .
  wa_fcat2-seltext_m = 'DT_INI_EMPREST' .
  wa_fcat2-outputlen = 12.
*  wa_fcat-edit = 'X' .
  APPEND wa_fcat2 TO it_fcat2 .
  CLEAR wa_fcat2 .
*--------------------------------------*
  wa_fcat2-col_pos = '8' .
  wa_fcat2-fieldname = 'DT_FIM_EMPREST' .
  wa_fcat2-tabname = 'LT_APROV2' .
  wa_fcat2-seltext_m = 'DT_FIM_EMPREST' .
  wa_fcat2-outputlen = 12.
*  wa_fcat-edit = 'X' .
  APPEND wa_fcat2 TO it_fcat2 .
  CLEAR wa_fcat2 .
*--------------------------------------*
  wa_fcat2-col_pos = '9' .
  wa_fcat2-fieldname = 'TOTAL_DIAS' .
  wa_fcat2-tabname = 'LT_APROV2' .
  wa_fcat2-seltext_m = 'TOTAL DIAS' .
  wa_fcat2-outputlen = 10.
*  wa_fcat-edit = 'X' .
  APPEND wa_fcat2 TO it_fcat2 .
  CLEAR wa_fcat2 .
*--------------------------------------*
  wa_fcat2-col_pos = '10' .
  wa_fcat2-fieldname = 'STATUS' .
  wa_fcat2-tabname = 'LT_APROV2' .
  wa_fcat2-seltext_m = 'STATUS' .
  wa_fcat2-outputlen = 15.
  wa_fcat2-ref_fieldname = 'STATUS'.
  wa_fcat2-ref_tabname = 'ZTBEDU_EMPREST'.
  wa_fcat2-edit = 'X' .
*  wa_fcat-f4availabl = 'X'.
  APPEND wa_fcat2 TO it_fcat2 .
  CLEAR wa_fcat2 .
*--------------------------------------*
  wa_fcat2-col_pos = '11' .
  wa_fcat2-fieldname = 'OBS' .
  wa_fcat2-tabname = 'LT_APROV2' .
  wa_fcat2-seltext_m = 'OBS' .
  wa_fcat2-outputlen = 50.
*  wa_fcat-edit = 'X' .
  APPEND wa_fcat2 TO it_fcat2 .
  CLEAR wa_fcat2 .
*--------------------------------------*

ENDFORM.


*----------------------------------------------------------------------*
***INCLUDE ZMPEDU_EMPREST_PAI_04.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0104  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0104 INPUT.
  CASE sy-ucomm.
    WHEN 'BACK'.
      LEAVE TO SCREEN '0100'.
    WHEN 'CANC'.
      LEAVE PROGRAM.
    WHEN 'ENDE'.
      LEAVE PROGRAM.
    WHEN 'BT1'.
      PERFORM zf_display_retdev.
    WHEN OTHERS.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Form zf_display_retdev
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM zf_display_retdev .

  ls_layout-coltab_fieldname = 'COR'.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program      = sy-repid
      i_callback_user_command = 'ZF_USER_COMMAND2'
      is_layout               = ls_layout
      it_fieldcat             = it_fcat2
      i_save                  = 'A'
    TABLES
      t_outtab                = lt_aprov2
    EXCEPTIONS
      program_error           = 1
      OTHERS                  = 2.
  IF sy-subrc <> 0.

  ENDIF.

  CLEAR: lt_aprov2, lt_emprest2, lt_emprg2, lt_veic2, it_fcat2.

ENDFORM.

FORM zf_user_command2 USING vl_ucomm LIKE sy-ucomm
                           rs_selfield TYPE slis_selfield.

  CASE vl_ucomm.
    WHEN '&DATA_SAVE'.
      PERFORM zf_save_status2.
    WHEN OTHERS.
  ENDCASE.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form zf_save_status2
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM zf_save_status2 .
 CLEAR lt_emprest2.
  LOOP AT lt_aprov2 INTO ls_aprov2.

    READ TABLE lt_emprest2 INTO ls_emprest2 WITH KEY id_emprestimo = ls_emprest2-id_emprestimo.
    READ TABLE lt_veic2 INTO ls_veic2 WITH KEY id_veiculo = ls_veic2-id_veiculo.

    IF ls_aprov2-status = 'W' AND ls_emprest2-status = 'A'.

      UPDATE ztbedu_emprest
      SET status = ls_aprov2-status
          dt_retirada = sy-datum
          hr_retirada = sy-timlo
          dt_alt_emprest = sy-datum
          hr_alt_emprest = sy-timlo
          usu_alt_emprest = sy-uname
      WHERE id_emprestimo = ls_aprov2-id_emprestimo.
      IF sy-subrc = 0.
        PERFORM zf_log_status2.
      ENDIF.

      UPDATE ztbedu_veiculos
      SET situacao = 'E'
      WHERE id_veiculo = ls_veic2-id_veiculo.
      IF sy-subrc = 0.
        PERFORM zf_log_situ USING 'E'.
      ENDIF.


    ELSEIF ls_aprov2-status = 'E' AND ls_emprest2-status = 'W'.

      UPDATE ztbedu_emprest
      SET status = ls_aprov2-status
          dt_entrega = sy-datum
          hr_entrega = sy-timlo
          dt_alt_emprest = sy-datum
          hr_alt_emprest = sy-timlo
          usu_alt_emprest = sy-uname
      WHERE id_emprestimo = ls_aprov2-id_emprestimo.
      IF sy-subrc = 0.
        PERFORM zf_log_status2.
      ENDIF.

      IF ztbedu_emprest-dt_entrega > ztbedu_emprest-dt_fim_emprest.

        UPDATE ztbedu_emprest
        SET obs = 'Entregue com atraso'
        WHERE id_emprestimo = ls_aprov2-id_emprestimo.

      ENDIF.

      UPDATE ztbedu_veiculos
      SET situacao = 'P'
      WHERE id_veiculo = ls_veic2-id_veiculo.
      IF sy-subrc = 0.
        PERFORM zf_log_situ USING 'P'.
      ENDIF.

    ELSEIF ( ls_aprov2-status = 'R' OR ls_aprov2-status = 'H' OR ls_aprov2-status = 'E' ) AND ls_emprest2-status = 'A'.
      MESSAGE: 'Mudança de status incorreta' TYPE 'I'.

    ELSEIF ( ls_aprov2-status = 'R' OR ls_aprov2-status = 'H' OR ls_aprov2-status = 'A') AND ls_emprest2-status = 'W'.
      MESSAGE: 'Mudança de status incorreta' TYPE 'I'.

    ENDIF.

  ENDLOOP.

  MESSAGE: 'Dados Salvos' TYPE 'I'.


ENDFORM.


*&---------------------------------------------------------------------*
*& Form zf_log_situ
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM zf_log_situ USING VALUE(p_situ).

  DATA: id   TYPE zed_id_empregado,
        situ TYPE zed_valor_antigo,
        novo TYPE zed_valor_novo.

  id =  0.
  IF p_situ = 'E'.
    situ = 'Solicitado'.
    novo = 'Emprestado'.
  ELSEIF p_situ = 'P'.
    situ = 'Emprestado'.
    novo = 'Pátio'.
  ENDIF.

  CALL FUNCTION 'ZFM_PREENCHE_LOG'
    EXPORTING
      i_idempregado  = id
      i_info_campo   = 'SITUACAO'
      i_valor_antigo = situ
      i_valor_novo   = novo
    EXCEPTIONS
      id_not_found   = 1
      valor_negativo = 2
      OTHERS         = 3.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form  zf_log_status2
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM zf_log_status2.

  DATA: id   TYPE zed_id_empregado,
        old  TYPE zed_valor_antigo,
        novo TYPE zed_valor_novo.

  id =  0.
  IF ls_emprest2-status = 'A' AND ls_aprov2-status = 'W'.
    old = 'Aprovado'.
    novo = 'Emprestado'.
  ELSEIF ls_emprest2-status = 'W' AND ls_aprov2-status = 'E'.
    old = 'Emprestado'.
    novo = 'Entregue'.
  ENDIF.

  CALL FUNCTION 'ZFM_PREENCHE_LOG'
    EXPORTING
      i_idempregado  = id
      i_info_campo   = 'STATUS'
      i_valor_antigo = old
      i_valor_novo   = novo
    EXCEPTIONS
      id_not_found   = 1
      valor_negativo = 2
      OTHERS         = 3.

ENDFORM.


*----------------------------------------------------------------------*
***INCLUDE ZMPEDU_EMPREST_PBO_05.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0105 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0105 OUTPUT.
 SET PF-STATUS 'ZSTATUS_EMPREST'.
* SET TITLEBAR 'xxx'.
ENDMODULE.


*----------------------------------------------------------------------*
***INCLUDE ZMPEDU_EMPREST_PAI_05.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0105  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0105 INPUT.
CASE sy-ucomm.
    WHEN 'BACK'.
      LEAVE TO SCREEN '0100'.
    WHEN 'CANC'.
      LEAVE PROGRAM.
    WHEN 'ENDE'.
      LEAVE PROGRAM.
    WHEN 'BT1'.
      SUBMIT zedu_relat_veiculos VIA SELECTION-SCREEN AND RETURN.
    WHEN 'BT2'.
      SUBMIT zedu_relat_emprest VIA SELECTION-SCREEN AND RETURN.
    WHEN 'BT3'.
      SUBMIT zedu_relat_log_emprest VIA SELECTION-SCREEN AND RETURN.
    WHEN 'BT4'.
      SUBMIT zedu_relat_empregado VIA SELECTION-SCREEN AND RETURN.
    WHEN OTHERS.
  ENDCASE.
ENDMODULE.


***********************************************************************
* NOME DO PROGRAMA    :  ZEDU_RELAT_VEICULOS                          *
* TRANSAÇÃO           :                                               *
* TÍTULO DO PROGRAMA  : Relatório de Veículos                         *
* DESCRIÇÃO           : Report para relatório de veículos             *
* PROGRAMADOR         : Eduardo Freitas Moura (EFREITAS)              *
* DATA                : 22.03.2022                                    *
***********************************************************************
REPORT zedu_relat_veiculos MESSAGE-ID zcm_efmoura.

TABLES: ztbedu_veiculos.

"----------TIPOS---------"
TYPES:
  BEGIN OF tp_veiculo,
    id_veiculo   TYPE ztbedu_veiculos-id_veiculo,
    montadora    TYPE ztbedu_veiculos-montadora,
    marca        TYPE ztbedu_veiculos-marca,
    placa        TYPE ztbedu_veiculos-placa,
    ano          TYPE ztbedu_veiculos-ano,
    cor          TYPE ztbedu_veiculos-cor,
    data_compra  TYPE ztbedu_veiculos-data_compra,
    situacao(10) TYPE c,
    obs          TYPE ztbedu_veiculos-obs,
    eliminado    TYPE ztbedu_veiculos-eliminado,
  END OF tp_veiculo.

"---TABELAS_INTERNAS---"
DATA: lt_veiculo  TYPE TABLE OF tp_veiculo,
      lt_dom      TYPE dd07v OCCURS 0 WITH HEADER LINE.


"------ESTRUTURAS------"
DATA: ls_veiculo  TYPE tp_veiculo,
      ls_dom      TYPE dd07v.

"-------FIELDCAT-------"
TYPE-POOLS: slis.
DATA: it_fcat TYPE slis_t_fieldcat_alv,
      wa_fcat LIKE LINE OF it_fcat.

"--------LAYOUT--------"
DATA: ls_layout TYPE slis_layout_alv.


"-------EVENTOS--------"
DATA: gt_events    TYPE slis_t_event,
      it_excluding TYPE slis_t_extab,
      s_excluding  TYPE slis_extab.

"----OUTRAS_GLOBAIS----"




"---------------TELA DE SELEÇÂO------------"
SELECTION-SCREEN: BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-001.

  SELECT-OPTIONS: s_idveic FOR ztbedu_veiculos-id_veiculo,
                  s_mont   FOR ztbedu_veiculos-montadora,
                  s_marca  FOR ztbedu_veiculos-marca,
                  s_situ   FOR ztbedu_veiculos-situacao,
                  s_elim   FOR ztbedu_veiculos-eliminado.

SELECTION-SCREEN: END OF BLOCK b01.

"----------------VALIDAÇÃO DE TELA-----------------"




"----------------INICIO_DA_SELEÇÃO-----------------"

START-OF-SELECTION.


  PERFORM: zf_select,
           zf_build_fcat,
           zf_display.


*&---------------------------------------------------------------------*
*& Form zf_select
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM zf_select .

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
    WHERE id_veiculo IN s_idveic AND
          montadora  IN s_mont   AND
          marca      IN s_marca  AND
          situacao   IN s_situ   AND
          eliminado  IN s_elim.


  CALL FUNCTION 'GET_DOMAIN_VALUES'
    EXPORTING
      domname         = 'ZDOM_SITUACAO_VEICULO'
    TABLES
      values_tab      = lt_dom
    EXCEPTIONS
      no_values_found = 1
      OTHERS          = 2.

  SORT lt_veiculo ASCENDING BY id_veiculo.

  LOOP AT lt_veiculo INTO ls_veiculo.

    READ TABLE lt_dom INTO ls_dom WITH KEY domvalue_L = ls_veiculo-situacao.

    ls_veiculo-situacao = ls_dom-ddtext.
    MODIFY lt_veiculo FROM ls_veiculo TRANSPORTING situacao.

  ENDLOOP.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form zf_build_fcat
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM zf_build_fcat .

*--------------------------------------*
  wa_fcat-col_pos = '1' .
  wa_fcat-fieldname = 'ID_VEICULO' .
  wa_fcat-tabname = 'LT_VEICULO' .
  wa_fcat-seltext_m = 'ID_VEICULO' .
  wa_fcat-key = 'X' .
  wa_fcat-outputlen = 10.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '2' .
  wa_fcat-fieldname = 'MONTADORA' .
  wa_fcat-tabname = 'LT_VEICULO' .
  wa_fcat-seltext_m = 'MONTADORA' .
  wa_fcat-outputlen = 20.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '3' .
  wa_fcat-fieldname = 'MARCA' .
  wa_fcat-tabname = 'LT_VEICULO' .
  wa_fcat-seltext_m = 'MARCA' .
  wa_fcat-outputlen = 20.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '4' .
  wa_fcat-fieldname = 'PLACA' .
  wa_fcat-tabname = 'LT_VEICULO' .
  wa_fcat-seltext_m = 'PLACA' .
  wa_fcat-outputlen = 12.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '5' .
  wa_fcat-fieldname = 'ANO' .
  wa_fcat-tabname = 'LT_VEICULO' .
  wa_fcat-seltext_m = 'ANO' .
  wa_fcat-outputlen = 4.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '6' .
  wa_fcat-fieldname = 'COR' .
  wa_fcat-tabname = 'LT_VEICULO' .
  wa_fcat-seltext_m = 'COR' .
  wa_fcat-outputlen = 15.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '7' .
  wa_fcat-fieldname = 'DATA_COMPRA' .
  wa_fcat-tabname = 'LT_VEICULO' .
  wa_fcat-seltext_m = 'DATA_COMPRA' .
  wa_fcat-outputlen = 12.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------* Ver como adiciona o nome completo do dóminio
  wa_fcat-col_pos = '8' .
  wa_fcat-fieldname = 'SITUACAO' .
  wa_fcat-tabname = 'LT_VEICULO' .
  wa_fcat-seltext_m = 'SITUACAO' .
*  wa_fcat-ref_fieldname = 'SITUACAO'.
*  wa_fcat-ref_tabname = 'ZTBEDU_VEICULOS'.
  wa_fcat-outputlen = 10.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '9' .
  wa_fcat-fieldname = 'OBS' .
  wa_fcat-tabname = 'LT_VEICULO'.
  wa_fcat-seltext_m = 'OBS'.
  wa_fcat-outputlen = 50.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '10' .
  wa_fcat-fieldname = 'ELIMINADO' .
  wa_fcat-tabname = 'LT_VEICULO' .
  wa_fcat-seltext_m = 'ELIMINADO' .
  wa_fcat-outputlen = 9.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*

ENDFORM.


*&---------------------------------------------------------------------*
*& Form zf_display
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM zf_display .

  DATA vl_repid LIKE sy-repid.
  vl_repid = sy-repid.

  ls_layout-zebra             = 'X'.


  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = vl_repid
      is_layout          = ls_layout
      it_fieldcat        = it_fcat
      i_save             = 'A'
    TABLES
      t_outtab           = lt_veiculo
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.


ENDFORM.


***********************************************************************
* NOME DO PROGRAMA    : ZEDU_RELAT_EMPREST                            *
* TRANSAÇÃO           :                                               *
* TÍTULO DO PROGRAMA  : Relatório de Empréstimos                      *
* DESCRIÇÃO           : Report para relatório de empréstimos          *
* PROGRAMADOR         : Eduardo Freitas Moura (EFREITAS)              *
* DATA                : 22.03.2022                                    *
***********************************************************************
REPORT zedu_relat_emprest MESSAGE-ID zcm_efmoura.

TABLES: ztbedu_emprest.

"----------TIPOS---------"
TYPES:
  BEGIN OF tp_emprest,
    id_emprestimo   TYPE ztbedu_emprest-id_emprestimo,
    id_veiculo      TYPE ztbedu_emprest-id_veiculo,
    id_empregado    TYPE ztbedu_emprest-id_empregado,
    dt_ini_emprest  TYPE ztbedu_emprest-dt_ini_emprest,
    dt_fim_emprest  TYPE ztbedu_emprest-dt_fim_emprest,
    status(30)      TYPE c,
    dt_reg_empres   TYPE ztbedu_emprest-dt_reg_empres,
    hr_reg_empres   TYPE ztbedu_emprest-hr_reg_empres,
    usu_reg_empres  TYPE ztbedu_emprest-usu_reg_empres,
    dt_retirada     TYPE ztbedu_emprest-dt_retirada,
    hr_retirada     TYPE ztbedu_emprest-hr_retirada,
    dt_entrega      TYPE ztbedu_emprest-dt_entrega,
    hr_entrega      TYPE ztbedu_emprest-hr_entrega,
    obs             TYPE ztbedu_emprest-obs,
    dt_alt_emprest  TYPE ztbedu_emprest-dt_alt_emprest,
    hr_alt_emprest  TYPE ztbedu_emprest-hr_alt_emprest,
    usu_alt_emprest TYPE ztbedu_emprest-usu_alt_emprest,
  END OF tp_emprest.

"---TABELAS_INTERNAS---"
DATA: lt_emprest TYPE TABLE OF tp_emprest,
      lt_dom      TYPE dd07v OCCURS 0 WITH HEADER LINE..

"------ESTRUTURAS------"
DATA: ls_emprest TYPE tp_emprest,
      ls_dom      TYPE dd07v.

"-------FIELDCAT-------"
TYPE-POOLS: slis.
DATA: it_fcat TYPE slis_t_fieldcat_alv,
      wa_fcat LIKE LINE OF it_fcat.

"--------LAYOUT--------"
DATA: ls_layout TYPE slis_layout_alv.


"-------EVENTOS--------"
DATA: gt_events    TYPE slis_t_event,
      it_excluding TYPE slis_t_extab,
      s_excluding  TYPE slis_extab.

"----OUTRAS_GLOBAIS----"




"---------------TELA DE SELEÇÂO------------"
SELECTION-SCREEN: BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-001.

  SELECT-OPTIONS: s_idempt FOR ztbedu_emprest-id_emprestimo,
                  s_idveic FOR ztbedu_emprest-id_veiculo,
                  s_idempr FOR ztbedu_emprest-id_veiculo,
                  s_status FOR ztbedu_emprest-status.

SELECTION-SCREEN: END OF BLOCK b01.

"----------------VALIDAÇÃO DE TELA-----------------"




"----------------INICIO_DA_SELEÇÃO-----------------"

START-OF-SELECTION.


  PERFORM: zf_select,
           zf_build_fcat,
           zf_display.


*&---------------------------------------------------------------------*
*& Form zf_select
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM zf_select .

  SELECT id_emprestimo
         id_veiculo
         id_empregado
         dt_ini_emprest
         dt_fim_emprest
         status
         dt_reg_empres
         hr_reg_empres
         usu_reg_empres
         dt_retirada
         hr_retirada
         dt_entrega
         hr_entrega
         obs
         dt_alt_emprest
         hr_alt_emprest
         usu_alt_emprest
    FROM ztbedu_emprest
    INTO TABLE lt_emprest[]
    WHERE id_emprestimo IN s_idempt AND
          id_veiculo    IN s_idveic AND
          id_empregado  IN s_idempr AND
          status        IN s_status.

  CALL FUNCTION 'GET_DOMAIN_VALUES'
    EXPORTING
      domname         = 'ZDOM_STATUS_EMPREST'
    TABLES
      values_tab      = lt_dom
    EXCEPTIONS
      no_values_found = 1
      OTHERS          = 2.

  SORT lt_emprest ASCENDING BY id_emprestimo.

  LOOP AT lt_emprest INTO ls_emprest.

    READ TABLE lt_dom INTO ls_dom WITH KEY domvalue_L = ls_emprest-status.

    ls_emprest-status = ls_dom-ddtext.
    MODIFY lt_emprest FROM ls_emprest TRANSPORTING status.

  ENDLOOP.


ENDFORM.


*&---------------------------------------------------------------------*
*& Form zf_build_fcat
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM zf_build_fcat .

*--------------------------------------*
  wa_fcat-col_pos = '1' .
  wa_fcat-fieldname = 'ID_EMPRESTIMO' .
  wa_fcat-tabname = 'LT_EMPREST' .
  wa_fcat-seltext_m = 'EMPRESTIMO' .
  wa_fcat-key = 'X' .
  wa_fcat-outputlen = 10.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '2' .
  wa_fcat-fieldname = 'ID_VEICULO' .
  wa_fcat-tabname = 'LT_EMPREST' .
  wa_fcat-seltext_m = 'ID_VEICULO' .
  wa_fcat-outputlen = 10.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '3' .
  wa_fcat-fieldname = 'ID_EMPREGADO' .
  wa_fcat-tabname = 'LT_EMPREST' .
  wa_fcat-seltext_m = 'EMPREGADO' .
  wa_fcat-outputlen = 10.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '4' .
  wa_fcat-fieldname = 'DT_INI_EMPREST' .
  wa_fcat-tabname = 'LT_EMPREST' .
  wa_fcat-seltext_m = 'DATA_INICIO' .
  wa_fcat-outputlen = 12.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '5' .
  wa_fcat-fieldname = 'DT_FIM_EMPREST' .
  wa_fcat-tabname = 'LT_EMPREST' .
  wa_fcat-seltext_m = 'DATA_FIM' .
  wa_fcat-outputlen = 12.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '6' .
  wa_fcat-fieldname = 'STATUS' .
  wa_fcat-tabname = 'LT_EMPREST' .
  wa_fcat-seltext_m = 'STATUS' .
  wa_fcat-outputlen = 25.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '7' .
  wa_fcat-fieldname = 'DT_REG_EMPRES' .
  wa_fcat-tabname = 'LT_EMPREST' .
  wa_fcat-seltext_m = 'DATA_REG' .
  wa_fcat-outputlen = 12.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '8' .
  wa_fcat-fieldname = 'HR_REG_EMPRES' .
  wa_fcat-tabname = 'LT_EMPREST' .
  wa_fcat-seltext_m = 'HORA_REG' .
  wa_fcat-outputlen = 10.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '9' .
  wa_fcat-fieldname = 'USU_REG_EMPRES' .
  wa_fcat-tabname = 'LT_EMPREST'.
  wa_fcat-seltext_m = 'USER_REG'.
  wa_fcat-outputlen = 15.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '10' .
  wa_fcat-fieldname = 'DT_RETIRADA'.
  wa_fcat-tabname = 'LT_EMPREST'.
  wa_fcat-seltext_m = 'DATA_RET'.
  wa_fcat-outputlen = 12.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '11' .
  wa_fcat-fieldname = 'HR_RETIRADA' .
  wa_fcat-tabname = 'LT_EMPREST' .
  wa_fcat-seltext_m = 'HORA_RET' .
  wa_fcat-outputlen = 10.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '12' .
  wa_fcat-fieldname = 'DT_ENTREGA' .
  wa_fcat-tabname = 'LT_EMPREST' .
  wa_fcat-seltext_m = 'DATA_ENTR' .
  wa_fcat-outputlen = 12.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '13' .
  wa_fcat-fieldname = 'HR_ENTREGA' .
  wa_fcat-tabname = 'LT_EMPREST' .
  wa_fcat-seltext_m = 'HORA_ENTR' .
  wa_fcat-outputlen = 10.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '14' .
  wa_fcat-fieldname = 'OBS' .
  wa_fcat-tabname = 'LT_EMPREST' .
  wa_fcat-seltext_m = 'OBS' .
  wa_fcat-outputlen = 50.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '15' .
  wa_fcat-fieldname = 'dt_alt_emprest' .
  wa_fcat-tabname = 'LT_EMPREST' .
  wa_fcat-seltext_m = 'DATA_ALT' .
  wa_fcat-outputlen = 12.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '16' .
  wa_fcat-fieldname = 'hr_alt_emprest' .
  wa_fcat-tabname = 'LT_EMPREST' .
  wa_fcat-seltext_m = 'HORA_ALT' .
  wa_fcat-outputlen = 10.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '17' .
  wa_fcat-fieldname = 'usu_alt_emprest' .
  wa_fcat-tabname = 'LT_EMPREST' .
  wa_fcat-seltext_m = 'USER_ALT' .
  wa_fcat-outputlen = 15.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*


ENDFORM.


*&---------------------------------------------------------------------*
*& Form zf_display
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM zf_display .

  DATA vl_repid LIKE sy-repid.
  vl_repid = sy-repid.

  ls_layout-zebra             = 'X'.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = vl_repid
      is_layout          = ls_layout
      it_fieldcat        = it_fcat
      i_save             = 'A'
    TABLES
      t_outtab           = lt_emprest
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.


ENDFORM.


***********************************************************************
* NOME DO PROGRAMA    :  ZEDU_RELAT_EMPREGADO                         *
* TRANSAÇÃO           :                                               *
* TÍTULO DO PROGRAMA  : Relatório Empregado                           *
* DESCRIÇÃO           : Report para relatório de empregado            *
* PROGRAMADOR         : Eduardo Freitas Moura (EFREITAS)              *
* DATA                : 07.03.2022                                    *
***********************************************************************
REPORT zedu_relat_empregado MESSAGE-ID zcm_efmoura.
"RESOLVER NOME DO CARGO E DO SETOR AO INVES DO ID"

TABLES: ztbedu_empregado, ztbedu_cargo , ztbedu_setor.

"----------TIPOS---------"
TYPES:
  BEGIN OF tp_empregado,
    id_empregado    TYPE ztbedu_empregado-id_empregado,
    nome_empregado  TYPE ztbedu_empregado-nome_empregado,
    data_nasc       TYPE ztbedu_empregado-data_nasc,
    genero          TYPE ztbedu_empregado-genero,
    id_cargo        TYPE ztbedu_empregado-id_cargo,
    id_setor        TYPE ztbedu_empregado-id_setor,
    data_adm        TYPE ztbedu_empregado-data_adm,
    salbruto        TYPE ztbedu_empregado-salbruto,
    moeda_empregado TYPE ztbedu_empregado-moeda_empregado,
  END OF tp_empregado,

  BEGIN OF tp_cargo,
*    id_empregado TYPE ztbedu_empregado-id_empregado,
    id_cargo   TYPE ztbedu_cargo-id_cargo,
    nome_cargo TYPE ztbedu_cargo-nome_cargo,
  END OF tp_cargo,

  BEGIN OF tp_setor,
*    id_empregado TYPE ztbedu_empregado-id_empregado,
    id_setor   TYPE ztbedu_setor-id_setor,
    nome_setor TYPE ztbedu_setor-nome_setor,
  END OF tp_setor,

  BEGIN OF tp_saida,
    id_empregado    TYPE ztbedu_empregado-id_empregado,
    nome_empregado  TYPE ztbedu_empregado-nome_empregado,
    data_nasc       TYPE ztbedu_empregado-data_nasc,
    genero          TYPE ztbedu_empregado-genero,
*    id_cargo        TYPE ztbedu_empregado-id_cargo,
    nome_cargo      TYPE ztbedu_cargo-nome_cargo,
*    id_setor        TYPE ztbedu_empregado-id_setor,
    nome_setor      TYPE ztbedu_setor-nome_setor,
    data_adm        TYPE ztbedu_empregado-data_adm,
*    salbruto        TYPE ztbedu_empregado-salbruto,
    salbruto(13)    TYPE c,
    moeda_empregado TYPE ztbedu_empregado-moeda_empregado,
  END OF tp_saida.

"---TABELAS_INTERNAS---"
DATA: lt_saida     TYPE TABLE OF tp_saida,
      lt_empregado TYPE TABLE OF tp_empregado,
      lt_cargo     TYPE TABLE OF tp_cargo,
      lt_setor     TYPE TABLE OF tp_setor.

"------ESTRUTURAS------"
DATA: ls_saida     TYPE tp_saida,
      ls_empregado TYPE tp_empregado,
      ls_cargo     TYPE tp_cargo,
      ls_setor     TYPE tp_setor.

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


"---------------TELA DE SELEÇÂO------------"
SELECTION-SCREEN: BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-001.

  SELECT-OPTIONS: s_idemp FOR ztbedu_empregado-id_empregado MATCHCODE OBJECT ZAPEDU_EMPREGADO,
                  s_nomee FOR ztbedu_empregado-nome_empregado,
                  s_cargo FOR ztbedu_empregado-id_cargo MATCHCODE OBJECT ZAPEDU_CARGO,
                  s_setor FOR ztbedu_empregado-id_setor MATCHCODE OBJECT ZAPEDU_SETOR.

SELECTION-SCREEN: END OF BLOCK b01.


"----------------VALIDAÇÃO DE TELA----------------"

AT SELECTION-SCREEN.
  IF s_idemp AND s_nomee AND s_cargo AND s_setor IS INITIAL.
    MESSAGE e002. "Mensagem de erro impede continuação da seleção"
  ENDIF.


  "-------------INICIO_DA_SELEÇÃO---------------"

START-OF-SELECTION.

  PERFORM zf_select.
  PERFORM zf_preenche_saida.
  PERFORM zf_build_fcat.
  PERFORM zf_build_layout.
  PERFORM zf_build_events.
  PERFORM zf_display_alv.


*&---------------------------------------------------------------------*
*& Form zf_select
*&---------------------------------------------------------------------*
FORM zf_select .

  SELECT  id_empregado
          nome_empregado
          data_nasc
          genero
          id_cargo
          id_setor
          data_adm
          salbruto
          moeda_empregado
    FROM ztbedu_empregado
    INTO TABLE lt_empregado[]
    WHERE id_empregado   IN s_idemp AND
          nome_empregado IN s_nomee AND
          id_cargo       IN s_cargo AND
          id_setor       IN s_setor.

  IF lt_empregado IS INITIAL.
    MESSAGE e000 WITH 'Falha ao ler ZTBEDU_EMPREGADO'.
  ELSE.

    SELECT id_cargo nome_cargo
      FROM ztbedu_cargo
      INTO TABLE lt_cargo[]
      FOR ALL ENTRIES IN lt_empregado[]
      WHERE id_cargo = lt_empregado-id_cargo.
    IF sy-subrc <> 0.
      MESSAGE e000 WITH 'Falha ao ler ZTBEDU_CARGO'.
    ENDIF.

    SELECT id_setor nome_setor
      FROM ztbedu_setor
      INTO TABLE lt_setor[]
      FOR ALL ENTRIES IN lt_empregado[] "lt_saida[]
      WHERE id_setor = lt_empregado-id_setor.
    IF sy-subrc <> 0.
      MESSAGE e000 WITH 'Falha ao ler ZTBEDU_SETOR'.
    ENDIF.

  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form zf_build_fcat
*&---------------------------------------------------------------------*
FORM zf_preenche_saida.

  DATA: dia(2)      TYPE c,
        mes(2)      TYPE c,
        ano(4)      TYPE c,
        data1(8)    TYPE c,
        data2(8)    TYPE c,
        salario(13) TYPE c.

  IF lt_empregado IS INITIAL.
    MESSAGE s000 WITH 'Tabela ZTBEDU_EMPREGADO está vazia'.
  ELSE.
    LOOP AT lt_empregado INTO ls_empregado.
      READ TABLE lt_cargo INTO ls_cargo WITH KEY id_cargo = ls_empregado-id_cargo.
      READ TABLE lt_setor INTO ls_setor WITH KEY id_setor = ls_empregado-id_setor.

      ls_saida-id_empregado     = ls_empregado-id_empregado.
      ls_saida-nome_empregado   = ls_empregado-nome_empregado.

      ano = ls_empregado-data_nasc(4).
      mes = ls_empregado-data_nasc+4(2).
      dia = ls_empregado-data_nasc+6(2).
      CONCATENATE ano dia mes  INTO data1.
      ls_saida-data_nasc        = data1.
*      ls_saida-data_nasc        = ls_empregado-data_nasc.

      ls_saida-genero           = ls_empregado-genero.
      ls_saida-nome_cargo       = ls_cargo-nome_cargo.
      ls_saida-nome_setor       = ls_setor-nome_setor.

      ano = ls_empregado-data_adm(4).
      mes = ls_empregado-data_adm+4(2).
      dia = ls_empregado-data_adm+6(2).
      CONCATENATE ano dia mes  INTO data2.
      ls_saida-data_adm         = data2.
*      ls_saida-data_adm        = ls_empregado-data_adm.

      salario                   = ls_empregado-salbruto.
      REPLACE ALL OCCURRENCES OF '.' IN salario WITH ','.
      CONDENSE salario.
      ls_saida-salbruto         = salario.

      ls_saida-moeda_empregado  = ls_empregado-moeda_empregado.




      APPEND ls_saida TO lt_saida.
      CLEAR : ls_saida.
    ENDLOOP.
    SORT lt_saida ASCENDING BY id_empregado.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form zf_build_fcat
*&---------------------------------------------------------------------*
FORM zf_build_fcat .

*--------------------------------------*
  wa_fcat-col_pos = '1' .
  wa_fcat-fieldname = 'ID_EMPREGADO'.
  wa_fcat-tabname = 'LT_SAIDA'.
  wa_fcat-seltext_m = 'ID.'.
  wa_fcat-key = 'X' .
  wa_fcat-outputlen = 5.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '2' .
  wa_fcat-fieldname = 'NOME_EMPREGADO'.
  wa_fcat-tabname = 'LT_SAIDA'.
  wa_fcat-seltext_m = 'NOME DO EMPREGADO'.
  wa_fcat-outputlen = 40.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '3' .
  wa_fcat-fieldname = 'DATA_NASC'.
  wa_fcat-tabname = 'LT_SAIDA'.
  wa_fcat-seltext_m = 'DATA NASC'.
  wa_fcat-outputlen = 10.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '4' .
  wa_fcat-fieldname = 'GENERO'.
  wa_fcat-tabname = 'LT_SAIDA'.
  wa_fcat-seltext_m = 'GENERO'.
  wa_fcat-outputlen = 11.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '5' .
  wa_fcat-fieldname = 'NOME_CARGO'.
  wa_fcat-tabname = 'LT_SAIDA'.
  wa_fcat-seltext_m = 'CARGO'.
  wa_fcat-outputlen = 20.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '6' .
  wa_fcat-fieldname = 'NOME_SETOR'.
  wa_fcat-tabname = 'LT_SAIDA'.
  wa_fcat-seltext_m = 'SETOR'.
  wa_fcat-outputlen = 20.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '7' .
  wa_fcat-fieldname = 'DATA_ADM'.
  wa_fcat-tabname = 'LT_SAIDA'.
  wa_fcat-seltext_m = 'DATA ADM'.
  wa_fcat-outputlen = 10.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '8' .
  wa_fcat-fieldname = 'SALBRUTO'.
  wa_fcat-tabname = 'LT_SAIDA'.
  wa_fcat-seltext_m = 'SALARIO'.
  wa_fcat-outputlen = 12.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '9' .
  wa_fcat-fieldname = 'MOEDA_EMPREGADO'.
  wa_fcat-tabname = 'LT_EMPREGADO'.
  wa_fcat-seltext_m = 'MOEDA'.
  wa_fcat-outputlen = 8.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*

ENDFORM.


*&---------------------------------------------------------------------*
*& Form zf_build_layout
*&---------------------------------------------------------------------*
FORM zf_build_layout .
  ls_layout-zebra             = 'X'.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form zf_build_events
*&---------------------------------------------------------------------*
FORM zf_build_events .

ENDFORM.

*&---------------------------------------------------------------------*
*& Form zf_display_alv
*&---------------------------------------------------------------------*
FORM zf_display_alv .
  DATA vl_repid LIKE sy-repid.
  vl_repid = sy-repid.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = vl_repid
      is_layout          = ls_layout
      it_fieldcat        = it_fcat
      i_save             = 'A'
    TABLES
      t_outtab           = lt_saida
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.


***********************************************************************
* NOME DO PROGRAMA    : ZEDU_RELAT_LOG_EMPREST                        *
* TRANSAÇÃO           :                                               *
* TÍTULO DO PROGRAMA  : Relatório de Log para Empréstimos             *
* DESCRIÇÃO           : Report para relatório de logs                 *
* PROGRAMADOR         : Eduardo Freitas Moura (EFREITAS)              *
* DATA                : 22.03.2022                                    *
***********************************************************************
REPORT zedu_relat_log_emprest.

TABLES: ztbedu_logemp.

"----------TIPOS---------"
TYPES:
  BEGIN OF tp_log,
    id_alteracao      TYPE ztbedu_logemp-id_alteracao,
    id_empregado      TYPE ztbedu_logemp-id_empregado,
    data_alteracao    TYPE ztbedu_logemp-data_alteracao,
    hora_alteracao    TYPE ztbedu_logemp-hora_alteracao,
    usuario_alteracao TYPE ztbedu_logemp-usuario_alteracao,
    info_alteracao    TYPE ztbedu_logemp-info_alteracao,
    valor_antigo      TYPE ztbedu_logemp-valor_antigo,
    valor_novo        TYPE ztbedu_logemp-valor_novo,
  END OF tp_log.

"---TABELAS_INTERNAS---"
DATA: lt_log TYPE TABLE OF tp_log.

"------ESTRUTURAS------"
DATA: ls_log TYPE tp_log.

"-------FIELDCAT-------"
TYPE-POOLS: slis.
DATA: it_fcat TYPE slis_t_fieldcat_alv,
      wa_fcat LIKE LINE OF it_fcat.

"--------LAYOUT--------"
DATA: ls_layout TYPE slis_layout_alv.


"-------EVENTOS--------"
DATA: gt_events    TYPE slis_t_event,
      it_excluding TYPE slis_t_extab,
      s_excluding  TYPE slis_extab.

"----OUTRAS_GLOBAIS----"




"---------------TELA DE SELEÇÂO------------"
SELECTION-SCREEN: BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-001.

  SELECT-OPTIONS: s_data   FOR ztbedu_logemp-data_alteracao,
                  s_hora   FOR ztbedu_logemp-hora_alteracao.

SELECTION-SCREEN: END OF BLOCK b01.

"----------------VALIDAÇÃO DE TELA-----------------"




"----------------INICIO_DA_SELEÇÃO-----------------"

START-OF-SELECTION.


  PERFORM: zf_select,
           zf_build_fcat,
           zf_display.


*&---------------------------------------------------------------------*
*& Form zf_select
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM zf_select .

  SELECT
    id_alteracao
    id_empregado
    data_alteracao
    hora_alteracao
    usuario_alteracao
    info_alteracao
    valor_antigo
    valor_novo
    FROM ztbedu_logemp
    INTO TABLE lt_log[]
    WHERE data_alteracao IN s_data     AND
          hora_alteracao IN s_hora     AND
          info_alteracao = 'SITUACAO'  OR
          info_alteracao = 'STATUS'.



ENDFORM.


*&---------------------------------------------------------------------*
*& Form zf_build_fcat
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM zf_build_fcat .

*--------------------------------------*
  wa_fcat-col_pos = '1' .
  wa_fcat-fieldname = 'ID_ALTERACAO' .
  wa_fcat-tabname = 'LT_LOG' .
  wa_fcat-seltext_m = 'ID_ALT' .
  wa_fcat-key = 'X' .
  wa_fcat-outputlen = 10.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '2' .
  wa_fcat-fieldname = 'ID_EMPREGADO' .
  wa_fcat-tabname = 'LT_LOG' .
  wa_fcat-seltext_m = 'ID EMPR' .
  wa_fcat-outputlen = 10.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '3' .
  wa_fcat-fieldname = 'DATA_ALTERACAO' .
  wa_fcat-tabname = 'LT_LOG' .
  wa_fcat-seltext_m = 'DATA ALT' .
  wa_fcat-outputlen = 12.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '4' .
  wa_fcat-fieldname = 'HORA_ALTERACAO' .
  wa_fcat-tabname = 'LT_LOG' .
  wa_fcat-seltext_m = 'HORA ALT' .
  wa_fcat-outputlen = 10.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '5' .
  wa_fcat-fieldname = 'USUARIO_ALTERACAO' .
  wa_fcat-tabname = 'LT_LOG' .
  wa_fcat-seltext_m = 'USER ALT' .
  wa_fcat-outputlen = 15.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '6' .
  wa_fcat-fieldname = 'INFO_ALTERACAO' .
  wa_fcat-tabname = 'LT_LOG' .
  wa_fcat-seltext_m = 'INFO ALT' .
  wa_fcat-outputlen = 20.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '7' .
  wa_fcat-fieldname = 'VALOR_ANTIGO' .
  wa_fcat-tabname = 'LT_LOG' .
  wa_fcat-seltext_m = 'VALOR ANTIGO' .
  wa_fcat-outputlen = 30.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '8' .
  wa_fcat-fieldname = 'VALOR_NOVO' .
  wa_fcat-tabname = 'LT_LOG' .
  wa_fcat-seltext_m = 'VALOR NOVO' .
  wa_fcat-outputlen = 30.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*

ENDFORM.


*&---------------------------------------------------------------------*
*& Form zf_display
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM zf_display .

  DATA vl_repid LIKE sy-repid.
  vl_repid = sy-repid.

  ls_layout-zebra             = 'X'.

  SORT lt_log ASCENDING BY id_alteracao.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = vl_repid
      is_layout          = ls_layout
      it_fieldcat        = it_fcat
      i_save             = 'A'
    TABLES
      t_outtab           = lt_log
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.


ENDFORM.



*----------------------------------------------------------------------*
***INCLUDE ZMPEDU_EMPREST_PBO_06.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0106 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0106 OUTPUT.
  SET PF-STATUS 'ZSTATUS_EMPREST'.
* SET TITLEBAR 'xxx'.
ENDMODULE.


*&---------------------------------------------------------------------*
*& Module SELECIONA_DADOS6 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE seleciona_dados6 OUTPUT.

  "---TABELAS_INTERNAS---"
  DATA: lt_emprst  TYPE TABLE OF     ztbedu_emprest,
        lt_veiculo TYPE TABLE OF ztbedu_veiculos,
        lt_empreg  TYPE TABLE OF   ztbedu_empregado.

  "------ESTRUTURAS------"
  DATA: ls_emprst  TYPE ztbedu_emprest,
        ls_veiculo TYPE ztbedu_veiculos,
        ls_empreg  TYPE ztbedu_empregado.

  SELECT  *
     FROM ztbedu_emprest
     INTO TABLE lt_emprst.

  SELECT *
    FROM ztbedu_veiculos
    INTO TABLE lt_veiculo.

  SELECT *
    FROM ztbedu_empregado
    INTO TABLE lt_empreg.
ENDMODULE.


*----------------------------------------------------------------------*
***INCLUDE ZMPEDU_EMPREST_PAI_06.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0106  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0106 INPUT.
  CASE sy-ucomm.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN 'CANC'.
      LEAVE PROGRAM.
    WHEN 'ENDE'.
      LEAVE PROGRAM.
    WHEN 'BT1'.
      PERFORM zf_call_smartform.
    WHEN OTHERS.
  ENDCASE.
ENDMODULE.


*&---------------------------------------------------------------------*
*& Form zf_call_smartform
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM zf_call_smartform .

  DATA: fname     TYPE rs38l_fnam,
        id_recibo TYPE zed_idemprest.

  CALL FUNCTION 'NUMBER_GET_NEXT'
    EXPORTING
      nr_range_nr = '01'
      object      = 'ZNR_IDREC'
    IMPORTING
      number      = id_recibo
 EXCEPTIONS
     INTERVAL_NOT_FOUND            = 1
     NUMBER_RANGE_NOT_INTERN       = 2
     OBJECT_NOT_FOUND              = 3
     QUANTITY_IS_0                 = 4
     QUANTITY_IS_NOT_1             = 5
     INTERVAL_OVERFLOW             = 6
     BUFFER_OVERFLOW               = 7
     OTHERS      = 8.


  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      formname           = 'ZEDU_SMARTFORM'
    IMPORTING
      fm_name            = fname
    EXCEPTIONS
      no_form            = 1
      no_function_module = 2
      OTHERS             = 3.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.


  READ TABLE lt_emprst  INTO ls_emprst  WITH KEY id_emprestimo  = ztbedu_emprest-id_emprestimo.
  READ TABLE lt_empreg  INTO ls_empreg  WITH KEY id_empregado   = ls_emprst-id_empregado.
  READ TABLE lt_veiculo INTO ls_veiculo WITH KEY id_veiculo     = ls_emprst-id_veiculo.


  CALL FUNCTION fname
    EXPORTING
*     ARCHIVE_INDEX    =
*     ARCHIVE_INDEX_TAB =
*     ARCHIVE_PARAMETERS =
*     CONTROL_PARAMETERS =
*     MAIL_APPL_OBJ    =
*     MAIL_RECIPIENT   =
*     MAIL_SENDER      =
*     OUTPUT_OPTIONS   =
*     USER_SETTINGS    = 'X'
      wa_empreg        = ls_empreg
      wa_emprest       = ls_emprst
      wa_veic          = ls_veiculo
      wa_recibo        = id_recibo
    EXCEPTIONS
      formatting_error = 1
      internal_error   = 2
      send_error       = 3
      user_canceled    = 4
      OTHERS           = 5.

  IF sy-subrc <> 0.

  ENDIF.
ENDFORM.