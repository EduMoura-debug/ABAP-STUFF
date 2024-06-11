*Dinamicamente mudar o campo de uma estrutura dentro de um loop do

*Exemplo: Ler campos FRGC2 até FRGC8

index = 2
v_campo = 'FRGC'.

DO 7 TIMES.

  CONCATENATE v_campo(4) index INTO v_campo.  //Dinamicamente monta o nome do campo
  ASSIGN COMPONENT v_campo OF STRUCTURE s_t16fs //Retorna o valor para o Field-Symbol
                                   TO <fs_code>.

  IF <fs_code> IS NOT INITIAL.

    SELECT *
    FROM zwf_mm_code
      APPENDING TABLE t_code
      WHERE frgco EQ <fs_code>.

    ADD 1 TO index.
  ELSE.
    EXIT.
  ENDIF.
ENDDO.