package potato.display3d.behaviour
{
	import core.display3d.Object3D;
	import core.display3d.Quaternion;
	import core.display3d.Vector3D;
	
	import potato.potato_internal;
	import potato.display3d.behaviour.common.NcEffectAniBehaviour;
	import potato.display3d.behaviour.common.Vector4;
	import potato.display3d.data.behaviour.NcCurveAnimationData;
	import potato.display3d.data.behaviour.NcInfoCurveData;

	public class NcCurveAnimation extends NcEffectAniBehaviour
	{
		use namespace potato_internal;
		
		public var m_fDelayTime:Number = 0;
		public var m_fDurationTime:Number = 0.6;
		public var m_bAutoDestruct:Boolean = true;
		
		public var m_CurveInfoList:Vector.<NcInfoCurve>;
		
		protected var m_fStartTime:Number;
		protected var m_fElapsedRate:Number = 0;
		
		public function NcCurveAnimation(data:NcCurveAnimationData)
		{
			m_fUserTag = data.m_fUserTag;
			m_fDelayTime = data.m_fDelayTime;
			m_fDurationTime = data.m_fDurationTime;
			m_bAutoDestruct = data.m_bAutoDestruct;
			m_CurveInfoList = new Vector.<NcInfoCurve>();
			for each(var curveInfoData:NcInfoCurveData in data.m_CurveInfoList){
				var curveInfo:NcInfoCurve = new NcInfoCurve(curveInfoData);
				m_CurveInfoList.push(curveInfo);
			}
		}
		
		override public function start():void
		{	
			m_fStartTime = GetEngineTime();
			InitAnimation();
			if(0 < m_fDelayTime){
				return;
			}else{
				InitAnimationTimer();
				UpdateAnimation(0);
			}
		}
		
		override public function laterUpdate():void
		{
			if(m_fStartTime == 0)return;
			if(m_fDelayTime != 0){
				if(GetEngineTime() < m_fStartTime + m_fDelayTime)
					return;
				m_fDelayTime = 0;
				InitAnimationTimer();
			}
			
			var fElapsedTime:Number = 0;
			if(m_Timer != null)
				fElapsedTime = m_Timer.GetTime();
			var fElapsedRate:Number = fElapsedTime;
			if(0 != m_fDurationTime)
				fElapsedRate = fElapsedTime / m_fDurationTime;
			UpdateAnimation(fElapsedRate);
		}
		
		private function InitAnimation():void
		{
			m_fElapsedRate = 0;
			for each(var curveInfo:NcInfoCurve in m_CurveInfoList){
				if(!curveInfo.m_bEnabled)
					continue;
				switch(curveInfo.m_ApplyType){
					case NcInfoCurve.APPLY_TYPE_NONE:
						continue;
					case NcInfoCurve.APPLY_TYPE_Position:
					case NcInfoCurve.APPLY_TYPE_Rotation:
						curveInfo.m_OriginalValue = new Vector4(0,0,0,0);
						curveInfo.m_BeforeValue = new Vector4(0,0,0,0);
						break;
					case NcInfoCurve.APPLY_TYPE_Scale:
						curveInfo.m_OriginalValue = new Vector4(container.scaleX,container.scaleY,container.scaleZ,1);
						curveInfo.m_BeforeValue = new Vector4(container.scaleX,container.scaleY,container.scaleZ,1);
						break;
					case NcInfoCurve.APPLY_TYPE_MaterialColor:
						break;
					case NcInfoCurve.APPLY_TYPE_TextureUV:
						break;
					case NcInfoCurve.APPLY_TYPE_MeshColor:
						break;
				}
			}
		}
	
		private function UpdateAnimation(fElapsedRate:Number):void
		{
			m_fElapsedRate = fElapsedRate;
			for each(var curveInfo:NcInfoCurve in m_CurveInfoList){
				if(!curveInfo.m_bEnabled)
					continue;
				var fValue:Number = curveInfo.m_AniCurve.Evaluate(m_fElapsedRate);
				if(curveInfo.m_ApplyType != NcInfoCurve.APPLY_TYPE_MaterialColor && curveInfo.m_ApplyType != NcInfoCurve.APPLY_TYPE_MeshColor)
					fValue *= curveInfo.m_fValueScale;
				switch(curveInfo.m_ApplyType){
					case NcInfoCurve.APPLY_TYPE_NONE:
						continue;
					case NcInfoCurve.APPLY_TYPE_Position:
						container.x += GetNextValue(curveInfo, 0, fValue);
						container.y += GetNextValue(curveInfo, 1, fValue);
						container.z += GetNextValue(curveInfo, 2, fValue);
						break;
					case NcInfoCurve.APPLY_TYPE_Rotation:
						var ox:Number = GetNextValue(curveInfo, 0, fValue);
						var oy:Number = GetNextValue(curveInfo, 1, fValue);
						var oz:Number = GetNextValue(curveInfo, 2, fValue);
						var qr:Quaternion = new Quaternion();
						qr.fromEulerZXY(ox,oy,oz);
						
						var qb:Quaternion = new Quaternion();
						qb.fromEuler(container.rotationX, container.rotationY, container.rotationZ);
						
						var vec:Vector3D;
						if(curveInfo.m_bApplyOption[3]){
							var qp:Quaternion = new Quaternion();
							var tq:Quaternion = new Quaternion();
							var o:Object3D = container;
							while(o.parent){
								o = o.parent;
								tq.fromEuler(o.rotationX, o.rotationY, o.rotationZ);
								qp.multiply(tq,qp);
							}
							var _qp:Quaternion = new Quaternion(-qp.x,-qp.y,-qp.z,qp.w);
							var oq:Quaternion = new Quaternion();
							oq.multiply(oq,_qp);
							oq.multiply(oq,qr);
							oq.multiply(oq,qp);
							oq.multiply(oq,qb);
							vec = oq.toEuler();
							container.rotationX = vec.x;
							container.rotationY = vec.y;
							container.rotationZ = vec.z;
						}else{//本地空间
							qb.multiply(qb,qr);
							vec = qb.toEuler();
							container.rotationX = vec.x;
							container.rotationY = vec.y;
							container.rotationZ = vec.z;
						}
						break;
					case NcInfoCurve.APPLY_TYPE_Scale:
						container.scaleX += GetNextScale(curveInfo, 0, fValue);
						container.scaleY += GetNextScale(curveInfo, 1, fValue);
						container.scaleZ += GetNextScale(curveInfo, 2, fValue);
						break;
					case NcInfoCurve.APPLY_TYPE_MaterialColor:
						break;
					case NcInfoCurve.APPLY_TYPE_TextureUV:
						break;
					case NcInfoCurve.APPLY_TYPE_MeshColor:
						break;
				}
			}
			if(0 != m_fDurationTime){
				if(1 < m_fElapsedRate){
					if(IsEndAnimation() == false)
						OnEndAnimation();
					if(m_bAutoDestruct)
						OnDestroy();
				}
			}
		}
		
		private function GetNextValue(curveInfo:NcInfoCurve, nIndex:int, fValue:Number):Number
		{
			if(curveInfo.m_bApplyOption[nIndex]){
				var incValue:Number = fValue - curveInfo.m_BeforeValue.getValue(nIndex);
				curveInfo.m_BeforeValue.setValue(nIndex, fValue);
				return incValue;
			}	
			return 0;
		}
		private function GetNextScale(curveInfo:NcInfoCurve, nIndex:int, fValue:Number):Number
		{
			if(curveInfo.m_bApplyOption[nIndex]){
				var absValue:Number = curveInfo.m_OriginalValue.getValue(nIndex) * (fValue + 1);
				var incValue:Number = absValue - curveInfo.m_BeforeValue.getValue(nIndex);
				curveInfo.m_BeforeValue.setValue(nIndex,absValue);
				return incValue;
			}
			return 0;
		}
		
		override protected function OnDestroy():void
		{
			super.OnDestroy();
			if(m_bAutoDestruct)
				container.dispose();
			else
				dispose();
		}
	}
}
import potato.display3d.behaviour.common.AnimationCurve;
import potato.display3d.behaviour.common.Vector4;
import potato.display3d.data.behaviour.NcInfoCurveData;

class NcInfoCurve
{	
	public var m_bEnabled:Boolean = true;
	public var m_CurveName:String = "";
	public var m_AniCurve:AnimationCurve;
	public var m_ApplyType:String = APPLY_TYPE_Position;
	public var m_bApplyOption:Array = [false, true, false, false];
	
	public var m_bRecursively:Boolean = false;
	public var m_fValueScale:Number = 1.0;
	public var m_FromColor:Vector4 = new Vector4(1,1,1,1);
	public var m_ToColor:Vector4 = new Vector4(1,1,1,1);
	
	public var m_OriginalValue:Vector4;
	public var m_BeforeValue:Vector4;
	
	public static const APPLY_TYPE_NONE:String = "NONE";
	public static const APPLY_TYPE_Position:String = "POSITION";
	public static const APPLY_TYPE_Rotation:String = "ROTATION";
	public static const APPLY_TYPE_Scale:String = "SCALE";
	public static const APPLY_TYPE_MaterialColor:String = "MATERIAL_COLOR";
	public static const APPLY_TYPE_TextureUV:String = "TEXTUREUV";
	public static const APPLY_TYPE_MeshColor:String = "MESH_COLOR";
	
	protected const m_fOverDraw:Number = 0.2;
	
	public function NcInfoCurve(data:NcInfoCurveData)
	{
		m_bEnabled = data.m_bEnabled;
		m_CurveName = data.m_CurveName;
		m_ApplyType = data.m_ApplyType;
		m_bApplyOption = data.m_bApplyOption.slice();
		
		m_AniCurve = new AnimationCurve(data.m_AniCurve);
		
		m_bRecursively = data.m_bRecursively;
		m_fValueScale = data.m_fValueScale;
		m_FromColor = new Vector4(data.m_FromColor[0],data.m_FromColor[1],data.m_FromColor[2],data.m_FromColor[3]);
		m_ToColor = new Vector4(data.m_ToColor[0],data.m_ToColor[1],data.m_ToColor[2],data.m_ToColor[3]);
	}
	
}