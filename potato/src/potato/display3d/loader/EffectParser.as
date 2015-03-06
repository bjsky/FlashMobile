package potato.display3d.loader
{
	import flash.utils.Dictionary;
	
	import core.display3d.Matrix3D;
	import core.display3d.Quaternion;
	import core.display3d.Vector3D;
	
	import potato.display3d.data.EffectData;
	import potato.display3d.data.ElemData;
	import potato.display3d.data.MeshElemData;
	import potato.display3d.data.ParticleElemData;
	import potato.display3d.data.behaviour.NcBillboardData;
	import potato.display3d.data.behaviour.NcCurveAnimationData;
	import potato.display3d.data.behaviour.NcInfoCurveData;
	import potato.display3d.data.behaviour.NcRotationData;
	import potato.display3d.data.behaviour.NcUvAnimationData;
	
	
	/**
	 * 效果文件解析 
	 * @author superFlash
	 * 
	 */
	public class EffectParser extends TxtParser
	{
		private var _curEffectData:EffectData;
		private var _currEffectElemData:ElemData;
		
		private var _meshArr:Array = [];
		
		private var _elemNs:Dictionary = new Dictionary();
		
		public function EffectParser()
		{
			isAscii=true;
		}
		
		public function parse(path:String):EffectData//Vector.<EffectData>
		{
			loadFile(path);
			
//			var _effectArr:Vector.<EffectData>= new Vector.<EffectData>();
			for (;;) {
				var word:String=readWord();
				if (!word)
					break;
				if (word=="effect") {
					_curEffectData=new EffectData();
					readEffect();
//					_effectArr.push(_curEffectData);
				} else if (word=="particle") {
					return _curEffectData;
				}else
					throwUnexpect(word);
			}
			
			return _curEffectData;
		}
		
		private function readEffect():void
		{
			var name:String=readNoBlank();
			_curEffectData.effectName=name;
			
			_curEffectData.effectElemDataArr=new Vector.<ElemData>();
			
			expectWord("{");
			
			for (;;) {
				var word:String=readNoBlank();
				if (word=="}")
					break;
				if (word=="element") {
					//递增索引号
					
					readElem(null);
					
				} else if (word=="LifeTime") {
					_curEffectData.lifeTime=readNumber()*1000;
					///////////////////////////////DELETE_WHILE_FIXED//////////////////////////////////////////////////
					//TODO:对之前易乐做的技能的临时补丁
					//易乐使用的旧版技能编辑器，时间0表示无限时间，而现在的引擎对0的解释是没有时间，而-1表示无限时间；
					if(_curEffectData.lifeTime<=0){
						_curEffectData.lifeTime=0;
					}
					///////////////////////////////END_OF_DELETE_WHILE_FIXED//////////////////////////////////////////////////
				} else
					throwUnexpect(word);
			}
			if (_curEffectData.effectElemDataArr.length<1)
				trace("特效 "+_curEffectData.effectName+" 为空");
//				throw new Error("特效 "+_curEffectData.effectName+" 为空");
		}
		
		private function readElem(_curElemData:ElemData,isElem:Boolean=false):void
		{
			var word:String;
			word=readNoBlank();
			if(word=="Particle"){
				_currEffectElemData = readParticle();
			}else if(word=="Container"){
				_currEffectElemData = readContainer();
			}else if(word == "Mesh"){
				_currEffectElemData = readMesh();
			}
			else{
				jumpAffector();;
			}
			if(!isElem)_curEffectData.effectElemDataArr.push(_currEffectElemData);
			else _curElemData.effectElemDataArr.push(_currEffectElemData);
		}
		private function readContainer():ElemData{
			var elemData:ElemData=new ElemData();
			var word:String;
			expectWord("{");
			var end:Boolean=false;
			while (!end) {
				word =readNoBlank();
				switch (word) {
					case "Position":
						var px:Number=readNumber();
						var py:Number=readNumber();
						var pz:Number=-readNumber();
						elemData.positon=new Vector3D(px,py,pz);
						break;
					case "Orientation":
						var qw:Number=readNumber();
						var qx:Number=readNumber();
						var qy:Number=readNumber();
						var qz:Number=readNumber();
						
						var matrixOL:Matrix3D;
						var quat:Quaternion = new Quaternion(qx, qy, -qz, -qw);
						matrixOL = quat.toMatrix3D();
						var vec3:Vector.<Vector3D> = matrixOL.decompose();
						//这里是轴角
						elemData.orientation=new Vector3D(vec3[1].x,vec3[1].y,vec3[1].z);
						break;
					case "Scale":
						var sx:Number = readNumber();
						var sy:Number = readNumber();
						var sz:Number = readNumber();
						elemData.scale = new Vector3D(sx,sy,sz);
						break;
					case "script":
						readScript(elemData);
						break;
					case "element":
						readElem(elemData,true);
						break;
					case "}":
						end=true;
						break;
					default:
						throwUnexpect(word);
				}
			}
			return elemData;
		}
		private function readParticle():ElemData{
			var particleData:ParticleElemData=new ParticleElemData();
			var word:String;
			expectWord("{");
			var end:Boolean=false;
			while (!end) {
				word =readNoBlank();
				switch (word) {
					case "StartTime":
						particleData.startTime=readNumber();
						break;
					case "LifeTime":
						readNumber();
						break;
					case "Position":
						var px:Number=readNumber();
						var py:Number=readNumber();
						var pz:Number=-readNumber();
						particleData.positon=new Vector3D(px,py,pz);
						break;
					case "Orientation":
						var qw:Number=readNumber();
						var qx:Number=readNumber();
						var qy:Number=readNumber();
						var qz:Number=readNumber();
						
						var matrixOL:Matrix3D;
						var quat:Quaternion = new Quaternion(qx, qy, -qz, -qw);
						matrixOL = quat.toMatrix3D();
						var vec3:Vector.<Vector3D> = matrixOL.decompose();
						//这里是轴角
						particleData.orientation=new Vector3D(vec3[1].x,vec3[1].y,vec3[1].z);
						break;
					case "Scale":
						var sx:Number = readNumber();
						var sy:Number = readNumber();
						var sz:Number = readNumber();
						particleData.scale = new Vector3D(sx,sy,sz);
						break;
					case "ParticleSystem":
						word=readNoBlank();
						particleData.particleName=word;
						break;
					case "script":
						readScript(particleData);
						break;
		 			case "}":
						end=true;
						break;
					default:
						throwUnexpect(word);
				}
			}
			return particleData;
		}
		
		private function readMesh():ElemData{
			var meshData:MeshElemData=new MeshElemData();
			var word:String;
			expectWord("{");
			var end:Boolean=false;
			while (!end) {
				word =readNoBlank();
				switch (word) {
					case "StartTime":
						meshData.startTime=readNumber();
						break;
					case "LifeTime":
						readNumber();
						break;
					case "Position":
						var px:Number=readNumber();
						var py:Number=readNumber();
						var pz:Number=-readNumber();
						meshData.positon=new Vector3D(px,py,pz);
						break;
					case "Orientation":
						var qw:Number=readNumber();
						var qx:Number=readNumber();
						var qy:Number=readNumber();
						var qz:Number=readNumber();
						
						var matrixOL:Matrix3D;
						var quat:Quaternion = new Quaternion(qx, qy, -qz, -qw);
						matrixOL = quat.toMatrix3D();
						var vec3:Vector.<Vector3D> = matrixOL.decompose();
						//这里是轴角
						meshData.orientation=new Vector3D(vec3[1].x,vec3[1].y,vec3[1].z);
						break;
					case "Scale":
						var sx:Number = readNumber();
						var sy:Number = readNumber();
						var sz:Number = readNumber();
						meshData.scale = new Vector3D(sx,sy,sz);
						break;
					case "MeshName":
						word=readNoBlank();
						meshData.meshName=word;
						break;
					case "MeshMatName":
						word=readNoBlank();
						meshData.meshMatName=word;
						break;
					case "script":
						readScript(meshData);
						break;
					case "}":
						end=true;
						break;
					default:
						throwUnexpect(word);
				}
			}
			return meshData;
		}
		
		private function readScript(elemData:ElemData):void{
			var word:String;
			word=readNoBlank();
			expectWord("{");
			switch(word){
				case "NcRotation":
					elemData.behaviourArr.push(readNcRotation());
					break;
				case "NcCurveAnimation":
					elemData.behaviourArr.push(readNcCurveAnimation());
					break;
				case "NcBillboard":
					elemData.behaviourArr.push(readNcBillboard());
					break;
				case "NcUvAnimation":
					elemData.behaviourArr.push(readNcUvAnimation());
					break;
				default:
					expectWord("}");
			}
		}
		
		private function jumpAffector():void
		{
			expectWord("{");
			
			var end:Boolean=false;
			while (!end) {
				var word:String=readNoBlank();
				if (word=="}")
					break;
			}
		}
		
		//////////解析脚本
		private function readNcRotation():NcRotationData
		{
			var _data:NcRotationData = new NcRotationData();
			
			var end:Boolean=false;
			while (!end) {
				var word:String=readNoBlank();
				switch(word){
					case "fUserTag":
						_data.m_fUserTag = readNumber();
						break;
					case "bWorldSpace":
						_data.m_bWorldSpace = readNoBlank() == "True" ? true : false;
						break;
					case "vRotationValue":
						_data.m_vRotationValue = new Vector3D(readNumber(), readNumber(), readNumber());
						break;
					case "}":
						end = true;
						break;
				}
			}
			return _data;
		}
		
		private function readNcCurveAnimation():NcCurveAnimationData
		{
			var _data:NcCurveAnimationData = new NcCurveAnimationData();
			
			var end:Boolean=false;
			var infoCurve:NcInfoCurveData=null;
			while (!end) {
				var word:String=readNoBlank();
				switch(word){
					case "fUserTag":
						_data.m_fUserTag = readNumber();
						break;
					case "fDelayTime":
						_data.m_fDelayTime = readNumber();
						break;
					case "fDurationTime":
						_data.m_fDurationTime = readNumber();
						break;
					case "bAutoDestruct":
						_data.m_bAutoDestruct = readNoBlank() == "True" ? true : false;
						break;
					case "NcInfoCurve":
						expectWord("{");
						infoCurve = new NcInfoCurveData();
						break;
					case "bEnabled":
						infoCurve.m_bEnabled = readNoBlank() == "True" ? true : false;
						break;
					case "ApplyType":
						infoCurve.m_ApplyType = readNoBlank();
						break;
					case "bApplyOption":
						infoCurve.m_bApplyOption[0] = readNoBlank() == "True" ? true : false;
						infoCurve.m_bApplyOption[1] = readNoBlank() == "True" ? true : false;
						infoCurve.m_bApplyOption[2] = readNoBlank() == "True" ? true : false;
						infoCurve.m_bApplyOption[3] = readNoBlank() == "True" ? true : false;
						break;
					case "bRecursively":
						infoCurve.m_bRecursively = readNoBlank() == "True" ? true : false;
						break;
					case "fValueScale":
						infoCurve.m_fValueScale = readNumber();
						break;
					case "FromColor":
						infoCurve.m_FromColor[0] = readNumber();
						infoCurve.m_FromColor[1] = readNumber();
						infoCurve.m_FromColor[2] = readNumber();
						infoCurve.m_FromColor[3] = readNumber();
						break;
					case "ToColor":
						infoCurve.m_ToColor[0] = readNumber();
						infoCurve.m_ToColor[1] = readNumber();
						infoCurve.m_ToColor[2] = readNumber();
						infoCurve.m_ToColor[3] = readNumber();
						break;
					case "preWrapMode":
						infoCurve.m_AniCurve.preWrapMode = getWrapMode(readNoBlank());
						break;
					case "postWrapMode":
						infoCurve.m_AniCurve.postWrapMode = getWrapMode(readNoBlank());
						break;
					case "keys":
						var len:int = readNumber();
						expectWord("{");
						for(var i:int=0;i<=len;i++){
							infoCurve.m_AniCurve.keys.push(readNumber());//key
							infoCurve.m_AniCurve.keys.push(readNumber());//value
						}
						expectWord("}");
						break;
					case "}NcInfoCurve":
						_data.m_CurveInfoList.push(infoCurve);
						break;
					case "}":
						end = true;
						break;
				}
			}
			
			return _data;
		}
		private function getWrapMode(mode:String):int
		{
			if("Loop" == mode)
				return 1;
			else if("PingPong" == mode)
				return 2;
			else
				return 3;
		}
	
		private function readNcBillboard():NcBillboardData
		{
			var _data:NcBillboardData = new NcBillboardData();
			
			var end:Boolean=false;
			while(!end){
				var word:String=readNoBlank();
				switch(word){
					case "fUserTag":
						_data.fUserTag = readNumber();
						break;
					case "bCameraLookAt":
						_data.bCameraLookAt = readNoBlank() == "True" ? true : false;
						break;
					case "bFixedObjectUp":
						_data.bFixedObjectUp = readNoBlank() == "True" ? true : false;
						break;
					case "bFixedStand":
						_data.bFixedStand = readNoBlank() == "True" ? true : false;
						break;
					case "frontAxis":
						_data.FrontAxis = readNumber();
						break;
					case "ratationMode":
						_data.ratationMode = readNumber();
						break;
					case "ratationAxis":
						_data.ratationAxis = readNumber();
						break;
					case "fRotationValue":
						_data.fRotationValue = readNumber();
						break;
					case "}":
						end = true;
						break;
				}
			}
			
			return _data;
		}
	
		private function readNcUvAnimation():NcUvAnimationData
		{
			var _data:NcUvAnimationData = new NcUvAnimationData();
			
			var end:Boolean=false;
			while(!end){
				var word:String=readNoBlank();
				switch(word){
					case "fUserTag":
						_data.m_fUserTag = readNumber();
						break;
					case "fScrollSpeedX":
						_data.m_fScrollSpeedX = readNumber();
						break;
					case "fScrollSpeedY":
						_data.m_fScrollSpeedY = readNumber();
						break;
					case "fTilingX":
						_data.m_fTilingX = readNumber();
						break;
					case "fTilingY":
						_data.m_fTilingY = readNumber();
						break;
					case "fOffsetX":
						_data.m_fOffsetX = readNumber();
						break;
					case "fOffsetY":
						_data.m_fOffsetY = readNumber();
						break;
					case "bUseSmoothDeltaTime":
						_data.m_bUseSmoothDeltaTime = readNoBlank() == "True" ? true : false;
						break;
					case "bFixedTileSize":
						_data.m_bFixedTileSize = readNoBlank() == "True" ? true : false;
						break;
					case "bRepeat":
						_data.m_bRepeat = readNoBlank() == "True" ? true : false;
						break;
					case "bAutoDestruct":
						_data.m_bAutoDestruct = readNoBlank() == "True" ? true : false;
						break;
					case "}":
						end = true;
						break;
				}
			}
			return _data;
		}
	}
}