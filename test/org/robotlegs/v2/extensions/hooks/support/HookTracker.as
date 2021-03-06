//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.hooks.support
{

	public class HookTracker
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		public var hooksConfirmed:Vector.<String> = new Vector.<String>();

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function HookTracker()
		{

		}


		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function confirm(hookName:String):void
		{
			hooksConfirmed.push(hookName);
		}
	}

}
