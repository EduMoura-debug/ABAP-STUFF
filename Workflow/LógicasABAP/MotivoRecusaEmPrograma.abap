DATA: ls_note_object           TYPE SWOTOBJID.
DATA: ls_decision_note         TYPE SWRSOBJID.
  
*note 1964571: create note for rejection reason if needed
     IF note_content IS NOT INITIAL AND note_title IS NOT INITIAL.
       CALL FUNCTION 'SWU_INTERN_CREATE_NOTE_OBJECT'
         EXPORTING
           im_title               = note_title
           im_text                = note_content
 *         IM_LANGUAGE            = SY-LANGU
         IMPORTING
           EX_OBJID               = ls_note_object.
       IF sy-subrc <> 0.
         REFRESH lt_message_tab.
         CLEAR ls_message.
         ls_message-msgid = 'SWN'.
         ls_message-msgty = 'S'.
         ls_message-msgno = '178'.
         ls_message-msgv1 = sy-subrc.
         APPEND ls_message TO lt_message_tab.
       ELSE.
         ls_decision_note = ls_note_object.
       ENDIF.
     ENDIF.
 *   execute work item
     CLEAR lt_message_tab[].
     CLEAR l_rc.
     CALL FUNCTION 'SAP_WAPI_DECISION_COMPLETE'
       EXPORTING
         workitem_id    = wi_id
         user           = sy-uname
         decision_key   = ls_decision_alternative-altkey
         do_commit      = 'X'
         decision_note  = ls_decision_note
       IMPORTING
         return_code    = l_rc
       TABLES
         message_struct = lt_message_tab.
*   set own message text