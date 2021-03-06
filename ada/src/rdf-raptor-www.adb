with Ada.Unchecked_Conversion;
with Interfaces.C; use Interfaces.C;
with Interfaces.C.Strings; use Interfaces.C.Strings;
with RDF.Auxiliary.Convert_Void;
with RDF.Auxiliary.C_Pointers;
with RDF.Raptor.Memory;
with RDF.Auxiliary.Convert; use RDF.Auxiliary.Convert;

package body RDF.Raptor.WWW is

   type C_Func is access procedure (WWW: WWW_Handle; Value: chars_ptr)
     with Convention=>C;

   procedure Set_Or_Null (Func: C_Func; WWW: WWW_Type_Without_Finalize; Value: String) is
   begin
      if Value /= "" then
         declare
            Str: aliased char_array := To_C(Value);
         begin
            Func.all(Get_Handle(WWW), To_Chars_Ptr(Str'Unchecked_Access));
         end;
      else
         Func.all(Get_Handle(WWW), Null_Ptr);
      end if;
   end;

   procedure raptor_www_set_user_agent (WWW: WWW_Handle; User_Agent: chars_ptr)
     with Import, Convention=>C;

   procedure Set_User_Agent (WWW: in out WWW_Type_Without_Finalize; User_Agent: String) is
   begin
      Set_Or_Null(raptor_www_set_user_agent'Access, WWW, User_Agent);
   end;

   procedure raptor_www_set_proxy (WWW: WWW_Handle; Proxy: char_array)
     with Import, Convention=>C;

   procedure Set_Proxy (WWW: in out WWW_Type_Without_Finalize; Proxy: String) is
   begin
      raptor_www_set_proxy(Get_Handle(WWW), To_C(Proxy));
   end;

   procedure raptor_www_set_http_accept (WWW: WWW_Handle; Value: chars_ptr)
     with Import, Convention=>C;

   procedure Set_HTTP_Accept (WWW: in out WWW_Type_Without_Finalize; Value: String) is
   begin
      Set_Or_Null(raptor_www_set_http_accept'Access, WWW, Value);
   end;

   -- FIXME: raptor_www_set_http_cache_control (with _www_ and _http_)?
   procedure raptor_set_cache_control (WWW: WWW_Handle; Cache_Control: chars_ptr)
     with Import, Convention=>C;

   -- FIXME: return value of raptor_set_cache_control()
   procedure Set_Cache_Control (WWW: in out WWW_Type_Without_Finalize; Cache_Control: String) is
      Str: aliased char_array := To_C(Cache_Control);
   begin
      raptor_set_cache_control(Get_Handle(WWW), To_Chars_Ptr(Str'Unchecked_Access));
   end;

   -- Remove Cache-Control: header altogether
   procedure Unset_Cache_Control (WWW: in out WWW_Type_Without_Finalize) is
   begin
      raptor_set_cache_control(Get_Handle(WWW), Null_Ptr);
   end;

   procedure raptor_www_set_connection_timeout (WWW: WWW_Handle; Timeout: int)
     with Import, Convention=>C;

   procedure Set_Connection_Timeout (WWW: in out WWW_Type_Without_Finalize; Timeout: Natural) is
   begin
      raptor_www_set_connection_timeout(Get_Handle(WWW), int(Timeout));
   end;

   function raptor_www_get_final_uri (WWW: WWW_Handle) return URI_Handle
     with Import, Convention=>C;

   function Get_Final_URI (WWW: WWW_Type_Without_Finalize) return URI_Type is
   begin
      -- may return object with NULL handle
      return From_Handle(raptor_www_get_final_uri(Get_Handle(WWW)));
   end;

   function raptor_www_fetch (WWW: WWW_Handle; URI: URI_Handle) return int
     with Import, Convention=>C;

   procedure Fetch (WWW: WWW_Type_Without_Finalize; URI: URI_Type_Without_Finalize'Class) is
   begin
      if raptor_www_fetch(Get_Handle(WWW), Get_Handle(URI)) /= 0 then
         raise RDF.Auxiliary.RDF_Exception;
      end if;
   end;

   type String_P_Type is access all chars_ptr with Convention=>C;
   type String_P_Type2 is access all RDF.Auxiliary.C_Pointers.Pointer with Convention=>C;

   function Convert2 is new Ada.Unchecked_Conversion(String_P_Type, String_P_Type2);

   function raptor_www_fetch_to_string (WWW: WWW_Handle;
                                        URI: URI_Handle;
                                        String_P: access chars_ptr;
                                        Length_P: access size_t;
                                        Malloc_Handler: chars_ptr) return int
     with Import, Convention=>C;

   function Fetch_To_String(WWW: WWW_Type_Without_Finalize; URI: URI_Type_Without_Finalize'Class)
                            return String is
      String_P: aliased chars_ptr;
      Length_P: aliased size_t;
   begin
      if raptor_www_fetch_to_string(Get_Handle(WWW), Get_Handle(URI), String_P'Access, Length_P'Access, Null_Ptr) /= 0 then
         raise RDF.Auxiliary.RDF_Exception;
      end if;
      declare
         Result: constant String := Value_With_Possible_NULs(Convert2(String_P'Unchecked_Access).all, Length_P);
      begin
         RDF.Raptor.Memory.raptor_free_memory(String_P);
         return Result;
      end;
   end;

   function raptor_www_get_connection (WWW: WWW_Handle) return Connection_Type
     with Import, Convention=>C;

   function Get_Connection (WWW: WWW_Type_Without_Finalize) return Connection_Type is
   begin
      return raptor_www_get_connection(Get_Handle(WWW));
   end;

   function raptor_www_set_ssl_cert_options (WWW: WWW_Handle;
                                             Cert_Filename, Cert_Type, Cert_Passphrase: char_array)
                                             return int
     with Import, Convention=>C;

   procedure Set_SSL_Cert_Options (WWW: in out WWW_Type_Without_Finalize;
                                   Cert_Filename, Cert_Type, Cert_Passphrase: String) is
   begin
      if raptor_www_set_ssl_cert_options(Get_Handle(WWW), To_C(Cert_Filename), To_C(Cert_Type), To_C(Cert_Passphrase)) /= 0 then
         raise RDF.Auxiliary.RDF_Exception;
      end if;
   end;

   function raptor_www_set_ssl_verify_options (WWW: WWW_Handle; Verify_Peer, Verify_Host: int) return int
     with Import, Convention=>C;

   procedure Set_SSL_Verify_Options (WWW: in out WWW_Type_Without_Finalize;
                                     Verify_Peer, Verify_Host: Boolean) is
   begin
      if raptor_www_set_ssl_verify_options(Get_Handle(WWW),
                                           (if Verify_Peer then 1 else 0),
                                           (if Verify_Host then 1 else 0)) /= 0
      then
         raise RDF.Auxiliary.RDF_Exception;
      end if;
   end;

   procedure raptor_www_abort (WWW: WWW_Handle; Reason: char_array)
     with Import, Convention=>C;

   procedure Abort_Operation (WWW: WWW_Type_Without_Finalize; Reason: String) is
   begin
      raptor_www_abort(Get_Handle(WWW), To_C(Reason));
   end;

   function raptor_new_www (World: Raptor_World_Handle) return WWW_Handle
     with Import, Convention=>C;

   function Create (World: Raptor_World_Type'Class) return WWW_Type is
   begin
      return From_Non_Null_Handle(raptor_new_www(Get_Handle(World)));
   end;

   function raptor_new_www_with_connection (World: Raptor_World_Handle;
                                            Connection: Connection_Type)
                                            return WWW_Handle
     with Import, Convention=>C;

   function Create (World: Raptor_World_Type'Class; Connection: Connection_Type) return WWW_Type is
   begin
      return From_Non_Null_Handle(raptor_new_www_with_connection(Get_Handle(World), Connection));
   end;

   procedure raptor_free_www (Handle: WWW_Handle)
     with Import, Convention=>C;

   procedure Finalize_Handle (Object: WWW_Type_Without_Finalize; Handle: WWW_Handle) is
   begin
      raptor_free_www(Handle);
   end;

--     type User_Defined_Access is access constant WWW_Type_Without_Finalize'Class;
   package My_Conv is new RDF.Auxiliary.Convert_Void(WWW_Type_Without_Finalize'Class);

   type raptor_www_write_bytes_handler is access procedure (WWW: WWW_Handle;
                                                            User_data: chars_ptr;
                                                            Ptr: RDF.Auxiliary.C_Pointers.Pointer;
                                                            Size, Nmemb: size_t)
     with Convention=>C;

   type raptor_www_content_type_handler is access procedure (WWW: WWW_Handle;
                                                             User_data: chars_ptr;
                                                             Content_Type: chars_ptr)
     with Convention=>C;

   type raptor_www_uri_filter_func is access function (User_data: chars_ptr; URI: URI_Handle) return int
     with Convention=>C;

   type raptor_www_final_uri_handler is access procedure (WWW: WWW_Handle;
                                                          User_data: chars_ptr;
                                                          URI: URI_Handle)
     with Convention=>C;

   procedure Write_Bytes_Handler_Impl (WWW: WWW_Handle;
                                       User_data: chars_ptr;
                                       Ptr: RDF.Auxiliary.C_Pointers.Pointer;
                                       Size, Nmemb: size_t)
     with Convention=>C;

   procedure Content_Type_Handler_Impl (WWW: WWW_Handle; User_data: chars_ptr; Content_Type: chars_ptr)
     with Convention=>C;

   function URI_Filter_Impl (User_data: chars_ptr; URI: URI_Handle) return int
     with Convention=>C;

   procedure Final_URI_Handler_Impl (WWW: WWW_Handle; User_data: chars_ptr; URI: URI_Handle)
     with Convention=>C;

   procedure Write_Bytes_Handler_Impl (WWW: WWW_Handle;
                                       User_data: chars_ptr;
                                       Ptr: RDF.Auxiliary.C_Pointers.Pointer;
                                       Size, Nmemb: size_t) is
   begin
      Write_Bytes_Handler(--WWW_Type_Without_Finalize'(From_Handle(WWW)), -- ignored
                          My_Conv.To_Access(User_Data).all,
                          Value_With_Possible_NULs(Ptr, Size*Nmemb));
   end;

   procedure Content_Type_Handler_Impl (WWW: WWW_Handle; User_data: chars_ptr; Content_Type: chars_ptr) is
   begin
      Content_Type_Handler(--WWW_Type_Without_Finalize'(From_Handle(WWW)), -- ignored
                           My_Conv.To_Access(User_Data).all,
                           Value(Content_Type));
   end;

   function URI_Filter_Impl (User_data: chars_ptr; URI: URI_Handle) return int is
      Result: constant Boolean := URI_Filter(My_Conv.To_Access(User_Data).all,
                                             URI_Type_Without_Finalize'(From_Non_Null_Handle(URI)));
   begin
      return (if Result then 0 else 1);
   end;

   procedure Final_URI_Handler_Impl (WWW: WWW_Handle; User_Data: chars_ptr; URI: URI_Handle) is
   begin
      Final_URI_Handler(--WWW_Type_Without_Finalize'(From_Handle(WWW)), -- ignored
                        My_Conv.To_Access(User_Data).all,
                        URI_Type_Without_Finalize'(From_Handle(URI)));
   end;

   procedure Initialize_All_Callbacks (WWW: in out WWW_Type_Without_Finalize) is
   begin
      Initialize_Write_Bytes_Handler(WWW);
      Initialize_Content_Type_Handler(WWW);
      Initialize_URI_Filter(WWW);
      Initialize_Final_URI_Handler(WWW);
   end;

   procedure raptor_www_set_write_bytes_handler(WWW: WWW_Handle;
                                                Handler: raptor_www_write_bytes_handler;
                                                User_Data: chars_ptr)
     with Import, Convention=>C;

   procedure Initialize_Write_Bytes_Handler (WWW: in out WWW_Type_Without_Finalize) is
   begin
      raptor_www_set_write_bytes_handler(Get_Handle(WWW),
                                         Write_Bytes_Handler_Impl'Access,
                                         My_Conv.To_C_Pointer(WWW'Unchecked_Access));
   end;

   procedure raptor_www_set_content_type_handler (WWW: WWW_Handle;
                                                  Handler: raptor_www_content_type_handler;
                                                  User_Data: chars_ptr)
     with Import, Convention=>C;

   procedure raptor_www_set_final_uri_handler (WWW: WWW_Handle;
                                               Handler: raptor_www_final_uri_handler;
                                               User_Data: chars_ptr)
     with Import, Convention=>C;

   procedure Initialize_Content_Type_Handler (WWW: in out WWW_Type_Without_Finalize) is
   begin
      raptor_www_set_content_type_handler(Get_Handle(WWW),
                                          Content_Type_Handler_Impl'Access,
                                          My_Conv.To_C_Pointer(WWW'Unchecked_Access));
   end;

   procedure raptor_www_set_uri_filter (WWW: WWW_Handle;
                                        Handler: raptor_www_uri_filter_func;
                                        User_Data: chars_ptr)
     with Import, Convention=>C;

   procedure Initialize_URI_Filter (WWW: in out WWW_Type_Without_Finalize) is
   begin
      raptor_www_set_uri_filter(Get_Handle(WWW), URI_Filter_Impl'Access, My_Conv.To_C_Pointer(WWW'Unchecked_Access));
   end;

   procedure Initialize_Final_URI_Handler (WWW: in out WWW_Type_Without_Finalize) is
   begin
      raptor_www_set_final_uri_handler(Get_Handle(WWW), Final_URI_Handler_Impl'Access, My_Conv.To_C_Pointer(WWW'Unchecked_Access));
   end;

end RDF.Raptor.WWW;
