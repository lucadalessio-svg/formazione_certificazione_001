CLASS zcl_ld_009_itab DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_ld_009_itab IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.


* Declarations
**********************************************************************

    " Internal tables
    DATA lt_numbers TYPE TABLE OF i.

    "Table type (local)
    TYPES ty_strings_t TYPE TABLE OF string.
    DATA lt_texts1        TYPE ty_strings_t.

    " Table type (global)
    DATA lt_texts2 TYPE string_table.

    " work areas
    DATA l_number TYPE i VALUE 1234.
    DATA l_text TYPE string.

* Example 1: APPEND
**********************************************************************

    APPEND: 4711         TO lt_numbers,
            l_number     TO lt_numbers,
            2 * l_number TO lt_numbers.

    out->write(  `-----------------` ).
    out->write(  `Example 1: APPEND` ).
    out->write(  `-----------------` ).

    out->write( lt_numbers ).

* Example 2: CLEAR
**********************************************************************

    CLEAR lt_numbers[].

    out->write(  `----------------` ).
    out->write(  `Example 2: CLEAR` ).
    out->write(  `----------------` ).

    out->write( lt_numbers ).

* Example 3: table expression
**********************************************************************
    APPEND: 4711         TO lt_numbers,
            l_number     TO lt_numbers,
            2 * l_number TO lt_numbers.

    out->write(  `---------------------------` ).
    out->write(  `Example 3: Table Expression` ).
    out->write(  `---------------------------` ).

    l_number = lt_numbers[ 2 ] .

    out->write( |Content of row 2: { l_number }|    ).
    "Direct use of expression in string template
    out->write( |Content of row 1: { lt_numbers[ 1 ]  }| ).

* Example 4: LOOP ... ENDLOOP
**********************************************************************
    out->write(  `---------------------------` ).
    out->write(  `Example 4: LOOP ... ENDLOOP` ).
    out->write(  `---------------------------` ).

    CLEAR: l_number.
    LOOP AT lt_numbers INTO l_number.

      out->write( |Row: { sy-tabix } Content { l_number }| ).

    ENDLOOP.

* Example 5: Inline declaration in LOOP ... ENDLOOP
**********************************************************************
    out->write(  `-----------------------------` ).
    out->write(  `Example 5: Inline Declaration` ).
    out->write(  `-----------------------------` ).

    LOOP AT lt_numbers INTO DATA(l_number_inline).
      out->write( |Row: { sy-tabix } Content { l_number_inline }| ).
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
