// CustomerDesktop
// Author Kate Kotova
// NIJANUS Copyright © 2004-2010
// nijanus@ymail.com
// http://nijanus.narod2.ru
//---------------------------------------------------------------------------
// Пакет классов, связанных с отображением.
package nijanus.display
{
	// Класс параметров светящейся кнопки.
	public class GlowButtonParameters
	{
		// Переменные экземпляра класса.
		
		// Имя шрифта текстовой метки.
		public var LabelFontName: String = GlowButton.LABEL_FONT_NAME;
		// Размер шрифта текстовой метки.
		public var LabelFontSize: uint   = GlowButton.LABEL_FONT_SIZE;
		
		// Светлый цвет шрифта текстовой метки.
		public var LabelFontLightColor: uint = GlowButton.LABEL_FONT_LIGHT_COLOR;
		// Тёмный цвет шрифта текстовой метки.
		public var LabelFontDarkColor:  uint = GlowButton.LABEL_FONT_DARK_COLOR;

		// Признак жирности шрифта текстовой метки.
		public var LabelFontIsBold:      Boolean = false;
		// Признак курсивного нечертания шрифта текстовой метки.
		public var LabelFontIsItalic:    Boolean = false;
		// Признак подчёркнутого нечертания шрифта текстовой метки.
		public var LabelFontIsUnderline: Boolean = false;	
		
		// Цвет свечения в шестнадцатеричном формате 0xRRGGBB.
		public var GlowColor: uint = GlowButton.GLOW_COLOR;
		//-----------------------------------------------------------------------
		// Методы-конструкторы.
		
		// Метод-конструктор экземпляра параметров светящейся кнопки.
		public function GlowButtonParameters( )
		{
		} // GlowButtonParameters
	} // GlowButtonParameters
} // nijanus.display