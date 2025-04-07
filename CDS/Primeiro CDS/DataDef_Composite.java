@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Data Definition Order Item'
@Metadata.ignorePropagatedAnnotations: false //true (ignora a config dos filhos, no caso a tabela)
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define view entity ZZI_DLCDS_ORD_IT
  as select from zzdlcdst_ord_it
{
  key sales_order       as SalesOrder,
  key sales_order_item  as SalesOrderItem,
      product           as Product,
      //@Semantics.quantity.unitOfMeasure : 'ProductUnity'
      product_quantity  as ProductQuantity,
      product_unity     as ProductUnity,
      //@Semantics.amount.currencyCode : 'Currency'
      total_value       as TotalValue,
      currency          as Currency,
      creation_date     as CreationDate,
      creation_user     as CreationUser,
      last_changed_by   as LastChangedBy,
      last_changed_from as LastChangedFrom

}