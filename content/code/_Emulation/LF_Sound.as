// LF_Sound.as
// Description:	Leapster Sound object
// Platform:	Flash Player 5 or later versions
// Actionscript:	1.0
// Author:		Johnny Ngo
// Dave Wise - 4-19-09 attempted looping capability - looping doesn't work unless the sound is an event and is pre-loaded
// If you want to loop a pre-loaded event sound - call oSound.setStreaming(false) and then oSound.setLoop(10) to loop 10 times

//trace("*** Loading LF_Sound object");


//if (typeof _global != "object") _global =_root;	// a hack for Flash 5

// LF_Sound object ///////////////////////////////////////////////////////
_global.LF_Sound = function(uniqueID, mcTarget, isUsingEmbededSound)
{
	// class definitions and initializing
	this.ID = uniqueID;					// an unique ID for reference
	this.aSounds = new Array();
	this.iCurrentIndex = 0;
	this.iVolume;
	this.iStatus = 0;						// 0=stop,	1=playing,	2=pause
	this.iStartTime;
	this.iSoundOffset = 0;
	this.oCurrentSound = null;
	this.bStreaming = true;
	this.bUsingEmbededSound = isUsingEmbededSound;
	this.bDeleteSoundsWhenFinish = false; 
	this.iLoop = 1;
	
	

	this.mySound = new Sound(mcTarget);	// local Sound object
	// a reference to this object
	this.mySound.oCaller = this;				
	// local callback
	this.mySound.onSoundComplete = function()	
	{

		trace("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
		trace("this.oCalller.ID: "+this.oCaller.ID)
		trace("this.oCalller.iCurrentIndex: "+this.oCaller.iCurrentIndex)
		trace("this.oCalller.length: "+this.oCaller.length())
		trace("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");

		this.oCaller.iStatus = 0;
		if (this.oCaller.iCurrentIndex < this.oCaller.length()-1)
		{
			this.oCaller.playNext();
		}
		else
		{
			
			if (this.oCaller.bDeleteSoundsWhenFinish)
			{	
				this.oCaller.removeAll();
			}
			if (this.oCaller.onComplete != null)
			{
				trace(" ** LF_Sound::onComplete() "+this.oCaller.ID);				
				this.oCaller.onComplete(this.oCaller);			// onComplete callback
			}
		}
	}


	trace("BEFORE THE IF");
	if (!this.bUsingEmbededSound)
	{
			// local callback
		this.mySound.onLoad = function(bSuccess)
		{
			trace("BEFORE THE SUCCESS TEST")
			if (bSuccess)
			{

				trace("DWP - this.oCaller.ID " + this.oCaller.ID);
				trace("DWP - this.oCaller.iStatus " + this.oCaller.iStatus);
				if (this.oCaller.iStatus == 1)
				{
					//this.start(this.oCaller.oCurrentSound.iOffset, this.oCaller.oCurrentSound.iLoop);
					//this.start(this.oCaller.oCurrentSound.iSoundOffset, this.oCaller.iLoop);
					trace(" ** LF_SoundX::play " + this.oCaller.oCurrentSound.sID + " on " + this.oCaller.ID);
					trace(" ** the volume = " + this.oCaller.iVolume);
					trace(" ** this.oCaller.iLoop = " + this.oCaller.iLoop);
					
					this.oCaller.iStartTime = getTimer();		// mark the timer
				}

			}
			else
			{
				// a hack
				trace("***LF_Sound: loading audio file failed!!!");
				
				trace("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
				trace("this.mySound.getBytesTotal: "+this.getBytesTotal())
				trace("this.mySound.getBytesLoaded: "+this.getBytesLoaded())
				trace("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
				if(this.getBytesTotal() == null)
				{
					trace("hmm, I don't think this audio exists...");
					this.loadSound('content/dragons/audio/mp3/Missing.mp3', true);
				}else{
					this.onSoundComplete();	// hack hack hack
				}

				//this.attachSound("idMissingAudio");	// this is not working somehow
				//this.start(0, 1);

			}
		}
	}

	trace(" ** LF_Sound: "+uniqueID+" initialized successfully");
	trace("  * LF_Sound: Using Embeded Sound = " + this.bUsingEmbededSound);
}

//-----------------------------------------------------------------------------------------
LF_Sound.prototype.setStreaming = function(isStreaming)
{
	// either streaming sound or Event sound | this is used when this.bUsingEmbededSound = false
	this.bStreaming = isStreaming;
}

//-----------------------------------------------------------------------------------------
LF_Sound.prototype.push = function(sSoundID, iLoop)
{
	// add a new sound into the sequence
	// sSoundID could be either Lib Sound Linkage ID or Audio Filename
	return this.aSounds.push({sID: sSoundID, iLoop: iLoop});
}

//-----------------------------------------------------------------------------------------
LF_Sound.prototype.setAutoDelete = function(bNew)
{
	// auto delete sounds when finish playing
	this.bDeleteSoundsWhenFinish = bNew;
}

//-----------------------------------------------------------------------------------------
LF_Sound.prototype.removeAll = function()
{
	// clear the sound sequence
	this.aSounds.length = 0;
	this.iCurrentIndex = 0;
}

//-----------------------------------------------------------------------------------------
LF_Sound.prototype.length = function()
{
	// how many sound in the sequence
	return this.aSounds.length;
}

//-----------------------------------------------------------------------------------------
LF_Sound.prototype.currentIndex = function()
{
	// where am I?
	return this.iCurrentIndex;
}

//-----------------------------------------------------------------------------------------
LF_Sound.prototype.start = function()

{
	// start playing sound at index 0
	this.play(0);
}

//-----------------------------------------------------------------------------------------
LF_Sound.prototype.play = function(iIndex)

{
	// play at the Index
	// if Index is out of bound, play at current index
	trace("DW - The current index is "+iIndex)
	trace("DW - The current this.iCurrentIndex is "+this.iCurrentIndex)
	
	trace("DW - this.length = "+(this.length()))
	var iOffset = 0;
	if (iIndex >= 0 && iIndex < this.length() && this.iCurrentIndex != iIndex)	// valid index?
	{
		this.iCurrentIndex = iIndex;	// change
		this.iSoundOffset = 0;
	}
	else if (this.iStatus == 2)	// pause
	{
		iOffset = this.iSoundOffset;
	}
//LC: Try removing sound from queue when you play it.
	this.oCurrentSound = this.aSounds[this.iCurrentIndex];
	
//	this.oCurrentSound = this.aSounds.shift();
	
	this.oCurrentSound.iOffset =  iOffset;
	if (this.bUsingEmbededSound)
	{
		// attach and play the lib sound
		this.mySound.attachSound(this.oCurrentSound.sID);
		this.mySound.start(this.oCurrentSound.iOffset, this.oCurrentSound.iLoop);
		trace(" ** LF_Sound0::play " + this.oCurrentSound.sID + " on " + this.ID);
		this.oCaller.iStartTime = getTimer();		// mark the timer
	}
	else
	{
		trace("LF SOUND2 PLAY DIRECTLY " + this.oCurrentSound.sID + " with "+ this.ID)
		this.mySound.loadSound(this.oCurrentSound.sID, this.bStreaming);
		if (this.iVolume != null)
		{
			this.mySound.setVolume(this.iVolume); //DW - For some reason I have to set the volume after I load the sound
		}
	}

	this.iStatus = 1;				// playing flag
	return this.iCurrentIndex;
}

//-----------------------------------------------------------------------------------------
LF_Sound.prototype.playNext = function()
{
	// play next sound
	this.play(this.iCurrentIndex + 1);
}

//-----------------------------------------------------------------------------------------
LF_Sound.prototype.stop = function()
{
	// stop the sound as it says
	trace("DW - stop audio this.oCurrentSound.sID "+ this.oCurrentSound.sID)
	this.mySound.stop();
	this.iStatus = 0;			// stop flag
	this.iSoundOffset = 0;
	this.iCurrentIndex = 0;
	//return this.iCurrentIndex;
}

//-----------------------------------------------------------------------------------------
LF_Sound.prototype.pause = function()
{
	// pause the sound
	// *** this is not working properly when audio loop
	if (this.iStatus == 2)	// already pause?
	{
		this.unpause();
		return this.iCurrentIndex;
	}

	this.mySound.stop();
	this.iStatus = 2;			// pause flag
	this.iSoundOffset = (getTimer()-this.iStartTime)/1000;	// how many second elapsed?
	return this.iCurrentIndex;
}

//-----------------------------------------------------------------------------------------
LF_Sound.prototype.unpause = function()
{
	// pause the sound
	if (this.iStatus != 2) return;		// not pause?

	return this.play(this.iCurrentIndex);
}

//-----------------------------------------------------------------------------------------
LF_Sound.prototype.isPause = function()
{
	return (this.iStatus == 2);
}

//-----------------------------------------------------------------------------------------
LF_Sound.prototype.isStop = function()
{
	return (this.iStatus == 0);
}

//-----------------------------------------------------------------------------------------
LF_Sound.prototype.isBusy = function()
{
	return (this.iStatus != 0);
}

//-----------------------------------------------------------------------------------------
LF_Sound.prototype.isPlaying = function()
{
	return (this.iStatus == 1);
}

//-----------------------------------------------------------------------------------------
LF_Sound.prototype.setVolume = function(iVol)
{
	this.iVolume = iVol;
	this.mySound.setVolume(iVol);
	//trace("DW - this.mySound = "+this.mySound.name);
	trace("DW - set volume this.mySound.getVolume() = "+this.mySound.getVolume());
	trace("DW - this.ID = "+this.ID);
	
}

//-----------------------------------------------------------------------------------------
LF_Sound.prototype.getVolume = function()
{
	return this.iVolume;
}

//-----------------------------------------------------------------------------------------
LF_Sound.prototype.trace = function()

{
	// output for debugging
	trace(" ** LF_Sound: listing...");
	for (var i=0; i<this.length(); i++)
	{
		trace("   " + i + " | ID=" +this.aSounds[i].sID + " | Loop=" + this.aSounds[i].iLoop);
	}
}

//-----------------------------------------------------------------------------------------
LF_Sound.prototype.setLoop = function(loopNum)
{
	// set the sound to loop
	
	this.iLoop = loopNum;
	trace(" LF_Sound - this.iLoop = "+this.iLoop);
}

LF_Sound.prototype.setStreaming = function(streamBool)
{
	// set the sound to loop
	this.bStreaming = streamBool;
	trace(" LF_Sound - this.bStreaming = "+this.bStreaming);
}


//-----------------------------------------------------------------------------------------
// Callback events
LF_Sound.prototype.onComplete = function(oSound) {};