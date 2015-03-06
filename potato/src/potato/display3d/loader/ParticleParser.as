package potato.display3d.loader
{
	import core.display3d.Vector3D;
	import core.effects.LinearForceAffector;
	import core.effects.ParticleSystem;
	
	import potato.display3d.data.AffectorData;
	import potato.display3d.data.EmitterData;
	import potato.display3d.data.ParticleData;
	import potato.display3d.data.affector.ColorFader2AffectorData;
	import potato.display3d.data.affector.ColorFader6AffectorData;
	import potato.display3d.data.affector.ColorFaderAffectorData;
	import potato.display3d.data.affector.DampAffectorData;
	import potato.display3d.data.affector.GrowAffectorData;
	import potato.display3d.data.affector.LinearForceAffectorData;
	import potato.display3d.data.affector.MotionAffectorData;
	import potato.display3d.data.affector.Rotation2AffectorData;
	import potato.display3d.data.affector.Rotation6AffectorData;
	import potato.display3d.data.affector.RotationAffectorData;
	import potato.display3d.data.affector.Scale2AffectorData;
	import potato.display3d.data.affector.Scale6AffectorData;
	import potato.display3d.data.affector.ScaleAffectorData;
	import potato.display3d.data.emitter.BoxEmitterData;
	import potato.display3d.data.emitter.CylinderEmitterData;
	import potato.display3d.data.emitter.EllipsoidEmitterData;
	import potato.display3d.data.emitter.HollowEllipsoidEmitterData;
	import potato.display3d.data.emitter.PointEmitterData;
	import potato.display3d.data.emitter.PolarEmitterData;
	import potato.display3d.data.emitter.RingEmitterData;

	/**
	 * 效果解析 
	 * @author liuxin
	 * 
	 */
	public class ParticleParser extends TxtParser
	{
		private var _curEffectElemData:ParticleData;
		private var _curEmitter:EmitterData;
		private var bad:Boolean;
		
		private var rot_vetex:Number=0;
		private var rot_tex:Number=0;
		private var rot_valid:Number=0;
		private var rot_no_valid:Number=0;
		
		private var _elemDataArr:Vector.<ParticleData>;
		
		public function ParticleParser()
		{
		}
		
		
		public function parse(path:String):Vector.<ParticleData>//,elemArr:Vector.<ParticleData>):void
		{
			_elemDataArr = new Vector.<ParticleData>();
			
//			for each(_curEffectElemData in _elemDataArr){
				loadFile(path);
				while(true){
					var word:String=readWord();
					if (!word)
						break;
					if(word=='particle'){
						_curEffectElemData = new ParticleData();
						word=readNoBlank();
						_curEffectElemData.elemName = word;
//						if(_curEffectElemData.elemName==word){
//							_curEffectElemData.emitters=new Vector.<EmitterData>();
//							_curEffectElemData.affectors=new Vector.<AffectorData>();
							readParticle();
//							break;
//						}
						_elemDataArr.push(_curEffectElemData);
					}
				}
				return _elemDataArr;
//			}
		}
		public function readParticle():void
		{
			expectWord("{");
			
			var billboard_rotation_type:String;
			
			var end:Boolean=false;
			while (!end) {
				var word:String=readNoBlank();
				switch (word) {
					case "material":
						_curEffectElemData.material=readNoBlank();
						break;
					case "quota":
						_curEffectElemData.quota=readNumber();
						break;
					case "emit_emitter_quota":
						readNumber();
						break;
					case "particle_width":
						_curEffectElemData.defaultWidth=readNumber();
						break;
					case "particle_height":
						_curEffectElemData.defaultHeight=readNumber();
						break;
					case "billboard_type":
						word=readNoBlank();
						switch (word) {
							case "point":
								_curEffectElemData.type=ParticleSystem.TYPE_POINT;
								break;
							case "oriented_common":
								_curEffectElemData.type=ParticleSystem.TYPE_ORIENTED_COMMON;
								break;
							case "oriented_self":
								_curEffectElemData.type=ParticleSystem.TYPE_ORIENTED_SELF;
								break;
							case "perpendicular_common":
								_curEffectElemData.type=ParticleSystem.TYPE_PERPENDICULAR_COMMON;
								break;
							case "perpendicular_self":
								_curEffectElemData.type=ParticleSystem.TYPE_PERPENDICULAR_SELF;
								break;
							default:
								throwUnexpect(word);
						}
						break;
					case "common_direction":
						_curEffectElemData.commonDirection=readVector3D_z();
						break;
					case "common_up_vector":
						_curEffectElemData.commonUp=readVector3D_z();
						break;
					case "worldSpace":
						word=readNoBlank();
						if(word=="true"){
							_curEffectElemData.worldSpace=true;
						}
						break;
					case "emitter":
						word=readNoBlank();
						switch (word) {
							case "Point":
								_curEmitter=new PointEmitterData();
								readEmitter();
								break;
							case "Box":
								_curEmitter=new BoxEmitterData();
								readEmitter();
								break;
							case "Ring":
								_curEmitter=new RingEmitterData();
								readEmitter();
								break;
							case "Ellipsoid":
								_curEmitter=new EllipsoidEmitterData();
								readEmitter();
								break;
							case "HollowEllipsoid":
								_curEmitter=new HollowEllipsoidEmitterData();
								readEmitter();
								break;
							case "Cylinder":
								_curEmitter=new CylinderEmitterData();
								readEmitter();
								break;
							case "PolarEmitter":
								_curEmitter=new PolarEmitterData();
								readEmitter();
								break;
							default:
								throwUnexpect(word);
						}
						_curEffectElemData.emitters.push(_curEmitter);
						break;
					case "affector":
						word=readNoBlank();
						switch (word) {
							case "ColourFading":
								readColorFader6Affector();
								break;
							case "ScaleInterpolator":
								readScale6Affector();
								break;
							case "Movement":
								readMotionAffector();
								break;
							case "Revolution":
								readRotation6Affector();
								break;
							case "Rotator":
								if (billboard_rotation_type=="vertex")
									++rot_vetex;
								else
									++rot_tex;
								readRotationAffector();
								break;
							case "LinearForce":
								readLinearForceAffector();
								break;
							case "ColourFader":
								readColorFaderAffector();
								break;
							case "ColourFader2":
								readColorFader2Affector();
								break;
							case "Scaler":
								readScalerAffector();
								break;
							case "MeshRotator":
							case "MeshAnimationAffector":
							case "HeightField":
							case "ColourInterpolator":
								bad=true;
								jumpAffector();
								break;
							case "DampAffector":
								dampAffector();
								break;
							case "GrowAffector":
								growAffector();
								break;
							default:
								throwUnexpect(word);
						}
						break;
					case "billboard_origin":
						word=readNoBlank();
						switch (word) {
							case "center":
								break;
							case "top_center":
							case "bottom_center":
							case "top_left":
							case "center_left":
							case "bottom_right":
								bad=true;
								break;
							default:
								throwUnexpect(word);
						}
						break;
					case "billboard_rotation_type":
						word=readNoBlank();
						if (word!="texcoord" && word!="vertex")
							throwUnexpect(word);
						billboard_rotation_type=word;
						break;
					case "renderer":
						word=readNoBlank();
						switch (word) {
							case "billboard":
								break;
							case "texcoord_billboard":
							case "ribbon":
							case "mesh":
								bad=true;
								break;
							default:
								throwUnexpect(word);
						}
						break;
					case "sorted":
						word=readNoBlank();
						switch (word) {
							case "false":
								break;
							case "true":
								bad=true;
								break;
							default:
								throwUnexpect(word);
						}
						break;
					case "local_space":
						word=readNoBlank();
						if (word!="true" && word!="false")
							throwUnexpect(word);
						break;
					case "iteration_interval":
						var n:Number=readNumber();
						//if (n!=0)
						//    throwUnexpect(word);
						break;
					case "nonvisible_update_timeout":
						n=readNumber();
						//if (n!=0)
						//    throwUnexpect(word);
						break;
					case "cull_each":
						readNoBlank();
						break;
					case "point_rendering":
						word=readNoBlank();
						if (word!="false")
							throwUnexpect(word);
						break;
					case "accurate_facing":
						readNoBlank();
						break;
					case "speed_relatived_size_factor":
						readNumber();
						break;
					case "mesh_name":
						bad=true;
						word=readNoBlank();
						if (word=="ZHUAN")
							readNoBlank();
						break;
					case "orientation_type":
						bad=true;
						readNoBlank();
						break;
					case "stacks":
					case "slices":
					case "repeat_times":
						bad=true;
						readNumber();
						break;
					case "head_alpha":
					case "tail_alpha":
					case "head_width_scale":
					case "tail_width_scale":
					case "element_count":
						bad=true;
						readNumber();
						break;
					
					case "}":
						end=true;
						break;
					default:
						throwUnexpect(word);
				}
			}
		}
		
		private function readEmitter():void
		{
			expectWord("{");
			
			var end:Boolean=false;
			while (!end) {
				var word:String=readNoBlank();
				switch (word) {
					case "angle":
						_curEmitter.angle=readNumber();
						break;
					case "colour":
						_curEmitter.colorRangeStart=_curEmitter.colorRangeEnd=readColor();
						break;
					case "colour_range_start":
						_curEmitter.colorRangeStart=readColor();
						break;
					case "colour_range_end":
						_curEmitter.colorRangeEnd=readColor();
						break;
					case "position":
						_curEmitter.emitPosition=readVector3D_z();
						break;
					case "direction":
						_curEmitter.emitDirection=readVector3D_z();
						break;
					case "emission_rate":
						_curEmitter.rate=readNumber();
						break;
					case "velocity":
						_curEmitter.minSpeed=_curEmitter.maxSpeed=readNumber();
						break;
					case "velocity_min":
						_curEmitter.minSpeed=readNumber();
						break;
					case "velocity_max":
						_curEmitter.maxSpeed=readNumber();
						break;
					case "time_to_live":
						_curEmitter.minTTL=_curEmitter.maxTTL=readNumber();
						break;
					case "time_to_live_min":
						_curEmitter.minTTL=readNumber();
						break;
					case "time_to_live_max":
						_curEmitter.maxTTL=readNumber();
						break;
					case "duration":
						_curEmitter.minDuration=_curEmitter.maxDuration=readNumber();
						break;
					case "duration_min":
						_curEmitter.minDuration=readNumber();
						break;
					case "duration_max":
						_curEmitter.maxDuration=readNumber();
						break;
					case "repeat_delay":
						_curEmitter.minRepeatDelay=_curEmitter.maxRepeatDelay=readNumber();
						break;
					case "repeat_delay_min":
						_curEmitter.minRepeatDelay=readNumber();
						break;
					case "repeat_delay_max":
						_curEmitter.maxRepeatDelay=readNumber();
						break;
					case "burstEmitCount":
						_curEmitter.burstEmitCount=readNumber();
						break;
					case "width":
						if (_curEmitter is BoxEmitterData)
							(_curEmitter as BoxEmitterData).boxWidth=readNumber();
						else
							throwUnexpect(word);
						break;
					case "height":
						if (_curEmitter is BoxEmitterData)
							(_curEmitter as BoxEmitterData).boxHeight=readNumber();
						else
							throwUnexpect(word);
						break;
					case "depth":
						if (_curEmitter is BoxEmitterData)
							(_curEmitter as BoxEmitterData).boxDepth=readNumber();
						else
							throwUnexpect(word);
						break;
					case "inner_width":
						if (_curEmitter is RingEmitterData)
							(_curEmitter as RingEmitterData).innerWidth=readNumber();
						else if (_curEmitter is HollowEllipsoidEmitterData)
							(_curEmitter as HollowEllipsoidEmitterData).innerWidth=readNumber();
						else
							throwUnexpect(word);
						break;
					case "inner_height":
						if (_curEmitter is RingEmitterData)
							(_curEmitter as RingEmitterData).innerHeight=readNumber();
						else if (_curEmitter is HollowEllipsoidEmitterData)
							(_curEmitter as HollowEllipsoidEmitterData).innerHeight=readNumber();
						else
							throwUnexpect(word);
						break;
					case "inner_depth":
						if (_curEmitter is HollowEllipsoidEmitterData)
							(_curEmitter as HollowEllipsoidEmitterData).innerDepth=readNumber();
						else
							throwUnexpect(word);
						break;
					case "radius_start":
						if (_curEmitter is PolarEmitterData)
							(_curEmitter as PolarEmitterData).radiusStart=readNumber();
						else
							throwUnexpect(word);
						break;
					case "radius_end":
						if (_curEmitter is PolarEmitterData)
							(_curEmitter as PolarEmitterData).radiusEnd=readNumber();
						else
							throwUnexpect(word);
						break;
					case "radius_step":
						if (_curEmitter is PolarEmitterData)
							(_curEmitter as PolarEmitterData).radiusStep=-readNumber();
						else
							throwUnexpect(word);
						break;
					case "theta_start":
						if (_curEmitter is PolarEmitterData)
							(_curEmitter as PolarEmitterData).thetaStart=readNumber();
						else
							throwUnexpect(word);
						break;
					case "theta_end":
						if (_curEmitter is PolarEmitterData)
							(_curEmitter as PolarEmitterData).thetaEnd=readNumber();
						else
							throwUnexpect(word);
						break;
					case "theta_step":
						if (_curEmitter is PolarEmitterData)
							(_curEmitter as PolarEmitterData).thetaStep=readNumber();
						else
							throwUnexpect(word);
						break;
					case "phi_start":
						if (_curEmitter is PolarEmitterData)
							(_curEmitter as PolarEmitterData).phiStart=readNumber();
						else
							throwUnexpect(word);
						break;
					case "phi_end":
						if (_curEmitter is PolarEmitterData)
							(_curEmitter as PolarEmitterData).phiEnd=readNumber();
						else
							throwUnexpect(word);
						break;
					case "phi_step":
						if (_curEmitter is PolarEmitterData)
							(_curEmitter as PolarEmitterData).phiStep=readNumber();
						else
							throwUnexpect(word);
						break;
					case "use_polar_step":
						if (_curEmitter is PolarEmitterData)
							(_curEmitter as PolarEmitterData).useStep=readNoBlank()=="true";
						else
							throwUnexpect(word);
						break;
					case "flip_yz_axis":
						if (_curEmitter is PolarEmitterData)
							(_curEmitter as PolarEmitterData).flipYZ=readNoBlank()=="true";
						else
							throwUnexpect(word);
						break;
					case "reset_radius":
						if (_curEmitter is PolarEmitterData)
							(_curEmitter as PolarEmitterData).resetRadius=readNoBlank()=="true";
						else
							throwUnexpect(word);
						break;
					case "reset_radius_count":
						if (_curEmitter is PolarEmitterData)
							(_curEmitter as PolarEmitterData).resetRadiusCount=readNumber();
						else
							throwUnexpect(word);
						break;
					case "name":
					case "emit_emitter":
						trace('存在发射器上的发射器！');
						break;
					case "}":
						end=true;
						break;
					default:
						throwUnexpect(word);
				}
			}
			
		}
		
		private function readScalerAffector():void
		{
			expectWord("{");
			
			var curAffector:ScaleAffectorData=new ScaleAffectorData();
			
			var end:Boolean=false;
			while (!end) {
				var word:String=readNoBlank();
				switch (word) {
					case "rate":
						curAffector.rate=readNumber();
						break;
					case "}":
						end=true;
						break;
					default:
						throwUnexpect(word);
				}
			}
			
			_curEffectElemData.affectors.push(curAffector);
		}
		
		
		private function dampAffector():void{
			expectWord("{");
			
			var curAffector:DampAffectorData=new DampAffectorData();
			var end:Boolean=false;
			while (!end) {
				var word:String=readNoBlank();
				switch (word) {
					case "damp":
						curAffector.damp = readNumber();
						break;
					case "}":
						end=true;
						break;
					default:
						throwUnexpect(word);
				}
			}
			
			_curEffectElemData.affectors.push(curAffector);
			
		}
		
		private function growAffector():void{
			expectWord("{");
			
			var curAffector:GrowAffectorData=new GrowAffectorData();
			var end:Boolean=false;
			while (!end) {
				var word:String=readNoBlank();
				switch (word) {
					case "grow":
						curAffector.grow = readNumber();
						break;
					case "}":
						end=true;
						break;
					default:
						throwUnexpect(word);
				}
			}
			
			_curEffectElemData.affectors.push(curAffector);
			
		}
		
		private function readLinearForceAffector():void
		{
			expectWord("{");
			
			var curAffector:LinearForceAffectorData=new LinearForceAffectorData();
			
			var end:Boolean=false;
			while (!end) {
				var word:String=readNoBlank();
				switch (word) {
					case "force_vector":
						curAffector.force=readVector3D_z();
						break;
					case "force_application":
						word=readNoBlank();
						switch (word) {
							case "add":
								curAffector.app=LinearForceAffector.ADD;
								break;
							default:
								throwUnexpect(word);
						}
						break;
					case "}":
						end=true;
						break;
					default:
						throwUnexpect(word);
				}
			}
			
			_curEffectElemData.affectors.push(curAffector);
		}
		
		private function readColorFaderAffector():void
		{
			expectWord("{");
			
			var curAffector:ColorFaderAffectorData=new ColorFaderAffectorData();
			
			var end:Boolean=false;
			while (!end) {
				var word:String=readNoBlank();
				switch (word) {
					case "red":
						curAffector.redAdj=readNumber();
						break;
					case "green":
						curAffector.greenAdj=readNumber();
						break;
					case "blue":
						curAffector.blueAdj=readNumber();
						break;
					case "alpha":
						curAffector.alphaAdj=readNumber();
						break;
					case "}":
						end=true;
						break;
					default:
						throwUnexpect(word);
				}
			}
			
			_curEffectElemData.affectors.push(curAffector);
		}
		
		private function readColorFader2Affector():void
		{
			expectWord("{");
			
			var curAffector:ColorFader2AffectorData=new ColorFader2AffectorData();
			
			var end:Boolean=false;
			while (!end) {
				var word:String=readNoBlank();
				switch (word) {
					case "red1":
						curAffector.redAdj=readNumber();
						break;
					case "green1":
						curAffector.greenAdj=readNumber();
						break;
					case "blue1":
						curAffector.blueAdj=readNumber();
						break;
					case "alpha1":
						curAffector.alphaAdj=readNumber();
						break;
					case "red2":
						curAffector.redAdj2=readNumber();
						break;
					case "green2":
						curAffector.greenAdj2=readNumber();
						break;
					case "blue2":
						curAffector.blueAdj2=readNumber();
						break;
					case "alpha2":
						curAffector.alphaAdj2=readNumber();
						break;
					case "state_change":
						curAffector.stateChange=readNumber();
						break;
					case "}":
						end=true;
						break;
					default:
						throwUnexpect(word);
				}
			}
			
			_curEffectElemData.affectors.push(curAffector);
		}
		
		private function readColorFader6Affector():void
		{
			expectWord("{");
			
			var curAffector:ColorFader6AffectorData=new ColorFader6AffectorData();
			curAffector.times=new Vector.<Number>(6);
			curAffector.colours= new Vector.<Vector3D>(6);

			
			var end:Boolean=false;
			var colour:Vector3D;
			var time:Number;
			while (!end) {
				var word:String=readNoBlank();
				switch (word) {
					case "colour0":
						colour = readColor();
						curAffector.colours[0] = colour; 
						break;
					case "colour1":
						colour = readColor();
						curAffector.colours[1] = colour; 
						break;
					case "colour2":
						colour = readColor();
						curAffector.colours[2] = colour; 
						break;
					case "colour3":
						colour = readColor();
						curAffector.colours[3] = colour; 
						break;
					case "colour4":
						colour = readColor();
						curAffector.colours[4] = colour; 
						break;
					case "colour5":
						colour = readColor();
						curAffector.colours[5] = colour; 
						break;
					case "time0":
						time = readNumber();
						curAffector.times[0] = time;
						break;
					case "time1":
						time = readNumber();
						curAffector.times[1] = time;
						break;
					case "time2":
						time = readNumber();
						curAffector.times[2] = time;
						break;
					case "time3":
						time = readNumber();
						curAffector.times[3] = time;
						break;
					case "time4":
						time = readNumber();
						curAffector.times[4] = time;
						break;
					case "time5":
						time = readNumber();
						curAffector.times[5] = time;
						break;
					case "repeat_times":
						curAffector.repeatTimes=readNumber();
						break;
					case "opacity":
						curAffector.opacity=readNumber();
						break;
					case "fade_in_time":
						curAffector.fadeInTime=readNumber();
						break;
					case "fade_out_time":
						curAffector.fadeOutTime=readNumber();
						break;
					case "}":
						end=true;
						break;
					default:
						throwUnexpect(word);
				}
			}
			
			_curEffectElemData.affectors.push(curAffector);
		}
		
		private function readScale6Affector():void
		{
			expectWord("{");
			
			var curAffector:AffectorData;
			var uniform_size:Boolean;
			var use_constant_scale:Boolean;
			var use_interpolated_scale:Boolean;
			var width_range_start:Number;
			var width_range_end:Number;
			var height_range_start:Number;
			var height_range_end:Number;
			var sx:Number=1;
			var sy:Number=1;
			var xadj:Array=[];
			var yadj:Array=[];
			var timeadj:Array=[];
			var repeat_times:Number;
			
			var end:Boolean=false;
			while (!end) {
				var word:String=readNoBlank();
				switch (word) {
					case "uniform_size":
						uniform_size=readNoBlank()=="true";
						break;
					case "use_constant_scale":
						use_constant_scale=readNoBlank()=="true";
						break;
					case "use_interpolated_scale":
						use_interpolated_scale=readNoBlank()=="true";
						break;
					case "width_range_start":
						width_range_start=readNumber();
						break;
					case "width_range_end":
						width_range_end=readNumber();
						break;
					case "height_range_start":
						height_range_start=readNumber();
						break;
					case "height_range_end":
						height_range_end=readNumber();
						break;
					case "constant_scale":
						sx=readNumber();
						sy=readNumber();
						readNumber();
						break;
					case "scale0":
						xadj[0]=readNumber();
						yadj[0]=readNumber();
						readNumber();
						break;
					case "scale1":
						xadj[1]=readNumber();
						yadj[1]=readNumber();
						readNumber();
						break;
					case "scale2":
						xadj[2]=readNumber();
						yadj[2]=readNumber();
						readNumber();
						break;
					case "scale3":
						xadj[3]=readNumber();
						yadj[3]=readNumber();
						readNumber();
						break;
					case "scale4":
						xadj[4]=readNumber();
						yadj[4]=readNumber();
						readNumber();
						break;
					case "scale5":
						xadj[5]=readNumber();
						yadj[5]=readNumber();
						readNumber();
						break;
					case "time0":
						timeadj[0]=readNumber();
						break;
					case "time1":
						timeadj[1]=readNumber();
						break;
					case "time2":
						timeadj[2]=readNumber();
						break;
					case "time3":
						timeadj[3]=readNumber();
						break;
					case "time4":
						timeadj[4]=readNumber();
						break;
					case "time5":
						timeadj[5]=readNumber();
						break;
					case "repeat_times":
						repeat_times=readNumber();
						break;
					case "}":
						end=true;
						break;
					default:
						throwUnexpect(word);
				}
			}
			
			if (use_constant_scale || !use_interpolated_scale) {
				var a:Scale2AffectorData=new Scale2AffectorData();
				a.widthStart=width_range_start;
				a.widthEnd=width_range_end;
				a.heightStart=height_range_start;
				a.heightEnd=height_range_end;
				a.uniformSize=uniform_size;
				a.doScale=use_constant_scale;
				a.rateX=sx;
				a.rateY=sy;
				_curEffectElemData.affectors.push(a);
				
				curAffector = a;
			} else {
				var a6:Scale6AffectorData=new Scale6AffectorData();
				a6.repeatTimes=repeat_times;
				a6.time=new Vector.<Number>(6);
				a6.scale=new Vector.<Vector3D>(6);
				for (var i:int=0;i<6;i++) {
					a6.time[i]=timeadj[i];
					a6.scale[i] = new Vector3D(xadj[i],yadj[i]);
				}
				_curEffectElemData.affectors.push(a6);
				
				curAffector = a6;
				
			}
		}
		
		private function readRotationAffector():void
		{
			expectWord("{");
			
			var curAffector:RotationAffectorData=new RotationAffectorData();
			
			var end:Boolean=false;
			while (!end) {
				var word:String=readNoBlank();
				switch (word) {
					case "rotation_speed_range_start":
						curAffector.rotationSpeedStart=readNumber();
						break;
					case "rotation_speed_range_end":
						curAffector.rotationSpeedEnd=readNumber();
						break;
					case "rotation_range_start":
						curAffector.rotationStart=readNumber();
						break;
					case "rotation_range_end":
						curAffector.rotationEnd=readNumber();
						break;
					case "}":
						end=true;
						break;
					default:
						throwUnexpect(word);
				}
			}
			
			if (curAffector.rotationStart || curAffector.rotationEnd || curAffector.rotationSpeedStart || curAffector.rotationSpeedEnd) {
				_curEffectElemData.affectors.push(curAffector);
				
				++rot_valid;
			} else {
				//trace("无效果的rotationAffector",_curEffectElemData.name);
				++rot_no_valid;
			}
		}
		
		private function readRotation6Affector():void
		{
			expectWord("{");
			
			var curAffector:AffectorData;
			var rotation_speed:Number;
			var radius_increment:Number;
			var rotation_axis:Vector3D;
			var center_offset_min:Vector3D;
			var center_offset_max:Vector3D;
			var radius_increment_scale:Array=[];
			var timeadj:Array=[];
			var repeat_times:Number;
			var use_radius_increment_scale:Boolean;
			
			var end:Boolean=false;
			while (!end) {
				var word:String=readNoBlank();
				switch (word) {
					case "radius_increment":
						radius_increment=readNumber();
						break;
					case "rotation_speed":
						rotation_speed=readNumber();
						break;
					case "rotation_axis":
						rotation_axis=readVector3D_z();
						break;
					case "center_offset_min":
						center_offset_min=readVector3D_z();
						break;
					case "center_offset_max":
						center_offset_max=readVector3D_z();
						break;
					case "radius_increment_scale0":
						radius_increment_scale[0]=readNumber();
						break;
					case "radius_increment_scale1":
						radius_increment_scale[1]=readNumber();
						break;
					case "radius_increment_scale2":
						radius_increment_scale[2]=readNumber();
						break;
					case "radius_increment_scale3":
						radius_increment_scale[3]=readNumber();
						break;
					case "radius_increment_scale4":
						radius_increment_scale[4]=readNumber();
						break;
					case "radius_increment_scale5":
						radius_increment_scale[5]=readNumber();
						break;
					case "time0":
						timeadj[0]=readNumber();
						break;
					case "time1":
						timeadj[1]=readNumber();
						break;
					case "time2":
						timeadj[2]=readNumber();
						break;
					case "time3":
						timeadj[3]=readNumber();
						break;
					case "time4":
						timeadj[4]=readNumber();
						break;
					case "time5":
						timeadj[5]=readNumber();
						break;
					case "repeat_times":
						repeat_times=readNumber();
						break;
					case "use_radius_increment_scale":
						use_radius_increment_scale=readNoBlank()=="true";
						break;
					case "}":
						end=true;
						break;
					default:
						throwUnexpect(word);
				}
			}
			
			if (use_radius_increment_scale) {
				var a:Rotation6AffectorData=new Rotation6AffectorData();
				a.speed=rotation_speed;
				a.axis=rotation_axis;
				a.centerMin=center_offset_min;
				a.centerMax=center_offset_max;
				a.repeatTimes=repeat_times;
				a.time=new Vector.<Number>(6);
				a.radius=new Vector.<Number>(6);

				for (var i:int=0;i<6;i++) {
					a.time[i]=timeadj[i];
					a.radius[i] = radius_increment_scale[i];
				}
				_curEffectElemData.affectors.push(a);
				
				curAffector = a;
				
			} else {
				var a2:Rotation2AffectorData=new Rotation2AffectorData();
				a2.speed=rotation_speed;
				a2.axis=rotation_axis;
				a2.centerMin=center_offset_min;
				a2.centerMax=center_offset_max;
				a2.radiusInc=radius_increment;
				_curEffectElemData.affectors.push(a2);
				
				curAffector = a2;
			}
		}
		
		private function readMotionAffector():void
		{
			expectWord("{");
			
			var curAffector:MotionAffectorData=new MotionAffectorData();
			
			var end:Boolean=false;
			while (!end) {
				var word:String=readNoBlank();
				switch (word) {
					case "use_start_velocity":
						curAffector.setSpeed=readNoBlank()=="true";
						break;
					case "start_velocity_min":
						curAffector.minSpeed=readVector3D_z();
						break;
					case "start_velocity_max":
						curAffector.maxSpeed=readVector3D_z();
						break;
					case "acceleration":
						curAffector.force=readVector3D_z();
						break;
					case "randomness_min":
						curAffector.randomnessMin=readVector3D_z();
						break;
					case "randomness_max":
						curAffector.randomnessMax=readVector3D_z();
						break;
					case "velocity_loss_min":
					case "velocity_loss_max":
						readVector3D_z();
						break;
					case "}":
						end=true;
						break;
					default:
						throwUnexpect(word);
				}
			}
			
			_curEffectElemData.affectors.push(curAffector);
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
		
		private function readVector3D_z():Vector3D
		{
			var v:Vector3D=new Vector3D();
			v.x=readNumber();
			v.y=readNumber();
			v.z=-readNumber();
			return v;
		}
		
		private function readColor():Vector3D
		{
			var v:Vector3D=new Vector3D();
			v.x=readNumber();
			v.y=readNumber();
			v.z=readNumber();
			v.w=readNumber();
			return v;
		}
	}
}