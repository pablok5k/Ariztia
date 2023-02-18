@ClientHandling.type: #CLIENT_DEPENDENT
@EndUserText.label: 'Table Funcion SD 313 Productos'
define table function ZTFSD131_P
returns
{

  mandt   : abap.clnt;
  Product : matnr;
  Plants: char50;
  Storages: char50;
}
implemented by method
  ZCL_SD131_AMDP_PRODUCTS=>GET_PRODUCTS_DATA;
