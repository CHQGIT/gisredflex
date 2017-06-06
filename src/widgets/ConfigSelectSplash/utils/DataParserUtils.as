/*
 | Version 10.2
 | Copyright 2012 Esri
 |
 | Licensed under the Apache License, Version 2.0 (the "License");
 | you may not use this file except in compliance with the License.
 | You may obtain a copy of the License at
 |
 |    http://www.apache.org/licenses/LICENSE-2.0
 |
 | Unless required by applicable law or agreed to in writing, software
 | distributed under the License is distributed on an "AS IS" BASIS,
 | WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 | See the License for the specific language governing permissions and
 | limitations under the License.
 */
	package widgets.ConfigSelectSplash.utils
	{
		import flash.net.SharedObject;

		import mx.collections.ArrayCollection;

		[Bindable]
		public class DataParserUtils
		{
			private static var instance : DataParserUtils;

			public var sharedObj:SharedObject;

			public var esfRolesArr:ArrayCollection= new ArrayCollection();
			public var eventArr:Array= new Array();
			public var widgetTitle:String='';
			public var eventGroupTitle:String='';
			public var saveBtnLabel:String='';

			public var windowsUrl:String;

			/**
			 * Constructor of DataParserUtil.
			 *
			 * @param enforcer instance of class SingletonEnforcer
			 */
			public function DataParserUtils(enforcer:SingletonEnforcer=null)
			{
				if(enforcer == null)
				{
					//trace("ApplicationController is a singleton.use getInstance() to access it")
				}
				else
				{
					//Dispatches event for InfoWindow.

				}

			}

			public static function getInstance() : DataParserUtils
			{
				if (instance == null ){
					instance = new DataParserUtils(new SingletonEnforcer);
				}
				return instance;
			}

		}
	}

	class SingletonEnforcer{

	}