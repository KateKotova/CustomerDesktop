// CustomerDesktop
// Author Kate Kotova
// NIJANUS Copyright © 2004-2010
// nijanus@ymail.com
// http://nijanus.narod2.ru
//---------------------------------------------------------------------------
// Пакет классов рабочего стола покупателя для работы с текстом и шрифтами.
package nijanus.customerDesktop.text
{
	// Класс текстовых параметров.
	public class TextParameters
	{
		// Список импортированных классов из других пакетов.
		
		import nijanus.text.FontParameters;
		import nijanus.text.TahomaFontParameters;
		//-----------------------------------------------------------------------
		// Статические константы.
		
		// Пустая строка.
		public static const EMPTY_STRNG: String = "";
		// Точка.
		public static const POINT:       String = ".";
		// Косая черта.
		public static const SLASH:       String = "/";
		// Двоеточие.
		public static const COLON:       String = ":";
		//-----------------------------------------------------------------------		
		// Переменные экземпляра класса.
		
		// Основные параметры шрифта - параметры шрифта Tahoma.
		public var MainFontParameters:  FontParameters =
			new TahomaFontParameters( );
		// Минимальный размер основного шрифта.
		public var MainFontMinimumSize: uint = 10;
		// Основной цвет шрифта.
		public var MainFontColor:       uint = 0xFFFF99;
		
		// Коэффициент сжатия ширины текстовой метки светящейся кнопки.
		public var GlowButtonLabelWidthCompressionRatio:  Number = 2.5;
		// Коэффициент сжатия высоты текстовой метки светящейся кнопки.
		public var GlowButtonLabelHeightCompressionRatio: Number = 0.5;	
		// Количество символов-отступов текстовой метки светящейся кнопки.
		public var GlowButtonLabelIndentionSymbolsCount:  Number = 2;

		// Цвет свечения светящейся кнопки.
		public var GlowButtonGlowColor:           uint = 0x47EDDF;
		// Светлый цвет шрифта текстовой метки светящейся кнопки.
		public var GlowButtonLabelFontLightColor: uint = 0xFFFF99;
		// Тёмный цвет шрифта текстовой метки светящейся кнопки.
		public var GlowButtonLabelFontDarkColor:  uint = 0x424200;
			
		// Цвет свечения особой светящейся кнопки.
		public var SpecialGlowButtonGlowColor:           uint = 0x44EA8A;
		// Светлый цвет шрифта текстовой метки особой светящейся кнопки.
		public var SpecialGlowButtonLabelFontLightColor: uint = 0xFFD299;
		// Тёмный цвет шрифта текстовой метки особой светящейся кнопки.
		public var SpecialGlowButtonLabelFontDarkColor:  uint = 0x583E01;
		//-----------------------------------------------------------------------		
		// Методы-конструкторы.
		
		// Метод-конструктор экземпляра текстовых параметров.
		public function TextParameters( ): void
		{
		} // TextParameters
		//-----------------------------------------------------------------------
		// Get- и set-методы.
		
		// Set-метод установки признака жирности основного шрифта.
		// Параметры:
		// parMainFontIsBold - признак жирности основного шрифта.
		public function set MainFontIsBold
			( parMainFontIsBold: Boolean ): void
		{
			// Признак жирности основного шрифта.
			this.MainFontParameters.IsBold = parMainFontIsBold;
		} // MainFontIsBold

		// Set-метод установки признака курсивного нечертания основного шрифта.
		// Параметры:
		// parMainFontIsItalic - признак курсивного нечертания основного шрифта.
		public function set MainFontIsItalic
			( parMainFontIsItalic: Boolean ): void
		{
			// Признак курсивного нечертания основного шрифта.
			this.MainFontParameters.IsItalic = parMainFontIsItalic;
		} // MainFontIsItalic
	} // TextParameters
} // nijanus.customerDesktop.text