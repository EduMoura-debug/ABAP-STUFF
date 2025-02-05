************************************************************************
* NOME DO PROGRAMA    :                                                *
* TRANSAÇÃO           :                                                *
* TÍTULO DO PROGRAMA  :                                                *
* DESCRIÇÃO           :                                                *
* PROGRAMADOR         :                                                *
* DATA                :                                                *
************************************************************************
REPORT z_report_exp. "Alterar pelo nome do programa

*-------------------TABELAS------------------*

*--------------------TIPOS-------------------*

*----------------FIELD SYMBOLS---------------*

*------------------CONSTANTES----------------*

*---------------TABELAS INTERNAS-------------*

*-----------------ESTRUTURAS-----------------*

*------------------VARIAVEIS-----------------*

*-------------------OBJETOS------------------*


*---------------------ALV--------------------*
TYPE-POOLS: slis.
DATA : it_fcat TYPE slis_t_fieldcat_alv,
       wa_fcat LIKE LINE OF it_fcat.

DATA: ls_layout TYPE slis_layout_alv.

*--------------------MACRO-------------------*
DEFINE m_fieldcat.
    wa_fcat-col_pos   = &1.
    wa_fcat-fieldname = &2.
    wa_fcat-tabname   = &3.
    wa_fcat-seltext_l = &4.
    wa_fcat-key       = &5.
    wa_fcat-edit      = &6.
    wa_fcat-outputlen = &7.
    append wa_fcat to it_fcat.
    clear wa_fcat.
END-OF-DEFINITION.

*----------------TELA DE SELEÇÃO-------------*
SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-001.

*SELECT-OPTIONS: s_nump  FOR ekko-ebeln,
*                s_forn  FOR ekko-lifnr.

SELECTION-SCREEN END OF BLOCK b01.

START-OF-SELECTION.


  PERFORM zf_select_dados.
  PERFORM zf_preenche_saida.
  PERFORM zf_display_alv.



*&---------------------------------------------------------------------*
*& zf_select_dados. Selecionar Dados
*&---------------------------------------------------------------------*
FORM zf_select_dados.


ENDFORM.

*&---------------------------------------------------------------------*
*& zf_preenche_saida. Preenche saída
*&---------------------------------------------------------------------*
FORM zf_preenche_saida.


ENDFORM.



*&---------------------------------------------------------------------*
*& Form zf_display_alv. Display ALV GRID
*&---------------------------------------------------------------------*
FORM zf_display_alv .
  
  DATA vl_repid LIKE sy-repid.
    
  vl_repid = sy-repid.

  ls_layout-colwidth_optimize = 'X'.
  ls_layout-zebra             = 'X'.

  m_fieldcat '' '' '' '' '' ''  10.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program      = vl_repid
      is_layout               = ls_layout
      it_fieldcat             = it_fcat
      i_save                  = 'A'
    TABLES
      t_outtab                = lt_saida
    EXCEPTIONS
      PROGRAM_ERROR                     = 1
      OTHERS                            = 2.
ENDFORM.
