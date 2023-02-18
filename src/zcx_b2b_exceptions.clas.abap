class zcx_b2b_exceptions definition
  public
  inheriting from cx_static_check
  create public .

  public section.

    constants zcx_b2b_exceptions type sotr_conc value '028C0ED2B5601ED78EB6F3368B1E4F9B' ##NO_TEXT.
    data error type string .
    data syst_at_raise type syst .

    interfaces if_t100_dyn_msg .
    interfaces if_t100_message .

    class-methods:
      s_raise
        raising
          zcx_b2b_exceptions .

    methods:
      get_bapireturn
        returning value(rs_return) type bapiret2.

    class-data: mv_msg_text type string.




    methods constructor
      importing
        !textid        like textid optional
        !previous      like previous optional
        !error         type string optional
        !syst_at_raise type syst optional .
    class-methods raise_text
      importing
        !iv_text type clike
      raising
        zcx_b2b_exceptions .
    class-methods raise_symsg
      raising
        zcx_b2b_exceptions .

    methods if_message~get_longtext
        redefinition .
    methods if_message~get_text
        redefinition .
  protected section.
  private section.
endclass.



class zcx_b2b_exceptions implementation.


  method constructor ##ADT_SUPPRESS_GENERATION.

    call method super->constructor
      exporting
        textid   = textid
        previous = previous.
    if textid is initial.
      me->textid = zcx_b2b_exceptions .
    endif.
    me->error = error .
    me->syst_at_raise = syst_at_raise .
  endmethod.


  method if_message~get_longtext.

    if   me->error         is not initial
      or me->syst_at_raise is not initial.
*--------------------------------------------------------------------*
* If message was supplied explicitly use this as longtext as well
*--------------------------------------------------------------------*
      result = me->get_text( ).
    else.
*--------------------------------------------------------------------*
* otherwise use standard method to derive text
*--------------------------------------------------------------------*
      result = super->if_message~get_longtext( preserve_newlines = preserve_newlines ).
    endif.
  endmethod.


  method if_message~get_text.

    if me->error is not initial.
*--------------------------------------------------------------------*
* If message was supplied explicitly use this
*--------------------------------------------------------------------*
      result = me->error .
    elseif me->syst_at_raise is not initial.
*--------------------------------------------------------------------*
* If message was supplied by syst create messagetext now
*--------------------------------------------------------------------*
      message id syst_at_raise-msgid type syst_at_raise-msgty number syst_at_raise-msgno
           with  syst_at_raise-msgv1 syst_at_raise-msgv2 syst_at_raise-msgv3 syst_at_raise-msgv4
           into  result.
    else.
*--------------------------------------------------------------------*
* otherwise use standard method to derive text
*--------------------------------------------------------------------*
      call method super->if_message~get_text
        receiving
          result = result.
    endif.
  endmethod.


  method raise_symsg.
    raise exception type zcx_b2b_exceptions
      exporting
        syst_at_raise = syst.
  endmethod.


  method raise_text.
    raise exception type zcx_b2b_exceptions
      exporting
        error = iv_text.
  endmethod.


  method get_bapireturn.

    call function 'BALW_BAPIRETURN_GET2'
      exporting
        type   = if_t100_dyn_msg~msgty
        cl     = if_t100_message~t100key-msgid
        number = if_t100_message~t100key-msgno
        par1   = if_t100_dyn_msg~msgv1
        par2   = if_t100_dyn_msg~msgv2
        par3   = if_t100_dyn_msg~msgv3
        par4   = if_t100_dyn_msg~msgv4
      importing
        return = rs_return.

  endmethod.


  method s_raise.

    data(lo_exception) = new zcx_b2b_exceptions(  ).
    lo_exception->if_t100_message~t100key-msgid = sy-msgid.
    lo_exception->if_t100_message~t100key-msgno = sy-msgno.
    lo_exception->if_t100_dyn_msg~msgty         = sy-msgty.
    lo_exception->if_t100_dyn_msg~msgv1         = sy-msgv1.
    lo_exception->if_t100_dyn_msg~msgv2         = sy-msgv2.
    lo_exception->if_t100_dyn_msg~msgv3         = sy-msgv3.
    lo_exception->if_t100_dyn_msg~msgv4         = sy-msgv4.
    raise exception lo_exception.


  endmethod.

endclass.
