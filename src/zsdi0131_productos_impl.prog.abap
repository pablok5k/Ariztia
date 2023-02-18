*&---------------------------------------------------------------------*
*& Include zsdi0131_productos_impl
*&---------------------------------------------------------------------*


class lcl_application implementation.

  method constructor.

  endmethod.


  method active_log.

    if i_active eq abap_true.
      log_active = abap_true.

      " Preparación de log SLG1
      go_log_application  = new #(  ).
      go_log_application->set_object( i_slg_object = 'ZB2B'  ).
      go_log_application->set_sub_object( i_slg_sub_object = 'ZSD0131' ).
      go_log_application->set_external_number( i_slg_ext_number = conv #( sy-datum ) ).
      go_log_application->enable( ).
    else.
      clear log_active.
    endif.

  endmethod.


  method is_log_active.
    result = me->log_active.
  endmethod.

  method prepare_interfaces.


    lo_interfase->create_by_url( ).

    lo_interfase->set_general_parameters( ).

    lo_interfase->set_request_method( ).

    lo_interfase->set_authorization( ).

    lo_interfase->lo_client->request->if_http_entity~set_content_type( if_rest_media_type=>gc_appl_json ).

    lo_interfase->lo_client->request->set_header_field(
      exporting
        name  = 'httpscontent-type'
        value = 'application/json' ).


  endmethod.


  method insert_log_header.
    if me->is_log_active( ) eq abap_true.
      data(lv_message) = |Ejecución Fecha: | & |{ sy-datum }|.
      go_log_application->log( i_msgty = 'S' i_msgtx_flg = 'X' i_msgtx =  lv_message ).
    endif.
  endmethod.

  method insert_log_success.
    if me->is_log_active( ) eq abap_true.
      go_log_application->log( i_msgty = 'S' i_msgtx_flg = 'X' i_msgtx =  i_text ).
    endif.
  endmethod.

  method insert_log_information.
    if me->is_log_active( ) eq abap_true.
      go_log_application->log( i_msgty = 'I' i_msgtx_flg = 'X' i_msgtx =  i_text ).
    endif.
  endmethod.

  method insert_log_error.
    if me->is_log_active( ) eq abap_true.
      go_log_application->log( i_msgty = 'E' i_msgtx_flg = 'X' i_msgtx =  i_text ).
    endif.
  endmethod.


  method insert_log_interfase_data.
    data: message type string.
    clear message.
    if me->is_log_active( ) eq abap_true.
      data(interfase_header) = i_interfase->get_db_interfase_header(  ).
      message =  |'Interfase:' { interfase_header-description  } 'Legacy: ' { i_interfase->get_legacy_code( ) }|.
      go_log_application->log( i_msgty = 'S' i_msgtx_flg = 'X' i_msgtx =  message ).

      clear message.
      message =  |'String: ' { i_interfase->get_connection_string( )  } |.
      go_log_application->log( i_msgty = 'S' i_msgtx_flg = 'X' i_msgtx =  message ).

    endif.
  endmethod.


  method insert_log_text_with_code.
    data: msgty         type symsgty.

    if me->is_log_active( ) eq abap_true.


        if i_code eq '200'.
          msgty = 'S'.
        else.
          msgty = 'E'.
        endif.

          go_log_application->log( i_msgty = msgty i_msgtx_flg = 'X' i_msgtx =  i_response ).


    endif.
  endmethod.

  method insert_log_json.
    if me->is_log_active( ) eq abap_true.
      go_log_application->log( i_msgty = 'I' i_msgtx_flg = 'X' i_msgtx =  i_interfase->get_last_json_message( ) ).
    endif.
  endmethod.


  method send_http_request.

*    data:  lr_data      type ref to data.

*    lo_interfase->set_last_json_message( go_scales->serialize( scale_prices ) ).
*    lo_interfase->lo_client->request->set_cdata( go_scales->get_last_json_message( ) ).
*
*    lo_interfase->lo_client->send( ).
*    lo_interfase->lo_client->receive( ).
*    if sy-subrc = 0.
*
*      lo_interfase->lo_client->response->get_status( importing code = data(http_code) ).
*
*      data(ls_response)  = lo_interfase->lo_client->response->get_cdata( ).
*
*      insert_log_interfase_data( lo_interfase ).
*      insert_log_text_with_code( exporting i_code = http_code i_response = ls_response ).
*      insert_log_json( lo_interfase ).
*      write ls_response.
*
*      if http_code eq lo_interfase->ok.
*        lo_interfase->deserialize( exporting i_response = ls_response
*                                   importing e_table    = lr_data ).
*      else.
*      endif.
*      go_scales->lo_client->close( ).
*

  endmethod.

endclass.
