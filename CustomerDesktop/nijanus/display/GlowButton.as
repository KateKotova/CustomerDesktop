// CustomerDesktop
// Author Kate Kotova
// NIJANUS Copyright © 2004-2010
// nijanus@ymail.com
// http://nijanus.narod2.ru
//---------------------------------------------------------------------------
// Пакет классов, связанных с отображением.
package nijanus.display
{
	// Класс светящейся кнопки.
	public class GlowButton extends GlowButtonBase
	{
		// Список импортированных классов из других пакетов.

    import flash.events.MouseEvent;    
    import flash.filters.BitmapFilterQuality;
    import flash.filters.GlowFilter;		
		import flash.text.TextField;
		import flash.text.TextFormat;
		import flash.text.TextFormatAlign;
		//-----------------------------------------------------------------------		
		// Статические константы.
		
		// Название стиля текстового формата текстовой метки.
		public static const LABEL_TEXT_FORMAT_STYLE_NAME: String = "textFormat";
		// Имя шрифта текстовой метки по умолчанию.
		public static const LABEL_FONT_NAME:              String = "Tahoma";
		// Размер шрифта текстовой метки по умолчанию.
		public static const LABEL_FONT_SIZE:              Number = 10;
		// Светлый цвет шрифта текстовой метки по умолчанию.
		public static const LABEL_FONT_LIGHT_COLOR:       uint   = 0xFFFFFF;
		// Тёмный цвет шрифта текстовой метки по умолчанию.
		public static const LABEL_FONT_DARK_COLOR:        uint   = 0x000000;		
		// URL-адрес гиперссылки текстового формата текстовой метки.
		public static const LABEL_TEXT_FORMAT_URL:        String = "";
		// Пустая строка текстовой метки.
		public static const LABEL_EMPTY_STRING:           String = "";		
		
		// Цвет свечения по умолчанию в шестнадцатеричном формате 0xRRGGBB -
		// цвет морской волны.
		public static const GLOW_COLOR:          uint    = 0x47EDDF;
		// Значение альфа-прозрачности цвета свечения.
		public static const GLOW_ALPHA:          Number  = 0.5;
		// Степень размытия свечения по горизонтали.
		public static const GLOW_BLUR_X:         Number  = 8;
		// Качество применения фильтра свечения - высшее.
		public static const GLOW_FILTER_QUALITY: int = BitmapFilterQuality.HIGH;
		// Признак того, что свечение внутреннее, а не внешнее.
		public static const GLOW_IS_INNER:       Boolean = false;
		// Признак применения эффекта выбивки.
		public static const KNOCKOUT_IS_USED:    Boolean = false;
		
		// Степень размытия свечения по вертикали
		// для обложки отпущенного состояния.
		public static const UP_SKIN_GLOW_BLUR_X:            Number = 8;
		// Степень размытия свечения по вертикали
		// для обложки наведённого состояния.
		public static const OVER_SKIN_GLOW_BLUR_X:          Number = 16;
		// Степень размытия свечения по вертикали
		// для обложки нажатого состояния.
		public static const DOWN_SKIN_GLOW_BLUR_X:          Number = 24;
		// Степень размытия свечения по вертикали
		// для обложки наведённого выбранного состояния.
		public static const SELECTED_OVER_SKIN_GLOW_BLUR_X: Number = 32;
		
		// Степень вдавливания или растискивания свечения
		// для обложки отпущенного состояния.
		public static const UP_SKIN_GLOW_STRENGTH:            Number = 1;
		// Степень вдавливания или растискивания свечения
		// для обложки наведённого состояния.
		public static const OVER_SKIN_GLOW_STRENGTH:          Number = 3;
		// Степень вдавливания или растискивания свечения
		// для обложки нажатого состояния.
		public static const DOWN_SKIN_GLOW_STRENGTH:          Number = 3;
		// Степень вдавливания или растискивания свечения
		// для обложки наведённого выбранного состояния.
		public static const SELECTED_OVER_SKIN_GLOW_STRENGTH: Number = 3;
		//-----------------------------------------------------------------------
		// Переменные экземпляра класса.
		
		// Имя шрифта текстовой метки.
		protected var _LabelFontName:   String = GlowButton.LABEL_FONT_NAME;
		// Размер шрифта текстовой метки.
		protected var _LabelFontSize:   Number = GlowButton.LABEL_FONT_SIZE;
		// Текстовый формат текстовой метки.
		protected var _LabelTextFormat: TextFormat;		
		
		// Светлый цвет шрифта текстовой метки.
		protected var _LabelFontLightColor: uint =
			GlowButton.LABEL_FONT_LIGHT_COLOR;
		// Тёмный цвет шрифта текстовой метки.
		protected var _LabelFontDarkColor:  uint =
			GlowButton.LABEL_FONT_DARK_COLOR;
		
		// Признак жирности шрифта текстовой метки.
		protected var _LabelFontIsBold:      Boolean = false;
		// Признак курсивного нечертания шрифта текстовой метки.
		protected var _LabelFontIsItalic:    Boolean = false;
		// Признак подчёркнутого нечертания шрифта текстовой метки.
		protected var _LabelFontIsUnderline: Boolean = false;	
		
		// Цвет свечения в шестнадцатеричном формате 0xRRGGBB.
		protected var _GlowColor: uint = GlowButton.GLOW_COLOR;
		//-----------------------------------------------------------------------		
		// Методы экземпляра класса.
		
		// Метод установка текстового формата текстовой метки.
		protected function SetLabelTextFormat( ): void
		{
			// Установка стиля текстового формата текстовой метки.
			this.setStyle( GlowButton.LABEL_TEXT_FORMAT_STYLE_NAME,
				this._LabelTextFormat );			
		} // SetLabelTextFormat	
		
		// Метод получения фильтра эффекта свечения
		// для обложки отпущенного состояния.
		// Результат: фильтр эффекта свечения для обложки отпущенного состояния.
		public function GetUpSkinGlowFilter( ): GlowFilter	
		{
			return new GlowFilter
				(
					// Цвет свечения в шестнадцатеричном формате 0xRRGGBB.
					this._GlowColor,
					// Значение альфа-прозрачности цвета.
					GlowButton.GLOW_ALPHA,
					// Степень размытия по горизонтали.
					GlowButton.GLOW_BLUR_X,
					// Степень размытия по вертикали.
					GlowButton.UP_SKIN_GLOW_BLUR_X,
					// Степень вдавливания или растискивания.
					GlowButton.UP_SKIN_GLOW_STRENGTH,
					// Качество применения фильтра.
					GlowButton.GLOW_FILTER_QUALITY,
					// Признак того, что свечение внутреннее, а не внешнее.
					GlowButton.GLOW_IS_INNER,
					// Признак применения эффекта выбивки.
					GlowButton.KNOCKOUT_IS_USED
				); // return			
		} // GetUpSkinGlowFilter
		
		// Метод получения фильтра эффекта свечения
		// для обложки наведённого состояния.
		// Результат: фильтр эффекта свечения для обложки наведённого состояния.
		public function GetOverSkinGlowFilter( ): GlowFilter	
		{
			return new GlowFilter
				(
					// Цвет свечения в шестнадцатеричном формате 0xRRGGBB.
					this._GlowColor,
					// Значение альфа-прозрачности цвета.
					GlowButton.GLOW_ALPHA,
					// Степень размытия по горизонтали.
					GlowButton.GLOW_BLUR_X,
					// Степень размытия по вертикали.
					GlowButton.OVER_SKIN_GLOW_BLUR_X,
					// Степень вдавливания или растискивания.
					GlowButton.OVER_SKIN_GLOW_STRENGTH,
					// Качество применения фильтра.
					GlowButton.GLOW_FILTER_QUALITY,
					// Признак того, что свечение внутреннее, а не внешнее.
					GlowButton.GLOW_IS_INNER,
					// Признак применения эффекта выбивки.
					GlowButton.KNOCKOUT_IS_USED
				); // return			
		} // GetOverSkinGlowFilter			
		
		// Метод получения фильтра эффекта свечения
		// для обложки нажатого состояния.
		// Результат: фильтр эффекта свечения для обложки нажатого состояния.
		public function GetDownSkinGlowFilter( ): GlowFilter	
		{
			return new GlowFilter
				(
					// Цвет свечения в шестнадцатеричном формате 0xRRGGBB.
					this._GlowColor,
					// Значение альфа-прозрачности цвета.
					GlowButton.GLOW_ALPHA,
					// Степень размытия по горизонтали.
					GlowButton.GLOW_BLUR_X,
					// Степень размытия по вертикали.
					GlowButton.DOWN_SKIN_GLOW_BLUR_X,
					// Степень вдавливания или растискивания.
					GlowButton.DOWN_SKIN_GLOW_STRENGTH,
					// Качество применения фильтра.
					GlowButton.GLOW_FILTER_QUALITY,
					// Признак того, что свечение внутреннее, а не внешнее.
					GlowButton.GLOW_IS_INNER,
					// Признак применения эффекта выбивки.
					GlowButton.KNOCKOUT_IS_USED
				); // return			
		} // GetDownSkinGlowFilter			
		
		// Метод получения фильтра эффекта свечения
		// для обложки наведённого выбранного состояния.
		// Результат: фильтр эффекта свечения
		// для обложки наведённого выбранного состояния.
		public function GetSelectedOverSkinGlowFilter( ): GlowFilter	
		{
			return new GlowFilter
				(
					// Цвет свечения в шестнадцатеричном формате 0xRRGGBB.
					this._GlowColor,
					// Значение альфа-прозрачности цвета.
					GlowButton.GLOW_ALPHA,
					// Степень размытия по горизонтали.
					GlowButton.GLOW_BLUR_X,
					// Степень размытия по вертикали.
					GlowButton.SELECTED_OVER_SKIN_GLOW_BLUR_X,
					// Степень вдавливания или растискивания.
					GlowButton.SELECTED_OVER_SKIN_GLOW_STRENGTH,
					// Качество применения фильтра.
					GlowButton.GLOW_FILTER_QUALITY,
					// Признак того, что свечение внутреннее, а не внешнее.
					GlowButton.GLOW_IS_INNER,
					// Признак применения эффекта выбивки.
					GlowButton.KNOCKOUT_IS_USED
				); // return			
		} // GetSelectedOverSkinGlowFilter			

		// Метод установки фильтра эффекта свечения.
		// Параметры:
		// parGlowFilter - фильтр эффекта свечения.
		public function SetGlowFilter( parGlowFilter: GlowFilter ): void	
		{
			// Массив фильтров эффекта свечения.
			var glowFilters: Array = new Array( );
			// Добавление фильтра эффекта свечения в массив.			
			glowFilters.push( parGlowFilter );
			// Переустановка фильтров светящейся кнопки.
			this.filters           = glowFilters;
		} // SetGlowFilter
		
		// Метод установки параметров светящейся кнопки.
		// Параметры:
		// parParameters - параметры светящейся кнопки.		
		public function SetGlowButtonParameters
			( parParameters: GlowButtonParameters ): void
		{
			// Если параметры не определены, то они считаются по умолчанию.
			if ( parParameters == null )
				parParameters = new GlowButtonParameters( );
			
			// Если задано имя шрифта текстовой метки.
			if ( parParameters.LabelFontName != null )
				// Имя шрифта текстовой метки.
				this._LabelFontName = parParameters.LabelFontName;
			// Если задан размер шрифта текстовой метки.
			if ( ! isNaN( parParameters.LabelFontSize ) )				
				// Размер шрифта текстовой метки.
				this._LabelFontSize = parParameters.LabelFontSize;
			
			// Светлый цвет шрифта текстовой метки.
			this._LabelFontLightColor = parParameters.LabelFontLightColor;
			// Тёмный цвет шрифта текстовой метки.
			this._LabelFontDarkColor  = parParameters.LabelFontDarkColor;
			
			// Признак жирности шрифта текстовой метки.
			this._LabelFontIsBold      = parParameters.LabelFontIsBold; 
			// Признак курсивного нечертания шрифта текстовой метки.
			this._LabelFontIsItalic    = parParameters.LabelFontIsItalic;
			// Признак подчёркнутого нечертания шрифта текстовой метки.
			this._LabelFontIsUnderline = parParameters.LabelFontIsUnderline;
			
			// Текстовый формат текстовой метки.
			this._LabelTextFormat =
				new TextFormat
				(
					// Имя шрифта для текста в виде строки.
					parParameters.LabelFontName,
					// Целое число, которое обозначает размер в пикселах.
					this._LabelFontSize,
					// Цвет текста, использующего данный формат.
					// Число, содержащее три 8-разрядных компонента RGB.
					parParameters.LabelFontLightColor,
					// Логическое значение, указывающее, является ли текст полужирным.
					parParameters.LabelFontIsBold,
					// Логическое значение, указывающее, является ли текст курсивным.
					parParameters.LabelFontIsItalic,
					// Логическое значение, указывающее, является ли текст подчеркнутым.
					parParameters.LabelFontIsUnderline,
					// URL-адрес, на который ссылается текст с этим форматом.
					// Если url представлен пустой строкой, текст не имеет гиперссылки.
					GlowButton.LABEL_TEXT_FORMAT_URL,
					// Целевое окно, где отображается гиперссылка.
					null,
					// Выравнивание абзаца - по центру в пределах текстового поля.
					TextFormatAlign.CENTER,
					// Левое поле абзаца (в пикселах).
					0,
					// Правое поле абзаца (в пикселах).
					0,
					// Целое число, указывающее отступ от левого поля
					// до первого символа в абзаце.
					0,
					// Число, указывающее величину вертикального интервала между строками.
					0
				); // new TextFormat			
			
			// Установка текстового формата текстовой метки.
			this.SetLabelTextFormat( );			
			
			// Цвет свечения в шестнадцатеричном формате 0xRRGGBB.
			this._GlowColor = parParameters.GlowColor;			
			// Установка фильтра эффекта свечения
			// для обложки отпущенного состояния.
			this.SetGlowFilter( this.GetUpSkinGlowFilter( ) );			
		} // SetGlowButtonParameters
		//-----------------------------------------------------------------------
		// Методы-прослушиватели событий.

		// Метод-прослушиватель события нажатия кнопки мыши.
		// Параметры:
		// parMouseEvent - событие мыши.
		protected function MouseDownListener( parMouseEvent: MouseEvent ): void
		{
			// Установка фильтра эффекта свечения для обложки нажатого состояния.
			this.SetGlowFilter( this.GetDownSkinGlowFilter( ) );			
			// Цвет текста текстовой метки - тёмный.
			this._LabelTextFormat.color = this._LabelFontDarkColor;			
			// Установка текстового формата текстовой метки.
			this.SetLabelTextFormat( );			
		} // MouseDownListener
		
		// Метод-прослушиватель события клика мыши.		
		// Параметры:
		// parMouseEvent - событие мыши.
		protected function ClickListener( parMouseEvent: MouseEvent ): void
		{
			// Если светящаяся кнопка - кнопка-переключатель.
			if ( this.toggle )
			{
				// Установка фильтра эффекта свечения
				// для обложки наведённого выбранного состояния.
				this.SetGlowFilter( this.GetSelectedOverSkinGlowFilter( ) );
				// Цвет текста текстовой метки - тёмный.
				this._LabelTextFormat.color = this._LabelFontDarkColor;
			} // if
			// Если светящаяся кнопка - не кнопка-переключатель.
			else
			{
				// Установка фильтра эффекта свечения
				// для обложки наведённого состояния.
				this.SetGlowFilter( this.GetOverSkinGlowFilter( ) );
				// Цвет текста текстовой метки - светлый.
				this._LabelTextFormat.color = this._LabelFontLightColor;				
			} // else
				
			// Установка текстового формата текстовой метки.
			this.SetLabelTextFormat( );			
		} // ClickListener
		
		// Метод-прослушиватель события наведения указателя мыши.
		// Параметры:
		// parMouseEvent - событие мыши.
		protected function RollOverListener( parMouseEvent: MouseEvent ): void
		{
			// Если светящаяся кнопка выбрана.
			if ( this.selected )
			{
				// Установка фильтра эффекта свечения
				// для обложки наведённого выбранного состояния.
				this.SetGlowFilter( this.GetSelectedOverSkinGlowFilter( ) );
				// Цвет текста текстовой метки - тёмный.
				this._LabelTextFormat.color = this._LabelFontDarkColor;				
			} // if
			// Если светящаяся кнопка не выбрана.
			else
			{
				// Установка фильтра эффекта свечения
				// для обложки наведённого состояния.
				this.SetGlowFilter( this.GetOverSkinGlowFilter( ) );
				// Цвет текста текстовой метки - светлый.
				this._LabelTextFormat.color = this._LabelFontLightColor;				
			} // else
				
			// Установка текстового формата текстовой метки.
			this.SetLabelTextFormat( );			
		} // RollOverListener
		
		// Метод-прослушиватель события покидания указателем мыши.
		// Параметры:
		// parMouseEvent - событие мыши.
		protected function RollOutListener( parMouseEvent: MouseEvent ): void
		{
			// Если светящаяся кнопка выбрана.
			if ( this.selected )
			{
				// Установка фильтра эффекта свечения для обложки нажатого состояния.
				this.SetGlowFilter( this.GetDownSkinGlowFilter( ) );	
				// Цвет текста текстовой метки - тёмный.
				this._LabelTextFormat.color = this._LabelFontDarkColor;				
			} // if
			// Если светящаяся кнопка не выбрана.
			else
			{
				// Установка фильтра эффекта свечения
				// для обложки отпущенного состояния.
				this.SetGlowFilter( this.GetUpSkinGlowFilter( ) );
				// Цвет текста текстовой метки - светлый.
				this._LabelTextFormat.color = this._LabelFontLightColor;				
			} // else
				
			// Установка текстового формата текстовой метки.
			this.SetLabelTextFormat( );			
		} // RollOutListener
		//-----------------------------------------------------------------------
		// Методы-конструкторы.

		// Метод-конструктор экземпляра светящейся кнопки.
		// Параметры:
		// parParameters - параметры светящейся кнопки.		
		public function GlowButton
			( parParameters: GlowButtonParameters = null ): void
		{
			// Вызов метода-конструктора суперкласса GlowButtonBase.
			super( );
			
			// Установка параметров светящейся кнопки.
			this.SetGlowButtonParameters( parParameters );
	
			// Регистрирация объекта-прослушивателя события нажатия кнопки мыши.
			this.addEventListener( MouseEvent.MOUSE_DOWN, this.MouseDownListener );
			// Регистрирация объекта-прослушивателя события клика мыши.		
			this.addEventListener( MouseEvent.CLICK,      this.ClickListener     );			
			// Регистрирация объекта-прослушивателя события
			// наведения указателя мыши.
			this.addEventListener( MouseEvent.ROLL_OVER,  this.RollOverListener  );
			// Регистрирация объекта-прослушивателя события
			// покидания указателем мыши.
			this.addEventListener( MouseEvent.ROLL_OUT,   this.RollOutListener   );
		} // GlowButton
		//-----------------------------------------------------------------------			
		// Get- и set-методы.
		
		// Get-метод получения имени шрифта текстовой метки.
		// Результат: имя шрифта текстовой метки.
		public function get LabelFontName( ): String
		{
			// Имя шрифта текстовой метки.
			return this._LabelFontName;
		} // LabelFontName	
		
		// Get-метод получения размера шрифта текстовой метки.
		// Результат: размер шрифта текстовой метки.
		public function get LabelFontSize( ): Number
		{
			// Размер шрифта текстовой метки.
			return this._LabelFontSize;
		} // LabelFontSize
		
		// Set-метод установки ширины.
		// Параметры:
		// parWidth - ширина.
		override public function set width( parWidth: Number): void
		{
			// Ширина.
			super.width = parWidth;
			// Размер шрифта текстового формата текстовой метки.
			this._LabelTextFormat.size = this._LabelFontSize;
			// Установка текстового формата текстовой метки.
			this.SetLabelTextFormat( );			
		} // width
		
		// Set-метод установки высоты.
		// Параметры:
		// parHeight - высота.
		override public function set height( parHeight: Number): void
		{
			// Высота.
			super.height = parHeight;
			// Размер шрифта текстового формата текстовой метки.
			this._LabelTextFormat.size = this._LabelFontSize;
			// Установка текстового формата текстовой метки.
			this.SetLabelTextFormat( );			
		} // height
		
		// Get-метод получения текстового формата текстовой метки.
		// Результат: текстовый формат текстовой метки.
		public function get LabelTextFormat( ): TextFormat
		{
			// Текстовый формат текстовой метки.
			return this._LabelTextFormat;
		} // LabelTextFormat		
		
		// Get-метод получения светлого цвета шрифта текстовой метки.
		// Результат: светлый цвет шрифта текстовой метки.
		public function get LabelFontLightColor( ): uint
		{
			// Светлый цвет шрифта текстовой метки.
			return this._LabelFontLightColor;
		} // LabelFontLightColor
		
		// Get-метод получения тёмного цвета шрифта текстовой метки.
		// Результат: тёмный цвет шрифта текстовой метки.
		public function get LabelFontDarkColor( ): uint
		{
			// Тёмный цвет шрифта текстовой метки.
			return this._LabelFontDarkColor;
		} // LabelFontDarkColor
		
		// Get-метод получения признака жирности шрифта текстовой метки.
		// Результат: признак жирности шрифта текстовой метки.
		public function get LabelFontIsBold( ): Boolean
		{
			// Признак жирности шрифта текстовой метки.
			return this._LabelFontIsBold;
		} // LabelFontIsBold	
		
		// Get-метод получения признака курсивного нечертания
		// шрифта текстовой метки.
		// Результат: признак курсивного нечертания шрифта текстовой метки.
		public function get LabelFontIsItalic( ): Boolean
		{
			// Признак курсивного нечертания шрифта текстовой метки.
			return this._LabelFontIsItalic;
		} // LabelFontIsItalic
		
		// Get-метод получения признака подчёркнутого нечертания
		// шрифта текстовой метки.
		// Результат: признак подчёркнутого нечертания шрифта текстовой метки.
		public function get LabelFontIsUnderline( ): Boolean
		{
			// Признак подчёркнутого нечертания шрифта текстовой метки.
			return this._LabelFontIsUnderline;
		} // LabelFontIsUnderline
		
		// Get-метод получения цвета свечения в шестнадцатеричном формате.
		public function get GlowColor( ): uint
		{
			// Цвет свечения в шестнадцатеричном формате.
			return this._GlowColor;
		} // GlowColor
	} // GlowButton
} // nijanus.display