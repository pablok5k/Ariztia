@AbapCatalog.sqlViewName: 'ZCDSSD131_P'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS Productos para enviar a B2B'
define view ZCDSSD131_PRODUCTS
  as select from I_ProductSalesDelivery
  association [1..1] to I_Productstorage          as _Productstorage          on I_ProductSalesDelivery.Product = _Productstorage.Product
  association [1..1] to ZTFSD131_P                as Locations                on I_ProductSalesDelivery.Product = Locations.Product
  //  association [1..*] to I_ProductStorageLocation  as _ProductStorageLocation  on I_ProductSalesDelivery.Product = _ProductStorageLocation.Product
  association [1..1] to I_SalesSpcfcProductGroup1 as _SalesSpcfcProductGroup1 on $projection.FirstSalesSpecProductGroup = _SalesSpcfcProductGroup1.SalesSpcfcProductGroup1
  association [1..1] to I_SalesSpcfcProductGroup2 as _SalesSpcfcProductGroup2 on $projection.SecondSalesSpecProductGroup = _SalesSpcfcProductGroup2.SalesSpcfcProductGroup2
  association [1..1] to I_SalesSpcfcProductGroup3 as _SalesSpcfcProductGroup3 on $projection.ThirdSalesSpecProductGroup = _SalesSpcfcProductGroup3.SalesSpcfcProductGroup3
  association [1..1] to I_SalesSpcfcProductGroup4 as _SalesSpcfcProductGroup4 on $projection.FourthSalesSpecProductGroup = _SalesSpcfcProductGroup4.SalesSpcfcProductGroup4
  association [1..1] to I_SalesSpcfcProductGroup5 as _SalesSpcfcProductGroup5 on $projection.FifthSalesSpecProductGroup = _SalesSpcfcProductGroup5.SalesSpcfcProductGroup5
  association [1..1] to I_ProductSalesTax         as _ProductSalesTax         on $projection.Product = _ProductSalesTax.Product
{
      @ObjectModel.foreignKey.association: '_Product'
  key I_ProductSalesDelivery.Product                                                                                     as Product,
      @ObjectModel.foreignKey.association: '_SalesOrganization'
  key I_ProductSalesDelivery.ProductSalesOrg                                                                             as ProductSalesOrg,
      @ObjectModel.foreignKey.association: '_DistributionChannel'
  key I_ProductSalesDelivery.ProductDistributionChnl                                                                     as ProductDistributionChnl,
      I_ProductSalesDelivery._Product.ProductType                                                                        as ProductType,
      I_ProductSalesDelivery._Product._ProductGroupText[1: Language = $session.system_language].MaterialGroupName        as MaterialGroupName,
      I_ProductSalesDelivery._Product.BaseUnit                                                                           as BaseUnit,
      I_ProductSalesDelivery._Product.IsMarkedForDeletion                                                                as IsMarkedForDeletion,
      I_ProductSalesDelivery._Product.SizeOrDimensionText                                                                as DimensionText,
      I_ProductSalesDelivery._Product.WeightUnit                                                                         as WeightUnit,
      I_ProductSalesDelivery._Product.GrossWeight                                                                        as GrossWeight,
      @ObjectModel.text.association: '_ProductGroupText'
      I_ProductSalesDelivery._Product.ProductGroup                                                                       as ProductGroup,
      I_ProductSalesDelivery._Product._ProductGroupText[1: Language = $session.system_language].MaterialGroupName        as ProductGroupText,
      @ObjectModel.text.association: '_ExtProdGrpText'
      I_ProductSalesDelivery._Product.ExternalProductGroup                                                               as ExternalProductGroup,
      I_ProductSalesDelivery._Product._ExtProdGrpText[1: Language = $session.system_language].ExternalProductGroupName   as ExternalProductGroupName,
      I_ProductSalesDelivery._Product._Text[1: Language = $session.system_language].ProductName                          as ProductName,
      @ObjectModel.text.association: '_ProductHierarchyText'
      I_ProductSalesDelivery._Product.ProductHierarchy                                                                   as ProductHierarchy,
      I_ProductSalesDelivery._Product._ProductHierarchyText[1: Language = $session.system_language].ProductHierarchyText as ProductHierarchyText,
      I_ProductSalesDelivery.SalesMeasureUnit                                                                            as SalesMeasureUnit,
      I_ProductSalesDelivery.FirstSalesSpecProductGroup                                                                  as FirstSalesSpecProductGroup,
      _SalesSpcfcProductGroup1._Text[1: Language = $session.system_language].SalesSpcfcProductGroup1Name                 as SalesSpcfcProductGroup1Name,
      I_ProductSalesDelivery.SecondSalesSpecProductGroup                                                                 as SecondSalesSpecProductGroup,
      _SalesSpcfcProductGroup2._Text[1: Language = $session.system_language].SalesSpcfcProductGroup2Name                 as SalesSpcfcProductGroup2Name,
      I_ProductSalesDelivery.ThirdSalesSpecProductGroup                                                                  as ThirdSalesSpecProductGroup,
      _SalesSpcfcProductGroup3._Text[1: Language = $session.system_language].SalesSpcfcProductGroup3Name                 as SalesSpcfcProductGroup3Name,
      I_ProductSalesDelivery.FourthSalesSpecProductGroup                                                                 as FourthSalesSpecProductGroup,
      _SalesSpcfcProductGroup4._Text[1: Language = $session.system_language].SalesSpcfcProductGroup4Name                 as SalesSpcfcProductGroup4Name,
      I_ProductSalesDelivery.FifthSalesSpecProductGroup                                                                  as FifthSalesSpecProductGroup,
      _SalesSpcfcProductGroup5._Text[1: Language = $session.system_language].SalesSpcfcProductGroup5Name                 as SalesSpcfcProductGroup5Name,
      @ObjectModel.text.association: '_StorageText'
      _Productstorage.StorageConditions                                                                                  as StorageConditions,
      _Productstorage._StorageText[1: Language = $session.system_language].StorageConditionName                          as StorageConditionName,
      Locations.Plants                                                                                                   as Plants,
      Locations.Storages                                                                                                 as Storages,
      case  _ProductSalesTax[1: TaxCategory = 'MWST' ].TaxClassification when '1' then 19 when '0' then 0 end            as Ivatax,
      case  _ProductSalesTax[1: TaxCategory = 'MWS5' ].TaxClassification when '1' then 5 when '0' then 0 end             as Meattax
}
//where  Product = '000000000967314714'
