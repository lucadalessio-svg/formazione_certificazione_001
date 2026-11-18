*"* use this source file for your ABAP unit test classes

class ltcl_Prova_001 definition final for testing
  duration short
  risk level harmless.

  private section.
    methods:
      success_test for testing raising cx_static_check,
      exception_test for testing.

endclass.


class ltcl_Prova_001 implementation.

  method success_test.




  endmethod.

  method exception_test.

  endmethod.

endclass.

