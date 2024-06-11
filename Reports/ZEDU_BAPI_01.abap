***********************************************************************
* NOME DO PROGRAMA    : ZEDU_BAPI_01                                  *
* TRANSAÇÃO           :                                               *
* TÍTULO DO PROGRAMA  : Aplicação de BAPI_PO_CREATE1                  *
* DESCRIÇÃO           : Report para exemplo prático e aprendizado     *
* PROGRAMADOR         : Eduardo Freitas Moura (EMOURA)                *
* DATA                : 05.04.2022                                    *
***********************************************************************
REPORT zedu_bapi_01.

"---------------------TIPOS----------------------"
TYPES:
  BEGIN OF tp_linha,
    linha(500) TYPE c,
  END OF tp_linha,

  BEGIN OF tp_download,
    ekorg(20),
    bsart(20),
    bkgrp(20),
    lifnr(20),
    waers(20),
    ebelp(20),
    mwskz(20),
    matnr18(20),
    ewerk(20),
    bstmg(20),
    bapicurext(20),
    j_1bnbmco1(20),
    j_1bmatorg(20),
  END OF tp_download.

"--------------TABELAS E ESTRUTURAS--------------"
"-----DOWNLOAD-----"
DATA: it_download TYPE TABLE OF tp_download,
      wa_download TYPE tp_download,

      it_linha    TYPE TABLE OF tp_linha,
      wa_linha    TYPE tp_linha.

"-------BAPI-------"
DATA: it_poheader  TYPE TABLE OF bapimepoheader,
      it_poheaderx TYPE TABLE OF bapimepoheaderx,
      wa_poheader  TYPE  bapimepoheader,
      wa_poheaderx TYPE  bapimepoheaderx,

      it_poitem    TYPE TABLE OF bapimepoitem,
      it_poitemx   TYPE TABLE OF bapimepoitemx,
      wa_poitem    LIKE LINE OF it_poitem,
      wa_poitemx   LIKE LINE OF it_poitemx,

      it_bapiret2  TYPE TABLE OF bapiret2,
      wa_bapiret2  LIKE LINE OF it_bapiret2,
      v_ebeln      TYPE ebeln.

"----------------OUTROS GLOBAIS------------------"



"-----------------TELA DE SELEÇÂO-----------------"
SELECTION-SCREEN: BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-001.

  PARAMETERS: p_carga LIKE rlgrap-filename.

SELECTION-SCREEN: END OF BLOCK b01.


"----------------VALIDAÇÃO DE TELA----------------"

AT SELECTION-SCREEN.
  IF p_carga IS INITIAL.
    MESSAGE e002(zcm_efmoura).
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

  PERFORM: zf_download_carga,
           zf_preenche_bapi.



*&---------------------------------------------------------------------*
*& Form zf_download_carga
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM zf_download_carga .

  DATA: lv_arq TYPE string.
  lv_arq = p_carga.

  CALL FUNCTION 'GUI_UPLOAD'
    EXPORTING
      filename        = lv_arq
      filetype        = 'ASC'
    TABLES
      data_tab        = it_linha
    EXCEPTIONS
      file_open_error = 1
      OTHERS          = 2.
  IF sy-subrc <> 0.
    MESSAGE e001(zcm_efmoura).
  ENDIF.

  LOOP AT it_linha INTO wa_linha.
    SPLIT wa_linha AT ';' INTO
                              wa_download-ekorg
                              wa_download-bsart
                              wa_download-bkgrp
                              wa_download-lifnr
                              wa_download-waers
                              wa_download-ebelp
                              wa_download-mwskz
                              wa_download-matnr18
                              wa_download-ewerk
                              wa_download-bstmg
                              wa_download-bapicurext
                              wa_download-j_1bnbmco1
                              wa_download-j_1bmatorg.


    APPEND wa_download TO it_download.
  ENDLOOP.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form zf_preenche_BAPI
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM zf_preenche_bapi.

  DATA: bapicurext TYPE p DECIMALS 2.

  LOOP AT it_download INTO wa_download.
    AT FIRST. "Pular cabeçalho
      CONTINUE.
    ENDAT.

*-----------------POHEADER--------------------*

    CLEAR:  wa_poheader,  wa_poheaderx.
    wa_poheader-purch_org    = wa_download-ekorg.
    wa_poheader-doc_type     = wa_download-bsart.
    wa_poheader-pur_group    = wa_download-bkgrp.
    wa_poheader-vendor       = wa_download-lifnr.
    wa_poheader-currency     = wa_download-waers.
    wa_poheader-currency_iso = wa_download-waers.

    wa_poheaderx-purch_org    = 'X'.
    wa_poheaderx-doc_type     = 'X'.
    wa_poheaderx-pur_group    = 'X'.
    wa_poheaderx-vendor       = 'X'.
    wa_poheaderx-currency     = 'X'.
    wa_poheaderx-currency_iso = 'X'.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = wa_poheader-vendor
      IMPORTING
        output = wa_poheader-vendor.

*-----------------POITEM---------------------*

    TRANSLATE wa_download-bapicurext USING ',.'.
    bapicurext = wa_download-bapicurext.

    CLEAR: wa_poitem, it_poitem.
    wa_poitem-po_item    = wa_download-ebelp.
    wa_poitem-tax_code   = wa_download-mwskz.
    wa_poitem-material   = wa_download-matnr18.
    wa_poitem-plant      = wa_download-ewerk.
    wa_poitem-quantity   = wa_download-bstmg.
    wa_poitem-net_price  = bapicurext.
    wa_poitem-bras_nbm   = wa_download-j_1bnbmco1.
    wa_poitem-mat_origin = wa_download-j_1bmatorg.
    wa_poitem-acctasscat = ' '.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = wa_poitem-preq_no
      IMPORTING
        output = wa_poitem-preq_no.

    CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
      EXPORTING
        input        = wa_poitem-material
      IMPORTING
        output       = wa_poitem-material
      EXCEPTIONS
        length_error = 1
        OTHERS       = 2.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

    APPEND wa_poitem TO it_poitem.


    CLEAR: wa_poitemx, it_poitemx.
    wa_poitemx-po_item    = wa_download-ebelp.
    wa_poitemx-tax_code   = 'X'.
    wa_poitemx-material   = 'X'.
    wa_poitemx-plant      = 'X'.
    wa_poitemx-quantity   = 'X'.
    wa_poitemx-net_price  = 'X'.
    wa_poitemx-bras_nbm   = 'X'.
    wa_poitemx-mat_origin = 'X'.
    wa_poitemx-acctasscat = 'X'.
    APPEND wa_poitemx TO it_poitemx.



    PERFORM zf_bapi_create.

  ENDLOOP.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form zf_bapi_create
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM zf_bapi_create .

*------------------BAPI--------------------*
  CALL FUNCTION 'BAPI_PO_CREATE1'
    EXPORTING
      poheader         = wa_poheader
      poheaderx        = wa_poheaderx
    IMPORTING
      exppurchaseorder = v_ebeln
    TABLES
      return           = it_bapiret2
      poitem           = it_poitem
      poitemx          = it_poitemx.

  IF NOT v_ebeln IS INITIAL.
* Commit
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = 'X'.

    ULINE.
**** Success ****
    FORMAT COLOR 5 INVERSE OFF INTENSIFIED ON.
    WRITE: / 'Pedido ', v_ebeln, '-> Produtor:', wa_download-lifnr, 'Produto:', wa_download-ebelp, 'Material:',wa_download-matnr18.
    ULINE.

  ELSE.
    DATA: count TYPE n VALUE 0.

    FORMAT COLOR 6 INVERSE OFF INTENSIFIED OFF.
    WRITE: / 'Mensagens de Erro -> Produtor:', wa_download-lifnr, 'Produto:', wa_download-ebelp, 'Material:',wa_download-matnr18.
    FORMAT RESET.
    ULINE.

    LOOP AT it_bapiret2 INTO wa_bapiret2 WHERE type = 'E'.
**** Error ****
      count += 1.
      WRITE: / count, '-', 5 wa_bapiret2-message.

    ENDLOOP.
    ULINE.
  ENDIF.

ENDFORM.