*&---------------------------------------------------------------------*
*&      Form  F_ANEXAR_ARQUIVO_WF
*&---------------------------------------------------------------------*
FORM f_anexar_arquivo_wf.

TYPES: 
BEGIN OF ty_extension,
  xfile     TYPE xstring,
  name_file TYPE string,
END OF ty_txt,

BEGIN OF ty_buffer,
  extension(3) TYPE c,
  buffer       TYPE xstring,
  name_file    TYPE string,
END OF ty_buffer.

DATA: lt_filetable TYPE filetable,
      gt_pdf       TYPE TABLE OF ty_extension,
      gt_doc       TYPE TABLE OF ty_extension,
      gt_msg       TYPE TABLE OF ty_extension,
      gt_xls       TYPE TABLE OF ty_extension,
      gt_txt       TYPE TABLE OF ty_extension,
      gt_buffer    TYPE TABLE OF ty_buffer.

CALL METHOD cl_gui_frontend_services=>file_open_dialog
    EXPORTING
*     window_title            =
*     default_extension       =
*     default_filename        =
*     file_filter             =
*     with_encoding           =
*     initial_directory       =
      multiselection          = 'X'
    CHANGING
      file_table              = lt_filetable
      rc                      = lv_rc
    EXCEPTIONS
      file_open_dialog_failed = 1
      cntl_error              = 2
      error_no_gui            = 3
      not_supported_by_gui    = 4
      OTHERS                  = 5.
  IF sy-subrc <> 0.

  ENDIF.

  REFRESH: gt_pdf, gt_doc, gt_msg, gt_xls, gt_txt, gt_buffer.
  CLEAR  gv_name_files.

  LOOP AT lt_filetable INTO DATA(s_filetable).

    REFRESH: t_paths, t_lines.
    CLEAR: gs_pdf, gs_doc, gs_msg, gs_xls, gs_txt, s_paths,  gv_xbuffer,
           index, lv_size_input, gv_name_file.

    SPLIT s_filetable AT '\' INTO TABLE t_paths.
    index = lines( t_paths ).

    CHECK index > 0.

    READ TABLE t_paths INTO s_paths INDEX index.
    gv_name_file = s_paths.

    FIND FIRST OCCURRENCE OF '.' IN gv_name_file MATCH OFFSET lv_offset.

    IF gv_name_file+lv_offset(4) = '.PDF' OR gv_name_file+lv_offset(4) = '.pdf'.

      PERFORM get_pdf_buffer USING s_filetable.

    ENDIF.

    IF gv_name_file+lv_offset(4) = '.DOC' OR gv_name_file+lv_offset(4) = '.doc'.

      PERFORM get_doc_buffer USING s_filetable.

    ENDIF.

    IF gv_name_file+lv_offset(4) = '.MSG' OR gv_name_file+lv_offset(4) = '.msg'.

      PERFORM get_msg_buffer USING s_filetable.

    ENDIF.

    IF gv_name_file+lv_offset(4) = '.XLS' OR gv_name_file+lv_offset(4) = '.xls'.

      PERFORM get_xls_buffer USING s_filetable.

    ENDIF.

    IF gv_name_file+lv_offset(4) = '.TXT' OR gv_name_file+lv_offset(4) = '.txt'.

      PERFORM get_txt_buffer USING s_filetable.

    ENDIF.

    IF gv_name_files IS INITIAL.
      gv_name_files = gv_name_file && ';'.
    ELSE.
      CONCATENATE gv_name_files gv_name_file ';' INTO gv_name_files SEPARATED BY space.
    ENDIF.

  ENDLOOP.

* Buscar arquivo. (.pdf, .doc, .msg, .xls, .txt)
  LOOP AT lt_registro INTO ls_registro.

    REFRESH: gt_message_lines, gt_message_struct, gt_items_worklist.
    CLEAR: gv_return_code, gv_return_code2, gv_workitem_id.

    IF ls_registro-wi_id IS NOT INITIAL.
      gv_workitem_id = ls_registro-wi_id.
    ELSE.
      CONTINUE.
    ENDIF.

    PERFORM f_trata_worklist. "Atualizar gv_workitem_id para o mais workitem mais recente

    IF gt_buffer IS NOT INITIAL.

      LOOP AT gt_buffer INTO gs_buffer.

        CLEAR: gv_xbuffer, gs_attheader.

        gv_xbuffer = gs_buffer-buffer.

        gs_attheader-file_type = 'B'.
        gs_attheader-file_name = gs_buffer-name_file.
        gs_attheader-file_extension = gs_buffer-extension.
        gs_attheader-language ='PT'.

** Adicionar Anexo Workitem Principal
        CALL FUNCTION 'SAP_WAPI_ATTACHMENT_ADD'
          EXPORTING
            workitem_id    = ls_registro-wi_id
            att_header     = gs_attheader
*           att_txt        =
            att_bin        = gv_xbuffer
            do_commit      = 'X'
          IMPORTING
            return_code    = gv_return_code
            att_id         = gs_att_id
          TABLES
            message_lines  = gt_message_lines
            message_struct = gt_message_struct.
        IF gv_return_code IS NOT INITIAL.
          "Tratamento de erro
        ENDIF.
** Adicionar Anexo Etapa Decisão
        CALL FUNCTION 'SAP_WAPI_ATTACHMENT_ADD'
          EXPORTING
            workitem_id    = gv_workitem_id
            att_header     = gs_attheader
*           att_txt        =
            att_bin        = gv_xbuffer
            do_commit      = 'X'
          IMPORTING
            return_code    = gv_return_code2
            att_id         = gs_att_id
          TABLES
            message_lines  = gt_message_lines
            message_struct = gt_message_struct.

        IF gv_return_code IS NOT INITIAL OR gv_return_code2 IS NOT INITIAL.
          "Tratamento de erro
          CLEAR s_message_struct.
          READ TABLE gt_message_struct INTO s_message_struct INDEX 1.
          CALL FUNCTION 'BALW_BAPIRETURN_GET2'
            EXPORTING
              type   = s_message_struct-msgty
              cl     = s_message_struct-msgid
              number = s_message_struct-msgno
              par1   = s_message_struct-msgv1
              par2   = s_message_struct-msgv2
              par3   = s_message_struct-msgv3
              par4   = s_message_struct-msgv4
            IMPORTING
              return = s_return.
          APPEND s_return TO t_return.
          CLEAR s_return.

        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDLOOP.

ENDFORM.                    " F_ANEXAR_ARQUIVO_WF