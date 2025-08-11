

EXIT: SAPLF051 -> Projeto ZLCTOFI

EXIT_SAPLF051_001
ZXF09U06

EXIT_SAPLF051_002
ZXF09U05

EXIT_SAPLF051_003



FV60 => Pré Edit => Doc      

===============================

F-47 => ? => Doc Memo

Monitor => Dispara WF => Após Aprovação chamar SHDB => Criar Doc

F-47 => Doc Memo => f110 


========================================= 

No include ZIMME_087 (Enhancement ZENH_RESTART_STRATEGIE_EKPO) foi adicionada, na linha 350, uma validação para impedir que o contrato fique com o Status A "Bloqueado" ao adicionar uma nova linha. Isso é válido apenas para a Organização de Compras (EKORG) OCP2.


TYPE-POOLS: mmcr.

 FIELD-SYMBOLS: <fs_ydrseg> TYPE mmcr_drseg.

    DATA: lv_knumv TYPE ekko-knumv,
          lv_kbetr TYPE konv-kbetr,
          lr_kschl TYPE TABLE OF selopt.

    IF ( sy-tcode EQ 'ZMMDEV' OR sy-tcode EQ 'MIR4' OR sy-tcode EQ 'MIRO' ) AND NF_ITEM-MWSKZ EQ 'R4'.
    CLEAR w_nf_item_tax.
    READ TABLE nf_item_tax INTO w_nf_item_tax WITH KEY taxtyp = 'ZCP2'.
      IF sy-subrc EQ 0 AND w_nf_item_tax-base IS NOT INITIAL.

        ASSIGN ('(SAPLMR1M)YDRSEG') TO <fs_ydrseg>.

        IF <fs_ydrseg> IS ASSIGNED.

          SELECT SINGLE knumv
            FROM ekko
            INTO lv_knumv
            WHERE ebeln EQ <fs_ydrseg>-ebeln.

          IF sy-subrc EQ 0.

            SELECT sign opti low high
              FROM tvarvc
              INTO TABLE lr_kschl
              WHERE name EQ 'ZMMDEV_KSCHL_NFPRI'.

            SELECT SINGLE kbetr
              FROM konv
              INTO lv_kbetr
              WHERE KNUMV EQ lv_knumv
                AND KPOSN EQ <fs_ydrseg>-ebelp
                AND KSCHL IN lr_kschl.

              IF sy-subrc EQ 0.
                ext_item-nfpri  = lv_kbetr.
              ENDIF.
          ENDIF.
      ENDIF.

      ext_item-nfnet  =  w_nf_item_tax-base.
      ext_item-nfnett =  w_nf_item_tax-base.

    ENDIF.
    ENDIF.



KONV-KWERT
( BX70 ou BX80 ) - BX13 
ALterar BX70 e BX80

( PNN0 ou PBBX ) - ZIC3
Alterar ZPIC-KWART


IF 
READ TABLE XKOMV INTO WA WITH KEY kschl = 'ZIC3'.

LBDK9A2PHD GEO.MM.EFM - PRP-CVLB-Ajuste Base PIS COFINS


DATA: wa_pnn0 TYPE komv_index,
      wa_pbbx TYPE komv_index,
      wa_zic3 TYPE komv_index.

IF xkomv-kbetr IS NOT INITIAL AND XKOMV-KSCHL EQ 'ZPIC'.
  READ TABLE xkomv INTO wa_pnn0 WITH KEY kschl = 'PNN0'.
  READ TABLE xkomv INTO wa_pbbx WITH KEY kschl = 'PBBX'.

  IF wa_pnn0 IS NOT INITIAL OR
     wa_pbbx IS NOT INITIAL.

  READ TABLE xkomv INTO wa_zic3 WITH KEY kschl = 'ZIC3'.

    IF sy-subrc EQ 0.

      IF wa_pnn0 IS NOT INITIAL.
        xkomv-kwert = wa_pnn0-kwert + wa_zic3-kwert.
      ELSE.
        xkomv-kwert = wa_pbbx-kwert + wa_zic3-kwert.
      ENDIF.

      MULTIPLY lv_kwert BY lv_kbetr.
      DIVIDE lv_kwert BY 1000.

    ENDIF.
  ENDIF.
ENDIF.