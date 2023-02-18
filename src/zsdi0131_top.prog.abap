*&---------------------------------------------------------------------*
*& Include zsdi0131_top
*&---------------------------------------------------------------------*
tables: mara, knvv, konv.

class lcl_application definition deferred.

data: go_log             type ref to zcl_log_util,
      go_log_application type ref to zcl_log_util_slg.

data: go_prices type ref to zcl_b2b_prices.
data: go_scales type ref to zcl_b2b_scales.


data: lo_rest_client    type ref to cl_rest_http_client,
      lo_request_entity type ref to if_rest_entity,
      lt_fields         type tihttpnvp,
      ls_fields         type ihttpnvp,
      lo_http_entity    type ref to if_http_entity,
      lo_request        type ref to if_rest_entity,
      lo_response       type ref to if_rest_entity.
data: lv_content_type type string,
      lv_body         type string.
data: ls_xml            type string,
      ls_respuesta_xml  type string,
      ld_urlurl         type string,
      lo_https_client   type ref to if_http_client,
      lv_http_status    type string,
      lv_status         type string,
      lv_reason         type string,
      lv_response       type string,
      lv_content_length type string,
      lv_location       type string,
      lt_tab_file       type table of char255,
      ls_xstring        type xstring,
      lv_length         type i,
      lv_string         type string,
      lv_rfc_dest       type rfcdest,
      lo_http_client    type ref to if_http_client.


    data:  lr_data      type ref to data.
