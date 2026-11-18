*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations


CLASS lcl_prova_ld_01 IMPLEMENTATION.

  METHOD constructor.

    CLEAR: me->a_prm_tab_r_carrier_id[], me->a_prm_tab_r_connection_id[].
    IF p_id_carrier_im IS NOT INITIAL
    AND p_flag_use_default_im IS NOT INITIAL.
      APPEND VALUE #( sign = 'I' option = 'EQ' low = p_id_carrier_im ) TO me->a_prm_tab_r_carrier_id.
    ENDIF.
    IF p_id_connection_im IS NOT INITIAL
    AND p_flag_use_default_im IS NOT INITIAL.
      APPEND VALUE #( sign = 'I' option = 'EQ' low = p_id_connection_im ) TO me->a_prm_tab_r_connection_id.
    ENDIF.

  ENDMETHOD.

  METHOD set_Attributes.

* Local Tables

    DATA LT_zld_db_s4d400 TYPE TABLE OF zld_db_s4d400.

* B.o.M.
    CLEAR: lt_zld_db_s4d400[].

    IF pt_data_to_save_im[] IS NOT INITIAL.

      SELECT * FROM zld_db_s4d400
      FOR ALL ENTRIES IN @pt_Data_to_save_im
      WHERE carrier_id = @pt_data_to_save_im-carrier_id
        AND connection_id = @pt_data_to_save_im-connection_id
      INTO TABLE @DATA(lt_to_delete).

      IF lt_to_Delete[] IS NOT INITIAL.
        DELETE zld_db_s4d400 FROM TABLE @lt_to_delete[].
        IF sy-subrc = 0.
          COMMIT WORK AND WAIT.
        ENDIF.
      ENDIF.
      TRY.
          LOOP AT pt_data_to_save_im INTO DATA(ls_save).


            APPEND VALUE #( uuid = cl_system_uuid=>create_uuid_x16_static( )
                            carrier_id = ls_Save-carrier_id
                            connection_id = ls_save-connection_id
                            airport_from_id = ls_save-airport_from_id
                            airport_to_id   = ls_save-airport_to_id ) TO lt_zld_db_s4d400[].

          ENDLOOP.
        CATCH cx_uuid_error INTO DATA(lox_uuid_err).
          RAISE EXCEPTION lox_uuid_err.
      ENDTRY.
      MODIFY zld_db_s4d400 FROM TABLE @lt_zld_db_s4d400[].

      IF sy-subrc = 0.
        COMMIT WORK AND WAIT.
      ELSE.
        ROLLBACK WORK.
        RAISE EXCEPTION TYPE cx_abap_invalid_value EXPORTING value = 'Excpetion on save data'.
      ENDIF.

    ENDIF.
  ENDMETHOD.

  METHOD get_db_data.

    DATA(LT_carrier_r) = pt_id_carrier_r_im[].
    DATA(lt_connection_R) = pt_id_connection_r_im[].

    IF lt_carrier_R[] IS INITIAL
    AND p_flag_use_default_im IS NOT INITIAL.
      lt_carrier_r[] = me->a_prm_tab_r_carrier_id[].
    ENDIF.

    IF lt_connection_r[] IS INITIAL
    AND p_flag_use_default_im IS NOT INITIAL.
      lt_connection_r[] = me->a_prm_tab_r_connection_id[].
    ENDIF.

    SELECT FROM /dmo/connection
    FIELDS *
    WHERE carrier_id IN @lt_carrier_r[]
     AND connection_id IN @lt_connection_r[]
    INTO TABLE @DATA(lt_data) UP TO 5 ROWS.

    IF sy-subrc = 0.
      pt_get_data_rt[] = CORRESPONDING #( lt_Data[] ).
    ELSE.
      RAISE EXCEPTION TYPE cx_abap_sql_error
        EXPORTING
          explanation = 'Dati non trovati con tale seleizone'.
    ENDIF.

  ENDMETHOD.


ENDCLASS.
