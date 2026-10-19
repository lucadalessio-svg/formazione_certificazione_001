CLASS zcl_ld_010_itab DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_ld_010_itab IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

* Local Structure/Table
    DATA: lt_numbers TYPE TABLE OF i,
          lt_output  TYPE string_table.

* Constants
    CONSTANTS: c_max_count TYPE  i VALUE 20.

* Local Variables
    DATA: l_count TYPE i.

* B.o.M.
    DO c_max_count TIMES.

      CASE sy-index.
        WHEN 1.
          APPEND 1 TO lt_numbers.
        WHEN 2.
          APPEND 2 TO lt_numbers.
        WHEN OTHERS.
          APPEND lt_numbers[ sy-index - 1 ] + lt_numbers[ sy-index - 2 ] TO lt_numbers[].
      ENDCASE.

    ENDDO.

    CLEAR: l_count, lt_output[].
    LOOP AT lt_numbers INTO DATA(ls_numbers).
      ADD 1 TO l_count.

      APPEND |Counter { l_count WIDTH = 4 ALIGN = LEFT } - value { ls_numbers WIDTH = 10 ALIGN = RIGHT }|
          TO lt_output[].

    ENDLOOP.

    IF lt_output IS NOT INITIAL.
      out->write(  data = lt_output
                   name = |The first { c_max_count } Fibonacci Numbers| ).
    ELSE.
      out->write( |Error during program execution| ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
