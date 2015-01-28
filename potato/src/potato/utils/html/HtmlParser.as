package potato.utils.html
{
	import flash.utils.Dictionary;

	/**
	 * html解释器.
	 * <p>转自开源的.net HtmlParser，封装了htmlNode对象</p>
	 * @author liuxin
	 * 
	 */
	public class HtmlParser
	{
		public function HtmlParser()
		{
		}
		
		private static var plaintext:RegExp = new RegExp("^([^<]+)");
		// plainstarttag = new Regex("^(<([a-zA-Z]+)>)");
		private static var starttag:RegExp = new RegExp("^<");
		private static var endtag:RegExp = new RegExp("^</");
		
		private static var closetag:RegExp = new RegExp("^>");
		private static var endsingletag:RegExp = new RegExp("^/?>");
		
		private static var tagname:RegExp =  new RegExp("^(([a-zA-Z][a-zA-Z0-9\\.\\-]*) *)", "m");
		private static var endtagname:RegExp =  new RegExp("^([a-zA-Z][a-zA-Z0-9\\.\\-]*)( *>)", "m");
		
		private static var commentstart:RegExp =  new RegExp("^(<!)");
		
		// Missing Pattern.DOTALL
		// comment_working =  new Regex("^(?:--)?(([^>]*?)--)", System.Text.RegularExpressions.RegexOptions.Multiline);
		private static var comment_finish:RegExp =  new RegExp("^([^>]*?)>", "m");
		
		// Attempts to grab the entire attribute string. This means multiple
		// attributes appear in our string. So we need to parse this substring 
		// again
		private static var attribute:RegExp =  new RegExp("^(([a-zA-Z][a-zA-Z0-9.\\-_:]*) *)", "m");
		
		// The value of the attribute. Either in quotes or not
		private static var unquotedvalue:RegExp =  new RegExp("(^= *([^\"\'> ][^> ]*) *)", "m");
		private static var quotedvalue:RegExp =  new RegExp("(^= *([\"])(.*?)([\"]) *)", "m");
		
		
		private static var _nodeList:Vector.<HtmlNode>;
		private static var _parseNodeList:Vector.<HtmlNode>;
		private static var _node:HtmlNode;
		
		private static function openNode():void{
			_node=new HtmlNode();
			_node.children=new Vector.<HtmlNode>()
				
			if(_nodeList.length>0)
				_nodeList[_nodeList.length-1].children.push(_node);
			else
				_parseNodeList.push(_node);
			
			_nodeList.push(_node);
		}
		
		private static function closeNode():void{
			_nodeList.pop();
			_node=null;
		}
		
		public static function parse(text:String):Vector.<HtmlNode>{
			_nodeList=new Vector.<HtmlNode>();
			_parseNodeList=new Vector.<HtmlNode>();
			
			while (true)
			{
				// We do this as we nibble at the text. If the length does not
				// change in a pass then we have stopped nibbling and should 
				// exit.
				var length:int = text.length;
				
				// Match results for our current text with our regular expressions
				var text_match:Object = plaintext.exec(text);
				var start_match:Object = starttag.exec(text);
				var end_match:Object = endtag.exec(text);
				var start_comment:Object = commentstart.exec(text);
				
				if (success(text_match))
				{
					// Consume this part of the text
					var isOpen:Boolean=false;
					if(!_node){
						isOpen=true;
						openNode();
					}
					
					text = remove(text,text_match);
					
					_node.text=text_match[0];
					
					if(isOpen)
						closeNode();
					// Fire event
//					if(this.Text != null)
//					{
//						TextEvent tagname = new TextEvent(text_match.Value);
//						this.Text(this, new TextEventArgs(tagname));
//					}
				}
//				else if (start_comment.lenght>-1)
//				{
//					// ^(<!)
//					// Consume start of comment and eat text till end of comment
//					// encountered. Then fire event with comment text
//					text = remove(text,start_comment.index, start_comment[0].length);
//					
//					// Build a comment body matcher instance.
//					// System.Text.RegularExpressions.Match comment_body_matcher = comment_working.Match(text);
//					
//					System.Text.StringBuilder comment_text = new System.Text.StringBuilder();
//					
//					// ^(([^>]*?)--) 
//					//	if(comment_body_matcher.matches())
//					//	{
//					//			text = comment_body_matcher.replaceFirst("");		
//					// Assign the comment part to eaten and if there was 
//					// text immediately after the <! we treat that as a declaration
//					// and store it.
//					//			eaten.append(comment_body_matcher.group(1));
//					//	}
//					
//					// Finish the comment tag.
//					
//					// Make a new comment end matcher and see if it matches our text
//					System.Text.RegularExpressions.Match comment_stop = comment_finish.Match(text);
//					
//					if (comment_stop.Success)
//					{
//						// Consume
//						text = text.Remove(comment_stop.Index, comment_stop.Length);
//						
//						// Grab the comment text and fire event
//						comment_text.Append(comment_stop.Groups[1].Value.ToString());
//						
//						// Now this text is either a comment or a declaration. As
//						// both start with <! we will have to check.
//						string finaltext = comment_text.ToString();
//						
//						if(finaltext.StartsWith("--"))
//						{
//							// Treat as a comment
//							if(this.Comment != null)
//							{
//								CommentEvent tagname = new CommentEvent(finaltext);
//								this.Comment(this, new CommentEventArgs(tagname));
//							}
//						}
//						else
//						{
//							// Treat as a declaration
//							if(this.Declaration != null)
//							{
//								DeclarationEvent tagname = new DeclarationEvent(finaltext);
//								this.Declaration(this, new DeclarationEventArgs(tagname));
//							}
//						}
//					}
//					else
//					{
//						// No end point - text event plus an exception.
//					}
//				}
				else if (success(end_match))
				{
					//System.Windows.Forms.MessageBox.Show("end tag");
					// Consume and try to see if we have an end tag name or no
					text = remove(text,end_match);
					
					// Make a new matcher for the end tag pattern.
					var endtagname_match:Object = endtagname.exec(text);
					
					if (success(endtagname_match))
					{
						// $self->end(lc($1), "</$1$2");
						text = remove(text,endtagname_match);
						
						
//						if(this.EndTag != null)
//						{
//							EndEvent mytag = new EndEvent(endtagname_match.Groups[1].ToString());
//							this.EndTag(this, new EndTagEventArgs(mytag));
//						}
					}
					
					closeNode();
				}
				else if (success(start_match))
				{
					openNode();
					
					text = startTagHandler(start_match, text);
				}
				else
				{
					// Nothing recognisable - The end of the file mayhap?
					trace("Could not recognise anything from here onwards");
				}
				
				if (length == text.length)
				{
					// The string has not changed - a quick hack while we test. 
					// This is definitely the end of the parsing run.
					break;
				}
			}
			
			return _parseNodeList;
		}
		
		private static function startTagHandler(start:Object,text:String):String
		{
			// A start tag with possible attributes
			text = remove(text,start);
			
			// Find the name of the tag.
			var tagname_match:Object = tagname.exec(text);
			
			if (success(tagname_match))
			{
				// Consume the tag
				text = remove(text,tagname_match);
				
				// Find the attributes within our text
//				String eaten = tagname_match.Groups[1].ToString();
				var name:String = tagname_match[2];
				
				_node.name=name;
				
				// Grab the attributes of this tag - todo
				var attr_match:Object = attribute.exec(text);
				_node.attributes=new Dictionary();
				
				while (success(attr_match))
				{
					// Replace
					text = remove(text,attr_match);
					
					// Update eaten and build up our attribue stuff
					var attr:String = String(attr_match[2]).toLowerCase();
//					eaten = new System.Text.StringBuilder(eaten + attr_match.Groups[2]).ToString();
					var value_Renamed:String;
					
					// Fill in the value and update eaten with what we are looking
					// at
					var unquoted_match:Object = unquotedvalue.exec(text);
					var quoted_match:Object = quotedvalue.exec(text);
					
					if (success(unquoted_match))
					{
						// Nibble
						text = remove(text,unquoted_match);
						
//						eaten = new System.Text.StringBuilder(eaten + unquoted_match.Groups[1]).ToString();
						value_Renamed = unquoted_match[2];
					}
					else if (success(quoted_match))
					{
						// Chew
						text = remove(text,quoted_match);
						
//						eaten = new System.Text.StringBuilder(eaten + quoted_match.Groups[1]).ToString();
						value_Renamed = quoted_match[3];
					}
					else
					{
						value_Renamed = attr;
					}
					
					// Now store in a hash of attributes
					_node.attributes[attr] = value_Renamed;
					
					// Go again
					attr_match = attribute.exec(text);
				}
				
				
				// Grab the end of the tag. If we don't find it then the tag isn't
				// closed and is not valid.
				var close_match:Object = closetag.exec(text);
				var closesingle_match:Object = endsingletag.exec(text);
				
				if (success(close_match))
				{
					// A full tag - the tag was closed
					text = remove(text,close_match);
					
					// Send off the tag
//					if(this.StartTag != null)
//					{
//						StartEvent mytag = new StartEvent(name, attributes);
//						this.StartTag(this, new StartTagEventArgs(mytag));
//					}
					
					// Double check tags that close but may not have been closed properly.
					// Currently we shall allow: br, hr, meta, img and nobr. This should come
					// from a config.
//					if(
//						name.StartsWith("br") || 
//						name.StartsWith("hr") ||
//						name.StartsWith("meta") ||
//						name.StartsWith("nobr") ||
//						name.StartsWith("img") ||
//						name.StartsWith("input")
//					)
//					{
//						// And now the end
//						//System.Windows.Forms.MessageBox.Show(tagname_match.Value);
//						//System.Windows.Forms.MessageBox.Show("Close match for '" + tagname_match.Value + "'");
//						if(this.EndTag != null)
//						{
//							EndEvent mytag = new EndEvent(name);
//							this.EndTag(this, new EndTagEventArgs(mytag));
//						}
//					}
					if(name=="br")
						closeNode();
				}
				else if (success(closesingle_match))
				{
					//System.Windows.Forms.MessageBox.Show("Close single match " + closesingle_match.Value + " " + text.Substring(0, 30).ToString());
					
					// A full tag - the tag was closed
					text = remove(text,closesingle_match);
					
					// Send off the start tag
//					if(this.StartTag != null)
//					{
//						//System.Windows.Forms.MessageBox.Show(name);
//						StartEvent mytag = new StartEvent(name, attributes);
//						this.StartTag(this, new StartTagEventArgs(mytag));
//					}
//					
//					// And now the end
//					if(this.EndTag != null)
//					{
//						//System.Windows.Forms.MessageBox.Show(name);
//						EndEvent mytag = new EndEvent(name);
//						this.EndTag(this, new EndTagEventArgs(mytag));
//					}
					closeNode();
				}
				else
				{
					// Non-compliance :). Treat as text at some point.
					trace("Found something: " + text);
				}
			}
			return text;
		} // End method
		
		
		private static function remove(instr:String,match:Object):String{
			var start:int=match.index;
			var len:int=match[0].length;
			var l:String=instr.substr(0,start);
			var r:String=instr.substr(start+len);
			return l+r;
		}
		
		private static function success(match:Object):Boolean{
			return match && match.length>-1;
		}
	}
}