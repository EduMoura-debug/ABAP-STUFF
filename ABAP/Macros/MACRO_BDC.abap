*-- Internal table to hold bdc DATA
    DATA: it_bdcdata TYPE TABLE OF bdcdata,
          wa_bdcdata LIKE LINE OF it_bdcdata.

    DATA: lv_UPDATE TYPE c VALUE 'S',
          lv_mode   TYPE c VALUE 'N'.

    DEFINE m_bdc.
      CLEAR wa_bdcdata.
      wa_bdcdata-program = &1.
    wa_bdcdata-dynpro = &2.
    wa_bdcdata-dynbegin = &3.
    wa_bdcdata-fnam = &4.
    wa_bdcdata-fval = &5.
    APPEND wa_bdcdata TO it_bdcdata.
    END-OF-DEFINITION.