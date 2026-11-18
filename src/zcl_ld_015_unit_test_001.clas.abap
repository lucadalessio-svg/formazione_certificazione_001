CLASS zcl_ld_015_unit_test_001 DEFINITION
PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA: a_obj_connection      TYPE REF TO lcl_prova_ld_01,
          a_tab_obj_connections TYPE TABLE OF REF TO lcl_prova_ld_01.
    CONSTANTS: a_cst_carrier_id_1    TYPE /dmo/carrier_id    VALUE 'LH',
               a_cst_connection_id_1 TYPE /dmo/connection_id VALUE '0400',
               a_cst_carrier_id_2    TYPE /dmo/carrier_id    VALUE 'SQ',
               a_cst_connection_id_2 TYPE /dmo/connection_id VALUE '0001',
               a_cst_carrier_id_3    TYPE /dmo/carrier_id    VALUE 'XX',
               a_cst_connection_id_3 TYPE /dmo/connection_id VALUE '0017'.

ENDCLASS.


CLASS zcl_ld_015_unit_test_001 IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

* B.o.M.

    DO 4 TIMES.

      CLEAR: me->a_obj_connection.

      CASE sy-index.

        WHEN 2.

          DATA(l_Carrier_id) = me->a_cst_carrier_id_1.
          DATA(L_connection_id) = me->a_cst_connection_id_1.

        WHEN 3.
          l_Carrier_id = me->a_cst_carrier_id_2.
          L_connection_id = me->a_cst_connection_id_2.
        WHEN 4.
          l_Carrier_id = me->a_cst_carrier_id_3.
          L_connection_id = me->a_cst_connection_id_3.
      ENDCASE.

      out->write( |Sy-index: { sy-index }| ).

      me->a_obj_connection = NEW #( p_id_carrier_im   = l_carrier_id
                                   p_id_connection_im = l_connection_id ).

      APPEND me->a_obj_connection TO me->a_Tab_obj_connections.

      out->write( `Objects Created successful` ).

    ENDDO.

    out->write( `-------------------------` ).
    out->write( `Get data by object table` ).

    LOOP AT me->a_Tab_obj_connections INTO DATA(lso_tmp).

      DATA(l_Tabix) = sy-tabix.

      out->write( |Get data of object table tabix { sy-tabix } | ).
      TRY.
          DATA(lt_Data) = lso_tmp->get_db_data(   ).
          LOOP AT lt_data INTO DATA(ls_Data).
            out->write( |Carrier ID get of tabix { l_tabix }: { ls_data-carrier_id }| ).
            out->write( |Connection ID get tabix { l_tabix }: { ls_data-connection_id }| ).
          ENDLOOP.


          IF lt_data[] IS NOT INITIAL.

            lso_tmp->set_attributes( lt_data[] ).

          ENDIF.

        CATCH cx_Abap_invalid_value INTO DATA(lo_cx_1).
          out->write( |{ lo_cx_1->get_text(  ) } | ).
        CATCH cx_abap_sql_error INTO DATA(lo_cx_2).
          out->write( |{ lo_cx_2->get_text(  ) } | ).
        CATCH cx_uuid_error INTO DATA(lo_cx_uuid).
          out->write( |{ lo_cx_uuid->get_text( ) } | ).
      ENDTRY.

    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
