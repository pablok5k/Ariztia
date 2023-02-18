*&---------------------------------------------------------------------*
*& Include zsdi0131_class
*&---------------------------------------------------------------------*
*&                  Clase para gestión de la aplicación
*&---------------------------------------------------------------------*
class lcl_application definition.
  public section.


    methods constructor.
    methods active_log
      importing
        i_active type abap_bool.
    methods is_log_active
      returning
        value(result) type abap_bool.

    methods prepare_interfaces
      importing
        lo_interfase type ref to zcl_b2b_prices
      raising
        zcx_b2b_exceptions.
    methods insert_log_header.

    methods insert_log_error
      importing
        i_text type string.

    methods insert_log_success      importing
                                      i_text type string.

    methods insert_log_information      importing
                                          i_text type string.
    methods insert_log_interfase_data
      importing
        i_interfase type ref to zcl_b2b_prices.
    methods insert_log_text_with_code
      importing
        i_code     type i
        i_response type string.
    methods insert_log_json
      importing
        i_interfase type ref to zcl_b2b_prices.
    methods send_http_request
      importing
        lo_interfase type ref to zcl_b2b_prices.
  protected section.

  private section.

    data: log_active type abap_bool.


endclass.
