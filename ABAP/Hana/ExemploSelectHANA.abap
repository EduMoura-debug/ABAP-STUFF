

SELECT carrid,
       connid,
       fldate,
       custtype,
       MAX( LUGGWEIGHT ) AS maximo,
       MIN( LUGGWEIGHT ) AS minimo,
       CASE
         WHEN custtype = 'B' THEN 'Bagagem por Empresa'
         WHEN custtype = 'P' THEN 'Bagagem Particular'
       END AS texto_bagagem
       FROM sbook INTO TABLE @DATA(t_data)
       GROUP BY carrid, connid, fldate, custtype.
       IF sy-subrc EQ 0.

       DATA:  gr_table type ref to cl_salv_table .

       call method cl_salv_table=>factory
         IMPORTING
           R_SALV_TABLE = gr_table
         CHANGING
           t_table = t_data.

        gr_table->display( ).

       ENDIF.