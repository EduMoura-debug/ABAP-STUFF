Importing	IO_CONTEXT	                    TYPE REF TO IF_SWF_FLEX_RUN_CONTEXT
Importing	IO_NEXT_ACTIVITY	            TYPE REF TO IF_SWF_FLEX_IFS_RUN_ACTIVITY
Exception	CX_SWF_FLEX_IFS_RUN_EXCEPTION	

METHOD if_swf_flex_ifs_run_appl_step~before_creation_callback.

    DATA: v_wi         TYPE sww_wiid,
          lv_scenario  TYPE REF TO if_swf_flex_ifs_scenario,
          lv_container TYPE REF TO if_swf_ifs_parameter_container,
          re_task      TYPE REF TO if_swf_ifs_parameter_container,
          lv_task_id   TYPE string,
          ls_object    TYPE sibflporb,
          lv_initiator TYPE wfsyst-initiator.

    TRY.
        v_wi         = io_context->get_wi_id( ).
        lv_container = io_context->get_workflow_container( ).
        lv_scenario  = io_context->get_scenario_definition( ).
        re_task      = io_context->get_task_container( ).
        ls_object    = io_context->get_leading_object_reference( ).

        lv_task_id  = io_next_activity->get_task_id( ).

        lv_container->get(
          EXPORTING
            name  = '_WF_INITIATOR'
          IMPORTING
            value = lv_initiator ).

      CATCH: cx_swf_cnt_elem_not_found,
             cx_swf_cnt_elem_type_conflict,
             cx_swf_cnt_unit_type_conflict,
             cx_swf_cnt_container.
    ENDTRY.

    IF lv_task_id EQ 'TS99900009'. "Validation Using Task

    ENDIF.

**TRY.
*CALL METHOD SUPER->IF_SWF_FLEX_IFS_RUN_APPL_STEP~BEFORE_CREATION_CALLBACK
*  EXPORTING
*    IO_CONTEXT       =
*    IO_NEXT_ACTIVITY =
*    .
**  CATCH cx_swf_flex_ifs_run_exception.
**ENDTRY.
  ENDMETHOD.