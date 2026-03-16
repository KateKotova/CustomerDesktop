// CustomerDesktop
// Author Kate Kotova
// NIJANUS Copyright © 2004-2010
// nijanus@ymail.com
// http://nijanus.narod2.ru
//---------------------------------------------------------------------------
// Пакет классов рабочего стола покупателя, взаимодействующих с PHP и MySQL.
package nijanus.customerDesktop.phpAndMySQL
{
	// Список импортированных классов из других пакетов.
	import nijanus.php.mySQL.MySQLDataSelector;
	//-------------------------------------------------------------------------
		
	// Класс добавителя данных продажи разновидности диска
	// в корзину покупок в таблицах MySQL.
	public class MySQLDiskVarietySaleDataToShoppingCartAdder
		extends MySQLDataSelector
	{
		// Список импортированных классов из других пакетов.
		
		import flash.net.URLLoaderDataFormat;			
		import flash.net.URLVariables;
		import nijanus.php.mySQL.MySQLConnectionAttributes;
		import nijanus.utils.Tracer;
		//-----------------------------------------------------------------------
		// Статические константы.
		
		// Имя класса.
		public static const CLASS_NAME: String =
			"MySQLDiskVarietySaleDataToShoppingCartAdder";		
		//-----------------------------------------------------------------------			
		// Статические переменные.
		
		// Счётчик загрузок запроса.
		// Он вводится для того, чтобы запрос, даже если его параметры
		// одни и те же, выполнялся каждый раз, а не только впервые,
		// как почему-то происходит обычно.
		private static var _ReqeustLoadingsCounter: uint = 0;
		//-----------------------------------------------------------------------		
		// Переменные экземпляра класса.
		
		// Имя таблицы корзины покупок.
		public var ShoppingCartTableName:     String = null;
		// Имя столбца идентивикаторов в таблице корзины покупок.
		public var ShoppingCartIDsColumnName: String = null;
		
		// Имя столбца идентивикаторов номенклатур в таблице корзины покупок.
		public var ShoppingCartNomenclaturesIDsColumnName:  String = null;
		// Имя столбца идентивикаторов разновидностей дисков
		// в таблице корзины покупок.
		public var ShoppingCartDisksVarietiesIDsColumnName: String = null;
		// Имя столбца цен в таблице корзины покупок.
		public var ShoppingCartCostsColumnName:             String = null;
		// Имя столбца номеров ячеек в таблице корзины покупок.
		public var ShoppingCartCellsNumbersColumnName:      String = null;
		
		// Данные продажи разновидности диска.
		public var SaleData: DiskVarietySaleData = null;
		//-----------------------------------------------------------------------
		// Статические методы.
		
		// Метод инкрементирования счётчика загрузок запроса.
		private static function IncrementReqeustLoadingsCounter( )
		{
			// Если значение счётчика загрузок запроса максимальное.
			if ( MySQLDiskVarietySaleDataToShoppingCartAdder.
					_ReqeustLoadingsCounter == uint.MAX_VALUE )
				// Увеличивать значение счётчика загрузок запроса больше некуда
				// и он обнуляется.
				MySQLDiskVarietySaleDataToShoppingCartAdder.
					_ReqeustLoadingsCounter = 0;
			// Значение счётчика загрузок запроса находится в допустимых пределах.
			else
				// Инкремент счётчика загрузок запроса.
				MySQLDiskVarietySaleDataToShoppingCartAdder.
					_ReqeustLoadingsCounter++;
		} // IncrementReqeustLoadingsCounter		
		//-----------------------------------------------------------------------
		// Методы экземпляра класса.
		
		// Метод загрузки запроса.
		// Параметры:
		// parPHPFileURLLoaderDataFormat - формат загружаемых данных
		//   с URL-адреса PHP-файла.
		override public function LoadRequest
			( parPHPFileURLLoaderDataFormat: String	=
			URLLoaderDataFormat.BINARY ): void
		{
			// Вызов метода класса.
			this._MainTracer.CallClassMethod
				( MySQLDiskVarietySaleDataToShoppingCartAdder.CLASS_NAME,
				"LoadRequest", parPHPFileURLLoaderDataFormat );			
			
			// Инкремент счётчика загрузок запроса. 
			MySQLDiskVarietySaleDataToShoppingCartAdder.
				IncrementReqeustLoadingsCounter( );
			// Вызов метода суперкласса MySQLDataSelector.
			super.LoadRequest( parPHPFileURLLoaderDataFormat );
		} // LoadRequest
		//-----------------------------------------------------------------------
		// Методы-конструкторы.

		// Метод-конструктор экземпляра добавителя данных продажи
		// разновидности диска в корзину покупок в таблицах MySQL.
		// Параметры:
		// parConnectionAttributes - атрибуты соединения с базой данных MySQL,
		// parRequestPHPFileURL    - URL-адрес PHP-файла запроса
		//   к базе данных MySQL,
		// parMainTracer           - основной трассировщик.
		public function MySQLDiskVarietySaleDataToShoppingCartAdder
		(
			parConnectionAttributes: MySQLConnectionAttributes,
			parRequestPHPFileURL:    String,
			parMainTracer:           Tracer
		): void
		{
			// Вызов метода-конструктора суперкласса MySQLDataSelector.
			super( parConnectionAttributes, parRequestPHPFileURL, parMainTracer );
			
			// Создание нового экземпляра класса.
			this._MainTracer.CreateClassNewInstance
				( MySQLDiskVarietySaleDataToShoppingCartAdder.CLASS_NAME,
				parConnectionAttributes, parRequestPHPFileURL, parMainTracer );				
		} // MySQLDiskVarietySaleDataToShoppingCartAdder
		//-----------------------------------------------------------------------			
		// Get- и set-методы.
		
		// Get-метод получения массива-результата выполненного запроса
		// к базе данных MySQL.
		// Результат: массива-результат выполненного запроса к базе данных MySQL.
		override public function get RequestArrayResult( ): Array
		{
			// Результат выполненного запроса к базе данных MySQL возвращается
			// в формате XML следующего вида:
			// <Result>
			//     OK
			// </Result>
			
			// Массив-результат выполненного запроса к базе данных MySQL.
			var requestArrayResult: Array = new Array( 1 );
			// Запись дочернего элемента - результата - 
			// XML-результата выполненного запроса к базе данных MySQL в массив.
			requestArrayResult[ 0 ] = this._RequestXMLResult.children( )[ 0 ];
			
			// Получение свойства класса.
			this._MainTracer.SetClassPropertie
				( MySQLDiskVarietySaleDataToShoppingCartAdder.CLASS_NAME,
				"RequestArrayResult", requestArrayResult );			
			
			// Массив-результат выполненного запроса к базе данных MySQL.
			return requestArrayResult;
		} // RequestArrayResult
		
		// Get-метод получения URL-переменных PHP-файла
		// запроса к базе данных MySQL.
		// Результат: URL-переменные PHP-файла запроса к базе данных MySQL.
		override public function get RequestPHPFileURLVariables( ): URLVariables
		{
			// Создание URL-переменных PHP-файла запроса к базе данных MySQL,
			// осуществляющих передачу данных между приложением и сервером.
			// Вызов get-метода суперкласса MySQLDataSelector.
			var requestPHPFileURLVariables: URLVariables =
				super.RequestPHPFileURLVariables;
			
			// Добавление URL-переменных запроса к базе данных MySQL.
			
			// Счётчик загрузок запроса.
			// Фактически он не задействован в выполнении запроса,
			// но вводится для того, чтобы запрос при неоднократном вызове
			// с одними и теми же параметрыми выполнялся всякий раз,
			// а не только впервые, как почему-то происходит обычно.
			// Таким образом, строки запроса с одинаковыми параметрами 
			// становятся различны, поскольку содержат значения
			// статической переменной счётчика загрузок запроса.
			requestPHPFileURLVariables.Counter =
				MySQLDiskVarietySaleDataToShoppingCartAdder._ReqeustLoadingsCounter;		
			
			// Имя таблицы корзины покупок.
			requestPHPFileURLVariables.ShoppingCartTableName     =
				this.ShoppingCartTableName;
			// Имя столбца идентивикаторов в таблице корзины покупок.
			requestPHPFileURLVariables.ShoppingCartIDsColumnName =
				this.ShoppingCartIDsColumnName;
			
			// Имя столбца идентивикаторов номенклатур в таблице корзины покупок.
			requestPHPFileURLVariables.ShoppingCartNomenclaturesIDsColumnName =
				this.ShoppingCartNomenclaturesIDsColumnName;
			// Значение идентивикатора номенклатуры.
			requestPHPFileURLVariables.NomenclatureIDValue                    =
				this.SaleData.NomenclatureID;
				
			// Имя столбца идентивикаторов разновидностей дисков
			// в таблице корзины покупок.
			requestPHPFileURLVariables.ShoppingCartDisksVarietiesIDsColumnName =
				this.ShoppingCartDisksVarietiesIDsColumnName;
			// Значение идентивикатора разновидности диска.
			requestPHPFileURLVariables.DiskVarietyIDValue                      =
				this.SaleData.DiskVarietyID;
				
			// Имя столбца цен в таблице корзины покупок.
			requestPHPFileURLVariables.ShoppingCartCostsColumnName =
				this.ShoppingCartCostsColumnName;
			// Значение цены.
			requestPHPFileURLVariables.CostValue = this.SaleData.Cost;
				
			// Имя столбца номеров ячеек в таблице корзины покупок.
			requestPHPFileURLVariables.ShoppingCartCellsNumbersColumnName =
				this.ShoppingCartCellsNumbersColumnName;
			// Значение номера ячейки.
			requestPHPFileURLVariables.CellNumberValue = this.SaleData.CellNumber;
			
			// URL-переменные PHP-файла запроса к базе данных MySQL.
			return requestPHPFileURLVariables;
		} // RequestPHPFileURLVariables	
	} // MySQLDiskVarietySaleDataToShoppingCartAdder
} // nijanus.customerDesktop.phpAndMySQL