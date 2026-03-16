// CustomerDesktop
// Author Kate Kotova
// NIJANUS Copyright © 2004-2010
// nijanus@ymail.com
// http://nijanus.narod2.ru
//---------------------------------------------------------------------------
// Пакет классов для работы с текстом и шрифтами.
package nijanus.text
{
	// Класс размер символа.
	public class SymbolSize
	{
		// Список импортированных классов из других пакетов.
		import flash.geom.Point;
		//-----------------------------------------------------------------------
		// Переменные экземпляра класса.
		
		// Ширина.
		private var _Width:  Number = 0;
		// Высота.
		private var _Height: Number = 0;
		//-----------------------------------------------------------------------
		// Методы экземпляра класса.
		
		// Метод получения длины строки.
		// Параметры:
		// parSymbolsCount - количество символов в строке.
		// Результат: длина строки.
		public function GetStringLength( parSymbolsCount: uint ): Number	
		{
			// Длина строки - произведение ширины символа
			// на их количество в строке.
			return this._Width * parSymbolsCount;			
		} // GetStringLength	
		
		// Метод получения высоты текста.
		// Параметры:
		// parLinesCount                - количество строк в тексте,
		// parLinesLeadingVerticalSpace - вертикальный межстрочный интервал.
		// Результат: высота текста.
		public function GetTextHeight
		(
			parLinesCount:                uint,
			parLinesLeadingVerticalSpace: Number = 0 
		): Number	
		{
			// Высота текста - сумма высот строк
			// (произведение высота символа в строке на количество строк в тексте)
			// и высот вертикальных межстрочных интервалов
			// (произведение величины вертикального межстрочного интервала
			// на их количество в тексте - на один меньше, чем строк).
			return this._Height * parLinesCount + parLinesLeadingVerticalSpace *
				( parLinesCount - 1 );			
		} // GetTextHeight	
		
		// Метод получения размера текста.
		// Параметры:
		// parLineSymbolsCount          - количество символов в строке,	
		// parLinesCount                - количество строк в тексте,
		// parLinesLeadingVerticalSpace - вертикальный межстрочный интервал.
		// Результат: размер текста. 
		public function GetTextSize
		(
			parLineSymbolsCount:          uint   = 1,
			parLinesCount:                uint   = 1,
			parLinesLeadingVerticalSpace: Number = 0
		): Point			
		{
			// Размер текста в виде экземпляра точки:
			// x - ширина текста,
			// y - высота текста.
			return new Point
			(
				// Ширина текста.
				this.GetStringLength( parLineSymbolsCount ),
				// Высота текста.
				this.GetTextHeight( parLinesCount, parLinesLeadingVerticalSpace )
			); // new Point
		} // GetTextSize
		
		// Метод получения признака того, что текст помещается в области.
		// Параметры:
		// parTextAreaSize - размер области текста,	
		// parTextSize     - размер текста.
		// Результат: признак того, что текст помещается в области.
		public static function TextIsFittingOnArea
		(
			parTextAreaSize,
			parTextSize: Point
		): Boolean		
		{
			// Если ширина и высота области текста не превышают соответственно
			// ширину и высоту текста.
			if
			(
				( parTextAreaSize.x >= parTextSize.x ) &&
				( parTextAreaSize.y >= parTextSize.y )
			)
				// Текст помещается в области.
				return true;
			else
				// Текст не помещается в области.
				return false;
		} // TextIsFittingOnArea
		//-----------------------------------------------------------------------		
		// Методы-конструкторы.
		
		// Метод-конструктор экземпляра размера символа.
		// Параметры:
		// parWidth  - ширина,
		// parHeight - высота.
		public function SymbolSize
		(
			parWidth:  Number = 0,
			parHeight: Number = 0
		): void
		{
			// Ширина.
			this.Width  = parWidth;
			// Высота.
			this.Height =	parHeight;
		} // SymbolSize
		//-----------------------------------------------------------------------
		// Get- и set-методы.
		
		// Get-метод получения ширины.
		// Результат: ширина.
		public function get Width( ): Number
		{
			// Ширина.
			return this._Width;
		} // Width

		// Set-метод установки ширины.
		// Параметры:
		// parWidth - ширина.
		public function set Width( parWidth: Number ): void
		{
			// Если ширина - отрицательное число. 
			if ( parWidth < 0 )
				// Установка нулевой ширины.
				this._Width = 0;
			else
				// Установка заданной ширины.
				this._Width = parWidth;
		} // Width

		// Get-метод получения высоты.
		// Результат: высота.
		public function get Height( ): Number
		{
			// Высота.
			return this._Height;
		} // Height

		// Set-метод установки высоты.
		// Параметры:
		// parHeight - высота.
		public function set Height( parHeight: Number ): void
		{
			// Если высота - отрицательное число. 
			if ( parHeight < 0 )
				// Установка нулевой высоты.
				this._Height = 0;
			else
				// Установка заданной высоты.
				this._Height = parHeight;
		} // Height
	} // SymbolSize
} // nijanus.text