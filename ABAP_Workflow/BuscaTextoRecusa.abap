DATA: return_code              LIKE sy-subrc,
      ifs_xml_container        TYPE xstring,
      ifs_xml_container_schema TYPE xstring,
      simple_container         TYPE TABLE OF  swr_cont,
      message_lines            TYPE TABLE OF  swr_messag,
      message_struct           TYPE TABLE OF  swr_mstruc,
      subcontainer_bor_objects TYPE TABLE OF  swr_cont,
      it_all_objects           TYPE TABLE OF  swr_cont,
      lwa_reason               TYPE swr_cont,

      document_id              TYPE sofolenti1-doc_id,
      object_content           TYPE TABLE OF solisti1,

      reason_txt               TYPE TABLE OF solisti1,
      s_reason_txt             TYPE solisti1.

CALL FUNCTION 'SAP_WAPI_READ_CONTAINER'
  EXPORTING
    workitem_id              = workid
    language                 = sy-langu
    user                     = sy-uname
  IMPORTING
    return_code              = return_code
    ifs_xml_container        = ifs_xml_container
    ifs_xml_container_schema = ifs_xml_container_schema
  TABLES
    simple_container         = simple_container
    message_lines            = message_lines
    message_struct           = message_struct
    subcontainer_bor_objects = subcontainer_bor_objects
    subcontainer_all_objects = it_all_objects.

IF return_code = 0 AND it_all_objects[] IS NOT INITIAL.

  LOOP AT it_all_objects INTO lwa_reason
                         WHERE element = '_ATTACH_OBJECTS'..

    document_id = lwa_reason-value.
  ENDLOOP.

ENDIF.

*--to read attachments

IF document_id IS NOT INITIAL.

  CALL FUNCTION 'SO_DOCUMENT_READ_API1'
    EXPORTING
      document_id                = document_id
    TABLES
      object_content             = object_content
    EXCEPTIONS
      document_id_not_exist      = 1
      operation_no_authorization = 2
      x_error                    = 3
      OTHERS                     = 4.

  IF sy-subrc = 0.
    LOOP AT object_content INTO DATA(s_content)." INTO reason_text.
      CLEAR s_reason_txt.
*      SHIFT s_content LEFT BY 5 PLACES.
      s_reason_txt = s_content.
      APPEND s_reason_txt TO justificativa.
    ENDLOOP.
  ENDIF.
ENDIF.