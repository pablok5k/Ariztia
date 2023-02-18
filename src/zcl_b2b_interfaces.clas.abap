class zcl_b2b_interfaces definition
  public
  create public .

  public section.
    interfaces zif_b2b_properties .


*"* public components of class zCL_HTTP_STATUS_CODES
*"* do not include other source files here!!!
    constants accepted type i value 202.                    "#EC NOTEXT
    constants bad_gateway type i value 502.                 "#EC NOTEXT
    constants bad_request type i value 400.                 "#EC NOTEXT
    constants conflict type i value 409.                    "#EC NOTEXT
    constants continue type i value 100.                    "#EC NOTEXT
    constants created type i value 201.                     "#EC NOTEXT
    constants expectation_failed type i value 417.          "#EC NOTEXT
    constants forbidden type i value 403.                   "#EC NOTEXT
    constants found type i value 302.                       "#EC NOTEXT
    constants gateway_timeout type i value 504.             "#EC NOTEXT
    constants gone type i value 410.                        "#EC NOTEXT
    constants http_version_not_supported type i value 505.  "#EC NOTEXT
    constants internal_server_error type i value 500.       "#EC NOTEXT
    constants length_required type i value 411.             "#EC NOTEXT
    constants method_not_allowed type i value 405.          "#EC NOTEXT
    constants moved_permanently type i value 301.           "#EC NOTEXT
    constants multiple_choices type i value 300.            "#EC NOTEXT
    constants nonauthoritative_informatio type i value 203. "#EC NOTEXT
    constants not_acceptable type i value 406.              "#EC NOTEXT
    constants not_found type i value 404.                   "#EC NOTEXT
    constants not_implemented type i value 501.             "#EC NOTEXT
    constants not_modified type i value 304.                "#EC NOTEXT
    constants no_content type i value 204.                  "#EC NOTEXT
    constants ok type i value 200.                          "#EC NOTEXT
    constants partial_content type i value 206.             "#EC NOTEXT
    constants payment_required type i value 402.            "#EC NOTEXT
    constants precondition_failed type i value 412.         "#EC NOTEXT
    constants proxy_authentication_requir type i value 407. "#EC NOTEXT
    constants requested_range_not_satisfi type i value 416. "#EC NOTEXT
    constants requesturi_too_large type i value 414.        "#EC NOTEXT
    constants request_entity_too_large type i value 413.    "#EC NOTEXT
    constants request_timeout type i value 408.             "#EC NOTEXT
    constants reset_content type i value 205.               "#EC NOTEXT
    constants see_other type i value 303.                   "#EC NOTEXT
    constants service_unavailable type i value 503.         "#EC NOTEXT
    constants switching_protocols type i value 101.         "#EC NOTEXT
    constants temporary_redirect type i value 307.          "#EC NOTEXT
    constants unauthorized type i value 401.                "#EC NOTEXT
    constants unsupported_media_type type i value 415.      "#EC NOTEXT
    constants use_proxy type i value 305.                   "#EC NOTEXT
    constants json_token_array_start type c value '['.      "#EC NOTEXT
    constants json_token_array_end type c value ']'.        "#EC NOTEXT
    constants json_token_object_start type c value '{'.     "#EC NOTEXT
    constants json_token_object_end type c value '}'.       "#EC NOTEXT
    constants json_token_name_val_separator type c value ':'. "#EC NOTEXT
    constants json_token_value_separator type c value ','.  "#EC NOTEXT
    constants json_token_string type c value '"'.           "#EC NOTEXT
    constants json_token_escape type c value '\'.           "#EC NOTEXT

    data: lo_client type ref to if_http_client.
    data: last_json_message type string.

    methods constructor importing !i_sales_organization type vkorg
                                  !i_interfase_code     type zed_interfase
                                  !i_legacy             type zed_legacy_system
                        raising
                                  zcx_b2b_exceptions.

    methods create_by_url
      raising
        zcx_b2b_exceptions.

    methods get_sales_organization returning value(result)   type vkorg.

    methods get_interfase_code returning value(result) type   zed_interfase.

    methods get_legacy_code returning value(result) type zed_legacy_system.

    methods get_host returning value(result) type http_host.

    methods get_service returning value(result) type http_service_short.

    methods get_method returning value(result) type httpmethod.

    methods get_port returning value(result) type http_port.

    methods get_timeout returning value(result) type  httptimeout.

    methods get_token returning value(result) type  httpvalue.

    methods get_username returning value(result) type http_chw_username.

    methods get_password returning value(result) type http_password_fieb.

    methods get_version returning value(result) type httpversion.

    methods get_credentials_bool returning value(result) type  http_cors_credentials.

    methods get_db_interfase_header returning value(result) type zsd0131_t.

    methods get_connection_string returning value(result) type  string.

    methods set_last_json_message importing json type string.

    methods get_last_json_message returning value(result) type string.

    methods set_request_method.

    methods set_authorization.

    methods set_version.

    methods set_propertytype_logon_popup.

    methods serialize importing i_table       type any
                      returning value(result) type string.
    methods deserialize       importing
                                i_response type string
                              exporting
                                e_table    type ref to data.

    methods set_general_parameters
      raising
        zcx_b2b_exceptions.

  protected section.
  private section.

    data: sales_organization type vkorg,
          interfase          type zed_interfase,
          legacy             type zed_legacy_system,
          host               type http_host,
          service            type http_service_short,
          method             type httpmethod,
          port               type http_port,
          version            type httpversion,
          timeout            type httptimeout,
          token              type httpvalue,
          username           type http_chw_username,
          password           type http_password_fieb,
          credentials        type http_cors_credentials.

    data: connection_string  type string,
          xconnection_string type string,
          node_name          type string.



    methods get_db_interfase_data
      importing !i_sales_organization type vkorg
                !i_interfase_code     type zed_interfase
                !i_legacy             type zed_legacy_system
      returning value(interfase_data) type zsd0131_services
      raising
                zcx_b2b_exceptions.

    methods set_interfase_data
      importing
        !i_interfase_data type zsd0131_services.

    methods set_string_connection
      raising
        zcx_b2b_exceptions.


endclass.

class zcl_b2b_interfaces implementation.

  method constructor.

    data(interfase_data) = me->get_db_interfase_data(
      i_sales_organization = i_sales_organization
      i_interfase_code     = i_interfase_code
      i_legacy             = i_legacy ).

    me->set_interfase_data( interfase_data ).

*    me->connection_string = i_connection_string.
  endmethod.

  method zif_b2b_properties~initialize.

  endmethod.

  method create_by_url.
    data: error_message type string.


    me->set_string_connection( ).


    cl_http_client=>create_by_url(
      exporting
        url                = me->connection_string
      importing
        client             = me->lo_client
      exceptions
        argument_not_found = 1
        plugin_not_active  = 2
        internal_error     = 3
    ).

    if sy-subrc <> 0.
      case sy-subrc.
        when 1.
          error_message = 'HTTPS ARGUMENT_NOT_FOUND | STRUST/SSL Setup correct?'.
        when others.
          error_message = 'While creating HTTP Client'.

      endcase.
      zcx_b2b_exceptions=>raise_text( error_message ).
    endif.

  endmethod.


  method get_db_interfase_data.
    data error_message type string.
    select single * from zsd0131_services
             into corresponding fields of interfase_data
             where vkorg = i_sales_organization
             and   interfase = i_interfase_code
             and   legacy = i_legacy.

    if sy-subrc eq 0.

    else.

      error_message = 'No existe interfase en tabla de customizing'.
      zcx_b2b_exceptions=>raise_text( error_message ).
    endif.
  endmethod.


  method set_interfase_data.

    me->sales_organization    = i_interfase_data-vkorg.
    me->interfase             = i_interfase_data-interfase.
    me->legacy                = i_interfase_data-legacy.
    me->host                  = i_interfase_data-host.
    me->service               = i_interfase_data-service.
    me->method                = i_interfase_data-method.
    me->port                  = i_interfase_data-port.
    me->version               = i_interfase_data-version.
    me->timeout               = i_interfase_data-timeout.
    me->token                 = i_interfase_data-token.
    me->username              = i_interfase_data-username.
    me->password              = i_interfase_data-password.
    me->credentials           = i_interfase_data-credentials.

  endmethod.


  method get_credentials_bool.
    result = me->credentials.
  endmethod.

  method get_host.
    result = me->host.
  endmethod.

  method get_interfase_code.
    result = me->interfase.
  endmethod.

  method get_legacy_code.
    result = me->legacy.
  endmethod.

  method get_method.
    result = me->method.
  endmethod.

  method get_password.
    result = me->password.
  endmethod.

  method get_port.
    result = me->port.
  endmethod.

  method get_sales_organization.
    result = me->sales_organization.
  endmethod.

  method get_service.
    result = me->service.
  endmethod.

  method get_timeout.
    result = me->timeout.
  endmethod.

  method get_token.
    result = me->token.
  endmethod.

  method get_username.
    result = me->username.
  endmethod.

  method set_string_connection.
    data: error_message type string.

    me->connection_string = |{ me->host }{ me->service }|.

*    TRANSLATE me->connection_string TO LOWER CASE.

    if me->connection_string is initial.
      error_message = 'No es posible definir string de conexión'.
      zcx_b2b_exceptions=>raise_text( error_message ).
    endif.
  endmethod.

  method set_request_method.
    me->lo_client->request->set_method( me->get_method( ) ).
  endmethod.

  method set_authorization.

    if me->get_credentials_bool( ) eq abap_true.
    else.
      me->lo_client->request->set_header_field( exporting name  = 'Authorization'
                                                          value = conv #( me->get_token( ) ) ).
    endif.
  endmethod.

  method get_version.
    result = me->version.
  endmethod.

  method set_propertytype_logon_popup.
    me->lo_client->propertytype_logon_popup = me->lo_client->co_disabled.
  endmethod.

  method set_version.
    data(version_http) = me->get_version( ).

    if version_http eq 'HTTP 1.0'.
      me->lo_client->request->set_version( me->lo_client->request->co_protocol_version_1_0 ).
    else.
      me->lo_client->request->set_version( me->lo_client->request->co_protocol_version_1_1 ).
    endif.

  endmethod.

  method serialize.
    result = /ui2/cl_json=>serialize(
      data             = i_table
      pretty_name      = /ui2/cl_json=>pretty_mode-low_case
      assoc_arrays_opt = abap_true ).
*    concatenate '{ ' result ' }' into result.
    concatenate me->json_token_object_start result json_token_object_end into result.
  endmethod.


  method deserialize.
    /ui2/cl_json=>deserialize(
      exporting
        json         = i_response
        pretty_name  = /ui2/cl_json=>pretty_mode-user
        assoc_arrays = abap_true
      changing
        data         = e_table ).
  endmethod.

  method get_db_interfase_header.

    data(interfase_code) =  me->get_interfase_code( ).
    select single * from zsd0131_t into result where interfase = interfase_code .

  endmethod.

  method get_connection_string.
    result = me->connection_string.
  endmethod.

  method get_last_json_message.

    result = me->last_json_message.

  endmethod.

  method set_last_json_message.

    me->last_json_message = json.

  endmethod.

  method set_general_parameters.
    me->set_propertytype_logon_popup( ).
    me->lo_client->request->set_version( ).
  endmethod.
endclass.
