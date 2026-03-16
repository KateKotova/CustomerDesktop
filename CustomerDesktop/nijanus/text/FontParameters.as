// CustomerDesktop
// Author Kate Kotova
// NIJANUS Copyright © 2004-2010
// nijanus@ymail.com
// http://nijanus.narod2.ru
//---------------------------------------------------------------------------
// Пакет классов для работы с текстом и шрифтами.
package nijanus.text
{
	// Класс параметров шрифта.
	public class FontParameters
	{
		// Список импортированных классов из других пакетов.
		import flash.geom.Point;
		//-----------------------------------------------------------------------
		// Переменные экземпляра класса.
		
		// Имя.
		protected var _Name:        String  = "";
		// Признак жирности.
		protected var _IsBold:      Boolean = false;
		// Признак курсивного нечертания.
		protected var _IsItalic:    Boolean = false;
		// Размеры символа.
		protected var _SymbolSizes: Object  = null;
		//-----------------------------------------------------------------------
		// Методы экземпляра класса.
		
		// Метод получения размера символа.
		// Параметры:
		// parSize - размер шрифта.
		// Результат: размер символа.
		public function GetSymbolSize( parSize: Number ): SymbolSize	
		{
			// Если размеры символа не определены.
			if ( this._SymbolSizes == null )
				// Неопределённые размеры символа.
				return null;
				
			// Выравнивание шрифта.
			var outline: String    = this.Outline;
			// Размеры симола, соответствующие выравниванию.
			var outlineSymbolSizes = this._SymbolSizes[ outline ];			
			// Если размеры символа, соответствующие выравниванию, не определены
			// или их количество нулевое.
			if
			(
				( outlineSymbolSizes        == null ) ||
				( outlineSymbolSizes.length == 0 )
			)
				// Неопределённые размеры символа.
				return null;
			
			// Если размер шрифта отрицателен.
			if ( parSize < 0 )
				// Размер шрифта обнуляется.
				parSize = 0;				
			// Округление размера шрифта вверх до ближайшего целого.
			parSize = Math.ceil( parSize );
			
			// Размер символа, соответствующий размеру шрифта и выравниванию.
			return outlineSymbolSizes[ parSize ];
		} // GetSymbolSize
		
		// Метод получения размера шрифта текстовой области.
		// Параметры:
		// parTextAreaSize         - размер области текста,
		// parTextLineWidthCompressionRatio  - коэффициент сжатия
		//   ширины строки текста,
		// parTextLineHeightCompressionRatio - коэффициент сжатия
		//   высоты строки текста,
		// parFontMinimumSize      - минимальный размер шрифта,
		// parTextLineSymbolsCount - количество символов в строке текста,	
		// parTextLinesCount       - количество строк в тексте,
		// parTextLinesLeadingVerticalSpace  - вертикальный межстрочный интервал
		//   в тексте.
		// Результат: размер шрифта текстовой области.
		public function GetTextAreaFontSize
		(
			parTextAreaSize:                   Point,
			parTextLineWidthCompressionRatio:  Number = 1,
			parTextLineHeightCompressionRatio: Number = 1,
			parFontMinimumSize:                uint   = 1,
			parTextLineSymbolsCount:           uint   = 1,
			parTextLinesCount:                 uint   = 1,
			parTextLinesLeadingVerticalSpace:  Number = 0		
		): uint
		{
			// Если размеры символа не определены.
			if ( this._SymbolSizes == null )
				// Неопредлённый размер шрифта текстовой области.
				return null;
				
			// Выравнивание шрифта.
			var outline:            String = this.Outline;
			// Размеры симола, соответствующие выравниванию.
			var outlineSymbolSizes: Array  = this._SymbolSizes[ outline ];			
			// Если размеры символа, соответствующие выравниванию, не определены
			// или их количество нулевое.
			if
			(
				( outlineSymbolSizes        == null ) ||
				( outlineSymbolSizes.length == 0 )
			)
				// Неопределённые размеры символа.
				return null;
			
			// Размер области текста.
			var textAreaSize: Point =
				new Point
				(
				 	// Ширины области текста, умноженная на коэффициент сжатия
					// ширины строки текста.
					parTextAreaSize.x * parTextLineWidthCompressionRatio,
					// Высота области текста, умноженная на коэффициент сжатия
					// высоты строки текста.					
					parTextAreaSize.y * parTextLineHeightCompressionRatio
				); // new Point
				
			// Если минимальный размер шрифта меньше известного минимального
			// или больше известного максимального.
			if
			(
				( parFontMinimumSize < 1 ) ||
				( parFontMinimumSize >= outlineSymbolSizes.length )
			)
				// Минимальный размер шрифта - известный минимальный.
				parFontMinimumSize = 1;
			
			// Просмотр всех размеров шрифта.
			for ( var fontSize = 1; fontSize < outlineSymbolSizes.length;
				fontSize++ )
			{
				// Размер символа, соответствующий размеру шрифта и выравниванию.
				var symbolSize: SymbolSize = outlineSymbolSizes[ fontSize ];
				// Если размер символа не определён.
				if ( symbolSize == null )
					// Переход к следующему размеру шрифта.
					continue;
					
				// Если текст с текущим шрифтом
				// не помещается в заданной текстовой области.
				if
				(
				 	// Признак того, что текст с текущим шрифтом
					// не помещается в заданной текстовой области.
					! SymbolSize.TextIsFittingOnArea					
					(
					 	// Размер области текста.
						textAreaSize,
						// Размер текста с текущим шрифтом.
						symbolSize.GetTextSize
						(
							// Количество символов в строке текста.
							parTextLineSymbolsCount,
							// Количество строк в тексте.
							parTextLinesCount,
							// Вертикальный межстрочный интервал в тексте.
							parTextLinesLeadingVerticalSpace
						) // symbolSize.GetTextSize
					) // SymbolSize.TextIsFittingOnArea
				) // if
				{
					// Если размер шрифта не превышает минимальный.
					if ( fontSize <= parFontMinimumSize )
						// Размер шрифта текстовой области - минимальный.
						return parFontMinimumSize;
					else
						// Размер шрифта текстовой области - предыдущий.
						return fontSize - 1;
				} // if
			} // for
			
			// Размер шрифта текстовой области - максимальный.
			return outlineSymbolSizes.length - 1;
		} // GetTextAreaFontSize 
		//-----------------------------------------------------------------------		
		// Методы-конструкторы.
		
		// Метод-конструктор экземпляра параметров шрифта.
		// Параметры:
		// parIsBold   - признак жирности,
		// parIsItalic - признак курсивного нечертания.
		public function FontParameters
		(
			parIsBold:   Boolean = false,
			parIsItalic: Boolean = false		
		): void
		{
			// Признак жирности.
			this._IsBold   = parIsBold;
			// Признак курсивного нечертания.
			this._IsItalic = parIsItalic;
		} // FontParameters
		//-----------------------------------------------------------------------
		// Get- и set-методы.
		
		// Get-метод получения имени.
		// Результат: имя.
		public function get Name( ): String
		{
			// Имя.
			return this._Name;
		} // Name

		// Get-метод получения признака жирности.
		// Результат: признак жирности.
		public function get IsBold( ): Boolean
		{
			// Признак жирности.
			return this._IsBold;
		} // IsBold

		// Set-метод установки признака жирности.
		// Параметры:
		// parIsBold - признак жирности.
		public function set IsBold( parIsBold: Boolean ): void
		{
			// Признак жирности.
			this._IsBold = parIsBold;
		} // IsBold

		// Get-метод получения признака курсивного нечертания.
		// Результат: признак курсивного нечертания.
		public function get IsItalic( ): Boolean
		{
			// Признак курсивного нечертания.
			return this._IsItalic;
		} // IsItalic

		// Set-метод установки признака курсивного нечертания.
		// Параметры:
		// parIsItalic - признак курсивного нечертания.
		public function set IsItalic( parIsItalic: Boolean ): void
		{
			// Признак курсивного нечертания.
			this._IsItalic = parIsItalic;
		} // IsItalic
		
		// Get-метод получения начертания.
		// Результат: начертание.
		public function get Outline( ): String
		{
			// Если шрифт полужирный.
			if ( this._IsBold )
			{
				// Если шрифт и жирный, и курсивный.
				if ( this._IsItalic )
					// Начертание - полжирный курсив.
					return FontOutline.BOLD_ITALIC;
				// Если шрифт жирный, но не курсивный.
				else
					// Начертание - полжирный.
					return FontOutline.BOLD;				
			} // if
			
			// Если шрифт курсивный.
			if ( this._IsItalic )
				// Начертание - курсив.
				return FontOutline.ITALIC;
				
			// Начертание - обычный.
			return FontOutline.REGULAR;
		} // Outline
		
		// Get-метод получения размеров символа.
		// Результат: размеры символа.
		public function get SymbolSizes( ): Boolean
		{
			// Размеры символа.
			return this._SymbolSizes;
		} // SymbolSizes
	} // FontParameters
} // nijanus.text