with Interfaces.C; use Interfaces.C;
with Interfaces.C.Strings; use Interfaces.C.Strings;
with RDF.Auxiliary.C_String_Holders;

package body RDF.Rasqal.Query is

   function rasqal_query_add_data_graph (Query: Query_Handle_Type; Graph: RDF.Rasqal.Data_Graph.Data_Graph_Handle)
                                         return int
     with Import, Convention=>C;

   procedure Add_Data_Graph (Query: Query_Type_Without_Finalize;
                             Graph: RDF.Rasqal.Data_Graph.Data_Graph_Type_Without_Finalize) is
      use RDF.Rasqal.Data_Graph;
   begin
      if rasqal_query_add_data_graph (Get_Handle(Query), Get_Handle(Graph)) /= 0 then
         raise RDF.Auxiliary.RDF_Exception;
      end if;
   end;

   procedure Add_Data_Graphs (Query: Query_Type_Without_Finalize; Graphs: Data_Graphs_Array) is
   begin
      for Graph of Graphs loop
         Add_Data_Graph(Query, Graph);
      end loop;
   end;

   function rasqal_new_query (World: RDF.Rasqal.World.Handle_Type; Name, URI: chars_ptr) return Query_Handle_Type
     with Import, Convention=>C;

   function New_Query (World: RDF.Rasqal.World.World_Type; Name, URI: RDF.Auxiliary.String_Holders.Holder) return Query_Type is
      use RDF.Auxiliary.C_String_Holders;
      Name2: chars_ptr := New_String(Name);
      URI2 : chars_ptr := New_String(URI );
      use RDF.Rasqal.World;
      Result: constant Query_Handle_Type := rasqal_new_query(Get_Handle(World), Name2, URI2);
   begin
      Free(Name2);
      Free(URI2);
      return From_Non_Null_Handle(Result);
   end;

   procedure rasqal_free_query (Handle: Query_Handle_Type)
     with Import, Convention=>C;

   procedure Finalize_Handle (Query: Query_Type; Handle: Query_Handle_Type) is
   begin
      rasqal_free_query(Handle);
   end;

end RDF.Rasqal.Query;