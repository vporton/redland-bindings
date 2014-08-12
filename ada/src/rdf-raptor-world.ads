with Interfaces.C;
with RDF.Auxilary.Simple_Limited_Handled_Record;

package RDF.Raptor.World is

   type World_Type_Without_Finalize is new RDF.Auxilary.Simple_Limited_Handled_Record.Base_Object with null record;

   subtype Handle_Type is RDF.Auxilary.Simple_Limited_Handled_Record.Access_Type;

   type Flag_Type is (Libxml_Error_Save,
                      Libxml_Structured_Error_Save,
		      URI_Interning,
                      WWW_Skip_Init_Finish);
   for Flag_Type'Size use Interfaces.C.int'Size; -- hack
   for Flag_Type use (Libxml_Error_Save => 1,
                      Libxml_Structured_Error_Save => 2,
		      URI_Interning => 3,
                      WWW_Skip_Init_Finish => 4);

   type Flag_And_Value is
      record
         Flag : Flag_Type;
         Value: Boolean;
      end record;

   type Flags_Array is array(Integer range <>) of Flag_And_Value;

   overriding function Default_Handle(Object: World_Type_Without_Finalize) return Handle_Type;

   --overriding function From_Handle(Handle: RDF.Base.Dummy_Record_Access) return World with Inline;

   not overriding procedure Open(Object: World_Type_Without_Finalize);

   not overriding procedure Open(Object: World_Type_Without_Finalize; Flags: Flags_Array);

   not overriding function Open return World_Type_Without_Finalize;

   not overriding function Open(Flags: Flags_Array) return World_Type_Without_Finalize;

   not overriding procedure Set_Flag(Object: World_Type_Without_Finalize; Flag: Flag_Type; Value: Boolean);

   not overriding procedure Set_Flags(Object: World_Type_Without_Finalize; Flags: Flags_Array);

   -- Not implemented
   -- procedure Set_Libxslt_Security_Preferences

   type World_Type is new World_Type_Without_Finalize with null record;

   overriding procedure Finalize_Handle(Object: World_Type; Handle: Handle_Type);

   -- TODO

end RDF.Raptor.World;