*&---------------------------------------------------------------------*
*& Include zsdi0131_parametros
*&---------------------------------------------------------------------*


parameters: p_vkorg type vkorg obligatory default 'AC01'.
select-options:
                s_vtweg for knvv-vtweg,
                s_kunnr for knvv-kunnr,
                s_matnr for mara-matnr,
                s_kschl for konv-kschl.

parameters: p_date type datum default sy-datum.


parameters: p_all type char1 as checkbox.
