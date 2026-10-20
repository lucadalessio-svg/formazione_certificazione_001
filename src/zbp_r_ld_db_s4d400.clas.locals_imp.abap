CLASS lhc_zr_ld_db_s4d400 DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS:
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING
        REQUEST requested_authorizations FOR zld_connection
        RESULT result,
      CheckSemanticKey FOR VALIDATE ON SAVE
       keys FOR zld_connection~CheckSemanticKey,
      GetCitiesInfo FOR DETERMINE ON SAVE
       keys FOR zld_connection~GetCitiesInfo,
      CheckFlightPrice FOR VALIDATE ON SAVE
       keys FOR zld_connection~CheckFlightPrice.


ENDCLASS.

CLASS lhc_zr_ld_db_s4d400 IMPLEMENTATION.
  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD CheckSemanticKey.

* Local Structures/Tables
    DATA: lS_reported    LIKE LINE OF reported-zld_connection,
          lt_read_keys   TYPE TABLE FOR READ IMPORT zr_ld_db_s4d400,
          lt_result_conn TYPE TABLE FOR READ RESULT zr_ld_db_s4d400.

* B.o.M.

    CLEAR: lt_read_keys[].
    lt_read_keys = CORRESPONDING #( Keys ).


    CLEAR: lt_result_conn[].

    READ ENTITIES OF zr_ld_db_s4d400 IN LOCAL MODE
    ENTITY ZLD_Connection
    FIELDS ( carrierid connectionid )
     WITH lt_Read_keys
    RESULT lt_result_conn.


    LOOP AT lt_Result_conn INTO DATA(ls_result_conn).

      SELECT FROM zld_db_s4d400 FIELDS uuid
       WHERE carrier_id    = @ls_Result_conn-CarrierID
         AND connection_id = @ls_Result_conn-connectionid
         AND uuid          <> @ls_Result_conn-uuid
         UNION
         SELECT FROM zld_db_s4d400_d FIELDS uuid
       WHERE carrierid     = @ls_Result_conn-CarrierID
         AND connectionid  = @ls_Result_conn-connectionid
         AND uuid          <> @ls_Result_conn-uuid
         INTO TABLE @DATA(lt_Check).

    ENDLOOP.

    IF lt_check[] IS NOT INITIAL.

* ls_reported-%key = ls_result_conn-%key.
* ls_reported-%msg = me->new_message( id = 'ZLD_CLS_MSG_01'
*                                     number = '001'
*                                     severity = ms-error
*                                     v1 = ls_result_conn-CarrierID
*                                     v2 = ls_result_conn-ConnectionID ).
*ls_reported-%element-carrierid = if_abap_behv=>mk-on.
*ls_reported-%element-connectionid = if_abap_behv=>mk-on.
*append ls_reported to reported-zldconnection.

      APPEND VALUE #( %key = ls_result_conn-%key
                      %msg = me->new_message( id = 'ZLD_CLS_MSG_01'
                                          number = '001'
                                        severity = ms-error
                                              v1 = ls_result_conn-CarrierID
                                              v2 = ls_result_conn-ConnectionID )
                      %element-carrierid = if_abap_behv=>mk-on
                      %element-connectionid = if_abap_behv=>mk-on ) TO reported-zld_connection.

    ENDIF.

  ENDMETHOD.

  METHOD GetCitiesInfo.

* Local Structures/Tables
    DATA: lt_connection_update TYPE TABLE FOR UPDATE zr_ld_db_s4d400.

* B.o.M.
    READ ENTITIES OF zr_ld_db_s4d400 IN LOCAL MODE
              ENTITY ZLD_Connection
              FIELDS ( AirportFromID AirportToID )
              WITH CORRESPONDING #(  keys )
              RESULT DATA(lt_result_conn).

    LOOP AT lt_result_conn ASSIGNING FIELD-SYMBOL(<result>).

      SELECT SINGLE city, countrycode
              FROM /dmo/i_airport
         WHERE AirportID = @<result>-AirportFromID
         INTO ( @<result>-cityfrom, @<result>-CountryFrom ).


      SELECT SINGLE city, countrycode
           FROM /dmo/i_airport
      WHERE AirportID = @<result>-Airporttoid
      INTO ( @<result>-cityto, @<result>-Countryto ).

    ENDLOOP.

    lt_Connection_update = CORRESPONDING #( lt_result_conn ).

    MODIFY ENTITIES OF zr_ld_db_s4d400 IN LOCAL MODE
               ENTITY ZLD_Connection
               UPDATE
               FIELDS ( CityFrom CountryFrom CityTo countryto )
                 WITH lt_Connection_update
        REPORTED DATA(lt_reported).

    reported-zld_connection = CORRESPONDING #( lt_reported-zld_connection ).

  ENDMETHOD.

  METHOD CheckFlightPrice.

    READ ENTITIES OF zr_ld_db_s4d400 IN LOCAL MODE
            ENTITY ZLD_Connection
            FIELDS ( Price currency )
            WITH CORRESPONDING #(  keys )
            RESULT DATA(lt_result).

    LOOP AT lt_result INTO DATA(ls_result).
      IF ls_result-Price <= 0.

        APPEND VALUE #( %key = ls_result-%key
                           %msg = me->new_message( id = 'ZLD_CLS_MSG_01'
                                               number = '002'
                                             severity = ms-error
                                                   v1 = ls_result-CarrierID
                                                   v2 = ls_result-ConnectionID
                                                   v3 = ls_result-Price )
                           %element-carrierid = if_abap_behv=>mk-on
                           %element-connectionid = if_abap_behv=>mk-on ) TO reported-zld_connection.

      ENDIF.
    ENDLOOP.

  ENDMETHOD.


ENDCLASS.
