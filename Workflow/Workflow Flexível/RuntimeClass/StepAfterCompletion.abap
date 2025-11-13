Importing	IO_CONTEXT	                TYPE REF TO IF_SWF_FLEX_RUN_CONTEXT
Importing	IO_CURRENT_ACTIVITY	        TYPE REF TO IF_SWF_FLEX_IFS_RUN_ACTIVITY
Importing	IV_DEFAULT_ADHOC_STEP_ID	TYPE STRING
Importing	IV_DEFAULT_ACTION	        TYPE STRING
Exporting	EV_ACTION	                TYPE STRING
Exporting	EV_ACTION_PARAM	            TYPE STRING
Exception	CX_SWF_FLEX_IFS_RUN_EXCEPTION	

METHOD if_swf_flex_ifs_run_appl_step~after_completion_callback.

    DATA: re_container   TYPE REF TO if_swf_ifs_parameter_container,
          re_task        TYPE REF TO if_swf_ifs_parameter_container,
          ls_object      TYPE sibflporb,
          ls_bp_object   TYPE sibflporb,
          lv_workitem    TYPE sww_wiid,
          lv_initiator   TYPE wfsyst-initiator,
          lv_step_result TYPE swd_lines-returncode,
          lv_task_id     TYPE string,
          lv_act_agent   TYPE WFSYST-ACT_AGENT.

    DATA: lv_agent_rule_id   TYPE  string,
          lv_agent_rule_type TYPE  string,
          lt_principal       TYPE  tswhactor.

    TRY.

        re_container = io_context->get_workflow_container( ).
        lv_workitem = io_context->get_wi_id( ).
        re_task      = io_context->get_task_container( ).
        ls_object    = io_context->get_leading_object_reference( ).

        io_current_activity->is_assigned_to(
        IMPORTING
            ev_agent_rule_id    = lv_agent_rule_id
            ev_agent_rule_type  = lv_agent_rule_type
            et_principal        = lt_principal ).

        lv_task_id = io_current_activity->get_task_id( ).

        re_container->get(
          EXPORTING
            name  = '_WF_INITIATOR'
          IMPORTING
            value = lv_initiator ).

        re_container->get(
          EXPORTING
            name  = 'STEPRESULT'
          IMPORTING
            value = lv_step_result ).

        re_container->get(
          EXPORTING
            name  = 'LASTAPPROVER'
          IMPORTING
            value = lv_act_agent ).


      CATCH: cx_swf_cnt_elem_not_found,
             cx_swf_cnt_elem_type_conflict,
             cx_swf_cnt_unit_type_conflict,
             cx_swf_cnt_container.
    ENDTRY.

    IF lv_task_id EQ 'TS99900009'.

      CASE lv_step_result.
        WHEN '0001'. " Approved

        WHEN '0002'. " Rejected

        WHEN '0003'. "Third option

        WHEN OTHERS.
      ENDCASE.

    ELSEIF lv_task_id EQ 'TS99900010'. "Review Task


    ELSEIF lv_task_id EQ 'TS99900011'. "Automatic 


    ENDIF.

**TRY.
*CALL METHOD SUPER->IF_SWF_FLEX_IFS_RUN_APPL_STEP~AFTER_COMPLETION_CALLBACK
*  EXPORTING
*    IO_CONTEXT               =
*    IO_CURRENT_ACTIVITY      =
*    IV_DEFAULT_ADHOC_STEP_ID =
*    IV_DEFAULT_ACTION        =
**  IMPORTING
**    ev_action                =
**    ev_action_param          =
*    .
**  CATCH cx_swf_flex_ifs_run_exception.
**ENDTRY.
ENDMETHOD.