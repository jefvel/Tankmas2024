package squid.util;

class XmlUtils
{
	public static inline function element(xml:Xml, ?element_name:String, ?element_name_aliases:Array<String>):Xml
	{
		var return_element:Xml = null;

		for (n in element_aliases(element_name, element_name_aliases))
		{
			return_element = xml.elementsNamed(n).next();
			break;
		}

		return return_element;
	}

	static inline function elements_array(xml:Xml, ?element_name:String, ?element_name_aliases:Array<String>):Array<Xml>
	{
		var return_array:Array<Xml> = [];

		for (iterator_name in element_aliases(element_name, element_name_aliases))
			for (element_xml in xml.elementsNamed(iterator_name))
				return_array.push(element_xml);

		return return_array;
	}

	static inline function element_exists(xml:Xml, ?element_name:String, ?element_name_aliases:Array<String>):Bool
	{
		var result:Bool = false;
		for (n in element_aliases(element_name, element_name_aliases))
			if (xml.elementsNamed(n).hasNext())
			{
				result = true;
				break;
			}

		return result;
	}

	public static inline function get_int(xml:Xml, ?default_int:Int, ?element_name:String, ?element_name_aliases:Array<String>):Int
	{
		var return_element:Int = default_int;
		element_name_aliases = element_name_aliases == null ? [element_name] : element_name_aliases;

		for (n in element_name_aliases)
		{
			if (xml.get(n) != null)
				return_element = Std.parseInt(xml.get(n));
			break;
		}

		return default_int;
	}

	public static inline function get_float(xml:Xml, ?default_float:Float, ?element_name:String, ?element_name_aliases:Array<String>):Float
	{
		var return_element:Float = default_float;
		element_name_aliases = element_name_aliases == null ? [element_name] : element_name_aliases;

		for (n in element_name_aliases)
		{
			if (xml.get(n) != null)
				return_element = Std.parseFloat(xml.get(n));
			break;
		}

		return return_element;
	}

	public static function element_aliases(?element_name:String, ?element_name_aliases:Array<String>):Array<String>
	{
		if (element_name != null && element_name_aliases != null)
			throw "UtilsXML.element() error: element_name and element_name_aliases can't both be true!";
		return element_name_aliases == null ? [element_name] : element_name_aliases;
	}

	public static inline function tags(xml:Xml, tag:String):Array<Xml>
	{
		var xml:Xml = xml;
		if (xml.elementsNamed("root").hasNext())
			xml = xml.elementsNamed("root").next();
		return xml.elements_array(tag);
	}

	public static inline function has_tags(xml:Xml, tag:String):Bool
		return xml.tags(tag).length > 0;

	public static inline function first_tag(xml:Xml, tag:String):Xml
		return xml.tags(tag)[0].firstChild();

	public static inline function first_tag_val(xml:Xml, tag:String):String
		return xml.first_tag(tag).toString();

	public static inline function first_tag_int(xml:Xml, tag:String):Int
		return Std.parseInt(xml.first_tag_val(tag));

	public static inline function first_tag_float(xml:Xml, tag:String):Float
		return Std.parseFloat(xml.first_tag_val(tag));
}
