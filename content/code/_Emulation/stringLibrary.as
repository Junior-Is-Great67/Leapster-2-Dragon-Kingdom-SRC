// StringLibrary.as
// Description:	String extension
// Platform:	Flash Player 5 or later versions
// Actionscript:	1.0
// Author:		Johnny Ngo

String.prototype.ltrim = function()
// This methods trims all of the white space from the left side of a String.
{

	var size = this.length;
	for(i = 0; i < size; i++)
	{
		if(this.charCodeAt(i) > 32)
		{
			return String(this.substring(i));
		}
	}
	return "";

}

String.prototype.rtrim = function()
// This methods trims all of the white space from the right side of a String.
{
	var size = this.length;
	for(i=size-1;  i >= 0; i--)
	{
		if(this.charCodeAt(i) > 32)
		{
			return this.substring(0, i + 1);
		}
	}
	return '';
}

String.prototype.trim = function()
// This methods trims all of the white space from both sides of a String.
{
	var sTemp = String(this.replaceAll("  ", " "));
	return sTemp.rtrim().ltrim();
}

String.prototype.endsWith = function(s)
// This methods returns true if the String ends with the string passed into
// the method. Otherwise, it returns false.
{
	return(substring(this, this.length - s.length + 1) == s);
}

String.prototype.beginsWith = function(s)
// This methods returns true if the String begins with the string passed into
// the method. Otherwise, it returns false.
{
	return(s == substring(this, 1, s.length));
}

String.prototype.replace = function(s1, s2)
// replace s1 by s2
{	
	var i  = this.indexOf(s1);
	if (i<0) return this;
	var len = s1.length;
	return (substring(this, 0, i)+ s2 + substring(this, i+len+1, this.length));
}

String.prototype.replaceAll = function(s1, s2)
// replace s1 by s2
{
	var sTemp = new String(this);
	while(sTemp.indexOf(s1) >= 0)
	{
		sTemp = sTemp.replace(s1, s2);
	}	
	return sTemp;
}
