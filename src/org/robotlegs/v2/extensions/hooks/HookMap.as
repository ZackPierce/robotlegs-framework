//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.hooks
{
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import org.robotlegs.v2.core.api.ITypeFilter;
	import org.robotlegs.v2.core.api.ITypeMatcher;
	import org.robotlegs.v2.core.impl.itemPassesFilter;
	import org.robotlegs.v2.extensions.guards.GuardsProcessor;
	import org.swiftsuspenders.DescribeTypeJSONReflector;
	import org.swiftsuspenders.Injector;
	import org.swiftsuspenders.Reflector;

	public class HookMap
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		[Inject]
		public var guardsProcessor:GuardsProcessor;

		[Inject]
		public var hooksProcessor:HooksProcessor;

		[Inject]
		public var injector:Injector;

		[Inject]
		public var reflector:Reflector;

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var _mappingsByFCQN:Dictionary;

		private var _mappingsByTypeFilter:Dictionary;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function HookMap()
		{
			_mappingsByTypeFilter = new Dictionary();
			_mappingsByFCQN = new Dictionary();
		}


		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function map(type:Class):GuardsAndHooksConfig
		{
			// TODO - overwrite? warnings? allow extension? handle duplicates? hrm.

			const fqcn:String = reflector.getFQCN(type);

			_mappingsByFCQN[fqcn] = new GuardsAndHooksConfig();

			return _mappingsByFCQN[fqcn];
		}

		public function mapMatcher(matcher:ITypeMatcher):GuardsAndHooksConfig
		{
			const filter:ITypeFilter = matcher.createTypeFilter();
			_mappingsByTypeFilter[filter] = new GuardsAndHooksConfig();

			return _mappingsByTypeFilter[filter];
		}

		public function process(item:*):Boolean
		{
			const fqcn:String = getQualifiedClassName(item);

			var interested:Boolean = false;

			if (_mappingsByFCQN[fqcn])
			{
				interested = true;
				if (!blockedByGuards(_mappingsByFCQN[fqcn].guards))
					hooksProcessor.runHooks(injector, _mappingsByFCQN[fqcn].hooks);
			}

			for (var filter:* in _mappingsByTypeFilter)
			{
				if (itemPassesFilter(item, filter as ITypeFilter))
				{
					interested = true;
					if (!blockedByGuards(_mappingsByTypeFilter[filter].guards))
						hooksProcessor.runHooks(injector, _mappingsByTypeFilter[filter].hooks);
				}
			}

			return interested;
		}

		/*============================================================================*/
		/* Protected Functions                                                        */
		/*============================================================================*/

		protected function blockedByGuards(guards:Vector.<Class>):Boolean
		{
			return ((guards.length > 0)
				&& !(guardsProcessor.processGuards(injector, guards)))
		}
	}
}
