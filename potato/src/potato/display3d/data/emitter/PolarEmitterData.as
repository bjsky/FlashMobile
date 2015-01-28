package potato.display3d.data.emitter
{
	import core.effects.ParticleEmitter;
	import core.effects.PolarEmitter;
	
	import potato.display3d.data.EmitterData;
	
	public class PolarEmitterData extends EmitterData
	{
		public function PolarEmitterData()
		{
			super();
		}
		
		public var flipYZ:Boolean=false;
		public var phiEnd:Number=0;
		public var phiStart:Number=0;
		public var phiStep:Number=0;
		public var radiusEnd:Number=0;
		public var radiusStart:Number=0;
		public var radiusStep:Number=0;
		public var resetRadius:Boolean=false;
		public var resetRadiusCount:uint=0;
		public var thetaEnd:Number=0;
		public var thetaStart:Number=0;
		public var thetaStep:Number=0;
		public var useStep:Boolean=false;
		
		override public function newEmitter():ParticleEmitter
		{
			var e:PolarEmitter=new PolarEmitter();
			setEmitter(e);
			
			return e;
		}
		
		override public function setEmitter(pe:ParticleEmitter):void{
			super.setEmitter(pe);
			PolarEmitter(pe).flipYZ=flipYZ;
			PolarEmitter(pe).phiEnd=phiEnd;
			PolarEmitter(pe).phiStart=phiStart;
			PolarEmitter(pe).phiStep=phiStep;
			PolarEmitter(pe).radiusEnd=radiusEnd;
			PolarEmitter(pe).radiusStart=radiusStart;
			PolarEmitter(pe).radiusStep=radiusStep;
			PolarEmitter(pe).resetRadius=resetRadius;
			PolarEmitter(pe).resetRadiusCount=resetRadiusCount;
			PolarEmitter(pe).thetaEnd=thetaEnd;
			PolarEmitter(pe).thetaStart=thetaStart;
			PolarEmitter(pe).thetaStep=thetaStep;
			PolarEmitter(pe).useStep=useStep;
		}
		
	}
}