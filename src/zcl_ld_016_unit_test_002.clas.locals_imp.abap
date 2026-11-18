*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

CLASS lcl_info_flight IMPLEMENTATION.

  METHOD constructor.
*
    SELECT * FROM
        ZLD_DB_S4D400
        WHERE carrier_id IN @pt_r_id_Carrier_im
          AND connection_id IN @pt_r_id_connection_im
        INTO TABLE @me->a_data_Tab.

    IF sy-subrc NE 0.
      RAISE EXCEPTION TYPE cx_Abap_invalid_value.
    ENDIF.

  ENDMETHOD.

  METHOD get_airports.

    pt_airports_id_rt[] = CORRESPONDING #( me->a_data_tab MAPPING carrier_id      = carrier_id
                                                                  connection_id   = connection_id
                                                                  airport_from_id = airport_from_id
                                                                  airport_to_id   = airport_to_id EXCEPT * ).

  ENDMETHOD.
  METHOD get_cities.


    pt_cities_rt[] = CORRESPONDING #( me->a_data_tab MAPPING carrier_id     = carrier_id
                                                             connection_id  = connection_id
                                                             city_from      = city_from
                                                             city_to        = city_to EXCEPT * ).

  ENDMETHOD.

ENDCLASS.
