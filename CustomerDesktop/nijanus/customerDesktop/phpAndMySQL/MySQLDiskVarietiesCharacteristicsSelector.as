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
		
	// Класс выборщика характеристик разновидностей дисков из таблиц MySQL.
	public class MySQLDiskVarietiesCharacteristicsSelector
		extends MySQLDataSelector
	{
		// Список импортированных классов из других пакетов.
		
		import flash.net.URLVariables;
		import nijanus.php.mySQL.MySQLConnectionAttributes;
		import nijanus.utils.Tracer;
		//-----------------------------------------------------------------------
		// Статические константы.
		
		// Имя класса.
		public static const CLASS_NAME: String =
			"MySQLDiskVarietiesCharacteristicsSelector";		
		//-----------------------------------------------------------------------
		// Переменные экземпляра класса.
		
		// Строка-разделитель элементов массивов.
		public var ArraysSeparatorString: String = null;
		
		// Имя таблицы розничных товаров.
		public var RetailGoodsTableName:                   String = null;
		// Имя столбца идентивикаторов номенклатур в таблице розничных товаров.
		public var RetailGoodsNomenclaturesIDsColumnName:  String = null;
		// Имя столбца идентивикаторов разновидностей дисков
		// в таблице розничных товаров.
		public var RetailGoodsDisksVarietiesIDsColumnName: String = null;
		// Имя столбца количеств в таблице розничных товаров.
		public var RetailGoodsCountsColumnName:            String = null;
		
		// Имя таблицы номенклатур.
		public var NomenclaturesTableName:          String = null;
		// Имя столбца идентификаторов в таблице номенклатур.
		public var NomenclaturesIDsColumnName:      String = null;
		// Имя столбца артикулов в таблице номенклатур.
		public var NomenclaturesArticlesColumnName: String = null;
		// Значение артикула изображения.
		public var ImageArticleValue:               String = null;
		
		// Имя таблицы групп товаров.
		public var GoodsGroupsTableName:       String = null;
		// Имя столбца кодов в таблице групп товаров.
		public var GoodsGroupsCodesColumnName: String = null;
		// Значение кода группы диска.
		public var DiskGroupCodeValue:         Object = null;		
		// Имя столбца наименований в таблице групп товаров.
		public var GoodsGroupsNamesColumnName: String = null;
		
		// Имя таблицы ссылок разновидностей дисков.
		public var DisksVarietiesReferencesTableName: String = null;
		// Имя столбца идентификаторов номенклатур
		// в таблице ссылок разновидностей дисков.
		public var DisksVarietiesReferencesNomenclaturesIDsColumnName:
			String = null;
		// Имя столбца идентификаторов характеристик разновидностей дисков
		// в таблице ссылок разновидностей дисков.
		public var
			DisksVarietiesReferencesDisksVarietiesCharacteristicsIDsColumnName:
			String = null;
		// Имя столбца идентивикаторов разновидностей дисков
		// в таблице ссылок разновидностей дисков.
		public var DisksVarietiesReferencesDisksVarietiesIDsColumnName:
			String = null;
			
		// Имя столбца в таблице ссылок разновидностей дисков,
		// упорядочивающего характеристики разновидностей дисков.
		public var DisksVarietiesReferencesCharacteristicsOrderingColumnName:
			String  = null;
		// Направление упорядочения характеристик разновидностей дисков
		// в таблице ссылок разновидностей дисков:
		// true - упорядочение по возрастанию упорядочивающего столбца,
		// false - упорядочение по убыванию упорядочивающего столбца.
		public var DisksVarietiesReferencesCharacteristicsOrderingAscendantSign:
			Boolean = true;
			
		// Имя таблицы названий характеристик дисков.
		public var DisksCharacteristicsNamesTableName: String = null;
		// Имя столбца наименований групп
		// в таблице названий характеристик дисков.
		public var DisksCharacteristicsNamesGroupsNamesColumnName:
			String = null;
		// Строка массива имён столбцов названий
		// в таблице названий характеристик дисков.
		public var DisksCharacteristicsNamesNamesColumnsNamesString:
			String = null;

		// Имя таблицы характеристик разновидностей дисков.
		public var DisksVarietiesCharacteristicsTableName: String = null;
		// Имя столбца идентификаторов
		// в таблице характеристик разновидностей дисков.
		public var DisksVarietiesCharacteristicsIDsColumnName: String = null;
		// Строка массива имён столбцов характеристик
		// в таблице характеристик разновидностей дисков.
		public var
			DisksVarietiesCharacteristicsCharacteristicsColumnsNamesString:
			String = null;
		
		// Основа заголовка разновидности диска.
		public var DiskVarietyCaptionBase: String = null;
		//-----------------------------------------------------------------------
		// Методы-конструкторы.

		// Метод-конструктор экземпляра
		// выборщика характеристик разновидностей дисков из таблиц MySQL.
		// Параметры:
		// parConnectionAttributes - атрибуты соединения с базой данных MySQL,		
		// parRequestPHPFileURL    - URL-адрес PHP-файла запроса
		//   к базе данных MySQL,
		// parMainTracer           - основной трассировщик.
		public function MySQLDiskVarietiesCharacteristicsSelector
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
				( MySQLDiskVarietiesCharacteristicsSelector.CLASS_NAME,
				parConnectionAttributes, parRequestPHPFileURL, parMainTracer );				
		} // MySQLDiskVarietiesCharacteristicsSelector
		//-----------------------------------------------------------------------			
		// Get- и set-методы.
		
		// Get-метод получения массива-результата выполненного запроса
		// к базе данных MySQL.
		// Результат: массива-результат выполненного запроса к базе данных MySQL.
		override public function get RequestArrayResult( ): Array
		{
			// Результат выполненного запроса к базе данных MySQL возвращается
			// в формате XML следующего вида:
			// <DisksVarietiesCharacteristics>
			//     <Row>
			//         <{$diskVarietyCaptionBase}0>
			//             $array[ 0 ][ 1 ]
			//         </{$diskVarietyCaptionBase}0>
			//         <{$diskVarietyCaptionBase}1>
			//             $array[ 1 ][ 1 ]
			//         </{$diskVarietyCaptionBase}1>			
			//         . . .
			//     </Row>
			//     <Row>
			//         <{$diskVarietyCaptionBase}0>
			//             $array[ 0 ][ 2 ]
			//         </{$diskVarietyCaptionBase}0>
			//         <{$diskVarietyCaptionBase}1>
			//             $array[ 1 ][ 2 ]
			//         </{$diskVarietyCaptionBase}1>			
			//         . . .
			//     </Row>		
			//     . . .			
			// </DisksVarietiesCharacteristics>
			
			// Массив-результат выполненного запроса к базе данных MySQL.
			var requestArrayResult: Array = new Array
				( this._RequestXMLResult.children( ).length( ) );
				
			// Массив-результат выполненного запроса к базе данных MySQL
			// представляет собой массив строк, а каждый его элемент -
			// строка - также является массивом значений ячеек таблицы
			// соответствующих им столбцов.			
				
			// Последовательный просмотр всех дочерних элементов -
			// строк, именованных как "Row" -
			// XML-результата выполненного запроса к базе данных MySQL.
			for ( var requestXMLResultRowIndex: uint = 0;
					requestXMLResultRowIndex <
					this._RequestXMLResult.children( ).length( );
					requestXMLResultRowIndex++ )
			{				
				// Количество разновидности диска текущей строки.
				var diskVarietiesCount: uint  = this._RequestXMLResult.
					Row[ requestXMLResultRowIndex ].children( ).length( );			
				// Элемент массива-результата выполненного запроса
				// к базе данных MySQL - строка - массив значений ячеек таблицы.
				requestArrayResult[ requestXMLResultRowIndex ] =
					new Array( diskVarietiesCount );

				// Последовательный просмотр всех столбцов в таблице характеристик.
				for ( var requestXMLResultСolumnIndex: uint = 0;
						requestXMLResultСolumnIndex < diskVarietiesCount;
						requestXMLResultСolumnIndex++ )				
					// Запись очередного
					// дочернего элемента - разновидности диска
					//   c соответствующим индексом -
					// дочернего элемента - строки  -
					// XML-результата выполненного запроса
					// к базе данных MySQL в массив.		
					requestArrayResult[ requestXMLResultRowIndex ]
						[ requestXMLResultСolumnIndex ] =
						this._RequestXMLResult.Row[ requestXMLResultRowIndex ].
						child( this.DiskVarietyCaptionBase +
						requestXMLResultСolumnIndex.toString( ) )[ 0 ];				
			} // for
			
			// Получение свойства класса.
			this._MainTracer.SetClassPropertie
				( MySQLDiskVarietiesCharacteristicsSelector.CLASS_NAME,
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
			
			// Строка-разделитель элементов массивов.
			requestPHPFileURLVariables.ArraysSeparatorString =
				this.ArraysSeparatorString;	
				
			// Имя таблицы розничных товаров.
			requestPHPFileURLVariables.RetailGoodsTN = this.RetailGoodsTableName;
			// Имя столбца идентивикаторов номенклатур в таблице розничных товаров.
			requestPHPFileURLVariables.RetailGoodsNomenclaturesIDsCN  =
				this.RetailGoodsNomenclaturesIDsColumnName;
			// Имя столбца идентивикаторов разновидностей дисков
			// в таблице розничных товаров.
			requestPHPFileURLVariables.RetailGoodsDisksVarietiesIDsCN =
				this.RetailGoodsDisksVarietiesIDsColumnName;
			// Имя столбца количеств в таблице розничных товаров.
			requestPHPFileURLVariables.RetailGoodsCountsCN            =
				this.RetailGoodsCountsColumnName;
				
			// Имя таблицы номенклатур.
			requestPHPFileURLVariables.NomenclaturesTN         =
				this.NomenclaturesTableName;
			// Имя столбца идентификаторов в таблице номенклатур.
			requestPHPFileURLVariables.NomenclaturesIDsCN      =
				this.NomenclaturesIDsColumnName;
			// Имя столбца артикулов в таблице номенклатур.
			requestPHPFileURLVariables.NomenclaturesArticlesCN =
				this.NomenclaturesArticlesColumnName;
			// Значение артикула изображения.
			requestPHPFileURLVariables.ImageArticleValue       =
				this.ImageArticleValue;
				
			// Имя таблицы групп товаров.
			requestPHPFileURLVariables.GoodsGroupsTN = this.GoodsGroupsTableName;
			// Имя столбца кодов в таблице групп товаров.
			requestPHPFileURLVariables.GoodsGroupsCodesCN =
				this.GoodsGroupsCodesColumnName;
			// Значение кода группы диска.
			requestPHPFileURLVariables.DiskGroupCodeValue =
				this.DiskGroupCodeValue;	
			// Имя столбца наименований в таблице групп товаров.
			requestPHPFileURLVariables.GoodsGroupsNamesCN =
				this.GoodsGroupsNamesColumnName;
				
			// Имя таблицы ссылок разновидностей дисков.
			requestPHPFileURLVariables.DisksVarietiesReferencesTN                 =
				this.DisksVarietiesReferencesTableName;
			// Имя столбца идентификаторов номенклатур
			// в таблице ссылок разновидностей дисков.
			requestPHPFileURLVariables.DisksVarietiesReferencesNomenclaturesIDsCN =
				this.DisksVarietiesReferencesNomenclaturesIDsColumnName;
			// Имя столбца идентификаторов характеристик разновидностей дисков
			// в таблице ссылок разновидностей дисков.
			requestPHPFileURLVariables.
				DisksVarietiesReferencesDisksVarietiesCharacteristicsIDsCN          =
		this.DisksVarietiesReferencesDisksVarietiesCharacteristicsIDsColumnName;		
			// Имя столбца идентивикаторов разновидностей дисков
			// в таблице ссылок разновидностей дисков.
			requestPHPFileURLVariables.
				DisksVarietiesReferencesDisksVarietiesIDsCN                         =
					this.DisksVarietiesReferencesDisksVarietiesIDsColumnName;
					
			// Имя столбца в таблице ссылок разновидностей дисков,
			// упорядочивающего характеристики разновидностей дисков.
			requestPHPFileURLVariables.
				DisksVarietiesReferencesCharacteristicsOrderingCN =
				this.DisksVarietiesReferencesCharacteristicsOrderingColumnName;
			// Направление упорядочения характеристик разновидностей дисков
			// в таблице ссылок разновидностей дисков:
			// если true, то 1, если false, то 0.
			if ( this.
					DisksVarietiesReferencesCharacteristicsOrderingAscendantSign )
				requestPHPFileURLVariables.
					DisksVarietiesReferencesCharacteristicsOrderingAS = 1;
			else
				requestPHPFileURLVariables.
					DisksVarietiesReferencesCharacteristicsOrderingAS = 0;			
					
			// Имя таблицы названий характеристик дисков.
			requestPHPFileURLVariables.DisksCharacteristicsNamesTN              =
				this.DisksCharacteristicsNamesTableName;
			// Имя столбца наименований групп
			// в таблице названий характеристик дисков.
			requestPHPFileURLVariables.DisksCharacteristicsNamesGroupsNamesCN   =
				this.DisksCharacteristicsNamesGroupsNamesColumnName;
			// Строка массива имён столбцов названий
			// в таблице названий характеристик дисков.
			requestPHPFileURLVariables.DisksCharacteristicsNamesNamesCsNsString =
				this.DisksCharacteristicsNamesNamesColumnsNamesString;
	
			// Имя таблицы характеристик разновидностей дисков.
			requestPHPFileURLVariables.DisksVarietiesCharacteristicsTN    =
				this.DisksVarietiesCharacteristicsTableName;
			// Имя столбца идентификаторов
			// в таблице характеристик разновидностей дисков.
			requestPHPFileURLVariables.DisksVarietiesCharacteristicsIDsCN =
				this.DisksVarietiesCharacteristicsIDsColumnName;
			// Строка массива имён столбцов характеристик
			// в таблице характеристик разновидностей дисков.
			requestPHPFileURLVariables.
				DisksVarietiesCharacteristicsCharacteristicsCsNsString      =
				this.DisksVarietiesCharacteristicsCharacteristicsColumnsNamesString;
					
			// URL-переменные PHP-файла запроса к базе данных MySQL.
			return requestPHPFileURLVariables;
		} // RequestPHPFileURLVariables	
	} // MySQLDiskVarietiesCharacteristicsSelector
} // nijanus.customerDesktop.phpAndMySQL