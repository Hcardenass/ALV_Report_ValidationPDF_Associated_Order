*&---------------------------------------------------------------------*
*& Include          ZSD_VAL_PDF_PEDIDOS_ALV_SEL
*&---------------------------------------------------------------------*

* Definición de la pantalla de selección con un bloque y título
SELECTION-SCREEN: BEGIN OF BLOCK a01 WITH FRAME TITLE TEXT-a01.
" Inicia un bloque de selección en la pantalla de selección.
" El bloque tiene un marco visual y un título que se toma de la variable TEXT-A01

* Definición de un conjunto de opciones de selección para el campo 'vbeln' (número de pedido)
  SELECT-OPTIONS: p_vbeln FOR vbak-vbeln.
  " Define un campo de entrada para que el usuario ingrese el número de pedido (VBELN).
  " 'p_vbeln' es el nombre de la opción de selección, y 'vbak-vbeln' es el campo de la tabla VBAK sobre el que se realizará la selección de datos.
  " El usuario podrá ingresar un rango de números de pedido o un solo valor para filtrar los datos.

* Definición de un conjunto de opciones de selección para el campo 'erdat' (fecha de creación del pedido)
  SELECT-OPTIONS: s_erdat FOR vbak-erdat.
  " Define un campo de entrada para que el usuario ingrese la fecha de creación del pedido (ERDAT).
  " 's_erdat' es el nombre de la opción de selección, y 'vbak-erdat' es el campo de la tabla VBAK que representa la fecha de creación del pedido (fecha en que se creó el pedido).
  " El usuario podrá ingresar un rango de fechas o un solo valor para filtrar los datos.

* Finalización del bloque de selección en la pantalla de selección
SELECTION-SCREEN: END OF BLOCK a01.
 " Finaliza el bloque de selección con el nombre A01.
  " Esto indica que el bloque de selección para los campos 'p_vbeln' y 's_erdat' ha terminado.
