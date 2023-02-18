*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZSD0131_SERVICES................................*
DATA:  BEGIN OF STATUS_ZSD0131_SERVICES              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZSD0131_SERVICES              .
CONTROLS: TCTRL_ZSD0131_SERVICES
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZSD0131_SERVICES              .
TABLES: ZSD0131_SERVICES               .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
