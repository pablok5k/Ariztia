@AbapCatalog.sqlViewName: 'ZSD131_A901'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS Precios'
@VDM: { viewType: #BASIC }
define view ZCDSSD131_A901
  with parameters
    //    p_kschl :kschl,
    p_date :abap.dats
  as select from a901  as A901

    inner join   konp  as KONP  on  a901.knumh    = konp.knumh
                                and konp.loevm_ko = ' '

    inner join   konh  as KONH  on a901.knumh = konh.knumh

    left outer join   konm  as KONM  on a901.knumh = konm.knumh

    left outer join   tvtwt as tvtwt on  a901.vtweg  = tvtwt.vtweg
                                and tvtwt.spras = 'S'

    left outer join   makt  as makt  on  a901.matnr = makt.matnr
                                and makt.spras = 'S'

    inner join   kna1  as KNA1  on a901.kunwe = kna1.kunnr



{
  vkorg,
  a901.vtweg,
  a901.matnr as material,
  kna1.kunnr as customer,

  a901.knumh,
  a901.kschl,

  konm.kopos,
  klfn1,
  konm.kstbm,
  konm.kbetr as scale_price,

  vtext,

  maktx,

  name1,

  konp.kbetr,
  konwa,
  kpein,
  kmein,
  mxwrt,
  loevm_ko,

  a901.datab as start_date,
  a901.datbi as end_date,

  stcd1      as customer_rut

}
where
      a901.kappl = 'V'
//  and a901.datab <= $parameters.p_date
//  and a901.datbi >= $parameters.p_date
