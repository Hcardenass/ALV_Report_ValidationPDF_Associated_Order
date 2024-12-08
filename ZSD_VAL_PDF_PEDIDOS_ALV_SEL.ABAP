*&---------------------------------------------------------------------*
*& Include          ZSD_VAL_PDF_PEDIDOS_ALV_SEL
*&---------------------------------------------------------------------*

* Definici�n de la pantalla de selecci�n con un bloque y t�tulo
SELECTION-SCREEN: BEGIN OF BLOCK a01 WITH FRAME TITLE TEXT-a01.
  " Inicia un bloque de selecci�n en la pantalla de selecci�n.
  " El bloque tiene un marco visual y un t�tulo que se toma de la variable TEXT-A01

* Definici�n de un conjunto de opciones de selecci�n para el campo 'vbeln' (n�mero de pedido)
  SELECT-OPTIONS: p_vbeln FOR vbak-vbeln.
  " Define un campo de entrada para que el usuario ingrese el n�mero de pedido (VBELN).
  " 'p_vbeln' es el nombre de la opci�n de selecci�n, y 'vbak-vbeln' es el campo de la tabla VBAK sobre el que se realizar� la selecci�n de datos.
  " El usuario podr� ingresar un rango de n�meros de pedido o un solo valor para filtrar los datos.

* Definici�n de un conjunto de opciones de selecci�n para el campo 'erdat' (fecha de creaci�n del pedido)
  SELECT-OPTIONS: s_erdat FOR vbak-erdat.
  " Define un campo de entrada para que el usuario ingrese la fecha de creaci�n del pedido (ERDAT).
  " 's_erdat' es el nombre de la opci�n de selecci�n, y 'vbak-erdat' es el campo de la tabla VBAK que representa la fecha de creaci�n del pedido (fecha en que se cre� el pedido).
  " El usuario podr� ingresar un rango de fechas o un solo valor para filtrar los datos.

* Finalizaci�n del bloque de selecci�n en la pantalla de selecci�n
SELECTION-SCREEN: END OF BLOCK a01.
" Finaliza el bloque de selecci�n con el nombre A01.
" Esto indica que el bloque de selecci�n para los campos 'p_vbeln' y 's_erdat' ha terminado.


AT SELECTION-SCREEN ON p_vbeln.
  PERFORM f_verificar_pedido.


FORM f_verificar_pedido.

  SELECT vbeln INTO TABLE @DATA(lt_const)
    FROM vbak
   WHERE auart IN ('ZP01','ZP03','ZP05','ZP11','ZP02','ZP18') AND
        vbeln IN @p_vbeln.

  IF sy-subrc <> 0.
    MESSAGE e398(00) WITH TEXT-001.
  ENDIF.

ENDFORM.
