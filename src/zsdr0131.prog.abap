*&---------------------------------------------------------------------*
*& Report zsdr0131
*&---------------------------------------------------------------------*
* PROGRAMA:        ZSDR0131
* TRANSACCIÓN:     ZSD0131
* FECHA CREACION:  10.01.2023
* MODULO SAP:      SD
* ID GAP:
* AUTOR:           Consultor Softtek
* TITULO:          ENVIO DE PRECIOS A B2B
************************************************************************
* DESCRIPCION:     Programa que envia informacion de precios a sistemas legados
************************************************************************
report zsdr0131.

include zsdi0131_top.
include zsdi0131_class.
include zsdi0131_impl.
include zsdi0131_parametros.

start-of-selection.

  try.

      data(application) = new lcl_application( ).

      go_scales = new #( i_sales_organization = p_vkorg
*                         i_interfase_code =  '015'
                         i_interfase_code =  '038'
                         i_legacy = conv #( 'ADOBE' ) ).


      go_prices = new #( i_sales_organization = p_vkorg
*                         i_interfase_code =  '006'
                         i_interfase_code =  '029'
                         i_legacy = conv #( 'ADOBE' )
                           r_vtweg = s_vtweg[]
                           r_kunnr = s_kunnr[]
                           r_matnr = s_matnr[]
                           r_kschl = s_kschl[]
                           date     = p_date
                           lo_scales = go_scales  ).

      application->active_log( abap_true ).
      application->insert_log_header( ).

      if p_all eq abap_true.
        go_prices->get_all_prices( ).
      else.
        go_prices->get_db_modify_prices( ).
      endif.

      go_prices->get_prices_tables(
        importing
          e_prices_table = data(prices_table) ).

      application->prepare_interfaces( go_prices ).

      go_prices->set_last_json_message( go_prices->serialize( prices_table ) ).
      go_prices->lo_client->request->set_cdata( go_prices->get_last_json_message( ) ).
      application->insert_log_json( go_prices ).

      go_prices->lo_client->send( timeout = go_prices->lo_client->co_timeout_infinite ).
      go_prices->lo_client->receive( ).

      if sy-subrc = 0.

        go_prices->lo_client->response->get_status( importing code = data(lv_code) ).

        data(ls_response) = go_prices->lo_client->response->get_cdata( ).

        application->insert_log_interfase_data( go_prices ).
        application->insert_log_text_with_code( exporting i_code = lv_code i_response = ls_response ).
        write go_prices->get_last_json_message( ).
        uline.
        write ls_response.
        uline.


        if lv_code eq go_prices->ok.
          go_prices->deserialize( exporting i_response = ls_response
                                  importing e_table    = lr_data ).
          go_prices->obj_scales->get_scales( importing e_scales = data(scale_prices) ).
          if scale_prices is not initial.
            go_scales->set_last_json_message( go_scales->serialize( scale_prices ) ).
            go_scales->lo_client->request->set_cdata( go_scales->get_last_json_message( ) ).

            go_scales->lo_client->send( ).
            go_scales->lo_client->receive( ).
            if sy-subrc = 0.
*
              go_scales->lo_client->response->get_status( importing code = lv_code ).

              ls_response = go_scales->lo_client->response->get_cdata( ).

*              application->insert_log_interfase_data( go_scales ).
              application->insert_log_text_with_code( exporting i_code = lv_code i_response = ls_response ).
*              application->insert_log_json( go_scales ).
              write go_scales->get_last_json_message( ).
              uline.
              write ls_response.
              uline.

              if lv_code eq go_scales->ok.
                go_scales->deserialize( exporting i_response = ls_response
                                        importing e_table    = lr_data ).
              else.
              endif.
              go_scales->lo_client->close( ).
            endif.
          endif.
        else.
        endif.
        go_prices->lo_client->close( ).
      endif.

      if sy-subrc is not initial.
* Handle errors
      endif.
    catch zcx_b2b_exceptions into data(lo_exceptions).
      application->insert_log_error( lo_exceptions->get_text( ) ).
      message lo_exceptions->get_text( ) type 'E'.
  endtry.
