
//trace("com.qlod.LoaderClass.as loaded");

/**
 *  @class LoaderClass
 *  Implements Colin Moock's Preloading Api as proposed
 *  at http://www.moock.org/blog/archives/000010.html
 * 
 *  This code is supplied as is, use it at your own risk
 *  and please don't remove this header. 
 *
 *  If you plan to use the code on a commercial site, 
 * 	we would happily receive a donation to 
 *  paypal@helpqlodhelp.com. See the docs for the details
 *
 *  Version 1.02
 *	Date 2003/08/06
 *  Author Ralf Bokelberg
 *  
 */
 
if( typeof(_global.com) != 'object')
{
	//trace("com.qlod.LoaderClass: Defining global com object");
	_global.com = new Object();
}
if( typeof(com.qlod) != 'object')
{
	//trace("com.qlod.LoaderClass: Defining global com.qlod object");
	com.qlod = new Object();
}

o = com.qlod.LoaderClass = function( piTimeoutMs, piIntervalMs, piMinSteps){
	//trace("LoaderClass " + arguments);
	if( arguments[0] == 'NO_INIT') return;
	
	this.iIntervalId = -1;
	this.iTimeoutIntervalId = -1;
	this.iBytesLoaded = 0;
	this.iBytesTotal = 1;
	this.iTimeoutMs = 0;
	this.bTimeoutEnabled = true;
	this.iIntervalMs = 0;
	this.iStartTimeMs = 0;
	this.iMinSteps = 1;
	this.iCurrentStep = 1;

	// --- DO'B
	this.bIsActive = false;
	
	this.aQueue = [];
	
	this.setTimeoutMs( piTimeoutMs);
	this.setIntervalMs( piIntervalMs);
	this.setMinSteps( piMinSteps);
	
	if( DefaultBroadcaster != undefined){
		DefaultBroadcaster.initialize( this);
	} else {
		if(ASBroadcaster == undefined){
			trace("ERROR in LoaderClass: ASBroadcaster undefined");
		} else {
			// trace("com.qlod.LoaderClass: using ASBroadcaster");	
			ASBroadcaster.initialize( this);
		}
	}
};
//
// Statics
o.DEFAULT_TIMEOUT_MS = 10 * 1000;
o.DEFAULT_INTERVAL_MS = 100;
o.DEFAULT_MIN_STEPS = 1;


// Prototypes
o = o.prototype;

o.load = function( pLoc, psUrl, poListener )
{
	//trace("LoaderClass.load " + arguments);
	return this.enqueue.apply( this, [true].concat(arguments));
};

o.observe = function( pLoc, psUrl, poListener ) {
	//trace("LoaderClass.observe " + arguments);
	return this.enqueue.apply( this, [false].concat(arguments));
};

o.clear = function(){
	this.aQueue.length = 0;
	this.removeCurrent();
}

o.removeCurrent = function(){
	if( this.isLoading()){
		var currentLoc = this.targetToLoc();
		if( this.checkLocation( currentLoc)){
			currentLoc.unloadMovie();	
		}
		this.endTimeout();
		this.endLoading();
	}	
}

o.remove = function( pId){
	if( this.oCurrentItem.iId == pId){
		this.removeCurrent();
		return true;	
	}
	for( var i=0; i<this.aQueue.length; i++){
		if(this.aQueue[i].iId == pId){
			this.aQueue.splice( i, 1);
			return true;	
		}	
	}
	return false;	
}

o.getTimeoutMs = function(){
	return this.iTimeoutMs;	
}

o.setTimeoutMs = function( piMilliseconds){
	this.iTimeoutMs = this.checkIntGreaterZero( piMilliseconds, this.constructor.DEFAULT_TIMEOUT_MS);
	if(this.iTimeoutIntervalId != -1){
		this.startTimeout();
	}
	return this.iTimeoutMs;	
}

o.disableTimeout = function(){
	this.endTimeout();
	this.bTimeoutEnabled = 0;	
}

o.enableTimeout = function(){
	this.bTimeoutEnabled = 1;
	this.startTimeout();	
}
 
o.getIntervalMs = function(){
	return this.iIntervalMs;	
}

o.setIntervalMs = function( piMilliseconds){
	this.iIntervalMs = this.checkIntGreaterZero( piMilliseconds, this.constructor.DEFAULT_INTERVAL_MS);
	if( this.isLoading()){
		clearInterval( this.iIntervalId);
		this.iIntervalId = -1;
		this.startInterval();
	}
	return this.iIntervalMs;	
}

o.getMinSteps = function(){
	return this.iMinSteps;	
}

o.setMinSteps = function( piMinSteps){
	return this.iMinSteps = this.checkIntGreaterZero( piMinSteps, this.constructor.DEFAULT_MIN_STEPS);	
}

o.isLoading = function(){
	return this.iIntervalId != -1;
}

o.getBytesLoaded = function(){
	var bytesToShow = Math.min( this.iBytesLoaded, Math.floor( this.iBytesTotal * this.iCurrentStep / this.iMinSteps ));
	// i wonder why NaN ever showed up, but it did, 
	// so it is more robust to check for NaN explicitely
	return (isNaN(bytesToShow)) ? 0 : bytesToShow;
} 

o.getBytesTotal = function(){
	return this.iBytesTotal;
} 

o.getKBLoaded = function(){
	return this.getBytesLoaded() >> 10;
} 

o.getKBTotal = function(){
	return this.getBytesTotal() >> 10;
} 

o.getPercent = function(){
	return this.getBytesLoaded() * 100 / this.iBytesTotal;
} 

o.getDuration = function(){
	return getTimer() - this.iStartTimeMs;
} 

o.getSpeed = function(){
	return Math.floor(this.getBytesLoaded() * 1000 / this.getDuration());
} 

o.getEstimatedTotalTime = function(){
	return Math.floor(this.getBytesTotal() / this.getSpeed());
} 

o.getTarget = function(){
	return this.oCurrentItem.target;
} 

o.getTargetObj = function(){
	return (typeof(this.oCurrentItem.target) == 'object') ? this.oCurrentItem.target : eval(this.oCurrentItem.target);
} 

o.getUrl = function(){
	return this.oCurrentItem.sUrl;
} 


/*********************************************************************************
 * 								private methods
 *********************************************************************************/


o.broadcastOnQueueStart = function(){
	this.broadcastMessage( "onQueueStart", this);	
} 

o.broadcastOnQueueStop = function(){
	this.broadcastMessage( "onQueueStop", this);	
} 
 
o.broadcastOnLoadStart = function(){
	this.broadcastMessage( "onLoadStart", this);	
} 

o.broadcastOnLoadComplete = function( pbResult){
	this.broadcastMessage( "onLoadComplete", pbResult, this);
}

o.broadcastOnLoadTimeout = function(){
	this.broadcastMessage( "onLoadTimeout", this);		
}

o.broadcastOnLoadProgress = function(){
	this.broadcastMessage( "onLoadProgress", this);
}

o._load = function(){
	this.startTimeout();
	this.oCurrentItem.load();	
}	

o._observe = function(){
	this.iBytesTotal = 1;
	this.iBytesLoaded = 0;	
	this.iCurrentStep = 1;
	this.iStartTimeMs = getTimer();
	this.funcWaitUntil = null;
	//
	this.oCurrentItem.addListenerTo( this);
	//
	this.broadcastOnLoadStart();
	this.broadcastOnLoadProgress();
	//
	if( this.oCurrentItem.bDoLoad){
		this._load();	
	}
}	 

o.enqueue = function( doLoad, pLoc, psUrl, poListener){
	trace("enqueue " + arguments);	
	//
	var sUrl = this.checkUrl( psUrl, pLoc);
	//
	var target = this.locToTarget( pLoc);
	if( target == null){
		if( doLoad){
			trace( "Warning: com.qlod.LoaderClass.load: Invalid location parameter: " + pLoc);
		} else {
			trace( "Warning: com.qlod.LoaderClass.load: Invalid location parameter: " + pLoc);
		}
	}
	//
	var additionalArguments = arguments.slice(4);
	//
	var id = ++this.iId;
	//
	this.aQueue.push( new com.qlod.LoaderItemClass( target, sUrl, doLoad, additionalArguments, id, poListener));	
	if( ! this.isLoading()){
		this.startLoading();
	}
	return id;
}	

o.checkUrl = function( psUrl, pLoc){
	if( typeof(psUrl) == 'string') return psUrl;
	if( typeof(pLoc._url) == 'string') return pLoc._url;
	return "";	
}

o.isQueueEmpty = function(){
	return this.aQueue.length == 0;
}

// --- DO'B
o.setActive = function(bActive)
{
	this.bIsActive = bActive;
}

o.loadNext = function()
{
	// --- DO'B - only proceed to the next item if this queue is active
	if ( this.bIsActive )
	{
		this.oCurrentItem = this.aQueue.shift();	
		this._observe();
	}
}

o.startLoading = function(){
	this.broadcastOnQueueStart();
	this.startInterval();		
	this.loadNext();
}

o.stopLoading = function(){
	this.endInterval();
	this.endTimeout();
}

o.startTimeout = function(){
	if(this.iTimeoutIntervalId != -1){
		clearInterval(this.iTimeoutIntervalId);
	}
	if(this.bTimeoutEnabled){
		this.iTimeoutIntervalId = setInterval( this, "onTimeout", this.iTimeoutMs);
	}
}

o.endTimeout = function(){
	if(this.iTimeoutIntervalId != -1){
		clearInterval(this.iTimeoutIntervalId);
		this.iTimeoutIntervalId = -1;
	}
}

o.onTimeout = function(){
	this.endTimeout();
	this.broadcastOnLoadTimeout();		
	this.endLoading( false);
}

o.locToTarget = function( loc){
	if( this.locIsNumber( loc)) return "_level" + loc;
	if( this.locIsPath( loc)) return loc; 
	if( this.locIsLevel( loc)) return loc;
	if( this.locIsMovieClip( loc)) return TargetPath(loc);
	if( this.locIsLoadableObject( loc)) return loc;
	if( loc instanceof String && loc.length > 0) return loc;
	return null;
}

o.targetToLoc = function(){
	return this.oCurrentItem.targetToLoc();
}

o.locIsNumber = function( loc){
	return typeof( loc) == 'number';	
}

o.locIsPath = function( loc){
	return typeof(loc) == 'string' && typeof( eval( loc)) == 'movieclip' && ( eval( loc) != _level0 || loc == "_level0");
}

o.locIsLevel = function( loc){
	return loc.indexOf( "_level") == 0 && ! isNaN( loc.substring( 6));	
}

o.locIsMovieClip = function( loc){
	return typeof( loc) == 'movieclip';
}

o.locIsLoadableObject = function( loc){
	//eg. movieclip, sound, xml, loadvars
	return typeof( loc.getBytesTotal) == 'function' && typeof( loc.getBytesLoaded) == 'function';	
}

o.startInterval = function(){
	if ( this.iIntervalId != -1) {
		this.endInterval();
	}
	this.iIntervalId = setInterval( this, "onInterval", this.iIntervalMs);
}

o.endInterval = function(){
	if ( this.iIntervalId != -1) {
		clearInterval(this.iIntervalId);
		this.iIntervalId = -1;
	}
}

o.onInterval = function(){
	var currentLoc = this.targetToLoc();
	if( ! this.checkLocation( currentLoc)) return;
	if( ! this.checkBytesTotal( currentLoc)) return;
	if( ! this.checkBytesLoaded( currentLoc)) return;
	this.endTimeout();
	//
	this.broadcastOnLoadProgress();
	this.checkComplete( currentLoc);	
	this.iCurrentStep++;
};

o.checkLocation = function( poCurrentLoc){
	if( poCurrentLoc == undefined){
 		this.broadcastOnLoadProgress();
		return false;
	}
	return true;
}

o.checkBytesTotal = function( poCurrentLoc){
	var iBytesTotal = poCurrentLoc.getBytesTotal();
	if( iBytesTotal < 4){ 
		this.broadcastOnLoadProgress();
		return false;
	}
	this.iBytesTotal = iBytesTotal;
	return true;
}

o.checkBytesLoaded = function( poCurrentLoc){
	var iBytesLoaded = poCurrentLoc.getBytesLoaded();
	if( iBytesLoaded < 1){ 
		this.broadcastOnLoadProgress();
		return false;
	}	
	this.iBytesLoaded = iBytesLoaded;	
	return true;
}

o.checkComplete = function( poCurrentLoc){
	if( this.iBytesTotal > 10 
	&& this.iBytesTotal - this.iBytesLoaded < 10 
	&& this.iCurrentStep >= this.iMinSteps
	&& ( this.funcWaitUntil == null || this.funcWaitUntil( poCurrentLoc))){ 
		this.endLoading( true);
		return true;
	}
	return false;
}

o.waitUntilPropertiesAreInitialized = function( pMc){
	return pMc._width != undefined && pMc._height != undefined && pMc._visible != undefined && pMc._url != undefined;
}

o.endCurrentLoading = function( pbResult){
	this.broadcastOnLoadComplete( pbResult);
	this.oCurrentItem.removeListenerFrom(this);
}

o.endLoading = function( pbResult){
	this.endCurrentLoading( pbResult);
	//
	if( this.isQueueEmpty()){
		this.endInterval();	
		this.broadcastOnQueueStop();
	} else {
		this.loadNext();	
	}
}

o.checkIntGreaterZero = function( piValue, piDefaultValue){
	if( piValue == undefined || isNaN( piValue) || piValue <= 0) return piDefaultValue;
	return piValue;
}

delete o;




o = com.qlod.LoaderItemClass = function( target, sUrl, doLoad, aArgs, id, oListener){
	trace("LoaderItemClass " + arguments);
	this.target = target;
	this.sUrl = sUrl;
	this.bDoLoad = doLoad;
	this.aArgs = aArgs;
	this.iId = id;
	this.oListener = oListener;
}

o = o.prototype;

o.load = function(){
	var loc = this.target;
	trace("_load " + loc);	
	//
	if( typeof( loc.load) == 'function'){
		loc.load.apply( loc, [this.sUrl].concat( this.aArgs));
	} else if( typeof( loc.loadSound) == 'function'){
		loc.loadSound.apply( loc, [this.sUrl].concat( this.aArgs));
	} else {
		this.funcWaitUntil = this.waitUntilPropertiesAreInitialized;
		if( this.aArgs[0].toUpperCase() == 'POST'){
			loadMovie( this.sUrl, loc, 'POST');
		} else if( this.aArgs[0].toUpperCase() == 'GET'){
			loadMovie( this.sUrl, loc, 'GET');
		} else {
			loadMovie( this.sUrl, loc);
		}
	}
}	

o.targetToLoc = function(){
	return ( typeof( this.target) == 'string') ? eval( this.target) : this.target;	
}

o.addListenerTo = function( broadcaster){
	if( this.oListener != undefined){
		broadcaster.addListener( this.oListener);	
	}	
}

o.removeListenerFrom = function( broadcaster){
	if( this.oListener != undefined){
		broadcaster.removeListener( this.oListener);	
	}	
}

delete o;