* Apenas no HANA 

*FILTER operator

DATA(lt_extract) =
  FILTER #( lt_bseg USING KEY matnr_bwtar WHERE matnr = CONV matnr( SPACE ) 
                                            AND bwtar = CONV bwtar( SPACE ) ).


lt_values_filtered = FILTER #( lt_values IN lt_values_filter
                     WHERE field1 = field1 " 
                     AND field2 = field2
                     ).

lt_values_filtered = FILTER ltty_value( lt_values IN lt_values_filter
                     WHERE field1 = field1 "
                     AND field2 = field2
                     ).

lt_values_filtered = FILTER #( lt_values EXCEPT IN lt_values_filter
    WHERE field1 = field1 " Comparação de chave primária
    AND field2 = field2
    ).

lt_values_filtered = FILTER #( lt_values " Sem o uso de 'IN'
                    WHERE field1 = 3
                    AND field2 = 5
                    ).

lt_vbfa_filter = FILTER #( lt_vbfa_filter USING KEY vb IN t_vbap WHERE vbeln = vbeln ).

*FOR table iterations with VALUE construction operator

DATA(lt_extract) = 
 VALUE tty_bseg( FOR line IN lt_bseg WHERE ( matnr EQ SPACE AND bwtar EQ SPACE ) ( line ) ).