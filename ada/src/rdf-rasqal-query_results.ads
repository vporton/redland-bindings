with RDF.Auxiliary;
with RDF.Auxiliary.Limited_Handled_Record;
with RDF.Raptor.URI;
with RDF.Rasqal.World;
limited with RDF.Rasqal.Query;

package RDF.Rasqal.Query_Results is

   package Query_Results_Handled_Record is new RDF.Auxiliary.Limited_Handled_Record(RDF.Auxiliary.Dummy_Record, RDF.Auxiliary.Dummy_Record_Access);

   subtype Query_Results_Handle_Type is Query_Results_Handled_Record.Access_Type;

   type Query_Results_Type_Without_Finalize is new Query_Results_Handled_Record.Base_Object with null record;

   type Query_Results_Type_Enum is (Results_Bindings,
                                    Results_Boolean,
                                    Results_Graph,
                                    Results_Syntax,
                                    Results_Unknow);

   -- function Add_Row is deliberately not implemented

   not overriding function Finished (Results: Query_Results_Type_Without_Finalize) return Boolean;

   -- TODO: Stopped at rasqal_query_results_get_binding_name ()

   -- TODO: Iterators

   type Query_Results_Type is new Query_Results_Type_Without_Finalize with null record;

   overriding procedure Finalize_Handle (Object: Query_Results_Type; Handle: Query_Results_Handle_Type);

   not overriding function New_Query_Results (World: RDF.Rasqal.World.World_Type_Without_Finalize;
                                              Query: RDF.Rasqal.Query.Query_Type_Without_Finalize;
                                              Kind: Query_Results_Type_Enum)
                                              return Query_Results_Type;

   not overriding function From_String (World: RDF.Rasqal.World.World_Type_Without_Finalize;
                                        Kind: Query_Results_Type_Enum;
                                        Base_URI: RDF.Raptor.URI.URI_Type_Without_Finalize;
                                        Value: String)
                                        return Query_Results_Type;

end RDF.Rasqal.Query_Results;
