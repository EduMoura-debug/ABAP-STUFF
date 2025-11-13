* End Current Workflow
      CALL FUNCTION 'SWP_WORKFLOW_ITEM_CANCEL'
        EXPORTING
          wi_id                     = v_wi
          wf_id                     = v_wi
          do_commit                 = 'X'
        EXCEPTIONS
          wi_header_read_failed     = 1
          wi_status_change_failed   = 2
          wi_find_dependents_failed = 3
          OTHERS                    = 4.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.

      APPEND INITIAL LINE TO lw_return ASSIGNING FIELD-SYMBOL(<fs_ret>).
      <fs_ret>-type    = 'E'.
      <fs_ret>-message = 'Workflow canceled.'.

    "Set return container if in runtime  
      lv_container->set(
            EXPORTING
              name  = 'BAPI_RETURN'
              value =  lw_return ).
      
      RAISE EXCEPTION TYPE cx_swf_flex_ifs_run_exception.