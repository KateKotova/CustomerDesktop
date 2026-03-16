// CustomerDesktop
// Author Kate Kotova
// NIJANUS Copyright © 2004-2010
// nijanus@ymail.com
// http://nijanus.narod2.ru
//---------------------------------------------------------------------------
// Пакет классов, связанных с отображением.
package nijanus.display
{
	// Класс параметров изменения альфа-прозрачности.
	public class AlphaChangingParameters	
	{
		// Переменные экземпляра класса.
		
		// Максимальная альфа-прозрачность отображаемого объекта.
		public var MaximumAlpha:          Number = undefined;		
		// Скорость изменения альфа-прозрачности
		// в единицах альфа-прозрачности за миллисекунду.
		public var AlphaChangingVelocity: Number = undefined;
		//-----------------------------------------------------------------------
		// Методы-конструкторы.
		
		// Метод-конструктор экземпляра параметров изменения альфа-прозрачности.
		public function AlphaChangingParameters( )
		{
		} // AlphaChangingParameters		
	} // AlphaChangingParameters
} // nijanus.display