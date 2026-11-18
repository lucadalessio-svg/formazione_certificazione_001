*"* use this source file for your ABAP unit test classes

CLASS: ltcl_Prova_001 DEFINITION DEFERRED,
       ltcl_Prova_002 DEFINITION DEFERRED.

CLASS: zcl_ld_015_unit_test_001 DEFINITION LOCAL FRIENDS ltcl_prova_001,
       zcl_ld_015_unit_test_001 DEFINITION LOCAL FRIENDS ltcl_prova_002.

CLASS ltcl_Prova_001 DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS:
      success_test   FOR TESTING RAISING cx_static_check,
      exception_test FOR TESTING.

ENDCLASS.

CLASS ltcl_Prova_002 DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
*    METHODS:
*      success_test   FOR TESTING RAISING cx_static_check,
*      exception_test FOR TESTING.

ENDCLASS.

CLASS ltcl_Prova_001 IMPLEMENTATION.

  METHOD success_test.

* Local Object
    DATA: lo_015_unit_Test TYPE REF TO zcl_ld_015_unit_test_001.

* B.o.M.

    SELECT FROM /dmo/connection
      FIELDS *
      INTO TABLE @DATA(lt_data) UP TO 5 ROWS.

    IF sy-subrc NE 0.
      cl_abap_unit_assert=>fail( 'Test Requires at last one entry DB table /dmo/connection' ).
    ENDIF.

    CLEAR: lo_015_unit_test.
    lo_015_unit_test = NEW #( ).

    lo_015_unit_test->a_obj_connection = NEW #( p_id_carrier_im    = lo_015_unit_test->a_cst_carrier_id_1
                                                p_id_connection_im = lo_015_unit_test->a_cst_connection_id_1  ).

    DATA(lt_result) = lo_015_unit_test->a_obj_connection->get_db_data( p_flag_use_default_im = 'X'  ).

    IF lt_result IS INITIAL.
      cl_abap_unit_assert=>fail(  msg = 'Test Requires at last one entry DB table /dmo/connection'
                                  detail = 'Use Other Combiantion of Carrier ID and Connection ID values'
                                  level  = if_abap_unit_constant=>severity-high
                                  quit   = if_abap_unit_constant=>quit-test ).
    ENDIF.



  ENDMETHOD.

  METHOD exception_test.


* Local Object
    DATA: lo_015_unit_Test TYPE REF TO zcl_ld_015_unit_test_001.

* B.o.M.

    SELECT FROM /dmo/connection
      FIELDS *
      INTO TABLE @DATA(lt_data) UP TO 5 ROWS.

    IF sy-subrc NE 0.
      cl_abap_unit_assert=>fail( 'Test Requires at last one entry DB table /dmo/connection' ).
    ENDIF.

    CLEAR: lo_015_unit_test.
    lo_015_unit_test = NEW #( ).
*
    lo_015_unit_test->a_obj_connection = NEW #( p_id_carrier_im    = lo_015_unit_test->a_cst_carrier_id_1
                                                p_id_connection_im = lo_015_unit_test->a_cst_connection_id_1  ).


*    lo_015_unit_test->a_obj_connection = NEW #( p_id_carrier_im    = 'GG'
*                                                p_id_connection_im = '02'  ).

    TRY.
        DATA(lt_result) = lo_015_unit_test->a_obj_connection->get_db_data( p_flag_use_default_im = 'X'  ).

      CATCH cx_abap_sql_error INTO DATA(lcx_01).

        cl_abap_unit_assert=>fail(  msg    = CONV #( lcx_01->get_text(  ) )
                                    detail = 'Use Other Combiantion of Carrier ID and Connection ID values'
                                    level  = if_abap_unit_constant=>severity-high
                                    quit   = if_abap_unit_constant=>quit-test ).

    ENDTRY.
  ENDMETHOD.

ENDCLASS.

CLASS ltcl_Prova_002 IMPLEMENTATION.
ENDCLASS.





