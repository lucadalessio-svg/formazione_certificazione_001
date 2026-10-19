CLASS zcl_ld_005_string_calc DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_ld_005_string_calc IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    TYPES t_amount TYPE  p LENGTH 8 DECIMALS 2.

    DATA: l_amount    TYPE t_amount VALUE '3.30',
          L_amount1   TYPE t_amount VALUE '2.20',
          l_amount2   TYPE t_amount VALUE '5.10',
          l_date      TYPE d  VALUE '19891109',
          l_number    TYPE p LENGTH 3 DECIMALS 2 VALUE '-273.15',
          l_str_part1 TYPE string VALUE `Hello`,
          l_str_part2 TYPE string VALUE `World`,
          l_number_01 TYPE i,
          l_number_02 TYPE i,
          l_number_03 TYPE i,
          l_number_04 TYPE i.

* String Templates
**********************************************************************

    " comment/uncomment the following lines for different examples
    DATA(l_text_1)  = |Hello World|.
    DATA(l_text_2)  = |Total: { l_amount } EUR|.
    DATA(l_text_3)  = |Total: { l_amount1 + l_amount2 } EUR|.

* Format Options
**********************************************************************

    "Date
    DATA(l_text_4)  = |Raw Date: { l_date }|.
    DATA(l_text_5)  = |ISO Date: { l_date DATE = ISO  }|.
    DATA(l_text_6)  = |USER Date:{ l_date DATE = USER }|.

    "Number
    DATA(l_text_7)  = |Raw Number { l_number }|.
    DATA(l_text_8)  = |User Format{ l_number NUMBER = USER }|.
    DATA(l_text_9)  = |Sign Right { l_number SIGN = RIGHT }|.
    DATA(l_text_10) = |Scientific { l_number STYLE = SCIENTIFIC }|.


* String expression (concatenation Operator)
**********************************************************************

    DATA(l_text_11) = L_str_part1 && l_stR_part2.
    DATA(l_text_12) = l_str_part1 && | | && l_str_part2.
    DATA(l_text_13) = |{ l_amount1 } + { l_amount2 }| && | = | && |{ l_amount1 + l_amount2 }|.

* Output
**********************************************************************

    out->write( l_text_1 ).
    out->write( l_text_2 ).
    out->write( l_text_3 ).
    out->write( l_text_4 ).
    out->write( l_text_5 ).
    out->write( l_text_6 ).
    out->write( l_text_7 ).
    out->write( l_text_8 ).
    out->write( l_text_9 ).
    out->write( l_text_10 ).
    out->write( l_text_11 ).
    out->write( l_text_12 ).
    out->write( l_text_13 ).

    CLEAR: l_number_01, l_number_02, l_number_03, l_number_04.
    l_number_01 = 6.
    l_number_02 = 3.

    DATA(l_result) = l_number_01 / l_number_02.
    out->write( l_result ).

    DATA(l_output) = | { l_number_01 } / { l_number_02 } = { l_result }|.
    out->write( l_output ).

    l_number_03 = -21.
    l_number_04 = 13.

    DATA: l_result_2 TYPE p DECIMALS 2.

    l_result_2 = l_number_03 / l_number_04.

    CLEAR: l_output.

    l_output = | { l_number_03 } / { l_number_04 } = { l_result_2 }|.
    out->write( l_output ).


  ENDMETHOD.

ENDCLASS.
