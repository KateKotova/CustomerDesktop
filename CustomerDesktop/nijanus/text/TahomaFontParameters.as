// CustomerDesktop
// Author Kate Kotova
// NIJANUS Copyright © 2004-2010
// nijanus@ymail.com
// http://nijanus.narod2.ru
//---------------------------------------------------------------------------
// Пакет классов для работы с текстом и шрифтами.
package nijanus.text
{
	// Класс параметров шрифта Tahoma.
	public class TahomaFontParameters extends FontParameters
	{
		// Статические константы.
		
		// Имя.
		public static const NAME: String = "Tahoma";
		
		// Размеры символа обычного начертания шрифта.
		public static const REGULAR_FONT_SYMBOL_SIZES:      Array =
		[	
		 	// Размер шрифта - 0.
		 	new SymbolSize( ),
		 	// Размер шрифта - 1.
			new SymbolSize(  3,  3 ),
		 	// Размер шрифта - 2.
			new SymbolSize(  4,  5 ),			
		 	// Размер шрифта - 3.
			new SymbolSize(  7,  5 ),	
		 	// Размер шрифта - 4.
			new SymbolSize(  8,  7 ),
		 	// Размер шрифта - 5.
			new SymbolSize(  9,  8 ),
		 	// Размер шрифта - 6.
			new SymbolSize( 10,  9 ),			
		 	// Размер шрифта - 7.
			new SymbolSize( 12, 10 ),
		 	// Размер шрифта - 8.
			new SymbolSize( 13, 10 ),
		 	// Размер шрифта - 9.
			new SymbolSize( 15, 14 ),
		 	// Размер шрифта - 10.
			new SymbolSize( 17, 16 ),
		 	// Размер шрифта - 11.
			new SymbolSize( 17, 17 ),
		 	// Размер шрифта - 12.
			new SymbolSize( 19, 20 ),
		 	// Размер шрифта - 13.
			new SymbolSize( 21, 21 ),
		 	// Размер шрифта - 14.
			new SymbolSize( 22, 22 ),
		 	// Размер шрифта - 15.
			new SymbolSize( 24, 25 ),
		 	// Размер шрифта - 16.
			new SymbolSize( 26, 26 ),
		 	// Размер шрифта - 17.
			new SymbolSize( 27, 26 ),
		 	// Размер шрифта - 18.
			new SymbolSize( 28, 29 ),
		 	// Размер шрифта - 19.
			new SymbolSize( 30, 30 ),
		 	// Размер шрифта - 20.
			new SymbolSize( 31, 31 ),			
		 	// Размер шрифта - 21.
			new SymbolSize( 32, 31 ),	
		 	// Размер шрифта - 22.
			new SymbolSize( 33, 33 ),
		 	// Размер шрифта - 23.
			new SymbolSize( 35, 36 ),
		 	// Размер шрифта - 24.
			new SymbolSize( 37, 38 ),
		 	// Размер шрифта - 25.
			new SymbolSize( 39, 40 ),
		 	// Размер шрифта - 26.
			new SymbolSize( 40, 40 ),
		 	// Размер шрифта - 27.
			new SymbolSize( 42, 43 ),
		 	// Размер шрифта - 28.
			new SymbolSize( 43, 44 ),
		 	// Размер шрифта - 29.
			new SymbolSize( 44, 45 ),
		 	// Размер шрифта - 30.
			new SymbolSize( 46, 45 ),
		 	// Размер шрифта - 31.
			new SymbolSize( 48, 49 ),
		 	// Размер шрифта - 32.
			new SymbolSize( 49, 51 ),
		 	// Размер шрифта - 33.
			new SymbolSize( 50, 52 ),
		 	// Размер шрифта - 34.
			new SymbolSize( 52, 53 ),
		 	// Размер шрифта - 35.
			new SymbolSize( 53, 55 ),
		 	// Размер шрифта - 36.
			new SymbolSize( 55, 57 ),
		 	// Размер шрифта - 37.
			new SymbolSize( 57, 59 ),
		 	// Размер шрифта - 38.
			new SymbolSize( 58, 60 ),
		 	// Размер шрифта - 39.
			new SymbolSize( 59, 61 ),
		 	// Размер шрифта - 40.
			new SymbolSize( 61, 64 )				
		]; // REGULAR_FONT_SYMBOL_SIZES		
		
		// Размеры символа полужирного начертание шрифта.
		public static const BOLD_FONT_SYMBOL_SIZES:         Array =
		[	
		 	// Размер шрифта - 0.
		 	new SymbolSize( ),
		 	// Размер шрифта - 1.
			new SymbolSize(  3,  3 ),
		 	// Размер шрифта - 2.
			new SymbolSize(  4,  5 ),			
		 	// Размер шрифта - 3.
			new SymbolSize(  7,  5 ),	
		 	// Размер шрифта - 4.
			new SymbolSize(  9,  7 ),
		 	// Размер шрифта - 5.
			new SymbolSize( 10,  8 ),
		 	// Размер шрифта - 6.
			new SymbolSize( 12,  9 ),			
		 	// Размер шрифта - 7.
			new SymbolSize( 14, 10 ),
		 	// Размер шрифта - 8.
			new SymbolSize( 15, 10 ),
		 	// Размер шрифта - 9.
			new SymbolSize( 17, 14 ),
		 	// Размер шрифта - 10.
			new SymbolSize( 19, 16 ),
		 	// Размер шрифта - 11.
			new SymbolSize( 20, 17 ),
		 	// Размер шрифта - 12.
			new SymbolSize( 22, 20 ),
		 	// Размер шрифта - 13.
			new SymbolSize( 24, 21 ),
		 	// Размер шрифта - 14.
			new SymbolSize( 25, 22 ),
		 	// Размер шрифта - 15.
			new SymbolSize( 27, 25 ),
		 	// Размер шрифта - 16.
			new SymbolSize( 29, 26 ),
		 	// Размер шрифта - 17.
			new SymbolSize( 30, 26 ),
		 	// Размер шрифта - 18.
			new SymbolSize( 32, 29 ),
		 	// Размер шрифта - 19.
			new SymbolSize( 34, 30 ),			
		 	// Размер шрифта - 20.
			new SymbolSize( 35, 31 ),			
		 	// Размер шрифта - 21.
			new SymbolSize( 37, 33 ),	
		 	// Размер шрифта - 22.
			new SymbolSize( 39, 35 ),
		 	// Размер шрифта - 23.
			new SymbolSize( 40, 36 ),
		 	// Размер шрифта - 24.
			new SymbolSize( 42, 38 ),
		 	// Размер шрифта - 25.
			new SymbolSize( 44, 40 ),
		 	// Размер шрифта - 26.
			new SymbolSize( 45, 40 ),
		 	// Размер шрифта - 27.
			new SymbolSize( 47, 43 ),
		 	// Размер шрифта - 28.
			new SymbolSize( 49, 44 ),
		 	// Размер шрифта - 29.
			new SymbolSize( 50, 45 ),
		 	// Размер шрифта - 30.
			new SymbolSize( 52, 45 ),			
		 	// Размер шрифта - 31.
			new SymbolSize( 54, 49 ),
		 	// Размер шрифта - 32.
			new SymbolSize( 55, 51 ),
		 	// Размер шрифта - 33.
			new SymbolSize( 57, 52 ),
		 	// Размер шрифта - 34.
			new SymbolSize( 59, 53 ),
		 	// Размер шрифта - 35.
			new SymbolSize( 60, 55 ),
		 	// Размер шрифта - 36.
			new SymbolSize( 62, 57 ),
		 	// Размер шрифта - 37.
			new SymbolSize( 64, 59 ),
		 	// Размер шрифта - 38.
			new SymbolSize( 65, 60 ),
		 	// Размер шрифта - 39.
			new SymbolSize( 67, 61 ),
		 	// Размер шрифта - 40.
			new SymbolSize( 70, 64 )
		]; // BOLD_FONT_SYMBOL_SIZES
		
		// Размеры символа курсивного начертание шрифта.
		public static const ITALIC_FONT_SYMBOL_SIZES:       Array =	
		[
		 	// Размер шрифта - 0.
		 	new SymbolSize( ),
		 	// Размер шрифта - 1.
			new SymbolSize(  3,  3 ),
		 	// Размер шрифта - 2.
			new SymbolSize(  4,  5 ),			
		 	// Размер шрифта - 3.
			new SymbolSize(  7,  5 ),	
		 	// Размер шрифта - 4.
			new SymbolSize(  9,  7 ),
		 	// Размер шрифта - 5.
			new SymbolSize( 10,  8 ),
		 	// Размер шрифта - 6.
			new SymbolSize( 12,  9 ),			
		 	// Размер шрифта - 7.
			new SymbolSize( 13, 10 ),
		 	// Размер шрифта - 8.
			new SymbolSize( 14, 10 ),
		 	// Размер шрифта - 9.
			new SymbolSize( 16, 14 ),
		 	// Размер шрифта - 10.
			new SymbolSize( 18, 16 ),
		 	// Размер шрифта - 11.
			new SymbolSize( 19, 17 ),
		 	// Размер шрифта - 12.
			new SymbolSize( 20, 20 ),
		 	// Размер шрифта - 13.
			new SymbolSize( 23, 21 ),
		 	// Размер шрифта - 14.
			new SymbolSize( 24, 22 ),
		 	// Размер шрифта - 15.
			new SymbolSize( 25, 25 ),
		 	// Размер шрифта - 16.
			new SymbolSize( 27, 26 ),
		 	// Размер шрифта - 17.
			new SymbolSize( 28, 26 ),
		 	// Размер шрифта - 18.
			new SymbolSize( 30, 29 ),
		 	// Размер шрифта - 19.
			new SymbolSize( 32, 30 ),
		 	// Размер шрифта - 20.
			new SymbolSize( 33, 31 ),			
		 	// Размер шрифта - 21.
			new SymbolSize( 35, 31 ),	
		 	// Размер шрифта - 22.
			new SymbolSize( 37, 33 ),
		 	// Размер шрифта - 23.
			new SymbolSize( 38, 36 ),
		 	// Размер шрифта - 24.
			new SymbolSize( 40, 38 ),
		 	// Размер шрифта - 25.
			new SymbolSize( 41, 40 ),
		 	// Размер шрифта - 26.
			new SymbolSize( 42, 40 ),
		 	// Размер шрифта - 27.
			new SymbolSize( 45, 43 ),
		 	// Размер шрифта - 28.
			new SymbolSize( 46, 44 ),
		 	// Размер шрифта - 29.
			new SymbolSize( 47, 45 ),
		 	// Размер шрифта - 30.
			new SymbolSize( 49, 45 ),
		 	// Размер шрифта - 31.
			new SymbolSize( 51, 49 ),
		 	// Размер шрифта - 32.
			new SymbolSize( 52, 51 ),
		 	// Размер шрифта - 33.
			new SymbolSize( 54, 52 ),
		 	// Размер шрифта - 34.
			new SymbolSize( 55, 53 ),
		 	// Размер шрифта - 35.
			new SymbolSize( 56, 55 ),
		 	// Размер шрифта - 36.
			new SymbolSize( 59, 57 ),
		 	// Размер шрифта - 37.
			new SymbolSize( 60, 59 ),
		 	// Размер шрифта - 38.
			new SymbolSize( 61, 60 ),
		 	// Размер шрифта - 39.
			new SymbolSize( 63, 61 ),
		 	// Размер шрифта - 40.
			new SymbolSize( 65, 64 )		 
		]; // ITALIC_FONT_SYMBOL_SIZES
		
		// Размеры символа курсивного полужирного начертание шрифта.
		public static const BOLD_ITALIC_FONT_SYMBOL_SIZES:  Array =
		[
		 	// Размер шрифта - 0.
		 	new SymbolSize( ),
		 	// Размер шрифта - 1.
			new SymbolSize(  3,  3 ),
		 	// Размер шрифта - 2.
			new SymbolSize(  4,  5 ),			
		 	// Размер шрифта - 3.
			new SymbolSize(  7,  5 ),	
		 	// Размер шрифта - 4.
			new SymbolSize(  9,  7 ),
		 	// Размер шрифта - 5.
			new SymbolSize( 11,  8 ),
		 	// Размер шрифта - 6.
			new SymbolSize( 12,  9 ),			
		 	// Размер шрифта - 7.
			new SymbolSize( 15, 10 ),
		 	// Размер шрифта - 8.
			new SymbolSize( 16, 10 ),
		 	// Размер шрифта - 9.
			new SymbolSize( 19, 14 ),
		 	// Размер шрифта - 10.
			new SymbolSize( 20, 16 ),
		 	// Размер шрифта - 11.
			new SymbolSize( 21, 17 ),
		 	// Размер шрифта - 12.
			new SymbolSize( 23, 20 ),
		 	// Размер шрифта - 13.
			new SymbolSize( 25, 21 ),
		 	// Размер шрифта - 14.
			new SymbolSize( 27, 22 ),
		 	// Размер шрифта - 15.
			new SymbolSize( 29, 25 ),
		 	// Размер шрифта - 16.
			new SymbolSize( 31, 26 ),
		 	// Размер шрифта - 17.
			new SymbolSize( 32, 26 ),
		 	// Размер шрифта - 18.
			new SymbolSize( 34, 29 ),
		 	// Размер шрифта - 19.
			new SymbolSize( 36, 30 ),			
		 	// Размер шрифта - 20.
			new SymbolSize( 37, 31 ),			
		 	// Размер шрифта - 21.
			new SymbolSize( 40, 33 ),	
		 	// Размер шрифта - 22.
			new SymbolSize( 41, 35 ),
		 	// Размер шрифта - 23.
			new SymbolSize( 43, 36 ),
		 	// Размер шрифта - 24.
			new SymbolSize( 44, 38 ),
		 	// Размер шрифта - 25.
			new SymbolSize( 47, 40 ),
		 	// Размер шрифта - 26.
			new SymbolSize( 48, 40 ),
		 	// Размер шрифта - 27.
			new SymbolSize( 50, 43 ),
		 	// Размер шрифта - 28.
			new SymbolSize( 52, 44 ),
		 	// Размер шрифта - 29.
			new SymbolSize( 53, 45 ),
		 	// Размер шрифта - 30.
			new SymbolSize( 55, 45 ),			
		 	// Размер шрифта - 31.
			new SymbolSize( 57, 49 ),			
		 	// Размер шрифта - 32.
			new SymbolSize( 59, 51 ),
		 	// Размер шрифта - 33.
			new SymbolSize( 61, 52 ),
		 	// Размер шрифта - 34.
			new SymbolSize( 63, 53 ),
		 	// Размер шрифта - 35.
			new SymbolSize( 64, 55 ),
		 	// Размер шрифта - 36.
			new SymbolSize( 66, 57 ),
		 	// Размер шрифта - 37.
			new SymbolSize( 68, 59 ),
		 	// Размер шрифта - 38.
			new SymbolSize( 69, 60 ),
		 	// Размер шрифта - 39.
			new SymbolSize( 70, 61 ),
		 	// Размер шрифта - 40.
			new SymbolSize( 73, 64 )				
		]; // BOLD_ITALIC_FONT_SYMBOL_SIZES
		
		// Размеры символа.
		public static const SYMBOL_SIZES: Object =
		{
			// Неизвестное начертание шрифта.
			UNKNOWN:     null,
			// Обычное начертание шрифта.
			REGULAR:     TahomaFontParameters.REGULAR_FONT_SYMBOL_SIZES,			
			// Полужирное начертание шрифта.
			BOLD:        TahomaFontParameters.BOLD_FONT_SYMBOL_SIZES,			
			// Курсивное начертание шрифта.
			ITALIC:      TahomaFontParameters.ITALIC_FONT_SYMBOL_SIZES,			
			// Курсивное полужирное начертание шрифта.
			BOLD_ITALIC: TahomaFontParameters.ITALIC_FONT_SYMBOL_SIZES
		} // SYMBOL_SIZES
		//-----------------------------------------------------------------------		
		// Методы-конструкторы.
		
		// Метод-конструктор экземпляра параметров шрифта Tahoma.
		// Параметры:
		// parIsBold   - признак жирности,
		// parIsItalic - признак курсивного нечертания.
		public function TahomaFontParameters
		(
			parIsBold:   Boolean = false,
			parIsItalic: Boolean = false		
		): void
		{
			// Вызов метода-конструктора суперкласса FontParameters.
			super( parIsBold, parIsItalic );			
			// Имя.
			this._Name        = TahomaFontParameters.NAME;
			// Размеры символа.
			this._SymbolSizes = TahomaFontParameters.SYMBOL_SIZES;			
		} // TahomaFontParameters
	} // TahomaFontParameters
} // nijanus.text