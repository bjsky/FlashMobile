package potato.display3d.loader
{
    import core.display.BlendMode;
    import core.display3d.Vector3D;
    
    import flash.utils.Dictionary;
    
    import potato.display3d.data.MaterialData;
    import potato.display3d.data.PassData;
    
	/**
	 * 材质解析
	 */
    public class MaterialParser extends TxtParser
    {	
		public static var path:String = "";
		
        private var curMaterial:MaterialData;
        private var curPass:PassData;
		private var _countMaterials:uint;
		private var mastDic:Dictionary=new Dictionary();
		private var _url:String
		
        public function MaterialParser()
        {
        }
        
		public function get countMaterials():uint
		{
			return _countMaterials;
		}

        public function parse(url:String):Vector.<MaterialData>
        {
			_url=url;
            loadFile(url);
			
			var materials:Vector.<MaterialData>=new Vector.<MaterialData>();
			
            for (;;) {
                var word:String=readWord();
                if (!word)
                    break;
                if (word=="material") {
					_countMaterials++;
                    curMaterial=new MaterialData();
					curMaterial.passes=new Vector.<PassData>();
                    readMaterial();
					if (mastDic[curMaterial.name])
					{
						trace("material same name:"+curMaterial.name)
						continue
					}
					else 
					{
						trace("material:"+curMaterial.name)
						mastDic[curMaterial.name]=true;
						materials.push(curMaterial);
					}
                } else if (word=="fragment_program")
                    readProgram();
                else if (word=="vertex_program")
                    readProgram();
                else
                    throwUnexpect(word);
            }
			
			return materials;
        }
        
//        public function saveMaterials(p:String):void
//        {
//            
//            var b:ByteArray=new ByteArray();
//            b.writeObject(materials);
//            File.writeByteArray(p,b);
//        }
//        
        private function readProgram():void
        {
            var name:String=readNoBlank();
            expectWord("cg");
            
            expectWord("{");
            var end:Boolean=false;
            while (!end) {
                var word:String=readNoBlank();
                switch (word) {
                case "source":
                    readNoBlank();
                    break;
                case "entry_point":
                    readNoBlank();
                    break;
                case "profiles":
                    readNoBlank();
                    readNoBlank();
                    break;
                case "default_params":
                    readParam();
                    break;
                case "}":
                    end=true;
                    break;
                default:
                    throwUnexpect(word);
                }
            }
        }
        
        private function readMaterial():void
        {
            var techNum:int=0;
            var template:String=null;
            var texture:String=null;
            
            var name:String=readNoBlank();
            curMaterial.name=name;
//			Global.richTF.appendText(name);
            if (name.indexOf(":")>0) {
                template=readNoBlank();
            }
            var word:String=readNoBlank();
            if (word==":") {
                template=readNoBlank();
                expectWord("{");
            } else if (word!="{")
                throwUnexpect(word);
            
            for (;;) {
                word=readNoBlank();
                if (word=="technique") {
                    expectWord0Or1Times("testtech");
                    expectWord("{");
                    
                    if (++techNum>=2)
                        throw new Error("多technique "+line);
                    
                    for (;;) {
                        word=readNoBlank();
                        if (word=="}")
                            break;
                        if (word=="pass") {
                            curPass=new PassData();
                            readPass();
                            curMaterial.passes.push(curPass);
                        } else
                            throwUnexpect(word);
                    }
                } else if (word=="set_texture_alias") {
                    word=readNoBlank();
                    if (word!="<baseTexture>" && word!="<BaseTexture>")
                        throwUnexpect(word);
                    texture=readNoBlank();
                } else if (word == "pass") { //直接读pass
					curPass=new PassData();
					readPass();
					curMaterial.passes.push(curPass);
				}
				else if (word=="}") {
                    break;
                } else
                    throwUnexpect(word);
            }
            
            if (template && curMaterial.passes.length==0 && texture) {
                curPass=new PassData();
                curPass.texture=changeTexture(texture);
                curPass.texture_num=1;
                curMaterial.passes.push(curPass);
            }
        }
        
        private function readPass():void
        {
            var word:String=readNoBlank();
            if (word!="{")
                expectWord("{");
            
            var end:Boolean=false;
            while (!end) {
                word=readNoBlank();
                switch (word) {
                case "lighting":
                    word=readNoBlank();
                    if (word=="off")
                        curPass.lighting=false;
                    else
                        throwUnexpect(word);
                    break;
				case "frameAnim":
					var v:Vector3D = new Vector3D();
					v.x = readNumber();
					v.y = readNumber();
					v.z = readNumber();
					curPass.frameAnim = v;
					break;
                case "scene_blend":
                    word=readNoBlank();
                    if (word=="add")
                        curPass.blend=BlendMode.BLEND_ADD;
                    else if (word=="alpha_blend" || word =="alpha") //兼容alpha
                        curPass.blend=BlendMode.BLEND_ALPHA;
                    else if (word=="colour_blend")
                        curPass.blend=BlendMode.BLEND_COLOR;
                    else if (word=="modulate")
                        curPass.blend=BlendMode.BLEND_MODULATE;
                    else if (word=="zero") {
                        word=readNoBlank();
                        if (word=="one_minus_src_colour")
                            curPass.blend=BlendMode.BLEND_MASK;
					}else if (word=="one"){
						word=readNoBlank();
						if (word=="one_minus_src_alpha")
                         curPass.blend=BlendMode.BLEND_NO;
					}
                    else
                        throwUnexpect(word);
                    break;
                case "depth_check":
                    word=readNoBlank();
                    if (word=="off")
                        curPass.depthCheck=false;
                    else if (word=="on")
                        curPass.depthCheck=true;
                    else
                        throwUnexpect(word);
                    break;
                case "depth_bias":
                    curPass.depthBias=readNumber();
                    break;
                case "depth_write":
                    word=readNoBlank();
                    if (word=="off")
                        curPass.depthWrite=false;
                    else
                        throwUnexpect(word);
                    break;
                case "colour_write":
                    word=readNoBlank();
                    if (word=="off")
                        curPass.colorWrite=false;
                    else
                        throwUnexpect(word);
                    break;
                case "ambient":
                    curPass.ambient=readColor();
                    break;
                case "diffuse":
//					word=readWord();
//					if (word=="vertexcolour")
//					{
//						
//					}
//					else 
//					{
//						setBApos(word.length);
                    	curPass.diffuse=readColor();
//					}
                    break;
                case "specular":
                    readSpecular(curPass);
                    break;
                case "emissive":
                    readColor();
                    break;
                case "alpha_rejection":
                    word=readNoBlank();
                    var ar:Number=readNumber();
                    switch (word) {
                    case "greater":
                        curPass.alphaReject=ar/255;
                        break;
                    case "greater_equal":
                        curPass.alphaReject=(ar-0.1)/255;
                        break;
                    default:
                        throwUnexpect(word);
                    }
                    break;//			alpha_rejection greater 127
                case "fog_override":
                    readNoBlank();
                    expectWord0Or1Times("none");
                    break;
                case "cull_hardware":
                    readNoBlank();
                    break;
                case "cull_software":
                    readNoBlank();
                    break;
                case "texture_unit":
                    readTexture();
                    curPass.texture_num++;
                    break;
                case "vertex_program_ref":
                    readVertexProgram();
                    curMaterial.useProgram=true;
                    break;
                case "fragment_program_ref":
                    readVertexProgram();
                    curMaterial.useProgram=true;
                    break;
                case "}":
                    end=true;
                    break;
                default:
                    throwUnexpect(word);
                }
            }
        }
        
        private function changeTexture(tex:String):String
        {
            var ext:int=tex.lastIndexOf(".");
            if (ext>=0) {
                switch (tex.substring(ext+1)) {
                case "dds":
				case "DDS":
                case "png":
				case "PNG":
                case "tga":
				case "TGA":	
                case "jpg":
				case "JPG":
                case "psd":
				case "bmp":
				case "BMP":
                    return tex.substring(0,ext);;
                default:
					trace("纹理扩展名不支持 "+line);
                    throw new Error("纹理扩展名不支持 "+line);
                }
            }
            return tex;
        }
        
        private function readTexture():void
        {
            var word:String=readNoBlank();
            if (word!="{") {
                expectWord("{");
            }
            var end:Boolean=false;
            while (!end) {
                word=readNoBlank();
                switch (word) {
                case "texture":
                    curPass.texture=changeTexture(readNoBlank());
                    expectWord0Or1Times("-1");
                    expectWord0Or1Times("1d");
                    break;
                case "anim_texture":
                    for (;;) {
                        word=readNoBlank();
                        if (!isNaN(parseFloat(word)))
                            break;
                    }
                    readNumberDefault();
                    break;
                case "tex_address_mode":
                    word=readNoBlank();
                    if (word=="clamp")
                        expectWord0OrAnyTimes("clamp");
                    break;
                case "colour_op_ex":
                    readNoBlank();
                    readNoBlank();
                    word=readNoBlank();
                    if (word=="src_manual") {
                        readNumber();
                        readNumber();
                        readNumber();
                    }
                    break;
                case "colour_op_multipass_fallback":
                    readNoBlank();
                    readNoBlank();
                    break;
                case "alpha_op_ex":
                    readNoBlank();
                    readNoBlank();
                    readNoBlank();
                    break;
                case "scale":
                    readNoBlank();
                    readNoBlank();
                    break;
                case "rotate":
                    readNoBlank();
                    break;
				case "env_map":
					readNoBlank()
					break;
				case "colour_op":
					readNoBlank();
					break;
                case "rotate_anim":
                    readNoBlank();
                    break;
                case "filtering":
                    word=readNoBlank();
                    if (word=="none")
                        expectWord0OrAnyTimes("none");
                    break;
                case "tex_coord_set":
                    readNoBlank();
                    break;
                case "scroll_anim":
                    readNoBlank();
                    readNoBlank();
                    break;
                case "scroll":
                    readNoBlank();
                    readNoBlank();
                    break;
                case "wave_xform":
                    readNoBlank();
                    readNoBlank();
                    readNoBlank();
                    readNoBlank();
                    readNoBlank();
                    readNoBlank();
                    break;
                case "}":
                    end=true;
                    break;
                default:
					trace('无法识别的源文件字段：'+word);
//                    throwUnexpect(word);
                }
            }
        }
        
        private function readVertexProgram():void
        {
            readNoBlank();
            readParam();
        }
        
        private function readParam():void
        {
            expectWord("{");
            var end:Boolean=false;
            while (!end) {
                var word:String=readNoBlank();
                switch (word) {
                case "param_named":
                    readOneParam();
                    break;
                case "param_named_auto":
                    readNoBlank();
                    readNoBlank();
                    break;
                case "}":
                    end=true;
                    break;
                default:
                    throwUnexpect(word);
                }
            }
        }
        
        private function readOneParam():void
        {
            var word:String=readNoBlank();
            switch (word) {
            case "colour_amount":
                readNoBlank();
                readNoBlank();
                break;
            case "gray_amount":
                readNoBlank();
                readNoBlank();
                break;
            case "direction":
                readNoBlank();
                readNoBlank();
                readNoBlank();
                break;
            case "brightness":
                expectWord("float");
                readNumber();
                break;
            case "blur_amount":
                expectWord("float");
                readNumber();
                break;
            case "shine_amount":
                expectWord("float");
                readNumber();
                break;
            case "random_fractions":
            case "depth_modulator":
            case "heatBiasScale":
            case "blurAmount":
                expectWord("float4");
                readNumber();
                readNumber();
                readNumber();
                readNumber();
                break;
            default:
                throwUnexpect(word);
            }
        }
        
        private function readColor():uint
        {
            var r:uint=readNumber()*255;
            var g:uint=readNumber()*255;
            var b:uint=readNumber()*255;
            var a:uint=readNumberDefault(1)*255;
            //if (a!=255)
                //throw new Error("非法的颜色值 "+line);
            return (r<<16)|(g<<8)|b;
        }
        
        private function readSpecular(pass:PassData):void
        {
            var r:uint=readNumber()*255;
            var g:uint=readNumber()*255;
            var b:uint=readNumber()*255;
            var aa:Number=readNumber();
            var gloss:Number=readNumberDefault(-1);
            if (gloss==-1) {
                gloss=aa;
            } else if (aa!=1)
                trace("非法的颜色值 "+line);
            pass.diffuse=(r<<16)|(g<<8)|b;
            pass.gloss=gloss;
        }
		
//		private function loadMaterials(path:String):void
//		{
//			MaterialData.registerAlias();
//			PassData.registerAlias();
//			
//			var b:ByteArray=File.readByteArray(path);
//			materials=b.readObject();
//		}
    }
}