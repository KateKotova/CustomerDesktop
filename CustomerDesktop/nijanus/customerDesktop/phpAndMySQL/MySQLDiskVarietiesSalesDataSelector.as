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
		
	// Класс выборщика данных продаж разновидностей дисков из таблиц MySQL.
	public class MySQLDiskVarietiesSalesDataSelector extends MySQLDataSelector
	{
		// Список импортированных классов из других пакетов.
		
		import flash.net.URLVariables;
		import nijanus.php.mySQL.MySQLConnectionAttributes;
		import nijanus.utils.Tracer;
		//-----------------------------------------------------------------------
		// Статические константы.
		
		// Имя класса.
		public static const CLASS_NAME: String =
			"MySQLDiskVarietiesSalesDataSelector";		
		//-----------------------------------------------------------------------		
		// Переменные экземпляра класса.
		
		// Имя таблицы розничных товаров.
		public var RetailGoodsTableName:                   String = null;
		// Имя столбца идентивикаторов номенклатур в таблице розничных товаров.
		public var RetailGoodsNomenclaturesIDsColumnName:  String = null;
		// Имя столбца идентивикаторов разновидностей дисков
		// в таблице розничных товаров.
		public var RetailGoodsDisksVarietiesIDsColumnName: String = null;	
		// Имя столбца цен в таблице розничных товаров.
		public var RetailGoodsCostsColumnName:             String = null;	
		// Имя столбца номеров ячеек в таблице розничных товаров.
		public var RetailGoodsCellsNumbersColumnName:      String = null;		
	
		// Имя столбца в таблице розничных товаров,
		// упорядочивающего данные продаж.
		public var RetailGoodsSalesDataOrderingColumnName:    String  = null;
		// Направление упорядочения данных продаж в таблице розничных товаров:
		// true - упорядочение по возрастанию упорядочивающего столбца,
		// false - упорядочение по убыванию упорядочивающего столбца.		
		public var RetailGoodsSalesDataOrderingAscendantSign: Boolean = true;
	
		// Имя таблицы номенклатур.
		public var NomenclaturesTableName:          String = null;
		// Имя столбца идентивикаторов в таблице номенклатур.
		public var NomenclaturesIDsColumnName:      String = null;
		// Имя столбца артикулов в таблице номенклатур.
		public var NomenclaturesArticlesColumnName: String = null;
		// Значение артикула изображения.
		public var ImageArticleValue:               String = null;
		
		// Имя таблицы ссылок разновидностей дисков.
		public var DisksVarietiesReferencesTableName: String = null;
		// Имя столбца идентивикаторов номенклатур
		// в таблице ссылок разновидностей дисков.
		public var DisksVarietiesReferencesNomenclaturesIDsColumnName:
			String = null;
		// Имя столбца идентивикаторов характеристик разновидностей дисков
		// в таблице ссылок разновидностей дисков.
		public var
			DisksVarietiesReferencesDisksVarietiesCharacteristicsIDsColumnName:
			String = null;			
		// Имя столбца в таблице ссылок разновидностей дисков,
		// упорядочивающего характеристики разновидностей дисков.
		public var DisksVarietiesReferencesCharacteristicsOrderingColumnName:
			String = null;
			
		// Имя таблицы характеристик разновидностей дисков.
		public var DisksVarietiesCharacteristicsTableName: String = null;
		// Имя столбца идентификаторов
		// в таблице характеристик разновидностей дисков.
		public var DisksVarietiesCharacteristicsIDsColumnName: String = null;
		//-----------------------------------------------------------------------
		// Методы-конструкторы.

		// Метод-конструктор экземпляра
		// выборщика данных продаж разновидностей дисков из таблиц MySQL.
		// Параметры:
		// parConnectionAttributes - атрибуты соединения с базой данных MySQL,
		// parRequestPHPFileURL    - URL-адрес PHP-файла запроса
		//   к базе данных MySQL,
		// parMainTracer           - основной трассировщик.
		public function MySQLDiskVarietiesSalesDataSelector
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
				( MySQLDiskVarietiesSalesDataSelector.CLASS_NAME,
				parConnectionAttributes, parRequestPHPFileURL, parMainTracer );			
		} // MySQLDiskVarietiesSalesDataSelector
		//-----------------------------------------------------------------------			
		// Get- и set-методы.
		
		// Get-метод получения массива-результата выполненного запроса
		// к базе данных MySQL.
		// Результат: массива-результат выполненного запроса к базе данных MySQL.
		override public function get RequestArrayResult( ): Array
		{
			// Результат выполненного запроса к базе данных MySQL возвращается
			// в формате XML следующего вида:
			// <{$parRetailGoodsTableName}>
			//     <Row>
			//         <{$parRetailGoodsNomenclaturesIDsColumnName}>
			//             $mySQLQueryFetch
			//                 [ $parRetailGoodsNomenclaturesIDsColumnName ][ 0 ]
			//         </{$parRetailGoodsNomenclaturesIDsColumnName}>
			//
			//         <{$parRetailGoodsDisksVarietiesIDsColumnName}>
			//             $mySQLQueryFetch
			//                 [ $parRetailGoodsDisksVarietiesIDsColumnName ][ 0 ]
			//         </{$parRetailGoodsDisksVarietiesIDsColumnName}>
			//
			//         <{$parRetailGoodsCostsColumnName}>
			//             $mySQLQueryFetch[ $parRetailGoodsCostsColumnName ][ 0 ]
			//         </{$parRetailGoodsCostsColumnName}>	
			//
			//         <{$parRetailGoodsCellsNumbersColumnName}>
			//             $mySQLQueryFetch
			//                 [ $parRetailGoodsCellsNumbersColumnName ][ 0 ]
			//         </{$parRetailGoodsCellsNumbersColumnName}>			
			//     </Row>
			//     . . .			
			// </{$parRetailGoodsTableName}>
			
			// Количество данных продаж разновидностей дисков.
			var diskVarietiesSalesDataCount =
				this._RequestXMLResult.children( ).length( );
			// Массив-результат выполненного запроса к базе данных MySQL.
			var requestArrayResult: Array = new Array
				( diskVarietiesSalesDataCount );
			
			// Последовательный просмотр всех дочерних элементов -
			// строк, именованных как "Row" -
			// XML-результата выполненного запроса к базе данных MySQL.
			for ( var requestXMLResultRowIndex: uint = 0;
					requestXMLResultRowIndex < diskVarietiesSalesDataCount;
					requestXMLResultRowIndex++ )
				// Запись очередных
				// дочерних элементов:
				//   столбца идентивикаторов номенклатур
				//     в таблице розничных товаров,
				//   столбца идентивикаторов разновидностей дисков
				//     в таблице розничных товаров,
				//   столбца цен в таблице розничных товаров,
				//   столбца номеров ячеек в таблице розничных товаров -
				// дочернего элемента - строки -
				// XML-результата выполненного запроса к базе данных MySQL
				// в массив, элементами которого являются экземпляры класса
				// данных продажи разновидности диска.
				requestArrayResult[ requestXMLResultRowIndex ] =
					new DiskVarietySaleData
					(
						// Идентивикатор номенклатуры.
						this._RequestXMLResult.Row[ requestXMLResultRowIndex ].
							child( this.RetailGoodsNomenclaturesIDsColumnName )[ 0 ],
						// Идентивикатор разновидности диска.
						this._RequestXMLResult.Row[ requestXMLResultRowIndex ].
							child( this.RetailGoodsDisksVarietiesIDsColumnName )[ 0 ],
						// Цена.
						this._RequestXMLResult.Row[ requestXMLResultRowIndex ].
							child( this.RetailGoodsCostsColumnName )[ 0 ],
						// Номер ячейки.
						this._RequestXMLResult.Row[ requestXMLResultRowIndex ].
							child( this.RetailGoodsCellsNumbersColumnName )[ 0 ]					
					); // new DiskVarietySaleData
					
			// Получение свойства класса.
			this._MainTracer.SetClassPropertie
				( MySQLDiskVarietiesSalesDataSelector.CLASS_NAME,
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
			
			// Имя таблицы розничных товаров.
			requestPHPFileURLVariables.RetailGoodsTableName                   =
				this.RetailGoodsTableName;
			// Имя столбца идентивикаторов номенклатур в таблице розничных товаров.
			requestPHPFileURLVariables.RetailGoodsNomenclaturesIDsColumnName  =
				this.RetailGoodsNomenclaturesIDsColumnName;
			// Имя столбца идентивикаторов разновидностей дисков
			// в таблице розничных товаров.
			requestPHPFileURLVariables.RetailGoodsDisksVarietiesIDsColumnName =
				this.RetailGoodsDisksVarietiesIDsColumnName;
			// Имя столбца цен в таблице розничных товаров.
			requestPHPFileURLVariables.RetailGoodsCostsColumnName             =
				this.RetailGoodsCostsColumnName;
			// Имя столбца номеров ячеек в таблице розничных товаров.
			requestPHPFileURLVariables.RetailGoodsCellsNumbersColumnName      =
				this.RetailGoodsCellsNumbersColumnName;
				
			// Имя столбца в таблице розничных товаров,
			// упорядочивающего данные продаж.
			requestPHPFileURLVariables.RetailGoodsSalesDataOrderingColumnName =
				this.RetailGoodsSalesDataOrderingColumnName;
			// Направление упорядочения данных продаж в таблице розничных товаров:
			// если true, то 1, если false, то 0.
			if ( this.RetailGoodsSalesDataOrderingAscendantSign )
				requestPHPFileURLVariables.
					RetailGoodsSalesDataOrderingAscendantSign = 1;
			else
				requestPHPFileURLVariables.
					RetailGoodsSalesDataOrderingAscendantSign = 0;				
				
			// Имя таблицы номенклатур.
			requestPHPFileURLVariables.NomenclaturesTableName          =
				this.NomenclaturesTableName;
			// Имя столбца идентивикаторов в таблице номенклатур.
			requestPHPFileURLVariables.NomenclaturesIDsColumnName      =
				this.NomenclaturesIDsColumnName;
			// Имя столбца артикулов в таблице номенклатур.
			requestPHPFileURLVariables.NomenclaturesArticlesColumnName =
				this.NomenclaturesArticlesColumnName;
			// Значение артикула изображения.
			requestPHPFileURLVariables.ImageArticleValue = this.ImageArticleValue;
			
			// Имя таблицы ссылок разновидностей дисков.
			requestPHPFileURLVariables.DisksVarietiesReferencesTableName         =
				this.DisksVarietiesReferencesTableName;
			// Имя столбца идентивикаторов номенклатур
			// в таблице ссылок разновидностей дисков.
			requestPHPFileURLVariables.
				DisksVarietiesReferencesNomenclaturesIDsColumnName                 =
				this.DisksVarietiesReferencesNomenclaturesIDsColumnName;
			// Имя столбца идентивикаторов характеристик разновидностей дисков
			// в таблице ссылок разновидностей дисков.
			requestPHPFileURLVariables.
				DisksVarietiesReferencesDisksVarietiesCharacteristicsIDsColumnName =
		this.DisksVarietiesReferencesDisksVarietiesCharacteristicsIDsColumnName;
			// Имя столбца в таблице ссылок разновидностей дисков,
			// упорядочивающего характеристики разновидностей дисков.
			requestPHPFileURLVariables.
				DisksVarietiesReferencesCharacteristicsOrderingColumnName          =
				this.DisksVarietiesReferencesCharacteristicsOrderingColumnName;
				
			// Имя таблицы характеристик разновидностей дисков.
			requestPHPFileURLVariables.DisksVarietiesCharacteristicsTableName     =
				this.DisksVarietiesCharacteristicsTableName;
			// Имя столбца идентификаторов
			// в таблице характеристик разновидностей дисков.
			requestPHPFileURLVariables.DisksVarietiesCharacteristicsIDsColumnName =
				this.DisksVarietiesCharacteristicsIDsColumnName;
			
			// URL-переменные PHP-файла запроса к базе данных MySQL.
			return requestPHPFileURLVariables;
		} // RequestPHPFileURLVariables	
	} // MySQLDiskVarietiesSalesDataSelector
} // nijanus.customerDesktop.phpAndMySQL