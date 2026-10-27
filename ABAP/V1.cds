@AccessControl.authorizationCheck: #NOT_REQUIRED
@AbapCatalog.sqlViewName: 'ZZ1_CB542B5B1131'
@EndUserText.label: 'Billed Sales Orders - Cube'
@AbapCatalog.compiler.compareFilter: true
@Search.searchable: false
@Metadata.allowExtensions: true
@AbapCatalog.dataMaintenance: #DISPLAY_ONLY
@Analytics.dataCategory: #CUBE
@Analytics.internalName: #LOCAL
@ObjectModel.representativeKey: 'BillingDocumentItem'

/*+[hideWarning] { "IDS" : [ "CARDINALITY_CHECK" ]  } */
define view ZZ1_BILLEDSALESORDERSCUBE2

  as select from ZZ1_I_BILLINGDOCUMENTITEM as _BILLEDSALESORDERS
  association [0..1] to I_BillingDocumentTypeText      as _BillingDocumentTypeText       on  _BillingDocumentTypeText.BillingDocumentType = _BILLEDSALESORDERS.BillingDocumentType
                                                                                         and _BillingDocumentTypeText.Language            = $session.system_language
  association [0..1] to ZZ1_CUSTOMERSALESAREAEXT       as _CUSTOMERSALESAREAEXT          on  _CUSTOMERSALESAREAEXT.CustomerNumber       = _BILLEDSALESORDERS.SoldToParty1
                                                                                         and _CUSTOMERSALESAREAEXT.SalesOrganization    = _BILLEDSALESORDERS.SalesOrganization
                                                                                         and _CUSTOMERSALESAREAEXT.DistribuitionChannel = _BILLEDSALESORDERS.DistributionChannel
                                                                                         and _CUSTOMERSALESAREAEXT.Division             = _BILLEDSALESORDERS.Division
  association [0..1] to I_BusinessPartner              as _PayerTo                       on  _PayerTo.BusinessPartner = _BILLEDSALESORDERS.PayerParty
  association [0..1] to I_BusinessPartner              as _SoldTo                        on  _SoldTo.BusinessPartner = _BILLEDSALESORDERS.SoldToParty1
  association [0..1] to I_RegionText                   as _RegionText                    on  _RegionText.Language = $session.system_language
                                                                                         and _RegionText.Region   = _BILLEDSALESORDERS.Region
                                                                                         and _RegionText.Country  = _BILLEDSALESORDERS.Country
  association [0..1] to I_CustomerSalesArea            as _CustomerSalesArea             on  _CustomerSalesArea.Division            = _BILLEDSALESORDERS.Division
                                                                                         and _CustomerSalesArea.DistributionChannel = _BILLEDSALESORDERS.DistributionChannel
                                                                                         and _CustomerSalesArea.SalesOrganization   = _BILLEDSALESORDERS.SalesOrganization
                                                                                         and _CustomerSalesArea.Customer            = _BILLEDSALESORDERS.SoldToParty1
  association [0..1] to I_AdditionalCustomerGroup1     as _InternationalBuyingGroupActua on  _InternationalBuyingGroupActua.AdditionalCustomerGroup1 = _CustomerSalesArea.AdditionalCustomerGroup1
  association [0..1] to I_AdditionalCustomerGroup2     as _BuyingGroupActual             on  _BuyingGroupActual.AdditionalCustomerGroup2 = _CustomerSalesArea.AdditionalCustomerGroup2
  association [0..1] to I_AdditionalCustomerGroup3     as _CustomerClusterActual         on  _CustomerClusterActual.AdditionalCustomerGroup3 = _CustomerSalesArea.AdditionalCustomerGroup3
  association [0..1] to I_AdditionalCustomerGroup4     as _CustomerLOBActual             on  _CustomerLOBActual.AdditionalCustomerGroup4 = _CustomerSalesArea.AdditionalCustomerGroup4
  association [0..1] to I_AdditionalCustomerGroup5     as _ChannelActual                 on  _ChannelActual.AdditionalCustomerGroup5 = _CustomerSalesArea.AdditionalCustomerGroup5
  association [0..1] to I_SalesOrderItem               as _SalesOrderItem                on  _SalesOrderItem.SalesOrderItem = _BILLEDSALESORDERS.SalesDocumentItem
                                                                                         and _SalesOrderItem.SalesOrder     = _BILLEDSALESORDERS.SalesDocument
  association [0..1] to ZZ1_BILLEDSALES_COST_MONTH     as _ZZ1_BILLEDSALES_COST_MONTH    on  _ZZ1_BILLEDSALES_COST_MONTH.BillingDocument     = _BILLEDSALESORDERS.BillingDocument
                                                                                         and _ZZ1_BILLEDSALES_COST_MONTH.BillingDocumentItem = _BILLEDSALESORDERS.BillingDocumentItem
                                                                                         and _ZZ1_BILLEDSALES_COST_MONTH.CompanyCode         = _BILLEDSALESORDERS.CompanyCode
                                                                                         and _ZZ1_BILLEDSALES_COST_MONTH.BillingDocumentDate = _BILLEDSALESORDERS.BillingDocumentDate
  association [0..1] to ZZ1_BILLEDSALES_COST           as _ZZ1_BILLEDSALES_COST          on  _ZZ1_BILLEDSALES_COST.BillingDocument     = _BILLEDSALESORDERS.BillingDocument
                                                                                         and _ZZ1_BILLEDSALES_COST.BillingDocumentItem = _BILLEDSALESORDERS.BillingDocumentItem
                                                                                         and _ZZ1_BILLEDSALES_COST.CompanyCode         = _BILLEDSALESORDERS.CompanyCode
                                                                                         and _ZZ1_BILLEDSALES_COST.BillingDocumentDate = _BILLEDSALESORDERS.BillingDocumentDate
  association [0..1] to ZZ1_BILLEDSALES_REVENUE        as _ZZ1_BILLEDSALES_REVENUE       on  _ZZ1_BILLEDSALES_REVENUE.BillingDocument     = _BILLEDSALESORDERS.BillingDocument
                                                                                         and _ZZ1_BILLEDSALES_REVENUE.BillingDocumentItem = _BILLEDSALESORDERS.BillingDocumentItem
                                                                                         and _ZZ1_BILLEDSALES_REVENUE.CompanyCode         = _BILLEDSALESORDERS.CompanyCode
                                                                                         and _ZZ1_BILLEDSALES_REVENUE.BillingDocumentDate = _BILLEDSALESORDERS.BillingDocumentDate
  association [0..1] to ZZ1_BILLEDSALES_BBACK          as _ZZ1_BILLEDSALES_BBACK         on  _ZZ1_BILLEDSALES_BBACK.BillingDocument     = _BILLEDSALESORDERS.BillingDocument
                                                                                         and _ZZ1_BILLEDSALES_BBACK.BillingDocumentItem = _BILLEDSALESORDERS.BillingDocumentItem
                                                                                         and _ZZ1_BILLEDSALES_BBACK.CompanyCode         = _BILLEDSALESORDERS.CompanyCode
                                                                                         and _ZZ1_BILLEDSALES_BBACK.BillingDocumentDate = _BILLEDSALESORDERS.BillingDocumentDate
  association [0..1] to ZZ1_BILLEDSALES_BBACK_MONTH    as _ZZ1_BILLEDSALES_BBACK_MONTH   on  _ZZ1_BILLEDSALES_BBACK_MONTH.BillingDocument     = _BILLEDSALESORDERS.BillingDocument
                                                                                         and _ZZ1_BILLEDSALES_BBACK_MONTH.BillingDocumentItem = _BILLEDSALESORDERS.BillingDocumentItem
                                                                                         and _ZZ1_BILLEDSALES_BBACK_MONTH.CompanyCode         = _BILLEDSALESORDERS.CompanyCode
                                                                                         and _ZZ1_BILLEDSALES_BBACK_MONTH.BillingDocumentDate = _BILLEDSALESORDERS.BillingDocumentDate
  association [0..1] to ZZ1_BILLEDSALES_DROPSHIP_MONTH as _ZZ1_BILLEDSALES_DROPSHIP_MONT on  _ZZ1_BILLEDSALES_DROPSHIP_MONT.BillingDocument     = _BILLEDSALESORDERS.BillingDocument
                                                                                         and _ZZ1_BILLEDSALES_DROPSHIP_MONT.BillingDocumentItem = _BILLEDSALESORDERS.BillingDocumentItem
                                                                                         and _ZZ1_BILLEDSALES_DROPSHIP_MONT.CompanyCode         = _BILLEDSALESORDERS.CompanyCode
                                                                                         and _ZZ1_BILLEDSALES_DROPSHIP_MONT.BillingDocumentDate = _BILLEDSALESORDERS.BillingDocumentDate
  association [0..1] to ZZ1_BILLEDSALES_DROPSHIP_OV    as _ZZ1_BILLEDSALES_DROPSHIP_OV   on  _ZZ1_BILLEDSALES_DROPSHIP_OV.BillingDocument     = _BILLEDSALESORDERS.BillingDocument
                                                                                         and _ZZ1_BILLEDSALES_DROPSHIP_OV.BillingDocumentItem = _BILLEDSALESORDERS.BillingDocumentItem
                                                                                         and _ZZ1_BILLEDSALES_DROPSHIP_OV.CompanyCode         = _BILLEDSALESORDERS.CompanyCode
                                                                                         and _ZZ1_BILLEDSALES_DROPSHIP_OV.BillingDocumentDate = _BILLEDSALESORDERS.BillingDocumentDate
  association [0..1] to ZZ1_BILLINGDOCUMENT              as _I_BillingDocument           on  _I_BillingDocument.BillingDocument = _BILLEDSALESORDERS.CancelledBillingDocument
  association [0..1] to ZZ1_BILLEDSALES_DELIVERY_ORDER as _ZZ1_BILLEDSALES_DELIVERY_ORDE on  _ZZ1_BILLEDSALES_DELIVERY_ORDE.BillingDocument     = _BILLEDSALESORDERS.BillingDocument
                                                                                         and _ZZ1_BILLEDSALES_DELIVERY_ORDE.BillingDocumentItem = _BILLEDSALESORDERS.BillingDocumentItem

{
      @EndUserText.label: 'Billing Document'
      @Semantics: null
      //      @ObjectModel.foreignKey.association: '_BillingDocument'
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
  key _BILLEDSALESORDERS.BillingDocument                                                                   as BillingDocument,

      @EndUserText.label: 'Billing Item'
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
  key _BILLEDSALESORDERS.BillingDocumentItem                                                               as BillingDocumentItem,

      @EndUserText.label: 'Billing Type'
      @Semantics: null
      @ObjectModel.foreignKey.association: '_BillingDocumentType'
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.BillingDocumentType                                                               as BillingDocumentType,

      @EndUserText.label: 'Created By'
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.CreatedByUser                                                                     as CreatedByUser,

      @EndUserText.label: 'Created on'
      @Semantics.systemDate.createdAt: true
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.CreationDate                                                                      as CreationDate,

      @EndUserText.label: 'Sales office'
      @Semantics: null
      @ObjectModel.foreignKey.association: '_SalesOffice'
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.SalesOffice                                                                       as SalesOffice,

      @EndUserText.label: 'Sales unit'
      @Semantics.unitOfMeasure: true
      @ObjectModel.foreignKey.association: '_BillingQuantityUnit'
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.BillingQuantityUnit                                                               as BillingQuantityUnit,

      @EndUserText.label: 'Base Unit of Measure'
      @Semantics.unitOfMeasure: true
      @ObjectModel.foreignKey.association: '_BaseUnit'
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.BaseUnit                                                                          as BaseUnit,

      @EndUserText.label: 'Billing Volume unit'
      @Semantics.unitOfMeasure: true
      @ObjectModel.foreignKey.association: '_ItemVolumeUnit'
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.ItemVolumeUnit                                                                    as ItemVolumeUnit,

      @EndUserText.label: 'Invoice Document Currency'
      @Semantics.currencyCode: true
      @ObjectModel.foreignKey.association: '_TransactionCurrency'
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.TransactionCurrency                                                               as TransactionCurrency,

      @EndUserText.label: 'Pricing Date'
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.PricingDate                                                                       as PricingDate,

      @EndUserText.label: 'Exchange Rate'
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.PriceDetnExchangeRate                                                             as PriceDetnExchangeRate,

      @EndUserText.label: 'Material Price Grp'
      @Semantics: null
      @ObjectModel.foreignKey.association: '_MaterialPricingGroup'
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.MaterialPricingGroup                                                              as MaterialPricingGroup,

      @EndUserText.label: 'Profit Center'
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.ProfitCenter                                                                      as ProfitCenter,

      @EndUserText.label: 'Volume Rebate Group'
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.VolumeRebateGroup                                                                 as VolumeRebateGroup,

      @EndUserText.label: 'Credit Funct. Active'
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.ItemIsRelevantForCredit                                                           as ItemIsRelevantForCredit,

      @EndUserText.label: 'Credit Price'
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: #SUM
      _BILLEDSALESORDERS.CreditRelatedPrice                                                                as CreditRelatedPrice,

      @EndUserText.label: 'Sales Organization'
      @Semantics: null
      @ObjectModel.foreignKey.association: '_SalesOrganization'
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.SalesOrganization                                                                 as SalesOrganization,

      @EndUserText.label: 'Distribution Channel'
      @Semantics: null
      @ObjectModel.foreignKey.association: '_DistributionChannel'
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.DistributionChannel                                                               as DistributionChannel,

      @EndUserText.label: 'Division'
      @Semantics: null
      @ObjectModel.foreignKey.association: '_Division'
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.Division                                                                          as Division,

      @EndUserText.label: 'Billing Date'
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.BillingDocumentDate                                                               as BillingDocumentDate,

      @EndUserText.label: 'Canceled'
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.BillingDocumentIsCancelled                                                        as BillingDocumentIsCancelled,

      @EndUserText.label: 'Canceled Bill. Doc.'
      @Semantics: null
      @ObjectModel.foreignKey.association: '_CancelledBillingDocument'
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.CancelledBillingDocument                                                          as CancelledBillingDocument,

      @EndUserText.label: 'Payment terms'
      @Semantics: null
      @ObjectModel.foreignKey.association: '_CustomerPaymentTerms'
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.CustomerPaymentTerms                                                              as CustomerPaymentTerms,

      @EndUserText.label: 'Payment Method'
      @Semantics: null
      @ObjectModel.foreignKey.association: '_PaymentMethod'
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.PaymentMethod                                                                     as PaymentMethod,

      @EndUserText.label: 'Company Code'
      @Semantics: null
      @ObjectModel.foreignKey.association: '_CompanyCode'
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.CompanyCode                                                                       as CompanyCode,

      @EndUserText.label: 'Fiscal Year'
      @Semantics: null
      @ObjectModel.foreignKey.association: '_FiscalYear'
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.FiscalYear                                                                        as FiscalYear,

      @EndUserText.label: 'Document Number'
      @Semantics: null
      //      @ObjectModel.foreignKey.association: '_AccountingDocument'
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.AccountingDocument                                                                as AccountingDocument,

      @EndUserText.label: 'Posting period'
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.FiscalPeriod                                                                      as FiscalPeriod,

      @EndUserText.label: 'Acct Assmt Grp Cust.'
      @Semantics: null
      @ObjectModel.foreignKey.association: '_CustomerAccountAssgmtGroup'
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.CustomerAccountAssignmentGroup                                                    as CustomerAccountAssignmentGroup,

      @EndUserText.label: 'Trading Partner No.'
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.PartnerCompany                                                                    as PartnerCompany,

      @EndUserText.label: 'Country'
      @Semantics: null
      @ObjectModel.foreignKey.association: '_Country'
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.Country                                                                           as Country,

      @EndUserText.label: 'Sales District'
      @Semantics: null
      @ObjectModel.foreignKey.association: '_SalesDistrict'
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.SalesDistrict                                                                     as SalesDistrict,

      @EndUserText.label: 'Region'
      @Semantics: null
      @ObjectModel.foreignKey.association: '_Region'
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.Region                                                                            as Region,

      @EndUserText.label: 'Credit control area'
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: '_CreditControlAreaText'
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.CreditControlArea                                                                 as CreditControlArea,

      @EndUserText.label: 'Agreement'
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.CustomerRebateAgreement                                                           as CustomerRebateAgreement,

      @EndUserText.label: 'Overall Status'
      @Semantics: null
      @ObjectModel.foreignKey.association: '_OverallSDProcessStatus'
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.OverallSDProcessStatus                                                            as OverallSDProcessStatus,

      @EndUserText.label: 'Status'
      @Semantics: null
      @ObjectModel.foreignKey.association: '_OverallBillingStatus'
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.OverallBillingStatus                                                              as OverallBillingStatus,

      @EndUserText.label: 'Sales document'
      @Semantics: null
//      @ObjectModel.foreignKey.association: '_SalesDocument'
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.SalesDocument                                                                     as SalesDocument,

      @EndUserText.label: 'Sales Document Item'
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.SalesDocumentItem                                                                 as SalesDocumentItem,

      @EndUserText.label: 'Sales Document Type'
      @Semantics: null
      @ObjectModel.foreignKey.association: '_SalesDocumentType'
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.SalesDocumentType                                                                 as SalesDocumentType,

      @EndUserText.label: 'Product'
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: '_Product'
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.Product                                                                           as Product,

      @EndUserText.label: 'Plant'
      @Semantics: null
//      @ObjectModel.foreignKey.association: '_Plant_1'
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.Plant                                                                             as Plant,

      @EndUserText.label: 'Plant Name'
      @Semantics.text: true
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.PlantName                                                                         as PlantName,

      @EndUserText.label: 'Pack Size'
      @Semantics: null
//      @ObjectModel.foreignKey.association: 'AdditionalMaterialGroup1'
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.PackSize                                                                          as PackSize,

      @EndUserText.label: 'Pack Size Name'
      @Semantics.text: true
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.PackSizeName                                                                      as PackSizeName,

      @EndUserText.label: 'FPS'
      @Semantics: null
//      @ObjectModel.foreignKey.association: '_AdditionalMaterialGroup2'
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.FPS                                                                               as FPS,

      @EndUserText.label: 'FPS Name'
      @Semantics.text: true
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.FPSName                                                                           as FPSName,

      @EndUserText.label: 'Product Application'
      @Semantics: null
//      @ObjectModel.foreignKey.association: '_AdditionalMaterialGroup3'
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.ProductApplication                                                                as ProductApplication,

      @EndUserText.label: 'Product Application Name'
      @Semantics.text: true
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.ProductApplicationName                                                            as ProductApplicationName,

      @EndUserText.label: 'ExxonMobil Sector'
      @Semantics: null
//      @ObjectModel.foreignKey.association: 'AddtionalMaterialGroup4'
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.ExxonMobilSector                                                                  as ExxonMobilSector,

      @EndUserText.label: 'ExxonMobil Sector Name'
      @Semantics.text: true
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.ExxonMobilSectorName                                                              as ExxonMobilSectorName,

      @EndUserText.label: 'International Buying Group'
      @Semantics: null
//      @ObjectModel.foreignKey.association: 'AddtionalCustomerGroup1'
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.InternacionalBuyingGroup                                                          as InternacionalBuyingGroup,

      @EndUserText.label: 'International Buying Group Name'
      @Semantics.text: true
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.InternacionalBuyingGroupName                                                      as InternacionalBuyingGroupName,

      @EndUserText.label: 'Buying Group'
      @Semantics: null
//      @ObjectModel.foreignKey.association: 'AddtionalCustomerGroup2'
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.BuyingGroup                                                                       as BuyingGroup,

      @EndUserText.label: 'Buying Group Name'
      @Semantics.text: true
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.BuyingGroupName                                                                   as BuyingGroupName,

      @EndUserText.label: 'Customer Cluster'
      @Semantics: null
//      @ObjectModel.foreignKey.association: 'AddtionalCustomerGroup3'
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.CustomerCluster                                                                   as CustomerCluster,

      @EndUserText.label: 'Customer Cluster Name'
      @Semantics.text: true
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.CustomerClusterName                                                               as CustomerClusterName,

      @EndUserText.label: 'Requested Delivery Date'
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.RequestedDeliveryDate                                                             as RequestedDeliveryDate,

      @EndUserText.label: 'Payer Party'
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.PayerParty                                                                        as PayerParty,

      @EndUserText.label: 'Payer Party Name'
      @Semantics.text: true
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.PayerPartyName                                                                    as PayerPartyName,

      @EndUserText.label: 'Customer Group'
      @Semantics: null
      @ObjectModel.foreignKey.association: '_CustomerGroup_1'
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.CustomerGroup_1                                                                   as CustomerGroup_1,

      @EndUserText.label: 'Customer Group Name'
      @Semantics.text: true
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.CustomerGroupName                                                                 as CustomerGroupName,

      @EndUserText.label: 'Customer Group'
      @Semantics: null
      @ObjectModel.foreignKey.association: '_CustomerGroup'
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.CustomerGroup                                                                     as CustomerGroup,

      @EndUserText.label: 'Material Volume'
      @Semantics.quantity.unitOfMeasure: 'VolumeUnit'
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: #SUM
      _BILLEDSALESORDERS.MaterialVolume                                                                    as MaterialVolume,

      @EndUserText.label: 'Material Volume unit'
      @Semantics.unitOfMeasure: true
      @ObjectModel.foreignKey.association: '_QuantityUnitValueHelp'
      @ObjectModel.text.association: '_QuantityUnitText'
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.VolumeUnit                                                                        as VolumeUnit,

      @EndUserText.label: 'Customer Price Group'
      @Semantics: null
      @ObjectModel.foreignKey.association: '_CustomerPriceGroup'
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.CustomerPriceGroup                                                                as CustomerPriceGroup,

      @EndUserText.label: 'Document Date'
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.SalesDocumentDate                                                                 as SalesDocumentDate,

      @EndUserText.label: 'Dest. Ctry/Reg. Ord.'
      @Semantics: null
      @ObjectModel.foreignKey.association: '_BillToPartyCountry'
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.BillToPartyCountry                                                                as BillToPartyCountry,

      @EndUserText.label: 'Region Order'
      @Semantics: null
      @ObjectModel.foreignKey.association: '_BillToPartyRegion'
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.BillToPartyRegion                                                                 as BillToPartyRegion,

      @EndUserText.label: 'Numerator'
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.OrderToBaseQuantityNmrtr                                                          as OrderToBaseQuantityNmrtr,

      @EndUserText.label: 'Sales Employee'
      @Semantics: null
      @ObjectModel.foreignKey.association: '_SalesEmployee'
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.SalesEmployee                                                                     as SalesEmployee,

      @EndUserText.label: 'Employee Responsible'
      @Semantics: null
      @ObjectModel.foreignKey.association: '_ResponsibleEmployee'
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.ResponsibleEmployee                                                               as ResponsibleEmployee,

      @EndUserText.label: 'Business Partner'
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.ReferenceBusinessPartner                                                          as ReferenceBusinessPartner,

      @EndUserText.label: 'Price List Type'
      @Semantics: null
      @ObjectModel.foreignKey.association: '_PriceListType'
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.PriceListType                                                                     as PriceListType,

      @EndUserText.label: 'Price List Type Name'
      @Semantics.text: true
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.PriceListTypeName                                                                 as PriceListTypeName,

      @EndUserText.label: 'Bill To Payer'
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.BillToPayer                                                                       as BillToPayer,

      @EndUserText.label: 'Bill To Payer Name'
      @Semantics.text: true
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.BillToPayerName                                                                   as BillToPayerName,

      @EndUserText.label: 'Changed On'
      @Semantics.systemDate.lastChangedAt: true
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.LastChangeDate                                                                    as LastChangeDate,

      @EndUserText.label: 'Days Differents'
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      @ObjectModel.readOnly: true
      DATS_DAYS_BETWEEN(_BILLEDSALESORDERS.BillingDocumentDate, cast( $session.system_date as abap.dats )) as DaysDifferents,

      @EndUserText.label: 'Controlling Area'
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.ControllingArea                                                                   as ControllingArea,

      @EndUserText.label: 'Brand'
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.Brand                                                                             as Brand,

      @EndUserText.label: 'LOB'
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.LOB                                                                               as LOB,

      @EndUserText.label: 'Category'
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.Category                                                                          as Category,

      @EndUserText.label: 'Family'
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.Family                                                                            as Family,

      @EndUserText.label: 'Brand Text'
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.BrandText                                                                         as BrandText,

      @EndUserText.label: 'LOB Text'
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.LobText                                                                           as LOBText,

      @EndUserText.label: 'Category Text'
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.CategoryText                                                                      as CategoryText,

      @EndUserText.label: 'Family Text'
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.FamilyText                                                                        as FamilyText,

      @EndUserText.label: 'Product Description'
      @Semantics.text: true
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.ProductName                                                                       as ProductName,

      @EndUserText.label: 'Billing Document Type Name'
      @Semantics.text: true
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BillingDocumentTypeText.BillingDocumentTypeName                                                     as BillingDocumentTypeName,

      @EndUserText.label: 'Sales Description'
      @Semantics.text: true
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.SalesDocumentItemText                                                             as SalesDocumentItemText,

      @EndUserText.label: 'Billing Quatity'
      @Semantics.quantity.unitOfMeasure: 'BillingQuantityUnit'
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: #SUM
      @ObjectModel.readOnly: true
      BillingQuatity1,

      @EndUserText.label: 'Cost'
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: #SUM
      @ObjectModel.readOnly: true
      CostAmount1,

      @EndUserText.label: 'Gross Value'
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: #SUM
      @ObjectModel.readOnly: true
      GrossAmount1,

      @EndUserText.label: 'Billed Volume'
      @Semantics.quantity.unitOfMeasure: 'ItemVolumeUnit'
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: #SUM
      @ObjectModel.readOnly: true
      ItemVolume1,

      @EndUserText.label: 'Sales Net Price Value'
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: #SUM
      @ObjectModel.readOnly: true
      NetPriceAmount1,

      @EndUserText.label: 'GrossProfit'
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: #SUM
      @ObjectModel.readOnly: true
      GrossProfit,

      @EndUserText.label: 'Customer LOB'
      @Semantics: null
//      @ObjectModel.foreignKey.association: 'AddtionalCustomerGroup4'
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.CustomerLOB                                                                       as CustomerLOB,

      @EndUserText.label: 'Customer LOB Name'
      @Semantics.text: true
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.CustomerLOBName                                                                   as CustomerLOBName,

      @EndUserText.label: 'Channel'
      @Semantics: null
//      @ObjectModel.foreignKey.association: '_AdditionalCustomerGroup5'
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.Channel                                                                           as Channel,

      @EndUserText.label: 'Channel Name'
      @Semantics.text: true
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.ChannelName                                                                       as ChannelName,

      @EndUserText.label: 'Customer Reference'
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.PurchaseOrderByCustomer                                                           as PurchaseOrderByCustomer,

      @EndUserText.label: 'Gross Value'
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: #SUM
      @ObjectModel.readOnly: true
      GrossAmount2,

      @EndUserText.label: 'GrossProfit'
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: #SUM
      @ObjectModel.readOnly: true
      GrossProfit2,

      @EndUserText.label: 'Gross Value'
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: #SUM
      @ObjectModel.readOnly: true
      GrossAmount3,

      @EndUserText.label: 'Shipping Point'
      @Semantics: null
      @ObjectModel.foreignKey.association: '_ShippingPoint'
      @ObjectModel.text.association: '_ShippingPointText'
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.ShippingPoint                                                                     as ShippingPoint,

      @EndUserText.label: 'Incoterms'
      @Semantics: null
      @ObjectModel.foreignKey.association: '_IncotermsClassification'
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.IncotermsClassification                                                           as IncotermsClassification,

      @EndUserText.label: 'Storage location'
      @Semantics: null
//      @ObjectModel.foreignKey.association: '_StorageLocation'
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.StorageLocation                                                                  as StorageLocation,

      @EndUserText.label: 'Weight unit'
      @Semantics.unitOfMeasure: true
      @ObjectModel.foreignKey.association: '_ItemWeightUnit'
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.ItemWeightUnit                                                                    as ItemWeightUnit,

      @EndUserText.label: '_Plant'
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.Plant_1                                                                           as Plant_1,

      @EndUserText.label: 'Old Payer Code'
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _PayerTo.BusinessPartnerIDByExtSystem                                                                as OldPayerCode,

      @EndUserText.label: 'Region Name'
      @Semantics.text: true
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _RegionText.RegionName                                                                               as RegionName,

      @EndUserText.label: 'Old Product Id'
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.OldProductId                                                                      as OldProductId,

      @EndUserText.label: 'Billing Qty in SKU'
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: #NOP
      @ObjectModel.readOnly: true
      BillingQuantityInBaseUnit,

      @EndUserText.label: 'Tax Amount'
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: #SUM
      @ObjectModel.readOnly: true
      TaxAmount,

      @EndUserText.label: 'Rebate Basis'
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: #SUM
      @ObjectModel.readOnly: true
      RebateBasisAmount,

      @EndUserText.label: 'Billing Net Value 1'
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: #SUM
      @ObjectModel.readOnly: true
      NetValue1,

      @EndUserText.label: 'Gross weight'
      @Semantics.quantity.unitOfMeasure: 'ItemWeightUnit'
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: #SUM
      @ObjectModel.readOnly: true
      ItemGrossWeight,

      @EndUserText.label: 'Net weight'
      @Semantics.quantity.unitOfMeasure: 'ItemWeightUnit'
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: #SUM
      @ObjectModel.readOnly: true
      ItemNetWeight,

      @EndUserText.label: 'Change Date New'
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      @ObjectModel.readOnly: true
      case when _BILLEDSALESORDERS.LastChangeDate = '00000000'
      then
        _BILLEDSALESORDERS.BillingDocumentDate
      else
        _BILLEDSALESORDERS.LastChangeDate
      end                                                                                                  as ChangeDateNew,

      @EndUserText.label: 'Sold To Party'
      @Semantics: null
      @ObjectModel.foreignKey.association: '_SoldToPartyBilling'
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.SoldToParty1                                                                      as SoldToParty,

      @EndUserText.label: 'Sold To Party Name'
      @Semantics.text: true
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.SoldToPartyName1                                                                  as SoldToPartyName,

      @EndUserText.label: 'Old Sold To Code'
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _SoldTo.BusinessPartnerIDByExtSystem                                                                 as OldSoldToCode,

      @EndUserText.label: 'Sector'
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: '_SectorText'
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _CUSTOMERSALESAREAEXT.Sector                                                                         as Sector,

      @EndUserText.label: 'Sub-sector'
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: '_SubsectorText'
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _CUSTOMERSALESAREAEXT.SubSector                                                                      as SubSector,

      @EndUserText.label: 'Sector Name'
      @Semantics.text: true
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _CUSTOMERSALESAREAEXT.SectorName                                                                     as SectorName,

      @EndUserText.label: 'Sub-sector Name'
      @Semantics.text: true
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _CUSTOMERSALESAREAEXT.SubSectorName                                                                  as SubSectorName,

      @EndUserText.label: 'International Buying Group Actual'
      @Semantics: null
      @ObjectModel.foreignKey.association: '_InternationalBuyingGroupActua'
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _CustomerSalesArea.AdditionalCustomerGroup1                                                          as InternationalBuyingGroupActual,

      @EndUserText.label: 'Buying Group Actual'
      @Semantics: null
      @ObjectModel.foreignKey.association: '_BuyingGroupActual'
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _CustomerSalesArea.AdditionalCustomerGroup2                                                          as BuyingGroupActual,

      @EndUserText.label: 'Customer Cluster Actual'
      @Semantics: null
      @ObjectModel.foreignKey.association: '_CustomerClusterActual'
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _CustomerSalesArea.AdditionalCustomerGroup3                                                          as CustomerClusterActual,

      @EndUserText.label: 'Customer LOB Actual'
      @Semantics: null
      @ObjectModel.foreignKey.association: '_CustomerLOBActual'
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _CustomerSalesArea.AdditionalCustomerGroup4                                                          as CustomerLOBActual,

      @EndUserText.label: 'Channel Actual'
      @Semantics: null
      @ObjectModel.foreignKey.association: '_ChannelActual'
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _CustomerSalesArea.AdditionalCustomerGroup5                                                          as ChannelActual,

      @EndUserText.label: 'ZBBD Moove Buyback Delvfee'
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: #SUM
      @ObjectModel.readOnly: true
      case when _BILLEDSALESORDERS.BillingDocumentType = 'ZBBD'
      then
          _BILLEDSALESORDERS.NetAmount
      else
          0
      end                                                                                                  as ZBBDMooveBuybackDelvfee,

      @EndUserText.label: 'Sales Document Currency'
      @Semantics.currencyCode: true
      @ObjectModel.foreignKey.association: '_TransactionCurrencySales'
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _SalesOrderItem.TransactionCurrency                                                                  as TransactionCurrencySales,

      @EndUserText.label: 'Sales Cost'
      @Semantics.amount.currencyCode: 'TransactionCurrencySales'
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: #NOP
      @ObjectModel.readOnly: true
      CostAmountSales,

      @EndUserText.label: 'Buyback COGS'
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: #SUM
      @ObjectModel.readOnly: true
      case when _BILLEDSALESORDERS.BillingDocumentType = 'ZBBF'
      then
        _SalesOrderItem.CostAmount
      else
        0
      end                                                                                                  as BuybackCOGS,

      @EndUserText.label: 'Case Quantity'
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: #SUM
      @ObjectModel.readOnly: true
      _BILLEDSALESORDERS.OrderToBaseQuantityNmrtr                                                          as CaseQuantity,

      @EndUserText.label: 'Previus day from Billing Date'
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      @ObjectModel.readOnly: true
      DATS_ADD_DAYS(_BILLEDSALESORDERS.BillingDocumentDate,-1, 'UNCHANGED')                                as BillingDocumentDatePrevius,

      @EndUserText.label: 'Ship-to Party'
      @Semantics: null
//      @ObjectModel.foreignKey.association: '_ShipToParty'
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.ShipToParty                                                                       as ShipToParty,

      @EndUserText.label: 'Name of Customer'
      @Semantics.text: true
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.ShipToPartyName                                                                   as ShipToPartyName,

      @EndUserText.label: 'Country/Region Key'
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.ShipToCountry                                                                     as ShipToCountry,

      @EndUserText.label: 'BilledVolume2'
      @Semantics.quantity.unitOfMeasure: 'ItemVolumeUnit'
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: #SUM
      @ObjectModel.readOnly: true
      ItemVolume2,

      @EndUserText.label: 'Billing Quantity2'
      @Semantics.quantity.unitOfMeasure: 'BillingQuantityUnit'
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: #SUM
      @ObjectModel.readOnly: true
      BillingQuantity2,

      @EndUserText.label: 'Billing Qty In SKU2'
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: #SUM
      @ObjectModel.readOnly: true
      BillingQuantityInBaseUnit2,

      @EndUserText.label: 'CostOverallCCCurrency'
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: #SUM
      _ZZ1_BILLEDSALES_COST.CostOverallCCCurrency                                                          as CostOverallCCCurrency,

      @EndUserText.label: 'CostOverallGlobalCurrency'
      @Semantics.amount.currencyCode: 'GlobalCurrency'
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: #SUM
      _ZZ1_BILLEDSALES_COST.CostOverallGlobalCurrency                                                      as CostOverallGlobalCurrency,

      @EndUserText.label: 'Company Code Currency'
      @Semantics.currencyCode: true
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _ZZ1_BILLEDSALES_COST.CompanyCodeCurrency                                                            as CompanyCodeCurrency,

      @EndUserText.label: 'Global Currency'
      @Semantics.currencyCode: true
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _ZZ1_BILLEDSALES_COST.GlobalCurrency                                                                 as GlobalCurrency,

      @EndUserText.label: 'Global Currency'
      @Semantics.currencyCode: true
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _ZZ1_BILLEDSALES_COST.GlobalCurrency                                                                 as GlobalCurrency_1,

      @EndUserText.label: 'Company Code Currency'
      @Semantics.currencyCode: true
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _ZZ1_BILLEDSALES_COST.CompanyCodeCurrency                                                            as CompanyCodeCurrency_1,

      @EndUserText.label: 'CostMonthCCCurrency'
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: #SUM
      _ZZ1_BILLEDSALES_COST_MONTH.CostMonthCCCurrency                                                      as CostMonthCCCurrency,

      @EndUserText.label: 'CostMonthGlobalCurrency'
      @Semantics.amount.currencyCode: 'GlobalCurrency'
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: #SUM
      _ZZ1_BILLEDSALES_COST_MONTH.CostMonthGlobalCurrency                                                  as CostMonthGlobalCurrency,

      @EndUserText.label: 'Global Currency'
      @Semantics.currencyCode: true
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _ZZ1_BILLEDSALES_COST_MONTH.GlobalCurrency                                                           as GlobalCurrency_2,

      @EndUserText.label: 'Company Code Currency'
      @Semantics.currencyCode: true
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _ZZ1_BILLEDSALES_COST_MONTH.CompanyCodeCurrency                                                      as CompanyCodeCurrency_2,

      @EndUserText.label: 'Revenue in CCode Curr.'
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency_3'
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: #SUM
      _ZZ1_BILLEDSALES_REVENUE.BillingRevCCCurr                                                            as BillingRevCCCurr,

      @EndUserText.label: 'Company Code Currency Rev'
      @Semantics.currencyCode: true
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _ZZ1_BILLEDSALES_REVENUE.CompanyCodeCurrency                                                         as CompanyCodeCurrency_3,

      @EndUserText.label: 'Revenue in Global Curr.'
      @Semantics.amount.currencyCode: 'GlobalCurrency_3'
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: #SUM
      _ZZ1_BILLEDSALES_REVENUE.BillingRevGlobalCurr                                                        as BillingRevGlobalCurr,

      @EndUserText.label: 'Global Currency Rev'
      @Semantics.currencyCode: true
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _ZZ1_BILLEDSALES_REVENUE.GlobalCurrency                                                              as GlobalCurrency_3,

      @EndUserText.label: 'BBCostMonthCCCurrency'
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency_4'
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: #SUM
      _ZZ1_BILLEDSALES_BBACK.CostMonthCCCurrency                                                           as BBCostMonthCCCurrency,

      @EndUserText.label: 'Company Code Currency'
      @Semantics.currencyCode: true
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _ZZ1_BILLEDSALES_BBACK.CompanyCodeCurrency                                                           as CompanyCodeCurrency_4,

      @EndUserText.label: 'BBCostMonthGlobalCurrency'
      @Semantics.amount.currencyCode: 'GlobalCurrency_4'
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: #SUM
      _ZZ1_BILLEDSALES_BBACK.CostMonthGlobalCurrency                                                       as BBCostMonthGlobalCurrency,

      @EndUserText.label: 'Global Currency'
      @Semantics.currencyCode: true
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _ZZ1_BILLEDSALES_BBACK.GlobalCurrency                                                                as GlobalCurrency_4,

      @EndUserText.label: 'BBCostOverallCCCurrency'
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency_5'
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: #SUM
      _ZZ1_BILLEDSALES_BBACK_MONTH.CostMonthCCCurrency                                                     as BBCostOverallCCCurrency,

      @EndUserText.label: 'Company Code Currency'
      @Semantics.currencyCode: true
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _ZZ1_BILLEDSALES_BBACK_MONTH.CompanyCodeCurrency                                                     as CompanyCodeCurrency_5,

      @EndUserText.label: 'BBCostOverallGlobalCurrency'
      @Semantics.amount.currencyCode: 'GlobalCurrency_5'
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: #SUM
      _ZZ1_BILLEDSALES_BBACK_MONTH.CostMonthGlobalCurrency                                                 as BBCostOverallGlobalCurrency,

      @EndUserText.label: 'Global Currency'
      @Semantics.currencyCode: true
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _ZZ1_BILLEDSALES_BBACK_MONTH.GlobalCurrency                                                          as GlobalCurrency_5,

      @EndUserText.label: 'Buyback Rev. in CCode Curr.'
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency_3'
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: #SUM
      _ZZ1_BILLEDSALES_REVENUE.BBackBillRevCCCurr                                                          as BBackBillRevCCCurr,

      @EndUserText.label: 'BuyBack Rev. in Global Curr.'
      @Semantics.amount.currencyCode: 'GlobalCurrency_3'
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: #SUM
      _ZZ1_BILLEDSALES_REVENUE.BBackBillRevGlobalCurr                                                      as BBackBillRevGlobalCurr,

      @EndUserText.label: 'TotalRevenue_CCCurrency'
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency_3'
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: #SUM
      @ObjectModel.readOnly: true
      _ZZ1_BILLEDSALES_REVENUE.BillingRevCCCurr +
      _ZZ1_BILLEDSALES_REVENUE.BBackBillRevCCCurr                                                          as TotalRevenue_CCCurrency,

      @EndUserText.label: 'TotalRevenue_GlobalCurrency'
      @Semantics.amount.currencyCode: 'GlobalCurrency_3'
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: #SUM
      @ObjectModel.readOnly: true
      _ZZ1_BILLEDSALES_REVENUE.BillingRevGlobalCurr +
      _ZZ1_BILLEDSALES_REVENUE.BBackBillRevGlobalCurr                                                      as TotalRevenue_GlobalCurrency,

      @EndUserText.label: 'Transaction Currency Revenue'
      @Semantics.currencyCode: true
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _ZZ1_BILLEDSALES_REVENUE.TransactionCurrency                                                         as TransactionCurrency_1,

      @EndUserText.label: 'Revenue in Trans. Curr.'
      @Semantics.amount.currencyCode: 'TransactionCurrency_1'
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: #SUM
      _ZZ1_BILLEDSALES_REVENUE.BillingRevTRCurr                                                            as BillingRevTRCurr,

      @EndUserText.label: 'Buyback Rev. in Trans. Curr.'
      @Semantics.amount.currencyCode: 'TransactionCurrency_1'
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: #SUM
      _ZZ1_BILLEDSALES_REVENUE.BBackBillRevTRCurr                                                          as BBackBillRevTRCurr,

      @EndUserText.label: 'Transaction Currency2'
      @Semantics.currencyCode: true
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _ZZ1_BILLEDSALES_BBACK.TransactionCurrency                                                           as TransactionCurrency_2,

      @EndUserText.label: 'BBCostMonthTransCurrency'
      @Semantics.amount.currencyCode: 'TransactionCurrency_2'
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: #SUM
      _ZZ1_BILLEDSALES_BBACK.CostMonthTransCurrency                                                        as BBCostMonthTransCurrency,

      @EndUserText.label: 'Transaction Currency BB Cost'
      @Semantics.currencyCode: true
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _ZZ1_BILLEDSALES_BBACK_MONTH.TransactionCurrency                                                     as TransactionCurrency_3,

      @EndUserText.label: 'BBCostOverallTranCurrency'
      @Semantics.amount.currencyCode: 'TransactionCurrency_3'
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: #SUM
      _ZZ1_BILLEDSALES_BBACK_MONTH.CostMonthTranCurrency                                                   as BBCostOverallTranCurrency,

      @EndUserText.label: 'Transaction Currency Cost'
      @Semantics.currencyCode: true
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _ZZ1_BILLEDSALES_COST.TransactionCurrency                                                            as TransactionCurrency_4,

      @EndUserText.label: 'CostOverallTransCurrency'
      @Semantics.amount.currencyCode: 'TransactionCurrency_4'
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: #SUM
      _ZZ1_BILLEDSALES_COST.CostOverallTransCurrency                                                       as CostOverallTransCurrency,

      @EndUserText.label: 'Transaction Currency5'
      @Semantics.currencyCode: true
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _ZZ1_BILLEDSALES_COST_MONTH.TransactionCurrency                                                      as TransactionCurrency_5,

      @EndUserText.label: 'CostMonthTransCurrency'
      @Semantics.amount.currencyCode: 'TransactionCurrency_5'
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: #SUM
      _ZZ1_BILLEDSALES_COST_MONTH.CostMonthTransCurrency                                                   as CostMonthTransCurrency,

      @EndUserText.label: 'TotalRevenue_TransactionCurrency'
      @Semantics.amount.currencyCode: 'TransactionCurrency_1'
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: #SUM
      @ObjectModel.readOnly: true
      _ZZ1_BILLEDSALES_REVENUE.BillingRevTRCurr + _ZZ1_BILLEDSALES_REVENUE.BBackBillRevTRCurr              as TotalRevenue_TransCurrency,

      @EndUserText.label: 'Item category'
      @Semantics: null
      @ObjectModel.foreignKey.association: '_ItemCategory'
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _SalesOrderItem.SalesOrderItemCategory                                                               as SalesOrderItemCategory,

      @EndUserText.label: 'CompanyCodeCurrDrop'
      @Semantics.currencyCode: true
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _ZZ1_BILLEDSALES_DROPSHIP_MONT.CompanyCodeCurrDrop                                                   as CompanyCodeCurrDrop,

      @EndUserText.label: 'CostMonthCCCurrDropship'
      @Semantics.amount.currencyCode: 'CompanyCodeCurrDrop'
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: #SUM
      _ZZ1_BILLEDSALES_DROPSHIP_MONT.CostMonthCCCurrDropship                                               as CostMonthCCCurrDropship,

      @EndUserText.label: 'GlobalCurrDrop'
      @Semantics.currencyCode: true
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _ZZ1_BILLEDSALES_DROPSHIP_MONT.GlobalCurrDrop                                                        as GlobalCurrDrop,

      @EndUserText.label: 'CostMonthGlobalCurrDropship'
      @Semantics.amount.currencyCode: 'GlobalCurrDrop'
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: #SUM
      _ZZ1_BILLEDSALES_DROPSHIP_MONT.CostMonthGlobalCurrDropship                                           as CostMonthGlobalCurrDropship,

      @EndUserText.label: 'TransactionCurrDrop'
      @Semantics.currencyCode: true
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _ZZ1_BILLEDSALES_DROPSHIP_MONT.TransactionCurrDrop                                                   as TransactionCurrDrop,

      @EndUserText.label: 'CostMonthTransCurrDropship'
      @Semantics.amount.currencyCode: 'TransactionCurrDrop'
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: #SUM
      _ZZ1_BILLEDSALES_DROPSHIP_MONT.CostMonthTransCurrDropship                                            as CostMonthTransCurrDropship,

      @EndUserText.label: 'Company Code Currency'
      @Semantics.currencyCode: true
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _ZZ1_BILLEDSALES_DROPSHIP_OV.CompanyCodeCurrDrop2                                                    as CompanyCodeCurrDrop2,

      @EndUserText.label: 'CostCCCurrDropshipOV'
      @Semantics.amount.currencyCode: 'CompanyCodeCurrDrop2'
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: #SUM
      _ZZ1_BILLEDSALES_DROPSHIP_OV.CostCCCurrDropshipOV                                                    as CostCCCurrDropshipOV,

      @EndUserText.label: 'Global Currency'
      @Semantics.currencyCode: true
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _ZZ1_BILLEDSALES_DROPSHIP_OV.GlobalCurrDrop2                                                         as GlobalCurrDrop2,

      @EndUserText.label: 'CostGlobalCurrDropshipOV'
      @Semantics.amount.currencyCode: 'GlobalCurrDrop2'
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: #SUM
      _ZZ1_BILLEDSALES_DROPSHIP_OV.CostGlobalCurrDropshipOV                                                as CostGlobalCurrDropshipOV,

      @EndUserText.label: 'Transaction Currency'
      @Semantics.currencyCode: true
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _ZZ1_BILLEDSALES_DROPSHIP_OV.TransactionCurrDrop2                                                    as TransactionCurrDrop2,

      @EndUserText.label: 'CostTransCurrDropshipOV'
      @Semantics.amount.currencyCode: 'TransactionCurrDrop2'
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: #SUM
      _ZZ1_BILLEDSALES_DROPSHIP_OV.CostTransCurrDropshipOV                                                 as CostTransCurrDropshipOV,

      @EndUserText.label: 'Cancelled Billing Type'
      @Semantics: null
      @ObjectModel.foreignKey.association: '_CancelledBillingDocumentType'
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _I_BillingDocument.BillingDocumentType                                                               as CancelledBillingDocumentType,

      @EndUserText.label: 'SalesOrderQuantity'
      @Semantics.quantity.unitOfMeasure: 'OrderUnit'
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: #SUM
      @ObjectModel.readOnly: true
      case when _BILLEDSALESORDERS.SalesDocumentType = 'ZCR' or
                _BILLEDSALESORDERS.SalesDocumentType = 'ZCRE' or
                _BILLEDSALESORDERS.SalesDocumentType = 'ZCRP' or
                _BILLEDSALESORDERS.SalesDocumentType = 'ZCRR' or
                _BILLEDSALESORDERS.SalesDocumentType = 'ZDR' or
                _BILLEDSALESORDERS.BillingDocumentType = 'ZBBF'

      then
       0
      else

      case when _BILLEDSALESORDERS.BillingDocumentType = 'BK1' or
                _BILLEDSALESORDERS.BillingDocumentType = 'BK3' or
                _BILLEDSALESORDERS.BillingDocumentType = 'CBRE' or
                _BILLEDSALESORDERS.BillingDocumentType = 'CFB3' or
                _BILLEDSALESORDERS.BillingDocumentType = 'CFG2' or
                _BILLEDSALESORDERS.BillingDocumentType = 'CICX' or
                _BILLEDSALESORDERS.BillingDocumentType = 'FAS' or
                _BILLEDSALESORDERS.BillingDocumentType = 'FXG' or
                _BILLEDSALESORDERS.BillingDocumentType = 'G2' or
                _BILLEDSALESORDERS.BillingDocumentType = 'G2S' or
                _BILLEDSALESORDERS.BillingDocumentType = 'IG' or
                _BILLEDSALESORDERS.BillingDocumentType = 'IG2' or
                _BILLEDSALESORDERS.BillingDocumentType = 'IGA' or
                _BILLEDSALESORDERS.BillingDocumentType = 'IVS' or
                _BILLEDSALESORDERS.BillingDocumentType = 'J3G4' or
                _BILLEDSALESORDERS.BillingDocumentType = 'J3G6' or
                _BILLEDSALESORDERS.BillingDocumentType = 'J3G7' or
                _BILLEDSALESORDERS.BillingDocumentType = 'J3G9' or
                _BILLEDSALESORDERS.BillingDocumentType = 'J3GA' or
                _BILLEDSALESORDERS.BillingDocumentType = 'J3GB' or
                _BILLEDSALESORDERS.BillingDocumentType = 'J3GC' or
                _BILLEDSALESORDERS.BillingDocumentType = 'JGL' or
                _BILLEDSALESORDERS.BillingDocumentType = 'LG' or
                _BILLEDSALESORDERS.BillingDocumentType = 'LRS' or
                _BILLEDSALESORDERS.BillingDocumentType = 'OIDR' or
                _BILLEDSALESORDERS.BillingDocumentType = 'RE' or
                _BILLEDSALESORDERS.BillingDocumentType = 'S1' or
                _BILLEDSALESORDERS.BillingDocumentType = 'S3' or
                _BILLEDSALESORDERS.BillingDocumentType = 'SHR' or
                _BILLEDSALESORDERS.BillingDocumentType = 'SV' or
                _BILLEDSALESORDERS.BillingDocumentType = 'VLG2' or
                _BILLEDSALESORDERS.BillingDocumentType = 'VLS1' or
                _BILLEDSALESORDERS.BillingDocumentType = 'ZCGP' or
                _BILLEDSALESORDERS.BillingDocumentType = 'ZG2'

      then
      _ZZ1_BILLEDSALES_DELIVERY_ORDE.SalesOrderQty * -1
      else
       _ZZ1_BILLEDSALES_DELIVERY_ORDE.SalesOrderQty
      end
      end                                                                                                  as SalesOrderQuantity,

      @EndUserText.label: 'Delivered Volume'
      @Semantics.quantity.unitOfMeasure: 'DeliveryVolumeUnit'
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: #SUM
      @ObjectModel.readOnly: true
      case when _BILLEDSALESORDERS.SalesDocumentType = 'ZCR' or
                _BILLEDSALESORDERS.SalesDocumentType = 'ZCRE' or
                _BILLEDSALESORDERS.SalesDocumentType = 'ZCRP' or
                _BILLEDSALESORDERS.SalesDocumentType = 'ZCRR' or
                _BILLEDSALESORDERS.SalesDocumentType = 'ZDR' or
                _BILLEDSALESORDERS.BillingDocumentType = 'ZBBF'

      then
       0
      else

      case when _BILLEDSALESORDERS.BillingDocumentType = 'BK1' or
                _BILLEDSALESORDERS.BillingDocumentType = 'BK3' or
                _BILLEDSALESORDERS.BillingDocumentType = 'CBRE' or
                _BILLEDSALESORDERS.BillingDocumentType = 'CFB3' or
                _BILLEDSALESORDERS.BillingDocumentType = 'CFG2' or
                _BILLEDSALESORDERS.BillingDocumentType = 'CICX' or
                _BILLEDSALESORDERS.BillingDocumentType = 'FAS' or
                _BILLEDSALESORDERS.BillingDocumentType = 'FXG' or
                _BILLEDSALESORDERS.BillingDocumentType = 'G2' or
                _BILLEDSALESORDERS.BillingDocumentType = 'G2S' or
                _BILLEDSALESORDERS.BillingDocumentType = 'IG' or
                _BILLEDSALESORDERS.BillingDocumentType = 'IG2' or
                _BILLEDSALESORDERS.BillingDocumentType = 'IGA' or
                _BILLEDSALESORDERS.BillingDocumentType = 'IVS' or
                _BILLEDSALESORDERS.BillingDocumentType = 'J3G4' or
                _BILLEDSALESORDERS.BillingDocumentType = 'J3G6' or
                _BILLEDSALESORDERS.BillingDocumentType = 'J3G7' or
                _BILLEDSALESORDERS.BillingDocumentType = 'J3G9' or
                _BILLEDSALESORDERS.BillingDocumentType = 'J3GA' or
                _BILLEDSALESORDERS.BillingDocumentType = 'J3GB' or
                _BILLEDSALESORDERS.BillingDocumentType = 'J3GC' or
                _BILLEDSALESORDERS.BillingDocumentType = 'JGL' or
                _BILLEDSALESORDERS.BillingDocumentType = 'LG' or
                _BILLEDSALESORDERS.BillingDocumentType = 'LRS' or
                _BILLEDSALESORDERS.BillingDocumentType = 'OIDR' or
                _BILLEDSALESORDERS.BillingDocumentType = 'RE' or
                _BILLEDSALESORDERS.BillingDocumentType = 'S1' or
                _BILLEDSALESORDERS.BillingDocumentType = 'S3' or
                _BILLEDSALESORDERS.BillingDocumentType = 'SHR' or
                _BILLEDSALESORDERS.BillingDocumentType = 'SV' or
                _BILLEDSALESORDERS.BillingDocumentType = 'VLG2' or
                _BILLEDSALESORDERS.BillingDocumentType = 'VLS1' or
                _BILLEDSALESORDERS.BillingDocumentType = 'ZCGP' or
                _BILLEDSALESORDERS.BillingDocumentType = 'ZG2'

      then
      _ZZ1_BILLEDSALES_DELIVERY_ORDE.DeliveryVolume * -1
      else
       _ZZ1_BILLEDSALES_DELIVERY_ORDE.DeliveryVolume
      end
      end

                                                                                                           as DeliveredVolume,

      @EndUserText.label: 'Delivered Quantity'
      @Semantics.quantity.unitOfMeasure: 'DeliveryQuantityUnit'
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: #SUM
      @ObjectModel.readOnly: true
      case when _BILLEDSALESORDERS.SalesDocumentType = 'ZCR' or
                _BILLEDSALESORDERS.SalesDocumentType = 'ZCRE' or
                _BILLEDSALESORDERS.SalesDocumentType = 'ZCRP' or
                _BILLEDSALESORDERS.SalesDocumentType = 'ZCRR' or
                _BILLEDSALESORDERS.SalesDocumentType = 'ZDR' or
                _BILLEDSALESORDERS.BillingDocumentType = 'ZBBF'

      then
       0
      else

      case when _BILLEDSALESORDERS.BillingDocumentType = 'BK1' or
                _BILLEDSALESORDERS.BillingDocumentType = 'BK3' or
                _BILLEDSALESORDERS.BillingDocumentType = 'CBRE' or
                _BILLEDSALESORDERS.BillingDocumentType = 'CFB3' or
                _BILLEDSALESORDERS.BillingDocumentType = 'CFG2' or
                _BILLEDSALESORDERS.BillingDocumentType = 'CICX' or
                _BILLEDSALESORDERS.BillingDocumentType = 'FAS' or
                _BILLEDSALESORDERS.BillingDocumentType = 'FXG' or
                _BILLEDSALESORDERS.BillingDocumentType = 'G2' or
                _BILLEDSALESORDERS.BillingDocumentType = 'G2S' or
                _BILLEDSALESORDERS.BillingDocumentType = 'IG' or
                _BILLEDSALESORDERS.BillingDocumentType = 'IG2' or
                _BILLEDSALESORDERS.BillingDocumentType = 'IGA' or
                _BILLEDSALESORDERS.BillingDocumentType = 'IVS' or
                _BILLEDSALESORDERS.BillingDocumentType = 'J3G4' or
                _BILLEDSALESORDERS.BillingDocumentType = 'J3G6' or
                _BILLEDSALESORDERS.BillingDocumentType = 'J3G7' or
                _BILLEDSALESORDERS.BillingDocumentType = 'J3G9' or
                _BILLEDSALESORDERS.BillingDocumentType = 'J3GA' or
                _BILLEDSALESORDERS.BillingDocumentType = 'J3GB' or
                _BILLEDSALESORDERS.BillingDocumentType = 'J3GC' or
                _BILLEDSALESORDERS.BillingDocumentType = 'JGL' or
                _BILLEDSALESORDERS.BillingDocumentType = 'LG' or
                _BILLEDSALESORDERS.BillingDocumentType = 'LRS' or
                _BILLEDSALESORDERS.BillingDocumentType = 'OIDR' or
                _BILLEDSALESORDERS.BillingDocumentType = 'RE' or
                _BILLEDSALESORDERS.BillingDocumentType = 'S1' or
                _BILLEDSALESORDERS.BillingDocumentType = 'S3' or
                _BILLEDSALESORDERS.BillingDocumentType = 'SHR' or
                _BILLEDSALESORDERS.BillingDocumentType = 'SV' or
                _BILLEDSALESORDERS.BillingDocumentType = 'VLG2' or
                _BILLEDSALESORDERS.BillingDocumentType = 'VLS1' or
                _BILLEDSALESORDERS.BillingDocumentType = 'ZCGP' or
                _BILLEDSALESORDERS.BillingDocumentType = 'ZG2'

      then
       _ZZ1_BILLEDSALES_DELIVERY_ORDE.ActualDeliveryQuantity * -1
      else
       _ZZ1_BILLEDSALES_DELIVERY_ORDE.ActualDeliveryQuantity
      end
      end

                                                                                                           as DeliveredQuantity,

      @EndUserText.label: 'Delivered Quantity SKU'
      @Semantics.quantity.unitOfMeasure: 'BaseUnit_1'
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: #SUM
      @ObjectModel.readOnly: true
      case when _BILLEDSALESORDERS.SalesDocumentType = 'ZCR' or
                _BILLEDSALESORDERS.SalesDocumentType = 'ZCRE' or
                _BILLEDSALESORDERS.SalesDocumentType = 'ZCRP' or
                _BILLEDSALESORDERS.SalesDocumentType = 'ZCRR' or
                _BILLEDSALESORDERS.SalesDocumentType = 'ZDR' or
                _BILLEDSALESORDERS.BillingDocumentType = 'ZBBF'

      then
       0
      else

      case when _BILLEDSALESORDERS.BillingDocumentType = 'BK1' or
                _BILLEDSALESORDERS.BillingDocumentType = 'BK3' or
                _BILLEDSALESORDERS.BillingDocumentType = 'CBRE' or
                _BILLEDSALESORDERS.BillingDocumentType = 'CFB3' or
                _BILLEDSALESORDERS.BillingDocumentType = 'CFG2' or
                _BILLEDSALESORDERS.BillingDocumentType = 'CICX' or
                _BILLEDSALESORDERS.BillingDocumentType = 'FAS' or
                _BILLEDSALESORDERS.BillingDocumentType = 'FXG' or
                _BILLEDSALESORDERS.BillingDocumentType = 'G2' or
                _BILLEDSALESORDERS.BillingDocumentType = 'G2S' or
                _BILLEDSALESORDERS.BillingDocumentType = 'IG' or
                _BILLEDSALESORDERS.BillingDocumentType = 'IG2' or
                _BILLEDSALESORDERS.BillingDocumentType = 'IGA' or
                _BILLEDSALESORDERS.BillingDocumentType = 'IVS' or
                _BILLEDSALESORDERS.BillingDocumentType = 'J3G4' or
                _BILLEDSALESORDERS.BillingDocumentType = 'J3G6' or
                _BILLEDSALESORDERS.BillingDocumentType = 'J3G7' or
                _BILLEDSALESORDERS.BillingDocumentType = 'J3G9' or
                _BILLEDSALESORDERS.BillingDocumentType = 'J3GA' or
                _BILLEDSALESORDERS.BillingDocumentType = 'J3GB' or
                _BILLEDSALESORDERS.BillingDocumentType = 'J3GC' or
                _BILLEDSALESORDERS.BillingDocumentType = 'JGL' or
                _BILLEDSALESORDERS.BillingDocumentType = 'LG' or
                _BILLEDSALESORDERS.BillingDocumentType = 'LRS' or
                _BILLEDSALESORDERS.BillingDocumentType = 'OIDR' or
                _BILLEDSALESORDERS.BillingDocumentType = 'RE' or
                _BILLEDSALESORDERS.BillingDocumentType = 'S1' or
                _BILLEDSALESORDERS.BillingDocumentType = 'S3' or
                _BILLEDSALESORDERS.BillingDocumentType = 'SHR' or
                _BILLEDSALESORDERS.BillingDocumentType = 'SV' or
                _BILLEDSALESORDERS.BillingDocumentType = 'VLG2' or
                _BILLEDSALESORDERS.BillingDocumentType = 'VLS1' or
                _BILLEDSALESORDERS.BillingDocumentType = 'ZCGP' or
                _BILLEDSALESORDERS.BillingDocumentType = 'ZG2'

      then
       _ZZ1_BILLEDSALES_DELIVERY_ORDE.ActualDeliveredQtyInBaseUnit * -1
      else
       _ZZ1_BILLEDSALES_DELIVERY_ORDE.ActualDeliveredQtyInBaseUnit
      end
      end


                                                                                                           as DeliveredQuantitySKU,

      @EndUserText.label: 'SalesOrderQuantitySKU'
      @Semantics.quantity.unitOfMeasure: 'BaseUnit_1'
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: #SUM
      @ObjectModel.readOnly: true
      case when _BILLEDSALESORDERS.SalesDocumentType = 'ZCR' or
                _BILLEDSALESORDERS.SalesDocumentType = 'ZCRE' or
                _BILLEDSALESORDERS.SalesDocumentType = 'ZCRP' or
                _BILLEDSALESORDERS.SalesDocumentType = 'ZCRR' or
                _BILLEDSALESORDERS.SalesDocumentType = 'ZDR' or
                _BILLEDSALESORDERS.BillingDocumentType = 'ZBBF'

      then
       0
      else

      case when _BILLEDSALESORDERS.BillingDocumentType = 'BK1' or
                _BILLEDSALESORDERS.BillingDocumentType = 'BK3' or
                _BILLEDSALESORDERS.BillingDocumentType = 'CBRE' or
                _BILLEDSALESORDERS.BillingDocumentType = 'CFB3' or
                _BILLEDSALESORDERS.BillingDocumentType = 'CFG2' or
                _BILLEDSALESORDERS.BillingDocumentType = 'CICX' or
                _BILLEDSALESORDERS.BillingDocumentType = 'FAS' or
                _BILLEDSALESORDERS.BillingDocumentType = 'FXG' or
                _BILLEDSALESORDERS.BillingDocumentType = 'G2' or
                _BILLEDSALESORDERS.BillingDocumentType = 'G2S' or
                _BILLEDSALESORDERS.BillingDocumentType = 'IG' or
                _BILLEDSALESORDERS.BillingDocumentType = 'IG2' or
                _BILLEDSALESORDERS.BillingDocumentType = 'IGA' or
                _BILLEDSALESORDERS.BillingDocumentType = 'IVS' or
                _BILLEDSALESORDERS.BillingDocumentType = 'J3G4' or
                _BILLEDSALESORDERS.BillingDocumentType = 'J3G6' or
                _BILLEDSALESORDERS.BillingDocumentType = 'J3G7' or
                _BILLEDSALESORDERS.BillingDocumentType = 'J3G9' or
                _BILLEDSALESORDERS.BillingDocumentType = 'J3GA' or
                _BILLEDSALESORDERS.BillingDocumentType = 'J3GB' or
                _BILLEDSALESORDERS.BillingDocumentType = 'J3GC' or
                _BILLEDSALESORDERS.BillingDocumentType = 'JGL' or
                _BILLEDSALESORDERS.BillingDocumentType = 'LG' or
                _BILLEDSALESORDERS.BillingDocumentType = 'LRS' or
                _BILLEDSALESORDERS.BillingDocumentType = 'OIDR' or
                _BILLEDSALESORDERS.BillingDocumentType = 'RE' or
                _BILLEDSALESORDERS.BillingDocumentType = 'S1' or
                _BILLEDSALESORDERS.BillingDocumentType = 'S3' or
                _BILLEDSALESORDERS.BillingDocumentType = 'SHR' or
                _BILLEDSALESORDERS.BillingDocumentType = 'SV' or
                _BILLEDSALESORDERS.BillingDocumentType = 'VLG2' or
                _BILLEDSALESORDERS.BillingDocumentType = 'VLS1' or
                _BILLEDSALESORDERS.BillingDocumentType = 'ZCGP' or
                _BILLEDSALESORDERS.BillingDocumentType = 'ZG2'

      then
      _ZZ1_BILLEDSALES_DELIVERY_ORDE.SalesOrderQtySKU * -1
      else
       _ZZ1_BILLEDSALES_DELIVERY_ORDE.SalesOrderQtySKU
      end
      end                                                                                                  as SalesOrderQuantitySKU,

      @EndUserText.label: 'BaseUnit'
      @Semantics.unitOfMeasure: true
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _ZZ1_BILLEDSALES_DELIVERY_ORDE.BaseUnit                                                              as BaseUnit_1,

      @EndUserText.label: 'ActualDeliveredQtyInBaseUnit'
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _ZZ1_BILLEDSALES_DELIVERY_ORDE.ActualDeliveredQtyInBaseUnit                                          as ActualDeliveredQtyInBaseUnit,

      @EndUserText.label: 'BaseUnit'
      @Semantics.unitOfMeasure: true
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _ZZ1_BILLEDSALES_DELIVERY_ORDE.DeliveryQuantityUnit                                                  as DeliveryQuantityUnit,

      @EndUserText.label: 'OriginalDeliveryQuantity'
      @Semantics.quantity.unitOfMeasure: 'DeliveryQuantityUnit'
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _ZZ1_BILLEDSALES_DELIVERY_ORDE.OriginalDeliveryQuantity                                              as OriginalDeliveryQuantity,

      @EndUserText.label: 'ActualDeliveryQuantity'
      @Semantics.quantity.unitOfMeasure: 'DeliveryQuantityUnit'
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _ZZ1_BILLEDSALES_DELIVERY_ORDE.ActualDeliveryQuantity                                                as ActualDeliveryQuantity,

      @EndUserText.label: 'Volume unit'
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _ZZ1_BILLEDSALES_DELIVERY_ORDE.DeliveryVolumeUnit                                                    as DeliveryVolumeUnit,

      @EndUserText.label: 'DeliveryVolume'
      @Semantics.quantity.unitOfMeasure: 'DeliveryVolumeUnit'
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _ZZ1_BILLEDSALES_DELIVERY_ORDE.DeliveryVolume                                                        as DeliveryVolume,

      @EndUserText.label: 'Ship-to Party'
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _ZZ1_BILLEDSALES_DELIVERY_ORDE.ShipToParty                                                           as ShipToParty_1,

      @EndUserText.label: 'Name of Customer'
      @Semantics.text: true
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _ZZ1_BILLEDSALES_DELIVERY_ORDE.ShipToPartyName                                                       as ShipToPartyName_1,

      @EndUserText.label: 'Country/Region Key'
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _ZZ1_BILLEDSALES_DELIVERY_ORDE.ShipToCountry                                                         as ShipToCountry_1,

      @EndUserText.label: 'Document Currency'
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _ZZ1_BILLEDSALES_DELIVERY_ORDE.TransactionCurrency                                                   as TransactionCurrency_6,

      @EndUserText.label: 'DeliveryCost'
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _ZZ1_BILLEDSALES_DELIVERY_ORDE.DeliveryCost                                                          as DeliveryCost,

      @EndUserText.label: 'BaseUnit'
      @Semantics.unitOfMeasure: true
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _ZZ1_BILLEDSALES_DELIVERY_ORDE.SOBaseUnit                                                            as SOBaseUnit,

      @EndUserText.label: 'Volume unit'
      @Semantics.unitOfMeasure: true
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _ZZ1_BILLEDSALES_DELIVERY_ORDE.OrderVolumeUnit                                                       as OrderVolumeUnit,

      @EndUserText.label: 'Sales unit'
      @Semantics.unitOfMeasure: true
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _ZZ1_BILLEDSALES_DELIVERY_ORDE.OrderUnit                                                             as OrderUnit,

      @EndUserText.label: 'Sales Order Volume'
      @Semantics.quantity.unitOfMeasure: 'OrderVolumeUnit'
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: false
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: #SUM
      @ObjectModel.readOnly: true
      case when _BILLEDSALESORDERS.SalesDocumentType = 'ZCR' or
                _BILLEDSALESORDERS.SalesDocumentType = 'ZCRE' or
                _BILLEDSALESORDERS.SalesDocumentType = 'ZCRP' or
                _BILLEDSALESORDERS.SalesDocumentType = 'ZCRR' or
                _BILLEDSALESORDERS.SalesDocumentType = 'ZDR' or
                _BILLEDSALESORDERS.BillingDocumentType = 'ZBBF'

      then
       0
      else

      case when _BILLEDSALESORDERS.BillingDocumentType = 'BK1' or
                _BILLEDSALESORDERS.BillingDocumentType = 'BK3' or
                _BILLEDSALESORDERS.BillingDocumentType = 'CBRE' or
                _BILLEDSALESORDERS.BillingDocumentType = 'CFB3' or
                _BILLEDSALESORDERS.BillingDocumentType = 'CFG2' or
                _BILLEDSALESORDERS.BillingDocumentType = 'CICX' or
                _BILLEDSALESORDERS.BillingDocumentType = 'FAS' or
                _BILLEDSALESORDERS.BillingDocumentType = 'FXG' or
                _BILLEDSALESORDERS.BillingDocumentType = 'G2' or
                _BILLEDSALESORDERS.BillingDocumentType = 'G2S' or
                _BILLEDSALESORDERS.BillingDocumentType = 'IG' or
                _BILLEDSALESORDERS.BillingDocumentType = 'IG2' or
                _BILLEDSALESORDERS.BillingDocumentType = 'IGA' or
                _BILLEDSALESORDERS.BillingDocumentType = 'IVS' or
                _BILLEDSALESORDERS.BillingDocumentType = 'J3G4' or
                _BILLEDSALESORDERS.BillingDocumentType = 'J3G6' or
                _BILLEDSALESORDERS.BillingDocumentType = 'J3G7' or
                _BILLEDSALESORDERS.BillingDocumentType = 'J3G9' or
                _BILLEDSALESORDERS.BillingDocumentType = 'J3GA' or
                _BILLEDSALESORDERS.BillingDocumentType = 'J3GB' or
                _BILLEDSALESORDERS.BillingDocumentType = 'J3GC' or
                _BILLEDSALESORDERS.BillingDocumentType = 'JGL' or
                _BILLEDSALESORDERS.BillingDocumentType = 'LG' or
                _BILLEDSALESORDERS.BillingDocumentType = 'LRS' or
                _BILLEDSALESORDERS.BillingDocumentType = 'OIDR' or
                _BILLEDSALESORDERS.BillingDocumentType = 'RE' or
                _BILLEDSALESORDERS.BillingDocumentType = 'S1' or
                _BILLEDSALESORDERS.BillingDocumentType = 'S3' or
                _BILLEDSALESORDERS.BillingDocumentType = 'SHR' or
                _BILLEDSALESORDERS.BillingDocumentType = 'SV' or
                _BILLEDSALESORDERS.BillingDocumentType = 'VLG2' or
                _BILLEDSALESORDERS.BillingDocumentType = 'VLS1' or
                _BILLEDSALESORDERS.BillingDocumentType = 'ZCGP' or
                _BILLEDSALESORDERS.BillingDocumentType = 'ZG2'

      then
       _ZZ1_BILLEDSALES_DELIVERY_ORDE.SalesOrderVolume * -1
      else
       _ZZ1_BILLEDSALES_DELIVERY_ORDE.SalesOrderVolume
      end
      end                                                                                                  as SalesOrderVolume,



      @EndUserText.label: '_AdditionalCustomerGroup1'
      @ObjectModel.association.type: null
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.AddtionalCustomerGroup1                                                         as AddtionalCustomerGroup1,

      @EndUserText.label: '_AdditionalCustomerGroup2'
      @ObjectModel.association.type: null
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.AddtionalCustomerGroup2                                                         as AddtionalCustomerGroup2,

      @EndUserText.label: '_AdditionalCustomerGroup3'
      @ObjectModel.association.type: null
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.AddtionalCustomerGroup3                                                         as AddtionalCustomerGroup3,

      @EndUserText.label: '_AdditionalMaterialGroup1'
      @ObjectModel.association.type: null
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.AdditionalMaterialGroup1                                                         as AdditionalMaterialGroup1,

      @EndUserText.label: '_AdditionalMaterialGroup2'
      @ObjectModel.association.type: null
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.AdditionalMaterialGroup2                                                         as AdditionalMaterialGroup2,

      @EndUserText.label: '_AdditionalMaterialGroup3'
      @ObjectModel.association.type: null
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.AdditionalMaterialGroup3                                                         as AdditionalMaterialGroup3,

      @EndUserText.label: '_AdditionalMaterialGroup4'
      @ObjectModel.association.type: null
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.AdditionalMaterialGroup4                                                         as AdditionalMaterialGroup4,

      @EndUserText.label: '_BaseUnit'
      @ObjectModel.association.type: null
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS._BaseUnit                                                                         as _BaseUnit,

      @EndUserText.label: '_BillingDocumentType'
      @ObjectModel.association.type: null
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS._BillingDocumentType                                                              as _BillingDocumentType,

      @EndUserText.label: '_BillingQuantityUnit'
      @ObjectModel.association.type: null
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS._BillingQuantityUnit                                                              as _BillingQuantityUnit,

      @EndUserText.label: '_BillToPartyCountry'
      @ObjectModel.association.type: null
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS._BillToPartyCountry                                                               as _BillToPartyCountry,

      @EndUserText.label: '_BillToPartyRegion'
      @ObjectModel.association.type: null
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS._BillToPartyRegion                                                                as _BillToPartyRegion,

      @EndUserText.label: '_CancelledBillingDocument'
      @ObjectModel.association.type: null
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS._CancelledBillingDocument                                                         as _CancelledBillingDocument,

      @EndUserText.label: '_CompanyCode'
      @ObjectModel.association.type: null
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS._CompanyCode                                                                      as _CompanyCode,

      @EndUserText.label: '_Country'
      @ObjectModel.association.type: null
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS._Country                                                                          as _Country,

      @EndUserText.label: '_CreditControlAreaText'
      @ObjectModel.association.type: null
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS._CreditControlAreaText                                                            as _CreditControlAreaText,

      @EndUserText.label: '_CustomerAccountAssgmtGroup'
      @ObjectModel.association.type: null
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS._CustomerAccountAssgmtGroup                                                       as _CustomerAccountAssgmtGroup,

      @EndUserText.label: '_CustomerGroup'
      @ObjectModel.association.type: null
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS._CustomerGroup                                                                    as _CustomerGroup,

      @EndUserText.label: '_CustomerGroup'
      @ObjectModel.association.type: null
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS._CustomerGroup_1                                                                  as _CustomerGroup_1,

      @EndUserText.label: '_CustomerPaymentTerms'
      @ObjectModel.association.type: null
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS._CustomerPaymentTerms                                                             as _CustomerPaymentTerms,

      @EndUserText.label: '_CustomerPriceGroup'
      @ObjectModel.association.type: null
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS._CustomerPriceGroup                                                               as _CustomerPriceGroup,

      @EndUserText.label: '_DistributionChannel'
      @ObjectModel.association.type: null
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS._DistributionChannel                                                              as _DistributionChannel,

      @EndUserText.label: '_Division'
      @ObjectModel.association.type: null
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS._Division                                                                         as _Division,

      @EndUserText.label: '_FiscalYear'
      @ObjectModel.association.type: null
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS._FiscalYear                                                                       as _FiscalYear,

      @EndUserText.label: '_ItemVolumeUnit'
      @ObjectModel.association.type: null
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS._ItemVolumeUnit                                                                   as _ItemVolumeUnit,

      @EndUserText.label: '_MaterialPricingGroup'
      @ObjectModel.association.type: null
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS._MaterialPricingGroup                                                             as _MaterialPricingGroup,

      @EndUserText.label: '_OverallBillingStatus'
      @ObjectModel.association.type: null
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS._OverallBillingStatus                                                             as _OverallBillingStatus,

      @EndUserText.label: '_OverallSDProcessStatus'
      @ObjectModel.association.type: null
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS._OverallSDProcessStatus                                                           as _OverallSDProcessStatus,

      @EndUserText.label: '_PaymentMethod'
      @ObjectModel.association.type: null
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS._PaymentMethod                                                                    as _PaymentMethod,

      @EndUserText.label: '_PriceListType'
      @ObjectModel.association.type: null
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS._PriceListType                                                                    as _PriceListType,

      @EndUserText.label: '_ProfitCenter'
      @ObjectModel.association.type: null
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS._ProfitCenter                                                                     as _ProfitCenter,

      @EndUserText.label: '_QuantityUnitText'
      @ObjectModel.association.type: null
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS._QuantityUnitText                                                                 as _QuantityUnitText,

      @EndUserText.label: '_QuantityUnitValueHelp'
      @ObjectModel.association.type: null
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS._QuantityUnitValueHelp                                                            as _QuantityUnitValueHelp,

      @EndUserText.label: '_Region'
      @ObjectModel.association.type: null
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS._Region                                                                           as _Region,

      @EndUserText.label: '_ResponsibleEmployee'
      @ObjectModel.association.type: null
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS._ResponsibleEmployee                                                              as _ResponsibleEmployee,

      @EndUserText.label: '_SalesDistrict'
      @ObjectModel.association.type: null
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS._SalesDistrict                                                                    as _SalesDistrict,

      @EndUserText.label: 'Salesdoc'
      @ObjectModel.association.type: null
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.Salesdoc                                                                          as Salesdoc,

      @EndUserText.label: '_SalesDocumentType'
      @ObjectModel.association.type: null
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS._SalesDocumentType                                                                as _SalesDocumentType,

      @EndUserText.label: '_SalesEmployee'
      @ObjectModel.association.type: null
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS._SalesEmployee                                                                    as _SalesEmployee,

      @EndUserText.label: '_SalesOffice'
      @ObjectModel.association.type: null
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS._SalesOffice                                                                      as _SalesOffice,

      @EndUserText.label: '_SalesOrganization'
      @ObjectModel.association.type: null
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS._SalesOrganization                                                                as _SalesOrganization,

      @EndUserText.label: '_TransactionCurrency'
      @ObjectModel.association.type: null
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS._TransactionCurrency                                                              as _TransactionCurrency,

      @EndUserText.label: '_Product'
      @ObjectModel.association.type: null
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS._Text                                                                             as _Product,

      @EndUserText.label: '_CreditControlArea'
      @ObjectModel.association.type: null
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS._CreditControlArea                                                                as _CreditControlArea,

      @EndUserText.label: '_ControllingArea'
      @ObjectModel.association.type: null
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS._ControllingArea                                                                  as _ControllingArea,

      @EndUserText.label: '_AdditionalCustomerGroup4'
      @ObjectModel.association.type: null
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.AddtionalCustomerGroup4                                                         as AddtionalCustomerGroup4,

      //      @EndUserText.label: '_AdditionalCustomerGroup5'
      //      @ObjectModel.association.type: null
      //      @Semantics: null
      //      @ObjectModel.foreignKey.association: null
      //      @ObjectModel.text.association: null
      //      @ObjectModel.text.element: null
      //      @Consumption.groupWithElement: null
      //      @Consumption.valueHelp: null
      //      @Consumption.filter.selectionType: null
      //      @Aggregation.default: null
      //      _BILLEDSALESORDERS._AdditionalCustomerGroup5                                                         as _AdditionalCustomerGroup5,

      @EndUserText.label: '_ShippingPoint'
      @ObjectModel.association.type: null
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS._ShippingPoint                                                                    as _ShippingPoint,

      @EndUserText.label: '_ShippingPointText'
      @ObjectModel.association.type: null
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS._ShippingPointText                                                                as _ShippingPointText,

      @EndUserText.label: '_IncotermsClassification'
      @ObjectModel.association.type: null
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS._IncotermsClassification                                                          as _IncotermsClassification,

      @EndUserText.label: '_StorageLocation'
      @ObjectModel.association.type: null
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS._StorageLocation                                                                 as _StorageLocation,

      @EndUserText.label: '_ItemWeightUnit'
      @ObjectModel.association.type: null
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS._ItemWeightUnit                                                                   as _ItemWeightUnit,

      @EndUserText.label: '_Plant'
      @ObjectModel.association.type: null
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS._Plant_1                                                                          as _Plant_1,

      @EndUserText.label: '_SoldToParty'
      @ObjectModel.association.type: null
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS._SoldToPartyBilling                                                               as _SoldToPartyBilling,

      @EndUserText.label: 'Additional Customer Group 1'
      @ObjectModel.association.type: null
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _InternationalBuyingGroupActua                                                                       as _InternationalBuyingGroupActua,

      @EndUserText.label: 'Additional Customer Group 2'
      @ObjectModel.association.type: null
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BuyingGroupActual                                                                                   as _BuyingGroupActual,

      @EndUserText.label: 'Additional Customer Group 3'
      @ObjectModel.association.type: null
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _CustomerClusterActual                                                                               as _CustomerClusterActual,

      @EndUserText.label: 'Additional Customer Group 4'
      @ObjectModel.association.type: null
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _CustomerLOBActual                                                                                   as _CustomerLOBActual,

      @EndUserText.label: 'Additional Customer Group 5'
      @ObjectModel.association.type: null
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _ChannelActual                                                                                       as _ChannelActual,

      @EndUserText.label: '_SectorText'
      @ObjectModel.association.type: null
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _CUSTOMERSALESAREAEXT._SectorText                                                                    as _SectorText,

      @EndUserText.label: '_SubsectorText'
      @ObjectModel.association.type: null
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _CUSTOMERSALESAREAEXT._SubsectorText                                                                 as _SubsectorText,

      @EndUserText.label: '_TransactionCurrencySales'
      @ObjectModel.association.type: null
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _SalesOrderItem._TransactionCurrency                                                                 as _TransactionCurrencySales,

      @EndUserText.label: '_ItemCategory'
      @ObjectModel.association.type: null
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _SalesOrderItem._ItemCategory                                                                        as _ItemCategory,

      @EndUserText.label: '_CancelledBillingDocumentType'
      @ObjectModel.association.type: null
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _I_BillingDocument._BillingDocumentType                                                              as _CancelledBillingDocumentType,

      @Analytics.hidden: true
      @Consumption.hidden: true
      @ObjectModel.association.type: null
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS./SAP/1__BILLINGDOCUMENT                                                           as /SAP/2__BILLINGDOCUMENT,

      @Analytics.hidden: true
      @Semantics: null
      @ObjectModel.foreignKey.association: null
      @ObjectModel.text.association: null
      @ObjectModel.text.element: null
      @Consumption.groupWithElement: null
      @Consumption.valueHelp: null
      @Consumption.hidden: true
      @Consumption.filter.mandatory: false
      @Consumption.filter.multipleSelections: false
      @Consumption.filter.selectionType: null
      @Aggregation.default: null
      _BILLEDSALESORDERS.BillingDocument                                                                   as /SAP/1_BILLINGDOCUMENT
     
}

where
  _BILLEDSALESORDERS.Uname = $session.user
