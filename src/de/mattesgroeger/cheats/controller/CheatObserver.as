/*
 * Copyright (c) 2011 Mattes Groeger
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
package de.mattesgroeger.cheats.controller
{
	import de.mattesgroeger.cheats.model.CheatData;

	import flash.events.IEventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.utils.Dictionary;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	public class CheatObserver
	{
		public var timeout:uint;
		
		private var cheatDatas:Vector.<CheatData>;
		private var cheatIndexes:Dictionary = new Dictionary();
		private var currentTimeout:uint;

		public function CheatObserver(stage:IEventDispatcher, cheatDatas:Vector.<CheatData>, timeout:uint = 5000)
		{
			this.cheatDatas = cheatDatas;
			this.timeout = timeout;
			
			initializeIndexes();
			registerForKeyEvents(stage);
		}

		private function initializeIndexes():void
		{
			for each (var cheatData:CheatData in cheatDatas)
				cheatIndexes[cheatData] = 0;
		}

		private function registerForKeyEvents(stage:IEventDispatcher):void
		{
			stage.addEventListener(KeyboardEvent.KEY_UP, handleKeyUp);
		}

		private function handleKeyUp(event:KeyboardEvent):void
		{
			for each (var cheatData:CheatData in cheatDatas)
			{
				if (cheatData.code.keyCodeAt(cheatIndexes[cheatData]) == event.keyCode)
				{
					if (cheatIndexes[cheatData] + 1 == cheatData.code.length)
					{
						cheatIndexes[cheatData] = 0;
						cheatData.toggle();
					}
					else
					{
						cheatIndexes[cheatData] += 1;
					}
				}
				else
				{
					cheatIndexes[cheatData] = 0;
				}
			}
			
			updateTimeout();
		}

		private function updateTimeout():void
		{
			clearTimeout(currentTimeout);
			
			currentTimeout = setTimeout(initializeIndexes, timeout);
		}
	}
}