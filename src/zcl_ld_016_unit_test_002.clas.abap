CLASS zcl_ld_016_unit_test_002 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun.

  PROTECTED SECTION.
  PRIVATE SECTION.

    data: A_obj_info_flights TYPE ref to lcl_info_flight.
    CONSTANTS: a_cst_carrier_id_1 TYPE /dmo/carrier_id VALUE 'LH'.

ENDCLASS.



CLASS zcl_ld_016_unit_test_002 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA: ls_data_to_show TYPE zld_db_s4d400.

    TRY.

        clear: me->A_obj_info_flights.
        me->A_obj_info_flights = NEW lcl_info_flight( pt_r_id_Carrier_im = VALUE #( ( sign = 'I' option = 'EQ' low = me->a_cst_carrier_id_1  ) ) ).

        DATA(LT_airports) = me->A_obj_info_flights->get_airports(  ).
        DATA(LT_cities) = me->A_obj_info_flights->get_cities(  ).

        LOOP AT lt_airports INTO DATA(ls_airport).
          CLEAR: ls_data_to_show.
          MOVE-CORRESPONDING ls_airport TO ls_data_to_show.
          READ TABLE lt_cities INTO DATA(ls_cities)
             WITH KEY carrier_id = ls_airport-carrier_id
                      connection_id = ls_airport-connection_id.
          IF sy-subrc = 0.
            ls_data_to_show-city_from = ls_cities-city_from.
            ls_data_to_show-city_to = ls_cities-city_to.
          ENDIF.

          out->write( |Tabix:                { sy-tabix }| ).
          out->write( |Carrier ID:           { ls_data_to_show-carrier_id }| ).
          out->write( |Connection ID:        { ls_data_to_show-connection_id }| ).
          out->write( |Departure Airport ID: { ls_data_to_show-airport_from_id }| ).
          out->write( |City From:            { ls_data_to_show-city_from }| ).
          out->write( |Arrival Airport ID:   { ls_data_to_show-airport_to_id }| ).
          out->write( |City To:              { ls_data_to_show-city_to }| ).

        ENDLOOP.

      CATCH cx_Abap_invalid_value INTO DATA(lo_cx_1).

        out->write( |{ lo_cx_1->get_text(  ) } | ).

    ENDTRY.

  ENDMETHOD.

ENDCLASS.
