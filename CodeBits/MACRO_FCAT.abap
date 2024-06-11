TYPE-POOLS: slis.
DATA: it_fcat TYPE slis_t_fieldcat_alv,
      wa_fcat LIKE LINE OF it_fcat.

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

  m_fieldcat '' 'CHAVE' 'T_SAIDA' 'Chave'          12 'X' ''  12.
  m_fieldcat '' 'VALOR' 'T_SAIDA' 'Valor'          ''  ''  02.
  m_fieldcat '' 'TEXTO' 'T_SAIDA' 'Texto Editável' ''  'X' 250.

*
*----------------------------------------------------------------------
*REUSE_ALV_GRID_DISPLAY_LVC

*POO: 

*usar lvc_t_fcat e lvc_s_fcat

*COL_POS
*FIELDNAME
*TABNAME
*SELTEXT reptext
*OUTPUTLEN col_opt
*KEY
