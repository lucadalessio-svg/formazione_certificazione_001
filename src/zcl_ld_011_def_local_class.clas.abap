CLASS zcl_ld_011_def_local_class DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_ld_011_def_local_class IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

* Local class.
    DATA: lo_test  TYPE REF TO lcl_prova_ld_01,
          lto_test TYPE TABLE OF REF TO lcl_prova_ld_01.

* B.o.M.

    CLEAR: lo_test.
    lo_test = NEW #(  ).

    lo_test->a_prm_id_carrier = 'LH'.
    lo_test->a_prm_id_connection = '0400'.

    APPEND lo_test TO lto_test.

    CLEAR: lo_test.
    lo_test = NEW #(  ).

    lo_test->a_prm_id_carrier = 'AA'.
    lo_test->a_prm_id_connection = '0017'.

    APPEND lo_test TO lto_test.

    CLEAR: lo_test.
    lo_test = NEW #(  ).

    lo_test->a_prm_id_carrier = 'SQ'.
    lo_test->a_prm_id_connection = '0001'.

    APPEND lo_test TO lto_test.

    LOOP AT lto_test INTO DATA(lo_test_tmp).
      DATA(l_index) = sy-tabix.

      out->write( |Sy-tabix: { sy-tabix }| ).
      out->write( |  | ).
      out->write( |Usando Workarea| ).
      out->write( lo_test_tmp->a_prm_id_carrier ).
      out->write( lo_test_tmp->a_prm_id_connection ).
      out->write( |  | ).
      out->write( |Usando indice tabella| ).
      out->write( lto_test[ l_index ]->a_prm_id_carrier ).
      out->write( lto_test[ l_index ]->a_prm_id_connection ).
      out->write( |-------------------- | ).

    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
