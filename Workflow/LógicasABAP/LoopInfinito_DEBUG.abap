*Criar Loop Infinito para debugar métodos que ocorrem em background.

DATA: lv_controle_debug TYPE tvarvc-low,
      lv_controle_loop  TYPE flag.

CLEAR: lv_controle_debug, lv_controle_loop.
"Criar uma TVARV para habilitar ou desabilitar o debug
SELECT SINGLE low
    FROM tvarvc
    INTO lv_controle_debug
    WHERE name EQ 'HABILITA_DEBUG_WF'.

IF lv_controle_debug EQ abap_true.
    DO. "Pela SM50 podemos entrar nesse ponto pelo debug 
        "Pelo Debug, preencher o flag com X para sair do loop inifinito    
        IF lv_controle_loop EQ abap_true. 
           EXIT.
        ENDIF.
    ENDDO.
ENDIF.


***** Outro *****

DATA: lc_ativo LIKE ztbsd_wf_debug-ativo.

SELECT SINGLE ativo
  INTO lc_ativo
FROM ztb_wf_debug
WHERE id_wf = 'WF_ID'        "WS9XXXXXXX
  AND evento = 'METHOD_NAME' "Método passado pela task
  AND task = 'TASK_ID'.      "TS9XXXXXXX
IF lc_ativo = abap_true.
  DATA: a.
  WHILE a IS INITIAL.
  ENDWHILE.
ENDIF.