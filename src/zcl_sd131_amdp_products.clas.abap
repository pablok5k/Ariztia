class ZCL_SD131_AMDP_PRODUCTS definition
  public
  final
  create public .

  public section.

    interfaces IF_AMDP_MARKER_HDB .

    class-methods: GET_PRODUCTS_DATA
        for table function ZTFSD131_P.


  protected section.
  private section.
endclass.



class ZCL_SD131_AMDP_PRODUCTS implementation.


  method GET_PRODUCTS_DATA by database function for hdb
                  language sqlscript
                  options read-only
                  using MARA MARD MARC.

    ITL_PRODUCTS_PLANT =
       SELECT
              MARA.MANDT    AS MANDT,
              MARA.MATNR    AS PRODUCT,
              MARC.WERKS    AS PLANT
                            FROM MARA AS MARA
                            INNER JOIN MARC AS MARC ON MARA.MANDT = MARC.MANDT
                                                    AND MARA.MATNR = MARC.MATNR;

    ITL_PRODUCTS_STORAGE =
       SELECT

              MARA.MANDT    AS MANDT,
              MARA.MATNR    AS PRODUCT,
              MARD.LGORT    AS STORAGE
                            FROM MARA AS MARA
                            INNER JOIN MARD AS MARD ON MARA.MANDT = MARD.MANDT
                                                    AND MARA.MATNR = MARD.MATNR;

     ITL_PROCESS_PLANT = SELECT MANDT AS MANDT,
                              PRODUCT as PRODUCT,
                              string_agg(PLANT, ', ' order by PLANT) as PLANTS
                              from :ITL_PRODUCTS_PLANT
                              GROUP BY MANDT, PRODUCT;


        ITL_PROCESS_STORAGE = select  MANDT as MANDT,
                              PRODUCT as PRODUCT,
                              STRING_AGG(STORAGE, ', ' ORDER BY STORAGE) as STORAGES
                              from :ITL_PRODUCTS_STORAGE
                              GROUP BY MANDT, PRODUCT;

ITL_FINAL_TABLE = select :ITL_PROCESS_PLANT.MANDT, :ITL_PROCESS_PLANT.PRODUCT, :ITL_PROCESS_PLANT.PLANTS, :ITL_PROCESS_STORAGE.STORAGES
                                            FROM :ITL_PROCESS_PLANT INNER JOIN  :ITL_PROCESS_STORAGE
                                           ON :ITL_PROCESS_PLANT. MANDT = :ITL_PROCESS_STORAGE.MANDT
                                           AND :ITL_PROCESS_PLANT. PRODUCT = :ITL_PROCESS_STORAGE.PRODUCT;


     RETURN :ITL_FINAL_TABLE;

  ENDMETHOD.

endclass.
