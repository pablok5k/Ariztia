*&---------------------------------------------------------------------*
*& Report zsdr0131_productos
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zsdr0131_productos.

INCLUDE zsdi0131_productos_top.
INCLUDE zsdi0131_productos_class.
INCLUDE zsdi0131_productos_impl.
INCLUDE zsdi0131_productos_param.

START-OF-SELECTION.

  TRY.
      DATA(application) = NEW lcl_application( ).

      go_material = NEW #( i_sales_organization = p_vkorg
                         i_interfase_code =  '019'
                         i_legacy = CONV #( 'ADOBE' )
                           r_matnr = s_matnr[]
                           i_date     = p_date ).

      application->active_log( abap_true ).
      application->insert_log_header( ).

      IF p_all EQ abap_true.
        go_material->process_all_product_data( ).
      ELSE.
        go_material->process_product_data_by_date( ).
      ENDIF.

      go_material->get_products( IMPORTING e_products = DATA(products) ).



      IF products IS NOT INITIAL.
        application->prepare_interfaces( go_material ).
        go_material->set_last_json_message( go_material->serialize( products ) ).

        go_material->lo_client->request->set_cdata( go_material->get_last_json_message( ) ).
        application->insert_log_json( go_material ).

        go_material->lo_client->send( timeout = go_material->lo_client->co_timeout_infinite ).
        go_material->lo_client->receive( ).

        go_material->lo_client->response->get_status( IMPORTING code = DATA(lv_code) ).
        DATA(ls_response) = go_material->lo_client->response->get_cdata( ).
        application->insert_log_interfase_data( go_material ).
        application->insert_log_text_with_code( EXPORTING i_code = lv_code i_response = ls_response ).
        WRITE go_material->get_last_json_message( ).
        ULINE.
        WRITE ls_response.

        IF lv_code EQ go_material->ok.
          go_material->deserialize( EXPORTING i_response = ls_response
                                    IMPORTING e_table    = lr_data ).
        ELSE.

        ENDIF.

      ENDIF.
    CATCH zcx_b2b_exceptions INTO DATA(lo_exceptions).
      application->insert_log_error( lo_exceptions->get_text( ) ).
      MESSAGE lo_exceptions->get_text( ) TYPE 'E'.
  ENDTRY.
