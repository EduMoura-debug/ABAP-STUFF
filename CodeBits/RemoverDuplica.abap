READ TABLE gt_dif_cliente_sav TRANSPORTING NO FIELDS WITH KEY chitem = gs_dif_cliente-chave_item.
IF sy-subrc NE 0.
	APPEND gs_dif_cliente TO gt_dif_cliente_sav.
ENDIF.	


READ TABLE gt_dif_saldo_sav TRANSPORTING NO FIELDS WITH KEY chitem = ls_dif_saldo-chave_item.
IF sy-subrc NE 0.
	APPEND ls_dif_saldo TO gt_dif_saldo_sav.
ENDIF.							   