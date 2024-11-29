*&---------------------------------------------------------------------*
*& Include          ZSD_VAL_PDF_PEDIDOS_ALV_PBO
*&---------------------------------------------------------------------*

MODULE status_0100 OUTPUT.

  " Establece el conjunto de funciones de la barra de herramientas como '0100'
  set pf-status '0100'.

  " Establece el título de la barra como '0100'
  SET TITLEBAR '0100'.

  " Incrementa el contador para controlar la inicialización del ALV
  gv_cont = gv_cont + 1.

  " Solo ejecuta el siguiente bloque de código la primera vez que se llama al módulo
  IF gv_cont EQ 1.
    " Crea el objeto ALV para asociar los documentos con los pedidos
    CREATE OBJECT go_alv_doc_asoc_ped.

    " Llama al método para inicializar el ALV y mostrar los datos
    CALL METHOD go_alv_doc_asoc_ped->iniciar_alv_doc_asoc_ped.
  ENDIF.
ENDMODULE.
