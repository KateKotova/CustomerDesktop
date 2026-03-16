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
		
	// Класс выборщика цен разновидностей дисков из таблиц MySQL.
	public class MySQLDiskVarietiesCostsSelector extends MySQLDataSelector
	{
		// Список импортированных классов из других пакетов.
		
		import flash.net.URLVariables;
		import nijanus.php.mySQL.MySQLConnectionAttributes;
		import nijanus.utils.Tracer;
		//-----------------------------------------------------------------------
		// Статические константы.
		
		// Имя класса.
		public static const CLASS_NAME: String =
			"MySQLDiskVarietiesCostsSelector";		
		//-----------------------------------------------------------------------		
		// Переменные экземпляра класса.
		
		// Имя таблицы розничных товаров.
		public var RetailGoodsTableName:                  String = null;
		// Имя столбца идентивикаторов номенклатур в таблице розничных товаров.
		public var RetailGoodsNomenclaturesIDsColumnName: String = null;
		// Имя столбца количеств в таблице розничных товаров.
		public var RetailGoodsCountsColumnName:           String = null;		
		// Имя столбца цен в таблице розничных товаров.
		public var RetailGoodsCostsColumnName:            String = null;
		
		// Имя столбца в таблице розничных товаров, упорядочивающего цены.
		public var RetailGoodsCostsOrderingColumnName:    String  = null;
		// Направление упорядочения цен в таблице розничных товаров:
		// true - упорядочение по возрастанию упорядочивающего столбца,
		// false - упорядочение по убыванию упорядочивающего столбца.		
		public var RetailGoodsCostsOrderingAscendantSign: Boolean = true;
	
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
		// выборщика цен разновидностей дисков из таблиц MySQL.
		// Параметры:
		// parConnectionAttributes - атрибуты соединения с базой данных MySQL,
		// parRequestPHPFileURL    - URL-адрес PHP-файла запроса
		//   к базе данных MySQL,
		// parMainTracer           - основной трассировщик.
		public function MySQLDiskVarietiesCostsSelector
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
				( MySQLDiskVarietiesCostsSelector.CLASS_NAME,
				parConnectionAttributes, parRequestPHPFileURL, parMainTracer );			
		} // MySQLDiskVarietiesCostsSelector
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
			//         <{$parRetailGoodsCostsColumnName}0>
			//             $mySQLQueryFetch[ $parRetailGoodsCostsColumnName ][ 0 ]
			//         </{$parRetailGoodsCostsColumnName}0>
			//         <{$parRetailGoodsCostsColumnName}1>
			//             $mySQLQueryFetch[ $parRetailGoodsCostsColumnName ][ 1 ]
			//         </{$parRetailGoodsCostsColumnName}1>
			//         . . .			
			//     </Row>
			// </{$parRetailGoodsTableName}>
			
			// Количество стоимостей.
			var costsCount:         uint  =
				this._RequestXMLResult.Row[ 0 ].children( ).length( );			
			// Массив-результат выполненного запроса к базе данных MySQL.
			var requestArrayResult: Array = new Array( costsCount );
				
			// Последовательный просмотр всех столбцов цен c индексами стоимостей
			// в таблице розничных товаров.
			for ( var costIndex: uint = 0; costIndex < costsCount; costIndex++ )
				// Запись очередного
				// дочернего элемента - столбца цен в таблице
				//   розничных товаров c индеком стоимости -
				// дочернего элемента - строки             -
				// XML-результата выполненного запроса к базе данных MySQL в массив.		
				requestArrayResult[ costIndex ] =
					this._RequestXMLResult.Row[ 0 ].child
					( this.RetailGoodsCostsColumnName +	costIndex.toString( ) )[ 0 ];
					
			// Получение свойства класса.
			this._MainTracer.SetClassPropertie
				( MySQLDiskVarietiesCostsSelector.CLASS_NAME, "RequestArrayResult",
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
			// Имя столбца цен в таблице розничных товаров.
			requestPHPFileURLVariables.RetailGoodsCostsColumnName            =
				this.RetailGoodsCostsColumnName;

			// Имя столбца в таблице розничных товаров, упорядочивающего цены.
			requestPHPFileURLVariables.RetailGoodsCostsOrderingColumnName =
				this.RetailGoodsCostsOrderingColumnName;
			// Направление упорядочения цен в таблице розничных товаров:
			// если true, то 1, если false, то 0.
			if ( this.RetailGoodsCostsOrderingAscendantSign )
				requestPHPFileURLVariables.RetailGoodsCostsOrderingAscendantSign = 1;
			else
				requestPHPFileURLVariables.RetailGoodsCostsOrderingAscendantSign = 0;				
				
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
	} // MySQLDiskVarietiesCostsSelector
} // nijanus.customerDesktop.phpAndMySQL