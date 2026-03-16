// CustomerDesktop
// Author Kate Kotova
// NIJANUS Copyright © 2004-2010
// nijanus@ymail.com
// http://nijanus.narod2.ru
//---------------------------------------------------------------------------
// Пакет классов рабочего стола покупателя, взаимодействующих с PHP и MySQL
// для выбора имён изображений.
package nijanus.customerDesktop.phpAndMySQL.imagesNamesSelector
{
	// Список импортированных классов из других пакетов.
	import nijanus.php.mySQL.MySQLDataSelector;
	//-------------------------------------------------------------------------
	
	// Класс выборщика артикулов изображений из таблиц MySQL.
	public class MySQLImagesArticlesSelector extends MySQLDataSelector
	{
		// Список импортированных классов из других пакетов.
		
		import flash.net.URLVariables;
		import nijanus.php.mySQL.MySQLConnectionAttributes;
		import nijanus.utils.Tracer;
		//-----------------------------------------------------------------------
		// Статические константы.
		
		// Имя класса.
		public static const CLASS_NAME: String = "MySQLImagesArticlesSelector";	
		//-----------------------------------------------------------------------
		// Переменные экземпляра класса.
		
		// Имя таблицы розничных товаров.
		public var RetailGoodsTableName:                  String = null;
		// Имя столбца идентивикаторов номенклатур в таблице розничных товаров.
		public var RetailGoodsNomenclaturesIDsColumnName: String = null;
		// Имя столбца количеств в таблице розничных товаров.
		public var RetailGoodsCountsColumnName:           String = null;
	
		// Имя таблицы номенклатур.
		public var NomenclaturesTableName:          String = null;
		// Имя столбца идентивикаторов в таблице номенклатур.
		public var NomenclaturesIDsColumnName:      String = null;
		// Имя столбца артикулов в таблице номенклатур.
		public var NomenclaturesArticlesColumnName: String = null;
	
		// Имя фильтрующего столбца.
		public var FilteringColumnName: String = null;
		// Значение фильтра.
		public var FilterValue:         Object = null;
	
		// Имя упорядочивающего столбца.
		public var OrderingColumnName: String  = null;
		// Направление упорядочения:
		// true - упорядочение по возрастанию упорядочивающего столбца,
		// false - упорядочение по убыванию упорядочивающего столбца.
		public var OrderingAscentSign: Boolean = true;
		//-----------------------------------------------------------------------
		// Методы-конструкторы.

		// Метод-конструктор экземпляра
		// выборщика артикулов изображений из таблиц MySQL.
		// Параметры:
		// parConnectionAttributes - атрибуты соединения с базой данных MySQL,
		// parRequestPHPFileURL    - URL-адрес PHP-файла запроса
		//   к базе данных MySQL,
		// parMainTracer           - основной трассировщик.
		public function MySQLImagesArticlesSelector
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
				( MySQLImagesArticlesSelector.CLASS_NAME, parConnectionAttributes,
				parRequestPHPFileURL, parMainTracer );			
		} // MySQLImagesArticlesSelector
		//-----------------------------------------------------------------------			
		// Get- и set-методы.
		
		// Get-метод получения массива-результата выполненного запроса
		// к базе данных MySQL.
		// Результат: массива-результат выполненного запроса к базе данных MySQL.
		override public function get RequestArrayResult( ): Array
		{
			// Результат выполненного запроса к базе данных MySQL возвращается
			// в формате XML следующего вида:
			// <{$parNomenclaturesTableName}>
			//     <Row>
			//         <{$parNomenclaturesArticlesColumnName}>
			//             $mySQLQueryFetch
			//             [ $parNomenclaturesArticlesColumnName ][ 0 ]
			//         </{$parNomenclaturesArticlesColumnName}>
			//     </Row>
			//     <Row>
			//         <{$parNomenclaturesArticlesColumnName}>
			//             $mySQLQueryFetch
			//             [ $parNomenclaturesArticlesColumnName ][ 0 ]
			//         </{$parNomenclaturesArticlesColumnName}>
			//     </Row>
			//     . . .
			// </{$parNomenclaturesTableName}>
			
			// Массив-результат выполненного запроса к базе данных MySQL.
			var requestArrayResult: Array = new Array
				( this._RequestXMLResult.children( ).length( ) );
			
			// Последовательный просмотр всех дочерних элементов -
			// строк, именованных как "Row" -
			// XML-результата выполненного запроса к базе данных MySQL.
			for ( var requestXMLResultRowIndex: uint = 0;
					requestXMLResultRowIndex <
					this._RequestXMLResult.children( ).length( );
					requestXMLResultRowIndex++ )
				// Запись очередного
				// дочернего элемента - столбца артикулов в таблице номенклатур -
				// дочернего элемента - строки -
				// XML-результата выполненного запроса к базе данных MySQL в массив.			
				requestArrayResult[ requestXMLResultRowIndex ] =
					this._RequestXMLResult.Row[ requestXMLResultRowIndex ].
					child( this.NomenclaturesArticlesColumnName )[ 0 ];
					
			// Получение свойства класса.
			this._MainTracer.SetClassPropertie
				( MySQLImagesArticlesSelector.CLASS_NAME, "RequestArrayResult",
				requestArrayResult );					

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
			
			// Имя таблицы розничных товаров.
			requestPHPFileURLVariables.RetailGoodsTableName                  =
				this.RetailGoodsTableName;
			// Имя столбца идентивикаторов номенклатур в таблице розничных товаров.
			requestPHPFileURLVariables.RetailGoodsNomenclaturesIDsColumnName =
				this.RetailGoodsNomenclaturesIDsColumnName;
			// Имя столбца количеств в таблице розничных товаров.
			requestPHPFileURLVariables.RetailGoodsCountsColumnName           =
				this.RetailGoodsCountsColumnName;
		
			// Имя таблицы номенклатур.
			requestPHPFileURLVariables.NomenclaturesTableName          =
				this.NomenclaturesTableName;
			// Имя столбца идентивикаторов в таблице номенклатур.
			requestPHPFileURLVariables.NomenclaturesIDsColumnName      =
				this.NomenclaturesIDsColumnName;
			// Имя столбца артикулов в таблице номенклатур.
			requestPHPFileURLVariables.NomenclaturesArticlesColumnName =
				this.NomenclaturesArticlesColumnName;
		
			// Имя фильтрующего столбца.
			requestPHPFileURLVariables.FilteringColumnName =
				this.FilteringColumnName;
			// Значение фильтра.
			requestPHPFileURLVariables.FilterValue         = this.FilterValue;
		
			// Имя упорядочивающего столбца.
			requestPHPFileURLVariables.OrderingColumnName =
				this.OrderingColumnName;
			// Направление упорядочения:
			// если true, то 1, если false, то 0.
			if ( this.OrderingAscentSign )
				requestPHPFileURLVariables.OrderingAscentSign = 1;
			else
				requestPHPFileURLVariables.OrderingAscentSign = 0;				
			
			// URL-переменные PHP-файла запроса к базе данных MySQL.
			return requestPHPFileURLVariables;
		} // RequestPHPFileURLVariables	
	} // MySQLImagesArticlesSelector
} // nijanus.customerDesktop.phpAndMySQL.imagesNamesSelector