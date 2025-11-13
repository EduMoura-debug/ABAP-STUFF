Importing	IO_CONTEXT	                  TYPE REF TO IF_SWF_FLEX_RUN_CONTEXT	            Context of workflow instance
Importing	IO_RESULT	                  TYPE REF TO IF_SWF_FLEX_RUN_RESULT	            Result of workflow instance
Exporting	EV_OUTCOME	                  TYPE STRING	                                    Workflow outcome
Exporting	EV_DECISION_REASON	          TYPE IF_SWF_FLEX_RUN_RESULT=>TY_DECISION_REASON	Workflow decision reason
Exception	CX_SWF_FLEX_IFS_RUN_EXCEPTION		                                            Exception to interrupt the completion

METHOD if_swf_flex_ifs_run_appl~result_callback.

    DATA: lv_initiator   TYPE wfsyst-initiator,
          lv_step_result TYPE swd_lines-returncode.

    DATA: v_wi         TYPE sww_wiid,
          lv_scenario  TYPE REF TO if_swf_flex_ifs_scenario,
          lv_container TYPE REF TO if_swf_ifs_parameter_container,
          re_task      TYPE REF TO if_swf_ifs_parameter_container,
          ls_object    TYPE sibflporb,
          ls_bp_object TYPE sibflporb,
          lv_act_agent TYPE WFSYST-ACT_AGENT.

    TRY.

        lv_container = io_context->get_workflow_container( ).

        lv_container->get(
          EXPORTING
            name  = '_WF_INITIATOR'
          IMPORTING
            value = lv_initiator ).

        lv_container->get(
          EXPORTING
            name  = 'STEPRESULT'
          IMPORTING
            value = lv_step_result ). "Decision Result

        lv_container->get(
          EXPORTING
            name  = 'APPROVER' "Last Approver
          IMPORTING
            value = lv_act_agent ).

        v_wi         = io_context->get_wi_id( ).
        lv_scenario  = io_context->get_scenario_definition( ).
        re_task      = io_context->get_task_container( ).
        ls_object    = io_context->get_leading_object_reference( ).

        lv_WorkflowKey = ls_object-instid.

      CATCH: cx_swf_cnt_elem_not_found,
             cx_swf_cnt_elem_type_conflict,
             cx_swf_cnt_unit_type_conflict,
             cx_swf_cnt_container.
    ENDTRY.

    IF lv_WorkflowKey IS NOT INITIAL AND lv_step_result EQ '0001'. "Approved


    ENDIF.

**TRY.
*CALL METHOD SUPER->IF_SWF_FLEX_IFS_RUN_APPL~RESULT_CALLBACK
*  EXPORTING
*    IO_CONTEXT         =
*    IO_RESULT          =
**  IMPORTING
**    ev_outcome         =
**    ev_decision_reason =
*    .
**  CATCH cx_swf_flex_ifs_run_exception.
**ENDTRY.
  ENDMETHOD.