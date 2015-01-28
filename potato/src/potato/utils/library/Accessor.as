package potato.utils.library
{
	public class Accessor
	{
		public static const ACCESS_READONLY:int = 1;
		public static const ACCESS_WRITEONLY:int = 2;
		public static const ACCESS_READWRITE:int = 3;
		
		
		public var name:String;
		public var access:int;
		public var type:String;
		public var declaredBy:String;
		
		public function Accessor(_name:String="",_type:String="",_access:int=3,_declaredBy:String="")
		{
			declaredBy = _declaredBy;
			access = _access;
			type = _type;
			name = _name;
		}
	}
}