with Interfaces.C; use Interfaces.C;
with RDF.Auxiliary;

package body RDF.Redland.URI is

   function librdf_new_uri2 (World: Redland_World_Handle; URI: char_array; Length: size_t)
                             return URI_Handle
     with Import, Convention=>C;

   function From_String (World: Redland_World_Type_Without_Finalize'Class; URI: URI_String)
                         return URI_Type is
      Handle: constant URI_Handle :=
        librdf_new_uri2(Get_Handle(World), To_C(String(URI), Append_Nul=>False), URI'Length);
   begin
      return From_Non_Null_Handle(Handle);
   end;

   function librdf_new_uri_from_uri (Old_URI: URI_Handle) return URI_Handle
     with Import, Convention=>C;

   procedure Adjust(Object: in out URI_Type) is
      use RDF.Auxiliary;
   begin
      if Get_Handle(Object) /= null then
         Set_Handle_Hack(Object, librdf_new_uri_from_uri(Get_Handle(Object)));
      end if;
   end;

end RDF.Redland.URI;
