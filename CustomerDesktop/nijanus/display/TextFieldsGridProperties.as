// CustomerDesktop
// Author Kate Kotova
// NIJANUS Copyright © 2004-2010
// nijanus@ymail.com
// http://nijanus.narod2.ru
//---------------------------------------------------------------------------
// Пакет классов, связанных с отображением.
package nijanus.display
{
	// Класс свойств сетки текстовых полей.
	public class TextFieldsGridProperties
	{
		// Список импортированных классов из других пакетов.
		
		import flash.text.TextFieldType;		
		import flash.text.TextFormat;		
		//-----------------------------------------------------------------------
		// Переменные экземпляра класса.
		
		// Формат текста столбцов по умолчанию.
		public var ColumnsDefaultTextFormat:    TextFormat = new TextFormat( );
		// Высота строки.
		public var RowHeight:   Number = TextFieldsColumn.CELL_DEFAULT_HEIGHT;
		// Признак многострочности текстовыйх полей столбцов.
		public var ColumnsAreMultiline:         Boolean    = false;	
		// Признак применения переноса по словам к текстовым полям столбцов.
		public var ColumnsHaveWordWrap:         Boolean    = false;	
		// Тип текстовых полей столбцов.
		public var ColumnsType: String = TextFieldType.DYNAMIC;
		// Признак выделения столбцов серым цветом при отсутствии фокуса.
		public var AlwaysShowColumnsSelections: Boolean    = false;	
		// Признак наличия возможности выборра текстовыйх полей столбцов.
		public var ColumnsAreSelectable:        Boolean    = true;	
		// Признак влючения столбцов в последовательность перехода
		// с помощью клавиши Tab.
		public var ColumnsTabEnabled:           Boolean    = false;
		// Признак выполнения автоматической прокрути
		// многострочных текстовых полей столбцов при вращении колёски мыши.
		public var ColumnsMouseWheelEnabled:    Boolean    = true;	
		// Признак получения сообщений мыши столбцами.
		public var ColumnsMouseEnabled:         Boolean    = true;
		// Признак наличия рамки у столбцов.
		public var ColumnsHaveBorder:           Boolean    = false;
		// Цвет рамки столбцов.
		public var ColumnsBorderColor:          uint       = 0x000000;
		// Признак использования фоновой заливки в столбцах.
		public var ColumnsHaveBackground:       Boolean    = false;
		// Цвет фона столбцов.
		public var ColumnsBackgroundColor:      uint       = 0xFFFFFF;
		// Значение альфа-прозрачности столбцов.
		public var ColumnsAlpha:                Number     = 1;
		// Индексированный массив фильтров столбцов.
		public var ColumnsFilters:              Array      = null;		
		// Цвет текста в текстовых полях столбцов.
		public var ColumnsTextColor:            uint       = 0x000000;
		// Признак видимости столбцов.
		public var ColumnsAreVisible:           Boolean    = true;	
		//-----------------------------------------------------------------------
		// Методы-конструкторы.
		
		// Метод-конструктор экземпляра свойств сетки текстовых полей.
		public function TextFieldsGridProperties( )
		{
		} // TextFieldsGridProperties		
	} // TextFieldsGridProperties
} // nijanus.display