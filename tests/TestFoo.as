package {
  import mx.charts.chartClasses.DataDescription;
  
  import org.flex_pilot.TestCase;

  public class TestFoo extends TestCase {
    public var order:Array = ['testdgItemSelect1','testdgItemEdit1','testdgSort1','testdgColumnStretch1','testSliderChange','testDateField','testdgItemDrag','testWaitCondition1','testClick', 'testClickTimeout', 'testWaitCondition', 'testWaitConditionTimeout',
        'testWaitSleep', 'testAssertDisplayObject', 'testWaitDisplayObject', 'testAssertEqualsString',
        'testAssertEqualsNumber', 'testAppPublicInt', 'testAppPublicString', 'testAppPublicArray'];

    public function setup():void {
    }
	
	
	public function testdgItemSelect1():void{
		
		var params:Object={
			id:'srcgrid' ,
			selectedItem : {Artist:'Original Cast', Album:'Camelot', Price:12.99},
			timeout: 2000
		}
		
		controller.select(params);		

	}
	
	public function testdgItemEdit1():void{
		var params:Object={
			id:'srcgrid' ,
			params: {
				rowIndex : 2 ,
				newValue : 'NewValue' ,
				dataField : 'Price'
			} 
			
			
		}
			
			
		controller.dgItemEdit(params);
		

	}
	
	
	public function testdgSort1():void{
		
		var params:Object={
			id:'srcgrid' ,
			params : {
				columnIndex : 1
			}
			
		}
			
			controller.dgSortAscending(params);
		
		
	}
	
	public function testdgColumnStretch1():void{
		
		var params:Object={
			id:'srcgrid' ,
			params : {
				columnIndex : 1 ,
				localX : 100 
				
			}
		}
			controller.dgColumnStretch(params);
	}
	
	
	public function testdgItemDrag():void{
		
		var params:Object={
			id:'destgrid' ,
			params:{
				stageX : 596 ,
				stageY : 189 ,
				ctrlKey :false
			} ,
			
			start :{
				id: 'srcgrid' ,
				params:{
					stageX : 195 ,
					stageY : 238 ,
					selectedIndices : [1 , 2] 
					
				}
				
			}
			
		}
			
			
			controller.dragDrop(params);
		
	}
	
	
	public function testSliderChange():void{
		var params:Object={
			id:'hslid' ,
			params:{
				value : 50
			}
		}
			
			controller.sliderChange(params);
	}
	
	
	public function testDateField():void{
		
		var dat:Date=new Date;

		dat.setMonth(8);
		
		trace("month" , dat.getMonth())
		
		
		var params:Object={
			id:'df' ,
			params:{
				value : dat
			}
		}
			controller.dateChange(params);
	}
	
	
    public function testClick():void {
      controller.click({id: 'howdyButton'});
    }
    public function testClickTimeout():void {
      controller.click({id: 'howdyButton', timeout: 3000});
    }
    public function testWaitCondition():void {
      var now:Date = new Date();
      var nowTime:Number = now.getTime();
      var thenTime:Number = nowTime + 5000; // Five seconds from now
      waits.forCondition({test: function ():Boolean {
          var dt:Date = new Date();
          var dtTime:Number = dt.getTime();
          // Wait until the current date is greater
          // the thenTime, set above
          return (dtTime > thenTime);
      }});
    }
    public function testWaitConditionTimeout():void {
      waits.forCondition({test: function ():Boolean {
          return false;
      }, timeout: 3000});
    }
    public function testWaitSleep():void {
      waits.sleep({milliseconds: 5000});
    }
    public function testAssertDisplayObject():void {
      asserts.assertDisplayObject({id: 'mainPane'});
    }
    public function testWaitDisplayObject():void {
      waits.forDisplayObject({id: 'mainPanel', timeout: 5000});
    }
    public function testAssertEqualsString():void {
      var foo:String = 'foo';
      asserts.assertEquals('foo', foo);
    }
    public function testAssertEqualsNumber():void {
      var num:int = 2111;
      asserts.assertEquals(2112, num);
    }

    // Test some public properties in the main Flex app class
    public function testAppPublicInt():void {
      var num:int = context.testAppCode.publicInt;
      asserts.assertEquals(2112, num);
    }
    public function testAppPublicString():void {
      var str:String = context.testAppCode.publicString;
      asserts.assertEquals('Geddy Lee', str);
    }
    public function testAppPublicArray():void {
      var arr:Array = context.testAppCode.publicArray;
      asserts.assertEquals('Snow Dog', arr[1]);
    }

    public function teardown():void {
    }
  }
}

