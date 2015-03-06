package potato.display3d.loader
{
    import flash.utils.Endian;
    
    import core.display.Texture;
    import core.display3d.Geometry;
    import core.display3d.JointPose;
    import core.display3d.Material;
    import core.display3d.Matrix3D;
    import core.display3d.Mesh;
    import core.display3d.ObjectContainer3D;
    import core.display3d.Quaternion;
    import core.display3d.Skeleton;
    import core.display3d.SkeletonClip;
    import core.display3d.SkeletonClipSet;
    import core.display3d.SkeletonJoint;
    import core.display3d.SkeletonPose;
    import core.display3d.Skin;
    import core.display3d.SkinnedSubGeometry;
    import core.display3d.SubGeometry;
    import core.display3d.Vector3D;
    
    import potato.display3d.core.MaterialManager;

	/**
	 * m3d解析 
	 * @author superFlash
	 * 
	 */
    public class M3DParser extends ParserBase
    {
        private var _inited:Boolean;
        private var _majorVersion:uint;
        private var _minorVersion:uint;
        private var _rootId:uint;
        private var _cur_block_id:uint;
        private var _blocks:Vector.<M3DBlock>;
        
        private var _rotationQuat:Quaternion;
        private var _materialFunc:Function;
        
        public function M3DParser(config:M3DConfig=null,materialFunc:Function=null)
        {
            _blocks=new Vector.<M3DBlock>();
            _blocks[0]=new M3DBlock();
            _blocks[0].data=null;
            
            _materialFunc=materialFunc;
            if (config) {
                if (config.animRotationAxis) {
                    _rotationQuat=new Quaternion();
                    _rotationQuat.fromAxisDegree(config.animRotationAxis,config.animRotationDegree);
                }
            }
        }
        
        protected override function proceedParsing():Boolean
        {
            if (!_inited) {
                _byteData.position=0;
                _byteData.endian=Endian.LITTLE_ENDIAN;
                parseHeader();
                
                _inited=true;
            }
            
            while (hasTime() && _byteData.bytesAvailable) {
                parseNextBlock();
            }
            
            if (_byteData.bytesAvailable)
                return MORE_TO_PARSE;
            obj=_blocks[_rootId].data;
            return PARSING_DONE;
        }
        
        private function parseHeader():void
        {
            _byteData.position=8;
            _majorVersion=_byteData.readUnsignedByte();
            _minorVersion=_byteData.readUnsignedByte();
            _rootId=_byteData.readUnsignedInt()&0xffffff;
            _byteData.position=16;
        }
        
        private function parseNextBlock():void
        {
            var block:M3DBlock;
            var assetData:*;
            
            _cur_block_id=_byteData.readUnsignedInt();
            var type:uint=_cur_block_id>>24;
            _cur_block_id&=0xffffff;
            var len:uint=_byteData.readUnsignedInt();
            
            block=new M3DBlock();
			
            switch (type) {
            case 1:
                assetData=parseGeometry(len);
                break;
            case 2:
                assetData=parseTexture(len);
                break;
            case 3:
                assetData=parseMaterial(len);
                break;
            case 4:
                assetData=parseMesh(len);
                break;
            case 5:
                assetData=parseContainer(len);
                break;
            case 6:
                assetData=parseSkeleton(len);
                break;
            case 7:
                assetData=parseSkeletonPose(len);
                break;
            case 8:
                assetData=parseSkeletonClip(len);
                break;
            case 9:
                assetData=parseSkin(len);
                break;
            case 10:
                assetData=parseAnim(len);
                break;
            case 11:
                assetData=parseNewMesh(len);
                break;
            case 12:
                assetData=parseNewSkin(len);
                break;
            }
            
            _blocks[_cur_block_id]=block;
            _blocks[_cur_block_id].data=assetData;
            _blocks[_cur_block_id].id=_cur_block_id;
        }
        
        private function parseGeometry(blockLength:uint):Geometry
        {
            var num_subs:uint=_byteData.readUnsignedShort();
            var geom:Geometry=new Geometry();
            var j:uint;
            
            for (var i:uint=0;i<num_subs;++i) {
                var jointsPerVertex:uint=_byteData.readUnsignedShort();
                var sub:SubGeometry;
                if (jointsPerVertex)
                    sub=new SkinnedSubGeometry(jointsPerVertex);
                else
                    sub=new SubGeometry();
                var faceNum:uint=_byteData.readUnsignedInt();
                var vertNum:uint=_byteData.readUnsignedInt();
                var bNormal:Boolean=false;
                for (;;) {
                    var type:uint=_byteData.readUnsignedByte();
                    if (type==0)
                        break;
                    var idx:uint=0;
                    switch (type) {
                    case 1:
                        j=vertNum*3;
                        var verts:Vector.<Number>=new Vector.<Number>(j);
                        while (j--) {
                            verts[idx++]=_byteData.readFloat();
                        }
						
                        sub.updateVertexData(verts);
						
                        break;
                    case 2:
                        j=faceNum*3;
                        var indices:Vector.<uint>=new Vector.<uint>(j);
                        while (j--) {
                            indices[idx++]=_byteData.readUnsignedShort();
                        }
                        sub.updateIndexData(indices);
                        break;
                    case 3:
                        j=vertNum*2;
                        var uvs:Vector.<Number>=new Vector.<Number>(j);
                        while (j--) {
                            uvs[idx++]=_byteData.readFloat();
                        }
						
						
                        sub.updateUVData(uvs);
						
                        break;
                    case 4:
                        j=vertNum*3;
                        var normals:Vector.<Number>=new Vector.<Number>(j);
                        while (j--) {
                            normals[idx++]=_byteData.readFloat();
                        }
						
                        sub.updateVertexNormalData(normals);
                        bNormal=true;
                        break;
					case 5:
						// 第二套uv						
						j=vertNum*2;
						var tangets:Vector.<Number>= new Vector.<Number>(j);
						while (j--)
						{
							tangets[idx++]=_byteData.readFloat();
						}
						sub.updateUV2Data(tangets);
						break;
                    case 6:						
                        j=vertNum*jointsPerVertex;
                        var jis:Vector.<uint>=new Vector.<uint>(j);
                        while (j--) {
                            jis[idx++]=_byteData.readUnsignedShort();
                        }
                        (sub as SkinnedSubGeometry).updateJointIndexData(jis);
                        break;
                    case 7:
                        j=vertNum*jointsPerVertex;
                        var jws:Vector.<Number>=new Vector.<Number>(j);
                        while (j--) {
                            jws[idx++]=_byteData.readFloat();
                        }
                        (sub as SkinnedSubGeometry).updateJointWeightsData(jws);
                        break;
                    }
                }
                if (!bNormal)
                    sub.updateVertexNormals();
                geom.addSubGeometry(sub);
            }
            return geom;
        }
        
        private function parseTexture(blockLength:uint):Texture
        {
            var url:String=_byteData.readUTF();
            var tex:Texture=getTexture(url);
            tex.mipmap=true;
            tex.repeat=true;
            return tex;
        }
        
        private function parseMaterial(blockLength:uint):Material
        {
            var tid:uint=_byteData.readUnsignedInt();
            if (tid==0) {
                return readMaterial();
            } else {
                var mat:Material=new Material(_blocks[tid].data as Texture);
                readColor();
                mat.color=readColor();
                mat.specularColor=readColor();
                mat.gloss=_byteData.readFloat();
				mat.specular=1;
                return mat;
            }
        }
        
        private function parseMesh(blockLength:uint):Mesh
        {
            var pid:uint=_byteData.readUnsignedInt();
            var m:MatrixX=readMatrix();
            var name:String=_byteData.readUTF();
            var gid:uint=_byteData.readUnsignedInt();
            var geo:Geometry=_blocks[gid].data as Geometry;
            var mesh:Mesh=new Mesh(geo);
            mesh.name=name;
            mesh.x=m.x;
            mesh.y=m.y;
            mesh.z=m.z;
            mesh.rotationX=m.rx;
            mesh.rotationY=m.ry;
            mesh.rotationZ=m.rz;
            mesh.scaleX=m.sx;
            mesh.scaleY=m.sy;
            mesh.scaleZ=m.sz;
            if (pid)
                (_blocks[pid].data as ObjectContainer3D).addChild(mesh);
            var num_materials:uint=_byteData.readUnsignedShort();
            if (num_materials==1) {
                mesh.material=_blocks[_byteData.readUnsignedInt()].data as Material;
            } else if (num_materials) {
                for (var i:uint=0;i<num_materials;i++) {
                    var material:Material=_blocks[_byteData.readUnsignedInt()].data as Material;
                    mesh.subMeshes[i].material=material;
                }
            }
            
            return mesh;
        }
        
        private function parseNewMesh(blockLength:uint):Mesh
        {
            var name:String=_byteData.readUTF();
            var min:Vector3D=readTranslation();
            var max:Vector3D=readTranslation();
            var radius:Number=_byteData.readFloat();
            var gid:uint=_byteData.readUnsignedInt();
            var geo:Geometry=_blocks[gid].data as Geometry;
            var mesh:Mesh=new Mesh(geo);
            mesh.name=name;
            var num_materials:uint=_byteData.readUnsignedShort();
            if (num_materials==1) {
                mesh.material=readMaterial();
            } else {
                for (var i:uint=0;i<num_materials;i++) {
                    mesh.subMeshes[i].material=readMaterial();
                }
            }
			
            mesh.setBounds(min,max);
            
            return mesh;
        }
        
        private function parseContainer(blockLength:uint):ObjectContainer3D
        {
            var pid:uint=_byteData.readUnsignedInt();
            var m:MatrixX=readMatrix();
            var name:String=_byteData.readUTF();
            var container:ObjectContainer3D=new ObjectContainer3D();
            container.name=name;
            container.x=m.x;
            container.y=m.y;
            container.z=m.z;
            container.rotationX=m.rx;
            container.rotationY=m.ry;
            container.rotationZ=m.rz;
            container.scaleX=m.sx;
            container.scaleY=m.sy;
            container.scaleZ=m.sz;
            if (pid)
                (_blocks[pid].data as ObjectContainer3D).addChild(container);
            
            return container;
        }
        
        private function parseSkeleton(blockLength:uint):Skeleton
        {
            var num_joints:uint=_byteData.readUnsignedShort();
            var skeleton:Skeleton=new Skeleton();
            var joints:Vector.<SkeletonJoint>=new Vector.<SkeletonJoint>();
			var matrix:Matrix3D;
            for (var i:uint=0;i<num_joints;++i) {
                var joint:SkeletonJoint=new SkeletonJoint();
                joint.parentIndex=_byteData.readUnsignedShort()-1;
                joint.name=_byteData.readUTF();
				//trace(joint.name, joint.parentIndex);
				matrix=readMatrix43();
				//matrix.invert();
                joint.inverseBindPose=matrix;
                joints.push(joint);
            }
            skeleton.updateJoints(joints);
            
            return skeleton;
        }
        
        private function parseSkeletonPose(blockLength:uint):SkeletonPose
        {
            var duration:uint=_byteData.readUnsignedShort();
            var num_joints:uint=_byteData.readUnsignedShort();
            var jointPoses:Vector.<JointPose>=new Vector.<JointPose>();
            for (var i:uint=0;i<num_joints;++i) {
                var joint_pose:JointPose=new JointPose();
                joint_pose.orientation=readQuaternion();
                joint_pose.translation=readTranslation();
                if (i==0 && _rotationQuat) {
                    joint_pose.orientation.multiply(_rotationQuat,joint_pose.orientation);
                    joint_pose.translation=_rotationQuat.rotatePoint(joint_pose.translation);
                }
                jointPoses.push(joint_pose);
            }
            var skeletonPose:SkeletonPose=new SkeletonPose();
            skeletonPose.duration=duration;
            skeletonPose.updateJointPoses(jointPoses);
            
            return skeletonPose;
        }
        
        private function parseSkeletonClip(blockLength:uint):SkeletonClip
        {
            var clip:SkeletonClip=new SkeletonClip();
            clip.name=_byteData.readUTF();
            var num_frames:uint=_byteData.readUnsignedShort();
            for (var i:uint=0;i<num_frames;++i) {
                clip.addFrame(_blocks[_byteData.readUnsignedInt()].data as SkeletonPose);
            }
            
            return clip;
        }
        
        private function parseAnim(blockLength:uint):SkeletonClipSet
        {
            var clipSet:SkeletonClipSet=new SkeletonClipSet();
            clipSet.skeleton=_blocks[_byteData.readUnsignedInt()].data as Skeleton;
            var clip_nums:uint=_byteData.readUnsignedShort();
            for (var i:int=0;i<clip_nums;++i) {
                clipSet.addClip(_blocks[_byteData.readUnsignedInt()].data as SkeletonClip);
            }
            return clipSet;
        }
        
        private function parseSkin(blockLength:uint):Skin
        {
            var pid:uint=_byteData.readUnsignedInt();
            var m:MatrixX=readMatrix();
            var name:String=_byteData.readUTF();
            var gid:uint=_byteData.readUnsignedInt();
            var geo:Geometry=_blocks[gid].data as Geometry;
            var skin:Skin=new Skin(geo);
            skin.name=name;
            skin.x=m.x;
            skin.y=m.y;
            skin.z=m.z;
            skin.rotationX=m.rx;
            skin.rotationY=m.ry;
            skin.rotationZ=m.rz;
            skin.scaleX=m.sx;
            skin.scaleY=m.sy;
            skin.scaleZ=m.sz;
            if (pid)
                (_blocks[pid].data as ObjectContainer3D).addChild(skin);
            var num_materials:uint=_byteData.readUnsignedShort();
            if (num_materials==1) {
                skin.material=_blocks[_byteData.readUnsignedInt()].data as Material;
            } else if (num_materials) {
                for (var i:uint=0;i<num_materials;i++) {
                    var material:Material=_blocks[_byteData.readUnsignedInt()].data as Material;
                    skin.subMeshes[i].material=material;
                }
            }
            
            var clipSet:SkeletonClipSet=new SkeletonClipSet();
            clipSet.skeleton=_blocks[_byteData.readUnsignedInt()].data as Skeleton;
            var clip_nums:uint=_byteData.readUnsignedShort();
            for (i=0;i<clip_nums;++i) {
                clipSet.addClip(_blocks[_byteData.readUnsignedInt()].data as SkeletonClip);
            }
            skin.clipSet=clipSet;
            
            return skin;
        }
        
        private function parseNewSkin(blockLength:uint):Skin
        {
            var name:String=_byteData.readUTF();
            var min:Vector3D=readTranslation();
            var max:Vector3D=readTranslation();
            var radius:Number=_byteData.readFloat();
            var gid:uint=_byteData.readUnsignedInt();
            var geo:Geometry=_blocks[gid].data as Geometry;
            var skin:Skin=new Skin(geo);
            skin.name=name;
            var num_materials:uint=_byteData.readUnsignedShort();
            if (num_materials==1) {
                skin.material=readMaterial();
            } else {
                for (var i:uint=0;i<num_materials;i++) {
                    skin.subMeshes[i].material=readMaterial();
                }
            }
            
            skin.setBounds(min,max);
            skin.name=_byteData.readUTF();
			//trace(skin.name);
            
            return skin;
        }
        
        private function readColor():uint
        {
            var c:uint=_byteData.readUnsignedByte()<<16;
            c|=_byteData.readUnsignedByte()<<8;
            c|=_byteData.readUnsignedByte();
            return c;
        }
        
        private function readMatrix():MatrixX
        {
            var m:MatrixX=new MatrixX();
            var flag:uint=_byteData.readUnsignedByte();
            if (flag&1) {
                m.x=_byteData.readFloat();
                m.y=_byteData.readFloat();
                m.z=_byteData.readFloat();
            }
            if (flag&2) {
                m.rx=_byteData.readFloat();
                m.ry=_byteData.readFloat();
                m.rz=_byteData.readFloat();
            }
            if (flag&4) {
                m.sx=_byteData.readFloat();
                m.sy=_byteData.readFloat();
                m.sz=_byteData.readFloat();
            }
            return m;
        }
        
        private function readMatrix43():Matrix3D
        {
            var mtx_raw:Vector.<Number>=new Vector.<Number>(16,true);
            mtx_raw[0] = _byteData.readFloat();
            mtx_raw[1] = _byteData.readFloat();
            mtx_raw[2] = _byteData.readFloat();
            mtx_raw[3] = 0.0;
            mtx_raw[4] = _byteData.readFloat();
            mtx_raw[5] = _byteData.readFloat();
            mtx_raw[6] = _byteData.readFloat();
            mtx_raw[7] = 0.0;
            mtx_raw[8] = _byteData.readFloat();
            mtx_raw[9] = _byteData.readFloat();
            mtx_raw[10] = _byteData.readFloat();
            mtx_raw[11] = 0.0;
            mtx_raw[12] = _byteData.readFloat();
            mtx_raw[13] = _byteData.readFloat();
            mtx_raw[14] = _byteData.readFloat();
            mtx_raw[15] = 1.0;
            
            if (isNaN(mtx_raw[0])) {
                mtx_raw[0] = 1;
                mtx_raw[1] = 0;
                mtx_raw[2] = 0;
                mtx_raw[4] = 0;
                mtx_raw[5] = 1;
                mtx_raw[6] = 0;
                mtx_raw[8] = 0;
                mtx_raw[9] = 0;
                mtx_raw[10] = 1;
                mtx_raw[12] = 0;
                mtx_raw[13] = 0;
                mtx_raw[14] = 0;
            }
            return new Matrix3D(mtx_raw);
        }
        
        private function readQuaternion():Quaternion
        {
            var x:Number=_byteData.readFloat();
            var y:Number=_byteData.readFloat();
            var z:Number=_byteData.readFloat();
            var w:Number=_byteData.readFloat();
            var q:Quaternion=new Quaternion(x,y,z,w);
            return q;
        }
        
        private function readTranslation():Vector3D
        {
            var x:Number=_byteData.readFloat();
            var y:Number=_byteData.readFloat();
            var z:Number=_byteData.readFloat();
            var v:Vector3D=new Vector3D(x,y,z);
            return v;
        }
        
        private function readMaterial():Material
        {
            var name:String=_byteData.readUTF();
            if (_materialFunc!=null)
                return _materialFunc(name);
            return MaterialManager.getMaterial(name);
        }
    }
}

internal class M3DBlock
{
    public var id:uint;
    public var data:*;
}

internal class MatrixX
{
    public var x:Number=0;
    public var y:Number=0;
    public var z:Number=0;
    public var rx:Number=0;
    public var ry:Number=0;
    public var rz:Number=0;
    public var sx:Number=1;
    public var sy:Number=1;
    public var sz:Number=1;
}
