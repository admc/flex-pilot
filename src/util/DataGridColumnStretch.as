package util
{
	import mx.controls.DataGrid;
	import mx.controls.dataGridClasses.DataGridColumn;
	

	public class DataGridColumnStretch
	{
		public function DataGridColumnStretch()
		{
		}
		
		public static function columnStretch(obj:* , columnIndex:Number , localX:Number):void{
			
			var colArray:Array=obj.columns;
			
				if(columnIndex<colArray.length){
					var newWidth:Number=localX-prewidth(colArray , columnIndex);
					colArray[columnIndex].width=newWidth;
				}
				else{
					throw new Error("send in the right column Index");
				}
			
				
			
			
			
			
			
		}
		
		private static function prewidth(colArray:* , columnIndex:Number):Number{
			var sum:Number=0;
			for(var i:Number=0 ; i<columnIndex ; i++){
				sum+=colArray[i].width;
			}
			
			return sum;
		}
	}
}