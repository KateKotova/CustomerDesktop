// CustomerDesktop
// Author Kate Kotova
// NIJANUS Copyright © 2004-2010
// nijanus@ymail.com
// http://nijanus.narod2.ru
//---------------------------------------------------------------------------
// Пакет классов, связанных с отображением.
package nijanus.display
{
	// Класс координат вершин четырёхугольника.
	public class TetragonCornersCoordinates 
	{
		// Переменные экземпляра класса.
		
		// Абсцисса левого верхнего угла.
		public var LeftTopCornerX:     Number = undefined;
		// Ордината левого верхнего угла.
		public var LeftTopCornerY:     Number = undefined;
		
		// Абсцисса правого верхнего угла.
		public var RightTopCornerX:    Number = undefined;
		// Ордината правого верхнего угла.
		public var RightTopCornerY:    Number = undefined;
	
		// Абсцисса левого нижнего угла.
		public var LeftBottomCornerX:  Number = undefined;
		// Ордината левого нижнего угла.
		public var LeftBottomCornerY:  Number = undefined;
		
		// Абсцисса правого нижнего угла.
		public var RightBottomCornerX: Number = undefined;
		// Ордината правого нижнего угла.
		public var RightBottomCornerY: Number = undefined;		
		//-----------------------------------------------------------------------
		// Методы-конструкторы.
		
		// Метод-конструктор экземпляра координат вершин четырёхугольника.
		public function TetragonCornersCoordinates( )
		{
		} // TetragonCornersCoordinates		
	} // TetragonCornersCoordinates
} // nijanus.display