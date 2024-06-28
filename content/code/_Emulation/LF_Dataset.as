// LF_Dataset.as
// Description:	Leapster Dataset emulation
// Platform:	Flash Player 5 or later versions
// Actionscript:	1.0
// Author:		Johnny Ngo

trace("*** Loading LF_Dataset Emulation");

if (typeof _global != "object") _global =_root;	// a hack for Flash 5

// LF_Dataset object ///////////////////////////////////////////////////////
_global.LF_Dataset = function(sFileURL)
// class LF_Dataset
{
	var loaded = false;			// flag
	var myXML = new XML();		// create a local XML object
	myXML.ignoreWhite = true;		// always
	myXML.oCaller = this;			// a reference to this object

	trace(" ** LF_Dataset: Loading XML file: " + sFileURL);
	myXML.load(sFileURL);			// load the xml

	myXML.onLoad = function(bSuccess)	// xml callback
	{
		if (bSuccess)
		{
			this.oCaller.generateNode(this.firstChild, this.oCaller);
			this.oCaller.loaded = true;
			trace("** LF_Dataset: XML file successfully loaded: " + sFileURL);
			this.oCaller.onLoad();	// callback
		}
		else
		{
			trace(" ** LF_Dataset: Invalid XML Exception: " + this.status);
		}
	};
}

//-----------------------------------------------------------------------------------------
LF_Dataset.prototype.generateNode = function(xNode, oRef)
// call this  as a "Static function"
{
	var aTemp = null;
	if (oRef[xNode.nodeName] == null)
	{
		aTemp = oRef[xNode.nodeName] = [{}];	// create a new array of object
	}
	else
	{
		aTemp = oRef[xNode.nodeName];
		oRef[xNode.nodeName].unshift({});	// add a new object to the beginning of the array
									// instead of the end to reverse the stack (recusion)
	}

	oRef = aTemp[0];					// just a reference

	if (xNode.hasChildNodes())
	{
		if (xNode.firstChild.nodeType == 1)	// a xml node
		{
			oRef.attributes = xNode.attributes;	// attributes for the object
			for (var i in xNode.childNodes)
				this.generateNode(xNode.childNodes[i], oRef);		// recusion the children
		}
		else if (xNode.firstChild.nodeType == 3)	// a text node
		{
			aTemp[0] = new String(xNode.firstChild.nodeValue);
			aTemp[0].attributes = xNode.attributes;
			//trace(xNode.nodeName  + " = " + aTemp[0]);
		}
	}
	else	// empty node
	{
		oRef.attributes = xNode.attributes;
	}
}
//-----------------------------------------------------------------------------------------
// Callback events
LF_Dataset.prototype.onLoad = function() {};
