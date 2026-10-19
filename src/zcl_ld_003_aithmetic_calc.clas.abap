CLASS zcl_ld_003_aithmetic_calc DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_ld_003_aithmetic_calc IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.


* Declarations
**********************************************************************

    " comment/uncomment these line for different result types
    TYPES t_result TYPE p LENGTH 8 DECIMALS 2.
*    TYPES t_result TYPE p LENGTH 8 DECIMALS 0.
*    TYPES t_result TYPE i.

    DATA result_1 TYPE t_result.

* Calculations
**********************************************************************
    " comment/uncomment these lines for different calculations

    result_1 = 2 + 3.
    DATA(result_2) = 2 - 3.
    DATA(result_3) = 2 * 3.
    DATA(result_4) = 2 / 3.
*
    DATA(result_5) = sqrt( 2 ).
    DATA(result_6) = ipow( base = 2 exp = 3 ).
*
*    result = ( 8 * 7 - 6 ) / ( 5 + 4 ).
*   result = 8 * 7 - 6 / 5 + 4.

* Output
**********************************************************************

    out->write( result_1 ).
    out->write( result_2 ).
    out->write( result_3 ).
    out->write( result_4 ).
    out->write( result_5 ).
    out->write( result_6 ).


  ENDMETHOD.

ENDCLASS.
