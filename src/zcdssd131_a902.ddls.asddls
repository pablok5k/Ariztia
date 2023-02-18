@AbapCatalog.sqlViewName: 'ZSD131_A902'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS Precios'
@VDM: { viewType: #BASIC }
define view ZCDSSD131_A902
  with parameters
    //    p_kschl :kschl,
    p_date :abap.dats
  as select from a902  as A902

    inner join   konp  as KONP  on  a902.knumh    = konp.knumh
                                and konp.loevm_ko = ' '

    inner join   konh  as KONH  on a902.knumh = konh.knumh

    left outer join  konm  as KONM  on a902.knumh = konm.knumh

    left outer join   tvtwt as tvtwt on  a902.vtweg  = tvtwt.vtweg
                                and tvtwt.spras = 'S'

    left outer join   makt  as makt  on  a902.matnr = makt.matnr
                                and makt.spras = 'S'

    left outer join   knvv  as knvv  on  a902.vkorg = knvv.vkorg
                                and a902.vtweg = knvv.vtweg
                                and a902.vkbur = knvv.vkbur


    inner join   kna1  as KNA1  on kna1.kunnr = knvv.kunnr



{
  a902.vkorg,
  a902.vtweg,
  a902.matnr as material,
  kna1.kunnr as customer,
  a902.knumh,
  a902.kschl,

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

  konh.datab as start_date,
  konh.datbi as end_date,

  stcd1      as customer_rut

}
where
      a902.kappl = 'V'
  and a902.datab <= $parameters.p_date
  and a902.datbi >= $parameters.p_date
