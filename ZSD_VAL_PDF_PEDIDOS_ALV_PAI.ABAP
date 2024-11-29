*&---------------------------------------------------------------------*
*& Include          ZSD_VAL_PDF_PEDIDOS_ALV_PAI
*&---------------------------------------------------------------------*

MODULE user_command_0100 INPUT.

  " Evalúa el código de la acción del usuario (ok_code_0100) y ejecuta la acción correspondiente
  CASE ok_code_0100.

    " Si el usuario presiona 'BACK', regresa al screen anterior
    WHEN 'BACK'.
      SET SCREEN 0.
      LEAVE SCREEN.

    " Si el usuario presiona 'EXIT' o 'CANCEL', termina el programa
    WHEN 'EXIT' OR 'CANCEL'.
      LEAVE PROGRAM.

  ENDCASE.
ENDMODULE.
