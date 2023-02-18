*&---------------------------------------------------------------------*
*& Include zsdi0131_productos_param
*&---------------------------------------------------------------------*

parameters: p_vkorg type vkorg obligatory default 'AC01'.
select-options:
                s_matnr for mara-matnr.

parameters: p_date type datum default sy-datum.


parameters: p_all type char1 as checkbox.
