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
package de.mattesgroeger.cheats.view
{
	import flash.filters.DropShadowFilter;
	import de.mattesgroeger.cheats.cheat_internal;
	import de.mattesgroeger.cheats.model.Cheat;
	import de.mattesgroeger.cheats.model.ICheat;

	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.IEventDispatcher;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	use namespace cheat_internal;

	public class DefaultCheatView implements ICheatView
	{
		[Embed(source="../../../../../assets/lock.png")]
		private var lockClass:Class;
		private var lockView:Bitmap = new lockClass();

		private static const SHOW_TIME_MS:uint = 3000;
		private static const TEXT_COLOR_1:String = "#575854";
		private static const TEXT_COLOR_2:String = "#000000";
		private static const BACKGROUND_COLOR_ON:uint = 0xcfff75;
		private static const BACKGROUND_COLOR_OFF:uint = 0xace8ed;

		private var stage:Stage;
		private var cheatView:Sprite;
		private var timeout:uint;

		public function DefaultCheatView(stage:IEventDispatcher)
		{
			if (stage is Stage)
				this.stage = Stage(stage);
		}

		public function cheatToggled(cheat:ICheat):void
		{
			if (stage != null)
				renderCheat(cheat);
		}

		private function renderCheat(cheat:ICheat):void
		{
			var isMasterCheat:Boolean = cheat is Cheat && Cheat(cheat).children && Cheat(cheat).children.length > 0;

			var labelText:String = (cheat.label != null) ? cheat.label : cheat.id;
			var label:TextField = createLabel(labelText, cheat.activated);
			
			var backgroundWidth:Number = label.width + (isMasterCheat ? 10 : 0);
			var backgroundColor:uint = (cheat.activated) ? BACKGROUND_COLOR_ON : BACKGROUND_COLOR_OFF;
			var background:Shape = createBackground(backgroundColor, backgroundWidth);
			
			var lockView:Bitmap = createLockView(isMasterCheat, label);
			
			clearView();
			setView(label, background, lockView);
		}

		private function createLabel(label:String, activated:Boolean):TextField
		{
			var stateText:String = (activated) ? "ON" : "OFF";
			var styleSheet:StyleSheet = new StyleSheet();
			styleSheet.setStyle("body", {fontFamily:"Arial", fontWeight:"bold", fontSize:10, color:TEXT_COLOR_2});
			styleSheet.setStyle(".state", {fontWeight:"normal", color:TEXT_COLOR_1});

			var text:TextField = new TextField();
			text.x = 2;
			text.autoSize = TextFieldAutoSize.LEFT;
			text.styleSheet = styleSheet;
			text.htmlText = "<body>" + label.toUpperCase() + " <span class='state'>" + stateText + "</span></body>";
			
			return text;
		}

		private function createBackground(color:uint, width:Number):Shape
		{
			var shape:Shape = new Shape();

			shape.graphics.beginFill(color, 0.8);
			shape.graphics.drawRoundRect(0, 0, width + 3, 14, 4, 4);
			shape.graphics.endFill();

			return shape;
		}

		private function createLockView(isMasterCheat:Boolean, label:TextField):Bitmap
		{
			if (isMasterCheat)
			{
				lockView.smoothing = true;
				lockView.x = label.x + label.width;
				lockView.y = 2;
				
				return lockView;
			}
			
			return null;
		}

		private function clearView():void
		{
			if (cheatView == null)
				return;

			clearTimeout(timeout);
			stage.removeChild(cheatView);
			cheatView = null;
		}

		private function setView(label:TextField, background:Shape, lockView:Bitmap):void
		{
			cheatView = new Sprite();
			
			with (cheatView)
			{
				x = 5;
				y = 5;
				
				addChild(background);
				addChild(label);
		
				if (lockView != null)
					addChild(lockView);
				
				filters = [new DropShadowFilter(1, 45, 0, 0.5, 1, 1)];
			}
			
			stage.addChild(cheatView);

			timeout = setTimeout(clearView, SHOW_TIME_MS);
		}

		public function destroy():void
		{
			clearView();
		}
	}
}