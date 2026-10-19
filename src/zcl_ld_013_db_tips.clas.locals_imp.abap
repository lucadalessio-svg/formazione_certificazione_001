*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations


TYPES: BEGIN OF ty_carrier_r_s,
         sign   TYPE ddsign,
         option TYPE ddoption,
         low    TYPE /dmo/carrier_id,
         high   TYPE /dmo/carrier_id,
       END OF ty_carrier_r_s,
       ty_carrier_r_t TYPE TABLE OF ty_carrier_r_s.

TYPES: BEGIN OF ty_connection_r_s,
         sign   TYPE ddsign,
         option TYPE ddoption,
         low    TYPE /dmo/connection_id,
         high   TYPE /dmo/connection_id,
       END OF ty_connection_r_s,
       ty_connection_r_t TYPE TABLE OF ty_connection_r_s.

CLASS lcl_prova_ld_01 DEFINITION.

  PUBLIC SECTION.

    METHODS: constructor IMPORTING p_id_Carrier_im       TYPE /dmo/carrier_id OPTIONAL
                                   p_id_connection_im    TYPE /dmo/connection_id OPTIONAL
                                   p_flag_use_default_im TYPE abap_boolean DEFAULT 'X',

      set_attributes IMPORTING pt_Data_to_save_im TYPE zld_db_my_conn_t OPTIONAL
                     RAISING   cx_Abap_invalid_value,

      get_db_data IMPORTING pt_id_Carrier_r_im    TYPE ty_carrier_r_t OPTIONAL
                            pt_id_connection_r_im TYPE ty_connection_r_t OPTIONAL
                            p_flag_use_default_im TYPE abap_boolean DEFAULT 'X'
                  RETURNING VALUE(pt_get_Data_rt) TYPE zld_db_my_conn_t
                  RAISING   cx_abap_sql_error.

  PROTECTED SECTION.

  PRIVATE SECTION.

    DATA: a_data_tab                TYPE zld_db_my_conn_t,
          a_prm_tab_r_carrier_id    TYPE ty_carrier_r_t,
          a_prm_tab_r_connection_id TYPE ty_connection_r_t.

ENDCLASS.

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


    delete from zld_db_my_conn.

    IF pt_data_to_save_im[] IS NOT INITIAL.

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
