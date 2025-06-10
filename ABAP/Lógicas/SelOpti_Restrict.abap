REPORT zrestringindo_select_options.
*--------------------------------------------------------------------*
*  Fala galera, hoje vou mostrar a usar uma função que faz restrição nos
* select-options, muito das vezes os funcionais pedem para que não deixemos
* o usuário colocar qualquer coisa, ou nós mesmos percebemos que certas
* informações podem dar dump em um select ou processos.
* Ai estais a salvação.

* Estruturas e tabelas internas.
DATA :
  lt_saplane TYPE TABLE OF saplane,
  ls_saplane LIKE LINE OF  lt_saplane
  .

* Parametros de seleção
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME.
SELECT-OPTIONS :
  so_plane FOR ls_saplane-planetype NO INTERVALS
  .
SELECTION-SCREEN END OF BLOCK   b1.

* PBO
AT SELECTION-SCREEN OUTPUT.
  PERFORM restricao_campos.

*&---------------------------------------------------------------------*
*&      Form  RESTRICAO_CAMPOS
*&---------------------------------------------------------------------*
FORM restricao_campos .
*  Se você perceber os campos a serem alimentados são bem percepciveis,
* para habilitar as opções é só 'Flagar' na estrutura que já tem os campos
* pré definidos,.... para facilitar coloquei todos as opções e algumas que
* eu não sei o que faz rsrs.
*  Para um bom teste, interessante era descomentar alguns.

* Observação importante é que ele é usado no 'AT SELECTION-SCREEN OUTPUT'.
  DATA:
    ls_restrict    TYPE sscr_restrict,
    ls_opt_list    TYPE sscr_opt_list,
    ls_association TYPE sscr_ass.

  BREAK-POINT.

  ls_opt_list-name      = 'RESTRICT'.
*  ls_opt_list-options-bt = abap_true. " Libera a aba para "Intervalos"
*  ls_opt_list-options-cp = abap_true. " ? " modelo ativo ??
  ls_opt_list-options-eq = abap_true. " =
  ls_opt_list-options-ge = abap_true. " >=
  ls_opt_list-options-gt = abap_true. " >
*  ls_opt_list-options-le = abap_true. " <=
*  ls_opt_list-options-lt = abap_true. " <
*  ls_opt_list-options-nb = abap_true. " ><
*  ls_opt_list-options-ne = abap_true. " <>
*  ls_opt_list-options-np = abap_true. " ? " excluir modelo ativo ??

  APPEND ls_opt_list TO ls_restrict-opt_list_tab.

* Clicando duas vezes na estrutura abaixo, entrando nos campos você
* conseguirá perceber os possiveis valores.
  ls_association-kind    = 'S'.
  ls_association-name    = 'SO_PLANE'. " Nome do select-options
  ls_association-sg_main = 'I'.
*  Abaixo está a opção de restrição que será usada como referencia
* no select-options informado acima.
  ls_association-op_main = ls_association-op_addy = 'RESTRICT'.

  APPEND ls_association TO ls_restrict-ass_tab.

  BREAK-POINT.

  CALL FUNCTION 'SELECT_OPTIONS_RESTRICT'
    EXPORTING
      program     = sy-repid
      restriction = ls_restrict
    EXCEPTIONS
      OTHERS      = 0.

ENDFORM.