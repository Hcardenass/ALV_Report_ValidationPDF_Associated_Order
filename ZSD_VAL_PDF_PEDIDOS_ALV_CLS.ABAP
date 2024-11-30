*&---------------------------------------------------------------------*
*& Include          ZSD_VAL_PDF_PEDIDOS_ALV_CLS
*&---------------------------------------------------------------------*


CLASS cl_alv_doc_asoc_ped DEFINITION.
  PUBLIC SECTION.
    METHODS: iniciar_alv_doc_asoc_ped,
      genera_cat_alv_doc_asoc_ped
        EXPORTING
          VALUE(e_cat_alv) TYPE lvc_t_fcat,
      exclude_in_toolbar_alv
        EXPORTING
          VALUE(e_exclude) TYPE ui_functions,
      refrescar_alv,
      top_of_page FOR EVENT top_of_page OF cl_gui_alv_grid
        IMPORTING e_dyndoc_id.


  PRIVATE SECTION.
    DATA lo_grid_doc_asoc_ped TYPE REF TO cl_gui_alv_grid.
    DATA lo_cc_doc_asoc_ped   TYPE REF TO cl_gui_custom_container.

    DATA lt_cat_alv    TYPE lvc_t_fcat.
    DATA lt_sort       TYPE lvc_t_sort.

    DATA lt_exclude    TYPE ui_functions.
    DATA lwa_exclude   TYPE ui_func.
    DATA lt_header     TYPE lvc_t_head.
    DATA li_length     TYPE int4.

    DATA lcl_top         TYPE REF TO cl_dd_document.
    DATA lcl_html_cntrl  TYPE REF TO cl_gui_html_viewer.
    DATA lcl_parent_grid TYPE REF TO cl_gui_container.
    DATA lcl_parent_html TYPE REF TO cl_gui_container.
    DATA lcl_splitter    TYPE REF TO cl_gui_splitter_container.

    DATA lwa_layout    TYPE lvc_s_layo.
    DATA lwa_stbl      TYPE lvc_s_stbl.
    DATA lwa_vari      TYPE disvariant.
    DATA lwa_prnt      TYPE lvc_s_prnt.
ENDCLASS.



CLASS cl_alv_doc_asoc_ped IMPLEMENTATION.
  METHOD iniciar_alv_doc_asoc_ped.
    IF lo_grid_doc_asoc_ped IS INITIAL.
      CREATE OBJECT lo_cc_doc_asoc_ped
        EXPORTING
          container_name              = 'GC_DOC_ASOC_PED'
        EXCEPTIONS
          cntl_error                  = 1
          cntl_system_error           = 2
          create_error                = 3
          lifetime_error              = 4
          lifetime_dynpro_dynpro_link = 5
          OTHERS                      = 6.

      IF sy-subrc NE 0.
      ELSE.
        IF me->lcl_top IS INITIAL.
          CREATE OBJECT me->lcl_top
            EXPORTING
              style = 'ALV_GRID'.
        ENDIF.

* Separamos en 2 filas el container principal
        CREATE OBJECT me->lcl_splitter
          EXPORTING
            parent  = me->lo_cc_doc_asoc_ped
            rows    = 2
            columns = 1.

* Primer Splitter para el TOP OF PAGE
        CALL METHOD me->lcl_splitter->get_container
          EXPORTING
            row       = 1
            column    = 1
          RECEIVING
            container = me->lcl_parent_html.

* Segundo splitter para los filtros
        CALL METHOD me->lcl_splitter->get_container
          EXPORTING
            row       = 2
            column    = 1
          RECEIVING
            container = me->lcl_parent_grid.

        CREATE OBJECT lo_grid_doc_asoc_ped
          EXPORTING
            i_appl_events = 'X'
            i_parent      = me->lcl_parent_grid. ".lo_cc_doc_asoc_ped

        CALL METHOD lo_grid_doc_asoc_ped->register_edit_event
          EXPORTING
            i_event_id = cl_gui_alv_grid=>mc_evt_modified.


        REFRESH lt_cat_alv.
        CALL METHOD me->genera_cat_alv_doc_asoc_ped
          IMPORTING
            e_cat_alv = lt_cat_alv.

        REFRESH lt_exclude.
        CALL METHOD me->exclude_in_toolbar_alv
          IMPORTING
            e_exclude = lt_exclude.


        CALL METHOD me->top_of_page.

**       Variante
        CLEAR lwa_vari.
        lwa_vari-report      = sy-repid.

*       Layout
        CLEAR lwa_layout.
        lwa_layout-ctab_fname = 'COLOR'.
        lwa_layout-sel_mode   = 'A'.
        lwa_layout-cwidth_opt = 'X'.

        CALL METHOD lo_grid_doc_asoc_ped->set_table_for_first_display
          EXPORTING
            is_variant           = lwa_vari
            is_layout            = lwa_layout
            it_toolbar_excluding = lt_exclude
            is_print             = lwa_prnt
            i_save               = 'A'
            i_default            = 'X'
          CHANGING
            it_outtab            = gt_dms_asoci_ped
            it_fieldcatalog      = lt_cat_alv.
      ENDIF.
    ELSE.
      CLEAR lwa_stbl.
      lwa_stbl-row = 'X'.
      lwa_stbl-col = 'X'.

      CALL METHOD lo_grid_doc_asoc_ped->refresh_table_display
        EXPORTING
          is_stable = lwa_stbl.
    ENDIF.
  ENDMETHOD.

  METHOD genera_cat_alv_doc_asoc_ped.

    DATA: li_col_pos TYPE int4.
    FIELD-SYMBOLS <fs_fcat> TYPE lvc_s_fcat.
    FIELD-SYMBOLS <fs_dms> TYPE gty_dms_asoci_ped.

    li_col_pos = li_col_pos + 1.
    APPEND INITIAL LINE TO e_cat_alv ASSIGNING <fs_fcat>.
    <fs_fcat>-col_pos    = li_col_pos.
    <fs_fcat>-tabname    = 'GT_DMS_ASOCI_PED'.
    <fs_fcat>-fieldname  = 'VBELN'.
    <fs_fcat>-ref_table  = 'VBAK'.
    <fs_fcat>-ref_field  = 'VBELN_VA'.
    <fs_fcat>-coltext    = TEXT-f01.
    <fs_fcat>-key        = 'X'.
    <fs_fcat>-outputlen  = 10.

    li_col_pos = li_col_pos + 1.
    APPEND INITIAL LINE TO e_cat_alv ASSIGNING <fs_fcat>.
    <fs_fcat>-col_pos    = li_col_pos.
    <fs_fcat>-tabname    = 'GT_DMS_ASOCI_PED'.
    <fs_fcat>-fieldname  = 'ERDAT'.
    <fs_fcat>-ref_table  = 'VBAK'.
    <fs_fcat>-ref_field  = 'ERDAT'.
    <fs_fcat>-coltext    = TEXT-f02.
    <fs_fcat>-outputlen  = 11.

    li_col_pos = li_col_pos + 1.
    APPEND INITIAL LINE TO e_cat_alv ASSIGNING <fs_fcat>.
    <fs_fcat>-col_pos    = li_col_pos.
    <fs_fcat>-tabname    = 'GT_DMS_ASOCI_PED'.
    <fs_fcat>-fieldname  = 'AUART'.
    <fs_fcat>-ref_table  = 'VBAK'.
    <fs_fcat>-ref_field  = 'AUART'.
    <fs_fcat>-coltext    = TEXT-f03.
    <fs_fcat>-outputlen  = 8.

    li_col_pos = li_col_pos + 1.
    APPEND INITIAL LINE TO e_cat_alv ASSIGNING <fs_fcat>.
    <fs_fcat>-col_pos    = li_col_pos.
    <fs_fcat>-tabname    = 'GT_DMS_ASOCI_PED'.
    <fs_fcat>-fieldname  = 'BSTNK'.
    <fs_fcat>-ref_table  = 'VBAK'.
    <fs_fcat>-ref_field  = 'BSTNK'.
    <fs_fcat>-coltext    = TEXT-f04.
    <fs_fcat>-outputlen  = 19.

    li_col_pos = li_col_pos + 1.
    APPEND INITIAL LINE TO e_cat_alv ASSIGNING <fs_fcat>.
    <fs_fcat>-col_pos    = li_col_pos.
    <fs_fcat>-tabname    = 'GT_DMS_ASOCI_PED'.
    <fs_fcat>-fieldname  = 'ERNAM'.
    <fs_fcat>-ref_table  = 'VBAK'.
    <fs_fcat>-ref_field  = 'ERNAM'.
    <fs_fcat>-coltext    = TEXT-f05.
    <fs_fcat>-outputlen  = 10.

    li_col_pos = li_col_pos + 1.
    APPEND INITIAL LINE TO e_cat_alv ASSIGNING <fs_fcat>.
    <fs_fcat>-col_pos    = li_col_pos.
    <fs_fcat>-tabname    = 'GT_DMS_ASOCI_PED'.
    <fs_fcat>-fieldname  = 'NAME1'.
    <fs_fcat>-ref_table  = 'KNA1'.
    <fs_fcat>-ref_field  = 'NAME1_GP'.
    <fs_fcat>-coltext    = TEXT-f06.
    <fs_fcat>-outputlen  = 20.

    li_col_pos = li_col_pos + 1.
    APPEND INITIAL LINE TO e_cat_alv ASSIGNING <fs_fcat>.
    <fs_fcat>-col_pos    = li_col_pos.
    <fs_fcat>-tabname    = 'GT_DMS_ASOCI_PED'.
    <fs_fcat>-fieldname  = 'NAME1_TEXT'.
    <fs_fcat>-ref_table  = 'BUT000'.
    <fs_fcat>-ref_field  = 'BU_NAME1TX'.
    <fs_fcat>-coltext    = TEXT-f07.
    <fs_fcat>-outputlen  = 15.

    li_col_pos = li_col_pos + 1.
    APPEND INITIAL LINE TO e_cat_alv ASSIGNING <fs_fcat>.
    <fs_fcat>-col_pos    = li_col_pos.
    <fs_fcat>-tabname    = 'GT_DMS_ASOCI_PED'.
    <fs_fcat>-fieldname  = 'DOKNR'.
    <fs_fcat>-ref_table  = 'DMS_DOC_FILES'.
    <fs_fcat>-ref_field  = 'DOKNR'.
    <fs_fcat>-coltext    = TEXT-f08.
    <fs_fcat>-outputlen  = 19.

    li_col_pos = li_col_pos + 1.
    APPEND INITIAL LINE TO e_cat_alv ASSIGNING <fs_fcat>.
    <fs_fcat>-col_pos    = li_col_pos.
    <fs_fcat>-tabname    = 'GT_DMS_ASOCI_PED'.
    <fs_fcat>-fieldname  = 'FILENAME'.
    <fs_fcat>-ref_table  = 'DMS_DOC_FILES'.
    <fs_fcat>-coltext    = TEXT-f09.
    <fs_fcat>-outputlen  = 25.
*    <fs_fcat>-emphasize = 'C500'.

  ENDMETHOD.


  METHOD exclude_in_toolbar_alv.
    DATA wa_exclude TYPE ui_func.
    REFRESH e_exclude.
    lwa_exclude  = cl_gui_alv_grid=>mc_fc_loc_delete_row.
    APPEND lwa_exclude  TO e_exclude.
    lwa_exclude  = cl_gui_alv_grid=>mc_fc_loc_append_row.
    APPEND lwa_exclude  TO e_exclude.
    lwa_exclude  = cl_gui_alv_grid=>mc_fc_loc_insert_row.
    APPEND lwa_exclude  TO e_exclude.
    lwa_exclude  = cl_gui_alv_grid=>mc_fc_loc_undo.
    APPEND lwa_exclude  TO e_exclude.
    lwa_exclude  = cl_gui_alv_grid=>mc_fc_loc_copy.
    APPEND lwa_exclude  TO e_exclude.
    lwa_exclude  = cl_gui_alv_grid=>mc_fc_loc_cut.
    APPEND lwa_exclude  TO e_exclude.
    lwa_exclude  = cl_gui_alv_grid=>mc_fc_loc_copy_row.
    APPEND lwa_exclude  TO e_exclude.
    lwa_exclude  = cl_gui_alv_grid=>mc_fc_graph.
    APPEND lwa_exclude  TO e_exclude.
    lwa_exclude  = cl_gui_alv_grid=>mc_fc_help.
    APPEND lwa_exclude  TO e_exclude.
    lwa_exclude  = cl_gui_alv_grid=>mc_fc_info.
    APPEND lwa_exclude  TO e_exclude.
    lwa_exclude  = cl_gui_alv_grid=>mc_mb_paste.
    APPEND lwa_exclude  TO e_exclude.
    lwa_exclude  = cl_gui_alv_grid=>mc_fc_print.
    APPEND lwa_exclude  TO e_exclude.
  ENDMETHOD.

  METHOD top_of_page.
    FIELD-SYMBOLS: <fs_header> TYPE lvc_s_head.
* Inicializando texto HTML
    IF NOT me->lcl_top IS INITIAL.
      CALL METHOD me->lcl_top->initialize_document.
    ENDIF.

* Procesar el evento TOP OF PAGE
    CALL METHOD lo_grid_doc_asoc_ped->list_processing_events
      EXPORTING
        i_event_name = 'TOP_OF_PAGE'
        i_dyndoc_id  = me->lcl_top.

* Instanciando el contenedor de tipo HTML
    IF me->lcl_html_cntrl IS INITIAL.
      CREATE OBJECT me->lcl_html_cntrl
        EXPORTING
          parent = me->lcl_parent_html.
    ENDIF.


* Construyendo datos de Cabecera

    CALL METHOD me->lcl_top->add_text
      EXPORTING
        text          = 'Reporte para Validación de PDFs Asociado al Pedido'
        sap_style     = cl_dd_area=>heading
        sap_fontstyle = cl_dd_area=>large
        sap_color     = cl_dd_area=>list_heading_int
        sap_emphasis  = cl_dd_area=>strong.

    CALL FUNCTION 'REUSE_ALV_GRID_COMMENTARY_SET'
      EXPORTING
        document = me->lcl_top
        bottom   = space
      IMPORTING
        length   = me->li_length.


    CALL METHOD me->lcl_splitter->set_row_mode
      EXPORTING
        mode = cl_gui_splitter_container=>mode_absolute.

    me->li_length = me->li_length + 75.
    CALL METHOD me->lcl_splitter->set_row_height
      EXPORTING
        id     = 1
        height = me->li_length.

    CALL METHOD me->lcl_top->add_gap
      EXPORTING
        width = 250.

    TRY.
        CALL METHOD me->lcl_top->add_picture
          EXPORTING
            picture_id = 'LOGO_TECNOFIL'
            width      = '150'.
      CATCH cx_root INTO DATA(lo_exception).
        MESSAGE lo_exception->get_text( ) TYPE 'S' DISPLAY LIKE 'E'.
    ENDTRY.

    CALL METHOD me->lcl_top->merge_document.

    me->lcl_top->html_control = me->lcl_html_cntrl.

* Mostrando cabecera en ALV

    CALL METHOD me->lcl_top->display_document
      EXPORTING
        reuse_control      = 'X'
        parent             = me->lcl_parent_html
      EXCEPTIONS
        html_display_error = 1.

  ENDMETHOD.

  METHOD refrescar_alv.
    DATA: lw_refresh TYPE lvc_s_stbl,
          lw_row     TYPE  i,
          lw_value   TYPE  c,
          lw_col     TYPE  i,
          lw_row_id  TYPE lvc_s_row,
          lw_col_id  TYPE lvc_s_col,
          lw_row_no  TYPE lvc_s_roid.

    CALL METHOD lo_grid_doc_asoc_ped->get_current_cell
      IMPORTING
        e_row     = lw_row
        e_value   = lw_value
        e_col     = lw_col
        es_row_id = lw_row_id
        es_col_id = lw_col_id
        es_row_no = lw_row_no.
    lw_refresh-row = 'X'.
    lw_refresh-col = 'X'.

    CALL METHOD lo_grid_doc_asoc_ped->refresh_table_display
      EXPORTING
        is_stable = lw_refresh.

    CALL METHOD lo_grid_doc_asoc_ped->set_current_cell_via_id
      EXPORTING
        is_row_id    = lw_row_id
        is_column_id = lw_col_id
        is_row_no    = lw_row_no.
  ENDMETHOD.

ENDCLASS.
