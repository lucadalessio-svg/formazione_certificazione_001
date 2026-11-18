*"* use this source file for any type of declarations (class
*"* definitions, interfaces or type declarations) you need for
*"* components in the private section

*
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


CLASS lcl_info_flight DEFINITION.

  PUBLIC SECTION.

    METHODS: constructor IMPORTING pt_r_id_Carrier_im    TYPE ty_carrier_r_t OPTIONAL
                                   pt_r_id_connection_im TYPE ty_connection_r_t OPTIONAL
                         RAISING   cx_Abap_invalid_value,
      get_airports RETURNING VALUE(pt_airports_id_rt) TYPE zld_db_s4d400_t,
      get_cities   RETURNING VALUE(pt_cities_rt) TYPE zld_db_s4d400_t.

  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA: a_data_tab                TYPE zld_db_s4d400_t,
          a_data_str                TYPE zld_db_s4d400,
          a_prm_tab_r_carrier_id    TYPE ty_carrier_r_t,
          a_prm_tab_r_connection_id TYPE ty_connection_r_t.

ENDCLASS.
