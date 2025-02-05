DATA: lv_datum     LIKE sy-datum,
      lv_SCAL_DATE LIKE SCAL-DATE,
      lv_indicator LIKE SCAL-INDICATOR.

  "Busca último dia do mês
  CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
    EXPORTING
      day_in            = sy-datum
    IMPORTING
      last_day_of_month = lv_datum
    EXCEPTIONS
      day_in_no_date    = 1
      OTHERS            = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  DO.
    "Verifica se a data é dia útil ou não
    CALL FUNCTION 'DATE_CHECK_WORKINGDAY'
      EXPORTING
        date                       = lv_datum "Data
        factory_calendar_id        = 'BR'     "Id de calendário da tabela TFACD
        message_type               = 'E'      "Tipo de msg de saída S,E,I,W)
      EXCEPTIONS
        date_after_range           = 1
        date_before_range          = 2
        date_invalid               = 3
        date_no_workingday         = 4
        factory_calendar_not_found = 5
        message_type_invalid       = 6
        OTHERS                     = 7.
    IF sy-subrc <> 0.
      lv_datum = lv_datum - 1. "Se o dia não for útil, subtrai 1 e verifica novamente
      CONTINUE.
    ELSE.
      "É dia útil mas é fim de semana?
      lv_scal_date = lv_datum.

      CALL FUNCTION 'DATE_COMPUTE_DAY' "Checar se é sabádo ou domingo.
        EXPORTING
          date = lv_scal_date
        IMPORTING
          day  = lv_indicator.

      IF lv_indicator EQ 6.
        lv_datum = lv_datum - 1.
      ELSEIF lv_indicator EQ 7.
        lv_datum = lv_datum - 2.
      ELSE.
        EXIT. "Se o dia for útil e não for sábado ou domingo, sai do loop
      ENDIF.
    ENDIF.
  ENDDO.

  IF lv_datum EQ sy-datum. "Se data de hoje igual último dia útil
     RESULT  = ABAP_TRUE.
  ELSE. "Se não
     RESULT  = ABAP_FALSE.
  ENDIF.