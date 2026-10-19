CLASS zcl_ld_007_get_exceptions DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_ld_007_get_exceptions IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

* Declarations
**********************************************************************
    DATA: l_result   TYPE i,
          l_numbers  TYPE TABLE OF i,
          l_count    TYPE i,
          l_numb_tmp TYPE i,
          l_index    TYPE i,
          l_char(1)  TYPE c.

* Preparation
**********************************************************************

    APPEND 123 TO l_numbers.

* Example 1: Conversion Error (no Number)
**********************************************************************

    CONSTANTS c_text_1 TYPE string VALUE 'ABC'.
    CONSTANTS c_text_2 TYPE string VALUE '123'.

    out->write(  `---------------------------` ).
    out->write(  `Example 1: Conversion Error` ).
    out->write(  `---------------------------` ).

    CLEAR: l_count.
    DO 2 TIMES.

      ADD 1 TO l_Count.

      TRY.

          IF l_count = 1.
            l_result = c_text_1.
          ELSE.
            l_result = c_text_2.
          ENDIF.
          .

          out->write( |Converted content is { l_result }|  ).
        CATCH cx_sy_conversion_no_number.
          out->write( |Error: { c_text_1 } is not a number!| ).
      ENDTRY.
    ENDDO.
* Example 2: Division by Zero
**********************************************************************

    CONSTANTS: c_number_1 TYPE i VALUE 0,
               c_number_2 TYPE i VALUE 7.


    out->write(  `---------------------------` ).
    out->write(  `Example 2: Division by Zero` ).
    out->write(  `---------------------------` ).

    CLEAR: l_count.
    DO 2 TIMES.

      CLEAR: l_numb_tmp.
      ADD 1 TO l_count.

      IF l_count = 1.
        l_numb_tmp = c_number_1.
      ELSE.
        l_numb_tmp = c_number_2.
      ENDIF.

      TRY.
          l_result = 100 / l_numb_tmp.
          out->write( |100 divided by { l_numb_tmp } equals { l_result }| ).
        CATCH cx_sy_zerodivide.
          out->write(  `Error: Division by zero is not defined!` ).
      ENDTRY.

    ENDDO.
* Example 3: Itab Error (Line Not Found)
**********************************************************************

    CONSTANTS: c_index_1 TYPE i VALUE 2,
               c_index_2 TYPE i VALUE 1.


    out->write(  `-------------------------` ).
    out->write(  `Example 3: Line Not Found` ).
    out->write(  `-------------------------` ).



    CLEAR: l_count.
    DO 2 TIMES.

      CLEAR: l_index.

      ADD 1 TO l_count.
      IF l_count = 1.
        l_index = c_index_1.
      ELSE.
        l_index = c_index_2.
      ENDIF.


      TRY.
          l_result = l_numbers[ l_index ].
          out->write( |Content of row { l_index } equals { l_result }| ).
        CATCH cx_sy_itab_line_not_found.
          out->write(  |Error: Itab has less than { l_index } rows!| ).
      ENDTRY.
    ENDDO.

* Example 4: Combination of Different Exceptions
**********************************************************************
    CONSTANTS: c_char_1 TYPE c LENGTH 1 VALUE 'X',
               c_char_2 TYPE c LENGTH 1 VALUE '0',
               c_char_3 TYPE c LENGTH 1 VALUE '1',
               c_char_4 TYPE c LENGTH 1 VALUE '2'.

    out->write(  `----------------------` ).
    out->write(  `Example 4: Combination` ).
    out->write(  `----------------------` ).

    CLEAR: l_count.
    DO 4 TIMES.

      ADD 1 TO l_count.

      CLEAR: l_char.

      CASE l_count.
        WHEN 1. l_char = c_char_1.
        WHEN 2. l_char = c_char_2.
        WHEN 3. l_char = c_char_3.
        WHEN 4. l_char = c_char_4.
      ENDCASE.

      TRY.
          l_result = l_numbers[ 2 / l_char ].
          out->write( |Result: { l_result } | ).
        CATCH cx_sy_zerodivide.
          out->write( `Error: Division by zero is not defined`  ).
        CATCH cx_sy_conversion_no_number.
          out->write( |Error: { l_char } is not a number! | ).
        CATCH cx_sy_itab_line_not_found.
          out->write( |Error: Itab contains less than { 2 / l_char } rows| ).
      ENDTRY.

    ENDDO.
  ENDMETHOD.

ENDCLASS.
