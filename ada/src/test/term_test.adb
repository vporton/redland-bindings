with AUnit.Assertions; use AUnit.Assertions;
with RDF.Raptor.URI; use RDF.Raptor.URI;
with RDF.Raptor.Term; use RDF.Raptor.Term;
with RDF.Raptor.World; use RDF.Raptor.World;
with RDF.Auxiliary;

package body Term_Test is

   procedure Test_Terms(T : in out Test_Cases.Test_Case'Class) is
      World: Raptor_World_Type;

      Term_1: Term_Type := From_Literal (World,
                                         RDF.Auxiliary.String_Holders.To_Holder("QWE"),
                                         From_String(World, "http://example.org"), -- datatype
                                         RDF.Auxiliary.String_Holders.Empty_Holder -- language
                                        );
      Term_2: Term_Type := From_URI_String(World, "http://example.org/abc");
      Term_3: Term_Type := From_URI(World, From_String(World, "http://example.org/cvb"));
      Term_4: Term_Type := From_String(World, """ZZZ"""); -- Turtle string
   begin
      Assert(Value(Get_Literal(Term_1)) = "QWE", "Term_1 value");
      Assert(To_String(Get_URI(Term_2)) = "http://example.org/abc", "Term_2 URI");
      Assert(To_String(Get_URI(Term_3)) = "http://example.org/cvb", "Term_3 URI");
      Assert(Value(Get_Literal(Term_4)) = "ZZZ", "Term_4 value");
      Assert(To_String(Datatype(Get_Literal(Term_1))) = "http://example.org", "Term_1 datatype"); -- infinite loop! why?
      Assert(Term_1 /= Term_2, "Non-equal terms");
      Assert(Get_Kind(Term_1) = Literal, "Term_1 is literal");
      Assert(Get_Kind(Term_2) = URI, "Term_2 is URI");
      Assert(Get_Kind(Term_3) = URI, "Term_3 is URI");
      Assert(Get_Kind(Term_4) = Literal, "Term_4 is literal");
   end;

   function Name (T : Test_Case)
                  return Test_String is
   begin
      return Format ("RDF terms");
   end Name;

   procedure Register_Tests (T : in out Test_Case) is
      use AUnit.Test_Cases.Registration;
   begin
      Register_Routine (T, Test_Terms'Access, "Testing terms");
   end Register_Tests;

end Term_Test;
