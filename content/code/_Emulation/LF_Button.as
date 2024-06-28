// LF_Button.as
// Description:	Leapster Button object
// Platform:	Flash Player 5 or later versions
// Actionscript:	1.0
// Author:		Johnny Ngo
// Comment:	You might want to modify to fit your project

trace("*** Loading LF_Button object");

if (typeof _global != "object") _global =_root;	// a hack for Flash 5

_global.LFButton_FinalState				= 0;		// last button state
_global.LFButton_ChangeMask 			= 0;		// change mask or'ed during the course of the frame

// Button's Definitions
_global.LF_BUTTON_UP 				= 0x0100;
_global.LF_BUTTON_DOWN 				= 0x0200;
_global.LF_BUTTON_LEFT 				= 0x0400;
_global.LF_BUTTON_RIGHT 				= 0x0800;
_global.LF_BUTTON_A 					= 0x1000;
_global.LF_BUTTON_B		 			= 0x2000;
_global.LF_BUTTON_HOME 				= 0x4000;
_global.LF_BUTTON_HINT 				= 0x8000;
_global.LF_BUTTON_PAUSE 				= 0x4000000; // API doc has this number wrong!
_global.LF_BUTTON_VOLUME_INC 			= 0x0010000;
_global.LF_BUTTON_VOLUME_DEC 			= 0x0020000;
_global.LF_BUTTON_CONTRAST_DEC 		= 0x0100000;
_global.LF_BUTTON_CONTRAST_INC 		= 0x0200000;
_global.LF_BUTTON_BRIGHT				= 0x0080;

// System buttons
_global.LF_SYSBUTTON_PAUSE 			= 8;
_global.LF_SYSBUTTON_VOLUME_INC 		= 4;
_global.LF_SYSBUTTON_VOLUME_DEC 		= 5;
_global.LF_SYSBUTTON_CONTRAST_DEC		= 3;
_global.LF_SYSBUTTON_CONTRAST_INC		= 2;
_global.LF_SYSBUTTON_BRIGHT			= 1; 

// Combinations
_global.LF_BUTTONGROUP_DPAD			= LF_BUTTON_UP | LF_BUTTON_DOWN | LF_BUTTON_LEFT | LF_BUTTON_RIGHT;
_global.LF_BUTTONGROUP_UPDOWN		= LF_BUTTON_UP | LF_BUTTON_DOWN;
_global.LF_BUTTONGROUP_LEFTRIGHT		= LF_BUTTON_LEFT | LF_BUTTON_RIGHT;
_global.LF_BUTTONGROUP_UPLEFT			= LF_BUTTON_UP | LF_BUTTON_LEFT;
_global.LF_BUTTONGROUP_UPRIGHT		= LF_BUTTON_UP | LF_BUTTON_RIGHT;
_global.LF_BUTTONGROUP_DOWNLEFT		= LF_BUTTON_DOWN | LF_BUTTON_LEFT;
_global.LF_BUTTONGROUP_DOWNRIGHT		= LF_BUTTON_DOWN | LF_BUTTON_RIGHT;

// REGULAR BUTTONS /////////////////////////////////////////////////////
//-----------------------------------------------------------------------------------------
_global.LF_ButtonCallback = null;	// default callback
_global.LF_onButton = function(fnCallback)
// call this function to register the callback
{		
	LF_ButtonCallback = fnCallback;
}

//-----------------------------------------------------------------------------------------
_global.onLFButtonPressed = function(iWhichButton)
{
	trace("DW - onLFButtonPressed "+iWhichButton)
	LFButton_FinalState = iWhichButton;
	LFButton_ChangeMask |= iWhichButton;	
	LF_ButtonCallback(LFButton_FinalState, iWhichButton);
}

//-----------------------------------------------------------------------------------------
_global.onLFButtonReleased = function(iWhichButton)
{
	LFButton_FinalState = 0;
	LFButton_ChangeMask |= iWhichButton;	
	LF_ButtonCallback(LFButton_FinalState, iWhichButton);
}

// SYSTEM BUTTONS //////////////////////////////////////////////////////
//-----------------------------------------------------------------------------------------
_global.LF_SystemButtonCallback = null;	// default callback
_global.LF_onSystemButton = function(fnCallback)
// call this function to register the callback
{	
	LF_SystemButtonCallback = fnCallback;
}

//-----------------------------------------------------------------------------------------
_global.onLFSystemButtonPressed = function(iWhichButton)
{
	LF_SystemButtonCallback(iWhichButton, true, 0/*change this to some variables*/);
}

//-----------------------------------------------------------------------------------------
_global.onLFSystemButtonReleased = function(iWhichButton)
{
	LF_SystemButtonCallback(iWhichButton, false, 0/*change this to some variables*/);
}

trace("*** All done Loading LF_Button object");