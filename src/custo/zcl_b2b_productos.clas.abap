class ZCL_B2B_PRODUCTOS definition
  public
      inheriting from ZCL_B2B_INTERFACES
  create public .

  public section.


    types: RANGE_MATNR type range of MATNR.
    types: TT_ZCDSSD131_PRODUCTS type standard table of ZCDSSD131_PRODUCTS.
    data: R_MATNR type RANGE_MATNR.

    types: TT_PRODUCTS type standard table of ZSD131_JSON_PRODUCTS.

    methods CONSTRUCTOR
      importing !I_SALES_ORGANIZATION type VKORG
                !I_INTERFASE_CODE     type ZED_INTERFASE
                !I_LEGACY             type ZED_LEGACY_SYSTEM
                !R_MATNR              type RANGE_MATNR optional
                !I_DATE               type DATUM  optional
      raising
                ZCX_B2B_EXCEPTIONS .

    methods GET_PRODUCTS
      exporting
        E_PRODUCTS type TT_PRODUCTS.

    methods PROCESS_ALL_PRODUCT_DATA
      raising
        ZCX_B2B_EXCEPTIONS.

    methods PROCESS_PRODUCT_DATA_BY_DATE
      raising
        ZCX_B2B_EXCEPTIONS.

    methods SERIALIZE redefinition.

    methods DESERIALIZE redefinition.

  protected section.
  private section.

    data: PRODUCTS type TT_PRODUCTS.

    data: PRICE_DATE type DATUM .
    methods CLEAR.

    methods PROCESS_DATA
      changing
        C_MATERIALS type TT_ZCDSSD131_PRODUCTS.

    methods SET_PARAMETERS
      importing
        !R_MATNR type RANGE_MATNR optional.


    methods GET_DB_MODIFY_PRODUCTS
      returning value(R_RESULT) type SYSUBRC
      raising   ZCX_B2B_EXCEPTIONS.

    methods GET_CHANGEDOCUMENT_READ_ALL
      importing
                !I_DATE_OF_CHANGE type CDHDR-UDATE
                !I_DATE_UNTIL     type CDHDR-UDATE
      exporting
                !E_CDPOS_TABLE    type CDPOS_TAB
                !E_CDHDR_TABLE    type CDHDR_TAB
      returning value(R_RESULT)   type SYSUBRC
      raising
                ZCX_B2B_EXCEPTIONS.

    methods SET_PRICE_DATE
      importing
        !I_DATE type DATUM.
    methods GET_PRICE_DATE
      returning
        value(R_RESULT) type DATUM.

    methods GET_MATERIALS_RANGE
      returning value(RESULT) type RANGE_MATNR.

endclass.


class ZCL_B2B_PRODUCTOS implementation.

  method CONSTRUCTOR.
    SUPER->CONSTRUCTOR( I_SALES_ORGANIZATION = I_SALES_ORGANIZATION
                        I_INTERFASE_CODE     = I_INTERFASE_CODE
                        I_LEGACY             = I_LEGACY ).

    ME->SET_PARAMETERS( R_MATNR ).

    ME->SET_PRICE_DATE( I_DATE = I_DATE ).

    ME->CLEAR( ).

  endmethod.

  method SET_PARAMETERS.
    ME->R_MATNR = R_MATNR.
  endmethod.

  method GET_MATERIALS_RANGE.
    RESULT = ME->R_MATNR.
  endmethod.


  method CLEAR.
    refresh PRODUCTS.
  endmethod.


  method GET_PRODUCTS.
    E_PRODUCTS = PRODUCTS.
  endmethod.


  method PROCESS_ALL_PRODUCT_DATA.
    data R_PRODUCTSB2B type range of MTART.
    data: ERROR_MESSAGE type STRING.
    ZCL_TVARVC=>GET_RANGE( exporting IV_NAME  = 'ZSD0131_MATERIALTOB2B'
                           importing ER_RANGE = R_PRODUCTSB2B ).
    if R_PRODUCTSB2B is initial.
      ERROR_MESSAGE = 'Tabla TVARVC no contiene tipos de productos'(001).
      ZCX_B2B_EXCEPTIONS=>RAISE_TEXT( ERROR_MESSAGE ).
    else.
      data(LR_MATERIALS) = GET_MATERIALS_RANGE( ).
      select * from ZCDSSD131_PRODUCTS into table @data(LT_TOTAL_MATERIALS)
                                       where  PRODUCT in @LR_MATERIALS and PRODUCTTYPE in @R_PRODUCTSB2B.
      if SY-SUBRC eq 0.
        PROCESS_DATA( changing C_MATERIALS = LT_TOTAL_MATERIALS ).
      endif.
    endif.
  endmethod.


  method PROCESS_PRODUCT_DATA_BY_DATE.
    GET_DB_MODIFY_PRODUCTS( ).
  endmethod.


  method GET_DB_MODIFY_PRODUCTS.
    data: LT_CDHDR type CDHDR_TAB,
          LT_CDPOS type CDPOS_TAB.
    data R_PRODUCTSB2B type range of MTART.
    data: ERROR_MESSAGE type STRING.

    ZCL_TVARVC=>GET_RANGE( exporting IV_NAME  = 'ZSD0131_MATERIALTOB2B'
                           importing ER_RANGE = R_PRODUCTSB2B ).
    if R_PRODUCTSB2B is initial.
      ERROR_MESSAGE = 'Tabla TVARVC no contiene tipos de productos'(001).
      ZCX_B2B_EXCEPTIONS=>RAISE_TEXT( ERROR_MESSAGE ).
    else.
      data(RESULT_READ_ALL) = ME->GET_CHANGEDOCUMENT_READ_ALL( exporting I_DATE_OF_CHANGE = ME->GET_PRICE_DATE( )
                                                                   I_DATE_UNTIL     = ME->GET_PRICE_DATE(  )
                                                         importing E_CDPOS_TABLE    = LT_CDPOS
                                                                   E_CDHDR_TABLE    = LT_CDHDR ).
      data(LR_MATERIALS) = GET_MATERIALS_RANGE( ).
      select * from ZCDSSD131_PRODUCTS into table @data(LT_TOTAL_MATERIALS)
                         for all entries in @LT_CDHDR
                         where PRODUCT = @LT_CDHDR-OBJECTID+0(40)
                         and   PRODUCT in @LR_MATERIALS and PRODUCTTYPE in @R_PRODUCTSB2B.
      if SY-SUBRC eq 0.
        PROCESS_DATA( changing C_MATERIALS = LT_TOTAL_MATERIALS ).
      endif.

    endif.
  endmethod.

  method GET_CHANGEDOCUMENT_READ_ALL.
    data: OBJECTCLAS    type CDOBJECTCL value 'MATERIAL',
          DATE_UNTIL    type CDHDR-UDATE,
          ERROR_MESSAGE type STRING.

    if I_DATE_UNTIL is initial.
      DATE_UNTIL = 99991231.
    else.
      DATE_UNTIL = I_DATE_UNTIL.
    endif.
    call function 'CHANGEDOCUMENT_READ_ALL'
      exporting
        I_OBJECTCLASS              = OBJECTCLAS
        I_DATE_OF_CHANGE           = I_DATE_OF_CHANGE
*       i_time_of_change           = '000000'
        I_DATE_UNTIL               = DATE_UNTIL
      importing
        ET_CDPOS                   = E_CDPOS_TABLE
      changing
        CT_CDHDR                   = E_CDHDR_TABLE
      exceptions
        MISSING_INPUT_OBJECTCLASS  = 1
        MISSING_INPUT_HEADER       = 2
        NO_POSITION_FOUND          = 3
        WRONG_ACCESS_TO_ARCHIVE    = 4
        TIME_ZONE_CONVERSION_ERROR = 5
        READ_TOO_MANY_ENTRIES      = 6
        others                     = 7.
    if SY-SUBRC <> 0 and SY-SUBRC <> 3.
      ERROR_MESSAGE = 'CHANGEDOCUMENT_READ_ALL read error'(002).
      ZCX_B2B_EXCEPTIONS=>RAISE_TEXT( ERROR_MESSAGE ).
    else.

    endif.

    R_RESULT = SY-SUBRC.
  endmethod.

  method SET_PRICE_DATE.
    ME->PRICE_DATE = I_DATE.
  endmethod.

  method GET_PRICE_DATE.
    R_RESULT = ME->PRICE_DATE.
  endmethod.

  method PROCESS_DATA.
    data: LS_JSON type ZSD131_JSON_PRODUCTS.
    data: LS_EXTENSION_ATTRIBUTES type ZSD131_ED_EXTENSION_ATTRIBUTES,
          LS_CUSTOM_ATTRIBUTES    type ZSD131_ED_CUSTOM_ATTRIBUTES.
    data: LS_PRODUCTS type ZCDSSD131_PRODUCTS.
    data: NEW_PRODUCT, END_PRODUCT.
    data: ALL_SALES_ORGANIZATIONS  type CHAR30,
          ALL_CHANNEL_DISTRIBUTION type CHAR30.
    refresh PRODUCTS.
    sort C_MATERIALS by  PRODUCT ascending.
    loop at  C_MATERIALS into LS_PRODUCTS.
      clear: END_PRODUCT, NEW_PRODUCT.
      at end of PRODUCT.
        END_PRODUCT = ABAP_TRUE.
      endat.
      at new PRODUCT.
        NEW_PRODUCT = ABAP_TRUE.
      endat.

      clear LS_EXTENSION_ATTRIBUTES.
      clear LS_CUSTOM_ATTRIBUTES.
      if NEW_PRODUCT eq ABAP_TRUE.
        clear LS_JSON.
        clear: ALL_SALES_ORGANIZATIONS,  ALL_CHANNEL_DISTRIBUTION.
        refresh LS_JSON-CUSTOM_ATTRIBUTES.
        refresh LS_JSON-EXTENSION_ATTRIBUTES.
        LS_JSON-NAME = LS_PRODUCTS-PRODUCTNAME.
        LS_JSON-SKU   = LS_PRODUCTS-PRODUCT.
        LS_JSON-ATTRIBUTE_SET_ID = '1'.
        LS_JSON-PRICE = '1'.
        LS_JSON-SPECIAL_PRICE = '1'.
        if LS_PRODUCTS-ISMARKEDFORDELETION eq ABAP_TRUE.
          LS_JSON-STATUS   = '0'.
          LS_JSON-VISIBILITY  = '0'.
        else.
          LS_JSON-STATUS   = '1'.
          LS_JSON-VISIBILITY  = '1'.
        endif.

        LS_JSON-TYPE_ID  = '1'.
        LS_EXTENSION_ATTRIBUTES-IS_IN_STOCK = 'true'.
        LS_EXTENSION_ATTRIBUTES-QTY = '1'.
        append LS_EXTENSION_ATTRIBUTES to LS_JSON-EXTENSION_ATTRIBUTES.
      endif.

      if ALL_SALES_ORGANIZATIONS is initial.
        ALL_SALES_ORGANIZATIONS = LS_PRODUCTS-PRODUCTSALESORG.
      else.
        ALL_SALES_ORGANIZATIONS = | { ALL_SALES_ORGANIZATIONS } ',' { LS_PRODUCTS-PRODUCTSALESORG } | .
      endif.


      if ALL_CHANNEL_DISTRIBUTION is initial.
        ALL_CHANNEL_DISTRIBUTION = LS_PRODUCTS-PRODUCTDISTRIBUTIONCHNL.
      else.
        ALL_CHANNEL_DISTRIBUTION = | { ALL_CHANNEL_DISTRIBUTION } ',' { LS_PRODUCTS-PRODUCTDISTRIBUTIONCHNL } |.
      endif.

      if END_PRODUCT eq ABAP_TRUE.
* Category IDs
*      LS_CUSTOM_ATTRIBUTES-ATTRIBUTE_CODE = 'category_ids'.
*      LS_CUSTOM_ATTRIBUTES-VALUE =
*      APPEND LS_CUSTOM_ATTRIBUTES TO LS_JSON-CUSTOM_ATTRIBUTES.

*marca
*      LS_CUSTOM_ATTRIBUTES-ATTRIBUTE_CODE = 'marca'.
*      LS_CUSTOM_ATTRIBUTES-VALUE =
*      APPEND LS_CUSTOM_ATTRIBUTES TO LS_JSON-CUSTOM_ATTRIBUTES.

*descripcion_subcategoria
        LS_CUSTOM_ATTRIBUTES-ATTRIBUTE_CODE = 'descripcion_subcategoria'.
        LS_CUSTOM_ATTRIBUTES-VALUE = LS_PRODUCTS-SALESSPCFCPRODUCTGROUP4NAME.
        append LS_CUSTOM_ATTRIBUTES to LS_JSON-CUSTOM_ATTRIBUTES.


*descripcion_categoria
        LS_CUSTOM_ATTRIBUTES-ATTRIBUTE_CODE = 'descripcion_categoria'.
        LS_CUSTOM_ATTRIBUTES-VALUE = LS_PRODUCTS-SALESSPCFCPRODUCTGROUP5NAME.
        append LS_CUSTOM_ATTRIBUTES to LS_JSON-CUSTOM_ATTRIBUTES.
*descripcion_emocional
*      LS_CUSTOM_ATTRIBUTES-ATTRIBUTE_CODE = 'descripcion_emocional'.
*      LS_CUSTOM_ATTRIBUTES-VALUE =
*      APPEND LS_CUSTOM_ATTRIBUTES TO LS_JSON-CUSTOM_ATTRIBUTES.
*unidades_por_caja
*      LS_CUSTOM_ATTRIBUTES-ATTRIBUTE_CODE = 'unidades_por_caja'.
*      LS_CUSTOM_ATTRIBUTES-VALUE = LS_PRODUCTS-
*      APPEND LS_CUSTOM_ATTRIBUTES TO LS_JSON-CUSTOM_ATTRIBUTES.
*peso_promedio_por_caja
*        LS_CUSTOM_ATTRIBUTES-ATTRIBUTE_CODE = 'peso_promedio_por_caja'.
*        LS_CUSTOM_ATTRIBUTES-VALUE =
*        APPEND LS_CUSTOM_ATTRIBUTES TO LS_JSON-CUSTOM_ATTRIBUTES.
*dimensiones_de_caja
        LS_CUSTOM_ATTRIBUTES-ATTRIBUTE_CODE = 'dimensiones_de_caja'.
        LS_CUSTOM_ATTRIBUTES-VALUE =  LS_PRODUCTS-DIMENSIONTEXT.
        append LS_CUSTOM_ATTRIBUTES to LS_JSON-CUSTOM_ATTRIBUTES.

*format
*      LS_CUSTOM_ATTRIBUTES-ATTRIBUTE_CODE = 'format'.
*      LS_CUSTOM_ATTRIBUTES-VALUE = LS_PRODUCTS-
*      APPEND LS_CUSTOM_ATTRIBUTES TO LS_JSON-CUSTOM_ATTRIBUTES.

*tipo_de_producto
*      LS_CUSTOM_ATTRIBUTES-ATTRIBUTE_CODE = 'tipo_de_producto'.
*      LS_CUSTOM_ATTRIBUTES-VALUE =
*      APPEND LS_CUSTOM_ATTRIBUTES TO LS_JSON-CUSTOM_ATTRIBUTES.

*ingredientes
*      LS_CUSTOM_ATTRIBUTES-ATTRIBUTE_CODE = 'ingredientes'.
*      LS_CUSTOM_ATTRIBUTES-VALUE =
*      APPEND LS_CUSTOM_ATTRIBUTES TO LS_JSON-CUSTOM_ATTRIBUTES.

* unidad_de_medida
        LS_CUSTOM_ATTRIBUTES-ATTRIBUTE_CODE = 'unidad_de_medida'.
        LS_CUSTOM_ATTRIBUTES-VALUE = LS_PRODUCTS-SALESMEASUREUNIT.
        append LS_CUSTOM_ATTRIBUTES to LS_JSON-CUSTOM_ATTRIBUTES.

*codigo_conservacion
        LS_CUSTOM_ATTRIBUTES-ATTRIBUTE_CODE = 'codigo_conservacion'.
        LS_CUSTOM_ATTRIBUTES-VALUE = LS_PRODUCTS-STORAGECONDITIONS.
        append LS_CUSTOM_ATTRIBUTES to LS_JSON-CUSTOM_ATTRIBUTES.

*descripcion_conservacion
        LS_CUSTOM_ATTRIBUTES-ATTRIBUTE_CODE = 'descripcion_conservacion'.
        LS_CUSTOM_ATTRIBUTES-VALUE = LS_PRODUCTS-STORAGECONDITIONNAME.
        append LS_CUSTOM_ATTRIBUTES to LS_JSON-CUSTOM_ATTRIBUTES.

*centro
        LS_CUSTOM_ATTRIBUTES-ATTRIBUTE_CODE = 'centro'.
        LS_CUSTOM_ATTRIBUTES-VALUE = ls_products-Plants.
        append LS_CUSTOM_ATTRIBUTES to LS_JSON-CUSTOM_ATTRIBUTES.

*almacen
        LS_CUSTOM_ATTRIBUTES-ATTRIBUTE_CODE = 'almacen'.
        LS_CUSTOM_ATTRIBUTES-VALUE = ls_products-Storages.
        append LS_CUSTOM_ATTRIBUTES to LS_JSON-CUSTOM_ATTRIBUTES.

*canal_de_distribucion
        LS_CUSTOM_ATTRIBUTES-ATTRIBUTE_CODE = 'canal_de_distribucion'.
        LS_CUSTOM_ATTRIBUTES-VALUE = ALL_SALES_ORGANIZATIONS.
        append LS_CUSTOM_ATTRIBUTES to LS_JSON-CUSTOM_ATTRIBUTES.

*org_de_ventas
        LS_CUSTOM_ATTRIBUTES-ATTRIBUTE_CODE = 'org_de_ventas'.
        LS_CUSTOM_ATTRIBUTES-VALUE = LS_PRODUCTS-PRODUCTSALESORG.
        append LS_CUSTOM_ATTRIBUTES to LS_JSON-CUSTOM_ATTRIBUTES.
*cucarda
*      LS_CUSTOM_ATTRIBUTES-ATTRIBUTE_CODE = 'cucarda'.
*      LS_CUSTOM_ATTRIBUTES-VALUE = LS_PRODUCTS-
*      APPEND LS_CUSTOM_ATTRIBUTES TO LS_JSON-CUSTOM_ATTRIBUTES.

*impuesto_por_producto
        LS_CUSTOM_ATTRIBUTES-ATTRIBUTE_CODE = 'impuesto_por_producto'.
        LS_CUSTOM_ATTRIBUTES-VALUE = LS_PRODUCTS-MEATTAX.
        append LS_CUSTOM_ATTRIBUTES to LS_JSON-CUSTOM_ATTRIBUTES.


        append LS_JSON to PRODUCTS.
      endif.
    endloop.
  endmethod.

  method SERIALIZE.
    RESULT = /UI2/CL_JSON=>SERIALIZE(
      NAME             = 'product'
      DATA             = I_TABLE
      PRETTY_NAME      = /UI2/CL_JSON=>PRETTY_MODE-LOW_CASE
      ASSOC_ARRAYS_OPT = ABAP_TRUE ).

    concatenate ME->JSON_TOKEN_OBJECT_START ' ' RESULT ' ' JSON_TOKEN_OBJECT_END into RESULT.
  endmethod.

  method DESERIALIZE.
    /UI2/CL_JSON=>DESERIALIZE(
      exporting
        JSON         = I_RESPONSE
        PRETTY_NAME  = /UI2/CL_JSON=>PRETTY_MODE-USER
        ASSOC_ARRAYS = ABAP_TRUE
      changing
        DATA         = E_TABLE ).
  endmethod.

endclass.
