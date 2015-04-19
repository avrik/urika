package com.communication 
{
	import com.eventUtils.EventManager;
	import flash.events.DataEvent;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import urikatils.LoggerHandler;
	/**
	 * ...
	 * @author Avrik
	 */
	
	public class XmlProvider extends EventDispatcher
	{
		public var data:XMLList;
		private var urlLoader:URLLoader;
		private var _traceActive:Boolean;
		private var request:URLRequest;
		
		public function XmlProvider(url:String = null, eventgroup:int = 0, traceActive:Boolean = false)
		{
			this._traceActive = traceActive;
			if (this._traceActive)
			{
				//LoggerHandler.getInstance.info(this,"[GET XML URL] :\n" + url+ "\n");
				trace("[GET XML URL] :\n" + url+ "\n");
			}
			try
			{
				urlLoader = new URLLoader();
				
				EventManager.addEvent(urlLoader, Event.COMPLETE, loadDataComplete, eventgroup);
				//EventManager.addEvent(urlLoader, HTTPStatusEvent.HTTP_STATUS, HTTPStatusHandler, eventgroup);
				EventManager.addEvent(urlLoader, IOErrorEvent.IO_ERROR, loadError, eventgroup);
				EventManager.addEvent(urlLoader, IOErrorEvent.NETWORK_ERROR, loadError, eventgroup);
				EventManager.addEvent(urlLoader, SecurityErrorEvent.SECURITY_ERROR, loadError, eventgroup);

				//url = url.indexOf("?") == -1?url + "?":url + "&";
				//request = new URLRequest(url + "rand=" + NumberUtilities.random(1, 9999999));
				request = new URLRequest(url);

			}catch (err:Error)
			{
				loadError(null);
			}
		}
		
		public function load():void
		{
			if (request)
			{
				urlLoader.load(request);
			}
		}
		
		private function HTTPStatusHandler(e:HTTPStatusEvent):void 
		{
			if (this._traceActive)
			{
				LoggerHandler.getInstance.info(this,"[HTTPStatusHandler STATUS !!! == ]" + e.status);
			}
			
			if (e.status != 200)
			{
				loadError(null);
			}
		}
		
		private function loadError(e:IOErrorEvent):void 
		{ 
			try
			{
				urlLoader.close();
			}catch (err:Error)
			{
				LoggerHandler.getInstance.info(this,err.message);
			}
			
			EventManager.clearEventsByDispatcher(urlLoader);
			dispatchEvent(new Event(ErrorEvent.ERROR)); 
			LoggerHandler.getInstance.info(this,"[LOAD URL ERROR !!! ]");
		};
		
		private function loadDataComplete(e:Event):void 
		{
			EventManager.clearEventsByDispatcher(urlLoader);
			this.data = new XMLList(e.target.data);
			if (this._traceActive)
			{
				trace("[XML DATA] :\n " + this.data + "\n");
			}
			
			dispatchEvent(new DataEvent(DataEvent.DATA));
		}
		
		public function destroy():void {
			EventManager.clearEventsByDispatcher(this);
			EventManager.clearEventsByDispatcher(urlLoader);
			urlLoader = null;
		}
		
	}

}