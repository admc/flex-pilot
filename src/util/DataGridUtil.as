package util
{
	import mx.collections.ICollectionView;
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
		
		public static function sortGridOrder(obj:* , index:Number , dir:Boolean=false , caseSensitive:Boolean=false ):void{
			
			var srt:Sort=new Sort();
			var oldSort:Sort=obj.dataProvider.sort;
			var column:DataGridColumn = obj.columns[index];
			if(oldSort){
				srt.fields=oldSort.fields;
				var sf:SortField = new SortField(column.dataField  , dir , caseSensitive);
				srt.fields.splice( 0 , 0 , sf);
				
			}
			else{
				
				var sf:SortField = new SortField(column.dataField  , dir , caseSensitive);
				srt.fields=[sf];
				
			}
			
			obj.dataProvider.sort = srt;
			obj.dataProvider.refresh();
			
			
			
		}
			
				
			
			
			
			
			
			
			
			
		}
		
		
	}
