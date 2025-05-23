
REPORT zalv_fast_report.


DATA:
  gt_table TYPE STANDARD TABLE OF ztable, 
  go_alv     TYPE REF TO cl_salv_table. 


SELECT *
  FROM ztable
  INTO TABLE gt_table.

TRY .
    cl_salv_table=>factory(
      IMPORTING
        r_salv_table = go_alv
      CHANGING
        t_table      = gt_table
    ).

  CATCH cx_salv_msg.
    WRITE: / 'ALV erro'.
ENDTRY.

go_alv->set_screen_status( pfstatus = 'ZSTANDARD' "PF-STATUS
                             report = sy-repid
                      set_functions = go_alv->c_functions_all ).

go_alv->display( ).