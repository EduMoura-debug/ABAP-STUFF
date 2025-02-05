***********************************************************************
* NOME DO PROGRAMA    :  ZEDU_MENU_EMPREGADO                          *
* TRANSAÇÃO           :                                               *
* TÍTULO DO PROGRAMA  : Menu Empregado                                *
* DESCRIÇÃO           : Report para  um menu com relatório, cáluculos *
*                       de valores, Log de alterações e carga         *
*                       programas de manutenção                       *
* PROGRAMADOR         : Eduardo Freitas Moura (EFREITAS)              *
* DATA                : 07.03.2022                                    *
***********************************************************************
REPORT zedu_menu_empregado MESSAGE-ID zcm_efmoura.

"------------------TELA DE SELEÇÂO---------------"
SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-001.

  PARAMETERS: p_relat RADIOBUTTON GROUP gr1. "Relatório Empregado
  PARAMETERS: p_calcv RADIOBUTTON GROUP gr1. "Cálculo de Valores
  PARAMETERS: p_log RADIOBUTTON GROUP gr1. "Log de alterações
  PARAMETERS: p_carga RADIOBUTTON GROUP gr1. "Carga

SELECTION-SCREEN END OF BLOCK b01.



START-OF-SELECTION.

  CASE 'X'.
    WHEN p_relat.
      SUBMIT zedu_relat_empregado VIA SELECTION-SCREEN AND RETURN.
    WHEN p_calcv.
      SUBMIT zedu_calculo_empregados VIA SELECTION-SCREEN AND RETURN.
    WHEN p_log.
      SUBMIT zedu_relat_alter_empregado VIA SELECTION-SCREEN AND RETURN.
    WHEN p_carga.
      SUBMIT zedu_carga_empregado VIA SELECTION-SCREEN AND RETURN.
  ENDCASE.

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
* NOME DO PROGRAMA    :ZEDU_CALCULO_EMPREGADOS                        *
* TRANSAÇÃO           :                                               *
* TÍTULO DO PROGRAMA  : Cálculos Empregado                            *
* DESCRIÇÃO           :`Programa para calcular reajuste anual e folha *
*                       de pagamento dos empregados                   *
*                       programas de manutenção                       *
* PROGRAMADOR         : Eduardo Freitas Moura (EFREITAS)              *
* DATA                : 08.03.2022                                    *
***********************************************************************
REPORT zedu_calculo_empregados MESSAGE-ID zcm_efmoura.

TABLES: ztbedu_empregado.
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
    id_cargo   TYPE ztbedu_cargo-id_cargo,
    nome_cargo TYPE ztbedu_cargo-nome_cargo,
  END OF tp_cargo,

  BEGIN OF tp_setor,
    id_setor   TYPE ztbedu_setor-id_setor,
    nome_setor TYPE ztbedu_setor-nome_setor,
  END OF tp_setor,

  BEGIN OF tp_saida1,
    id_empregado   TYPE ztbedu_empregado-id_empregado,
    nome_empregado TYPE ztbedu_empregado-nome_empregado,
    data_nasc      TYPE ztbedu_empregado-data_nasc,
    genero         TYPE ztbedu_empregado-genero,
    nome_cargo     TYPE ztbedu_cargo-nome_cargo,
    nome_setor     TYPE ztbedu_setor-nome_setor,
    data_adm       TYPE ztbedu_empregado-data_adm,
    valor_antigo   TYPE ztbedu_empregado-salbruto,
    percent        TYPE ztbedu_empregado-salbruto,
    valor_aumento  TYPE ztbedu_empregado-salbruto,
    valor_novo     TYPE ztbedu_empregado-salbruto,
    checkbox       TYPE c,
  END OF tp_saida1,

  BEGIN OF tp_saida2,
    id_empregado(5)    TYPE c,
    nome_empregado(40) TYPE c,
    nome_cargo(40)     TYPE c,
    nome_setor(40)     TYPE c,
    data_adm(12)       TYPE c,
    salario            TYPE ztbedu_empregado-salbruto,
    percent            TYPE ztbedu_empregado-salbruto,
    desconto           TYPE ztbedu_empregado-salbruto,
    inss               TYPE ztbedu_empregado-salbruto,
    fgts               TYPE ztbedu_empregado-salbruto,
    total_desc         TYPE ztbedu_empregado-salbruto,
    sal_liquid         TYPE ztbedu_empregado-salbruto,
  END OF tp_saida2.


"---TABELAS_INTERNAS---"
DATA: lt_saida1    TYPE TABLE OF tp_saida1,
      lt_saida2    TYPE TABLE OF tp_saida2,
      lt_empregado TYPE TABLE OF tp_empregado,
      lt_cargo     TYPE TABLE OF tp_cargo,
      lt_setor     TYPE TABLE OF tp_setor.

"------ESTRUTURAS------"
DATA: ls_saida1    TYPE tp_saida1,
      ls_saida2    TYPE tp_saida2,
      ls_empregado TYPE tp_empregado,
      ls_cargo     TYPE tp_cargo,
      ls_setor     TYPE tp_setor.


"-------FIELDCAT-------"
TYPE-POOLS: slis.
DATA: it_fcat1 TYPE slis_t_fieldcat_alv,
      wa_fcat1 LIKE LINE OF it_fcat1,
      it_fcat2 TYPE slis_t_fieldcat_alv,
      wa_fcat2 LIKE LINE OF it_fcat2.

"--------LAYOUT--------"
DATA:  ls_layout TYPE slis_layout_alv.

"------ORDENAÇÃO-------"

"-------EVENTOS--------"
DATA: gt_events    TYPE slis_t_event.

"----OUTRAS_GLOBAIS----"
DATA: file TYPE string.

"---------------TELA DE SELEÇÂO------------"
SELECTION-SCREEN: BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-001.

  SELECT-OPTIONS: s_idemp FOR ztbedu_empregado-id_empregado MATCHCODE OBJECT zapedu_empregado,
                  s_nomee FOR ztbedu_empregado-nome_empregado,
                  s_cargo FOR ztbedu_empregado-id_cargo MATCHCODE OBJECT zapedu_cargo,
                  s_setor FOR ztbedu_empregado-id_setor MATCHCODE OBJECT zapedu_setor.

SELECTION-SCREEN: END OF BLOCK b01.

SELECTION-SCREEN SKIP 1.

SELECTION-SCREEN BEGIN OF BLOCK b02 WITH FRAME TITLE TEXT-002.

  PARAMETERS: p_ajusta RADIOBUTTON GROUP gr1, " Ajustar pagamento
              p_paychk RADIOBUTTON GROUP gr1. " Folha de Pagamento

SELECTION-SCREEN END OF BLOCK b02.

"----------------VALIDAÇÃO DE TELA----------------"

AT SELECTION-SCREEN.
  IF s_idemp AND s_nomee AND s_cargo AND s_setor IS INITIAL.
    MESSAGE e002. "Prrencha ao menos todos os campos
  ENDIF.


  "----------------INICIO_DA_SELEÇÃO----------------"

START-OF-SELECTION.

  PERFORM zf_select.
  PERFORM zf_build_events.
  ls_layout-zebra             = 'X'.

  IF p_ajusta = 'X'.
    PERFORM zf_ajusta_salario.
  ELSEIF p_paychk = 'X'.
    PERFORM zf_folha_pagamento.
  ENDIF.


*&---------------------------------------------------------------------*
*& Form zf_ajusta_salario
*&---------------------------------------------------------------------*
FORM zf_ajusta_salario .
  PERFORM zf_preenche_saida1.
  PERFORM zf_ajusta_fcat1.
  PERFORM zf_ajusta_display.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form zf_folha_pagamento
*&---------------------------------------------------------------------*
FORM zf_folha_pagamento.
  PERFORM zf_preenche_saida2.
  PERFORM zf_ajusta_fcat2.
  PERFORM zf_paycheck_display.
ENDFORM.




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
    MESSAGE e000 WITH 'Nenhum empregado encontrado'.
  ELSE.

    SELECT id_cargo nome_cargo
      FROM ztbedu_cargo
      INTO TABLE lt_cargo[]
      FOR ALL ENTRIES IN lt_empregado[]
    WHERE id_cargo = lt_empregado-id_cargo.
    IF sy-subrc <> 0.
      MESSAGE e000 WITH 'Nenhum cargo encontrado'.
    ENDIF.

    SELECT id_setor nome_setor
      FROM ztbedu_setor
      INTO TABLE lt_setor[]
      FOR ALL ENTRIES IN lt_empregado[] "lt_saida[]
    WHERE id_setor = lt_empregado-id_setor.
    IF sy-subrc <> 0.
      MESSAGE e000 WITH 'Nenhum setor encontrado'.
    ENDIF.

  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form zf_preenche_saida1
*&---------------------------------------------------------------------*
FORM zf_preenche_saida1 .
  IF lt_empregado IS INITIAL.
    MESSAGE s000 WITH 'Tabela Interna está vazia'.
  ELSE.
    LOOP AT lt_empregado INTO ls_empregado.
      READ TABLE lt_cargo INTO ls_cargo WITH KEY id_cargo = ls_empregado-id_cargo.
      READ TABLE lt_setor INTO ls_setor WITH KEY id_setor = ls_empregado-id_setor.

      ls_saida1-id_empregado     = ls_empregado-id_empregado.
      ls_saida1-nome_empregado   = ls_empregado-nome_empregado.
      ls_saida1-data_nasc        = ls_empregado-data_nasc.
      ls_saida1-genero           = ls_empregado-genero.
      ls_saida1-nome_cargo       = ls_cargo-nome_cargo.
      ls_saida1-nome_setor       = ls_setor-nome_setor.
      ls_saida1-data_adm         = ls_empregado-data_adm.
      ls_saida1-valor_antigo     = ls_empregado-salbruto.
*    ls_saida-moeda_empregado  = ls_empregado-moeda_empregado.

      CALL FUNCTION 'ZFM_REAJUSTE_SALARIAL'
        EXPORTING
          i_salario       = ls_empregado-salbruto
        IMPORTING
          e_perc_aumento  = ls_saida1-percent
          e_valor_aumento = ls_saida1-valor_aumento
          e_novo_salario  = ls_saida1-valor_novo
        EXCEPTIONS
          valor_negativo  = 1
          OTHERS          = 2.
      IF sy-subrc <> 0.
        MESSAGE e000 WITH 'Não foi feito o reajuste salarial'.
        CONTINUE.
      ENDIF.

      APPEND ls_saida1 TO lt_saida1.
      CLEAR : ls_saida1.
    ENDLOOP.
    SORT lt_saida1 ASCENDING BY id_empregado.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form zf_ajusta_fcat1
*&---------------------------------------------------------------------*
FORM zf_ajusta_fcat1 .
*--------------------------------------*
  wa_fcat1-col_pos = '0' .
  wa_fcat1-fieldname = 'CHECKBOX'.
  wa_fcat1-tabname = 'LT_SAIDA1'.
  wa_fcat1-seltext_m = 'CHECK'.
  wa_fcat1-checkbox = 'X'.
  wa_fcat1-edit = 'X'.
  wa_fcat1-outputlen = 5.
  APPEND wa_fcat1 TO it_fcat1 .
  CLEAR wa_fcat1 .
*--------------------------------------*
  wa_fcat1-col_pos = '1' .
  wa_fcat1-fieldname = 'ID_EMPREGADO'.
  wa_fcat1-tabname = 'LT_SAIDA1'.
  wa_fcat1-seltext_m = 'ID.'.
  wa_fcat1-key = 'X' .
  wa_fcat1-outputlen = 5.
  APPEND wa_fcat1 TO it_fcat1 .
  CLEAR wa_fcat1 .
*--------------------------------------*
  wa_fcat1-col_pos = '2' .
  wa_fcat1-fieldname = 'NOME_EMPREGADO'.
  wa_fcat1-tabname = 'LT_SAIDA1'.
  wa_fcat1-seltext_m = 'NOME DO EMPREGADO'.
  wa_fcat1-outputlen = 40.
  APPEND wa_fcat1 TO it_fcat1 .
  CLEAR wa_fcat1 .
*--------------------------------------*
  wa_fcat1-col_pos = '3' .
  wa_fcat1-fieldname = 'DATA_NASC'.
  wa_fcat1-tabname = 'LT_SAIDA1'.
  wa_fcat1-seltext_m = 'DATA NASC'.
  wa_fcat1-outputlen = 10.
  APPEND wa_fcat1 TO it_fcat1 .
  CLEAR wa_fcat1 .
*--------------------------------------*
  wa_fcat1-col_pos = '4' .
  wa_fcat1-fieldname = 'GENERO'.
  wa_fcat1-tabname = 'LT_SAIDA1'.
  wa_fcat1-seltext_m = 'GENERO'.
  wa_fcat1-outputlen = 11.
  APPEND wa_fcat1 TO it_fcat1 .
  CLEAR wa_fcat1 .
*--------------------------------------*
  wa_fcat1-col_pos = '5' .
  wa_fcat1-fieldname = 'NOME_CARGO'.
  wa_fcat1-tabname = 'LT_SAIDA1'.
  wa_fcat1-seltext_m = 'CARGO'.
  wa_fcat1-outputlen = 20.
  APPEND wa_fcat1 TO it_fcat1 .
  CLEAR wa_fcat1 .
*--------------------------------------*
  wa_fcat1-col_pos = '6' .
  wa_fcat1-fieldname = 'NOME_SETOR'.
  wa_fcat1-tabname = 'LT_SAIDA1'.
  wa_fcat1-seltext_m = 'SETOR'.
  wa_fcat1-outputlen = 20.
  APPEND wa_fcat1 TO it_fcat1 .
  CLEAR wa_fcat1 .
*--------------------------------------*
  wa_fcat1-col_pos = '7' .
  wa_fcat1-fieldname = 'DATA_ADM'.
  wa_fcat1-tabname = 'LT_SAIDA1'.
  wa_fcat1-seltext_m = 'DATA ADM'.
  wa_fcat1-outputlen = 10.
  APPEND wa_fcat1 TO it_fcat1 .
  CLEAR wa_fcat1 .
*--------------------------------------*
  wa_fcat1-col_pos = '8' .
  wa_fcat1-fieldname = 'VALOR_ANTIGO'.
  wa_fcat1-tabname = 'LT_SAIDA1'.
  wa_fcat1-seltext_m = 'ANTIGO SALARIO'.
  wa_fcat1-outputlen = 15.
  APPEND wa_fcat1 TO it_fcat1 .
  CLEAR wa_fcat1 .
*--------------------------------------*
  wa_fcat1-col_pos = '9' .
  wa_fcat1-fieldname = 'PERCENT'.
  wa_fcat1-tabname = 'LT_SAIDA1'.
  wa_fcat1-seltext_m = 'PERC %'.
  wa_fcat1-outputlen = 12.
  APPEND wa_fcat1 TO it_fcat1 .
  CLEAR wa_fcat1 .
*--------------------------------------*
  wa_fcat1-col_pos = '10' .
  wa_fcat1-fieldname = 'VALOR_AUMENTO'.
  wa_fcat1-tabname = 'LT_SAIDA1'.
  wa_fcat1-seltext_m = 'AUMENTO'.
  wa_fcat1-outputlen = 12.
  APPEND wa_fcat1 TO it_fcat1 .
  CLEAR wa_fcat1 .
*--------------------------------------*
  wa_fcat1-col_pos = '11' .
  wa_fcat1-fieldname = 'VALOR_NOVO'.
  wa_fcat1-tabname = 'LT_SAIDA1'.
  wa_fcat1-seltext_m = 'NOVO SALARIO'.
  wa_fcat1-outputlen = 15.
  APPEND wa_fcat1 TO it_fcat1 .
  CLEAR wa_fcat1 .
*--------------------------------------*

ENDFORM.

*&---------------------------------------------------------------------*
*& Form zf_ajusta_display
*&---------------------------------------------------------------------*
FORM zf_ajusta_display .
  DATA vl_repid LIKE sy-repid.
  vl_repid = sy-repid.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program      = vl_repid
      i_callback_user_command = 'ZF_USER_COMMAND'
      is_layout               = ls_layout
      it_fieldcat             = it_fcat1
      i_save                  = 'A'
    TABLES
      t_outtab                = lt_saida1
    EXCEPTIONS
      program_error           = 1
      OTHERS                  = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.


ENDFORM.

*&---------------------------------------------------------------------*
*& Form zf_preenche_saida2
*&---------------------------------------------------------------------*
FORM zf_preenche_saida2 .
  IF lt_empregado IS INITIAL.
    MESSAGE s000 WITH 'Tabela Interna está vazia'.
  ELSE.
    LOOP AT lt_empregado INTO ls_empregado.
      READ TABLE lt_cargo INTO ls_cargo WITH KEY id_cargo = ls_empregado-id_cargo.
      READ TABLE lt_setor INTO ls_setor WITH KEY id_setor = ls_empregado-id_setor.

      ls_saida2-id_empregado     = ls_empregado-id_empregado.
      ls_saida2-nome_empregado   = ls_empregado-nome_empregado.
      ls_saida2-nome_cargo       = ls_cargo-nome_cargo.
      ls_saida2-nome_setor       = ls_setor-nome_setor.
      ls_saida2-data_adm         = ls_empregado-data_adm.
      ls_saida2-salario          = ls_empregado-salbruto.
*    ls_saida-moeda_empregado  = ls_empregado-moeda_empregado.


      CALL FUNCTION 'ZFM_FOLHA_PAGAMENTO'
        EXPORTING
          i_salario      = ls_saida2-salario
        IMPORTING
          e_percent_ir   = ls_saida2-percent
          e_desc_ir      = ls_saida2-desconto
          e_inss         = ls_saida2-inss
          e_fgts         = ls_saida2-fgts
          e_desc_total   = ls_saida2-total_desc
          e_sal_liquido  = ls_saida2-sal_liquid
        EXCEPTIONS
          valor_negativo = 1
          OTHERS         = 2.
      IF sy-subrc <> 0.

      ENDIF.

      APPEND ls_saida2 TO lt_saida2.
      CLEAR : ls_saida2.
    ENDLOOP.
    SORT lt_saida2 ASCENDING BY id_empregado.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form zf_ajusta_fcat
*&---------------------------------------------------------------------*
FORM zf_ajusta_fcat2 .
*--------------------------------------*
  wa_fcat2-col_pos = '1' .
  wa_fcat2-fieldname = 'ID_EMPREGADO'.
  wa_fcat2-tabname = 'LT_SAIDA2'.
  wa_fcat2-seltext_m = 'ID.'.
  wa_fcat2-key = 'X' .
  wa_fcat2-outputlen = 5.
  APPEND wa_fcat2 TO it_fcat2 .
  CLEAR wa_fcat2 .
*--------------------------------------*
  wa_fcat2-col_pos = '2'.
  wa_fcat2-fieldname = 'NOME_EMPREGADO'.
  wa_fcat2-tabname = 'LT_SAIDA2'.
  wa_fcat2-seltext_m = 'NOME DO EMPREGADO'.
  wa_fcat2-outputlen = 40.
  APPEND wa_fcat2 TO it_fcat2 .
  CLEAR wa_fcat2 .
*--------------------------------------*
  wa_fcat2-col_pos = '3' .
  wa_fcat2-fieldname = 'NOME_CARGO'.
  wa_fcat2-tabname = 'LT_SAIDA2'.
  wa_fcat2-seltext_m = 'CARGO'.
  wa_fcat2-outputlen = 20.
  APPEND wa_fcat2 TO it_fcat2 .
  CLEAR wa_fcat2 .
*--------------------------------------*
  wa_fcat2-col_pos = '4' .
  wa_fcat2-fieldname = 'NOME_SETOR'.
  wa_fcat2-tabname = 'LT_SAIDA2'.
  wa_fcat2-seltext_m = 'SETOR'.
  wa_fcat2-outputlen = 20.
  APPEND wa_fcat2 TO it_fcat2 .
  CLEAR wa_fcat2 .
*--------------------------------------*
  wa_fcat2-col_pos = '5' .
  wa_fcat2-fieldname = 'DATA_ADM'.
  wa_fcat2-tabname = 'LT_SAIDA2'.
  wa_fcat2-seltext_m = 'DATA ADM'.
  wa_fcat2-outputlen = 10.
  APPEND wa_fcat2 TO it_fcat2 .
  CLEAR wa_fcat2 .
*--------------------------------------*
  wa_fcat2-col_pos = '6' .
  wa_fcat2-fieldname = 'SALARIO'.
  wa_fcat2-tabname = 'LT_SAIDA2'.
  wa_fcat2-seltext_m = 'SALARIO'.
  wa_fcat2-outputlen = 13.
  APPEND wa_fcat2 TO it_fcat2 .
  CLEAR wa_fcat2 .
*--------------------------------------*
  wa_fcat2-col_pos = '7' .
  wa_fcat2-fieldname = 'PERCENT'.
  wa_fcat2-tabname = 'LT_SAIDA2'.
  wa_fcat2-seltext_m = 'PERC %'.
  wa_fcat2-outputlen = 6.
  APPEND wa_fcat2 TO it_fcat2 .
  CLEAR wa_fcat2 .
*--------------------------------------*
  wa_fcat2-col_pos = '8' .
  wa_fcat2-fieldname = 'DESCONTO'.
  wa_fcat2-tabname = 'LT_SAIDA2'.
  wa_fcat2-seltext_m = 'DESCONTO'.
  wa_fcat2-outputlen = 10.
  APPEND wa_fcat2 TO it_fcat2 .
  CLEAR wa_fcat2 .
*--------------------------------------*
  wa_fcat2-col_pos = '9' .
  wa_fcat2-fieldname = 'INSS'.
  wa_fcat2-tabname = 'LT_SAIDA2'.
  wa_fcat2-seltext_m = 'INSS(10%)'.
  wa_fcat2-outputlen = 10.
  APPEND wa_fcat2 TO it_fcat2 .
  CLEAR wa_fcat2 .
*--------------------------------------*
  wa_fcat2-col_pos = '10' .
  wa_fcat2-fieldname = 'FGTS'.
  wa_fcat2-tabname = 'LT_SAIDA2'.
  wa_fcat2-seltext_m = 'FGTS(11%)'.
  wa_fcat2-outputlen = 10.
  APPEND wa_fcat2 TO it_fcat2 .
  CLEAR wa_fcat2 .
*--------------------------------------*
  wa_fcat2-col_pos = '11' .
  wa_fcat2-fieldname = 'TOTAL_DESC'.
  wa_fcat2-tabname = 'LT_SAIDA2'.
  wa_fcat2-seltext_m = 'TOTAL DESCONTOS'.
  wa_fcat2-outputlen = 15.
  APPEND wa_fcat2 TO it_fcat2 .
  CLEAR wa_fcat2 .
*--------------------------------------*
  wa_fcat2-col_pos = '12' .
  wa_fcat2-fieldname = 'SAL_LIQUID'.
  wa_fcat2-tabname = 'LT_SAIDA2'.
  wa_fcat2-seltext_m = 'VALOR LÍQUIDO'.
  wa_fcat2-outputlen = 15.
  APPEND wa_fcat2 TO it_fcat2 .
  CLEAR wa_fcat2 .
*--------------------------------------*


ENDFORM.


*&---------------------------------------------------------------------*
*& Form zf_ajusta_display
*&---------------------------------------------------------------------*
FORM zf_paycheck_display .
  DATA vl_repid LIKE sy-repid.
  vl_repid = sy-repid.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program       = vl_repid
      i_callback_pf_status_set = 'ZPF_STATUS'
      i_callback_user_command  = 'ZF_USER_COMMAND2'
      is_layout                = ls_layout
      it_fieldcat              = it_fcat2
      i_save                   = 'A'
      it_events                = gt_events[]
    TABLES
      t_outtab                 = lt_saida2
    EXCEPTIONS
      program_error            = 1
      OTHERS                   = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form zf_user_command
*&---------------------------------------------------------------------*
FORM zf_user_command USING vl_ucomm LIKE sy-ucomm
                           rs_campo TYPE slis_selfield.

  CASE vl_ucomm.
    WHEN '&DATA_SAVE' OR 'SAVE'. "clique do usuário

      PERFORM zf_update_table.

    WHEN OTHERS.
  ENDCASE.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form zf_user_command2
*&---------------------------------------------------------------------*
FORM zf_user_command2 USING vl_ucomm LIKE sy-ucomm
                           rs_campo TYPE slis_selfield.

  CASE vl_ucomm.
    WHEN 'CSV'. "clique do usuário

      PERFORM zf_download_table.

    WHEN OTHERS.
  ENDCASE.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form zf_update_table
*&---------------------------------------------------------------------*
FORM zf_update_table.
  DATA: lv_valantigo(40) TYPE c,
        lv_valnovo(40)   TYPE c.

  LOOP AT lt_saida1 INTO ls_saida1.

    IF ls_saida1-checkbox = 'X'.

      lv_valantigo = ls_saida1-valor_antigo.
      lv_valnovo = ls_saida1-valor_novo.

      UPDATE ztbedu_empregado
        SET salbruto = ls_saida1-valor_novo
        WHERE id_empregado = ls_saida1-id_empregado.

      IF sy-subrc = 0.
        CALL FUNCTION 'ZFM_PREENCHE_LOG'
          EXPORTING
            i_idempregado  = ls_saida1-id_empregado
            i_info_campo   = 'SALBRUTO'
            i_valor_antigo = lv_valantigo
            i_valor_novo   = lv_valnovo
          EXCEPTIONS
            id_not_found   = 1
            valor_negativo = 2
            OTHERS         = 3.
        IF sy-subrc <> 0.
          MESSAGE: i000 WITH 'Log de Alteração não Inserido'.
        ELSE.
          COMMIT WORK AND WAIT.
          MESSAGE: i000 WITH 'Log de Alteração Inserido'.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDLOOP.
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
ENDFORM.

*&---------------------------------------------------------------------*
*& Form zf_download_table
*&---------------------------------------------------------------------*
FORM zf_download_table .

  DATA lt_saida_csv TYPE truxs_t_text_data.

  PERFORM zf_caminho_local.

  CALL FUNCTION 'SAP_CONVERT_TO_CSV_FORMAT'
    EXPORTING
      i_field_seperator    = ';'
*     I_LINE_HEADER        =
*     I_FILENAME           =
*     I_APPL_KEEP          = ' '
    TABLES
      i_tab_sap_data       = lt_saida2
    CHANGING
      i_tab_converted_data = lt_saida_csv
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
        data_tab = lt_saida_csv
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
*& Form zpf_status
*&---------------------------------------------------------------------*
FORM zpf_status USING icon_extab.
  SET PF-STATUS 'ZPAYCHK_EMPREGADO' EXCLUDING icon_extab.
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

  CONCATENATE vl_caminho '\FolhaPagamento_' sy-datum tp_file INTO file.

ENDFORM.



***********************************************************************
* NOME DO PROGRAMA    : ZEDU_RELAT_ALTER_EMPREGADO                    *
* TRANSAÇÃO           :                                               *
* TÍTULO DO PROGRAMA  : Relatório de ALteração (Log) de Empregado     *
* DESCRIÇÃO           : Report para relatório log de alteração        *
* PROGRAMADOR         : Eduardo Freitas Moura (EFREITAS)              *
* DATA                : 08.03.2022                                    *
***********************************************************************
REPORT zedu_relat_alter_empregado MESSAGE-ID zcm_efmoura.

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

  SELECT-OPTIONS: s_idemp  FOR ztbedu_logemp-id_empregado,
                  s_altdat FOR ztbedu_logemp-data_alteracao,
                  s_alttim FOR ztbedu_logemp-hora_alteracao.

SELECTION-SCREEN: END OF BLOCK b01.


"----------------VALIDAÇÃO DE TELA----------------"

AT SELECTION-SCREEN.
  IF s_alttim AND s_altdat AND s_idemp IS INITIAL.
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

  SELECT  id_alteracao
          id_empregado
          data_alteracao
          hora_alteracao
          usuario_alteracao
          info_alteracao
          valor_antigo
          valor_novo
    FROM ztbedu_logemp
    INTO TABLE lt_log[]
  WHERE id_empregado   IN s_idemp  AND
        data_alteracao IN s_altdat AND
        hora_alteracao IN s_alttim.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form zf_build_fcat
*&---------------------------------------------------------------------*
FORM zf_build_fcat .

*--------------------------------------*
  wa_fcat-col_pos = '1' .
  wa_fcat-fieldname = 'ID_ALTERACAO'.
  wa_fcat-tabname = 'LT_LOG'.
  wa_fcat-seltext_m = 'ID. ALT'.
  wa_fcat-key = 'X' .
  wa_fcat-outputlen = 8.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '2' .
  wa_fcat-fieldname = 'ID_EMPREGADO'.
  wa_fcat-tabname = 'LT_LOG'.
  wa_fcat-seltext_m = 'ID. EMP'.
  wa_fcat-key = 'X' .
  wa_fcat-outputlen = 8.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '3' .
  wa_fcat-fieldname = 'DATA_ALTERACAO'.
  wa_fcat-tabname = 'LT_LOG'.
  wa_fcat-seltext_m = 'DATA ALT'.
  wa_fcat-outputlen = 12.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '4' .
  wa_fcat-fieldname = 'HORA_ALTERACAO'.
  wa_fcat-tabname = 'LT_LOG'.
  wa_fcat-seltext_m = 'HORA ALT'.
  wa_fcat-outputlen = 12.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '5' .
  wa_fcat-fieldname = 'USUARIO_ALTERACAO'.
  wa_fcat-tabname = 'LT_LOG'.
  wa_fcat-seltext_m = 'USER ALT'.
  wa_fcat-outputlen = 15.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '6' .
  wa_fcat-fieldname = 'INFO_ALTERACAO'.
  wa_fcat-tabname = 'LT_LOG'.
  wa_fcat-seltext_m = 'INFO ALTERACAO'.
  wa_fcat-outputlen = 40.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '7'.
  wa_fcat-fieldname = 'VALOR_ANTIGO'.
  wa_fcat-tabname = 'LT_LOG'.
  wa_fcat-seltext_m = 'VALOR ANTIGO'.
  wa_fcat-outputlen = 40.
  APPEND wa_fcat TO it_fcat .
  CLEAR wa_fcat .
*--------------------------------------*
  wa_fcat-col_pos = '8' .
  wa_fcat-fieldname = 'VALOR_NOVO'.
  wa_fcat-tabname = 'LT_LOG'.
  wa_fcat-seltext_m = 'VALOR NOVO'.
  wa_fcat-outputlen = 40.
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
*     I_INTERFACE_CHECK  = ' '
*     I_BYPASSING_BUFFER = ' '
*     I_BUFFER_ACTIVE    = ' '
      i_callback_program = vl_repid
*     I_CALLBACK_PF_STATUS_SET          = ' '
*     I_CALLBACK_USER_COMMAND           = ' '
*     I_CALLBACK_TOP_OF_PAGE            = ' '
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME   =
*     I_BACKGROUND_ID    = ' '
*     I_GRID_TITLE       =
*     I_GRID_SETTINGS    =
      is_layout          = ls_layout
      it_fieldcat        = it_fcat
*     IT_EXCLUDING       =
*     IT_SPECIAL_GROUPS  =
*     IT_SORT            =
*     IT_FILTER          =
*     IS_SEL_HIDE        =
*     I_DEFAULT          = 'X'
      i_save             = 'A'
*     IS_VARIANT         =
*     IT_EVENTS          =
*     IT_EVENT_EXIT      =
*     IS_PRINT           =
*     IS_REPREP_ID       =
*     I_SCREEN_START_COLUMN             = 0
*     I_SCREEN_START_LINE               = 0
*     I_SCREEN_END_COLUMN               = 0
*     I_SCREEN_END_LINE  = 0
*     I_HTML_HEIGHT_TOP  = 0
*     I_HTML_HEIGHT_END  = 0
*     IT_ALV_GRAPHICS    =
*     IT_HYPERLINK       =
*     IT_ADD_FIELDCAT    =
*     IT_EXCEPT_QINFO    =
*     IR_SALV_FULLSCREEN_ADAPTER        =
*     O_PREVIOUS_SRAL_HANDLER           =
*   IMPORTING
*     E_EXIT_CAUSED_BY_CALLER           =
*     ES_EXIT_CAUSED_BY_USER            =
    TABLES
      t_outtab           = lt_log
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.

  ENDIF.

ENDFORM.


***********************************************************************
* NOME DO PROGRAMA    : ZEDU_CARGA_EMPREGADO                          *
* TRANSAÇÃO           :                                               *
* TÍTULO DO PROGRAMA  : Carga de Empregados                           *
* DESCRIÇÃO           : Report para carga de empregados               *
* PROGRAMADOR         : Eduardo Freitas Moura (EFREITAS)              *
* DATA                : 07.03.2022                                    *
***********************************************************************
REPORT zedu_carga_empregado MESSAGE-ID zcm_efmoura.


TABLES: ztbedu_empregado.

"----------TIPOS---------"
TYPES:
  BEGIN OF tp_linha,
    linha(500) TYPE c,
  END OF tp_linha,

  BEGIN OF tp_download,
*    id_empregado(5)    TYPE c,
    nome_empregado(40) TYPE c,
    data_nasc(8)       TYPE c,
    genero(11)         TYPE c,
    id_cargo(5)        TYPE c,
    id_setor(5)        TYPE c,
*    data_adm(8)        TYPE c,
    salbruto(13)       TYPE c,
    moeda_empregado(5) TYPE c,
  END OF tp_download.

"---TABELAS_INTERNAS---"
DATA: lt_linha    TYPE STANDARD TABLE OF tp_linha WITH HEADER LINE,
      lt_download TYPE TABLE OF tp_download,
      lt_xlsxload TYPE TABLE OF alsmex_tabline.

"------ESTRUTURAS------"
DATA: ls_linha    TYPE tp_linha,
      ls_download TYPE tp_download,
      ls_xlsxload TYPE alsmex_tabline.

"--------GLOBAIS-------"
DATA: data1(10) TYPE c,
      data2(10) TYPE c,
      currline  TYPE i,
      lv_max(4) TYPE c,
      l_nome    TYPE rvari_vnam VALUE 'ZCARGA_EMPREGADO',
      l_low     TYPE tvarv_val,
      l_path    LIKE dxfields-longpath.


"-----------------TELA DE SELEÇÂO-----------------"
SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-001.

  PARAMETERS: p_carga LIKE rlgrap-filename MODIF ID id1.
  PARAMETERS: p_file  LIKE dxfields-longpath MODIF ID id2.


SELECTION-SCREEN END OF BLOCK b01.
SELECTION-SCREEN SKIP 1.
SELECTION-SCREEN BEGIN OF BLOCK b02 WITH FRAME TITLE TEXT-002.

  PARAMETERS: p_csv  RADIOBUTTON GROUP grp2 MODIF ID id3,
              p_xlsx RADIOBUTTON GROUP grp2 MODIF ID id3.

SELECTION-SCREEN END OF BLOCK b02.
SELECTION-SCREEN SKIP 1.
SELECTION-SCREEN BEGIN OF BLOCK b03 WITH FRAME TITLE TEXT-003.

  PARAMETERS: p_local RADIOBUTTON GROUP grp1 USER-COMMAND click DEFAULT 'X',
              p_rede  RADIOBUTTON GROUP grp1.
SELECTION-SCREEN END OF BLOCK b03.

"----------------VALIDAÇÃO DE TELA----------------"
*AT SELECTION-SCREEN.
*  IF p_carga IS INITIAL.
*    MESSAGE e002. "Mensagem de erro impede continuação da seleção"
*  ENDIF.


AT SELECTION-SCREEN OUTPUT.
  CASE 'X'.
    WHEN p_local.
      LOOP AT SCREEN.
        IF screen-group1 = 'ID2'.
          screen-active = '0'.
          MODIFY SCREEN FROM screen.
        ENDIF.
      ENDLOOP.
    WHEN p_rede.
      LOOP AT SCREEN.
        IF screen-group1 = 'ID1'.
          screen-active = '0'.
          MODIFY SCREEN FROM screen.
        ENDIF.
      ENDLOOP.
  ENDCASE.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_carga.

  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      program_name  = syst-cprog
      dynpro_number = syst-dynnr
      field_name    = ' '
    IMPORTING
      file_name     = p_carga.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.

*    DATA: p_file TYPE dxfields-longpath.
*    p_file = carga.

  SELECT SINGLE low
    FROM tvarvc
    INTO l_low
    WHERE name = l_nome.

    IF sy-subrc = 0.

      l_path = l_low.

      CALL FUNCTION 'F4_DXFILENAME_TOPRECURSION'
        EXPORTING
          i_location_flag = 'A'
          i_server        = ' '
          i_path          = l_path
*         FILEMASK        = '*.*'
*         FILEOPERATION   = 'R'
        IMPORTING
*         O_LOCATION_FLAG =
*         O_SERVER        =
          o_path          = p_file
*         ABEND_FLAG      =
        EXCEPTIONS
          rfc_error       = 1
          error_with_gui  = 2
          OTHERS          = 3.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.
    ELSE.
      MESSAGE 'Caminho não encontrado' TYPE 'I'.
    ENDIF.

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
*FORM zf_caminho USING carga.
*
*  IF p_local = 'X'.
*    CALL FUNCTION 'F4_FILENAME'
*      EXPORTING
*        program_name  = syst-cprog
*        dynpro_number = syst-dynnr
*        field_name    = ' '
*      IMPORTING
*        file_name     = carga.
*
*  ELSEIF p_rede = 'X'.
**    DATA: p_file TYPE dxfields-longpath.
**    p_file = carga.
*    l_path = '/usr/sap/tmp/'.
*
*    CALL FUNCTION 'F4_DXFILENAME_TOPRECURSION'
*      EXPORTING
*        i_location_flag = 'A'
*        i_server        = ' '
*        i_path          = l_path
**       FILEMASK        = '*.*'
**       FILEOPERATION   = 'R'
*      IMPORTING
**       O_LOCATION_FLAG =
**       O_SERVER        =
*        o_path          = carga
**       ABEND_FLAG      =
*      EXCEPTIONS
*        rfc_error       = 1
*        error_with_gui  = 2
*        OTHERS          = 3.
*    IF sy-subrc <> 0.
** Implement suitable error handling here
*
*    ENDIF.
*  ENDIF.
*
*ENDFORM.

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
*          ls_download-id_empregado
          ls_download-nome_empregado
          data1
          ls_download-genero
          ls_download-id_cargo
          ls_download-id_setor
*          data2
          ls_download-salbruto
          ls_download-moeda_empregado.


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
*    WHEN 1.
*       ls_download-id_empregado = ls_xlsxload-value.
      WHEN 1.
        ls_download-nome_empregado = ls_xlsxload-value.
      WHEN 2.
        data1 = ls_xlsxload-value.
      WHEN 3.
        ls_download-genero = ls_xlsxload-value.
      WHEN 4.
        ls_download-id_cargo = ls_xlsxload-value.
      WHEN 5.
        ls_download-id_setor = ls_xlsxload-value.
*     WHEN 6.
*       data2 = ls_xlsxload-value.
      WHEN 6.
        ls_download-salbruto = ls_xlsxload-value.
      WHEN 7.
        ls_download-moeda_empregado = ls_xlsxload-value.
      WHEN OTHERS.
    ENDCASE.
    PERFORM zf_date_transformation.
  ENDLOOP.
  APPEND ls_download TO lt_download.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form zf_leitura_rede
*&---------------------------------------------------------------------*
FORM zf_leitura_rede .

  IF p_csv = 'X'.

    OPEN DATASET p_carga FOR INPUT IN TEXT MODE ENCODING DEFAULT.

    IF sy-subrc = 0.
      DO.
        READ DATASET p_carga INTO lt_linha.
        IF sy-subrc <> 0.
          EXIT.
        ENDIF.
        SPLIT ls_linha AT ';' INTO
*          ls_download-id_empregado
              ls_download-nome_empregado
              data1
              ls_download-genero
              ls_download-id_cargo
              ls_download-id_setor
*          data2
              ls_download-salbruto
              ls_download-moeda_empregado.

        PERFORM zf_date_transformation.
        APPEND ls_download TO lt_download.
      ENDDO.
      CLOSE DATASET p_carga.
    ELSE.
      MESSAGE e001.
    ENDIF.
  ELSEIF p_xlsx = 'X'.
    MESSAGE e003.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form zf_date_transformation
*&---------------------------------------------------------------------*
FORM zf_date_transformation.

  CALL FUNCTION 'CONVERSION_EXIT_PDATE_INPUT'
    EXPORTING
      input        = data1
    IMPORTING
      output       = ls_download-data_nasc
    EXCEPTIONS
      invalid_date = 1
      OTHERS       = 2.
  IF sy-subrc <> 0.
    MESSAGE: i000 WITH 'DATA DE NASCIMENTO NÃO CONVERTIDA'.
  ENDIF.


*  CALL FUNCTION 'CONVERSION_EXIT_PDATE_INPUT'
*    EXPORTING
*      input        = data1
*    IMPORTING
*      output       = ls_download-data_adm
*    EXCEPTIONS
*      invalid_date = 1
*      OTHERS       = 2.
*  IF sy-subrc <> 0.
*    MESSAGE: i000 WITH 'DATA DE ADMISSÃO NÃO CONVERTIDA'.
*  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form zf_valida_dados
*&---------------------------------------------------------------------*
FORM zf_valida_dados.
  "Buscar maior valor de id_fruta
  SELECT MAX( id_fruta )
    FROM zfruta_aluno07
    INTO lv_max.
    LOOP AT lt_download INTO ls_download.

      lv_max += 1.


      PERFORM zf_insere_carga.

    ENDLOOP.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form zf_insere_carga
*&---------------------------------------------------------------------*
FORM zf_insere_carga .

  ztbedu_empregado-id_empregado    = lv_max.
  ztbedu_empregado-nome_empregado  = ls_download-nome_empregado.
  ztbedu_empregado-data_nasc       = ls_download-data_nasc.
  ztbedu_empregado-genero          = ls_download-genero.
  ztbedu_empregado-id_cargo        = ls_download-id_cargo.
  ztbedu_empregado-id_setor        = ls_download-id_setor.
  ztbedu_empregado-data_adm        = sy-datum. "ls_download-data_adm.
  ztbedu_empregado-salbruto        = ls_download-salbruto.
  ztbedu_empregado-moeda_empregado = ls_download-moeda_empregado.

  INSERT ztbedu_empregado.
  IF sy-subrc = 0.
    COMMIT WORK AND WAIT.
    WRITE: / ls_download-nome_empregado, 40 'Foi Adicionado.'.
  ELSE.
    WRITE: / ls_download-nome_empregado, 40 'Não Adicionado.'.
  ENDIF.

ENDFORM.



FUNCTION zfm_reajuste_salarial.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     REFERENCE(I_SALARIO) TYPE  ZED_SALBRUTO_EMPREGADO
*"  EXPORTING
*"     REFERENCE(E_PERC_AUMENTO) TYPE  ZED_SALBRUTO_EMPREGADO
*"     REFERENCE(E_VALOR_AUMENTO) TYPE  ZED_SALBRUTO_EMPREGADO
*"     REFERENCE(E_NOVO_SALARIO) TYPE  ZED_SALBRUTO_EMPREGADO
*"  EXCEPTIONS
*"      VALOR_NEGATIVO
*"----------------------------------------------------------------------

  TABLES: ztbedu_percreaj.

  TYPES: BEGIN OF tp_percreaj,
           val_de     TYPE ztbedu_percreaj-val_de,
           val_ate    TYPE ztbedu_percreaj-val_ate,
           percentual TYPE ztbedu_percreaj-percentual,
         END OF tp_percreaj.
  DATA: lt_percreaj TYPE TABLE OF tp_percreaj,
        ls_percreaj TYPE tp_percreaj.

  SELECT val_de val_ate percentual
    FROM ztbedu_percreaj
    INTO TABLE lt_percreaj.

  IF i_salario < 0.
    RAISE valor_negativo.
  ELSE.

    LOOP AT lt_percreaj INTO ls_percreaj.

      IF i_salario BETWEEN ls_percreaj-val_de AND ls_percreaj-val_ate.
        e_perc_aumento = ls_percreaj-percentual .
        e_valor_aumento = i_salario * ( e_perc_aumento / 100 ).
        e_novo_salario = i_salario + e_valor_aumento.
      ENDIF.

    ENDLOOP.
  ENDIF.

ENDFUNCTION.


FUNCTION zfm_folha_pagamento.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     REFERENCE(I_SALARIO) TYPE  ZED_SALBRUTO_EMPREGADO
*"  EXPORTING
*"     REFERENCE(E_PERCENT_IR) TYPE  ZED_SALBRUTO_EMPREGADO
*"     REFERENCE(E_DESC_IR) TYPE  ZED_SALBRUTO_EMPREGADO
*"     REFERENCE(E_INSS) TYPE  ZED_SALBRUTO_EMPREGADO
*"     REFERENCE(E_FGTS) TYPE  ZED_SALBRUTO_EMPREGADO
*"     REFERENCE(E_DESC_TOTAL) TYPE  ZED_SALBRUTO_EMPREGADO
*"     REFERENCE(E_SAL_LIQUIDO) TYPE  ZED_SALBRUTO_EMPREGADO
*"  EXCEPTIONS
*"      VALOR_NEGATIVO
*"----------------------------------------------------------------------
  DATA: vl_salario TYPE zed_salbruto_empregado.


  vl_salario = i_salario.

  IF vl_salario < 0.
    RAISE valor_negativo.
  ELSE.

    IF vl_salario <= 250.
      e_percent_ir =  0.

    ELSEIF vl_salario <= 950.
      e_percent_ir =  5.

    ELSEIF vl_salario <= 2500.
      e_percent_ir =  10.

    ELSEIF vl_salario > 2500.
      e_percent_ir = 20.

    ENDIF.

      e_desc_ir = vl_salario * ( e_percent_ir / 100 ).
      e_inss = vl_salario * ( 10 / 100 ). " 10% INSS
      e_fgts = vl_salario * ( 11 / 100 ). " 11% FGTS
      e_desc_total = e_desc_ir + e_inss.
      e_sal_liquido = vl_salario - E_desc_total.

  ENDIF.

ENDFUNCTION.


FUNCTION zfm_preenche_log.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     REFERENCE(I_IDEMPREGADO) TYPE  ZED_ID_EMPREGADO
*"     VALUE(I_INFO_CAMPO) TYPE  ZED_INFO_ALTERACAO
*"     REFERENCE(I_VALOR_ANTIGO) TYPE  ZED_VALOR_ANTIGO
*"     REFERENCE(I_VALOR_NOVO) TYPE  ZED_VALOR_NOVO
*"  EXCEPTIONS
*"      ID_NOT_FOUND
*"      VALOR_NEGATIVO
*"----------------------------------------------------------------------

  TABLES: ztbedu_empregado, ztbedu_logemp.

  DATA: lv_max TYPE zed_id_alteracao.

*  SELECT MAX( id_alteracao )
*    FROM ztbedu_logemp
*    INTO lv_max.

  CALL FUNCTION 'NUMBER_GET_NEXT'
    EXPORTING
      nr_range_nr = '01'
      object      = 'ZNR_IDLOG'
*     QUANTITY    = '1'
*     SUBOBJECT   = ' '
*     TOYEAR      = '0000'
*     IGNORE_BUFFER                 = ' '
    IMPORTING
      number      = lv_max
*     QUANTITY    =
*     RETURNCODE  =
 EXCEPTIONS
     INTERVAL_NOT_FOUND            = 1
     NUMBER_RANGE_NOT_INTERN       = 2
     OBJECT_NOT_FOUND              = 3
     QUANTITY_IS_0                 = 4
     QUANTITY_IS_NOT_1             = 5
     INTERVAL_OVERFLOW             = 6
     BUFFER_OVERFLOW               = 7
     OTHERS      = 8
    .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.


*  IF i_valor_antigo < 0 OR i_valor_novo < 0.
*    RAISE valor_negativo.
*  ELSE.
*    lv_max += 1.
    ztbedu_logemp-id_alteracao = lv_max.
    ztbedu_logemp-id_empregado = i_idempregado.
    ztbedu_logemp-data_alteracao = sy-datum.
    ztbedu_logemp-hora_alteracao = sy-timlo.
    ztbedu_logemp-usuario_alteracao = sy-uname.
    ztbedu_logemp-info_alteracao = i_info_campo.
    ztbedu_logemp-valor_antigo = i_valor_antigo.
    ztbedu_logemp-valor_novo = i_valor_novo.

    INSERT ztbedu_logemp.

*  ENDIF.


ENDFUNCTION.



