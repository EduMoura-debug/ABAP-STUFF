CLASS cl_event_receiver DEFINITION.

  PUBLIC SECTION.

    METHODS:
      handle_double_click
                    FOR EVENT double_click OF cl_gui_alv_grid
        IMPORTING e_row e_column.

ENDCLASS.

CLASS cl_event_receiver IMPLEMENTATION.

  METHOD handle_double_click.



  ENDMETHOD.

ENDCLASS.

DATA: event_receiver TYPE REF TO cl_event_receiver.

CREATE OBJECT event_receiver.
SET HANDLER event_receiver->handle_double_click FOR go_superior.