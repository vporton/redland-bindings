with Interfaces.C; use Interfaces.C;
with Interfaces.C.Strings; use Interfaces.C.Strings;
with RDF.Raptor.URI; use RDF.Raptor.URI;
with RDF.Raptor.World;

package RDF.Raptor.Log is

   type Log_Level_Type is (None, Trace, Debug, Info, Warn, Error, Fatal);
   for Log_Level_Type'Size use Interfaces.C.int'Size; -- hack
   for Log_Level_Type use (None => 0,
                           Trace => 1,
                           Debug => 2,
                           Info => 3,
                           Warn => 4,
                           Error => 5,
                           Fatal => 6);
   function Last return Log_Level_Type renames Fatal;

   type Domain_Type is (None,
                        Iostream,
                        Namespace,
                        Parser,
                        Qname,
                        Sax2,
                        Serializer,
                        Term,
                        Turtle_Writer,
                        URI,
                        World_Domain,
                        WWW,
                        XML_Writer);
   for Domain_Type'Size use Interfaces.C.int'Size; -- hack
   for Domain_Type use (None => 0,
                        Iostream => 1,
                        Namespace => 2,
                        Parser => 3,
                        Qname => 4,
                        Sax2 => 5,
                        Serializer => 6,
                        Term => 7,
                        Turtle_Writer => 8,
                        URI => 9,
                        World_Domain => 10,
                        WWW => 11,
                        XML_Writer => 12);
   function Last return Domain_Type renames XML_Writer;

   type Locator_Type is private;

   type Log_Message_Type is private;

   function Get_URI (Locator: Locator_Type) return URI_Type_Without_Finalize;

   function Get_File (Locator: Locator_Type) return String;

   function Get_Line   (Locator: Locator_Type) return Natural;
   function Get_Column (Locator: Locator_Type) return Natural;
   function Get_Byte   (Locator: Locator_Type) return Natural;

   function Get_Error_Code (Message: Log_Message_Type) return int;
   function Get_Domain (Message: Log_Message_Type) return Domain_Type;
   function Get_Log_Level (Message: Log_Message_Type) return Log_Level_Type;
   function Get_Text (Message: Log_Message_Type) return String;
   function Get_Locator (Message: Log_Message_Type) return Locator_Type;

   type Log_Handler is abstract tagged null record;

   procedure Log_Message(Handler: Log_Handler; Info: Log_Message_Type) is abstract;

   procedure Set_Log_Handler(World: RDF.Raptor.World.World_Type_Without_Finalize'Class; Handler: in out Log_Handler);

   function Get_Label (Level: Log_Level_Type) return String;
   function Get_Label (Level: Domain_Type) return String;

private

   type Locator_Type is
      record
         URI: RDF.Raptor.URI.Handle_Type;
         File: chars_ptr;
         Line, Column, Byte: int;
      end record
      with Convention => C;

   type Log_Message_Type is
      record
         Code: Interfaces.C.int;
         Domain: Domain_Type;
         Log_Level: Log_Level_Type;
         Locator: access Locator_Type;
         Text: chars_ptr;
      end record
      with Convention => C;

end RDF.Raptor.Log;
