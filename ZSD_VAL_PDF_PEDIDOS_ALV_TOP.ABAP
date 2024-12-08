*&---------------------------------------------------------------------*
*& Include          ZSD_VAL_PDF_PEDIDOS_ALV_TOP
*&---------------------------------------------------------------------*

* Declaraci�n de tablas base utilizadas en el programa
TABLES: vbak.

* Definici�n de estructura para los datos del ALV
* Incluye campos del pedido (VBELN), fecha de creaci�n, tipo de pedido,
* n�mero de referencia, creador del pedido, cliente asociado y datos del PDF.
TYPES: BEGIN OF gty_dms_asoci_ped,
         vbeln         TYPE vbak-vbeln,
         erdat         TYPE vbak-erdat,
         auart         TYPE vbak-auart,
         bstnk         TYPE vbak-bstnk,
         ernam         TYPE vbak-ernam,
         name1         TYPE kna1-name1,
         name1_text    TYPE but000-name1_text,
         doknr         TYPE drad-doknr,
         filename(200) TYPE c,
         color         TYPE LVC_T_SCOL, " Campo para estilos
       END OF gty_dms_asoci_ped.

* Declaraci�n de tabla interna basada en la estructura anterior
* Esta tabla almacenar� los datos que se mostrar�n en el ALV
DATA: gt_dms_asoci_ped TYPE STANDARD TABLE OF gty_dms_asoci_ped.

* Declaraci�n de una variable de trabajo basada en la estructura para manipulaci�n
* Se utiliza para almacenar temporalmente un registro de datos
DATA gs_dms_asoci_ped TYPE gty_dms_asoci_ped.

* Declaraci�n de variable num�rica utilizada como contador para inicializar
* el objeto del ALV y evitar m�ltiples inicializaciones en cada llamada al m�dulo.
DATA gv_cont TYPE i.

* Declaraci�n de variable para el c�digo de funci�n (OK_CODE)
* ok_code_0100 almacena el c�digo de funci�n utilizado en los eventos del ALV o en el procesamiento de comandos.
DATA: ok_code_0100 TYPE sy-ucomm.

* Declaraci�n de variables para manejar colores en el ALV
* lt_s_color es una tabla interna que contendr� los estilos de color para las columnas del ALV.
* ls_s_color es una variable que se utiliza para almacenar temporalmente un estilo de color individual
* que se aplicar� a cada fila o columna del ALV.
DATA: lt_s_color TYPE lvc_t_scol,
      ls_s_color TYPE lvc_s_scol.
