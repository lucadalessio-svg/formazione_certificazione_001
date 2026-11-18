*"* use this source file for any type of declarations (class
*"* definitions, interfaces or type declarations) you need for
*"* components in the private section

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
