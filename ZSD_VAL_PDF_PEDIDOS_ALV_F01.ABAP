*&---------------------------------------------------------------------*
*& Include          ZSD_VAL_PDF_PEDIDOS_ALV_F01
*&---------------------------------------------------------------------*


*---------------------------Subrutina para obtener datos--------------------------*

FORM select_data.


  SELECT dr~objky AS pedido,
        dm~doknr,
        dm~filename
   FROM drad AS dr
   INNER JOIN draw AS dw ON dw~doknr = dr~doknr AND dw~dappl = 'PDF'
   INNER JOIN dms_doc_files AS dm ON dm~doknr = dw~doknr
   WHERE dr~dokob = 'VBAK' AND dr~objky IN @p_vbeln
   INTO TABLE @DATA(it_dms_doc).


  SELECT vb~vbeln, vb~erdat, vb~auart, vb~bstnk, vb~ernam,
         kn~name1,
         bu~name1_text,
         it~doknr,
         it~filename
    FROM vbak AS vb
    LEFT JOIN kna1 AS kn ON kn~kunnr = vb~kunnr
    LEFT JOIN vbpa AS va ON va~vbeln = vb~vbeln AND parvw = 'VE'
    LEFT JOIN but000 AS bu ON bu~partner = va~assigned_bp
    LEFT JOIN @it_dms_doc as it on it~pedido = vb~vbeln
                       "----Tipo Ped Exterior----" "Tipo Ped Loc"
    WHERE vb~vbeln IN @p_vbeln AND
          vb~erdat IN @s_erdat AND
          vb~auart IN ('ZP01','ZP03','ZP05','ZP11','ZP02','ZP18') AND
          vb~erdat >= '20240101'
    ORDER BY vb~erdat DESCENDING
        INTO TABLE @DATA(it_select_ped).


 LOOP AT it_select_ped  ASSIGNING FIELD-SYMBOL(<fs_select_ped>).

   ClEAR gs_dms_asoci_ped.

   gs_dms_asoci_ped-vbeln = <fs_select_ped>-vbeln.
   gs_dms_asoci_ped-erdat = <fs_select_ped>-erdat.
   gs_dms_asoci_ped-auart = <fs_select_ped>-auart.
   gs_dms_asoci_ped-bstnk = <fs_select_ped>-bstnk.
   gs_dms_asoci_ped-ernam = <fs_select_ped>-ernam.
   gs_dms_asoci_ped-name1 = <fs_select_ped>-name1.
   gs_dms_asoci_ped-name1_text = <fs_select_ped>-name1_text.
   gs_dms_asoci_ped-doknr = <fs_select_ped>-doknr.
   gs_dms_asoci_ped-filename = <fs_select_ped>-filename.

*/ COLOR
          IF <fs_select_ped>-filename IS NOT INITIAL.
            ls_s_color-fname     = 'FILENAME'.
            ls_s_color-color-col = col_positive.
            ls_s_color-color-int = 0.
            ls_s_color-color-inv = 0.
            APPEND ls_s_color TO lt_s_color.

          ELSE.

            ls_s_color-fname     = 'FILENAME'.
            ls_s_color-color-col = col_negative.
            ls_s_color-color-int = 1.
            ls_s_color-color-inv = 1.
            APPEND ls_s_color TO lt_s_color.
            ENDIF.

          IF <fs_select_ped>-filename IS NOT INITIAL.
            ls_s_color-fname     = 'DOKNR'.
            ls_s_color-color-col = col_positive.
            ls_s_color-color-int = 0.
            ls_s_color-color-inv = 0.
            APPEND ls_s_color TO lt_s_color.

          ELSE.

            ls_s_color-fname     = 'DOKNR'.
            ls_s_color-color-col = col_negative.
            ls_s_color-color-int = 1.
            ls_s_color-color-inv = 1.
            APPEND ls_s_color TO lt_s_color.
            ENDIF.


          gs_dms_asoci_ped-color = lt_s_color.
          CLEAR: lt_s_color, ls_s_color.


   APPEND gs_dms_asoci_ped to gt_dms_asoci_ped.

 ENDLOOP.

  IF gt_dms_asoci_ped[] IS NOT INITIAL.
        CALL SCREEN 0100.
      ELSE.
        MESSAGE s899(vf) WITH TEXT-M01 DISPLAY LIKE 'E'.
      ENDIF.

ENDFORM.
