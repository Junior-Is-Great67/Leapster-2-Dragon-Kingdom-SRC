// Leapster.as
// Description:	Leapster Flash Emulator
// Platform:	Flash Player 6
// Actionscript:	1.0
// Author:		Johnny Ngo

// Properties ////////////////////////////////////////////////////////////
MovieClip.prototype.LEAPSTER = this;	// this is for easy reference

// Note: we need to get these below values initially before the info changed
var nScreenWidth = mcScreen._width;
var nScreenHeight = mcScreen._height;
var nScreenX = mcScreen._x;
var nScreenY = mcScreen._y;

var bPenEnabled = false;
var bKeyMapEnabled = false;		// for keyboard mapping
var nLastKeyDown = -1;



// Initializing ////////////////////////////////////////////////////////////
stop();
hideAllButtons();			// internal call to hide the button graphics
setEnablePen(false);		// Pen or Mouse cursor?
setEnableKeyMap(true);	// PC keyboard mapping enable

//TODO: DW remove the Disney site stuff
// On Disney site, load the main game - on LeapsterWorld.com, wait -- DO'B
if (_parent == _level0)
{
	// Disney scheme
	// we're loaded as the main movie, start loading
	if (_parent.sMainGameSwf != null)
	{
		// this variable can be set by passing it in via the html src tag.
		loadGame(_parent.sMainGameSwf);
	}
	else
	{
		// load the default swf
		loadGame("content/dragons/movies/swf/dragonMain.swf");
		//loadGame("content/dragons/movies/swf/main.swf");
		//trace("main.swf loaded")
	}
}
else
{
	// LeapsterWorld.com scheme
	// do nothing, the container movie that loaded us will make a call to loadGame.
}






// Additional functions /////////////////////////////////////////////////////
//-----------------------------------------------------------------------------------------
function loadGame(sFileURL)
{
	this.mcScreen.mcHolder.loadMovie(sFileURL);
	
	
}

//-----------------------------------------------------------------------------------------
function setEnablePen(bNew)
{
	if (bPenEnabled && !bNew)
	{
		mcPen._visible = false;
		Mouse.show();
	}

	bPenEnabled = bNew;
}

//-----------------------------------------------------------------------------------------
function getEnablePen()
{
	return bPenEnabled;
}

//-----------------------------------------------------------------------------------------
function setEnableKeyMap(bNew)
{
	if (bNew)
		Key.addListener(this);		// start listening the Key events
	else
		Key.removeListener(this);	// stop listening
	bKeyMapEnabled = bNew;
}

//-----------------------------------------------------------------------------------------
function getEnableKeyMap()
{
	return bKeyMapEnabled;
}

//-----------------------------------------------------------------------------------------
function setEnableButton(fButton, bNew)
{
	fButton.enabled  = bNew;
}

//-----------------------------------------------------------------------------------------
function getEnableButton(button)
{
	return button.enabled;
}

//-----------------------------------------------------------------------------------------
function hideAllButtons()
// for internal use only
{
	mcButtonA._visible = false;
	mcButtonB._visible = false;
	mcButtonHome._visible = false;
	mcButtonHint._visible = false;
	mcButtonPause._visible = false;
	mcButtonUp._visible = false;
	mcButtonDown._visible = false;
	mcButtonLeft._visible = false;
	mcButtonRight._visible = false;

	mcPen._visible = false;	//pen
}

//-----------------------------------------------------------------------------------------
function disableAllButtons()
{
	setEnableButton(fButtonA, false);
	setEnableButton(fButtonB, false);
	setEnableButton(fButtonHome, false);
	setEnableButton(fButtonHint, false);
	setEnableButton(fButtonPause, false);
	setEnableButton(fButtonUp, false);
	setEnableButton(fButtonDown, false);
	setEnableButton(fButtonLeft, false);
	setEnableButton(fButtonRight, false);
}

//-----------------------------------------------------------------------------------------
function enableAllButtons()
{
	setEnableButton(fButtonA, true);
	setEnableButton(fButtonB, true);
	setEnableButton(fButtonHome, true);
	setEnableButton(fButtonHint, true);
	setEnableButton(fButtonPause, true);
	setEnableButton(fButtonUp, true);
	setEnableButton(fButtonDown, true);
	setEnableButton(fButtonLeft, true);
	setEnableButton(fButtonRight, true);
}

//-----------------------------------------------------------------------------------------
function changeColor(sColor)
{
	//mcBase.gotoAndStop(sColor.toLowerCase());
	mcBase.loadMovie("Skins/" + sColor+ ".swf", "get");
}

// BUTTONS /////////////////////////////////////////////////////////////
//-----------------------------------------------------------------------------------------
function buttonA(bIsPressed)
{
	if (mcButtonA._visible == bIsPressed) return;

	mcButtonA._visible = bIsPressed;
	if (bIsPressed)
		onLFButtonPressed(LF_BUTTON_A);
	else
		onLFButtonReleased(LF_BUTTON_A);
}

//-----------------------------------------------------------------------------------------
function buttonB(bIsPressed)
{
	if (mcButtonB._visible == bIsPressed) return;

	mcButtonB._visible = bIsPressed;
	if (bIsPressed)
		onLFButtonPressed(LF_BUTTON_B);
	else
		onLFButtonReleased(LF_BUTTON_B);
}

//-----------------------------------------------------------------------------------------
function buttonUp(bIsPressed)
{
	if (mcButtonUp._visible == bIsPressed) return;

	mcButtonUp._visible = bIsPressed;
	if (bIsPressed)
		onLFButtonPressed(LF_BUTTON_UP);
	else
		onLFButtonReleased(LF_BUTTON_UP);
}

//-----------------------------------------------------------------------------------------
function buttonDown(bIsPressed)
{
	if (mcButtonDown._visible == bIsPressed) return;

	mcButtonDown._visible = bIsPressed;
	if (bIsPressed)
		onLFButtonPressed(LF_BUTTON_DOWN);
	else
		onLFButtonReleased(LF_BUTTON_DOWN);
}

//-----------------------------------------------------------------------------------------
function buttonLeft(bIsPressed)
{
	if (mcButtonLeft._visible == bIsPressed) return;

	mcButtonLeft._visible = bIsPressed;
	if (bIsPressed)
		onLFButtonPressed(LF_BUTTON_LEFT);
	else
		onLFButtonReleased(LF_BUTTON_LEFT);
}

//-----------------------------------------------------------------------------------------
function buttonRight(bIsPressed)
{
	if (mcButtonRight._visible == bIsPressed) return;

	mcButtonRight._visible = bIsPressed;
	if (bIsPressed)
		onLFButtonPressed(LF_BUTTON_RIGHT);
	else
		onLFButtonReleased(LF_BUTTON_RIGHT);
}

//-----------------------------------------------------------------------------------------
function buttonHome(bIsPressed)
{
	if (mcButtonHome._visible == bIsPressed) return;

	mcButtonHome._visible = bIsPressed;
	if (bIsPressed)
		onLFButtonPressed(LF_BUTTON_HOME);
	else
		onLFButtonReleased(LF_BUTTON_HOME);
}

//-----------------------------------------------------------------------------------------
function buttonHint(bIsPressed)
{
	if (mcButtonHint._visible == bIsPressed) return;

	mcButtonHint._visible = bIsPressed;
	if (bIsPressed)
		onLFButtonPressed(LF_BUTTON_HINT);
	else
		onLFButtonReleased(LF_BUTTON_HINT);
}

//-----------------------------------------------------------------------------------------
function buttonPause(bIsPressed)
{
	if (mcButtonPause._visible == bIsPressed) return;

	mcButtonPause._visible = bIsPressed;
	if (bIsPressed)
		onLFButtonPressed(LF_BUTTON_PAUSE);
	else
		onLFButtonReleased(LF_BUTTON_PAUSE);
}

// EVENTS ///////////////////////////////////////////////////////////////
//-----------------------------------------------------------------------------------------
function onMouseUp()
{
	buttonA(false);
	buttonB(false);
	buttonUp(false);
	buttonDown(false);
	buttonLeft(false);
	buttonRight(false);
	buttonHome(false);
	buttonHint(false);
	buttonPause(false);

	mcPen.gotoAndStop("up");
}

//-----------------------------------------------------------------------------------------
function onMouseDown()
{
	mcPen.gotoAndStop("down");
}

//-----------------------------------------------------------------------------------------
 function onMouseMove()
{
	if (bPenEnabled)
	{
		var x = _xmouse - this._x;
		var y = _ymouse - this._y;

		if ( x >= nScreenX &&  x < nScreenX + nScreenWidth
			&& y >= nScreenY &&  y < nScreenY + nScreenHeight)
		{
			Mouse.hide();
			mcPen._visible = true;
			mcPen._x = x;
			mcPen._y = y;
		}
		else
		{
			mcPen._visible = false;
			Mouse.show();
		}
	}
}


//-----------------------------------------------------------------------------------------
function onKeyDown()
{
	var nNewKey = Key.getCode();
	if (nNewKey == nLastKeyDown) return;

	if (bKeyMapEnabled)
	{
		nLastKeyDown = nNewKey;
		switch (nNewKey)
		{
			case 37:
				if (fButtonLeft.enabled) buttonLeft(true);
				break;
			case 38:
				if (fButtonUp.enabled) buttonUp(true);
				break;
			case 39:
				if (fButtonRight.enabled) buttonRight(true);
				break;
			case 40:
				if (fButtonDown.enabled) buttonDown(true);
				break;

			case 45:	// "0" w/o NumLock
			case 96:	// "0" w NumLock
			case 65:	// 'a' button
			case 32:	//  space bar
				if (fButtonA.enabled) buttonA(true);
				break;

			case 46:	// "." w/o NumLock
			case 110: 	// "." w NumLock
			case 66: // 'b' button
				if (fButtonB.enabled) buttonB(true);
				break;

			case 111:	// "/"
				if (fButtonHome.enabled) buttonHome(true);
				break;
			case 106: 	// "*"
			case 72: 	// "h"
			case 191: 	// "/ and ?"
				if (fButtonHint.enabled) buttonHint(true);
				break;
			case 109: 	// "-"
				if (fButtonPause.enabled) buttonPause(true);
				break;
		}
	}
}

//-----------------------------------------------------------------------------------------
function onKeyUp(nKeyCode)
{
	if (bKeyMapEnabled)
	{
		nLastKeyDown = -1;
		switch (Key.getCode())
		{
			case 37:
				buttonLeft(false);
				break;
			case 38:
				buttonUp(false);
				break;
			case 39:
				buttonRight(false);
				break;
			case 40:
				buttonDown(false);
				break;

			case 45:	// 0 w/o NumLock
			case 96:	// 0 w NumLock
			case 65:	// 'a' button
			case 32:	//  space bar
				buttonA(false);
				break;

			case 46:	// . w/o NumLock
			case 110: 	// . w NumLock
				buttonB(false);
				break;

			case 111:	// "/"
				buttonHome(false);
				break;
			case 106: 	// "*"
				buttonHint(false);
				break;
			case 109:  	// "-"
				buttonPause(false);
				break;
		}
	}
}

