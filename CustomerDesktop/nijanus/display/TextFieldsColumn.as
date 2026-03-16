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
	import flash.display.Sprite;
	//-------------------------------------------------------------------------

	// Класс столбца текстовых полей.
	public class TextFieldsColumn extends Sprite
	{
		// Список импортированных классов из других пакетов.
		
		import flash.geom.Rectangle;
		import flash.text.TextField;
		import flash.text.TextFieldType;
		import flash.text.TextFormat;
		//-----------------------------------------------------------------------
		// Статические константы.
		
		// Высота ячейки по умолчанию.
		public static const CELL_DEFAULT_HEIGHT: Number = 20;
		//-----------------------------------------------------------------------
		// Переменные экземпляра класса.
		
		// Имя.
		private var _Name:       String = "";
		// Массив ячеек текстовых полей.
		private var _Cells:      Array  = null;
		// Высота ячейки: если она определена, то все ячейки имеют такую высоту,
		// иначе высота ячеек может быть разной.
		private var _CellHeight: Number = TextFieldsColumn.CELL_DEFAULT_HEIGHT;
		
		// Значение альфа-прозрачности ячеек.
		private var _CellsAlpha:                Number     = 1;
		// Признак выделения ячеек серым цветом при отсутствии фокуса.
		private var _AlwaysShowCellsSelections: Boolean    = false;	
		// Признак использования фоновой заливки в ячейках.
		private var _CellsHaveBackground:       Boolean    = false;
		// Цвет фона ячеек.
		private var _CellsBackgroundColor:      uint       = 0xFFFFFF;
		// Признак наличия рамки у ячеек.
		private var _CellsHaveBorder:           Boolean    = false;
		// Цвет рамки ячеек.
		private var _CellsBorderColor:          uint       = 0x000000;
		// Формат текста ячеек по умолчанию.
		private var _CellsDefaultTextFormat:    TextFormat = new TextFormat( );		
		// Индексированный массив фильтров ячеек.
		private var _CellsFilters:              Array      = null;		
		// Признак получения сообщений мыши ячейками.
		private var _CellsMouseEnabled:         Boolean    = true;
		// Признак выполнения автоматической прокрути
		// многострочных текстовых полей ячеек при вращении колёски мыши.
		private var _CellsMouseWheelEnabled:    Boolean    = true;	
		// Признак многострочности текстовыйх полей ячеек.
		private var _CellsAreMultiline:         Boolean    = false;	
		// Признак наличия возможности выборра текстовыйх полей ячеек.
		private var _CellsAreSelectable:        Boolean    = true;	
		// Признак влючения ячеек в последовательность перехода
		// с помощью клавиши Tab.
		private var _CellsTabEnabled:           Boolean    = false;
		// Цвет текста в текстовых полях ячеек.
		private var _CellsTextColor:            uint       = 0x000000;
		// Тип текстовых полей ячеек.
		private var _CellsType:                 String = TextFieldType.DYNAMIC;
		// Признак видимости ячеек.
		private var _CellsAreVisible:           Boolean    = true;
		// Признак применения переноса по словам к текстовым полям ячеек.
		private var _CellsHaveWordWrap:         Boolean    = false;		
		//-----------------------------------------------------------------------	
		// Методы экземпляра класса.
		
		// Метод установки свойств.
		// Параметры:
		// parProperties - свойств столбца текстовых полей.
		public function SetProperties
			( parProperties: TextFieldsColumnProperties ): void
		{
			// Высота ячейки.
			this._CellHeight                = parProperties.CellHeight;			
			// Значение альфа-прозрачности ячеек.
			this._CellsAlpha                = parProperties.CellsAlpha;
			// Признак выделения ячеек серым цветом при отсутствии фокуса.
			this._AlwaysShowCellsSelections =
				parProperties.AlwaysShowCellsSelections;
			// Признак использования фоновой заливки в ячейках.
			this._CellsHaveBackground       = parProperties.CellsHaveBackground;
			// Цвет фона ячеек.
			this._CellsBackgroundColor      = parProperties.CellsBackgroundColor;
			// Признак наличия рамки у ячеек.
			this._CellsHaveBorder           = parProperties.CellsHaveBorder;
			// Цвет рамки ячеек.
			this._CellsBorderColor          = parProperties.CellsBorderColor;
			// Формат текста ячеек по умолчанию.
			this._CellsDefaultTextFormat    = parProperties.CellsDefaultTextFormat;		
			// Индексированный массив фильтров ячеек.
			this._CellsFilters              = parProperties.CellsFilters;		
			// Признак получения сообщений мыши ячейками.
			this._CellsMouseEnabled         = parProperties.CellsMouseEnabled;
			// Признак выполнения автоматической прокрути
			// многострочных текстовых полей ячеек при вращении колёски мыши.
			this._CellsMouseWheelEnabled    = parProperties.CellsMouseWheelEnabled;	
			// Признак многострочности текстовыйх полей ячеек.
			this._CellsAreMultiline         = parProperties.CellsAreMultiline;	
			// Признак наличия возможности выборра текстовыйх полей ячеек.
			this._CellsAreSelectable        = parProperties.CellsAreSelectable;	
			// Признак влючения ячеек в последовательность перехода
			// с помощью клавиши Tab.
			this._CellsTabEnabled           = parProperties.CellsTabEnabled;
			// Цвет текста в текстовых полях ячеек.
			this._CellsTextColor            = parProperties.CellsTextColor;
			// Тип текстовых полей ячеек.
			this._CellsType                 = parProperties.CellsType;
			// Признак видимости ячеек.
			this._CellsAreVisible           = parProperties.CellsAreVisible;
			// Признак применения переноса по словам к текстовым полям ячеек.
			this._CellsHaveWordWrap         = parProperties.CellsHaveWordWrap;			
		
			// Если есть ячейки.
			if ( this._Cells != null )				
				// Просмотр всех ячеек.
				for ( var cellIndex: uint = 0; cellIndex < this._Cells.length;
						cellIndex++ )
					// Если существует текущая ячейка.
					if ( this._Cells[ cellIndex ] != null )
					{
						// Установка высоты текущей ячейки.
						this._Cells[ cellIndex ].height  = parProperties.CellHeight;
						// Ордината текущей ячейки:
						// произведение высоты текущей ячейки и её индекса.
						this._Cells[ cellIndex ].y                   =
							parProperties.CellHeight * cellIndex;
						// Установка альфа-прозрачности текущей ячейки.
						this._Cells[ cellIndex ].alpha   = parProperties.CellsAlpha;
						// Установка признака выделения текущей ячейки
						// серым цветом при отсутствии фокуса.					
						this._Cells[ cellIndex ].alwaysShowSelection =
							parProperties.AlwaysShowCellsSelections;
						// Установка признака использования
						// фоновой заливки в текущей ячейке.
						this._Cells[ cellIndex ].background          =
							parProperties.CellsHaveBackground;
						// Установка цвета фона текущей ячейки.
						this._Cells[ cellIndex ].backgroundColor     =
							parProperties.CellsBackgroundColor;
						// Установка признака наличия рамки у текущей ячейки.
						this._Cells[ cellIndex ].border  = parProperties.CellsHaveBorder;						
						// Установка цвета рамки текущей ячейки.
						this._Cells[ cellIndex ].borderColor         =
							parProperties.CellsBorderColor;
						// Установка формата текста текущей ячейки по умолчанию.
						this._Cells[ cellIndex ].defaultTextFormat   =
							parProperties.CellsDefaultTextFormat;
						// Установка индексированного массива фильтров текущей ячейки.
						this._Cells[ cellIndex ].filters = parProperties.CellsFilters;
						// Установка признака получения сообщений мыши текущей ячейкой.
						this._Cells[ cellIndex ].mouseEnabled        =
							parProperties.CellsMouseEnabled;
						// Установка признака выполнения автоматической прокрути
						// многострочного текстового поля текущей ячейки
						// при вращении колёски мыши.
						this._Cells[ cellIndex ].mouseWheelEnabled   =
							parProperties.CellsMouseWheelEnabled;
						// Установка признака многострочности
						// текстового поля текущей ячейки.
						this._Cells[ cellIndex ].multiline           =
							parProperties.CellsAreMultiline;
						// Установка признака наличия возможности выборра
						// текстового поля текущей ячейки.
						this._Cells[ cellIndex ].selectable          =
							parProperties.CellsAreSelectable;	
						// Установка признака влючения текущей ячейки
						// в последовательность перехода с помощью клавиши Tab.
						this._Cells[ cellIndex ].tabEnabled          =
							parProperties.CellsTabEnabled;
						// Установка цвета текста в текстовом поле текущей ячейки.
						this._Cells[ cellIndex ].textColor           =
							parProperties.CellsTextColor;					
						// Установка типа текстового поля текущей ячейки.
						this._Cells[ cellIndex ].type    = parProperties.CellsType;	
						// Установка признака видимости текущей ячейки.
						this._Cells[ cellIndex ].visible = parProperties.CellsAreVisible;
						// Установка признака применения переноса по словам
						// к текстовому полю текущей ячейки.
						this._Cells[ cellIndex ].wordWrap            =
							parProperties.CellsHaveWordWrap;				
					} // if
		} // SetProperties
		
		// Метод получения ячейки по заданному индексу.
		// Параметры:
		// parCellIndex - индекс ячейки.
		// Результат: текстовое поле ячейки по заданному индексу.
		public function GetCell( parCellIndex: uint ): TextField		
		{			
			// Если нет ячеек или заданный индекс находится
			// вне пределов индекса ячейки.
			if
			(
				( this._Cells  == null ) ||
				( parCellIndex >= this._Cells.length )
			)
				// Ячейка с заданным индексом не существует.
				return null;
			// Если заданный индекс находится в пределах индекса ячейки.
			else
				// Ячейка по заданному индексу.
				return this._Cells[ parCellIndex ];
		} // GetCell
		
		// Метод установки ячейки по заданному индексу.
		// Параметры:
		// parCellIndex     - индекс ячейки,
		// parCellTextField - текстовое поле ячейки.
		public function SetCell
		(
			parCellIndex:     uint,
			parCellTextField: TextField
		): void		
		{
			// Если нет ячеек или заданный индекс находится
			// вне пределов индекса ячейки.
			if
			(
				( this._Cells  == null ) ||
				( parCellIndex >= this._Cells.length )
			)
				// Ячейка с заданным индексом не существует и ничего не изменяется.
				return;
			// Если заданный индекс находится в пределах индекса ячейки.
			else
			{
				// Ордината ячейки.
				var cellY:     Number = this._Cells[ parCellIndex ].y;
				// Высота ячейки.
				var cellHeigh: Number = this._Cells[ parCellIndex ].height;
				
				// Удаление текстового поля ячейки из столбца текстовых полей.
				this.removeChild( this._Cells[ parCellIndex ] );				
				// Установка ячейки по заданному индексу.
				this._Cells[ parCellIndex ] = parCellTextField;
				// Добавление текстового поля ячейки в столбец текстовых полей.
				this.addChild( this._Cells[ parCellIndex ] );
			
				// Абсцисса ячейки - абсцисса столбца текстовых полей.
				this._Cells[ parCellIndex ].x      = this.x;
				// Ордината ячейки - прежняя.
				this._Cells[ parCellIndex ].y      = cellY;
				// Ширина ячейки   - ширина столбца текстовых полей.
				this._Cells[ parCellIndex ].width  = this.scrollRect.width;
				// Высота ячейки   - прежняя.
				this._Cells[ parCellIndex ].height = cellHeigh;
			} // else
		} // SetCell
		
		// Метод получения строки, представляющей текущий текст
		// в текстовом поле ячейки.
		// Параметры:
		// parCellIndex - индекс ячейки.
		// Результат: строка, представляющая текущий текст
		// в текстовом поле ячейки.
		public function GetCellText( parCellIndex: uint ): String		
		{
			// Если нет ячеек или заданный индекс находится
			// вне пределов индекса ячейки.
			if
			(
				( this._Cells  == null ) ||
				( parCellIndex >= this._Cells.length )
			)
				// Ячейка с заданным индексом не существует.
				return null;
			// Если заданный индекс находится в пределах индекса ячейки.
			else
				// строка, представляющая текущий текст в текстовом поле ячейки.
				return this._Cells[ parCellIndex ].text;
		} // GetCellText	
		
		// Метод установки строки, представляющей текущий текст
		// в текстовом поле ячейки.
		// Параметры:
		// parCellIndex - индекс ячейки,
		// parCellText  - строка, представляющая текущий текст
		// в текстовом поле ячейки.
		public function SetCellText
		(
			parCellIndex: uint,
			parCellText:  String
		): void		
		{
			// Если нет ячеек или заданный индекс находится
			// вне пределов индекса ячейки.
			if
			(
				( this._Cells  == null ) ||
				( parCellIndex >= this._Cells.length )
			)
				// Ячейка с заданным индексом не существует и ничего не изменяется.
				return;
			// Если заданный индекс находится в пределах индекса ячейки.
			else
				// Установка строки, представляющей текущий текст
				// в текстовом поле ячейки.
				this._Cells[ parCellIndex ].text = parCellText;
		} // SetCellText
		
		// Метод получения текстового поля, стилизованного,
		// согласно свойствам ячеек.
		// Результат: текстовое поле, стилизованное, согласно свойствам ячеек.
		public function GetCellStyledTextField( ): TextField		
		{
			// Текстовое поле, стилизованное, согласно свойствам ячеек.
			var cellStyledTextField: TextField = new TextField( );
			
			// Значение альфа-прозрачности ячеек.
			cellStyledTextField.alpha               = this._CellsAlpha;
			// Признак выделения ячеек серым цветом при отсутствии фокуса.
			cellStyledTextField.alwaysShowSelection =
				this._AlwaysShowCellsSelections;
			// Признак использования фоновой заливки в ячейках.
			cellStyledTextField.background          = this._CellsHaveBackground;
			// Цвет фона ячеек.
			cellStyledTextField.backgroundColor     = this._CellsBackgroundColor;
			// Признак наличия рамки у ячеек.
			cellStyledTextField.border              = this._CellsHaveBorder;
			// Цвет рамки ячеек.
			cellStyledTextField.borderColor         = this._CellsBorderColor;
			// Индексированный массив фильтров ячеек.
			cellStyledTextField.filters             = this._CellsFilters;
			// Признак получения сообщений мыши ячейками.
			cellStyledTextField.mouseEnabled        = this._CellsMouseEnabled;
			// Признак выполнения автоматической прокрути
			// многострочных текстовых полей ячеек при вращении колёски мыши.
			cellStyledTextField.mouseWheelEnabled   = this._CellsMouseWheelEnabled;
			// Признак многострочности текстовыйх полей ячеек.
			cellStyledTextField.multiline           = this._CellsAreMultiline;	
			// Признак наличия возможности выборра текстовыйх полей ячеек.
			cellStyledTextField.selectable          = this._CellsAreSelectable;
			// Признак влючения ячеек в последовательность перехода
			// с помощью клавиши Tab.
			cellStyledTextField.tabEnabled          = this._CellsTabEnabled;
			// Цвет текста в текстовых полях ячеек.
			cellStyledTextField.textColor           = this._CellsTextColor;
			// Тип текстовых полей ячеек.
			cellStyledTextField.type                = this._CellsType;
			// Признак видимости ячеек.
			cellStyledTextField.visible             = this._CellsAreVisible;
			// Признак применения переноса по словам к текстовым полям ячеек.
			cellStyledTextField.wordWrap            = this._CellsHaveWordWrap;
			
			// Формат текста ячеек по умолчанию.
			cellStyledTextField.defaultTextFormat =
				new TextFormat
				(
					this._CellsDefaultTextFormat.font,
					this._CellsDefaultTextFormat.size,
					this._CellsDefaultTextFormat.color,
					this._CellsDefaultTextFormat.bold,
					this._CellsDefaultTextFormat.italic,
					this._CellsDefaultTextFormat.underline,
					this._CellsDefaultTextFormat.url,
					this._CellsDefaultTextFormat.target,
					this._CellsDefaultTextFormat.align,
					this._CellsDefaultTextFormat.leftMargin,
					this._CellsDefaultTextFormat.rightMargin,
					this._CellsDefaultTextFormat.indent,
					this._CellsDefaultTextFormat.leading
				); // new TextFormat			
			// Абсцисса ячейки - абсцисса столбца текстовых полей.
			cellStyledTextField.x                 = this.x;
			// Ширина ячейки   - ширина столбца текстовых полей.
			cellStyledTextField.width             = this.scrollRect.width;
			
			// Если определена высота ячейки.
			if ( ! isNaN( this._CellHeight ) )
				// Установка высоты ячейки.
				cellStyledTextField.height = this._CellHeight;	
			// Если неопределена высота ячейки.
			else
				// Установка высоты ячейки по умолчанию.
				cellStyledTextField.height = TextFieldsColumn.CELL_DEFAULT_HEIGHT;		
		
			// Текстовое поле, стилизованное, согласно свойствам ячеек.
			return cellStyledTextField;
		} // GetCellStyleTextField		
		
		// Метод добавления текстового поля ячейки в конец массива ячеек.
		// Параметры:
		// parCellTextField - текстовое поле ячейки.
		public function AddCell( parCellTextField: TextField ): void		
		{
			// Ордината добавляемой ячейки.
			var cellY: Number = 0;	
			
			// Если нет ячеек.
			if ( this._Cells == null )
				// Создание ячеек.
				this._Cells = new Array( );
			
			// Просмотр всех ячеек.
			for ( var cellIndex: uint = 0; cellIndex < this._Cells.length;
					cellIndex++ )
				// Если существует текущая ячейка.
				if ( this._Cells[ cellIndex ] != null )
					// Ордината добавляемой ячейки - сумма высот существующих ячеек,
					// расположенных последовательно друг под другом,
					// начиная от верхней грани столбца текстовых полей.
					cellY += this._Cells[ cellIndex ].height;
				
			// Добавление текстового поля ячейки в столбец текстовых полей.
			this.addChild( parCellTextField );
			// Добавление текстового поля ячейки в конец массива ячеек.
			this._Cells.push( parCellTextField );
			
			// Абсцисса текстового поля ячейки - абсцисса столбца текстовых полей.
			parCellTextField.x     = this.x;
			// Ордината текстового поля ячейки.
			parCellTextField.y     = cellY;
			// Ширина ячейки -  ширина столбца текстовых полей.
			parCellTextField.width = this.scrollRect.width;
			// Если определена высота ячейки, то она устанавливается.
			if ( ! isNaN( this._CellHeight ) )
				parCellTextField.height = this._CellHeight;
		} // AddCell
		
		// Метод добавления текстового поля ячейки с заданным текстом
		// в конец массива ячеек.
		// Параметры:
		// parCellText - текст текстового поля ячейки.
		public function AddCellText( parCellText: String ): void		
		{
			// Текстовое поле, стилизованное, согласно свойствам ячеек.
			var cellStyledTextField: TextField = this.GetCellStyledTextField( );
			// Запись текста текстового поля ячейки, стилизованного,
			// согласно свойствам ячеек.
			cellStyledTextField.text           = parCellText;			
			// Добавление текстового поля ячейки, стилизованного,
			// согласно свойствам ячеек, в конец массива ячеек.
			this.AddCell( cellStyledTextField );
		} // AddCellText		
		
		// Метод добавления пустого текстового поля ячейки в конец массива ячеек.
		public function AddEmptyCell( ): void		
		{
			// Текстовое поле, стилизованное, согласно свойствам ячеек.
			var cellStyledTextField: TextField = this.GetCellStyledTextField( );
			// Добавление текстового поля ячейки, стилизованного,
			// согласно свойствам ячеек, в конец массива ячеек.
			this.AddCell( cellStyledTextField );
		} // AddEmptyCell		
		
		// Метод добавления текстового поля ячейки по заданному индексу.
		// Параметры:
		// parCellIndex     - индекс ячейки,
		// parCellTextField - текстовое поле ячейки.
		public function AddCellAt
		(
			parCellIndex:     uint,
			parCellTextField: TextField
		): void
		{
			// Если нет ячеек.
			if ( this._Cells == null )
				// Создание ячеек.
				this._Cells = new Array( );
				
			// Если заданный индекс превышает индекс последней ячейки.
			if ( parCellIndex >= this._Cells.length )
				// Добавления текстового поля ячейки в конец массива ячеек.
				this.AddCell( parCellTextField );
			
			// Абсцисса текстового поля ячейки - абсцисса столбца текстовых полей.
			parCellTextField.x     = this.x;
			// Ордината текстового поля ячейки - ордината ячейки,
			// в натоящий момент записаной по заданному индексу.
			parCellTextField.y     = this._Cells[ parCellIndex ].y;
			// Ширина ячейки -  ширина столбца текстовых полей.
			parCellTextField.width = this.scrollRect.width;
			// Если определена высота ячейки, то она устанавливается.
			if ( ! isNaN( this._CellHeight ) )
				parCellTextField.height = this._CellHeight;				
				
			// Добавление текстового поля ячейки в столбец текстовых полей.
			this.addChild( parCellTextField );
			// Добавление текстового поля ячейки в массива ячеек
			// по заданному индексу.
			this._Cells.splice( parCellIndex, 0, parCellTextField );				
	
			// Просмотр всех ячеек после добавленной.
			for ( var cellIndex: uint = parCellIndex + 1; cellIndex <
					this._Cells.length; cellIndex++ )			
				// Если существует текущая ячейка.
				if ( this._Cells[ cellIndex ] != null )
					// Ордината текущей ячейки увеличивается
					// на значение высоты добавленной ячейки.
					this._Cells[ cellIndex ].y += parCellTextField.height;
		} // AddCellAt		
		
		// Метод добавления текстового поля ячейки с заданным текстом
		// по заданному индексу.
		// Параметры:
		// parCellIndex - индекс ячейки,
		// parCellText  - текст текстового поля ячейки.
		public function AddCellTextAt
		(
			parCellIndex: uint,
			parCellText:  String
		): void		
		{
			// Текстовое поле, стилизованное, согласно свойствам ячеек.
			var cellStyledTextField: TextField = this.GetCellStyledTextField( );
			// Запись текста текстового поля ячейки, стилизованного,
			// согласно свойствам ячеек.
			cellStyledTextField.text           = parCellText;			
			// Добавление текстового поля ячейки, стилизованного,
			// согласно свойствам ячеек, по заданному индексу.
			this.AddCellAt( parCellIndex, cellStyledTextField );
		} // AddCellTextAt
		
		// Метод удаления ячейки с заданным индексом.
		// Параметры:
		// parCellIndex - индекс ячейки.
		public function RemoveCellAt( parCellIndex: uint ): void
		{
			// Если нет ячеек или заданный индекс находится
			// вне пределов индекса ячейки.
			if
			(
				( this._Cells  == null ) ||
				( parCellIndex >= this._Cells.length )
			)
				// Ничего не удаляется.
				return;
			
			// Просмотр всех ячеек после удаляемой.
			for ( var cellIndex: uint = parCellIndex + 1; cellIndex <
					this._Cells.length; cellIndex++ )	
				// Если существует текущая ячейка.
				if ( this._Cells[ cellIndex ] != null )
					// Ордината текущей ячейки уменьшается
					// на значение высоты удаляемой ячейки.
					this._Cells[ cellIndex ].y -= this._Cells[ parCellIndex ].height;
					
			// Удаление текстового поля ячейки из столбца текстовых полей.
			this.removeChild( this._Cells[ parCellIndex ] );
			// Удаление текстового поля ячейки из массива ячеек
			// по заданному индексу.
			this._Cells.splice( parCellIndex, 1 );					
		} // RemoveCellAt		
		//-----------------------------------------------------------------------		
		// Методы-конструкторы.
		
		// Метод-конструктор экземпляра столбца текстовых полей.
		// Параметры:
		// parName          - имя столбца текстовых полей,
		// parAreaRectangle - прямоугольная область столбца текстовых полей.
		public function TextFieldsColumn
		(
		 	parName:          String,
			parAreaRectangle: Rectangle
		): void
		{
			// Вызов метода-конструктора суперкласса Sprite.
			super( );			
			
			// Имя      столбца текстовых полей.
			this._Name      = parName;
			// Абсцисса столбца текстовых полей.
			this.x          = parAreaRectangle.x;
			// Ордината столбца текстовых полей.
			this.y          = parAreaRectangle.y;
			// Определение прямоугольной области прокрутки столбца текстовых полей.
			this.scrollRect = parAreaRectangle;			
		} // TextFieldsColumn
		//-----------------------------------------------------------------------
		// Get- и set-методы.
		
		// Get-метод получения ширины.
		// Результат: ширина.
		override public function get width( ): Number
		{
			// Ширина прямоугольной области прокрутки столбца текстовых полей.
			return this.scrollRect.width;
		} // width
		
		// Set-метод установки ширины.
		// parWidth - ширина.
		override public function set width( parWidth: Number ): void
		{
			// Если ширина не изменилась, ничего не меняется.
			if ( this.scrollRect.width == parWidth )
				return;			
			// Прямоугольная область прокрутки столбца текстовых полей.
			this.scrollRect = new Rectangle( this.scrollRect.x, this.scrollRect.y,
				parWidth, this.scrollRect.height );
			
			// Если есть ячейки.
			if ( this._Cells != null )				
				// Просмотр всех ячеек.
				for ( var cellIndex: uint = 0; cellIndex < this._Cells.length;
						cellIndex++ )
					// Если существует текущая ячейка.
					if ( this._Cells[ cellIndex ] != null )
						// Установка ширины текущей ячейки.
						this._Cells[ cellIndex ].width = parWidth;		
		} // width
		
		// Get-метод получения высоты.
		// Результат: высота.
		override public function get height( ): Number
		{
			// Высота прямоугольной области прокрутки столбца текстовых полей.
			return this.scrollRect.height;
		} // height		
		
		// Set-метод установки высоты.
		// parHeight - высота.
		override public function set height( parHeight: Number ): void
		{
			// Если высота не изменилась, ничего не меняется.
			if ( this.scrollRect.height == parHeight )
				return;			
			// Прямоугольная область прокрутки столбца текстовых полей.
			this.scrollRect = new Rectangle( this.scrollRect.x, this.scrollRect.y,
				this.scrollRect.width, parHeight );
		} // height		
		
		// Get-метод получения имени.
		// Результат: имя.
		public function get Name( ): String
		{
			// Имя.
			return this._Name;
		} // Name

		// Set-метод установки имени.
		// Параметры:
		// parName - имя.
		public function set Name( parName: String ): void
		{
			// Имя.
			this._Name = parName;
		} // Name			
		
		// Get-метод получения высоты ячейки.
		// Результат: высота ячейки.
		public function get CellHeight( ): Number
		{
			// Высота ячейки.
			return this._CellHeight;
		} // CellHeight

		// Set-метод установки высоты ячейки.
		// Параметры:
		// parCellHeight - высота ячейки.
		public function set CellHeight( parCellHeight: Number ): void
		{
			// Если высота ячейки не изменилась, ничего не меняется.
			if ( this._CellHeight == parCellHeight )
				return;
			
			// Высота ячейки.
			this._CellHeight = parCellHeight;
			
			// Если высота ячейки определена и вообще есть ячейки.
			if ( ( ! isNaN( parCellHeight ) )	&& ( this._Cells != null ) )	
				// Просмотр всех ячеек.
				for ( var cellIndex: uint = 0; cellIndex < this._Cells.length;
						cellIndex++ )
					// Если существует текущая ячейка.
					if ( this._Cells[ cellIndex ] != null )
					{
						// Установка высоты текущей ячейки.
						this._Cells[ cellIndex ].height = parCellHeight;
						// Ордината текущей ячейки:
						// произведение высоты текущей ячейки и её индекса.
						this._Cells[ cellIndex ].y      = parCellHeight * cellIndex;
					} // if
		} // CellHeight	
		
		// Get-метод получения количества ячеек.
		// Результат: количество ячеек.
		public function get CellsCount( ): uint
		{
			// Количество ячеек - количество элементов массива.
			return this._Cells.length;
		} // CellsCount
		
		// Set-метод установки количества ячеек.
		// Параметры:
		// parCellsCount - количество ячеек.
		public function set CellsCount( parCellsCount: uint ): void
		{
			// Если нет ячеек.
			if ( this._Cells == null )
				// Создание ячеек.
				this._Cells = new Array( );			
			
			// Если количество ячеек не изменилось, ничего не меняется.
			if ( this._Cells.length == parCellsCount )
				return;
				
			// Индекс ячейки.
			var cellIndex: uint;
				
			// Если количество ячеек уменьшилось.
			if ( this._Cells.length > parCellsCount )
			{				
				// Просмотр ячеек, начиная с первой, которую надо удалить.
				for ( cellIndex = parCellsCount; cellIndex < this._Cells.length;
						cellIndex++ )
					// Если существует текущая ячейка.
					if ( this._Cells[ cellIndex ] != null )
						// Удаление текстового поля ячейки из столбца текстовых полей.
						this.removeChild( this._Cells[ cellIndex ] );
						
				// Удаление последних текстовых полей ячеек из массива ячеек.
				this._Cells.splice( parCellsCount,
					this._Cells.length - parCellsCount );
			} // if
			
			// Если количество ячеек увеличилось.
			else
				// Просмотр ячеек, начиная с первой, которую надо добавить.
				for ( cellIndex = this._Cells.length; cellIndex < parCellsCount;
						cellIndex++ )
					// Добавление пустого текстового поля ячейки в конец массива ячеек.
					this.AddEmptyCell( );
		} // CellsCount	

		// Get-метод получения значения альфа-прозрачности ячеек.
		// Результат: значение альфа-прозрачности ячеек.
		public function get CellsAlpha( ): Number
		{
			// Значение альфа-прозрачности ячеек.
			return this._CellsAlpha;
		} // CellsAlpha

		// Set-метод установки значения альфа-прозрачности ячеек.
		// Параметры:
		// parCellsAlpha - значение альфа-прозрачности ячеек.
		public function set CellsAlpha( parCellsAlpha: Number ): void
		{
			// Если значение альфа-прозрачности ячеек не изменилась,
			// ничего не меняется.
			if ( this._CellsAlpha == parCellsAlpha )
				return;			
			
			// Значение альфа-прозрачности ячеек.
			this._CellsAlpha = parCellsAlpha;
			
			// Если есть ячейки.
			if ( this._Cells != null )				
				// Просмотр всех ячеек.
				for ( var cellIndex: uint = 0; cellIndex < this._Cells.length;
						cellIndex++ )
					// Если существует текущая ячейка.
					if ( this._Cells[ cellIndex ] != null )
						// Установка альфа-прозрачности текущей ячейки.
						this._Cells[ cellIndex ].alpha = parCellsAlpha;		
		} // CellsAlpha
		
		// Get-метод получения признака выделения ячеек
		// серым цветом при отсутствии фокуса.
		// Результат: признак выделения ячеек серым цветом при отсутствии фокуса.
		public function get AlwaysShowCellsSelections( ): Boolean
		{
			// Признак выделения ячеек серым цветом при отсутствии фокуса.
			return this._AlwaysShowCellsSelections;
		} // AlwaysShowCellsSelections

		// Set-метод установки признака выделения ячеек
		// серым цветом при отсутствии фокуса.
		// Параметры:
		// parAlwaysShowCellsSelections - признак выделения ячеек
		// серым цветом при отсутствии фокуса.
		public function set AlwaysShowCellsSelections
			( parAlwaysShowCellsSelections: Boolean ): void
		{
			// Если признак выделения ячеек серым цветом при отсутствии фокуса
			// не изменилось, ничего не меняется.
			if ( this._AlwaysShowCellsSelections == parAlwaysShowCellsSelections )
				return;			
			
			// Признак выделения ячеек серым цветом при отсутствии фокуса.
			this._AlwaysShowCellsSelections = parAlwaysShowCellsSelections;
			
			// Если есть ячейки.
			if ( this._Cells != null )				
				// Просмотр всех ячеек.
				for ( var cellIndex: uint = 0; cellIndex < this._Cells.length;
						cellIndex++ )
					// Если существует текущая ячейка.
					if ( this._Cells[ cellIndex ] != null )
						// Установка признака выделения текущей ячейки
						// серым цветом при отсутствии фокуса.					
						this._Cells[ cellIndex ].alwaysShowSelection =
							parAlwaysShowCellsSelections;		
		} // AlwaysShowCellsSelections
		
		// Get-метод получения признака использования фоновой заливки в ячейках.
		// Результат: признак использования фоновой заливки в ячейках.
		public function get CellsHaveBackground( ): Boolean
		{
			// Признак использования фоновой заливки в ячейках.
			return this._CellsHaveBackground;
		} // CellsHaveBackground

		// Set-метод установки признака использования фоновой заливки в ячейках.
		// Параметры:
		// parCellsHaveBackground - признак использования
		// фоновой заливки в ячейках.
		public function set CellsHaveBackground
			( parCellsHaveBackground: Boolean ): void
		{
			// Если признак использования фоновой заливки в ячейках не изменился,
			// ничего не меняется.
			if ( this._CellsHaveBackground == parCellsHaveBackground )
				return;			
			
			// Признак использования фоновой заливки в ячейках.
			this._CellsHaveBackground = parCellsHaveBackground;
			
			// Если есть ячейки.
			if ( this._Cells != null )				
				// Просмотр всех ячеек.
				for ( var cellIndex: uint = 0; cellIndex < this._Cells.length;
						cellIndex++ )
					// Если существует текущая ячейка.
					if ( this._Cells[ cellIndex ] != null )
						// Установка признака использования
						// фоновой заливки в текущей ячейке.
						this._Cells[ cellIndex ].background = parCellsHaveBackground;
		} // CellsHaveBackground
		
		// Get-метод получения цвета фона ячеек.
		// Результат: цвет фона ячеек.
		public function get CellsBackgroundColor( ): uint
		{
			// Цвет фона ячеек.
			return this._CellsBackgroundColor;
		} // CellsBackgroundColor

		// Set-метод установки цвета фона ячеек.
		// Параметры:
		// parCellsBackgroundColor - цвет фона ячеек.
		public function set CellsBackgroundColor
			( parCellsBackgroundColor: uint ): void
		{
			// Если цвет фона ячеек не изменился, ничего не меняется.
			if ( this._CellsBackgroundColor == parCellsBackgroundColor )
				return;			
			
			// Цвет фона ячеек.
			this._CellsBackgroundColor = parCellsBackgroundColor;
			
			// Если есть ячейки.
			if ( this._Cells != null )				
				// Просмотр всех ячеек.
				for ( var cellIndex: uint = 0; cellIndex < this._Cells.length;
						cellIndex++ )
					// Если существует текущая ячейка.
					if ( this._Cells[ cellIndex ] != null )
						// Установка цвета фона текущей ячейки.
						this._Cells[ cellIndex ].backgroundColor =
							parCellsBackgroundColor;
		} // CellsBackgroundColor
		
		// Get-метод получения признака наличия рамки у ячеек.
		// Результат: признак наличия рамки у ячеек.
		public function get CellsHaveBorder( ): Boolean
		{
			// Признак наличия рамки у ячеек.
			return this._CellsHaveBorder;
		} // CellsHaveBorder

		// Set-метод установки признака наличия рамки у ячеек.
		// Параметры:
		// parCellsHaveBorder - признак наличия рамки у ячеек.
		public function set CellsHaveBorder( parCellsHaveBorder: Boolean ): void
		{
			// Если признак наличия рамки у ячеек не изменился, ничего не меняется.
			if ( this._CellsHaveBorder == parCellsHaveBorder )
				return;			
			
			// Признак наличия рамки у ячеек.
			this._CellsHaveBorder = parCellsHaveBorder;
			
			// Если есть ячейки.
			if ( this._Cells != null )				
				// Просмотр всех ячеек.
				for ( var cellIndex: uint = 0; cellIndex < this._Cells.length;
						cellIndex++ )
					// Если существует текущая ячейка.
					if ( this._Cells[ cellIndex ] != null )
						// Установка признака наличия рамки у текущей ячейки.
						this._Cells[ cellIndex ].border = parCellsHaveBorder;
		} // CellsHaveBorder
		
		// Get-метод получения цвета рамки ячеек.
		// Результат: цвет рамки ячеек.
		public function get CellsBorderColor( ): uint
		{
			// Цвет рамки ячеек.
			return this._CellsBorderColor;
		} // CellsBorderColor

		// Set-метод установки цвета рамки ячеек.
		// Параметры:
		// parCellsBorderColor - цвет рамки ячеек.
		public function set CellsBorderColor
			( parCellsBorderColor: uint ): void
		{
			// Если цвет рамки ячеек не изменился, ничего не меняется.
			if ( this._CellsBorderColor == parCellsBorderColor )
				return;			
			
			// Цвет рамки ячеек.
			this._CellsBorderColor = parCellsBorderColor;
			
			// Если есть ячейки.
			if ( this._Cells != null )				
				// Просмотр всех ячеек.
				for ( var cellIndex: uint = 0; cellIndex < this._Cells.length;
						cellIndex++ )
					// Если существует текущая ячейка.
					if ( this._Cells[ cellIndex ] != null )
						// Установка цвета рамки текущей ячейки.
						this._Cells[ cellIndex ].borderColor = parCellsBorderColor;
		} // CellsBorderColor	
		
		// Get-метод получения формата текста ячеек по умолчанию.
		// Результат: формат текста ячеек по умолчанию.
		public function get CellsDefaultTextFormat( ): TextFormat
		{
			// Формат текста ячеек по умолчанию.
			return this._CellsDefaultTextFormat;
		} // CellsDefaultTextFormat

		// Set-метод установки формата текста ячеек по умолчанию.
		// Параметры:
		// parCellsDefaultTextFormat - формат текста ячеек по умолчанию.
		public function set CellsDefaultTextFormat
			( parCellsDefaultTextFormat: TextFormat ): void
		{
			// Если формат текста ячеек по умолчанию не изменился,
			// ничего не меняется.
			if ( this._CellsDefaultTextFormat == parCellsDefaultTextFormat )
				return;			
			
			// Формат текста ячеек по умолчанию.
			this._CellsDefaultTextFormat = parCellsDefaultTextFormat;
			
			// Если есть ячейки.
			if ( this._Cells != null )				
				// Просмотр всех ячеек.
				for ( var cellIndex: uint = 0; cellIndex < this._Cells.length;
						cellIndex++ )
					// Если существует текущая ячейка.
					if ( this._Cells[ cellIndex ] != null )
						// Установка формата текста текущей ячейки по умолчанию.
						this._Cells[ cellIndex ].defaultTextFormat =
							parCellsDefaultTextFormat;
		} // CellsDefaultTextFormat		
		
		// Get-метод получения индексированного массива фильтров ячеек.
		// Результат: индексированный массив фильтров ячеек.
		public function get CellsFilters( ): Array
		{
			// Индексированный массив фильтров ячеек.
			return this._CellsFilters;
		} // CellsFilters

		// Set-метод установки индексированного массива фильтров ячеек.
		// Параметры:
		// parCellsFilters - индексированный массив фильтров ячеек.
		public function set CellsFilters( parCellsFilters: Array ): void
		{
			// Если индексированный массив фильтров ячеек не изменился,
			// ничего не меняется.
			if ( this._CellsFilters == parCellsFilters )
				return;			
			
			// Индексированный массив фильтров ячеек.
			this._CellsFilters = parCellsFilters;
			
			// Если есть ячейки.
			if ( this._Cells != null )				
				// Просмотр всех ячеек.
				for ( var cellIndex: uint = 0; cellIndex < this._Cells.length;
						cellIndex++ )
					// Если существует текущая ячейка.
					if ( this._Cells[ cellIndex ] != null )
						// Установка индексированного массива фильтров текущей ячейки.
						this._Cells[ cellIndex ].filters = parCellsFilters;
		} // CellsFilters		
		
		// Get-метод получения признака получения сообщений мыши ячейками.
		// Результат: признак получения сообщений мыши ячейками.
		public function get CellsMouseEnabled( ): Boolean
		{
			// Признак получения сообщений мыши ячейками.
			return this._CellsMouseEnabled;
		} // CellsMouseEnabled

		// Set-метод установки признака получения сообщений мыши ячейками.
		// Параметры:
		// parCellsMouseEnabled - признак получения сообщений мыши ячейками.
		public function set CellsMouseEnabled
			( parCellsMouseEnabled: Boolean ): void
		{
			// Если признак получения сообщений мыши ячейками не изменился,
			// ничего не меняется.
			if ( this._CellsMouseEnabled == parCellsMouseEnabled )
				return;			
			
			// Признак получения сообщений мыши ячейками.
			this._CellsMouseEnabled = parCellsMouseEnabled;
			
			// Если есть ячейки.
			if ( this._Cells != null )				
				// Просмотр всех ячеек.
				for ( var cellIndex: uint = 0; cellIndex < this._Cells.length;
						cellIndex++ )
					// Если существует текущая ячейка.
					if ( this._Cells[ cellIndex ] != null )
						// Установка признака получения сообщений мыши текущей ячейкой.
						this._Cells[ cellIndex ].mouseEnabled = parCellsMouseEnabled;
		} // CellsMouseEnabled
		
		// Get-метод получения признака выполнения автоматической прокрути
		// многострочных текстовых полей ячеек при вращении колёски мыши.
		// Результат: признак выполнения автоматической прокрути
		// многострочных текстовых полей ячеек при вращении колёски мыши.
		public function get CellsMouseWheelEnabled( ): Boolean
		{
			// Признак выполнения автоматической прокрути
			// многострочных текстовых полей ячеек при вращении колёски мыши.
			return this._CellsMouseWheelEnabled;
		} // CellsMouseWheelEnabled

		// Set-метод установки признака выполнения автоматической прокрути
		// многострочных текстовых полей ячеек при вращении колёски мыши.
		// Параметры:
		// parCellsMouseWheelEnabled - признак выполнения автоматической прокрути
		// многострочных текстовых полей ячеек при вращении колёски мыши.
		public function set CellsMouseWheelEnabled
			( parCellsMouseWheelEnabled: Boolean ): void
		{
			// Если признак выполнения автоматической прокрути
			// многострочных текстовых полей ячеек при вращении колёски мыши
			// не изменился, ничего не меняется.
			if ( this._CellsMouseWheelEnabled == parCellsMouseWheelEnabled )
				return;				
			
			// Признак выполнения автоматической прокрути
			// многострочных текстовых полей ячеек при вращении колёски мыши.
			this._CellsMouseWheelEnabled = parCellsMouseWheelEnabled;
			
			// Если есть ячейки.
			if ( this._Cells != null )				
				// Просмотр всех ячеек.
				for ( var cellIndex: uint = 0; cellIndex < this._Cells.length;
						cellIndex++ )
					// Если существует текущая ячейка.
					if ( this._Cells[ cellIndex ] != null )
						// Установка признака выполнения автоматической прокрути
						// многострочного текстового поля текущей ячейки
						// при вращении колёски мыши.
						this._Cells[ cellIndex ].mouseWheelEnabled =
							parCellsMouseWheelEnabled;
		} // CellsMouseWheelEnabled
		
		// Get-метод получения признака многострочности текстовыйх полей ячеек.
		// Результат: признак многострочности текстовыйх полей ячеек.
		public function get CellsAreMultiline( ): Boolean
		{
			// Признак многострочности текстовыйх полей ячеек.
			return this._CellsAreMultiline;
		} // CellsAreMultiline

		// Set-метод установки признака многострочности текстовыйх полей ячеек.
		// Параметры:
		// parCellsAreMultiline - признак многострочности текстовыйх полей ячеек.
		public function set CellsAreMultiline
			( parCellsAreMultiline: Boolean ): void
		{
			// Если ппризнак многострочности текстовыйх полей ячеек не изменился,
			// ничего не меняется.
			if ( this._CellsAreMultiline == parCellsAreMultiline )
				return;			
			
			// Признак многострочности текстовыйх полей ячеек.
			this._CellsAreMultiline = parCellsAreMultiline;
			
			// Если есть ячейки.
			if ( this._Cells != null )				
				// Просмотр всех ячеек.
				for ( var cellIndex: uint = 0; cellIndex < this._Cells.length;
						cellIndex++ )
					// Если существует текущая ячейка.
					if ( this._Cells[ cellIndex ] != null )
						// Установка признака многострочности
						// текстового поля текущей ячейки.
						this._Cells[ cellIndex ].multiline = parCellsAreMultiline;
		} // CellsAreMultiline
		
		// Get-метод получения признака наличия возможности
		// выборра текстовыйх полей ячеек.
		// Результат: признак наличия возможности выборра текстовыйх полей ячеек.
		public function get CellsAreSelectable( ): Boolean
		{
			// Признак наличия возможности выборра текстовыйх полей ячеек.
			return this._CellsAreSelectable;
		} // CellsAreSelectable

		// Set-метод установки признака наличия возможности
		// выборра текстовыйх полей ячеек.
		// Параметры:
		// parCellsAreSelectable - признак наличия возможности
		// выборра текстовыйх полей ячеек.
		public function set CellsAreSelectable
			( parCellsAreSelectable: Boolean ): void
		{
			// Если признак наличия возможности выборра текстовыйх полей ячеек
			// не изменился, ничего не меняется.
			if ( this._CellsAreSelectable == parCellsAreSelectable )
				return;			
			
			// Признак наличия возможности выборра текстовыйх полей ячеек.
			this._CellsAreSelectable = parCellsAreSelectable;
			
			// Если есть ячейки.
			if ( this._Cells != null )				
				// Просмотр всех ячеек.
				for ( var cellIndex: uint = 0; cellIndex < this._Cells.length;
						cellIndex++ )
					// Если существует текущая ячейка.
					if ( this._Cells[ cellIndex ] != null )
						// Установка признака наличия возможности выборра
						// текстового поля текущей ячейки.
						this._Cells[ cellIndex ].selectable = parCellsAreSelectable;
		} // CellsAreSelectable		
		
		// Get-метод получения признака влючения ячеек
		// в последовательность перехода с помощью клавиши Tab.
		// Результат: признак влючения ячеек
		// в последовательность перехода с помощью клавиши Tab.
		public function get CellsTabEnabled( ): Boolean
		{
			// Признак влючения ячеек в последовательность перехода
			// с помощью клавиши Tab.
			return this._CellsTabEnabled;
		} // CellsTabEnabled

		// Set-метод установки признака влючения ячеек
		// в последовательность перехода с помощью клавиши Tab.
		// Параметры:
		// parCellsTabEnabled - признак влючения ячеек
		// в последовательность перехода с помощью клавиши Tab.
		public function set CellsTabEnabled( parCellsTabEnabled: Boolean ): void
		{
			// Если признак влючения ячеек в последовательность перехода
			// с помощью клавиши Tab не изменился, ничего не меняется.
			if ( this._CellsTabEnabled == parCellsTabEnabled )
				return;			
			
			// Признак влючения ячеек в последовательность перехода
			// с помощью клавиши Tab.
			this._CellsTabEnabled = parCellsTabEnabled;
			
			// Если есть ячейки.
			if ( this._Cells != null )				
				// Просмотр всех ячеек.
				for ( var cellIndex: uint = 0; cellIndex < this._Cells.length;
						cellIndex++ )
					// Если существует текущая ячейка.
					if ( this._Cells[ cellIndex ] != null )
						// Установка признака влючения текущей ячейки
						// в последовательность перехода с помощью клавиши Tab.
						this._Cells[ cellIndex ].tabEnabled = parCellsTabEnabled;
		} // CellsTabEnabled
		
		// Get-метод получения цвета текста в текстовых полях ячеек.
		// Результат: цвет текста в текстовых полях ячеек.
		public function get CellsTextColor( ): uint
		{
			// Цвет текста в текстовых полях ячеек.
			return this._CellsTextColor;
		} // CellsTextColor

		// Set-метод установки цвета текста в текстовых полях ячеек.
		// Параметры:
		// parCellsTextColor - цвет текста в текстовых полях ячеек.
		public function set CellsTextColor( parCellsTextColor: uint ): void
		{
			// Если цвет текста в текстовых полях ячеек не изменился,
			// ничего не меняется.
			if ( this._CellsTextColor == parCellsTextColor )
				return;			
			
			// Цвет текста в текстовых полях ячеек.
			this._CellsTextColor = parCellsTextColor;
			
			// Если есть ячейки.
			if ( this._Cells != null )				
				// Просмотр всех ячеек.
				for ( var cellIndex: uint = 0; cellIndex < this._Cells.length;
						cellIndex++ )
					// Если существует текущая ячейка.
					if ( this._Cells[ cellIndex ] != null )
						// Установка цвета текста в текстовом поле текущей ячейки.
						this._Cells[ cellIndex ].textColor = parCellsTextColor;
		} // CellsTextColor
		
		// Get-метод получения типа текстовых полей ячеек.
		// Результат: тип текстовых полей ячеек.
		public function get CellsType( ): String
		{
			// Тип текстовых полей ячеек.
			return this._CellsType;
		} // CellsType

		// Set-метод установки типа текстовых полей ячеек.
		// Параметры:
		// parCellsType - тип текстовых полей ячеек.
		public function set CellsType( parCellsType: String ): void
		{
			// Если тип текстовых полей ячеек не изменился, ничего не меняется.
			if ( this._CellsType == parCellsType )
				return;			
			
			// Тип текстовых полей ячеек.
			this._CellsType = parCellsType;
			
			// Если есть ячейки.
			if ( this._Cells != null )				
				// Просмотр всех ячеек.
				for ( var cellIndex: uint = 0; cellIndex < this._Cells.length;
						cellIndex++ )
					// Если существует текущая ячейка.
					if ( this._Cells[ cellIndex ] != null )
						// Установка типа текстового поля текущей ячейки.
						this._Cells[ cellIndex ].type = parCellsType;
		} // CellsType
		
		// Get-метод получения признака видимости ячеек.
		// Результат: признак видимости ячеек.
		public function get CellsAreVisible( ): Boolean
		{
			// Признак видимости ячеек.
			return this._CellsAreVisible;
		} // CellsAreVisible

		// Set-метод установки признака видимости ячеек.
		// Параметры:
		// parCellsAreVisible - признак видимости ячеек.
		public function set CellsAreVisible( parCellsAreVisible: Boolean ): void
		{
			// Если признак видимости ячеек не изменился, ничего не меняется.
			if ( this._CellsAreVisible == parCellsAreVisible )
				return;			
			
			// Признак видимости ячеек.
			this._CellsAreVisible = parCellsAreVisible;
			
			// Если есть ячейки.
			if ( this._Cells != null )				
				// Просмотр всех ячеек.
				for ( var cellIndex: uint = 0; cellIndex < this._Cells.length;
						cellIndex++ )
					// Если существует текущая ячейка.
					if ( this._Cells[ cellIndex ] != null )
						// Установка признака видимости текущей ячейки.
						this._Cells[ cellIndex ].visible = parCellsAreVisible;
		} // CellsAreVisible
		
		// Get-метод получения признака применения переноса по словам
		// к текстовым полям ячеек.
		// Результат: признак применения переноса по словам
		// к текстовым полям ячеек.
		public function get CellsHaveWordWrap( ): Boolean
		{
			// Признак применения переноса по словам к текстовым полям ячеек.
			return this._CellsHaveWordWrap;
		} // CellsHaveWordWrap

		// Set-метод установки признака применения переноса по словам
		// к текстовым полям ячеек.
		// Параметры:
		// parCellsHaveWordWrap - признак применения переноса по словам
		// к текстовым полям ячеек.
		public function set CellsHaveWordWrap
			( parCellsHaveWordWrap: Boolean ): void
		{
			// Если признак применения переноса по словам к текстовым полям ячеек
			// не изменился, ничего не меняется.
			if ( this._CellsHaveWordWrap == parCellsHaveWordWrap )
				return;			
			
			// Признак применения переноса по словам к текстовым полям ячеек.
			this._CellsHaveWordWrap = parCellsHaveWordWrap;
			
			// Если есть ячейки.
			if ( this._Cells != null )				
				// Просмотр всех ячеек.
				for ( var cellIndex: uint = 0; cellIndex < this._Cells.length;
						cellIndex++ )
					// Если существует текущая ячейка.
					if ( this._Cells[ cellIndex ] != null )
						// Установка признака применения переноса по словам
						// к текстовому полю текущей ячейки.
						this._Cells[ cellIndex ].wordWrap = parCellsHaveWordWrap;
		} // CellsHaveWordWrap
	} // TextFieldsColumn
} // nijanus.display