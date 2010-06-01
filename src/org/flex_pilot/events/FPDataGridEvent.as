package org.flex_pilot.events
{
	import mx.controls.listClasses.IListItemRenderer;
	import mx.events.DataGridEvent;
	
	public class FPDataGridEvent extends DataGridEvent
	{
		public function FPDataGridEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, columnIndex:int=-1, dataField:String=null, rowIndex:int=-1, reason:String=null, itemRenderer:IListItemRenderer=null, localX:Number=NaN)
		{
			super(type, bubbles, cancelable, columnIndex, dataField, rowIndex, reason, itemRenderer, localX);
			
			
		}
	}
}