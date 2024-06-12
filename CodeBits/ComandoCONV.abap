"Use CONV #( ) para  converter data types e salvar em uma variável temporária 

DATA a_char(2) TYPE C.

a_char = `cc`.
methods_takes_string( CONV #( a_char ) ).

DATA a_string TYPE string.

a_string = a_char.
methods_takes_string( a_string ).