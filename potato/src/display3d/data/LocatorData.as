package potato.display3d.data
{
	import flash.net.registerClassAlias;
	
	import core.display3d.Vector3D;
	

	public class LocatorData
	{
		/*
		<Locator name="武器绑定点_01" bonename=""  x="5.290020" y="93.045799" z="0.000000" qx="1.000000" qy="0.000000" qz="0.000000" qw="0.000000">
			<Slot name="RightWeaponObj" object="武器_刺_03_01.obj" attribs=""/>
		</Locator>
		*/
		
		public var name:String;
		public var bonename:String;
		public var pos:Vector3D;
		public var rotation:Vector3D;//z,w已取反
		public var object:String;
		public var attribs:String;
		
		/** 绑定物向量**/
		public var slotVector:Vector.<Vector3D>;
		
		public static function registerAlias():void
		{
			registerClassAlias("potato.mirage3d.data.LocatorData",LocatorData);
			Vector3D.registerAlias();
		}
	}
}