package potato.utils
{
	

	public class StringUtil
	{
		public function StringUtil()
		{
		}
		
		/** 获取内存地址名**/
		static public function getMemoryName(obj:Object):String{
			var memoryHash:String;
			try{
				StringUtil(obj);
			}catch(e:Error){
				memoryHash =String(e).replace(/.*([@|\$].*?) to .*$/gi,'$1');
			}
			return memoryHash;
		}
		
		/**
		 * 去掉空字符 
		 * @param s
		 * @return 
		 * 
		 */
		static public function regTrim( s:String ):String
		{
			return s.replace( /^([\s|\t|\n]+)?(.*)([\s|\t|\n]+)?$/gm, "$2" );
		}
		
		///////////////////////////////////////////
		// original code
		//////////////////////////////////////////
		
		/**
		 *  Removes all whitespace characters from the beginning and end
		 *  of the specified string.
		 *
		 *  @param str The String whose whitespace should be trimmed. 
		 *
		 *  @return Updated String where whitespace was removed from the 
		 *  beginning and end. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static function trim(str:String):String
		{
			if (str == null) return '';
			
			var startIndex:int = 0;
			while (isWhitespace(str.charAt(startIndex)))
				++startIndex;
			
			var endIndex:int = str.length - 1;
			while (isWhitespace(str.charAt(endIndex)))
				--endIndex;
			
			if (endIndex >= startIndex)
				return str.slice(startIndex, endIndex + 1);
			else
				return "";
		}
		
		/**
		 *  Removes all whitespace characters from the beginning and end
		 *  of each element in an Array, where the Array is stored as a String. 
		 *
		 *  @param value The String whose whitespace should be trimmed. 
		 *
		 *  @param separator The String that delimits each Array element in the string.
		 *
		 *  @return Updated String where whitespace was removed from the 
		 *  beginning and end of each element. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static function trimArrayElements(value:String, delimiter:String):String
		{
			if (value != "" && value != null)
			{
				var items:Array = value.split(delimiter);
				
				var len:int = items.length;
				for (var i:int = 0; i < len; i++)
				{
					items[i] = StringUtil.trim(items[i]);
				}
				
				if (len > 0)
				{
					value = items.join(delimiter);
				}
			}
			
			return value;
		}
		
		/**
		 *  Returns <code>true</code> if the specified string is
		 *  a single space, tab, carriage return, newline, or formfeed character.
		 *
		 *  @param str The String that is is being queried. 
		 *
		 *  @return <code>true</code> if the specified string is
		 *  a single space, tab, carriage return, newline, or formfeed character.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static function isWhitespace(character:String):Boolean
		{
			switch (character)
			{
				case " ":
				case "\t":
				case "\r":
				case "\n":
				case "\f":
					return true;
					
				default:
					return false;
			}
		}
		
		/**
		 *  Substitutes "{n}" tokens within the specified string
		 *  with the respective arguments passed in.
		 *
		 *  @param str The string to make substitutions in.
		 *  This string can contain special tokens of the form
		 *  <code>{n}</code>, where <code>n</code> is a zero based index,
		 *  that will be replaced with the additional parameters
		 *  found at that index if specified.
		 *
		 *  @param rest Additional parameters that can be substituted
		 *  in the <code>str</code> parameter at each <code>{n}</code>
		 *  location, where <code>n</code> is an integer (zero based)
		 *  index value into the array of values specified.
		 *  If the first parameter is an array this array will be used as
		 *  a parameter list.
		 *  This allows reuse of this routine in other methods that want to
		 *  use the ... rest signature.
		 *  For example <pre>
		 *     public function myTracer(str:String, ... rest):void
		 *     { 
		 *         label.text += StringUtil.substitute(str, rest) + "\n";
		 *     } </pre>
		 *
		 *  @return New string with all of the <code>{n}</code> tokens
		 *  replaced with the respective arguments specified.
		 *
		 *  @example
		 *
		 *  var str:String = "here is some info '{0}' and {1}";
		 *  trace(StringUtil.substitute(str, 15.4, true));
		 *
		 *  // this will output the following string:
		 *  // "here is some info '15.4' and true"
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static function substitute(str:String, ... rest):String
		{
			if (str == null) return '';
			
			// Replace all of the parameters in the msg string.
			var len:uint = rest.length;
			var args:Array;
			if (len == 1 && rest[0] is Array)
			{
				args = rest[0] as Array;
				len = args.length;
			}
			else
			{
				args = rest;
			}
			
			for (var i:int = 0; i < len; i++)
			{
				str = str.replace(new RegExp("\\{"+i+"\\}", "g"), args[i]);
			}
			
			return str;
		}
		
		/**
		 *  Returns a string consisting of a specified string
		 *  concatenated with itself a specified number of times.
		 *
		 *  @param str The string to be repeated.
		 *
		 *  @param n The repeat count.
		 *
		 *  @return The repeated string.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4.1
		 */
		public static function repeat(str:String, n:int):String
		{
			if (n == 0)
				return "";
			
			var s:String = str;
			for (var i:int = 1; i < n; i++)
			{
				s += str;
			}
			return s;
		}
		
		/**
		 *  Removes "unallowed" characters from a string.
		 *  A "restriction string" such as <code>"A-Z0-9"</code>
		 *  is used to specify which characters are allowed.
		 *  This method uses the same logic as the <code>restrict</code>
		 *  property of TextField.
		 *
		 *  @param str The input string.
		 *
		 *  @param restrict The restriction string.
		 *
		 *  @return The input string, minus any characters
		 *  that are not allowed by the restriction string.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4.1
		 */
		public static function restrict(str:String, restrict:String):String
		{
			// A null 'restrict' string means all characters are allowed.
			if (restrict == null)
				return str;
			
			// An empty 'restrict' string means no characters are allowed.
			if (restrict == "")
				return "";
			
			// Otherwise, we need to test each character in 'str'
			// to determine whether the 'restrict' string allows it.
			var charCodes:Array = [];
			
			var n:int = str.length;
			for (var i:int = 0; i < n; i++)
			{
				var charCode:uint = str.charCodeAt(i);
				if (testCharacter(charCode, restrict))
					charCodes.push(charCode);
			}
			
			return String.fromCharCode.apply(null, charCodes);
		}
		
		/**
		 *  @private
		 *  Helper method used by restrict() to test each character
		 *  in the input string against the restriction string.
		 *  The logic in this method implements the same algorithm
		 *  as in TextField's 'restrict' property (which is quirky,
		 *  such as how it handles a '-' at the beginning of the
		 *  restriction string).
		 */
		private static function testCharacter(charCode:uint,
											  restrict:String):Boolean
		{
			var allowIt:Boolean = false;
			
			var inBackSlash:Boolean = false;
			var inRange:Boolean = false;
			var setFlag:Boolean = true;
			var lastCode:uint = 0;
			
			var n:int = restrict.length;
			var code:uint;
			
			if (n > 0)
			{
				code = restrict.charCodeAt(0);
				if (code == 94) // caret
					allowIt = true;
			}
			
			for (var i:int = 0; i < n; i++)
			{
				code = restrict.charCodeAt(i)
				
				var acceptCode:Boolean = false;
				if (!inBackSlash)
				{
					if (code == 45) // hyphen
						inRange = true;
					else if (code == 94) // caret
						setFlag = !setFlag;
					else if (code == 92) // backslash
						inBackSlash = true;
					else
						acceptCode = true;
				}
				else
				{
					acceptCode = true;
					inBackSlash = false;
				}
				
				if (acceptCode)
				{
					if (inRange)
					{
						if (lastCode <= charCode && charCode <= code)
							allowIt = setFlag;
						inRange = false;
						lastCode = 0;
					}
					else
					{
						if (charCode == code)
							allowIt = setFlag;
						lastCode = code;
					}
				}
			}
			
			return allowIt;
		}
		
		/**
		 *	Does a case insensitive compare or two strings and returns true if
		 *	they are equal.
		 * 
		 *	@param s1 The first string to compare.
		 *
		 *	@param s2 The second string to compare.
		 *
		 *	@returns A boolean value indicating whether the strings' values are 
		 *	equal in a case sensitive compare.	
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */			
		public static function stringsAreEqual(s1:String, s2:String, 
											   caseSensitive:Boolean):Boolean
		{
			if(caseSensitive)
			{
				return (s1 == s2);
			}
			else
			{
				return (s1.toUpperCase() == s2.toUpperCase());
			}
		}
		
		/**
		 *	Removes whitespace from the front of the specified string.
		 * 
		 *	@param input The String whose beginning whitespace will will be removed.
		 *
		 *	@returns A String with whitespace removed from the begining	
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */	
		public static function ltrim(input:String):String
		{
			var size:Number = input.length;
			for(var i:Number = 0; i < size; i++)
			{
				if(input.charCodeAt(i) > 32)
				{
					return input.substring(i);
				}
			}
			return "";
		}
		
		/**
		 *	Removes whitespace from the end of the specified string.
		 * 
		 *	@param input The String whose ending whitespace will will be removed.
		 *
		 *	@returns A String with whitespace removed from the end	
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */	
		public static function rtrim(input:String):String
		{
			var size:Number = input.length;
			for(var i:Number = size; i > 0; i--)
			{
				if(input.charCodeAt(i - 1) > 32)
				{
					return input.substring(0, i);
				}
			}
			
			return "";
		}
		
		/**
		 *	Determines whether the specified string begins with the spcified prefix.
		 * 
		 *	@param input The string that the prefix will be checked against.
		 *
		 *	@param prefix The prefix that will be tested against the string.
		 *
		 *	@returns True if the string starts with the prefix, false if it does not.
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */	
		public static function beginsWith(input:String, prefix:String):Boolean
		{			
			return (prefix == input.substring(0, prefix.length));
		}	
		
		/**
		 *	Determines whether the specified string ends with the spcified suffix.
		 * 
		 *	@param input The string that the suffic will be checked against.
		 *
		 *	@param prefix The suffic that will be tested against the string.
		 *
		 *	@returns True if the string ends with the suffix, false if it does not.
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */	
		public static function endsWith(input:String, suffix:String):Boolean
		{
			return (suffix == input.substring(input.length - suffix.length));
		}	
		
		/**
		 *	Removes all instances of the remove string in the input string.
		 * 
		 *	@param input The string that will be checked for instances of remove
		 *	string
		 *
		 *	@param remove The string that will be removed from the input string.
		 *
		 *	@returns A String with the remove string removed.
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */	
		public static function remove(input:String, remove:String):String
		{
			return StringUtil.replace(input, remove, "");
		}
		
		/**
		 *	Replaces all instances of the replace string in the input string
		 *	with the replaceWith string.
		 * 
		 *	@param input The string that instances of replace string will be 
		 *	replaces with removeWith string.
		 *
		 *	@param replace The string that will be replaced by instances of 
		 *	the replaceWith string.
		 *
		 *	@param replaceWith The string that will replace instances of replace
		 *	string.
		 *
		 *	@returns A new String with the replace string replaced with the 
		 *	replaceWith string.
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function replace(input:String, replace:String, replaceWith:String):String
		{
			//change to StringBuilder
			var sb:String = new String();
			var found:Boolean = false;
			
			var sLen:Number = input.length;
			var rLen:Number = replace.length;
			
			for (var i:Number = 0; i < sLen; i++)
			{
				if(input.charAt(i) == replace.charAt(0))
				{   
					found = true;
					for(var j:Number = 0; j < rLen; j++)
					{
						if(!(input.charAt(i + j) == replace.charAt(j)))
						{
							found = false;
							break;
						}
					}
					
					if(found)
					{
						sb += replaceWith;
						i = i + (rLen - 1);
						continue;
					}
				}
				sb += input.charAt(i);
			}
			//TODO : if the string is not found, should we return the original
			//string?
			return sb;
		}
		
		/**
		 *	Specifies whether the specified string is either non-null, or contains
		 *  	characters (i.e. length is greater that 0)
		 * 
		 *	@param s The string which is being checked for a value
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */		
		public static function stringHasValue(s:String):Boolean
		{
			//todo: this needs a unit test
			return (s != null && s.length > 0);			
		}
	}
}