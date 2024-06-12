METHOD download_layout. "Baixar Layout de um Modelo Excel

    DATA: BEGIN OF ls_layout,
            pedido      TYPE c LENGTH 15,
            loja        TYPE c LENGTH 15,
            cod_cliente TYPE c LENGTH 15,
            data_pedido TYPE c LENGTH 15,
            hora_pedido TYPE c LENGTH 15,
            material    TYPE c LENGTH 15,
            qtd         TYPE c LENGTH 15,
            und         TYPE c LENGTH 17,
          END OF ls_layout,
          lt_layout LIKE TABLE OF ls_layout.

    DATA: lv_file      TYPE xstring,
          lv_bytecount TYPE i,
          lt_file_tab  TYPE solix_tab.

    DATA: lv_full_path      TYPE string,
          lv_workdir        TYPE string,
          lv_file_separator TYPE c.

    DATA: lv_filename TYPE string.
    DATA: lv_path     TYPE string.
    DATA: lv_fullpath TYPE string.
    DATA: lv_lastname TYPE string.
    DATA: lv_type_file TYPE c LENGTH 5.

    CALL METHOD cl_gui_frontend_services=>file_save_dialog
      EXPORTING
*       window_title              =
        default_extension         = 'xlsx'
        default_file_name         = 'example.xlsx'
*       with_encoding             =
        file_filter               = 'XLSX-Files (*.XLSX)'
        initial_directory         = 'C:\'
*       prompt_on_overwrite       = 'X'
      CHANGING
        filename                  = lv_filename
        path                      = lv_path
        fullpath                  = lv_fullpath
*       user_action               =
*       file_encoding             =
      EXCEPTIONS
        cntl_error                = 1
        error_no_gui              = 2
        not_supported_by_gui      = 3
        invalid_default_file_name = 4
        OTHERS                    = 5.

    IF lv_fullpath IS NOT INITIAL.

      TRANSLATE lv_fullpath TO UPPER CASE.
      FIND '.XLS' IN lv_fullpath.
      IF sy-subrc <> 0.
        CONCATENATE lv_fullpath '.XLSX' INTO lv_fullpath.
      ENDIF.

      APPEND INITIAL LINE TO lt_layout ASSIGNING FIELD-SYMBOL(<fs_layout>).
      <fs_layout>-pedido       =  'PEDIDO'.
      <fs_layout>-loja         =  'LOJA'.
      <fs_layout>-cod_cliente  =  'COD CLIENTE'.
      <fs_layout>-data_pedido  =  'DATA'.
      <fs_layout>-hora_pedido  =  'HORA'.
      <fs_layout>-material     =  'MATERIAL'.
      <fs_layout>-qtd          =  'QUANTIDADE'.
      <fs_layout>-und          =  'UNIDADE DE MEDIDA'.

    ELSE.
      MESSAGE 'Ação cancelada!' TYPE 'S' DISPLAY LIKE 'E'.
      RETURN.
    ENDIF.

    CALL FUNCTION 'SAP_CONVERT_TO_XLS_FORMAT'
      EXPORTING
*       I_FIELD_SEPERATOR =
*       I_LINE_HEADER     =
        i_filename        = CONV rlgrap-filename( lv_fullpath )
*       I_APPL_KEEP       =
      TABLES
        i_tab_sap_data    = lt_layout
*       CHANGING
*       I_TAB_CONVERTED_DATA       =
      EXCEPTIONS
        conversion_failed = 1
        OTHERS            = 2.

    IF sy-subrc <> 0.
*     Implement suitable error handling here
    ELSE.
      CONCATENATE 'Arquivo' lv_filename 'gerado com Sucesso' INTO DATA(m_text) SEPARATED BY space.
      MESSAGE m_text TYPE 'I'.
    ENDIF.

  ENDMETHOD.