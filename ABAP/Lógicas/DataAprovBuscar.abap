DATA: lt_cdpos TYPE TABLE OF cdpos,
      gt_cdhdr TYPE TABLE OF cdhdr,
      ls_cdhdr TYPE cdhdr,
      lv_ebeln TYPE rseg-ebeln,
      dt_aprov LIKE sy-datum.

REFRESH: lt_cdpos, gt_cdhdr.
CLEAR: lv_ebeln, ls_cdhdr.

SELECT *
INTO TABLE lt_cdpos FROM cdpos
  WHERE objectclas = 'EINKBELEG' AND
        objectid   = rseg-ebeln.
DELETE lt_cdpos WHERE  tabname   NE 'EKKO'  OR
                       fname     NE 'FRGKE' OR
                       value_new NE 'L'.

SORT lt_cdpos BY objectid DESCENDING changenr DESCENDING.
DELETE ADJACENT DUPLICATES FROM lt_cdpos COMPARING objectid.

IF lt_cdpos[] IS NOT INITIAL.
  SELECT *
    INTO TABLE gt_cdhdr FROM cdhdr
    FOR ALL ENTRIES IN lt_cdpos
    WHERE objectclas = 'EINKBELEG'       AND
          objectid   = lt_cdpos-objectid AND
          changenr   = lt_cdpos-changenr.
ENDIF.
IF gt_cdhdr IS NOT INITIAL.
  READ TABLE gt_cdhdr INTO ls_cdhdr
    WITH KEY objectid = rseg-ebeln.
  IF sy-subrc IS INITIAL.
    dt_aprov = ls_cdhdr-udate."Data de aprovação
  ENDIF.
ENDIF.
