CLASS zcl_ld_006_conditions DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_ld_006_conditions IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
* Declarations
**********************************************************************

    CONSTANTS: c_number_1 TYPE i VALUE 0,
               c_number_2 TYPE i VALUE 1,
               c_number_3 TYPE i VALUE 2,
               c_number_4 TYPE i VALUE -1,
               c_number_5 TYPE i VALUE -2.

    DATA: L_number TYPE i,
          l_count  TYPE i.
* Example 1: Simple IF ... ENDIF.
**********************************************************************

    out->write(  `--------------------------------` ).
    out->write(  `Example 1: Simple IF ... ENDIF.` ).
    out->write(  `-------------------------------` ).

    CLEAR: l_count.
    DO 2 TIMES.

      l_count = l_count + 1.
      CLEAR: l_number.

      IF l_count  = 1.
        l_number = c_number_1.
      ELSE.
        l_number = c_number_2.
      ENDIF.


      IF l_number = 0.
        out->write( |The value of l_NUMBER { l_number } equals zero|   ).
      ELSE.
        out->write( |The value of l_NUMBER { l_number } is NOT zero|   ).
      ENDIF.

    ENDDO.

* Example 2: Optional Branches ELSEIF and ELSE
**********************************************************************

    out->write(  `--------------------------------------------` ).
    out->write(  `Example 2: Optional Branches ELSEIF and ELSE` ).
    out->write(  `--------------------------------------------` ).


    CLEAR: l_count.


    DO 3 TIMES.

      l_count = l_count + 1.
      CLEAR: l_number.

      CASE  l_count.
        WHEN 1.
          l_number = C_number_1.
        WHEN 2.
          l_number = C_number_2.
        WHEN 3.
          l_number = C_number_4.
      ENDCASE.

      IF l_number = 0.
        out->write( |The value of l_NUMBER { l_number } equals zero|            ).
      ELSEIF l_number > 0.
        out->write( |The value of l_NUMBER { l_number } is greater than zero|   ).
      ELSE.
        out->write( |The value of l_NUMBER { l_number } is less than zero|   ).
      ENDIF.

    ENDDO.
* Example 3: CASE ... ENDCASE
**********************************************************************

    out->write(  `---------------------------` ).
    out->write(  `Example 3: CASE ... ENDCASE` ).
    out->write(  `---------------------------` ).


    CLEAR: l_count.
    DO 4 TIMES.

      l_count = l_count + 1.

      CLEAR: l_number.
      CASE l_count.

        WHEN 1.
          l_number = C_number_1.
        WHEN 2.
          l_number = C_number_2.
        WHEN 3.
          l_number = C_number_3.
        WHEN 4.
          l_number = C_number_4.
      ENDCASE.

      CASE l_number.
        WHEN 0.
          out->write( |The value of l_NUMBER { l_number } equals zero|             ).
        WHEN 1.
          out->write( |The value of l_NUMBER { l_number } equals one|             ).
        WHEN 2.
          out->write( |The value of l_NUMBER { l_number } equals two|              ).
        WHEN OTHERS.
          out->write( |The value of l_NUMBER { l_number } equals non of the above| ).
      ENDCASE.
    ENDDO.
  ENDMETHOD.

ENDCLASS.
