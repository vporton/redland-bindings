with Interfaces.C; use Interfaces.C;
with RDF.Auxilary.My_Indefinite_Holders;

package RDF.Auxilary.C_String_Holders is

   -- TODO: Should something in this package be made private?

   package Char_Array_Holders is new RDF.Auxilary.My_Indefinite_Holders(char_array);

   type C_String_Holder is new Char_Array_Holders.Holder with null record;

   function Length (Object: C_String_Holder) return size_t;

   function New_String (Value: String_Holders.Holder) return chars_ptr;

   function To_C_String_Holder (Item: String_Holders.Holder) return C_String_Holder;

   function C_String (Object: C_String_Holder) return chars_ptr;

end RDF.Auxilary.C_String_Holders;