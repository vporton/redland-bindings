with Interfaces.C; use Interfaces.C;
with RDF.Auxiliary.Limited_Handled_Record;
with RDF.Raptor.World; use RDF.Raptor.World;
with RDF.Raptor.IOStream; use RDF.Raptor.IOStream;
with RDF.Raptor.URI; use RDF.Raptor.URI;
with RDF.Raptor.Namespace; use RDF.Raptor.Namespace;
with RDF.Raptor.Statement; use RDF.Raptor.Statement;
with RDF.Raptor.Syntaxes; use RDF.Raptor.Syntaxes;
with RDF.Raptor.Log; use RDF.Raptor.Log;
with RDF.Raptor.Options; use RDF.Raptor.Options;

package RDF.Raptor.Serializer is

   package Serializer_Handled_Record is new RDF.Auxiliary.Limited_Handled_Record(RDF.Auxiliary.Dummy_Record, RDF.Auxiliary.Dummy_Record_Access);

   subtype Serializer_Handle is Serializer_Handled_Record.Access_Type;

   type Serializer_Type_Without_Finalize is new Serializer_Handled_Record.Base_Object with null record;

   overriding procedure Finalize_Handle (Serializer: Serializer_Type_Without_Finalize; Handle: Serializer_Handle);

   -- WARNING: Other order of arguments than in C
   not overriding procedure Start_To_IOStream (Serializer: Serializer_Type_Without_Finalize;
                                               IOStream: IOStream_Type_Without_Finalize'Class;
                                               URI: URI_Type_Without_Finalize'Class := URI_Type_Without_Finalize'(From_Handle(null)));

   not overriding procedure Start_To_Filename (Serializer: Serializer_Type_Without_Finalize; Filename: String);

   -- raptor_serializer_start_to_string() is deliberately not used.
   -- Use Stream_To_String instead.

   not overriding procedure Start_To_Filehandle (Serializer: Serializer_Type_Without_Finalize;
                                                 URI: URI_Type_Without_Finalize'Class;
                                                 FH: RDF.Auxiliary.C_File_Access);

   -- WARNING: Other order of arguments than in C
   not overriding procedure Set_Namespace (Serializer: in out Serializer_Type_Without_Finalize;
                                           Prefix: String;
                                           URI: URI_Type_Without_Finalize'Class := URI_Type_Without_Finalize'(From_Handle(null)));

   not overriding procedure Set_Namespace_Without_Prefix (Serializer: in out Serializer_Type_Without_Finalize;
                                                          URI: URI_Type_Without_Finalize'Class := URI_Type_Without_Finalize'(From_Handle(null)));

   not overriding procedure Set_Namespace (Serializer: in out Serializer_Type_Without_Finalize;
                                           Namespace: Namespace_Type_Without_Finalize'Class);

   not overriding procedure Serialize_Statement (Serializer: Serializer_Type_Without_Finalize;
                                                 Statement: Statement_Type_Without_Finalize'Class);

   not overriding procedure Serialize_End (Serializer: Serializer_Type_Without_Finalize);

   not overriding procedure Serialize_Flush (Serializer: Serializer_Type_Without_Finalize);

   not overriding function Get_Description (Serializer: Serializer_Type_Without_Finalize)
                                            return Raptor_Syntax_Description_Type;

   not overriding function Get_IOStream (Serializer: Serializer_Type_Without_Finalize)
                                         return IOStream_Type_Without_Finalize;

   not overriding function Get_Locator (Serializer: Serializer_Type_Without_Finalize)
                                        return Locator_Type;

   not overriding procedure Set_Option (Serializer: in out Serializer_Type_Without_Finalize;
                                        Option: Raptor_Option;
                                        Value: String);
   not overriding procedure Set_Option (Serializer: in out Serializer_Type_Without_Finalize;
                                        Option: Raptor_Option;
                                        Value: int);

   -- Not sure if we should be able to query here whether the option is numeric
   not overriding function Get_Numeric_Option (Serializer: Serializer_Type_Without_Finalize;
                                               Option: Raptor_Option)
                                               return Natural;
   not overriding function Get_String_Option (Serializer: Serializer_Type_Without_Finalize;
                                              Option: Raptor_Option)
                                              return String;

   not overriding function Get_World (Serializer: Serializer_Type_Without_Finalize)
                                      return Raptor_World_Type_Without_Finalize;

   package Handlers is new Serializer_Handled_Record.Common_Handlers(Serializer_Type_Without_Finalize);

   type Serializer_Type is new Handlers.Base_With_Finalization with null record;

   type Serializer_Type_User is new Handlers.User_Type with null record;

   not overriding function Create (World: Raptor_World_Type_Without_Finalize'Class)
                                   return Serializer_Type;
   not overriding function Create (World: Raptor_World_Type_Without_Finalize'Class;
                                   Syntax_Name: String)
                                   return Serializer_Type;

end RDF.Raptor.Serializer;
