with AUnit, AUnit.Test_Cases; use AUnit, AUnit.Test_Cases;

package Constants_Test is

   type Test_Case is new AUnit.Test_Cases.Test_Case with null record;

   procedure Register_Tests (T : in out Test_Case);
   --  Register routines to be run

   function Name (T : Test_Case)
                  return Test_String;
   --  Returns name identifying the test case

end Constants_Test;
