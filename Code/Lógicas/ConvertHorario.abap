
* Validação de um valor de horário por carga. Padrão HHMMSS

        lv_offset = strlen( ls_xlsxload-value ). 
        CASE lv_offset.
          WHEN 8. "Ex: 12:30:00 / HH:MM:SS
            REPLACE ALL OCCURRENCES OF ':' IN ls_xlsxload-value WITH space.
          WHEN 7. "Ex: 2:30:00   / -H:MM:SS
            REPLACE ALL OCCURRENCES OF ':' IN ls_xlsxload-value WITH space.
            CONCATENATE '0' ls_xlsxload-value INTO ls_xlsxload-value.
          WHEN 6. "Ex: 163000 / HHMMSS

          WHEN 5. "Ex: 15:15 / HH:MM
            REPLACE ALL OCCURRENCES OF ':' IN ls_xlsxload-value WITH space.
            CONCATENATE ls_xlsxload-value '00' INTO ls_xlsxload-value.
          WHEN 4. "Ex: 1230   / HHMM ou 6:30 / -H:MM
            FIND FIRST OCCURRENCE OF ':' IN ls_xlsxload-value MATCH OFFSET lv_offset.
            IF sy-subrc NE 0.
              CONCATENATE ls_xlsxload-value '00' INTO ls_xlsxload-value.
            ENDIF.
            IF lv_offset LT 2.
              REPLACE ALL OCCURRENCES OF ':' IN ls_xlsxload-value WITH space.
              CONCATENATE '0' ls_xlsxload-value '00' INTO ls_xlsxload-value.
            ENDIF.
        ENDCASE.

        ls_arquivo-horario = ls_xlsxload-value.