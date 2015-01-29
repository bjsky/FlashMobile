package potato.display3d
{
	import core.display3d.Material;
	import core.display3d.UVAnimation;
	import core.display3d.UVMatrix;
	
	import potato.potato_internal;
	import potato.display3d.core.GameObject;
	import potato.display3d.core.IGameContainer;
	import potato.display3d.core.IGameObject;
	import potato.display3d.data.MaterialData;
	import potato.display3d.data.PassData;
	
	/**
	 * 材质Gameobject包装
	 * @author liuxin
	 * 
	 */
	public class GameMaterial extends Material
		implements IGameObject
	{
		public function GameMaterial(data:MaterialData)
		{
			super(null);
			_data=data;
			setData();
		}
		use namespace potato_internal;
		
		private var _data:MaterialData;
		
		//////////////////////
		//  IGameObject
		///////////////////////
		private var _tag:String;
		potato_internal var _parentGameObject:IGameContainer;
		
		public function get parentGameObject():IGameContainer
		{
			return null;
		}
		
		public function set tag(name:String):void
		{	
			_tag=name;
		}
		
		public function get tag():String
		{
			return _tag;
		}
		
		public function dispose():void{
			GameObject.removeGameObjects(parentGameObject,this);
		}
		
		private function setData():void
		{
			if (_data)
			{
				var pd:PassData=_data.passes[0];
				blendMode=pd.blend;
				colorWrite=pd.colorWrite;
				depthWrite=pd.depthWrite;
				depthCheck=pd.depthCheck;
				depthBias=pd.depthBias;
				lightingEnabled=pd.lighting;
				specular=1;  //ps.ambient=ps.diffuse=
				//			ps.ambientColor=pd.ambient;
				color=pd.diffuse;
				specularColor=pd.specular;
				gloss=pd.gloss;
				alphaReject=pd.alphaReject;
				texture=Res3D.getTexture(pd.texture);
				if(pd.frameAnim){
					var uv:UVAnimation = new UVAnimation();
					uv.uTile = pd.frameAnim.x;
					uv.vTile = pd.frameAnim.y;
					uv.cycles = pd.frameAnim.z;
					this.uvMatrix=new UVMatrix();
					this.uvMatrix.frameAnim = uv;
				}
			}else{
				texture=Res3D.getDefaultTexture();
			}
		}
	}
}