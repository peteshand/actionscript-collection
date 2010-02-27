﻿package net.peteshand{	import flash.display.MovieClip;	import flash.display.Sprite;	import flash.events.Event;	import flash.events.MouseEvent;	import flash.display.Loader;	import flash.net.URLRequest;	import flash.events.IOErrorEvent;	import net.peteshand.utils.Dimensions;	import net.peteshand.CircleSlicePreloader;		import com.gskinner.motion.GTween;	import gs.easing.*;		public class Gallery extends MovieClip	{		private var rotationSpeed:Number = 4;		private var Width:Number = 300;		private var Height:Number = 200;				private var moduleLoader:Loader;		private var imageURLs:Array = new Array();		private var imageLoaders:Array = new Array();		private var loadIndex:int = 0;		private var playCount:int = 0;		private var displayIndex:int = -1;				private var imageContainer:MovieClip;		private var imageMask:MovieClip;				private var fadeTween:GTween;				private var iLoaded:Boolean = false;				private var dimensions:Dimensions = new Dimensions();		private var c:CircleSlicePreloader = new CircleSlicePreloader();				public function Gallery(w:Number=300, h:Number=200):void		{			width = w;			height = h;						c.x = w/2;			c.y = h/2			addChild(c);						imageContainer = new MovieClip();			addChild(imageContainer);						imageMask = new MovieClip();			imageMask.graphics.beginFill(0x000000);			imageMask.graphics.drawRect(0,0,width,height);			imageMask.graphics.endFill();			addChild(imageMask);						imageContainer.mask = imageMask;					graphics.beginFill(0x000000);			graphics.drawRect(0,0,width,height);			graphics.endFill();		}		override public function set width(v:Number):void		{			Width = v;		}		override public function get width():Number		{			return Width;		}		override public function set height(v:Number):void		{			Height = v;		}		override public function get height():Number		{			return Height;		}		public function LoadImages(_imageURLs:Array=null):void		{			imageURLs = _imageURLs;			loadImage(imageURLs[loadIndex]);		}		private function loadImage(url:String):void		{			trace("url = " + url);						//var moduleCommunication:DisplayObject;			moduleLoader = new Loader();			var moduleRequest:URLRequest = new URLRequest(url);			moduleLoader.load(moduleRequest);			moduleLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete);			moduleLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loadError);												/** sets variables once module is loaded */			function loadComplete(event:Event):void 			{				imageLoaders.push(moduleLoader);				setDimensions();				moduleLoaded();			}			function loadError(evt:IOErrorEvent):void			{				trace("error loading " + url);			}						function moduleLoaded():void			{				if (loadIndex < imageURLs.length-1) {					if (loadIndex == 0) {						iLoaded = true;						dispatchEvent(new Event("ImagesLoaded"));						switchImages();					}					loadIndex++;					loadImage(imageURLs[loadIndex]);				}				else {					if (imageURLs.length == 1) {						iLoaded = true;						dispatchEvent(new Event("ImagesLoaded"));						switchImages();					}					ImagesLoaded();				}			}		}		private function ImagesLoaded():void		{						trace("ImagesLoaded");					}		public function startPlaying():void		{			playCount = 0;			displayIndex = -1;			switchImages();			addEventListener(Event.ENTER_FRAME, Play);		}		public function stopPlaying():void		{			removeEventListener(Event.ENTER_FRAME, Play);		}		private function Play(evnet:Event):void		{			if (playCount < 30 * rotationSpeed){				playCount++;			}			else {				switchImages();				playCount=0;				if (imageURLs.length == 1) {					stopPlaying();				}			}		}		private function switchImages():void		{			trace("iLoaded = " + iLoaded);			if (iLoaded){				displayIndex++;				if (displayIndex == imageLoaders.length) displayIndex = 0;								imageContainer.setChildIndex(imageLoaders[displayIndex], imageLoaders.length-1);				imageLoaders[displayIndex].visible = true;				imageLoaders[displayIndex].alpha = 0;				fadeTween = new GTween(imageLoaders[displayIndex], 0.5, {alpha:1}, {ease:Linear.easeNone, delay:0});				fadeTween.addEventListener(Event.COMPLETE, FadeComplete);				function FadeComplete(event:Event):void				{					for (var i:int = 0; i < imageLoaders.length; i++){						//if (i != displayIndex) imageLoaders[i].visible = false;					}				}			}		}		private function setDimensions():void		{			dimensions.Calculator("Zoom", width, height, moduleLoader.width, moduleLoader.height);			moduleLoader.x = dimensions.x;			moduleLoader.y = dimensions.y;			moduleLoader.width = dimensions.width;			moduleLoader.height = dimensions.height;			moduleLoader.visible = false;			imageContainer.addChild(moduleLoader);		}	}}