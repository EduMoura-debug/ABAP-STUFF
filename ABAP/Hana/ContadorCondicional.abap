
*Tabela Interna: pt_chg_cond
*Campo a ser comparado: is_statistical

DATA(lv_lines) = REDUCE i( INIT x = 0 FOR wa IN pt_chg_cond
                   WHERE ( is_statistical = 'X' ) NEXT x = x + 1 ).