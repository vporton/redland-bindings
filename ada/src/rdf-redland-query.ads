with Ada.Iterator_Interfaces;
with RDF.Auxiliary.Limited_Handled_Record;
with RDF.Raptor.Syntaxes; use RDF.Raptor.Syntaxes;
with RDF.Redland.World; use RDF.Redland.World;
with RDF.Redland.URI; use RDF.Redland.URI;

package RDF.Redland.Query is

   package Query_Handled_Record is new RDF.Auxiliary.Limited_Handled_Record(RDF.Auxiliary.Dummy_Record, RDF.Auxiliary.Dummy_Record_Access);

   type Query_Type_Without_Finalize is new RDF.Redland.Query.Query_Handled_Record.Base_Object with null record;

   subtype Query_Handle is Query_Handled_Record.Access_Type;

   overriding procedure Finalize_Handle (Object: Query_Type_Without_Finalize; Handle: Query_Handle);

--     overriding function Adjust_Handle (Object: Query_Type_Without_Finalize; Handle: Query_Handle) return Query_Handle;

   function Get_Query_Language_Description (World: Redland_World_Type_Without_Finalize'Class;
                                            Counter: Natural)
                                            return Raptor_Syntax_Description_Type;

   type Query_Language_Description_Cursor is private;

   function Get_Position (Cursor: Query_Language_Description_Cursor) return Natural;

   function Get_Description (Cursor: Query_Language_Description_Cursor) return Raptor_Syntax_Description_Type;

   function Has_Element (Position: Query_Language_Description_Cursor) return Boolean;

   package Query_Language_Description_Iterators is new Ada.Iterator_Interfaces(Query_Language_Description_Cursor, Has_Element);

   type Query_Language_Description_Iterator is new Query_Language_Description_Iterators.Forward_Iterator with private;

   overriding function First (Object: Query_Language_Description_Iterator) return Query_Language_Description_Cursor;
   overriding function Next (Object: Query_Language_Description_Iterator; Position: Query_Language_Description_Cursor)
                             return Query_Language_Description_Cursor;

   function Create_Query_Language_Descriptions_Iterator (World: Redland_World_Type_Without_Finalize'Class)
                                                         return Query_Language_Description_Iterator;

   -- TODO: How to do this without a circular dependency?
--     not overriding function Execute (Query: Query_Type_Without_Finalize;
--                                      Model: Model_Type_Without_Finalize'Class)
--                                      return Query_Results_Type;

   package Handlers is new Query_Handled_Record.Common_Handlers(Query_Type_Without_Finalize);

   type Query_Type is new Handlers.Base_With_Finalization with null record;

   type Query_Type_User is new Handlers.User_Type with null record;

   -- Order of arguments not the same as in C
   not overriding
   function Create (World: Redland_World_Type_Without_Finalize'Class;
                    Name: String;
                    Query_String: String;
                    URI, Base_URI: URI_Type_Without_Finalize'Class := URI_Type_Without_Finalize'(From_Handle(null)))
                    return Query_Type;

   -- It seems that this is buggy (see count_test2.adb)
   not overriding function Copy (Query: Query_Type_Without_Finalize'Class) return Query_Type;

private

   type Query_Language_Description_Cursor is
      record
         World: Redland_World_Handle;
         Position: Natural;
      end record;

   type Query_Language_Description_Iterator is new Query_Language_Description_Iterators.Forward_Iterator with
      record
         World: Redland_World_Handle;
      end record;

end RDF.Redland.Query;
