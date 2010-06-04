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

package org.flex_pilot {
  import flash.display.DisplayObject;
  import flash.display.DisplayObjectContainer;
  import flash.display.Stage;
  import flash.events.KeyboardEvent;
  import flash.events.MouseEvent;
  import flash.events.TextEvent;
  import flash.external.ExternalInterface;
  import flash.utils.*;
  
  import mx.controls.ComboBox;
  import mx.controls.DataGrid;
  import mx.controls.DateChooser;
  import mx.controls.DateField;
  import mx.controls.List;
  import mx.controls.VSlider;
  import mx.controls.listClasses.ListBase;
  import mx.controls.sliderClasses.Slider;
  import mx.core.EventPriority;
  import mx.events.CalendarLayoutChangeEvent;
  import mx.events.DataGridEvent;
  import mx.events.ListEvent;
  import mx.events.SliderEvent;
  
  import org.flex_pilot.FPExplorer;
  import org.flex_pilot.FPLocator;
  import org.flex_pilot.FPLogger;
  import org.flex_pilot.FlexPilot;

  public class FPRecorder {
    // Remember the last event type so we know when to
    // output the stored string from a sequence of keyDown events
    private static var lastEventType:String;
    private static var lastEventLocator:String;
	
	
	
	//just to hide the mouse clicks occured while the user is changing the date or value of slider .
	private static var noClickTime:Boolean=false;
	private static var noClick:*;
	
	
    // Remember recent target -- used to detect double-click
    // and to throw away click events on text items that have
    // already spawned a 'link' TextEvent.
    // Only remembered for one second
    private static var recentTarget:Object = {
      click: null,
      change: null,
	  sliderChange: null
    };
    // Timeout id for removing the recentTarget
    private static var recentTargetTimeout:Object = {
      click: null,
      change: null,
	  sliderChange: null,
	  dateChange: null
    };
    // String built from a sequenece of keyDown events
    private static var keyDownString:String = '';
    private static var listItems:Array = [];
	private static var sliderItems:Array=[];
	private static var dateItems:Array=[];
	private static var dgItems:Array=[];
	
    private static var running:Boolean = false;
	
	public static var temp:*;

    public function FPRecorder():void {}

    public static function start():void {
      // Stop the explorer if it's going
      FPExplorer.stop();

      var recurseAttach:Function = function (item:*):void {
        // Otherwise recursively check the next link in
        // the locator chain
        var count:int = 0;
		
        if (item is ComboBox || item is List) {
          FPRecorder.listItems.push(item);
          item.addEventListener(ListEvent.CHANGE, FPRecorder.handleEvent);
        }
		if(item is Slider){
			item.addEventListener(SliderEvent.CHANGE, FPRecorder.handleEvent);
			FPRecorder.sliderItems.push(item);
		}
		if(item is DateChooser||item is DateField){
			item.addEventListener(CalendarLayoutChangeEvent.CHANGE, FPRecorder.handleEvent);
			FPRecorder.dateItems.push(item);
		}
		if(item is DataGrid){
			item.addEventListener(DataGridEvent.COLUMN_STRETCH , FPRecorder.handleEvent);
			item.addEventListener(DataGridEvent.ITEM_EDIT_END , FPRecorder.handleEvent);
			item.addEventListener(ListEvent.CHANGE , FPRecorder.handleEvent);
			
			// will record only after all other event listeners have done their job .
			item.addEventListener(DataGridEvent.HEADER_RELEASE , FPRecorder.handleEvent );
			FPRecorder.dgItems.push(item);
			
		}
        if (item is DisplayObjectContainer) {
          count = item.numChildren;
        }
        if (count > 0) {
          var index:int = 0;
          while (index < count) {
            var kid:DisplayObject = item.getChildAt(index);
            var res:DisplayObject = recurseAttach(kid);
            index++;
          }
        }
      }
      recurseAttach(FlexPilot.getContext());
      var stage:Stage = FlexPilot.getStage();
      stage.addEventListener(MouseEvent.CLICK, FPRecorder.handleEvent);
      stage.addEventListener(MouseEvent.DOUBLE_CLICK, FPRecorder.handleEvent);
      stage.addEventListener(TextEvent.LINK, FPRecorder.handleEvent);
      stage.addEventListener(KeyboardEvent.KEY_DOWN, FPRecorder.handleEvent);
	  

      FPRecorder.running = true;
    }

    public static function stop():void {
      if (!FPRecorder.running) { return; }
      var stage:Stage = FlexPilot.getStage();
      stage.removeEventListener(MouseEvent.CLICK, FPRecorder.handleEvent);
      stage.removeEventListener(MouseEvent.DOUBLE_CLICK, FPRecorder.handleEvent);
      stage.removeEventListener(TextEvent.LINK, FPRecorder.handleEvent);
      stage.removeEventListener(KeyboardEvent.KEY_DOWN, FPRecorder.handleEvent);
	  
	  
      var list:Array = FPRecorder.listItems;
      for each (var item:* in list) {
        item.removeEventListener(ListEvent.CHANGE, FPRecorder.handleEvent);
      }
	  
	  list = FPRecorder.sliderItems;
	  for each (var item:* in list) {
		  item.removeEventListener(SliderEvent.CHANGE, FPRecorder.handleEvent);
	  }
	  
	  list = FPRecorder.dateItems;
	  for each (var item:* in list) {
		  
		  item.removeEventListener(CalendarLayoutChangeEvent.CHANGE, FPRecorder.handleEvent);
	  }
	  
	  list=FPRecorder.dgItems;
	  
	  for(var i:Number = 0 ; i<list.length;i++){
		  var item:*=list[i];
		  item.removeEventListener(DataGridEvent.COLUMN_STRETCH , FPRecorder.handleEvent);
		  item.removeEventListener(DataGridEvent.ITEM_EDIT_END , FPRecorder.handleEvent);
		  item.removeEventListener(ListEvent.CHANGE , FPRecorder.handleEvent);
		  item.removeEventListener(DataGridEvent.HEADER_RELEASE , FPRecorder.handleEvent);
		  
	  }
    }

    public static function handleEvent(e:*){
		
      var targ:* = e.target;
      var _this:* = FPRecorder;
      var chain:String = FPLocator.generateLocator(targ);
		//trace(e.type);
	  
	  //needed further more ordered clissification below as some events may have same type :-(
      switch (e.type) {
        // Keyboard input -- append to the stored string reference
		  
		case SliderEvent.CHANGE:
			
			// filtered the change in slider event from the change in List Event
			  if(targ is Slider && e is SliderEvent)
			  {
				  //trace("slider caught at switch");
				  _this.generateAction('sliderChange',targ);
				  _this.setNoClickZone();
				  //_this.resetRecentTarget(('sliderChange' , e);
				  
				  
				  break;
			  }
		case CalendarLayoutChangeEvent.CHANGE:
			if((targ is DateChooser || targ is DateField) && e is CalendarLayoutChangeEvent){
				_this.generateAction('dateChange',targ);
				_this.setNoClickZone();
				break;
			}
		case DataGridEvent.COLUMN_STRETCH:
			if(targ is DataGrid && e is DataGridEvent){
				var opts:Object=new Object;
				opts.localX=Number(e.localX);
				opts.columnIndex=e.columnIndex;
				opts.dataField=e.dataField;
				opts.rowIndex=e.rowIndex;
				
				_this.generateAction('dgColumnStretch', targ , opts);
				_this.setNoClickZone();
				break;	
			}
		case DataGridEvent.ITEM_EDIT_END:
			if(targ is DataGrid && e is DataGridEvent){
				var opts:Object=new Object;
				opts.newValue=e.target.itemEditorInstance[e.target.columns[e.columnIndex].editorDataField];
				
				opts.columnIndex=e.columnIndex;
				opts.dataField=e.dataField;
				opts.rowIndex=e.rowIndex;
				
				opts.reason=e.reason;
				opts.cancelable=e.cancelable;
				_this.generateAction('dgItemEditEnd', targ , opts);
				_this.setNoClickZone();
				break;
			}
			
		case DataGridEvent.HEADER_RELEASE:
			
			if(targ is DataGrid && e is DataGridEvent){
				
				trace("I have the event");
				
				var opts:Object=new Object;
				opts.columnIndex=e.columnIndex;
				opts.dataField=e.dataField;
				opts.rowIndex=e.rowIndex;
				
				opts.reason=e.reason;
				opts.cancelable=e.cancelable;
				
				opts.sortDescending=targ.columns[e.columnIndex].sortDescending;
				_this.generateAction('dgSort' , targ , opts);
				_this.setNoClickZone();
				break;
			}
		
			
			
	    case KeyboardEvent.KEY_DOWN:
          // If we don't ignore 0 we get a translation error
          // as it generates a non unicode character
			if(e is KeyboardEvent){
            if (e.charCode != 0) 
            _this.keyDownString += String.fromCharCode(e.charCode);
          
          break;}
        // ComboBox changes
        case ListEvent.CHANGE:
			if(targ is ListBase || ComboBox )
			{
          _this.generateAction('select', targ);
          _this.resetRecentTarget('change', e);
          break;
			}
        // Mouse/URL clicks
		
        default:
          // If the last event was a keyDown, write out the string
          // that's been saved from the sequence of keyboard events
          if (_this.lastEventType == KeyboardEvent.KEY_DOWN) {
            var locate:* = targ;
            //If we have a prebuild last locator, use it
            //Since the current isn't actually the node we want
            //it's the following node that generated the onchange
            if (_this.lastEventLocator){
                locate = _this.lastEventLocator;
            }
            _this.generateAction('type', locate, { text: _this.keyDownString });
            // Empty out string storage
            _this.keyDownString = '';
          }
          // Ignore clicks on ComboBox/List items that result
          // in ListEvent.CHANGE events -- the list gets blown
          // away, and can't be looked up by the generated locator
          // anyway, so we have to use this event instead
          else
			  if (_this.lastEventType == ListEvent.CHANGE) {
			  
			  //trace("this happens anyways");
			  
            if (_this.recentTarget.change && _this.recentTarget is List) {
              return;
            }
			  
			  else
				  if(_this.recentTarget.sliderChange  && _this.recentTarget is Slider){
					  return;
					  
				  }
          }
          // Avoid multiple clicks on the same target
          if (_this.recentTarget == e.target) {
            // Check for previous TextEvent.LINK
            if (_this.lastEventType != MouseEvent.DOUBLE_CLICK) {
              // Just throw this mofo away
              return;
            }
          }
          var t:String = e.type == MouseEvent.DOUBLE_CLICK ?
              'doubleClick' : 'click';
			  if(!_this.noClickTime){
          _this.generateAction(t, targ);
          _this.resetRecentTarget('click', e);
			  }
      }

      // Remember the last event type for saving sequences of
      // keyboard events
      _this.lastEventType = e.type;
      _this.lastEventLocator = FPLocator.generateLocator(targ);

      //FPLogger.log(e.toString());
      //FPLogger.log(e.target.toString());
    }

    private static function resetRecentTarget(t:String, e:*):void  {
      var _this:* = FPRecorder;
      // Remember this target, avoid multiple clicks on it
      _this.recentTarget[t] = e.target;
      // Cancel any old setTimeout still hanging around
      if (_this.recentTargetTimeout[t]) {
        clearTimeout(_this.recentTargetTimeout[t]);
      }
      // Clear the recentTarget after 1 sec.
      _this.recentTargetTimeout[t] = setTimeout(function ():void {
        _this.recentTarget[t] = null;
        _this.recentTargetTimeout[t] = null;
      }, 1);
    }
	
	private static function setNoClickZone():void{
		var _this:* = FPRecorder;
		
		if(_this.noClick){
			clearTimeout(_this.noClick);
			
		}
		_this.noClickTime=true;
		
		_this.noClick=setTimeout(function():void{
			_this.noClickTime=false;
			
		},0.5);
	}

    private static function generateAction(t:String, targ:*,
        opts:Object = null):void {
		
		var trybool:Boolean=false;
			
      var chain:String;
      //Type actions send an already build locator string
      if (typeof(targ) == 'object'){
          chain = FPLocator.generateLocator(targ);
		  
      }
      else { chain = targ; }
	  
	  

      //Figure out what kind of displayObj were dealing with
      var classInfo:XML = describeType(targ);
      classInfo =  describeType(targ);
      var objType:String = classInfo.@name.toString();

      var res:Object = {
        method: t,
        chain: chain
      };
      var params:Object = {};
	  

      //if we have a flex accordion
      if (objType.indexOf('Accordion') != -1){
        if (objType.indexOf('AccordionHeader') != -1){
          params.label = targ.label;
        }
        else {
          params.label = targ.getHeaderAt(0).label;
        }
      }

      var p:String;
      for (p in opts) {
		  //trace(p);
        params[p] = opts[p]
      }
      switch (t) {
        case 'click':
          break;
        case 'doubleClick':
          break;
        case 'select':
          var sel:* = targ.selectedItem;
          // Can set a custom label field via labelField attr
          var labelField:String = targ.labelField ?
              targ.labelField : 'label';
          params.label = sel[labelField];
          break;
        case 'type':
          break;
		case 'sliderChange':
			params.value=targ.value;
			break;
		case 'dateChange':
			params.value=targ.selectedDate;
			break;
		case 'dgColumnStretch' :
			break;
		case 'dgItemEditEnd' :
			
			break;
		case 'dgSort' :
			break;
      }
	  
      for (p in params) {
        res.params = params;
        break;
      
	  }
	  
	  if(t=='dgSort')
	  {
		  trace("sort saved");
		  temp=res;
	  }
	  
      
	  var r:* = ExternalInterface.call('fp_recorderAction', res);
	  
	  
      if (!r) {
        FPLogger.log(res);
        //FPLogger.log('(FlexPilot Flash bridge not found.)');
      }
    }

  }
}

