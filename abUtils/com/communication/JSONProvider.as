package com.communication 
{
	import ascb.util.NumberUtilities;
	import com.adobe.serialization.json.JSONDecoder;
	import flash.events.DataEvent;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLStream;
	/**
	 * ...
	 * @author Avrik
	 */
	
	public class JSONProvider extends EventDispatcher
	{
		public var data:Object;
		private var urlLoader:URLLoader;
		private var _traceActive:Boolean;
		private var request:URLRequest;
		
		public static var response : String = "No response yet.";
		
		public function JSONProvider(url:String = null, eventgroup:int = 0, traceActive:Boolean = true)
		{
			this._traceActive = traceActive;
			//trace("[GET JSON URL] :\n" + url+ "\n");
			if (this._traceActive)
			{
				Tracer.alert("[GET JSON URL] :\n" + url+ "\n");
			}
			try
			{
				urlLoader = new URLLoader();
				//urlLoader.data = URLLoaderDataFormat.TEXT;

				EventManager.addEvent(urlLoader, HTTPStatusEvent.HTTP_STATUS, HTTPStatusHandler, eventgroup);
				EventManager.addEvent(urlLoader, IOErrorEvent.IO_ERROR, loadError);
				EventManager.addEvent(urlLoader, IOErrorEvent.NETWORK_ERROR, loadError);
				EventManager.addEvent(urlLoader, Event.COMPLETE, loadDataComplete, eventgroup);
				EventManager.addEvent(urlLoader, SecurityErrorEvent.SECURITY_ERROR, loadError);
				EventManager.addEvent(this, ErrorEvent.ERROR, function(e:ErrorEvent):void { trace("ERROR LOADING URL "); } );
				
				url = url.indexOf("?") == -1?url + "?":url + "&";
				
				request = new URLRequest();
				request.url = url + "rand=" + NumberUtilities.random(1, 9999999);
				
				if (request)
				{
					urlLoader.load(request);
				}
				
			}catch (err:Error)
			{
				loadError(null);
			}
		}
		
		private function HTTPStatusHandler(e:HTTPStatusEvent):void 
		{
			if (this._traceActive)
			{
				Tracer.alert("[HTTPStatusHandler STATUS !!! == ]" + e.status);
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
				Tracer.alert(err.message);
			}
			
			EventManager.clearEventsByDispatcher(urlLoader);
			dispatchEvent(new ErrorEvent(ErrorEvent.ERROR)); 
			Tracer.alert("[LOAD URL ERROR !!! ]");
		};
		
		private function loadDataComplete(e:Event):void 
		{
			response = e.target.data;
			
			EventManager.clearEventsByDispatcher(urlLoader);
			this.data = new JSONDecoder(e.target.data, false).getValue();
			if (this._traceActive)
			{
				//Tracer.alert("[JSON DATA] :\n " + e.target.data + "\n");
				trace("[JSON DATA] :\n " + e.target.data + "\n");
			}
			
			dispatchEvent(new DataEvent(DataEvent.DATA));
		}
		
	}

}