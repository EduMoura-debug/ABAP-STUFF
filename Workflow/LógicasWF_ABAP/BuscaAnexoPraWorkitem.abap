
DATA: l_objectid TYPE bapiborid,
      lt_relat   TYPE TABLE OF bapirellk WITH HEADER LINE,
      l_objdisp  TYPE sood2,
      lt_objcont TYPE TABLE OF soli.

PARAMETERS: p_ebeln       LIKE ekko-ebeln,
            p_workitem_id LIKE SWWWIHEAD-wi_id.

START-OF-SELECTION.

  l_objectid-objkey = p_ebeln.
  l_objectid-objtype = 'BUS2012'.

  CALL FUNCTION 'BAPI_REL_GETRELATIONS'
    EXPORTING
      objectid        = l_objectid
    TABLES
      listofrelations = lt_relat[].

  BREAK-POINT.

  DATA: document_id TYPE sofolenti1-doc_id.

  DATA: document_data TYPE sofolenti1.

  DATA:
    object_header   TYPE TABLE OF solisti1 ,
    object_content  TYPE TABLE OF solisti1 ,
    object_para     TYPE TABLE OF soparai1 ,
    object_parb     TYPE TABLE OF soparbi1 ,
    attachment_list TYPE TABLE OF soattlsti1,
    receiver_list   TYPE TABLE OF soreclsti1,
    contents_hex    TYPE TABLE OF solix .

  DATA: text         TYPE string.
  DATA: buffer       TYPE xstring.
  DATA: input_length TYPE i.
  DATA: t_lines       TYPE STANDARD TABLE OF solisti1.

  DATA   workitem_id TYPE swr_struct-workitemid.
  DATA   header      TYPE swr_att_header.
  DATA   att_bin     TYPE xstring.
  DATA   return_code TYPE sy-subrc.
  DATA   att_id      TYPE swr_att_id.
  DATA   lt_att_atuais TYPE TABLE OF swr_object.

  workitem_id = p_workitem_id.

  LOOP AT lt_relat.

    REFRESH lt_objcont.

    REFRESH: object_header,
             object_content,
             object_para,
             object_parb,
             attachment_list,
             receiver_list,
             contents_hex,
             lt_att_atuais.

    IF lt_relat-reltype = 'PNOT'.
      document_id = lt_relat-objkey_b+12.
    ELSE.
      document_id = lt_relat-objkey_b.
    ENDIF.

    CALL FUNCTION 'SO_DOCUMENT_READ_API1'
      EXPORTING
        document_id                = document_id
*       filter                     = filter
      IMPORTING
        document_data              = document_data
      TABLES
        object_header              = object_header
        object_content             = object_content
        object_para                = object_para
        object_parb                = object_parb
        attachment_list            = attachment_list
        receiver_list              = receiver_list
        contents_hex               = contents_hex
      EXCEPTIONS
        document_id_not_exist      = 1
        operation_no_authorization = 2
        x_error                    = 3
        OTHERS                     = 4.

    input_length          = document_data-doc_size.

    CLEAR header.
    header-file_type      = document_data-obj_type(1).
    header-file_name      = document_data-obj_descr.
    header-file_extension = document_data-obj_type.
    header-language       = document_data-obj_langu.

    CALL FUNCTION 'SAP_WAPI_GET_ATTACHMENTS' 
      EXPORTING
        workitem_id = workitem_id
      IMPORTING
        return_code = return_code
      TABLES
        attachments = lt_att_atuais.

    IF lt_att_atuais IS NOT INITIAL.
      READ TABLE lt_att_atuais TRANSPORTING NO FIELDS WITH KEY obj_descr = document_data-obj_descr.
      IF sy-subrc EQ 0.
        CONTINUE.
      ENDIF.
    ENDIF.

    IF header-file_type <> 'T'.

      header-file_type = 'B'.

      CLEAR buffer.
      CALL FUNCTION 'SCMS_BINARY_TO_XSTRING'
        EXPORTING
          input_length = input_length
        IMPORTING
          buffer       = buffer
        TABLES
          binary_tab   = contents_hex
        EXCEPTIONS
          failed       = 1
          OTHERS       = 2.

      CALL FUNCTION 'SAP_WAPI_ATTACHMENT_ADD'
        EXPORTING
          workitem_id = workitem_id
          att_header  = header
          att_bin     = buffer
        IMPORTING
          att_id      = att_id
          return_code = return_code.

    ELSE.

      CLEAR text.
      LOOP AT object_content INTO DATA(s_object_content).
        CONCATENATE s_object_content-line text INTO text.
      ENDLOOP.

      CALL FUNCTION 'SAP_WAPI_ATTACHMENT_ADD'
        EXPORTING
          workitem_id = workitem_id
          att_header  = header
          att_txt     = text
        IMPORTING
          att_id      = att_id
          return_code = return_code.

    ENDIF.

  ENDLOOP.

