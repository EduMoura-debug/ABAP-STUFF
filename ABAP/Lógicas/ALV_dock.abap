  IF o_dock IS NOT BOUND.
    CREATE OBJECT o_dock
      EXPORTING
        side = o_dock->dock_at_bottom.
*        extension = 2000.
  ENDIF.

  IF o_alv_log IS NOT BOUND.

    TRY.
        CREATE OBJECT o_alv_log
          EXPORTING
            i_parent          = o_dock
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

        s_layout-zebra      = 'X'.
*       s_layout-sel_mode   = 'D'.
        s_layout-numc_total = 'X'.
        s_layout-cwidth_opt = 'X'.
        s_layout-stylefname = 'CELLTAB'.

        s_variant-report    = sy-repid.
        s_variant-username  = sy-uname.

        m_fieldcat '1'  'STATUS'         'GT_LOG' 'Status'             ''  ''    20 'X'.

        o_alv_log->set_table_for_first_display(
          EXPORTING
            is_layout                     = s_layout
            is_variant                    = s_variant
            i_save                        = 'A'
          CHANGING
            it_outtab                     = gt_log
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

      CATCH cx_sy_create_object_error.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDTRY.

  ELSE.

    DATA is_stable TYPE lvc_s_stbl.
    is_stable-row = 'X'.
    is_stable-col = 'X'.

    CALL METHOD o_alv_log->refresh_table_display(
      EXPORTING
        is_stable = is_stable
      EXCEPTIONS
        finished  = 1
        OTHERS    = 2
    ).
    IF sy-subrc <> 0.

    ENDIF.

  ENDIF.