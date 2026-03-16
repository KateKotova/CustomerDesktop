// CustomerDesktop
// Author Kate Kotova
// NIJANUS Copyright © 2004-2010
// nijanus@ymail.com
// http://nijanus.narod2.ru
//---------------------------------------------------------------------------
// Пакет классов, связанных с отображением.
package nijanus.display
{
	// Класс чёрного полупрозрачного спрайта.
	public class TranslucentBlackSprite extends TranslucentBlackSpriteBase
	{
		// Список импортированных классов из других пакетов.

		import flash.geom.Rectangle;
		//-----------------------------------------------------------------------		
		// Статические константы.

		// Ширина теневого бордюра.
		public static const SHADOW_BORDER_WIDTH: uint = 10;
		//-----------------------------------------------------------------------
		// Методы-конструкторы.

		// Метод-конструктор экземпляра чёрного полупрозрачного спрайта.
		public function TranslucentBlackSprite( ): void
		{
			// Вызов метода-конструктора суперкласса TranslucentBlackSpriteBase.
			super( );
		} // TranslucentBlackSprite
		//-----------------------------------------------------------------------
		// Get- и set-методы.
		
		// Get-метод получения границ.
		// Результат: границы.
		public function get Bounds( ): RectangleWithPerimeterBorder
		{
			// Прямоугольник с бордюром по периметру, соответствующий границам
			// чёрного полупрозрачного спрайта, с теневым бордюром.
			return new RectangleWithPerimeterBorder
				(
				 	TranslucentBlackSprite.SHADOW_BORDER_WIDTH,
					this.x,
					this.y,
					this.width,
					this.height
				); // return
		} // Bounds
	
		// Set-метод установки границ с бордюром.
		// Параметры:
		// parBoundsWithBorder - границы с бордюром.
		public function set BoundsWithBorder
			( parBoundsWithBorder: Rectangle ): void
		{
			// Абсцисса с бордюром.
			this.x      = parBoundsWithBorder.x; 
			// Oрдината с бордюром.
			this.y      = parBoundsWithBorder.y; 
			// Ширина с бордюром.
			this.width  = parBoundsWithBorder.width;
			// Высота с бордюром.
			this.height = parBoundsWithBorder.height;
		} // BoundsWithBorder		
		
		// Get-метод получения границ без бордюра.
		// Результат: границы без бордюра.
		public function get BoundsWithoutBorder( ): Rectangle
		{
			// Границы без бордюра прямоугольника с бордюром по периметру,
			// соответствующего границам чёрного полупрозрачного спрайта.
			return this.Bounds.BoundsWithoutBorder;
		} // BoundsWithoutBorder
		
		// Set-метод установки границ без бордюра.
		// Параметры:
		// parBoundsWithoutBorder - границы без бордюра.
		public function set BoundsWithoutBorder
			( parBoundsWithoutBorder: Rectangle ): void
		{
			// Границы - прямоугольник с бордюром по периметру,
			// соответствующий границам чёрного полупрозрачного спрайта,
			// нулевых размеров с теневым бордюром.
			var bounds: RectangleWithPerimeterBorder =
				new RectangleWithPerimeterBorder
				( TranslucentBlackSprite.SHADOW_BORDER_WIDTH );				
			// Границы без бордюра.
			bounds.BoundsWithoutBorder = parBoundsWithoutBorder;
			// Установка границ с бордюром.
			this.BoundsWithBorder      = bounds.BoundsWithBorder;
		} // BoundsWithoutBorder		
	} // TranslucentBlackSprite
} // nijanus.display