*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZSD0131_T.......................................*
DATA:  BEGIN OF STATUS_ZSD0131_T                     .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZSD0131_T                     .
CONTROLS: TCTRL_ZSD0131_T
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZSD0131_T                     .
TABLES: ZSD0131_T                      .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
