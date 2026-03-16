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

	// Класс сетки текстовых полей.
	public class TextFieldsGrid extends Sprite
	{
		// Список импортированных классов из других пакетов.

		import flash.geom.Rectangle;
		import flash.text.TextField;
		import flash.text.TextFieldType;		
		import flash.text.TextFormat;		
		import flash.utils.Dictionary;	
		//-----------------------------------------------------------------------
		// Переменные экземпляра класса.
		
		// Массив столбцов текстовых полей.
		private var _Columns:        Array      = null;
		// Словарь индексов столбцов, ключами которого являются
		// названия соответствующих столбцов.
		private var _ColumnsIndices: Dictionary = new Dictionary( );		
		// Высота строки.
		private var _RowHeight: Number = TextFieldsColumn.CELL_DEFAULT_HEIGHT;
		// Количество строк.
		private var _RowsCount:      uint       = undefined;	
		
		// Значение альфа-прозрачности столбцов.
		private var _ColumnsAlpha:                Number     = 1;
		// Признак выделения столбцов серым цветом при отсутствии фокуса.
		private var _AlwaysShowColumnsSelections: Boolean    = false;	
		// Признак использования фоновой заливки в столбцах.
		private var _ColumnsHaveBackground:       Boolean    = false;
		// Цвет фона столбцов.
		private var _ColumnsBackgroundColor:      uint       = 0xFFFFFF;
		// Признак наличия рамки у столбцов.
		private var _ColumnsHaveBorder:           Boolean    = false;
		// Цвет рамки столбцов.
		private var _ColumnsBorderColor:          uint       = 0x000000;
		// Формат текста столбцов по умолчанию.
		private var _ColumnsDefaultTextFormat:    TextFormat = new TextFormat( );
		// Индексированный массив фильтров столбцов.
		private var _ColumnsFilters:              Array      = null;		
		// Признак получения сообщений мыши столбцами.
		private var _ColumnsMouseEnabled:         Boolean    = true;
		// Признак выполнения автоматической прокрути
		// многострочных текстовых полей столбцов при вращении колёски мыши.
		private var _ColumnsMouseWheelEnabled:    Boolean    = true;	
		// Признак многострочности текстовыйх полей столбцов.
		private var _ColumnsAreMultiline:         Boolean    = false;	
		// Признак наличия возможности выборра текстовыйх полей столбцов.
		private var _ColumnsAreSelectable:        Boolean    = true;	
		// Признак влючения столбцов в последовательность перехода
		// с помощью клавиши Tab.
		private var _ColumnsTabEnabled:           Boolean    = false;
		// Цвет текста в текстовых полях столбцов.
		private var _ColumnsTextColor:            uint       = 0x000000;
		// Тип текстовых полей столбцов.
		private var _ColumnsType:                 String = TextFieldType.DYNAMIC;
		// Признак видимости столбцов.
		private var _ColumnsAreVisible:           Boolean    = true;
		// Признак применения переноса по словам к текстовым полям столбцов.
		private var _ColumnsHaveWordWrap:         Boolean    = false;		
		//-----------------------------------------------------------------------	
		// Методы экземпляра класса.
		
		// Метод установки свойств.
		// Параметры:
		// parProperties - свойств сетки текстовых полей.
		public function SetProperties
			( parProperties: TextFieldsGridProperties ): void
		{
			// Если высота строки не определена.
			if ( isNaN( parProperties.RowHeight ) )
				// Установка высоты строки,
				// равной высоте ячейки столбца по умолчанию.
				parProperties.RowHeight = TextFieldsColumn.CELL_DEFAULT_HEIGHT;
			
			// Высота строки.
			this._RowHeight              = parProperties.RowHeight;			
			// Значение альфа-прозрачности столбцов.
			this._ColumnsAlpha           = parProperties.ColumnsAlpha;
			// Признак выделения столбцов серым цветом при отсутствии фокуса.
			this._AlwaysShowColumnsSelections =
				parProperties.AlwaysShowColumnsSelections;
			// Признак использования фоновой заливки в столбцах.
			this._ColumnsHaveBackground  = parProperties.ColumnsHaveBackground;
			// Цвет фона столбцов.
			this._ColumnsBackgroundColor = parProperties.ColumnsBackgroundColor;
			// Признак наличия рамки у столбцов.
			this._ColumnsHaveBorder      = parProperties.ColumnsHaveBorder;
			// Цвет рамки столбцов.
			this._ColumnsBorderColor     = parProperties.ColumnsBorderColor;
			// Формат текста столбцов по умолчанию.
			this._ColumnsDefaultTextFormat    =
				parProperties.ColumnsDefaultTextFormat;		
			// Индексированный массив фильтров столбцов.
			this._ColumnsFilters         = parProperties.ColumnsFilters;		
			// Признак получения сообщений мыши столбцами.
			this._ColumnsMouseEnabled    = parProperties.ColumnsMouseEnabled;
			// Признак выполнения автоматической прокрути
			// многострочных текстовых полей столбцов при вращении колёски мыши.
			this._ColumnsMouseWheelEnabled    =
				parProperties.ColumnsMouseWheelEnabled;	
			// Признак многострочности текстовыйх полей столбцов.
			this._ColumnsAreMultiline    = parProperties.ColumnsAreMultiline;	
			// Признак наличия возможности выборра текстовыйх полей столбцов.
			this._ColumnsAreSelectable   = parProperties.ColumnsAreSelectable;	
			// Признак влючения столбцов в последовательность перехода
			// с помощью клавиши Tab.
			this._ColumnsTabEnabled      = parProperties.ColumnsTabEnabled;
			// Цвет текста в текстовых полях столбцов.
			this._ColumnsTextColor       = parProperties.ColumnsTextColor;
			// Тип текстовых полей столбцов.
			this._ColumnsType            = parProperties.ColumnsType;
			// Признак видимости столбцов.
			this._ColumnsAreVisible      = parProperties.ColumnsAreVisible;
			// Признак применения переноса по словам к текстовым полям столбцов.
			this._ColumnsHaveWordWrap    = parProperties.ColumnsHaveWordWrap;			
		
			// Если есть столбцы.
			if ( this._Columns != null )				
				// Просмотр всех столбцов.
				for ( var columnIndex: uint = 0; columnIndex < this._Columns.length;
						columnIndex++ )
					// Если существует текущий столбец.
					if ( this._Columns[ columnIndex ] != null )
					{
						// Высоты столбца текущего столбца - высота строки.					
						this._Columns[ columnIndex ].CellHeight                =
							parProperties.RowHeight;
						// Установка альфа-прозрачности текущего столбца.
						this._Columns[ columnIndex ].CellsAlpha                =
							parProperties.ColumnsAlpha;
						// Установка признака выделения текущего столбца
						// серым цветом при отсутствии фокуса.					
						this._Columns[ columnIndex ].AlwaysShowCellsSelections =
							parProperties.AlwaysShowColumnsSelections;
						// Установка признака использования
						// фоновой заливки в текущем столбце.
						this._Columns[ columnIndex ].CellsHaveBackground       =
							parProperties.ColumnsHaveBackground;
						// Установка цвета фона текущего столбца.
						this._Columns[ columnIndex ].CellsBackgroundColor      =
							parProperties.ColumnsBackgroundColor;
						// Установка признака наличия рамки у текущего столбца.
						this._Columns[ columnIndex ].CellsHaveBorder           =
							parProperties.ColumnsHaveBorder;							
						// Установка цвета рамки текущего столбца.
						this._Columns[ columnIndex ].CellsBorderColor          =
							parProperties.ColumnsBorderColor;
						// Установка формата текста текущего столбца по умолчанию.
						this._Columns[ columnIndex ].CellsDefaultTextFormat    =
							parProperties.ColumnsDefaultTextFormat;
						// Установка индексированного массива фильтров текущего столбца.
						this._Columns[ columnIndex ].CellsFilters              =
							parProperties.ColumnsFilters;
						// Установка признака получения сообщений мыши текущим столбцом.
						this._Columns[ columnIndex ].CellsMouseEnabled         =
							parProperties.ColumnsMouseEnabled;
						// Установка признака выполнения автоматической прокрути
						// многострочного текстового поля текущего столбца
						// при вращении колёски мыши.
						this._Columns[ columnIndex ].CellsMouseWheelEnabled    =
							parProperties.ColumnsMouseWheelEnabled;
						// Установка признака многострочности
						// текстового поля текущего столбца.
						this._Columns[ columnIndex ].CellsAreMultiline         =
							parProperties.ColumnsAreMultiline;
						// Установка признака наличия возможности выборра
						// текстового поля текущего столбца.
						this._Columns[ columnIndex ].CellsAreSelectable        =
							parProperties.ColumnsAreSelectable;	
						// Установка признака влючения текущего столбца
						// в последовательность перехода с помощью клавиши Tab.
						this._Columns[ columnIndex ].CellsTabEnabled           =
							parProperties.ColumnsTabEnabled;
						// Установка цвета текста в текстовом поле текущего столбца.
						this._Columns[ columnIndex ].CellsTextColor            =
							parProperties.ColumnsTextColor;						
						// Установка типа текстового поля текущего столбца.
						this._Columns[ columnIndex ].CellsType                 =
							parProperties.ColumnsType;	
						// Установка признака видимости текущего столбца.
						this._Columns[ columnIndex ].CellsAreVisible           =
							parProperties.ColumnsAreVisible;
						// Установка признака применения переноса по словам
						// к текстовому полю текущего столбца.
						this._Columns[ columnIndex ].CellsHaveWordWrap         =
							parProperties.ColumnsHaveWordWrap;				
					} // if
		} // SetProperties		
		
		// Метод получения столбца по заданному индексу.
		// Параметры:
		// parColumnIndex - индекс столбца.
		// Результат: столбец текстовых полей по заданному индексу.
		public function GetColumnByIndex
			( parColumnIndex: uint ): TextFieldsColumn		
		{			
			// Если нет столбцов или заданный индекс находится
			// вне пределов индекса столбца.
			if
			(
				( this._Columns  == null ) ||
				( parColumnIndex >= this._Columns.length )
			)
				// Столбец с заданным индексом не существует.
				return null;
			// Если заданный индекс находится в пределах индекса столбца.
			else
				// Столбец по заданному индексу.
				return this._Columns[ parColumnIndex ];
		} // GetColumnByIndex
		
		// Метод получения столбца по заданному имени.
		// Параметры:
		// parColumnName - имя столбца.
		// Результат: столбец текстовых полей по заданному имени.
		public function GetColumnByName
			( parColumnName: String ): TextFieldsColumn		
		{
			// Индекс столбца из словаря индексов столбцов,
			// полученный по имени столбца.
			var columnIndex: Number = this._ColumnsIndices[ parColumnName ];			
			
			// Если индекс столбца не определён.
			if ( isNaN( columnIndex ) )
				// Столбец с заданным именем не существует.
				return null;
			// Если индекс столбца определён.
			else
				// Столбец по индексу.
				return this.GetColumnByIndex( columnIndex );
		} // GetColumnByName		
		
		// Метод установки столбца по заданному индексу.
		// Параметры:
		// parColumnIndex - индекс столбца,
		// parColumn      - столбец.
		public function SetColumnByIndex
		(
			parColumnIndex: uint,
			parColumn:      TextFieldsColumn
		): void		
		{
			// Если нет столбцов
			// или заданный индекс находится вне пределов индекса столбца,
			// или существует столбец с другим индексом, но таким же именем.
			if
			(
				( this._Columns  == null                 ) ||
				( parColumnIndex >= this._Columns.length ) ||
				(
					( ! isNaN( this._ColumnsIndices[ parColumn.Name ] )        ) &&
					( this._ColumnsIndices[ parColumn.Name ] != parColumnIndex )
				)
			)			
				// Ничего не изменяется.
				return;
			// Если заданный индекс находится в пределах индекса столбца.
			else
			{
				// Абсцисса столбца.
				var columnX:     Number = this._Columns[ parColumnIndex ].x;
				// Ширина столбца.
				var columnWidth: Number = this._Columns[ parColumnIndex ].width;	
				
				// Удаление столбца из сетки текстовых полей.
				this.removeChild( this._Columns[ parColumnIndex ] );
				// Удаление индекса столбца по имени.
				delete this._ColumnsIndices[ this._Columns[ parColumnIndex ].Name ];
				
				// Установка столбца по заданному индексу.
				this._Columns[ parColumnIndex ] = parColumn;
				// Добавление столбца в сетку текстовых полей.
				this.addChild( this._Columns[ parColumnIndex ] );
				// Запись в словарь индекса столбца по имени.
				this._ColumnsIndices[ this._Columns[ parColumnIndex ].Name ] =
					parColumnIndex;			
				
				// Абсцисса столбца - прежняяй.
				this._Columns[ parColumnIndex ].x      = columnX;
				// Ордината столбца - нулевая.
				this._Columns[ parColumnIndex ].y      = 0;
				// Ширина столбца   - прежняя.
				this._Columns[ parColumnIndex ].width  = columnWidth;
				// Высота столбца   - высота сетки текстовых полей.
				this._Columns[ parColumnIndex ].height = this.scrollRect.height;
				
				// Высота ячейки столбца - высота строки.
				this._Columns[ parColumnIndex ].CellHeight = this._RowHeight;
				// Количество ячеек столбца - количество строк.
				this._Columns[ parColumnIndex ].CellsCount = this._RowsCount;		
			} // else
		} // SetColumnByIndex	
		
		// Метод установки столбца по заданному имени.
		// Параметры:
		// parColumnName - имя столбца,
		// parColumn      - столбец.
		public function SetColumnByName
		(
			parColumnName: String,
			parColumn:     TextFieldsColumn
		): void
		{
			// Индекс столбца из словаря индексов столбцов,
			// полученный по имени столбца.
			var columnIndex: Number = this._ColumnsIndices[ parColumnName ];			
			
			// Если индекс столбца не определён.
			if ( isNaN( columnIndex ) )
				// Столбец с заданным именем не существует.
				return;
			// Если индекс столбца определён.
			else
				// Установка столбца по индексу.
				return this.SetColumnByIndex( columnIndex, parColumn );
		} // SetColumnByName		
		
		// Метод установки ширины столбца по заданному индексу.
		// Параметры:
		// parColumnIndex - индекс столбца,
		// parColumnWidth - ширина столбца.
		public function SetColumnWidthByIndex
		(
			parColumnIndex: uint,
			parColumnWidth: Number
		): void		
		{
			// Если нет столбцов
			// или заданный индекс находится вне пределов индекса столбца.
			if
			(
				( this._Columns  == null ) ||
				( parColumnIndex >= this._Columns.length )
			)			
				// Ничего не изменяется.
				return;
			// Если заданный индекс находится в пределах индекса столбца.
			else
				// Устновка ширины столбца.
				this._Columns[ parColumnIndex ].width = parColumnWidth;
		} // SetColumnWidthByIndex
		
		// Метод установки ширины столбца по заданному имени.
		// Параметры:
		// parColumnName  - имя столбца,
		// parColumnWidth - ширина столбца.
		public function SetColumnWidthByName
		(
			parColumnName:  String,
			parColumnWidth: Number
		): void		
		{
			// Индекс столбца из словаря индексов столбцов,
			// полученный по имени столбца.
			var columnIndex: Number = this._ColumnsIndices[ parColumnName ];			
			
			// Если индекс столбца не определён.
			if ( isNaN( columnIndex ) )
				// Столбец с заданным именем не существует.
				return;
			// Если индекс столбца определён.
			else
				// Установка ширины столбца по заданному индексу.
				return this.SetColumnWidthByIndex( columnIndex, parColumnWidth );
		} // SetColumnWidthByName	
		
		// Метод установки ячейки по заданному индексу
		// столбца с заданным индексом.
		// Параметры:
		// parColumnIndex   - индекс столбца,		
		// parRowIndex      - индекс строки,
		// parCellTextField - текстовое поле ячейки.
		public function SetColumnCellByIndex
		(
			parColumnIndex,		 
			parRowIndex:      uint,
			parCellTextField: TextField
		): void
		{
			// Если нет столбцов или заданный индекс столбца
			// находится вне пределов индекса столбца.
			if
			(
				( this._Columns  == null ) ||
				( parColumnIndex >= this._Columns.length )
			)			
				// Ничего не изменяется.
				return;
			// Если заданный индекс столбца находится в пределах индекса столбца.
			else
				// Устновка ячейки столбца.
				this._Columns[ parColumnIndex ].SetCell
					( parRowIndex, parCellTextField );		
		} // SetColumnCellByIndex
		
		// Метод установки ячейки по заданному индексу
		// столбца с заданным именем.
		// Параметры:
		// parColumnName    - имя столбца,
		// parRowIndex      - индекс строки,
		// parCellTextField - текстовое поле ячейки.
		public function SetColumnCellByName
		(
			parColumnName:    String,
			parRowIndex:      uint,
			parCellTextField: TextField
		): void
		{
			// Индекс столбца из словаря индексов столбцов,
			// полученный по имени столбца.
			var columnIndex: Number = this._ColumnsIndices[ parColumnName ];			
			
			// Если индекс столбца не определён.
			if ( isNaN( columnIndex ) )
				// Столбец с заданным именем не существует.
				return;
			// Если индекс столбца определён.
			else
				// Установка ячейки по заданному индексу
				// столбца с заданным индексом.
				return this.SetColumnCellByIndex
					( columnIndex, parRowIndex, parCellTextField );
		} // SetColumnCellByName
		
		// Метод установки текста ячейки по заданному индексу
		// столбца с заданным индексом.
		// Параметры:
		// parColumnIndex - индекс столбца,		
		// parRowIndex    - индекс строки,
		// parCellText    - текст ячейки.
		public function SetColumnCellTextByIndex
		(
			parColumnIndex,		 
			parRowIndex: uint,
			parCellText: String
		): void
		{
			// Если нет столбцов или заданный индекс столбца
			// находится вне пределов индекса столбца.
			if
			(
				( this._Columns  == null ) ||
				( parColumnIndex >= this._Columns.length )
			)			
				// Ничего не изменяется.
				return;
			// Если заданный индекс столбца находится в пределах индекса столбца.
			else
				// Устновка текста ячейки столбца.
				this._Columns[ parColumnIndex ].SetCellText
					( parRowIndex, parCellText );
		} // SetColumnCellTextByIndex		
		
		// Метод установки текста ячейки по заданному индексу
		// столбца с заданным именем.
		// Параметры:
		// parColumnName - имя столбца,
		// parRowIndex   - индекс строки,
		// parCellText   - текст ячейки.
		public function SetColumnCellTextByName
		(
			parColumnName: String,
			parRowIndex:   uint,
			parCellText:   String
		): void
		{
			// Индекс столбца из словаря индексов столбцов,
			// полученный по имени столбца.
			var columnIndex: Number = this._ColumnsIndices[ parColumnName ];			
			
			// Если индекс столбца не определён.
			if ( isNaN( columnIndex ) )
				// Столбец с заданным именем не существует.
				return;
			// Если индекс столбца определён.
			else
				// Установка текста ячейки по заданному индексу
				// столбца с заданным индексом.
				return this.SetColumnCellTextByIndex
					( columnIndex, parRowIndex, parCellText );
		} // SetColumnCellTextByName		
		
		// Метод установки стиля столбцов данной сетки текстовых полей
		// для заданного столбца текстовых полей.
		// Параметры:
		// parColumn - столбец текстовых полей.
		public function SetColumnsStyle( parColumn: TextFieldsColumn )
		{
			// Свосйтва столбца текстовых полей.
			var columnProperties: TextFieldsColumnProperties =
				new TextFieldsColumnProperties( );
				
			// Формат текста ячеек по умолчанию.
			columnProperties.CellsDefaultTextFormat =
				new TextFormat
				(
					this._ColumnsDefaultTextFormat.font,
					this._ColumnsDefaultTextFormat.size,
					this._ColumnsDefaultTextFormat.color,
					this._ColumnsDefaultTextFormat.bold,
					this._ColumnsDefaultTextFormat.italic,
					this._ColumnsDefaultTextFormat.underline,
					this._ColumnsDefaultTextFormat.url,
					this._ColumnsDefaultTextFormat.target,
					this._ColumnsDefaultTextFormat.align,
					this._ColumnsDefaultTextFormat.leftMargin,
					this._ColumnsDefaultTextFormat.rightMargin,
					this._ColumnsDefaultTextFormat.indent,
					this._ColumnsDefaultTextFormat.leading
				), // new TextFormat
				
			// Высота ячейки - высота строки.
			columnProperties.CellHeight           = this._RowHeight;
			// Признак многострочности текстовыйх полей ячеек.
			columnProperties.CellsAreMultiline    = this._ColumnsAreMultiline;
			// Признак применения переноса по словам к текстовым полям ячеек.
			columnProperties.CellsHaveWordWrap    = this._ColumnsHaveWordWrap;
			// Тип текстовых полей ячеек.
			columnProperties.CellsType            = this._ColumnsType;
			// Признак выделения ячеек серым цветом при отсутствии фокуса.
			columnProperties.AlwaysShowCellsSelections =
				this._AlwaysShowColumnsSelections;
			// Признак наличия возможности выборра текстовыйх полей ячеек.
			columnProperties.CellsAreSelectable   = this._ColumnsAreSelectable;
			// Признак влючения ячеек в последовательность перехода
			// с помощью клавиши Tab.
			columnProperties.CellsTabEnabled      = this._ColumnsTabEnabled;
			// Признак выполнения автоматической прокрути
			// многострочных текстовых полей ячеек при вращении колёски мыши.
			columnProperties.CellsMouseWheelEnabled    =
				this._ColumnsMouseWheelEnabled;
			// Признак получения сообщений мыши ячейками.
			columnProperties.CellsMouseEnabled    = this._ColumnsMouseEnabled;
			// Признак наличия рамки у ячеек.
			columnProperties.CellsHaveBorder      = this._ColumnsHaveBorder;
			// Цвет рамки ячеек.
			columnProperties.CellsBorderColor     = this._ColumnsBorderColor;
			// Признак использования фоновой заливки в ячейках.
			columnProperties.CellsHaveBackground  = this._ColumnsHaveBackground;
			// Цвет фона ячеек.
			columnProperties.CellsBackgroundColor = this._ColumnsBackgroundColor;
			// Значение альфа-прозрачности ячеек.
			columnProperties.CellsAlpha           = this._ColumnsAlpha;
			// Индексированный массив фильтров ячеек.
			columnProperties.CellsFilters         = this._ColumnsFilters;
			// Цвет текста в текстовых полях ячеек.
			columnProperties.CellsTextColor       = this._ColumnsTextColor;
			// Признак видимости ячеек.
			columnProperties.CellsAreVisible      = this._ColumnsAreVisible;
			
			// Установки свойств столбца текстовых полей, таких же,
			// как у столбцов данной сетки текстовых полей.
			parColumn.SetProperties( columnProperties );
			// Количество ячеек столбца - количество строк.
			parColumn.CellsCount = this._RowsCount;			
		} // TextFieldsColumn		
		
		// Метод добавления столбца в конец массива стобцов.
		// Параметры:
		// parColumnName  - имя столбца,
		// parColumnWidth - ширина столбца.
		public function AddColumn
		(
			parColumnName:  String,
			parColumnWidth: Number
		): void
		{
			// Если уже существует столбец с заданным именем.
			if ( ! isNaN( this._ColumnsIndices[ parColumnName ] ) )
				// Ничего не изменяется.
				return;
				
			// Если нет столбцов.
			if ( this._Columns == null )
				// Создание столбцов.
				this._Columns = new Array( );			
			
			// Абсцисса добавляемого столбца.
			var columnX: Number = 0;
			
			// Просмотр всех столбцов.
			for ( var columnIndex: uint = 0; columnIndex < this._Columns.length;
					columnIndex++ )
				// Если существует текущий столбец.
				if ( this._Columns[ columnIndex ] != null )
					// Абсцисса добавляемого столбца - сумма ширин
					// существующих столбцов, расположенных последовательно
					// друг под другом, начиная от левой грани сетки текстовых полей.
					columnX += this._Columns[ columnIndex ].width;
					
			// Столбец текстовых полей.
			var column: TextFieldsColumn =
				new TextFieldsColumn
				(
					// Имя      столбца.
					parColumnName,
					// Прямоугольная область столбца текстовых полей.
					new Rectangle
					(
						// Абсцисса.
						columnX,
						// Ордината - нулевая.
						0,
						// Ширина.
						parColumnWidth,
						// Высота - высота сетки текстовых полей.
						this.scrollRect.height
					) // new Rectangle
				); // new TextFieldsColumn				
				
			// Добавление столбца в сетку текстовых полей.
			this.addChild( column );
			// Добавление столбца в конец массива столбцов.
			this._Columns.push( column );
			// Запись в словарь индекса столбца по имени.
			this._ColumnsIndices[ parColumnName ] = this._Columns.length - 1;			
			// Установка стиля столбцов данной сетки текстовых полей
			// для столбца текстовых полей.	
			this.SetColumnsStyle( column );		
		} // AddColumn
		
		// Метод добавления столбца по заданному индексу.
		// Параметры:
		// parColumnIndex - индекс столбца,
		// parColumnName  - имя столбца,
		// parColumnWidth - ширина столбца.		
		public function AddColumnAt
		(
			parColumnIndex: uint,
			parColumnName:  String,
			parColumnWidth: Number
		): void
		{
			// Если уже существует столбец с заданным именем.
			if ( ! isNaN( this._ColumnsIndices[ parColumnName ] ) )
				// Ничего не изменяется.
				return;			
			
			// Если нет столбцов.
			if ( this._Columns == null )
				// Создание столбцов.
				this._Columns = new Array( );
				
			// Если заданный индекс превышает индекс последнего столбца.
			if ( parColumnIndex >= this._Columns.length )
				// Добавления столбца в конец массива стобцов.
				this.AddColumn( parColumnName, parColumnWidth );
				
			// Столбец текстовых полей.
			var column: TextFieldsColumn =
				new TextFieldsColumn
				(
					// Имя      столбца.
					parColumnName,
					// Прямоугольная область столбца текстовых полей.
					new Rectangle
					(
						// Абсцисса - абсцисса столбца,
						// в натоящий момент записанного по заданному индексу.
						this._Columns[ parColumnIndex ].x,
						// Ордината - нулевая.
						0,
						// Ширина.
						parColumnWidth,
						// Высота - высота сетки текстовых полей.
						this.scrollRect.height					
					) // new Rectangle
				); // new TextFieldsColumn
				
			// Добавление столбца в сетку текстовых полей.
			this.addChild( column );
			// Добавление столбца в массив столбцов по заданному индексу.
			this._Columns.splice( parColumnIndex, 0, column );
			// Запись в словарь индекса столбца по имени.
			this._ColumnsIndices[ parColumnName ] = parColumnIndex;
			// Установка стиля столбцов данной сетки текстовых полей
			// для столбца текстовых полей.	
			this.SetColumnsStyle( column );			
				
			// Просмотр всех столбцов после добаленного.
			for ( var columnIndex: uint = parColumnIndex + 1; columnIndex <
					this._Columns.length; columnIndex++ )
				// Если существует текущий столбец.
				if ( this._Columns[ columnIndex ] != null )
				{
					// Абсцисса текущего столбца увеличивается
					// на значение ширины добавленного столбца.
					this._Columns[ columnIndex ].x += parColumnWidth;
					// Запись в словарь нового индекса столбца с текущим именем.
					this._ColumnsIndices[ this._Columns[ columnIndex ].Name ] =
						columnIndex;	
				} // if
		} // AddColumnAt
		
		// Метод удаления столбца с заданным индексом.
		// Параметры:
		// parColumnIndex - индекс столбца.
		public function RemoveColumnAtIndex( parColumnIndex: uint ): void
		{
			// Если нет столбцов или заданный индекс находится
			// вне пределов индекса столбца.
			if
			(
				( this._Columns  == null ) ||
				( parColumnIndex >= this._Columns.length )
			)
				// Ничего не удаляется.
				return;
				
			// Просмотр всех столбцов после удаляемого.
			for ( var columnIndex: uint = parColumnIndex + 1; columnIndex <
					this._Columns.length; columnIndex++ )
				// Если существует текущий столбец.
				if ( this._Columns[ columnIndex ] != null )
				{
					// Абсцисса текущего столбца уменьшается
					// на значение ширины удаляемого столбца.
					this._Columns[ columnIndex ].x -=
						this._Columns[ parColumnIndex ].width;						
					// Запись в словарь нового индекса столбца с текущим именем.
					this._ColumnsIndices[ this._Columns[ columnIndex ].Name ] =
						columnIndex - 1;				
				} // if
				
			// Удаление столбца из сетки текстовых полей.
			this.removeChild( this._Columns[ parColumnIndex ] );
			// Удаление индекса столбца по имени.
			delete this._ColumnsIndices[ this._Columns[ parColumnIndex ].Name ];				
			// Удаление столбца из массива столбцов по заданному индексу.
			this._Columns.splice( parColumnIndex, 1 );					
		} // RemoveColumnAtIndex		
		
		// Метод удаления столбца с заданным именем.
		// Параметры:
		// parColumnName - имя столбца.
		public function RemoveColumnAtName( parColumnName: String ): void	
		{
			// Индекс столбца из словаря индексов столбцов,
			// полученный по имени столбца.
			var columnIndex: Number = this._ColumnsIndices[ parColumnName ];			
			
			// Если индекс столбца не определён.
			if ( isNaN( columnIndex ) )
				// Столбец с заданным именем не существует.
				return;
			// Если индекс столбца определён.
			else
				// Удаления столбца с заданным индексом.
				return this.RemoveColumnAtIndex( columnIndex );
		} // RemoveColumnAtName
		
		// Метод загрузки текстов ячеек из XML-данных.
		// Параметры:
		// parXML - XML-данне.
		public function LoadCellsTextsFromXML( parXML: XML ): void
		{
			// Количество строк - количество дочерних узлов дерева XML-данных
			// с заголовком "Row".
			this.RowsCount = parXML.Row.length( );
			
			// Просмотр строк.
			for ( var rowIndex: uint = 0; rowIndex < parXML.Row.length( );
					rowIndex++ )
				// Просмотр элементов текущей строки.
				for ( var elementIndex: uint = 0; elementIndex <
						parXML.Row[ rowIndex ].children( ).length( ); elementIndex++ )
					// Установка текста ячейки в строке с текущим индексом
					// в столбце с именем текущего элемента.
					this.SetColumnCellTextByName
					(
						// Имя столбца.
						parXML.Row[ rowIndex ].children( )[ elementIndex ].name( ).
							toString( ),
						// Индекс строки.
						rowIndex,
						// Текст ячейки.
						parXML.Row[ rowIndex ].children( )[ elementIndex ].toString( )
					);
		} // LoadCellsTextsFromXML
		//-----------------------------------------------------------------------		
		// Методы-конструкторы.
		
		// Метод-конструктор экземпляра сетки текстовых полей.
		// Параметры:
		// parAreaRectangle - прямоугольная область сетки текстовых полей.
		public function TextFieldsGrid( parAreaRectangle: Rectangle ): void
		{
			// Вызов метода-конструктора суперкласса Sprite.
			super( );			
			
			// Абсцисса сетки текстовых полей.
			this.x          = parAreaRectangle.x;
			// Ордината сетки текстовых полей.
			this.y          = parAreaRectangle.y;
			// Определение прямоугольной области прокрутки сетки текстовых полей.
			this.scrollRect = new Rectangle( 0, 0, parAreaRectangle.width,
				parAreaRectangle.height );			
		} // TextFieldsGrid
		//-----------------------------------------------------------------------
		// Get- и set-методы.
		
		// Get-метод получения ширины.
		// Результат: ширина.
		override public function get width( ): Number
		{
			// Ширина прямоугольной области прокрутки сетки текстовых полей.
			return this.scrollRect.width;
		} // width		
		
		// Set-метод установки ширины.
		// parWidth - ширина.
		override public function set width( parWidth: Number ): void
		{
			// Если ширина не изменилась, ничего не меняется.
			if ( this.scrollRect.width == parWidth )
				return;			
			// Прямоугольная область прокрутки сетки текстовых полей.
			this.scrollRect = new Rectangle( this.scrollRect.x, this.scrollRect.y,
				parWidth, this.scrollRect.height );
		} // width
		
		// Get-метод получения высоты.
		// Результат: высота.
		override public function get height( ): Number
		{
			// Высота прямоугольной области прокрутки сетки текстовых полей.
			return this.scrollRect.height;
		} // height		
		
		// Set-метод установки высоты.
		// parHeight - высота.
		override public function set height( parHeight: Number ): void
		{
			// Если высота не изменилась, ничего не меняется.
			if ( this.scrollRect.height == parHeight )
				return;			
			// Прямоугольная область прокрутки сетки текстовых полей.
			this.scrollRect = new Rectangle( this.scrollRect.x, this.scrollRect.y,
				this.scrollRect.width, parHeight );
			
			// Если есть столбцы.
			if ( this._Columns != null )				
				// Просмотр всех столбцов.
				for ( var columnIndex: uint = 0; columnIndex < this._Columns.length;
						columnIndex++ )
					// Если существует текущий столбец.
					if ( this._Columns[ columnIndex ] != null )
						// Установка высоты текущего столбца.
						this._Columns[ columnIndex ].height = parHeight;			
		} // height		
		
		// Get-метод получения высоты строки.
		// Результат: высота строки.
		public function get RowHeight( ): Number
		{
			// Высота строки.
			return this._RowHeight;
		} // RowHeight

		// Set-метод установки высоты строки.
		// Параметры:
		// parRowHeight - высота строки.
		public function set RowHeight( parRowHeight: Number ): void
		{
			// Если высота строки не изменилась, ничего не меняется.
			if ( this._RowHeight == parRowHeight )
				return;
			
			// Высота строки.
			this._RowHeight = parRowHeight;
			
			// Если есть столбцы.
			if ( this._Columns != null )
				// Просмотр всех столбцов.
				for ( var columnIndex: uint = 0; columnIndex < this._Columns.length;
						columnIndex++ )
					// Если существует текущий столбец.
					if ( this._Columns[ columnIndex ] != null )
						// Высоты столбца текущего столбца - высота строки.					
						this._Columns[ columnIndex ].CellHeight = parRowHeight;		
		} // RowHeight
		
		// Get-метод получения количества столбцов.
		// Результат: количество столбцов.
		public function get ColumnsCount( ): uint
		{
			// Количество столбцов - количество элементов массива стоблцов.
			return this._Columns.length;
		} // ColumnsCount
		
		// Set-метод установки количества столбцов.
		// Параметры:
		// parColumnsCount - количество столбцов.
		public function set ColumnsCount( parColumnsCount: uint ): void
		{
			// Если нет столбцов.
			if ( this._Columns == null )
				// Создание столбцов.
				this._Columns = new Array( );			
			
			// Если количество столбцов не изменилось
			// или предпринята попытка его увеличить, ничего не меняется.
			if ( this._Columns.length <= parColumnsCount )
				return;				
				
			// Количество столбцов можно только уменьшать,
			// потому что если добавлять новые столбцы,
			// то им нужны имена, а имена - уникальны,
			// то есть двух столбцов с одним именем быт не может,
			// поэтому нельзя создать много столбцов
			// с одним и тем же именем по умелчанию.
			
			// Просмотр всех столбцов, начиная с первого, который надо удалить.
			for ( var columnIndex: uint = parColumnsCount; columnIndex <
					this._Columns.length; columnIndex++ )
				// Если существует текущий столбец.
				if ( this._Columns[ columnIndex ] != null )
				{
					// Удаление теукущего столбца из сетки текстовых полей.
					this.removeChild( this._Columns[ columnIndex ] );						
					// Удаление индекса текущего столбца по имени.
					delete this._ColumnsIndices[ this._Columns[ columnIndex ].Name ];					
				} // if			
					
			// Удаление последних столбцов из массива столбцов.
			this._Columns.splice( parColumnsCount,
				this._Columns.length - parColumnsCount );
		} // ColumnsCount		
		
		// Get-метод получения количества строк.
		// Результат: количество строк.
		public function get RowsCount( ): uint
		{
			// Количество строк.
			return this._RowsCount;
		} // RowsCount
		
		// Set-метод установки количества строк.
		// Параметры:
		// parRowsCount - количество строк.
		public function set RowsCount( parRowsCount: uint ): void
		{
			// Если нет столбцов или количество строк не изменилось,
			// ничего не меняется.
			if
			(
			 	( this._Columns   == null ) ||
				( this._RowsCount == parRowsCount )
			)
				return;
				
			// Количество строк.
			this._RowsCount = parRowsCount;			
				
			// Просмотр всех столбцов.
			for ( var columnIndex: uint = 0; columnIndex < this._Columns.length;
					columnIndex++ )
				// Если существует текущий столбец.
				if ( this._Columns[ columnIndex ] != null )
					// Установка количества ячеек текущего столбца.
					this._Columns[ columnIndex ].CellsCount = parRowsCount;				
		} // RowsCount
		
		// Get-метод получения значения альфа-прозрачности столбцов.
		// Результат: значение альфа-прозрачности столбцов.
		public function get ColumnsAlpha( ): Number
		{
			// Значение альфа-прозрачности столбцов.
			return this._ColumnsAlpha;
		} // ColumnsAlpha

		// Set-метод установки значения альфа-прозрачности столбцов.
		// Параметры:
		// parColumnsAlpha - значение альфа-прозрачности столбцов.
		public function set ColumnsAlpha( parColumnsAlpha: Number ): void
		{
			// Если значение альфа-прозрачности столбцов не изменилась,
			// ничего не меняется.
			if ( this._ColumnsAlpha == parColumnsAlpha )
				return;			
			
			// Значение альфа-прозрачности столбцов.
			this._ColumnsAlpha = parColumnsAlpha;
			
			// Если есть столбцы.
			if ( this._Columns != null )				
				// Просмотр всех столбцов.
				for ( var columnIndex: uint = 0; columnIndex < this._Columns.length;
						columnIndex++ )
					// Если существует текущий столбец.
					if ( this._Columns[ columnIndex ] != null )
						// Установка альфа-прозрачности текущего столбца.
						this._Columns[ columnIndex ].CellsAlpha = parColumnsAlpha;		
		} // ColumnsAlpha
		
		// Get-метод получения признака выделения столбцов
		// серым цветом при отсутствии фокуса.
		// Результат: признак выделения столбцов серым цветом
		// при отсутствии фокуса.
		public function get AlwaysShowColumnsSelections( ): Boolean
		{
			// Признак выделения столбцов серым цветом при отсутствии фокуса.
			return this._AlwaysShowColumnsSelections;
		} // AlwaysShowColumnsSelections

		// Set-метод установки признака выделения столбцов
		// серым цветом при отсутствии фокуса.
		// Параметры:
		// parAlwaysShowColumnsSelections - признак выделения столбцов
		// серым цветом при отсутствии фокуса.
		public function set AlwaysShowColumnsSelections
			( parAlwaysShowColumnsSelections: Boolean ): void
		{
			// Если признак выделения столбцов серым цветом при отсутствии фокуса
			// не изменилось, ничего не меняется.
			if ( this._AlwaysShowColumnsSelections ==
					parAlwaysShowColumnsSelections )
				return;			
			
			// Признак выделения столбцов серым цветом при отсутствии фокуса.
			this._AlwaysShowColumnsSelections = parAlwaysShowColumnsSelections;
			
			// Если есть столбцы.
			if ( this._Columns != null )				
				// Просмотр всех столбцов.
				for ( var columnIndex: uint = 0; columnIndex < this._Columns.length;
						columnIndex++ )
					// Если существует текущий столбец.
					if ( this._Columns[ columnIndex ] != null )
						// Установка признака выделения текущего столбца
						// серым цветом при отсутствии фокуса.					
						this._Columns[ columnIndex ].AlwaysShowCellsSelections =
							parAlwaysShowColumnsSelections;		
		} // AlwaysShowColumnsSelections
		
		// Get-метод получения признака использования фоновой заливки в столбцах.
		// Результат: признак использования фоновой заливки в столбцах.
		public function get ColumnsHaveBackground( ): Boolean
		{
			// Признак использования фоновой заливки в столбцах.
			return this._ColumnsHaveBackground;
		} // ColumnsHaveBackground

		// Set-метод установки признака использования фоновой заливки в столбцах.
		// Параметры:
		// parColumnsHaveBackground - признак использования
		// фоновой заливки в столбцах.
		public function set ColumnsHaveBackground
			( parColumnsHaveBackground: Boolean ): void
		{
			// Если признак использования фоновой заливки в столбцах не изменился,
			// ничего не меняется.
			if ( this._ColumnsHaveBackground == parColumnsHaveBackground )
				return;			
			
			// Признак использования фоновой заливки в столбцах.
			this._ColumnsHaveBackground = parColumnsHaveBackground;
			
			// Если есть столбцы.
			if ( this._Columns != null )				
				// Просмотр всех столбцов.
				for ( var columnIndex: uint = 0; columnIndex < this._Columns.length;
						columnIndex++ )
					// Если существует текущий столбец.
					if ( this._Columns[ columnIndex ] != null )
						// Установка признака использования
						// фоновой заливки в текущей столбцу.
						this._Columns[ columnIndex ].CellsHaveBackground = 
							parColumnsHaveBackground;
		} // ColumnsHaveBackground
		
		// Get-метод получения цвета фона столбцов.
		// Результат: цвет фона столбцов.
		public function get ColumnsBackgroundColor( ): uint
		{
			// Цвет фона столбцов.
			return this._ColumnsBackgroundColor;
		} // ColumnsBackgroundColor

		// Set-метод установки цвета фона столбцов.
		// Параметры:
		// parColumnsBackgroundColor - цвет фона столбцов.
		public function set ColumnsBackgroundColor
			( parColumnsBackgroundColor: uint ): void
		{
			// Если цвет фона столбцов не изменился, ничего не меняется.
			if ( this._ColumnsBackgroundColor == parColumnsBackgroundColor )
				return;			
			
			// Цвет фона столбцов.
			this._ColumnsBackgroundColor = parColumnsBackgroundColor;
			
			// Если есть столбцы.
			if ( this._Columns != null )				
				// Просмотр всех столбцов.
				for ( var columnIndex: uint = 0; columnIndex < this._Columns.length;
						columnIndex++ )
					// Если существует текущий столбец.
					if ( this._Columns[ columnIndex ] != null )
						// Установка цвета фона текущего столбца.
						this._Columns[ columnIndex ].CellsBackgroundColor =
							parColumnsBackgroundColor;
		} // ColumnsBackgroundColor
		
		// Get-метод получения признака наличия рамки у столбцов.
		// Результат: признак наличия рамки у столбцов.
		public function get ColumnsHaveBorder( ): Boolean
		{
			// Признак наличия рамки у столбцов.
			return this._ColumnsHaveBorder;
		} // ColumnsHaveBorder

		// Set-метод установки признака наличия рамки у столбцов.
		// Параметры:
		// parColumnsHaveBorder - признак наличия рамки у столбцов.
		public function set ColumnsHaveBorder
			( parColumnsHaveBorder: Boolean ): void
		{
			// Если признак наличия рамки у столбцов не изменился,
			// ничего не меняется.
			if ( this._ColumnsHaveBorder == parColumnsHaveBorder )
				return;			
			
			// Признак наличия рамки у столбцов.
			this._ColumnsHaveBorder = parColumnsHaveBorder;
			
			// Если есть столбцы.
			if ( this._Columns != null )				
				// Просмотр всех столбцов.
				for ( var columnIndex: uint = 0; columnIndex < this._Columns.length;
						columnIndex++ )
					// Если существует текущий столбец.
					if ( this._Columns[ columnIndex ] != null )
						// Установка признака наличия рамки у текущего столбца.
						this._Columns[ columnIndex ].CellsHaveBorder =
							parColumnsHaveBorder;
		} // ColumnsHaveBorder
		
		// Get-метод получения цвета рамки столбцов.
		// Результат: цвет рамки столбцов.
		public function get ColumnsBorderColor( ): uint
		{
			// Цвет рамки столбцов.
			return this._ColumnsBorderColor;
		} // ColumnsBorderColor

		// Set-метод установки цвета рамки столбцов.
		// Параметры:
		// parColumnsBorderColor - цвет рамки столбцов.
		public function set ColumnsBorderColor
			( parColumnsBorderColor: uint ): void
		{
			// Если цвет рамки столбцов не изменился, ничего не меняется.
			if ( this._ColumnsBorderColor == parColumnsBorderColor )
				return;			
			
			// Цвет рамки столбцов.
			this._ColumnsBorderColor = parColumnsBorderColor;
			
			// Если есть столбцы.
			if ( this._Columns != null )				
				// Просмотр всех столбцов.
				for ( var columnIndex: uint = 0; columnIndex < this._Columns.length;
						columnIndex++ )
					// Если существует текущий столбец.
					if ( this._Columns[ columnIndex ] != null )
						// Установка цвета рамки текущего столбца.
						this._Columns[ columnIndex ].CellsBorderColor =
							parColumnsBorderColor;
		} // ColumnsBorderColor	
		
		// Get-метод получения формата текста столбцов по умолчанию.
		// Результат: формат текста столбцов по умолчанию.
		public function get ColumnsDefaultTextFormat( ): TextFormat
		{
			// Формат текста столбцов по умолчанию.
			return this._ColumnsDefaultTextFormat;
		} // ColumnsDefaultTextFormat

		// Set-метод установки формата текста столбцов по умолчанию.
		// Параметры:
		// parColumnsDefaultTextFormat - формат текста столбцов по умолчанию.
		public function set ColumnsDefaultTextFormat
			( parColumnsDefaultTextFormat: TextFormat ): void
		{
			// Если формат текста столбцов по умолчанию не изменился,
			// ничего не меняется.
			if ( this._ColumnsDefaultTextFormat == parColumnsDefaultTextFormat )
				return;			
			
			// Формат текста столбцов по умолчанию.
			this._ColumnsDefaultTextFormat = parColumnsDefaultTextFormat;
			
			// Если есть столбцы.
			if ( this._Columns != null )				
				// Просмотр всех столбцов.
				for ( var columnIndex: uint = 0; columnIndex < this._Columns.length;
						columnIndex++ )
					// Если существует текущий столбец.
					if ( this._Columns[ columnIndex ] != null )
						// Установка формата текста текущего столбца по умолчанию.
						this._Columns[ columnIndex ].CellsDefaultTextFormat =
							parColumnsDefaultTextFormat;
		} // ColumnsDefaultTextFormat		
		
		// Get-метод получения индексированного массива фильтров столбцов.
		// Результат: индексированный массив фильтров столбцов.
		public function get ColumnsFilters( ): Array
		{
			// Индексированный массив фильтров столбцов.
			return this._ColumnsFilters;
		} // ColumnsFilters

		// Set-метод установки индексированного массива фильтров столбцов.
		// Параметры:
		// parColumnsFilters - индексированный массив фильтров столбцов.
		public function set ColumnsFilters( parColumnsFilters: Array ): void
		{
			// Если индексированный массив фильтров столбцов не изменился,
			// ничего не меняется.
			if ( this._ColumnsFilters == parColumnsFilters )
				return;			
			
			// Индексированный массив фильтров столбцов.
			this._ColumnsFilters = parColumnsFilters;
			
			// Если есть столбцы.
			if ( this._Columns != null )				
				// Просмотр всех столбцов.
				for ( var columnIndex: uint = 0; columnIndex < this._Columns.length;
						columnIndex++ )
					// Если существует текущий столбец.
					if ( this._Columns[ columnIndex ] != null )
						// Установка индексированного массива фильтров текущего столбца.
						this._Columns[ columnIndex ].CellsFilters = parColumnsFilters;
		} // ColumnsFilters		
		
		// Get-метод получения признака получения сообщений мыши столбцами.
		// Результат: признак получения сообщений мыши столбцами.
		public function get ColumnsMouseEnabled( ): Boolean
		{
			// Признак получения сообщений мыши столбцами.
			return this._ColumnsMouseEnabled;
		} // ColumnsMouseEnabled

		// Set-метод установки признака получения сообщений мыши столбцами.
		// Параметры:
		// parColumnsMouseEnabled - признак получения сообщений мыши столбцами.
		public function set ColumnsMouseEnabled
			( parColumnsMouseEnabled: Boolean ): void
		{
			// Если признак получения сообщений мыши столбцами не изменился,
			// ничего не меняется.
			if ( this._ColumnsMouseEnabled == parColumnsMouseEnabled )
				return;			
			
			// Признак получения сообщений мыши столбцами.
			this._ColumnsMouseEnabled = parColumnsMouseEnabled;
			
			// Если есть столбцы.
			if ( this._Columns != null )				
				// Просмотр всех столбцов.
				for ( var columnIndex: uint = 0; columnIndex < this._Columns.length;
						columnIndex++ )
					// Если существует текущий столбец.
					if ( this._Columns[ columnIndex ] != null )
						// Установка признака получения сообщений мыши текущей столбцом.
						this._Columns[ columnIndex ].CellsMouseEnabled =
							parColumnsMouseEnabled;
		} // ColumnsMouseEnabled
		
		// Get-метод получения признака выполнения автоматической прокрути
		// многострочных текстовых полей столбцов при вращении колёски мыши.
		// Результат: признак выполнения автоматической прокрути
		// многострочных текстовых полей столбцов при вращении колёски мыши.
		public function get ColumnsMouseWheelEnabled( ): Boolean
		{
			// Признак выполнения автоматической прокрути
			// многострочных текстовых полей столбцов при вращении колёски мыши.
			return this._ColumnsMouseWheelEnabled;
		} // ColumnsMouseWheelEnabled

		// Set-метод установки признака выполнения автоматической прокрути
		// многострочных текстовых полей столбцов при вращении колёски мыши.
		// Параметры:
		// parColumnsMouseWheelEnabled - признак выполнения
		// автоматической прокрути многострочных текстовых полей столбцов
		// при вращении колёски мыши.
		public function set ColumnsMouseWheelEnabled
			( parColumnsMouseWheelEnabled: Boolean ): void
		{
			// Если признак выполнения автоматической прокрути
			// многострочных текстовых полей столбцов при вращении колёски мыши
			// не изменился, ничего не меняется.
			if ( this._ColumnsMouseWheelEnabled == parColumnsMouseWheelEnabled )
				return;				
			
			// Признак выполнения автоматической прокрути
			// многострочных текстовых полей столбцов при вращении колёски мыши.
			this._ColumnsMouseWheelEnabled = parColumnsMouseWheelEnabled;
			
			// Если есть столбцы.
			if ( this._Columns != null )				
				// Просмотр всех столбцов.
				for ( var columnIndex: uint = 0; columnIndex < this._Columns.length;
						columnIndex++ )
					// Если существует текущий столбец.
					if ( this._Columns[ columnIndex ] != null )
						// Установка признака выполнения автоматической прокрути
						// многострочного текстового поля текущего столбца
						// при вращении колёски мыши.
						this._Columns[ columnIndex ].CellsMouseWheelEnabled =
							parColumnsMouseWheelEnabled;
		} // ColumnsMouseWheelEnabled
		
		// Get-метод получения признака многострочности
		// текстовыйх полей столбцов.
		// Результат: признак многострочности текстовыйх полей столбцов.
		public function get ColumnsAreMultiline( ): Boolean
		{
			// Признак многострочности текстовыйх полей столбцов.
			return this._ColumnsAreMultiline;
		} // ColumnsAreMultiline

		// Set-метод установки признака многострочности
		// текстовыйх полей столбцов.
		// Параметры:
		// parColumnsAreMultiline - признак многострочности
		// текстовыйх полей столбцов.
		public function set ColumnsAreMultiline
			( parColumnsAreMultiline: Boolean ): void
		{
			// Если ппризнак многострочности текстовыйх полей столбцов
			// не изменился, ничего не меняется.
			if ( this._ColumnsAreMultiline == parColumnsAreMultiline )
				return;			
			
			// Признак многострочности текстовыйх полей столбцов.
			this._ColumnsAreMultiline = parColumnsAreMultiline;
			
			// Если есть столбцы.
			if ( this._Columns != null )				
				// Просмотр всех столбцов.
				for ( var columnIndex: uint = 0; columnIndex < this._Columns.length;
						columnIndex++ )
					// Если существует текущий столбец.
					if ( this._Columns[ columnIndex ] != null )
						// Установка признака многострочности
						// текстового поля текущего столбца.
						this._Columns[ columnIndex ].CellsAreMultiline =
							parColumnsAreMultiline;
		} // ColumnsAreMultiline
		
		// Get-метод получения признака наличия возможности
		// выборра текстовыйх полей столбцов.
		// Результат: признак наличия возможности
		// выборра текстовыйх полей столбцов.
		public function get ColumnsAreSelectable( ): Boolean
		{
			// Признак наличия возможности выборра текстовыйх полей столбцов.
			return this._ColumnsAreSelectable;
		} // ColumnsAreSelectable

		// Set-метод установки признака наличия возможности
		// выборра текстовыйх полей столбцов.
		// Параметры:
		// parColumnsAreSelectable - признак наличия возможности
		// выборра текстовыйх полей столбцов.
		public function set ColumnsAreSelectable
			( parColumnsAreSelectable: Boolean ): void
		{
			// Если признак наличия возможности выборра текстовыйх полей столбцов
			// не изменился, ничего не меняется.
			if ( this._ColumnsAreSelectable == parColumnsAreSelectable )
				return;			
			
			// Признак наличия возможности выборра текстовыйх полей столбцов.
			this._ColumnsAreSelectable = parColumnsAreSelectable;
			
			// Если есть столбцы.
			if ( this._Columns != null )				
				// Просмотр всех столбцов.
				for ( var columnIndex: uint = 0; columnIndex < this._Columns.length;
						columnIndex++ )
					// Если существует текущий столбец.
					if ( this._Columns[ columnIndex ] != null )
						// Установка признака наличия возможности выборра
						// текстового поля текущего столбца.
						this._Columns[ columnIndex ].CellsAreSelectable =
							parColumnsAreSelectable;
		} // ColumnsAreSelectable		
		
		// Get-метод получения признака влючения столбцов
		// в последовательность перехода с помощью клавиши Tab.
		// Результат: признак влючения столбцов
		// в последовательность перехода с помощью клавиши Tab.
		public function get ColumnsTabEnabled( ): Boolean
		{
			// Признак влючения столбцов в последовательность перехода
			// с помощью клавиши Tab.
			return this._ColumnsTabEnabled;
		} // ColumnsTabEnabled

		// Set-метод установки признака влючения столбцов
		// в последовательность перехода с помощью клавиши Tab.
		// Параметры:
		// parColumnsTabEnabled - признак влючения столбцов
		// в последовательность перехода с помощью клавиши Tab.
		public function set ColumnsTabEnabled
			( parColumnsTabEnabled: Boolean ): void
		{
			// Если признак влючения столбцов в последовательность перехода
			// с помощью клавиши Tab не изменился, ничего не меняется.
			if ( this._ColumnsTabEnabled == parColumnsTabEnabled )
				return;			
			
			// Признак влючения столбцов в последовательность перехода
			// с помощью клавиши Tab.
			this._ColumnsTabEnabled = parColumnsTabEnabled;
			
			// Если есть столбцы.
			if ( this._Columns != null )				
				// Просмотр всех столбцов.
				for ( var columnIndex: uint = 0; columnIndex < this._Columns.length;
						columnIndex++ )
					// Если существует текущий столбец.
					if ( this._Columns[ columnIndex ] != null )
						// Установка признака влючения текущего столбца
						// в последовательность перехода с помощью клавиши Tab.
						this._Columns[ columnIndex ].CellsTabEnabled =
							parColumnsTabEnabled;
		} // ColumnsTabEnabled
		
		// Get-метод получения цвета текста в текстовых полях столбцов.
		// Результат: цвет текста в текстовых полях столбцов.
		public function get ColumnsTextColor( ): uint
		{
			// Цвет текста в текстовых полях столбцов.
			return this._ColumnsTextColor;
		} // ColumnsTextColor

		// Set-метод установки цвета текста в текстовых полях столбцов.
		// Параметры:
		// parColumnsTextColor - цвет текста в текстовых полях столбцов.
		public function set ColumnsTextColor( parColumnsTextColor: uint ): void
		{
			// Если цвет текста в текстовых полях столбцов не изменился,
			// ничего не меняется.
			if ( this._ColumnsTextColor == parColumnsTextColor )
				return;			
			
			// Цвет текста в текстовых полях столбцов.
			this._ColumnsTextColor = parColumnsTextColor;
			
			// Если есть столбцы.
			if ( this._Columns != null )				
				// Просмотр всех столбцов.
				for ( var columnIndex: uint = 0; columnIndex < this._Columns.length;
						columnIndex++ )
					// Если существует текущий столбец.
					if ( this._Columns[ columnIndex ] != null )
						// Установка цвета текста в текстовом поле текущего столбца.
						this._Columns[ columnIndex ].CellsTextColor =
							parColumnsTextColor;
		} // ColumnsTextColor
		
		// Get-метод получения типа текстовых полей столбцов.
		// Результат: тип текстовых полей столбцов.
		public function get ColumnsType( ): String
		{
			// Тип текстовых полей столбцов.
			return this._ColumnsType;
		} // ColumnsType

		// Set-метод установки типа текстовых полей столбцов.
		// Параметры:
		// parColumnsType - тип текстовых полей столбцов.
		public function set ColumnsType( parColumnsType: String ): void
		{
			// Если тип текстовых полей столбцов не изменился, ничего не меняется.
			if ( this._ColumnsType == parColumnsType )
				return;			
			
			// Тип текстовых полей столбцов.
			this._ColumnsType = parColumnsType;
			
			// Если есть столбцы.
			if ( this._Columns != null )				
				// Просмотр всех столбцов.
				for ( var columnIndex: uint = 0; columnIndex < this._Columns.length;
						columnIndex++ )
					// Если существует текущий столбец.
					if ( this._Columns[ columnIndex ] != null )
						// Установка типа текстового поля текущего столбца.
						this._Columns[ columnIndex ].CellsType = parColumnsType;
		} // ColumnsType
		
		// Get-метод получения признака видимости столбцов.
		// Результат: признак видимости столбцов.
		public function get ColumnsAreVisible( ): Boolean
		{
			// Признак видимости столбцов.
			return this._ColumnsAreVisible;
		} // ColumnsAreVisible

		// Set-метод установки признака видимости столбцов.
		// Параметры:
		// parColumnsAreVisible - признак видимости столбцов.
		public function set ColumnsAreVisible
			( parColumnsAreVisible: Boolean ): void
		{
			// Если признак видимости столбцов не изменился, ничего не меняется.
			if ( this._ColumnsAreVisible == parColumnsAreVisible )
				return;			
			
			// Признак видимости столбцов.
			this._ColumnsAreVisible = parColumnsAreVisible;
			
			// Если есть столбцы.
			if ( this._Columns != null )				
				// Просмотр всех столбцов.
				for ( var columnIndex: uint = 0; columnIndex < this._Columns.length;
						columnIndex++ )
					// Если существует текущий столбец.
					if ( this._Columns[ columnIndex ] != null )
						// Установка признака видимости текущего столбца.
						this._Columns[ columnIndex ].CellsAreVisible =
							parColumnsAreVisible;
		} // ColumnsAreVisible
		
		// Get-метод получения признака применения переноса по словам
		// к текстовым полям столбцов.
		// Результат: признак применения переноса по словам
		// к текстовым полям столбцов.
		public function get ColumnsHaveWordWrap( ): Boolean
		{
			// Признак применения переноса по словам к текстовым полям столбцов.
			return this._ColumnsHaveWordWrap;
		} // ColumnsHaveWordWrap

		// Set-метод установки признака применения переноса по словам
		// к текстовым полям столбцов.
		// Параметры:
		// parColumnsHaveWordWrap - признак применения переноса по словам
		// к текстовым полям столбцов.
		public function set ColumnsHaveWordWrap
			( parColumnsHaveWordWrap: Boolean ): void
		{
			// Если признак применения переноса по словам
			// к текстовым полям столбцов не изменился, ничего не меняется.
			if ( this._ColumnsHaveWordWrap == parColumnsHaveWordWrap )
				return;			
			
			// Признак применения переноса по словам к текстовым полям столбцов.
			this._ColumnsHaveWordWrap = parColumnsHaveWordWrap;
			
			// Если есть столбцы.
			if ( this._Columns != null )				
				// Просмотр всех столбцов.
				for ( var columnIndex: uint = 0; columnIndex < this._Columns.length;
						columnIndex++ )
					// Если существует текущий столбец.
					if ( this._Columns[ columnIndex ] != null )
						// Установка признака применения переноса по словам
						// к текстовому полю текущего столбца.
						this._Columns[ columnIndex ].CellsHaveWordWrap =
							parColumnsHaveWordWrap;
		} // ColumnsHaveWordWrap
	} // TextFieldsGrid
} // nijanus.display