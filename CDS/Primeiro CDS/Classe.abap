
CLASS zzdlcds_001 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

* Preenchimento dos dados
CLASS zzdlcds_001 IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    "Inserir Produto
    TYPES tt_product TYPE TABLE OF zzdlcdst_product WITH DEFAULT KEY.
    DATA(lt_product) = VALUE tt_product(
        ( product = 1 description = 'Caderno' product_type = 1 authorization_group = 1 )
        ( product = 2 description = 'Lápis'   product_type = 1 authorization_group = 1 )
        ( product = 3 description = 'Caneta'  product_type = 1 authorization_group = 1 )
        ( product = 4 description = 'Celular' product_type = 1 authorization_group = 1 )
    ).

    MODIFY zzdlcdst_product FROM TABLE @lt_product.

    "Inserir Itens
    TYPES tt_item TYPE TABLE OF zzdlcdst_ord_it WITH DEFAULT KEY.
    DATA(lt_item) = VALUE tt_item(
        ( sales_order = 1 sales_order_item = 1 product = 1 product_quantity = 2  total_value = 10 )
        ( sales_order = 1 sales_order_item = 2 product = 2 product_quantity = 3  total_value = 20 )
        ( sales_order = 1 sales_order_item = 3 product = 3 product_quantity = 10 total_value = 30 )
        ( sales_order = 2 sales_order_item = 1 product = 4 product_quantity = 4  total_value = 10 )
    ).

    MODIFY zzdlcdst_ord_it FROM TABLE @lt_item.

    out->write( 'Dados Inseridos com sucesso!' ).


  ENDMETHOD.

ENDCLASS.