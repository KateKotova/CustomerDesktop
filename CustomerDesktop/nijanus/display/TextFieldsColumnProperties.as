// CustomerDesktop
// Author Kate Kotova
// NIJANUS Copyright © 2004-2010
// nijanus@ymail.com
// http://nijanus.narod2.ru
//---------------------------------------------------------------------------
// Пакет классов, связанных с отображением.
package nijanus.display
{
	// Класс свойств столбца текстовых полей.
	public class TextFieldsColumnProperties
	{
		// Список импортированных классов из других пакетов.
		
		import flash.text.TextFieldType;		
		import flash.text.TextFormat;		
		//-----------------------------------------------------------------------
		// Переменные экземпляра класса.
		
		// Формат текста ячеек по умолчанию.
		public var CellsDefaultTextFormat:    TextFormat = new TextFormat( );	
		// Высота ячейки: если она определена, то все ячейки имеют такую высоту,
		// иначе высота ячеек может быть разной.
		public var CellHeight: Number = TextFieldsColumn.CELL_DEFAULT_HEIGHT;
		// Признак многострочности текстовыйх полей ячеек.
		public var CellsAreMultiline:         Boolean    = false;	
		// Признак применения переноса по словам к текстовым полям ячеек.
		public var CellsHaveWordWrap:         Boolean    = false;
		// Тип текстовых полей ячеек.
		public var CellsType:                 String     = TextFieldType.DYNAMIC;
		// Признак выделения ячеек серым цветом при отсутствии фокуса.
		public var AlwaysShowCellsSelections: Boolean    = false;	
		// Признак наличия возможности выборра текстовыйх полей ячеек.
		public var CellsAreSelectable:        Boolean    = true;	
		// Признак влючения ячеек в последовательность перехода
		// с помощью клавиши Tab.
		public var CellsTabEnabled:           Boolean    = false;
		// Признак выполнения автоматической прокрути
		// многострочных текстовых полей ячеек при вращении колёски мыши.
		public var CellsMouseWheelEnabled:    Boolean    = true;	
		// Признак получения сообщений мыши ячейками.
		public var CellsMouseEnabled:         Boolean    = true;
		// Признак наличия рамки у ячеек.
		public var CellsHaveBorder:           Boolean    = false;
		// Цвет рамки ячеек.
		public var CellsBorderColor:          uint       = 0x000000;	
		// Признак использования фоновой заливки в ячейках.
		public var CellsHaveBackground:       Boolean    = false;
		// Цвет фона ячеек.
		public var CellsBackgroundColor:      uint       = 0xFFFFFF;
		// Значение альфа-прозрачности ячеек.
		public var CellsAlpha:                Number     = 1;	
		// Индексированный массив фильтров ячеек.
		public var CellsFilters:              Array      = null;		
		// Цвет текста в текстовых полях ячеек.
		public var CellsTextColor:            uint       = 0x000000;
		// Признак видимости ячеек.
		public var CellsAreVisible:           Boolean    = true;
		//-----------------------------------------------------------------------
		// Методы-конструкторы.
		
		// Метод-конструктор экземпляра свойств столбца текстовых полей.
		public function GlowButtonParameters( )
		{
		} // TextFieldsColumnProperties		
	} // TextFieldsColumnProperties
} // nijanus.display