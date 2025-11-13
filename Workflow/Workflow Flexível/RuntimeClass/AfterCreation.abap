Importing	IO_CONTEXT	                    TYPE REF TO IF_SWF_FLEX_RUN_CONTEXT	
Importing	IO_ROOT_COMPONENT	            TYPE REF TO IF_SWF_FLEX_IFS_RUN_BLOCK	
Exception	CX_SWF_FLEX_IFS_RUN_EXCEPTION		

  METHOD if_swf_flex_ifs_run_appl~after_creation_callback.
    
    DATA: v_wi         TYPE sww_wiid,
          lv_event     TYPE hrs1212-event,
          lv_scenario  TYPE REF TO if_swf_flex_ifs_scenario,
          lv_container TYPE REF TO if_swf_ifs_parameter_container,
          re_task      TYPE REF TO if_swf_ifs_parameter_container,
          ls_object    TYPE sibflporb,
          lv_initiator TYPE wfsyst-initiator.

    DATA: lv_WorkflowKey TYPE table-key.

    TRY.
        v_wi         = io_context->get_wi_id( ).
        lv_container = io_context->get_workflow_container( ).
        lv_scenario  = io_context->get_scenario_definition( ).
        re_task      = io_context->get_task_container( ).
        ls_object    = io_context->get_leading_object_reference( ).

        lv_WorkflowKey = ls_object-instid.

        lv_container->get(
          EXPORTING
            name  = '_WF_INITIATOR'
          IMPORTING
            value = lv_initiator ).

          lv_container->set(
           EXPORTING
             name  = 'DATA' "Container Name
             value = lv_data ).


      CATCH: cx_swf_cnt_elem_not_found,
             cx_swf_cnt_elem_type_conflict,
             cx_swf_cnt_unit_type_conflict,
             cx_swf_cnt_container.
    ENDTRY.

* Validation
    IF Condition.

    ENDIF.

  ENDMETHOD.