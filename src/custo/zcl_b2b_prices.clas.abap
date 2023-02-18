class zcl_b2b_prices definition
  public
    inheriting from zcl_b2b_interfaces
  create public .

  public section.

    types: begin of ty_prices_conditions,
             customer_rut   type stcd1,
             sku            type matnr,
             product_format type char3,
*             price          type p length 10 decimals 0,
*             special_price  type p length 10 decimals 0,
*             box_price      type p length 10 decimals 0,
             price          type char10,
             special_price  type char10,
             box_price      type char10,
             start_date     type char12,
             end_date       type char12,
             promotional    type char5,
           end   of ty_prices_conditions.

    types: begin of ty_prices_scale,
             customer_rut type stcd1,
             sku          type matnr,
             price        type char10,
             qty_min      type char8,
             qty_max      type char8,
             status       type char1,
           end   of ty_prices_scale.

    types: begin  of ty_change_conditions,
             knumh   type konh-knumh,
             kvewe   type konh-kvewe,
             kotabnr type konh-kotabnr,
             kappl   type konh-kappl,
             kschl   type konh-kschl,
             datab   type konh-datab,
             datbi   type konh-datbi,
             kopos   type konp-kopos,
             kzbzg   type konp-kzbzg,
             konms   type konp-konms,
             kbetr   type konp-kbetr,
             kpein   type konp-kpein,
             kmein   type konp-kmein,
             konwa   type konp-konwa,
           end of ty_change_conditions.
    types: tr_knumh type range of knumh,
           tr_kschl type range of kschl.

    types: tt_change_conditions type standard table of ty_change_conditions.
    types: tt_prices_scale type standard table of ty_prices_scale.
    types: tt_t681 type standard table of t681.
    types: tt_prices_conditions type standard table of ty_prices_conditions.

    data: price_date type datum .
    data: scales type tt_prices_scale,
          prices type tt_prices_conditions.

    data: obj_scales type ref to zcl_b2b_scales.

    types:
      range_vkbur type range of vkbur,
      range_vtweg type range of vtweg,
      range_kunnr type range of kunnr,
      range_matnr type range of matnr,
      range_kschl type range of kschl.


    methods constructor
      importing !i_sales_organization type vkorg
                !i_interfase_code     type zed_interfase
                !i_legacy             type zed_legacy_system
                !r_vkbur              type range_vkbur optional
                !r_vtweg              type range_vtweg optional
                !r_kunnr              type range_kunnr optional
                !r_matnr              type range_matnr optional
                !r_kschl              type range_kschl optional
                !date                 type datum  optional
                !lo_scales            type ref to zcl_b2b_scales
      raising
                zcx_b2b_exceptions .

    methods get_db_modify_prices
      importing
                !i_date_until   type cdhdr-udate optional
      returning value(r_result) type sysubrc
      raising
                zcx_b2b_exceptions .


    methods get_prices_tables exporting e_prices_table type tt_prices_conditions
                              raising
                                        zcx_b2b_exceptions.
    methods get_prices_scale  exporting e_prices_table type tt_prices_scale.

    methods get_all_prices
      raising
        zcx_b2b_exceptions.

    methods serialize redefinition.

    methods deserialize redefinition.

  protected section.

  private section.

    constants: type_error type   msgty value 'E'.

    types: tt_zcdssd131_a901 type standard table of zcdssd131_a901,
           tt_zcdssd131_a902 type standard table of zcdssd131_a902.

    data: box_unit type meins.
    data:
      r_vtweg type range_vtweg,
      r_kunnr type range_kunnr,
      r_matnr type range_matnr,
      r_kschl type range_kschl.


    methods set_parameters
      importing
        !r_vtweg type zcl_b2b_prices=>range_vtweg
        !r_kunnr type zcl_b2b_prices=>range_kunnr
        !r_matnr type zcl_b2b_prices=>range_matnr
        !r_kschl type any.

    methods get_changedocument_read_all
      importing
                !i_date_of_change type cdhdr-udate
                !i_date_until     type cdhdr-udate
      exporting
                !e_cdpos_table    type cdpos_tab
                !e_cdhdr_table    type cdhdr_tab
      returning value(r_result)   type sysubrc
      raising
                zcx_b2b_exceptions .

    methods get_box_price
      importing
                !material     type matnr
                !price_unit   type char3
                !currency     type waers
                !base_price   type kbetr_kond
      returning value(result) type char10
      raising
                zcx_b2b_exceptions.

    methods get_change_conditions
      importing
        !cdhdr          type cdhdr_tab
        !ir_range       type tr_kschl
      exporting
        !e_conditions   type tt_change_conditions
        !e_a901         type tt_zcdssd131_a901
        !e_a902         type tt_zcdssd131_a902
      returning
        value(r_result) type sysubrc.

    methods get_db_t681
      importing !i_list       type tt_change_conditions
      exporting !e_t681       type tt_t681
      returning value(result) type sysubrc.

    methods get_list_cond_tables importing !i_list   type tt_change_conditions
                                 exporting !e_tables type tt_change_conditions.

    methods prepare_range_knumh
      importing
        !conditions_table type  tt_change_conditions
        !kotabnr          type kotabnr
      exporting
        !er_range         type tr_knumh.
    methods set_box_unit
      importing
        !i_box_unit type string.

    methods set_price_date
      importing
        !i_date type datum.
    methods get_price_date
      returning
        value(r_result) type datum.

    methods prepare_data changing i_a901 type tt_zcdssd131_a901
                                  i_a902 type tt_zcdssd131_a902
                         raising
                                  zcx_b2b_exceptions.
    methods clear.
    methods set_prices
      importing
        i_prices type tt_prices_conditions.
    methods set_scales
      importing
        i_scales type tt_prices_scale.
endclass.

class zcl_b2b_prices implementation.

  method constructor.
    super->constructor( i_sales_organization = i_sales_organization
                        i_interfase_code     = i_interfase_code
                        i_legacy             = i_legacy ).

    me->set_parameters(
      r_vtweg = r_vtweg
      r_kunnr = r_kunnr
      r_matnr = r_matnr
      r_kschl = r_kschl ).

    me->set_price_date( date ).
    me->set_box_unit( 'CS' ).

    me->clear( ).

    obj_scales = lo_scales.

  endmethod.

  method prepare_data.
    data: ls_prices_conditions type ty_prices_conditions,
          lt_prices_scale      type tt_prices_scale,
          lt_prices_conditions type tt_prices_conditions.

    refresh lt_prices_conditions.
    refresh lt_prices_scale.
    data: ls_prices_scale type ty_prices_scale.

    sort i_a901 by knumh ascending kschl ascending.
    loop at i_a901 assigning field-symbol(<fs_a901>).
      clear ls_prices_conditions.

      ls_prices_scale-customer_rut = ls_prices_conditions-customer_rut = <fs_a901>-customer_rut.
      ls_prices_scale-sku = ls_prices_conditions-sku = <fs_a901>-material.
      ls_prices_conditions-product_format = <fs_a901>-kmein.
      if line_exists( lt_prices_conditions[ sku = <fs_a901>-material customer_rut = <fs_a901>-customer_rut ] ).
        data(index_a901) = line_index( lt_prices_conditions[ sku = <fs_a901>-material customer_rut = <fs_a901>-customer_rut ] ).

        if <fs_a901>-kschl eq 'ZP07'.
          ls_prices_conditions-promotional = 'true'.
          write <fs_a901>-kbetr to ls_prices_conditions-special_price currency <fs_a901>-konwa.
          condense ls_prices_conditions-special_price.
          modify lt_prices_conditions from ls_prices_conditions index index_a901 .

        elseif <fs_a901>-kschl eq 'ZP01'.
          if ls_prices_conditions-price is not initial.
            write <fs_a901>-kbetr to ls_prices_conditions-price currency <fs_a901>-konwa.
            condense ls_prices_conditions-price.
            ls_prices_conditions-box_price = me->get_box_price( exporting material   = ls_prices_conditions-sku
                                                                          price_unit = ls_prices_conditions-product_format
                                                                          base_price = <fs_a901>-kbetr
                                                                          currency   = <fs_a901>-konwa ).
            condense ls_prices_conditions-box_price.
            modify lt_prices_conditions from ls_prices_conditions index index_a901 .
          endif.
        endif.
      else.
        try.
            if <fs_a901>-kschl eq 'ZP07'.
              ls_prices_conditions-promotional = 'true'.
              write <fs_a901>-kbetr to ls_prices_conditions-special_price currency <fs_a901>-konwa.
              condense ls_prices_conditions-special_price.
            elseif <fs_a901>-kschl eq 'ZP01'.
              write <fs_a901>-kbetr to ls_prices_conditions-price currency <fs_a901>-konwa.
              condense ls_prices_conditions-price.
              ls_prices_conditions-promotional = 'false'.
            endif.

            ls_prices_conditions-box_price = me->get_box_price( exporting material   = ls_prices_conditions-sku
                                                                          price_unit = ls_prices_conditions-product_format
                                                                          base_price = <fs_a901>-kbetr
                                                                          currency   = <fs_a901>-konwa ).
            condense ls_prices_conditions-box_price.
          catch zcx_b2b_exceptions.
            clear ls_prices_conditions-box_price.
        endtry.

        write <fs_a901>-start_date to ls_prices_conditions-start_date dd/mm/yyyy.
        replace all occurrences of'.' in ls_prices_conditions-start_date with '-'.
        write <fs_a901>-end_date to ls_prices_conditions-end_date dd/mm/yyyy.
        replace all occurrences of'.' in ls_prices_conditions-end_date with '-'.
        append ls_prices_conditions to lt_prices_conditions.
      endif.


      if <fs_a901>-scale_price  is not initial.
        write <fs_a901>-scale_price to ls_prices_scale-price currency <fs_a901>-konwa.

        ls_prices_scale-qty_min = <fs_a901>-kstbm.
        condense ls_prices_scale-qty_min.
*      ls_prices_scale-qty_max = .
        condense ls_prices_scale-qty_max.
        ls_prices_scale-status = '1'.
        if line_exists( lt_prices_scale[ customer_rut = ls_prices_scale-customer_rut sku  = ls_prices_scale-sku qty_min = ls_prices_scale-qty_min ] ).
          write |' Error escalas: Material: ' { ls_prices_scale-sku  } 'Cliente: ' { ls_prices_scale-customer_rut } 'Escala:' { ls_prices_scale-qty_min } ':' |.
          uline.
        else.
          append ls_prices_scale to lt_prices_scale.
        endif.

      endif.
    endloop.

    sort i_a902 by knumh ascending kschl ascending.
    loop at i_a902 assigning field-symbol(<fs_a902>).
      clear ls_prices_conditions.
      ls_prices_scale-customer_rut = ls_prices_conditions-customer_rut = <fs_a902>-customer_rut.
      ls_prices_scale-sku = ls_prices_conditions-sku = <fs_a902>-material.
      ls_prices_conditions-product_format = <fs_a902>-kmein.

      if line_exists( lt_prices_conditions[ sku = <fs_a902>-material customer_rut = <fs_a902>-customer_rut ] ).
        data(index_a902) = line_index( lt_prices_conditions[ sku = <fs_a902>-material customer_rut = <fs_a902>-customer_rut ] ).

        if <fs_a902>-kschl eq 'ZP07'.
          if ls_prices_conditions-special_price is not initial.
            ls_prices_conditions-promotional = 'true'.
            write <fs_a902>-kbetr to ls_prices_conditions-special_price currency <fs_a902>-konwa.
            condense ls_prices_conditions-special_price .
            modify lt_prices_conditions from ls_prices_conditions index index_a902 .
          endif.
        elseif <fs_a902>-kschl eq 'ZP01'.
          if ls_prices_conditions-price is not initial.
            write <fs_a902>-kbetr to ls_prices_conditions-price currency <fs_a902>-konwa.
            condense ls_prices_conditions-price.
            ls_prices_conditions-box_price = me->get_box_price( exporting material   = ls_prices_conditions-sku
                                                                          price_unit = ls_prices_conditions-product_format
                                                                          base_price = <fs_a902>-kbetr
                                                                          currency   = <fs_a902>-konwa ).

            condense ls_prices_conditions-box_price.
            modify lt_prices_conditions from ls_prices_conditions index index_a902 .
          endif.
        endif.
      else.

        try.
            if <fs_a902>-kschl eq 'ZP07'.
              ls_prices_conditions-promotional = 'true'.
              write <fs_a902>-kbetr to ls_prices_conditions-special_price currency <fs_a902>-konwa.
              condense ls_prices_conditions-special_price .
            elseif <fs_a902>-kschl eq 'ZP01'.
              write <fs_a902>-kbetr to ls_prices_conditions-price currency <fs_a902>-konwa.
              condense ls_prices_conditions-price.
              ls_prices_conditions-promotional = 'false'.
            endif.

            ls_prices_conditions-box_price = me->get_box_price( exporting material   = ls_prices_conditions-sku
                                                                          price_unit = ls_prices_conditions-product_format
                                                                          base_price = <fs_a902>-kbetr
                                                                          currency   = <fs_a902>-konwa ).
            condense ls_prices_conditions-box_price.
          catch zcx_b2b_exceptions.
            clear ls_prices_conditions-box_price.
        endtry.

        write <fs_a902>-start_date to ls_prices_conditions-start_date dd/mm/yyyy.
        replace all occurrences of'.' in ls_prices_conditions-start_date with '-'.
        write <fs_a902>-end_date to ls_prices_conditions-end_date dd/mm/yyyy.
        replace all occurrences of '.' in ls_prices_conditions-end_date with '-'.
        append ls_prices_conditions to lt_prices_conditions.

      endif.
      if <fs_a902>-scale_price  is not initial.
        write <fs_a902>-scale_price to ls_prices_scale-price currency <fs_a902>-konwa.
        condense ls_prices_scale-price.
        ls_prices_scale-qty_min = <fs_a902>-kstbm.
        condense ls_prices_scale-qty_min.
*      ls_prices_scale-qty_max = .
        condense ls_prices_scale-qty_max.
        ls_prices_scale-status = '1'.

        if line_exists( lt_prices_scale[ customer_rut = ls_prices_scale-customer_rut sku  = ls_prices_scale-sku qty_min = ls_prices_scale-qty_min ] ).

          write |' Error escalas: Material: ' { ls_prices_scale-sku  } 'Cliente: ' { ls_prices_scale-customer_rut } 'Escala:' { ls_prices_scale-qty_min }  ':' |.
          uline.
        else.
          append ls_prices_scale to lt_prices_scale.
        endif.
      endif.
    endloop.

    if lt_prices_conditions is not initial.
      set_prices( lt_prices_conditions ).
    endif.

    if lt_prices_scale is not initial.
      set_scales( lt_prices_scale ).
    endif.
  endmethod.


  method set_parameters.

    me->r_vtweg = r_vtweg.
    me->r_kunnr = r_kunnr.
    me->r_matnr = r_matnr.
    me->r_kschl = r_kschl.

  endmethod.

  method get_db_modify_prices.

    data: lt_cdhdr type cdhdr_tab,
          lt_cdpos type cdpos_tab.
    data error_message type string.
    data r_conditionstob2b type range of kschl.
    data lt_conditions type me->tt_change_conditions.


    refresh: lt_cdhdr, lt_cdpos.

    zcl_tvarvc=>get_range( exporting iv_name  = 'ZSD0131_CONDITIONSTOB2B'
                           importing er_range = r_conditionstob2b ).
    if r_conditionstob2b is initial.

      error_message = 'Tabla TVARVC no contiene clase de condición'(001).
      zcx_b2b_exceptions=>raise_text( error_message ).
    endif.
    try.
        data(result_read_all) = me->get_changedocument_read_all( exporting i_date_of_change = me->get_price_date( )
                                                                           i_date_until     = i_date_until
                                                                 importing e_cdpos_table    = lt_cdpos
                                                                           e_cdhdr_table    = lt_cdhdr ).
        if result_read_all eq 0.

          data: lt_a901 type tt_zcdssd131_a901,
                lt_a902 type tt_zcdssd131_a902.

          data(result_read_conditions) = me->get_change_conditions( exporting cdhdr        = lt_cdhdr
                                                                              ir_range     = r_conditionstob2b
                                                                    importing e_conditions = lt_conditions
                                                                              e_a901       = lt_a901
                                                                              e_a902       = lt_a902 ).
          if result_read_conditions eq 0.
            if lt_a901 is not initial or lt_a902 is not initial.
              me->prepare_data( changing i_a901 = lt_a901
                                         i_a902 = lt_a902 ).
            else.

              error_message = 'No se encontraron datos'(004).
              zcx_b2b_exceptions=>raise_text( error_message ).
            endif.
          endif.
        endif.


      catch  zcx_b2b_exceptions into data(lo_exceptions).
        zcx_b2b_exceptions=>raise_text( conv #( lo_exceptions->get_text( ) ) ).
    endtry.
  endmethod.

  method get_changedocument_read_all.
    data: objectclas    type cdobjectcl value 'COND_A',
          date_until    type cdhdr-udate,
          error_message type string.

    if i_date_until is initial.
      date_until = 99991231.
    else.
      date_until = i_date_until.
    endif.
    call function 'CHANGEDOCUMENT_READ_ALL'
      exporting
        i_objectclass              = objectclas
        i_date_of_change           = i_date_of_change
*       i_time_of_change           = '000000'
        i_date_until               = date_until
      importing
        et_cdpos                   = e_cdpos_table
      changing
        ct_cdhdr                   = e_cdhdr_table
      exceptions
        missing_input_objectclass  = 1
        missing_input_header       = 2
        no_position_found          = 3
        wrong_access_to_archive    = 4
        time_zone_conversion_error = 5
        read_too_many_entries      = 6
        others                     = 7.
    if sy-subrc <> 0 and sy-subrc <> 3.
      error_message = 'CHANGEDOCUMENT_READ_ALL read error'(002).
      zcx_b2b_exceptions=>raise_text( error_message ).
    else.

    endif.

    r_result = sy-subrc.
  endmethod.


  method get_prices_tables.
    data error_message type string.
    if prices is initial.
      error_message = 'No se encontraron datos'(004).
      zcx_b2b_exceptions=>raise_text( error_message ).
    else.
      e_prices_table = prices.
    endif.
  endmethod.


  method get_box_price.

    data: box_quantity         type p length 10 decimals 2,
          error_message        type string,
          price_unit_converted type meins.

    if price_unit ne me->box_unit.
      data(lo_converter) = new cl_frml_calc_conv(  ).

      call function 'CONVERSION_EXIT_CUNIT_INPUT'
        exporting
          input          = price_unit
*         language       = sy-langu
        importing
          output         = price_unit_converted
        exceptions
          unit_not_found = 1
          others         = 2.
      if sy-subrc eq 0.

        lo_converter->material_conversion(
          exporting
            i_matnr        = material
            i_source_value = 1
            i_source_unit  = me->box_unit
            i_target_unit  = price_unit_converted
          importing
            e_target_value = data(box_quantity_float)
            et_msg         = data(et_msg)
        ).

        if line_exists( et_msg[ msgty = me->type_error ] ).
          clear result.
        endif.

        lo_converter->conv_float_quan_single(
          exporting
            i_flt        = box_quantity_float
            i_dec_places = 3
*           i_fieldname  =
          importing
            e_quan       = box_quantity
*           et_msg       =
*           e_factor     =
        ).
        if line_exists( et_msg[ msgty = me->type_error ] ).

          clear result.
          error_message = 'Error al convertir unidades'(003).
          write error_message.
          write |'Unidad Origen: ' { me->box_unit  } 'Unidad Destino: ' { price_unit_converted } 'Material:'{ material }|.
*          zcx_b2b_exceptions=>raise_text( error_message ).
        else.
          data(box_price) = box_quantity *  base_price.
          write box_price to result currency currency.
        endif.

      else.

        if price_unit eq 'CS' or price_unit eq 'CV' or price_unit eq 'CJ'.
          result = base_price.
        else.
          clear result.
        endif.
      endif.
    else.
      result = base_price.
    endif.

  endmethod.


  method get_all_prices.
    data: r_conditionstob2b type range of kschl,
          error_message     type string.

    field-symbols: <lt_rec>   type standard table,
                   <lv_field> type any,
                   <lv_knumh> type knumh.

    zcl_tvarvc=>get_range( exporting iv_name  = 'ZSD0131_CONDITIONSTOB2B'
                           importing er_range = r_conditionstob2b ).
    if r_conditionstob2b is initial.

      error_message = 'Tabla TVARVC no contiene clase de condición'(001).
      zcx_b2b_exceptions=>raise_text( error_message ).
    endif.


    data(price_date) = me->get_price_date( ).
    data(sales_organization) = me->get_sales_organization( ).
    select * from zcdssd131_a901( p_date  = @price_date )
                                 into table @data(lt_a901) where vkorg = @sales_organization
                                                           and vtweg in @r_vtweg
                                                           and material in @r_matnr
                                                           and customer in @r_kunnr
                                                           and kschl in @r_conditionstob2b.

    select * from zcdssd131_a902( p_date  = @price_date )
                                 into table @data(lt_a902) where vkorg = @sales_organization
                                                           and vtweg in @r_vtweg
                                                           and material in @r_matnr
                                                           and customer in @r_kunnr
                                                           and kschl in @r_conditionstob2b.


    if lt_a901 is not initial or lt_a902 is not initial.
      me->prepare_data( changing i_a901 = lt_a901
                                 i_a902 = lt_a902 ).
    else.

      error_message = 'No se encontraron datos'(004).
      zcx_b2b_exceptions=>raise_text( error_message ).
    endif.

  endmethod.


  method get_change_conditions.

    data(price_date) = me->get_price_date( ).
    data(sales_organization) = me->get_sales_organization( ).
    select * into table @e_a901  from zcdssd131_a901( p_date  = @price_date )
                                  for all entries in @cdhdr
                                  where vkorg = @sales_organization
                                  and knumh = @cdhdr-objectid+0(10)
                                  and material in @r_matnr
                                  and customer in @r_kunnr
                                  and kschl in @ir_range.

    select * into table @e_a902  from zcdssd131_a902( p_date  = @price_date )
                                  for all entries in @cdhdr
                                  where vkorg = @sales_organization
                                  and knumh = @cdhdr-objectid+0(10)
                                  and vtweg in @r_vtweg
                                  and material in @r_matnr
                                  and customer in @r_kunnr
                                  and kschl in @ir_range.

  endmethod.


  method get_db_t681.
    select * from t685 into table @data(lt_t685) for all entries in @i_list
                                                 where kvewe = @i_list-kvewe
                                                 and   kappl = @i_list-kappl
                                                 and   kschl = @i_list-kschl.
    if sy-subrc eq 0.
      select * from t681
                       into table e_t681
                       for all entries in i_list
                       where kvewe   eq i_list-kvewe
                       and kotabnr eq i_list-kotabnr.

    endif.
    result = sy-subrc.
  endmethod.


  method get_list_cond_tables.
    e_tables = i_list.
    sort e_tables by kvewe kotabnr kappl kschl.
    delete adjacent duplicates from e_tables comparing kvewe kotabnr kappl kschl.
  endmethod.


  method prepare_range_knumh.
    data: ls_range_knumh type line of tr_knumh.

    clear ls_range_knumh.
    refresh er_range.
    ls_range_knumh-sign = 'I'.
    ls_range_knumh-option = 'EQ'.
    loop at conditions_table into data(ls_conditions)
                                 where  kotabnr = kotabnr.
      ls_range_knumh-low = ls_conditions-knumh.
      append ls_range_knumh to er_range.
    endloop.
  endmethod.


  method set_box_unit.
    me->box_unit = i_box_unit.
  endmethod.



  method set_price_date.
    me->price_date = i_date.
  endmethod.

  method get_price_date.
    r_result = me->price_date.
  endmethod.

  method serialize.
    result = /ui2/cl_json=>serialize(
      name             = 'prices'
      data             = i_table
      pretty_name      = /ui2/cl_json=>pretty_mode-low_case
      assoc_arrays_opt = abap_true ).
*    concatenate '{ ' result ' }' into result.
    concatenate me->json_token_object_start ' ' result ' ' json_token_object_end into result.
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


  method get_prices_scale.
    e_prices_table = scales.
  endmethod.

  method clear.

    refresh scales.
    refresh prices.

  endmethod.


  method set_prices.

    me->prices = i_prices.
  endmethod.


  method set_scales.
    obj_scales->set_scales( i_scales ).
  endmethod.

endclass.
