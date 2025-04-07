//--------- DATABASE TABLE ---------//

//Tabela Produto
@EndUserText.label : 'Tabela Product'
@AbapCatalog.enhancement.category : #NOT_EXTENSIBLE
@AbapCatalog.tableCategory : #TRANSPARENT
@AbapCatalog.deliveryClass : #A
@AbapCatalog.dataMaintenance : #RESTRICTED
define table zzdlcdst_product {

  key client          : abap.clnt not null;
  key product         : int4 not null;
  product_type        : int4;
  description         : char40;
  authorization_group : int4;
  creation_date_time  : timestamp;

}

//Tabela Ordem de Item
@EndUserText.label : 'Tabela Order Item'
@AbapCatalog.enhancement.category : #NOT_EXTENSIBLE
@AbapCatalog.tableCategory : #TRANSPARENT
@AbapCatalog.deliveryClass : #A
@AbapCatalog.dataMaintenance : #RESTRICTED
define table zzdlcdst_ord_it {

  key client           : abap.clnt not null;
  key sales_order      : int4 not null;
  key sales_order_item : int4 not null;
  product              : int4;
  @Semantics.quantity.unitOfMeasure : 'zzdlcdst_ord_it.product_unity'
  product_quantity     : abap.quan(10,2);
  product_unity        : meins;
  @Semantics.amount.currencyCode : 'zzdlcdst_ord_it.currency'
  total_value          : abap.curr(10,2);
  currency             : waers;
  creation_date        : dats;
  creation_user        : uname;
  last_changed_by      : uname;
  last_changed_from    : timestamp;

}






