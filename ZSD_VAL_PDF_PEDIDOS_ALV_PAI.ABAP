*&---------------------------------------------------------------------*
*& Include          ZSD_VAL_PDF_PEDIDOS_ALV_PAI
*&---------------------------------------------------------------------*

MODULE user_command_0100 INPUT.

  " Eval�a el c�digo de la acci�n del usuario (ok_code_0100) y ejecuta la acci�n correspondiente
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
