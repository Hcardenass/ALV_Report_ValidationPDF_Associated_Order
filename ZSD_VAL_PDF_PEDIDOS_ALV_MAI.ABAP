*&---------------------------------------------------------------------*
*& Include          ZSD_VAL_PDF_PEDIDOS_ALV_MAI
*&---------------------------------------------------------------------*

START-OF-SELECTION.
  " Inicio del bloque de procesamiento principal del programa.

  DATA: go_alv_doc_asoc_ped TYPE REF TO cl_alv_doc_asoc_ped.
  " Declara una variable de tipo referencia a la clase 'cl_alv_doc_asoc_ped'.
  " y la variable 'go_alv_doc_asoc_ped' ser� utilizada para crear un objeto de esa clase.

  PERFORM select_data.
  " Llama al subrutina 'select_data' para ejecutar la l�gica de selecci�n de datos.
  " La subrutina 'select_data' realiza la consulta a la base de datos y obtiene los datos que se mostrar�n en el ALV
