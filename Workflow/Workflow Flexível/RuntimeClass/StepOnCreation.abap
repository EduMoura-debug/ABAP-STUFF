Importing	IO_CONTEXT	                    TYPE REF TO IF_SWF_FLEX_RUN_CONTEXT	
Importing	IO_CURRENT_ACTIVITY	            TYPE REF TO IF_SWF_FLEX_IFS_RUN_ACTIVITY	
Exception	CX_SWF_FLEX_IFS_RUN_EXCEPTION		

METHOD if_swf_flex_ifs_run_appl_step~on_creation_callback.

     TYPES:
      BEGIN OF ty_execution_result,
        wi_id          TYPE sww_wiid,
        wi_type        TYPE sww_witype,
        wi_stat        TYPE string,
        wi_dh_stat     TYPE sww_widhst,
        result         TYPE string,
        nature         TYPE string,
        processor      TYPE swhactor,
        creation_tst   TYPE swfrcrets,
        completion_tst TYPE swfrcmpts,
      END OF ty_execution_result .
    TYPES:
      tt_execution_result TYPE STANDARD TABLE OF ty_execution_result WITH DEFAULT KEY .
    TYPES: BEGIN OF ty_multi_inst_agent,
             context TYPE REF TO data,
             agents  TYPE tswhactor,
           END OF ty_multi_inst_agent.
    TYPES: tt_multi_inst_agent TYPE STANDARD TABLE OF ty_multi_inst_agent WITH DEFAULT KEY.

    DATA: re_container      TYPE REF TO if_swf_ifs_parameter_container,
          re_task           TYPE REF TO if_swf_ifs_parameter_container,
          ls_object         TYPE sibflporb,
          ls_bp_object      TYPE sibflporb,
          lv_workitem       TYPE sww_wiid,
          lv_initiator      TYPE wfsyst-initiator,
          lv_step_result    TYPE swd_lines-returncode,
          lv_task_id        TYPE string,
          lv_cancel_trigger TYPE syst-input,
          lv_return         LIKE sy-subrc.

    DATA: lv_agent_rule_id   TYPE string,
          lv_agent_rule_type TYPE string,
          lt_principal       TYPE tswhactor,
          lt_actor_result    TYPE tt_execution_result,
          lt_agents          TYPE tswhactor,
          lt_mult_actor      TYPE tt_multi_inst_agent.

    TRY.

        lv_workitem = io_context->get_wi_id( ).
        re_container = io_context->get_workflow_container( ).
        re_task      = io_context->get_task_container( ).
        ls_object    = io_context->get_leading_object_reference( ).

        io_current_activity->is_assigned_to(
          IMPORTING
            ev_agent_rule_id    = lv_agent_rule_id
            ev_agent_rule_type  = lv_agent_rule_type
            et_principal        = lt_principal ).

        lt_actor_result = io_current_activity->get_execution_results( ).
        lt_agents = io_current_activity->resolve_agents( ).
        lt_mult_actor = io_current_activity->resolve_multi_inst_agents( ).

        lv_task_id  = io_current_activity->get_task_id( ).

      CATCH: cx_swf_cnt_elem_not_found,
             cx_swf_cnt_elem_type_conflict,
             cx_swf_cnt_unit_type_conflict,
             cx_swf_cnt_container.
    ENDTRY.

    IF lv_task_id EQ 'TS99900009'. 

    "Send Approval Request Email

    ENDIF.