// CustomerDesktop
// Author Kate Kotova
// NIJANUS Copyright © 2004-2010
// nijanus@ymail.com
// http://nijanus.narod2.ru
//---------------------------------------------------------------------------
// Пакет классов, связанных с отображением.
package nijanus.display
{
	// Список импортированных классов из других пакетов.
	import flash.geom.Rectangle;
	//-------------------------------------------------------------------------
	
	// Класс прямоугольника с бордюром по периметру.
	public class RectangleWithPerimeterBorder extends Rectangle
	{
		// Список импортированных классов из других пакетов.

		import flash.geom.Point;
		//-----------------------------------------------------------------------		
		// Переменные экземпляра класса.
		
		// Ширина бордюра.
		protected var _BorderWidth: uint = 0;			
		//-----------------------------------------------------------------------
		// Методы-конструкторы.

		// Метод-конструктор экземпляра прямоугольника с бордюром по периметру.
		// Параметры:
		// parBorderWidth - ширина бордюра,
		// parX           - абсцисса левого верхнего угла,
		// parY           - ордината левого верхнего угла,
		// parWidth       - ширина,
		// parHeight      - высота.		
		public function RectangleWithPerimeterBorder
		(
			parBorderWidth: uint   = 0,
			parX:           Number = 0,
			parY:           Number = 0,
			parWidth:       Number = 0,
			parHeight:      Number = 0			
		)
		{
			// Вызов метода-конструктора суперкласса Rectangle.
			super( parX, parY, parWidth, parHeight );	
			// Ширина бордюра.
			this._BorderWidth = parBorderWidth;
		} // RectangleWithPerimeterBorder
		//-----------------------------------------------------------------------
		// Get- и set-методы.
		
		// Get-метод получения ширины бордюра.
		// Результат: ширина бордюра.
		public function get BorderWidth( ): Number
		{
			// Ширина бордюра.
			return this._BorderWidth;
		} // BorderWidth
		
		// Set-метод установки ширины бордюра.
		// Параметры:
		// parBorderWidth - ширина бордюра.
		public function set BorderWidth( parBorderWidth: Number ): void
		{
			// Ширина бордюра.
			this._BorderWidth = parBorderWidth;
		} // BorderWidth		
		
		// Get-метод получения ширины удвоенного бордюра.
		// Результат: ширина удвоенного бордюра.
		public function get DoubleBorderWidth( ): Number
		{
			// Ширина удвоенного теневого бордюра.
			return this._BorderWidth * 2;
		} // DoubleBorderWidth		
		
		// Get-метод получения абсциссы без бордюра.
		// Результат: абсцисса без бордюра.
		public function get XWithoutBorder( ): Number
		{
			// Абсцисса без бордюра.
			return this.x + this._BorderWidth;
		} // XWithoutBorder
		
		// Set-метод установки абсциссы без бордюра.
		// Параметры:
		// parXWithoutBorder - абсцисса без бордюра.
		public function set XWithoutBorder( parXWithoutBorder: Number ): void
		{
			// Абсцисса с бордюром - истинная абсцисса.
			this.x = parXWithoutBorder - this._BorderWidth;
		} // XWithoutBorder
		
		// Get-метод получения ординаты без бордюра.
		// Результат: ордината без бордюра.
		public function get YWithoutBorder( ): Number
		{
			// Oрдината без бордюра.
			return this.y + this._BorderWidth;
		} // YWithoutBorder
		
		// Set-метод установки ординаты без бордюра.
		// Параметры:
		// parYWithoutBorder - ордината без бордюра.
		public function set YWithoutBorder( parYWithoutBorder: Number ): void
		{
			// Oрдината с бордюром - истинная ордината.
			this.y = parYWithoutBorder - this._BorderWidth;
		} // YWithoutBorder		
		
		// Get-метод получения ширины без бордюра.
		// Результат: ширина без бордюра.
		public function get WidthWithoutBorder( ): Number
		{
			// Ширина без бордюра.
			return this.width - this.DoubleBorderWidth;
		} // WidthWithoutBorder
		
		// Set-метод установки ширины без бордюра.
		// Параметры:
		// parWidthWithoutBorder - ширина без бордюра.
		public function set WidthWithoutBorder
			( parWidthWithoutBorder: Number ): void
		{
			// Ширина с бордюром - истинная ширина.
			this.width = parWidthWithoutBorder +
				this.DoubleBorderWidth;
		} // WidthWithoutBorder			
	
		// Get-метод получения высоты без бордюра.
		// Результат: высота без бордюра.
		public function get HeightWithoutBorder( ): Number
		{
			// Высота без бордюра.
			return this.height - this.DoubleBorderWidth;
		} // WithoutBorder
		
		// Set-метод установки высоты без бордюра.
		// Параметры:
		// parHeightWithoutBorder - высота без бордюра.
		public function set HeightWithoutBorder
			( parHeightWithoutBorder: Number ): void
		{
			// Высота с бордюром - истинная высота.
			this.height = parHeightWithoutBorder +
				this.DoubleBorderWidth;
		} // HeightWithoutBorder
		
		// Get-метод получения абсциссы левой стороны без бордюра.
		// Результат: абсцисса левой стороны без бордюра.
		public function get LeftWithoutBorder( ): Number
		{
			// Абсцисса левой стороны без бордюра.
			return this.left + this._BorderWidth;
		} // LeftWithoutBorder
		
		// Set-метод установки абсциссы левой стороны без бордюра.
		// Параметры:
		// parLeftWithoutBorder - абсцисса левой стороны без бордюра.
		public function set LeftWithoutBorder
			( parLeftWithoutBorder: Number ): void
		{
			// Абсцисса левой стороны без бордюра.
			this.left = parLeftWithoutBorder - this._BorderWidth;
		} // LeftWithoutBorder
		
		// Get-метод получения абсциссы правой стороны без бордюра.
		// Результат: абсцисса правой стороны без бордюра.
		public function get RightWithoutBorder( ): Number
		{
			// Абсцисса правой стороны без бордюра.
			return this.right - this._BorderWidth;
		} // RightWithoutBorder
		
		// Set-метод установки абсциссы правой стороны без бордюра.
		// Параметры:
		// parRightWithoutBorder - абсцисса правой стороны без бордюра.
		public function set RightWithoutBorder
			( parRightWithoutBorder: Number ): void
		{
			// Абсцисса правой стороны без бордюра.
			this.right = parRightWithoutBorder + this._BorderWidth;
		} // RightWithoutBorder		
		
		// Get-метод получения ординаты верхней стороны без бордюра.
		// Результат: ордината верхней стороны без бордюра.
		public function get TopWithoutBorder( ): Number
		{
			// Ордината верхней стороны без бордюра.
			return this.top + this._BorderWidth;
		} // TopWithoutBorder
		
		// Set-метод установки ординаты верхней стороны без бордюра.
		// Параметры:
		// parTopWithoutBorder - ордината верхней стороны без бордюра.
		public function set TopWithoutBorder
			( parTopWithoutBorder: Number ): void
		{
			// Ордината верхней стороны без бордюра.
			this.top = parTopWithoutBorder - this._BorderWidth;
		} // TopWithoutBorder	
		
		// Get-метод получения ординаты нижней стороны без бордюра.
		// Результат: ордината нижней стороны без бордюра.
		public function get BottomWithoutBorder( ): Number
		{
			// Ордината нижней стороны без бордюра.
			return this.bottom - this._BorderWidth;
		} // BottomWithoutBorder
		
		// Set-метод установки ординаты нижней стороны без бордюра.
		// Параметры:
		// parBottomWithoutBorder - ордината нижней стороны без бордюра.
		public function set BottomWithoutBorder
			( parBottomWithoutBorder: Number ): void
		{
			// Ордината нижней стороны без бордюра.
			this.bottom = parBottomWithoutBorder + this._BorderWidth;
		} // BottomWithoutBorder
		
		// Get-метод получения точки левого верхнего угла без бордюра.
		// Результат: точка левого верхнего угла без бордюра.
		public function get TopLeftWithoutBorder( ): Point
		{
			// Точка левого верхнего угла без бордюра.
			return new Point( this.LeftWithoutBorder, this.TopWithoutBorder );
		} // TopLeftWithoutBorder
		
		// Set-метод установки точки левого верхнего угла без бордюра.
		// Параметры:
		// parTopLeftWithoutBorder - точка левого верхнего угла без бордюра.
		public function set TopLeftWithoutBorder
			( parTopLeftWithoutBorder: Point ): void
		{
			// Абсцисса левой стороны без бордюра.
			this.LeftWithoutBorder = parTopLeftWithoutBorder.x;
			// Ордината верхений стороны без бордюра.
			this.TopWithoutBorder  = parTopLeftWithoutBorder.y;
		} // TopLeftWithoutBorder
		
		// Get-метод получения точки правого нижнего угла без бордюра.
		// Результат: точка правого нижнего угла без бордюра.
		public function get BottomRightWithoutBorder( ): Point
		{
			// Точка правого нижнего угла без бордюра.
			return new Point( this.RightWithoutBorder, this.BottomWithoutBorder );
		} // BottomRightWithoutBorder
		
		// Set-метод установки точки правого нижнего угла без бордюра.
		// Параметры:
		// parBottomRightWithoutBorder - точка правого нижнего угла без бордюра.
		public function set BottomRightWithoutBorder
			( parBottomRightWithoutBorder: Point ): void
		{
			// Абсцисса правой стороны без бордюра.
			this.RightWithoutBorder  = parBottomRightWithoutBorder.x;
			// Ордината нижней стороны без бордюра.
			this.BottomWithoutBorder = parBottomRightWithoutBorder.y;
		} // BottomRightWithoutBorder
		
		// Get-метод получения размера без бордюра.
		// Результат: размер без бордюра.
		public function get SizeWithoutBorder( ): Point
		{
			// Размер без бордюра.
			return new Point( this.WidthWithoutBorder, this.HeightWithoutBorder );
		} // SizeWithoutBorder
		
		// Set-метод установки размера без бордюра.
		// Параметры:
		// parSizeWithoutBorder - размер без бордюра.
		public function set SizeWithoutBorder
			( parSizeWithoutBorder: Point ): void
		{
			// Ширина без бордюра.
			this.WidthWithoutBorder  = parSizeWithoutBorder.x;
			// Высота без бордюра.
			this.HeightWithoutBorder = parSizeWithoutBorder.y;
		} // SizeWithoutBorder
		
		// Get-метод получения границ с бордюром.
		// Результат: границы с бордюром.
		public function get BoundsWithBorder( ): Rectangle
		{
			// Границы с бордюром.
			return new Rectangle
			(
				this.x,
				this.y,
				this.width,
				this.height
			); // return
		} // BoundsWithBorder	
		
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
			// Границы без бордюра.
			return new Rectangle
			(
				this.XWithoutBorder,
				this.YWithoutBorder,
				this.WidthWithoutBorder,
				this.HeightWithoutBorder
			); // return
		} // BoundsWithoutBorder
		
		// Set-метод установки границ без бордюра.
		// Параметры:
		// parBoundsWithoutBorder - границы без бордюра.
		public function set BoundsWithoutBorder
			( parBoundsWithoutBorder: Rectangle ): void
		{
			// Абсцисса без бордюра.
			this.XWithoutBorder      = parBoundsWithoutBorder.x; 
			// Oрдината без бордюра.
			this.YWithoutBorder      = parBoundsWithoutBorder.y; 
			// Ширина без бордюра.
			this.WidthWithoutBorder  = parBoundsWithoutBorder.width;
			// Высота без бордюра.
			this.HeightWithoutBorder = parBoundsWithoutBorder.height;
		} // BoundsWithoutBorder				
	} // RectangleWithPerimeterBorder
} // nijanus.display