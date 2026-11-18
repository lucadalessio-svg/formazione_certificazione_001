*"* use this source file for your ABAP unit test classes

**********************************************************************
*--------------------------- DEFINITION ------------------------------
**********************************************************************

* Friendly definition.
CLASS: ltcl_test_01 DEFINITION DEFERRED,
       ltcl_test_02 DEFINITION DEFERRED.

CLASS: zcl_ld_016_unit_test_002 DEFINITION LOCAL FRIENDS ltcl_test_01,
       zcl_ld_016_unit_test_002 DEFINITION LOCAL FRIENDS ltcl_test_02.

* Test Class 01 - Definition
CLASS ltcl_test_01 DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.


  PRIVATE SECTION.

    DATA: a_obj_016_unit_Test   TYPE REF TO zcl_ld_016_unit_test_002,
          a_cst_connection_id_2 TYPE /dmo/connection_id VALUE '0002',
          a_Cst_carrier_id_2    TYPE /dmo/carrier_id VALUE 'AF'.

    METHODS:
      setup,
      test_01_get_airport FOR TESTING RAISING cx_static_check,
      test_01_Get_cities  FOR TESTING.


ENDCLASS.

*---------------------------------------------------------------------
* Test Class 02 - Definition
CLASS ltcl_test_02 DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.

    DATA: a_obj_016_unit_Test   TYPE REF TO zcl_ld_016_unit_test_002,
          a_flag_db_modified    TYPE abap_boolean,
          a_db_row_manage       TYPE zld_db_s4d400,
          a_cst_connection_id_1 TYPE /dmo/connection_id VALUE '9999',
          a_cst_connection_id_2 TYPE /dmo/connection_id VALUE '0002',
          a_Cst_carrier_id_1    TYPE /dmo/carrier_id VALUE 'ZZ',
          a_Cst_carrier_id_2    TYPE /dmo/carrier_id VALUE 'AF'.

    METHODS:
      setup,
      teardown,
      test_02_get_airport FOR TESTING RAISING cx_static_check,
      test_02_Get_cities  FOR TESTING.

ENDCLASS.

**********************************************************************
*---------------------- IMPLEMENTATIONS ------------------------------
**********************************************************************

* Test Class 01 - Implementation
CLASS ltcl_test_01 IMPLEMENTATION.
  METHOD setup.

    me->a_obj_016_unit_test = new #(  ).

    TRY.
        me->a_obj_016_unit_Test->a_obj_info_flights = NEW #( pt_r_id_carrier_im    = VALUE #( ( sign = 'I' option = 'EQ' low = 'SQ' ) )
                                                             pt_r_id_connection_im = VALUE #( ( sign = 'I' option = 'EQ' low = '0002' ) ) ).
      CATCH cx_abap_invalid_value.
        cl_abap_unit_assert=>skip( msg = 'Prerequisito mancante: volo AF 0002 non trovato in ZLD_DB_S4D400' ).
    ENDTRY.

  ENDMETHOD.

  METHOD test_01_get_airport.

    DATA(lt_ariports) = me->a_obj_016_unit_Test->a_obj_info_flights->get_airports( ).

    ". Controlliamo che abbia estratto esattamente 1 riga
    cl_abap_unit_assert=>assert_equals( act = lines( lt_ariports )
                                        exp = 1
                                        msg = 'Numero di righe estratte per gli aeroporti errato' ).

    ". Leggiamo la riga e verifichiamo gli ID degli aeroporti
    cl_abap_unit_assert=>assert_equals( act = lt_ariports[ 1 ]-airport_from_id
                                        exp = 'SIN'
                                        msg = 'Aeroporto di partenza (AIRPORT_FROM_ID) errato' ).

    cl_abap_unit_assert=>assert_equals( act = lt_ariports[ 1 ]-airport_to_id
                                        exp = 'SFO'
                                        msg = 'Aeroporto di arrivo (AIRPORT_TO_ID) errato' ).

  ENDMETHOD.

  METHOD test_01_get_cities.
    " 1. Chiamiamo il metodo che estrae le città
    DATA(lt_cities) = me->a_obj_016_unit_Test->a_obj_info_flights->get_cities( ).

    " 2. Leggiamo la prima riga (se è vuota o non esiste il test fallisce)
    cl_abap_unit_assert=>assert_not_initial( act = lt_cities[]
                                             msg = 'La tabella delle città è vuota'  ).

    " 3. Verifichiamo i nomi delle città (Bangkok -> Nashville, Tennessee)
    cl_abap_unit_assert=>assert_equals( act = lt_cities[ 1 ]-city_from
                                        exp = 'Singapore'
                                        msg = 'Città di partenza (CITY_FROM) errata' ).

    cl_abap_unit_assert=>assert_equals( act = lt_cities[ 1 ]-city_to
                                        exp = 'San Francisco, California'
                                        msg = 'Città di arrivo (CITY_TO) errata' ).
  ENDMETHOD.

ENDCLASS.

*--------------------------------------------------------------------
* Test Class 02 - Implementation

CLASS ltcl_test_02 IMPLEMENTATION.

  METHOD setup.

    TRY.
        me->a_db_row_manage = VALUE #( uuid            = cl_system_uuid=>create_uuid_x16_static( )
                                      carrier_id      = me->a_Cst_carrier_id_1
                                      connection_id   = '9999'
                                      airport_from_id = 'GOA'
                                      city_from       = 'Genova'
                                      airport_to_id   = 'FCO'
                                      city_to         = 'Roma'  ).

        MODIFY zld_db_s4d400 FROM @me->a_db_row_manage.
        IF sy-subrc = 0.
          COMMIT WORK AND WAIT.
          me->a_flag_db_modified = abap_true.
        ELSE.
          ROLLBACK WORK.
          cl_abap_unit_assert=>skip( msg = |Modifica tabella DB andato in errore !!| ).
        ENDIF.

      CATCH cx_uuid_error INTO DATA(lo_Cx_uuid_01).
        cl_abap_unit_assert=>skip( msg = |Prerequisito fallito: impossibile generare UUID ({ lo_Cx_uuid_01->get_text( ) })|
        ).
    ENDTRY.

    me->a_obj_016_unit_test = new #(  ).

    TRY.
        me->a_obj_016_unit_Test->a_obj_info_flights = NEW lcl_info_flight( pt_r_id_carrier_im = VALUE #( ( sign = 'I' option = 'EQ' low = me->a_Cst_carrier_id_1 ) )
    ).
      CATCH cx_abap_invalid_value.
        " Se non trova il record 'AF' '0002' nel DB, fa fallire il test subito
        cl_abap_unit_assert=>fail( msg = |Prerequisito mancante: volo { me->a_Cst_carrier_id_1 } { me->a_cst_connection_id_1 }  non trovato in ZLD_DB_S4D400| ).
    ENDTRY.


  ENDMETHOD.

  METHOD test_02_get_airport.

    DATA(lt_ariports) = me->a_obj_016_unit_Test->a_obj_info_flights->get_airports( ).

    ". Controlliamo che abbia estratto esattamente 1 riga
    cl_abap_unit_assert=>assert_equals( act = lines( lt_ariports )
                                        exp = 1
                                        msg = 'Numero di righe estratte per gli aeroporti errato' ).

    ". Leggiamo la riga e verifichiamo gli ID degli aeroporti
    cl_abap_unit_assert=>assert_equals( act = lt_ariports[ 1 ]-airport_from_id
                                        exp = 'GOA'
                                        msg = 'Aeroporto di partenza (AIRPORT_FROM_ID) errato' ).

    cl_abap_unit_assert=>assert_equals( act = lt_ariports[ 1 ]-airport_to_id
                                        exp = 'FCO'
                                        msg = 'Aeroporto di arrivo (AIRPORT_TO_ID) errato' ).
  ENDMETHOD.

  METHOD test_02_get_cities.
    " 1. Chiamiamo il metodo che estrae le città
    DATA(lt_cities) = me->a_obj_016_unit_Test->a_obj_info_flights->get_cities( ).

    " 2. Leggiamo la prima riga (se è vuota o non esiste il test fallisce)
    cl_abap_unit_assert=>assert_not_initial( act = lt_cities[]
                                             msg = 'La tabella delle città è vuota'  ).

    " 3. Verifichiamo i nomi delle città (Bangkok -> Nashville, Tennessee)
    cl_abap_unit_assert=>assert_equals( act = lt_cities[ 1 ]-city_from
                                        exp = 'Genova'
                                        msg = 'Città di partenza (CITY_FROM) errata' ).

    cl_abap_unit_assert=>assert_equals( act = lt_cities[ 1 ]-city_to
                                        exp = 'Roma'
                                        msg = 'Città di arrivo (CITY_TO) errata' ).
  ENDMETHOD.

  METHOD teardown.

    IF me->a_flag_db_modified IS NOT INITIAL.
      DELETE zld_db_s4d400 FROM @me->a_db_row_manage.
      IF sy-subrc = 0.
        COMMIT WORK AND WAIT.
      ELSE.
        ROLLBACK WORK.
      ENDIF.
    ENDIF.

  ENDMETHOD.

ENDCLASS.


