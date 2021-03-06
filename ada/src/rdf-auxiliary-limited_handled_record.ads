with Ada.Finalization;

generic
   type Record_Type; -- It should be a convention C record
   type Record_Type_Access is access Record_Type;  -- It should be a convention C access type
package RDF.Auxiliary.Limited_Handled_Record is

   -- Does not compile because https://gcc.gnu.org/bugzilla/show_bug.cgi?id=62235
   --    subtype Access_Type is access Record_Type
   --       with Convention=>C;

   subtype Access_Type is Record_Type_Access;

   -- It is logically abstract, but not exactly abstract in Ada sense.
   -- It can't be abstract because the function From_Handle returns this type.
   type Base_Object is new Ada.Finalization.Limited_Controlled with private;

   overriding procedure Initialize(Object: in out Base_Object);

   not overriding procedure Do_Finalize(Object: in out Base_Object);

   -- Don't call this procedure unless you really need it.
   not overriding procedure Set_Handle_Hack(Object: in out Base_Object; Handle: Access_Type);

   not overriding function Get_Handle(Object: Base_Object) return Access_Type;

   not overriding function From_Handle(Handle: Access_Type) return Base_Object;

   not overriding function From_Non_Null_Handle(Handle: Access_Type) return Base_Object;

   not overriding function Default_Handle(Object: Base_Object) return Access_Type;

   not overriding procedure Finalize_Handle(Object: Base_Object; Handle: Access_Type) is null;

   not overriding function Is_Null (Object: Base_Object) return Boolean;

   generic
      type Base is new Base_Object with private;
   package Common_Handlers is
      type User_Type is new Base with null record;
      overriding procedure Finalize(Object: in out User_Type)
                                    renames Do_Finalize;
      type Base_With_Finalization is new User_Type with null record;
      -- "Detach" API is experimental
      procedure Detach(Object: in out Base_With_Finalization);
      function Detach(Object: in out Base_With_Finalization) return Base;
   end;

private

   type Base_Object is new Ada.Finalization.Limited_Controlled with
      record
         Handle: Access_Type;
      end record;

end RDF.Auxiliary.Limited_Handled_Record;
