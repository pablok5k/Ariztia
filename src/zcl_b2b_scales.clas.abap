class ZCL_B2B_SCALES definition
    public
    inheriting from ZCL_B2B_INTERFACES
  final
  create public .

  public section.
*    TYPES: ty_helper_type TYPE zcl_b2b_prices=>tt_prices_scale.

    data: SCALES type ZCL_B2B_PRICES=>TT_PRICES_SCALE.

    methods CONSTRUCTOR
      importing !I_SALES_ORGANIZATION type VKORG
                !I_INTERFASE_CODE     type ZED_INTERFASE
                !I_LEGACY             type ZED_LEGACY_SYSTEM
      raising
                ZCX_B2B_EXCEPTIONS.

    methods SET_SCALES
      importing
        I_SCALES type ZCL_B2B_PRICES=>TT_PRICES_SCALE.

    methods GET_SCALES
      exporting
        E_SCALES type ZCL_B2B_PRICES=>TT_PRICES_SCALE.

    methods SERIALIZE redefinition.

    methods DESERIALIZE redefinition.

  protected section.
  private section.
endclass.



class ZCL_B2B_SCALES implementation.

  method CONSTRUCTOR.
    SUPER->CONSTRUCTOR( I_SALES_ORGANIZATION = I_SALES_ORGANIZATION
                        I_INTERFASE_CODE     = I_INTERFASE_CODE
                        I_LEGACY             = I_LEGACY ).
  endmethod.

  method SET_SCALES.
    SCALES = I_SCALES.
  endmethod.

  method GET_SCALES.
    E_SCALES = ME->SCALES.
  endmethod.

  method SERIALIZE.
    RESULT = /UI2/CL_JSON=>SERIALIZE(
      NAME             = 'prices'
      DATA             = I_TABLE
      PRETTY_NAME      = /UI2/CL_JSON=>PRETTY_MODE-LOW_CASE
      ASSOC_ARRAYS_OPT = ABAP_TRUE ).
*    concatenate '{ ' result ' }' into result.
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
