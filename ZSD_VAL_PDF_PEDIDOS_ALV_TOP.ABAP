*&---------------------------------------------------------------------*
*& Include          ZSD_VAL_PDF_PEDIDOS_ALV_TOP
*&---------------------------------------------------------------------*

* Declaración de tablas base utilizadas en el programa
TABLES: vbak.

* Definición de estructura para los datos del ALV
* Incluye campos del pedido (VBELN), fecha de creación, tipo de pedido,
* número de referencia, creador del pedido, cliente asociado y datos del PDF.
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

* Declaración de tabla interna basada en la estructura anterior
* Esta tabla almacenará los datos que se mostrarán en el ALV
DATA: gt_dms_asoci_ped TYPE STANDARD TABLE OF gty_dms_asoci_ped.

* Declaración de una variable de trabajo basada en la estructura para manipulación
* Se utiliza para almacenar temporalmente un registro de datos
DATA gs_dms_asoci_ped TYPE gty_dms_asoci_ped.

* Declaración de variable numérica utilizada como contador para inicializar
* el objeto del ALV y evitar múltiples inicializaciones en cada llamada al módulo.
DATA gv_cont TYPE i.

* Declaración de variable para el código de función (OK_CODE)
* ok_code_0100 almacena el código de función utilizado en los eventos del ALV o en el procesamiento de comandos.
DATA: ok_code_0100 TYPE sy-ucomm.

* Declaración de variables para manejar colores en el ALV
* lt_s_color es una tabla interna que contendrá los estilos de color para las columnas del ALV.
* ls_s_color es una variable que se utiliza para almacenar temporalmente un estilo de color individual
* que se aplicará a cada fila o columna del ALV.
DATA: lt_s_color TYPE lvc_t_scol,
      ls_s_color TYPE lvc_s_scol.
