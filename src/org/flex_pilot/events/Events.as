/*
Copyright 2009, Matthew Eernisse (mde@fleegix.org) and Slide, Inc.

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
*/

package org.flex_pilot.events {
  import flash.events.*;
  
  import mx.controls.DataGrid;
  import mx.events.*;
  
  import org.flex_pilot.events.*;
  
  import util.DataGridUtil;

  public class Events {
    public function Events():void {}

    // Allow lengthy list of ordered params or a simple params
    // object to override the default values
    // NOTE: 'default' param is an array of arrays -- this is
    // a janky hack because Object keys in AS3 don't iterate
    // in their insertion order
    private static function normalizeParams(defaults:Array,
        args:Array):Object {
      var p:Object = {};
      var elem:*;
      // Merge the two arrays into a params obj
      for each (elem in defaults) {
        p[elem[0]] = elem[1];
      };
      // If there are other params, that means either ordered
      // params, or a single params object to set all the options
      if (args.length) {
        // Ordered params -- use these to override vals
        // in the params map
        if (args[0] is Boolean) {
          // Iterate through the array of param keys to pull
          // out any param values passed, in order
          for each (elem in defaults) {
            p[elem[0]] = args.shift();
            if (!args.length) {
              break;
            }
          }
        }
        // Options param obj
        else {
          for (var prop:String in p) {
            if (prop in args[0]) {
              p[prop] = args[0][prop];
            }
          }
        }
      }
      return p;
    }

    public static function triggerMouseEvent(obj:*, type:String,
        ...args):void {
      // AS3 Object keys don't iterate in insertion order
      var defaults:Array = [
        ['bubbles', true], // Override the default of false
        ['cancelable', false],
        ['localX', 0], // Override the default of NaN
        ['localY', 0], // Override the default of NaN
        ['relatedObject', null],
        ['ctrlKey', false],
        ['altKey', false],
        ['shiftKey', false],
        ['buttonDown', false],
        ['delta', 0]
      ];
      var p:Object = Events.normalizeParams(defaults, args);
      var ev:FPMouseEvent = new FPMouseEvent(type, p.bubbles,
          p.cancelable, p.localX, p.localY,
          p.relatedObject, p.ctrlKey, p.altKey, p.shiftKey,
          p.buttonDown, p.delta);
      // Check for stageX and stageY in params obj -- these are
      // only getters in th superclass, so we don't set them in
      // the constructor -- we set them here.
      if (args.length && !(args[0] is Boolean)) {
        p = args[0];
        if ('stageX' in p) {
          ev.stageX = p.stageX;
        }
        if ('stageY' in p) {
          ev.stageY = p.stageY;
        }
      }
      obj.dispatchEvent(ev);
    }

    public static function triggerTextEvent(obj:*, type:String,
        ...args):void {
      // AS3 Object keys don't iterate in insertion order
      var defaults:Array = [
        ['bubbles', true], // Override the default of false
        ['cancelable', false],
        ['text', '']
      ];
      var p:Object = Events.normalizeParams(defaults, args);
      var ev:FPTextEvent = new FPTextEvent(type, p.bubbles,
          p.cancelable, p.text);
      obj.dispatchEvent(ev);
    }

    public static function triggerFocusEvent(obj:*, type:String,
        ...args):void {
      // AS3 Object keys don't iterate in insertion order
      var defaults:Array = [
        ['bubbles', true], // Override the default of false
        ['cancelable', false],
        ['relatedObject', null],
        ['shiftKey', false],
        ['keyCode', 0]
      ];
      var p:Object = Events.normalizeParams(defaults, args);
      var ev:FPFocusEvent = new FPFocusEvent(type, p.bubbles,
          p.cancelable, p.relatedObject, p.shiftKey, p.keyCode);
      obj.dispatchEvent(ev);
    }
    
    public static function triggerKeyboardEvent(obj:*, type:String,
        ...args):void {
      // AS3 Object keys don't iterate in insertion order
      var defaults:Array = [
        ['bubbles', true], // Override the default of false
        ['cancelable', false],
        ['charCode', 0],
        ['keyCode', 0],
        ['keyLocation', 0],
        ['ctrlKey', false],
        ['altKey', false],
        ['shiftKey', false]
      ];
      var p:Object = Events.normalizeParams(defaults, args);
      var ev:FPKeyboardEvent = new FPKeyboardEvent(type, p.bubbles,
          p.cancelable, p.charCode, p.keyCode, p.keyLocation,
          p.ctrlKey, p.altKey, p.shiftKey);
      obj.dispatchEvent(ev);
    }
    public static function triggerListEvent(obj:*, type:String,
        ...args):void {
      // AS3 Object keys don't iterate in insertion order
      var defaults:Array = [
        ['bubbles', false], // Don't override -- the real one doesn't bubble
        ['cancelable', false],
        ['columnIndex', -1],
        ['rowIndex', -1],
        ['reason', null],
        ['itemRenderer', null]
      ];
      var p:Object = Events.normalizeParams(defaults, args);
      var ev:FPListEvent = new FPListEvent(type, p.bubbles,
          p.cancelable, p.columnIndex, p.rowIndex, p.reason,
          p.itemRenderer);
      obj.dispatchEvent(ev);
    }
	
	
	///////////////////////**  Methods created in progress my MaSh  **//////////////////////////
	
	public static function  triggerSliderEvent(obj:* , type:String , ...args):void{
		var defaults:Array=[
			['bubbles',false],
			['cancelable',false],
			['thumbIndex',-1],
			['triggerEvent',null],
			['clickTarget',null],
			['keyCode',-1]
			];
		var p:Object = Events.normalizeParams(defaults, args);
		var ev:FPSliderEvent=new FPSliderEvent(type, p.bubbles, p.cancelable, p.thumbIndex, p.value, p.triggerEvent, p.clickTarget, p.keyCode);
		obj.dispatchEvent(ev);
			
	}
	
	public static function triggerCalendarLayoutChangeEvent(obj:* , type:String , ...args):void{
		var defaults:Array=[
			['bubbles',false],
			['cancelable',false],
			['newDate',null],
			['triggerEvent',null]
		];
		
		var p:Object=Events.normalizeParams(defaults, args);
		var ev:FPCalendarLayoutChangeEvent=new FPCalendarLayoutChangeEvent(type, p.bubbles, p.cancelable, p.newDate, p.triggerEvent);
		obj.dispatchEvent(ev);
		
	}
	
	public static function triggerDataGridEvent(obj:* , type:String , ...args):void{
		
		var defaults:Array=[
		['bubbles' , true],
		['cancelable' , false],
		['columnIndex',-1],
		['dataField',null],
		['rowIndex',-1],
		['reason',null],
		['itemRenderer',null],
		['localX',NaN],
		['newValue',null],
		['sortDescending',null] ,
		['dir' , false] , 
		['caseSensitivity' , false]
		];
		var p:Object=Events.normalizeParams(defaults, args);
		
		
		var ev:FPDataGridEvent=new FPDataGridEvent(type , p.bubbles , p.cancelable , p.columnIndex , p.dataField , p.rowIndex , p.reason , p.itemRenderer ,p.localX);
		switch(type){
		
			case DataGridEvent.COLUMN_STRETCH :
				DataGridUtil.columnStretch(obj , p.columnIndex , p.localX );
				break ;
			
			case DataGridEvent.ITEM_EDIT_END :
				DataGridUtil.itemEdit(obj , p.rowIndex ,p.columnIndex, p.dataField , p.newValue); 
				break;
			
			case FPDataGridEvent.SORT_ASCENDING :
				ev.preventDefault();
				DataGridUtil.sortGridOrder(obj , p.columnIndex);
				break;
			
			case FPDataGridEvent.SORT_DESCENDING :
				ev.preventDefault();
				DataGridUtil.sortGridOrder(obj , p.columnIndex);
				break;

				
				
		}
			
			
		
		obj.dispatchEvent(ev);
		
	
	}
  }
}

