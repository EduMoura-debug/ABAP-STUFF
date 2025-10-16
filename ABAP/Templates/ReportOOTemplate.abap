*&---------------------------------------------------------------------*
*& Include          ZFI_XXXXXXXX_TOP
*&---------------------------------------------------------------------*
*-------------------TABLES--------------------*
TABLES: ztable.

*-------------------TYPES---------------------*
TYPES: BEGIN OF ty_table.
         INCLUDE STRUCTURE ztable.
TYPES:   celltab TYPE lvc_t_styl,
       END OF ty_table.

*---------------GLOBAL VARIABLES---------------*
DATA: lt_table TYPE TABLE OF ty_table,
      ls_table TYPE ty_table.

FIELD-SYMBOLS: <fs_cognos_output> TYPE ty_table.

*---------------------ALV---------------------*
CLASS cl_event DEFINITION DEFERRED.
DATA: o_alv            TYPE REF TO cl_gui_alv_grid,
      o_event_receiver TYPE REF TO cl_event,

      t_filter         TYPE lvc_t_filt,
      s_filter         TYPE lvc_s_filt.

DATA: it_fcat TYPE lvc_t_fcat,
      wa_fcat TYPE lvc_s_fcat.

DATA: ls_layout TYPE lvc_s_layo.

DATA: ls_cell TYPE lvc_s_styl.

*--------------------MACRO-------------=------*
DEFINE m_fieldcat.
  wa_fcat-col_pos   = &1.
  wa_fcat-fieldname = &2.
  wa_fcat-tabname   = &3.
  wa_fcat-reptext   = &4.
  wa_fcat-key       = &5.
  wa_fcat-edit      = &6.
  wa_fcat-outputlen = &7.
  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.
END-OF-DEFINITION.


*----------------SELECTION SCREEN-------------*
SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-001.

*Select Values

SELECTION-SCREEN END OF BLOCK b01.


START-OF-SELECTION.

  PERFORM zf_select_data.
  PERFORM zf_build_output.

  CALL SCREEN 1001.

*----------------------------------------------------------------------*
***INCLUDE ZFI_XXXXXXX_PBO.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_1001 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_1001 OUTPUT.
 SET PF-STATUS 'ZSTATUS'.
* SET TITLEBAR 'xxx'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module DISPLAY_ALV OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE display_alv OUTPUT.

PERFORM zf_display_alv.

ENDMODULE.
*----------------------------------------------------------------------*
***INCLUDE ZFI_XXXXXXX_PAI.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_1001  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_1001 INPUT.

  DATA: lt_index_rows TYPE lvc_t_row,
        lt_row_no     TYPE lvc_t_roid.

  o_alv->check_changed_data( ).

  o_alv->get_selected_rows(
    IMPORTING
      et_index_rows	= lt_index_rows
      et_row_no	    = lt_row_no    ).

  CASE sy-ucomm.

    WHEN 'BACK' OR 'EXIT' OR 'FINISH'.

      LEAVE TO SCREEN 0.

    WHEN OTHERS.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Include          ZFI_XXXXXXXX_CLS
*&---------------------------------------------------------------------*
CLASS cl_event DEFINITION .

  PUBLIC SECTION.
    METHODS: toolbar FOR EVENT toolbar OF cl_gui_alv_grid
      IMPORTING e_object,

      user_command FOR EVENT user_command OF cl_gui_alv_grid
        IMPORTING e_ucomm.

    METHODS:handle_hotspot_click
                  FOR EVENT hotspot_click OF cl_gui_alv_grid
      IMPORTING e_row_id e_column_id.

    METHODS: handle_user_command
                  FOR EVENT user_command OF cl_gui_alv_grid
      IMPORTING e_ucomm.

ENDCLASS.

CLASS cl_event IMPLEMENTATION.

  METHOD toolbar.

    DATA: ls_toolbar TYPE stb_button.

    DELETE e_object->mt_toolbar
    WHERE function = '&LOCAL&CUT' OR function = '&LOCAL&COPY' OR function = '&LOCAL&PASTE'
       OR function = '&LOCAL&APPEND' OR function = '&LOCAL&INSERT_ROW'
       OR function = '&LOCAL&DELETE_ROW' OR function = '&LOCAL&COPY_ROW' .

  ENDMETHOD.

  METHOD user_command.

  ENDMETHOD.

  METHOD handle_hotspot_click.

  ENDMETHOD.

  METHOD handle_user_command.

  ENDMETHOD.

ENDCLASS.
*&---------------------------------------------------------------------*
*& Include          ZFI_XXXXXXXXXX_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& zf_select_data.
*&---------------------------------------------------------------------*
FORM zf_select_data.


ENDFORM.
*&---------------------------------------------------------------------*
*& zf_build_output.
*&---------------------------------------------------------------------*
FORM zf_build_output.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form zf_display_alv.
*&---------------------------------------------------------------------*
FORM zf_display_alv.

  DATA: lc_custom_control_name TYPE scrfname VALUE 'ALV_001',
        lr_ccontainer1         TYPE REF TO cl_gui_custom_container.

  IF o_alv IS NOT BOUND.

    CREATE OBJECT lr_ccontainer1
      EXPORTING
        container_name              = lc_custom_control_name
        repid                       = sy-repid
        dynnr                       = sy-dynnr
      EXCEPTIONS
        cntl_error                  = 1
        cntl_system_error           = 2
        create_error                = 3
        lifetime_error              = 4
        lifetime_dynpro_dynpro_link = 5
        OTHERS                      = 6.

    TRY.
        CREATE OBJECT o_alv
          EXPORTING
            i_parent          = lr_ccontainer1 "cl_gui_custom_container( container_name = 'CC_ALV_CONTROL' )
          EXCEPTIONS
            error_cntl_create = 1                " Error when creating the control
            error_cntl_init   = 2                " Error While Initializing Control
            error_cntl_link   = 3                " Error While Linking Control
            error_dp_create   = 4                " Error While Creating DataProvider Control
            OTHERS            = 5.
        IF sy-subrc <> 0.
          MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
        ENDIF.

        DATA(w_layout) = VALUE lvc_s_layo( zebra      = 'X'
*                                           sel_mode   = 'D'
                                           numc_total = 'X'
                                           cwidth_opt = 'X'
                                           stylefname = 'CELLTAB' ).

        DATA(w_variant) = VALUE disvariant( report    = sy-repid
                                            username  = sy-uname ).

        PERFORM f_set_events.
        PERFORM f_set_fieldcat.

        o_alv->set_table_for_first_display(
          EXPORTING
            is_layout                     = w_layout
            is_variant                    = w_variant
            i_save                        = 'A'
            is_print                      = VALUE lvc_s_prnt( no_colwopt = 'X' )
          CHANGING
            it_outtab                     = lt_table
            it_fieldcatalog               = it_fcat
          EXCEPTIONS
            invalid_parameter_combination = 1
            program_error                 = 2
            too_many_lines                = 3
            OTHERS                        = 4 ).
        IF sy-subrc IS NOT INITIAL.
          MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
        ENDIF.

      CATCH cx_sy_create_object_error INTO DATA(w_exp).
        MESSAGE w_exp->get_longtext( ) TYPE 'E'.
    ENDTRY.

  ELSE.

    DATA is_stable TYPE lvc_s_stbl.
    is_stable-row = 'X'.
    is_stable-col = 'X'.

    CALL METHOD o_alv->refresh_table_display(
      EXPORTING
        is_stable = is_stable
      EXCEPTIONS
        finished  = 1
        OTHERS    = 2
    ).
    IF sy-subrc <> 0.

    ENDIF.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_set_events
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_set_events.

  CREATE OBJECT o_event_receiver.

  SET HANDLER o_event_receiver->toolbar              FOR o_alv.
  SET HANDLER o_event_receiver->user_command         FOR o_alv.
  SET HANDLER o_event_receiver->handle_user_command  FOR o_alv.
  SET HANDLER o_event_receiver->handle_hotspot_click FOR o_alv.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_set_fieldcat
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_set_fieldcat .

  TRY.
      cl_salv_table=>factory( IMPORTING r_salv_table = DATA(o_salv)
                              CHANGING  t_table      = gt_saida  )."table

      gt_fieldcat    = cl_salv_controller_metadata=>get_lvc_fieldcatalog( r_columns     = o_salv->get_columns( )
                                                                         r_aggregations = o_salv->get_aggregations( ) ).
    CATCH cx_salv_msg.
      CLEAR o_salv.
  ENDTRY.
  IF o_salv IS BOUND.
    FREE o_salv.
  ENDIF.

* m_fieldcat '#1' 'Fieldname' 'Tabname' 'Description'    'Key'  'Edit'    25.

ENDFORM.
