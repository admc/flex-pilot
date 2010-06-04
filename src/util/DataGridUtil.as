package util
{
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.controls.DataGrid;
	import mx.controls.TextInput;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.controls.listClasses.IDropInListItemRenderer;
	import mx.events.FlexEvent;
	import mx.events.IndexChangedEvent;
	

	public class DataGridUtil
	{
		public function DataGridUtil()
		{
		}
		
		public static function columnStretch(obj:* , columnIndex:Number , localX:Number):void{
			
			var colArray:Array=obj.columns;
			
				if(columnIndex<colArray.length){
					var newWidth:Number=localX-prewidth(colArray , columnIndex);
					colArray[columnIndex].width=newWidth;
				}
				else{
					throw new Error("Incorrect columnIndex recieved");
				}
			
				
			
			
			
			
			
		}
		
		private static function prewidth(colArray:* , columnIndex:Number):Number{
			var sum:Number=0;
			for(var i:Number=0 ; i<columnIndex ; i++){
				sum+=colArray[i].width;
			}
			
			return sum;
		}
		
		public static function itemEdit(obj:* , row:Number,column:Number , field:* , newValue:*){
			
			trace("dg");
			trace(obj is DataGrid);
			trace(newValue);
			trace(obj.dataProvider.getItemAt(row)[field]);
			obj.dataProvider.getItemAt(row)[field]=newValue;
			trace(obj.dataProvider.getItemAt(row)[field]);
						
			obj.dataProvider.itemUpdated(obj.dataProvider.getItemAt(row));
			
			
			
		}
		
		public static function sortGrid(obj:* , column:Number , descSort:Boolean):void{
			
			var s:Sort=obj.dataProvider.sort;
			var sf:Array=s.fields;
			var col:DataGridColumn = obj.columns[column];
			
			col.sortDescending=!descSort;
			
			
			
			if (sf)
			{

				var find:Boolean=false;
				
				for (var i:int = 0; i < sf.length; i++)
				{
					
					if (sf[i].name == col.dataField)
					{
						// we're part of the current sort
						f = sf[i]
						// flip the logic so desc is new desired order
						f.descending=descSort;
						find=true;
						break;
					}
				}
				
				if(!find)
				{
					s=new Sort;
					var f:SortField = new SortField(col.dataField);
					f.descending=!descSort;
					col.sortDescending=descSort;
					sf=[f];
					s.fields=sf;
					obj.dataProvider.sort=s;
				}
			}
			else{
				trace("got a null");
				s=new Sort;
				var f:SortField = new SortField(col.dataField);
				f.descending=!descSort;
				sf=[f];
				s.fields=sf;
				obj.dataProvider.sort=s;
			}
				
			
			
			
			
			
			
			
			
		}
		
		
	}
}