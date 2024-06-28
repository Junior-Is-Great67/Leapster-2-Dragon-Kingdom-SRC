// LF_Timer.as
// Description:	Leapster Timer emulation
// Platform:	Flash Player 5 or later versions
// Author:		Johnny Ngo

trace("*** Loading LF_Timer Emulation");

if (typeof _global != "object") _global =_root;	// a hack for Flash 5

// LF_Timer object ///////////////////////////////////////////////////////
_global.LF_Timer = function(newID, newInterval)
{
	this.id = newID;
	this.interval = newInterval;
	this.startTime = getTimer();
}

LF_Timer.prototype.getElapsedTime = function()
{
	return getTimer() - this.startTime;
}

LF_Timer.prototype.getRemainingTime = function()
{
	return this.interval - ( getTimer() - this.startTime );
}

// LF functions //////////////////////////////////////////////////////////

//-----------------------------------------------------------------------------------------
//_global.LF_InitTimer = function()
{
	_global.g_aLFTimers = new Array();
	_global.g_iLFTimerNextID = 0;
}

//-----------------------------------------------------------------------------------------
_global.LF_StartTimer = function(miliseconds)
// create a new Timer and return the TimerID
{	
	var newTimer = new LF_Timer(g_iLFTimerNextID, miliseconds);
	g_aLFTimers.push(newTimer);
	
	return g_iLFTimerNextID++;
}

//-----------------------------------------------------------------------------------------
_global.LF_StopTimer = function(timerID)
// stop a Timer with specified ID 
{
	for (var i=0; i<g_aLFTimers.length; i++)
	{
		if (g_aLFTimers[i].id == timerID)
		{
			for (var j= i; j<g_aLFTimers.length-1; j++)
				g_aLFTimers[j] = g_aLFTimers[j+1];
			
			g_aLFTimers.length --;
			return i;
		}
	}
	return -1;
}

//-----------------------------------------------------------------------------------------
_global.LF_GetTimerRemainingTime = function(timerID)
// return how many miliseconds left
{
	var myTimer = LF_GetTimer(timerID);
	if (myTimer == null)
		return -1;
	
	return myTimer.getRemainingTime();
}

//-----------------------------------------------------------------------------------------
_global.LF_CleanTimers = function()
// removes all expired timers
{
	var aNewTimers = new Array();
	for (var i=0; i<g_aLFTimers.length; i++)
	{
		if (g_aLFTimers[i].getRemainingTime() > 0)
		{
			aNewTimers.push(g_aLFTimers[i]);
		}
	}
	g_aLFTimers = aNewTimers;
}

//-----------------------------------------------------------------------------------------
_global.LF_GetTimer = function(timerID)
// return a Timer instance
{
	for (var i=0; i<g_aLFTimers.length; i++)
	{
		if (g_aLFTimers[i].id == timerID)
			return g_aLFTimers[i];
	}
	return null;
}

//-----------------------------------------------------------------------------------------
_global.LF_TraceTimers = function()
// output all of the Timers and their info
{
	for (var i=0; i<g_aLFTimers.length; i++)
	{
		trace("Timer " + i 
			+ " | ID = " + g_aLFTimers[i].id 
			+ " | Interval = " + g_aLFTimers[i].interval
			+ " | Remaining = " + g_aLFTimers[i].getRemainingTime());
	}
}


//DW - Added this function to support getting game time - we don't use pause so it just returns time from when the swf was launched
//we could add support for pause by creating a function that suspends the timer when a game is paused
//-----------------------------------------------------------------------------------------
_global.LF_GetGameTime = function()
{
	return getTimer();
}

