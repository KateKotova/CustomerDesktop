// CustomerDesktop
// Author Kate Kotova
// NIJANUS Copyright © 2004-2010
// nijanus@ymail.com
// http://nijanus.narod2.ru
//---------------------------------------------------------------------------
// Пакет классов рабочего стола покупателя, взаимодействующих с PHP и MySQL
// для выбора примечаний диска.
package nijanus.customerDesktop.phpAndMySQL.diskNotesSelector
{
	// Список импортированных классов из других пакетов.
	import nijanus.php.mySQL.MySQLDataSelector;
	//-------------------------------------------------------------------------
		
	// Класс выборщика примечаний первого типа диска из таблиц MySQL.
	public class MySQLDiskFirstTypeNotesSelector extends MySQLDataSelector
	{
		// Список импортированных классов из других пакетов.
		
		import flash.net.URLVariables;
		import nijanus.php.mySQL.MySQLConnectionAttributes;
		import nijanus.utils.Tracer;
		//-----------------------------------------------------------------------
		// Статические константы.
		
		// Имя класса.
		public static const CLASS_NAME: String =
			"MySQLDiskFirstTypeNotesSelector";	
		//-----------------------------------------------------------------------
		// Переменные экземпляра класса.
		
		// Имя таблицы номенклатур.
		public var NomenclaturesTableName:                String = null;
		// Имя столбца идентивикаторов в таблице номенклатур.
		public var NomenclaturesIDsColumnName:            String = null;
		// Имя столбца артикулов в таблице номенклатур.
		public var NomenclaturesArticlesColumnName:       String = null;
		// Значение артикула изображения.
		public var ImageArticleValue:                     String = null;
		// Имя столбца названий стран в таблице номенклатур.
		public var NomenclaturesCountriesNamesColumnName: String = null;
		// Имя столбца дат релизов в таблице номенклатур.
		public var NomenclaturesReleasesDatesColumnName:  String = null;
	
		// Имя таблицы категорий товаров и номенклатур.
		public var GoodsCategoriesAndNomenclaturesTableName: String = null;
		// Имя столбца идентивикаторов номенклатур
		// в таблице категорий товаров и номенклатур.
		public var GoodsCategoriesAndNomenclaturesNomenclaturesIDsColumnName:
			String = null;
		// Имя столбца идентивикаторов категорий товаров
		// в таблице категорий товаров и номенклатур.
		public var GoodsCategoriesAndNomenclaturesGoodsCategoriesIDsColumnName:
			String = null;
	
		// Имя таблицы категорий товаров.
		public var GoodsCategoriesTableName:       String = null;
		// Имя столбца идентивикаторов в таблице категорий товаров.
		public var GoodsCategoriesIDsColumnName:   String = null;
		// Имя столбца наименований в таблице категорий товаров.
 		public var GoodsCategoriesNamesColumnName: String = null;
		
		// Имя таблицы ссылок свойств.
		public var PropertiesReferencesTableName: String = null;
		// Имя столбца идентивикаторов номенклатур в таблице ссылок свойств.
		public var PropertiesReferencesNomenclaturesIDsColumnName:
			String = null;
		// Имя столбца идентивикаторов значений свойств
		// в таблице ссылок свойств.
		public var PropertiesReferencesPropertiesValuesIDsColumnName:
			String = null;
	
		// Имя таблицы значений свойств.
		public var PropertiesValuesTableName:       String = null;
		// Имя столбца идентивикаторов в таблице значений свойств.
		public var PropertiesValuesIDsColumnName:   String = null;
		// Имя столбца наименований в таблице значений свойств.
		public var PropertiesValuesNamesColumnName: String = null		
		
		// Основа заголовка примечания.
		public var NoteCaptionBase: String = null;	
		//-----------------------------------------------------------------------
		// Методы-конструкторы.

		// Метод-конструктор экземпляра выборщика примечаний первого типа диска
		// из таблиц MySQL.
		// Параметры:
		// parConnectionAttributes - атрибуты соединения с базой данных MySQL,
		// parRequestPHPFileURL    - URL-адрес PHP-файла запроса
		//   к базе данных MySQL,
		// parMainTracer           - основной трассировщик.
		public function MySQLDiskFirstTypeNotesSelector
		(
			parConnectionAttributes: MySQLConnectionAttributes,
			parRequestPHPFileURL:    String	,
			parMainTracer:           Tracer
		): void
		{
			// Вызов метода-конструктора суперкласса MySQLDataSelector.
			super( parConnectionAttributes, parRequestPHPFileURL, parMainTracer );
			
			// Создание нового экземпляра класса.
			this._MainTracer.CreateClassNewInstance
				( MySQLDiskFirstTypeNotesSelector.CLASS_NAME,
				parConnectionAttributes, parRequestPHPFileURL, parMainTracer );			
		} // MySQLDiskFirstTypeNotesSelector
		//-----------------------------------------------------------------------			
		// Get- и set-методы.
		
		// Get-метод получения массива-результата выполненного запроса
		// к базе данных MySQL.
		// Результат: массива-результат выполненного запроса к базе данных MySQL.
		override public function get RequestArrayResult( ): Array
		{
			// Результат выполненного запроса к базе данных MySQL возвращается
			// в формате XML следующего вида:
			// <Notes>
			//     <Row>
			//         <{$noteCaptionBase}1>
			//             $notes[ $noteIndex ][ 0 ]
			//         </{$noteCaptionBase}1>
			//
			//         <{$noteCaptionBase}2>
			//             $notes[ $noteIndex ][ 0 ]
			//         </{$noteCaptionBase}2>
			//
			//         <{$noteCaptionBase}3>
			//             $notes[ $noteIndex ][ 0 ]
			//         </{$noteCaptionBase}3>
			//     </Row>
			// </Notes>
			
			// Количество примечаний.
			var notesCount:         uint  =
				this._RequestXMLResult.Row[ 0 ].children( ).length( );			
			// Массив-результат выполненного запроса к базе данных MySQL.
			var requestArrayResult: Array = new Array( notesCount );
			
			// Последовательный просмотр всех столбцов примечаний
			// c индексами примечаний XML-результата выполненного запроса
			// к базе данных MySQL.
			for ( var noteIndex: uint = 0; noteIndex < notesCount; noteIndex++ )			
				// Запись очередного
				// дочернего элемента - столбца примечаний c индеком примечания -
				// дочернего элемента - строки -
				// XML-результата выполненного запроса к базе данных MySQL в массив.		
				requestArrayResult[ noteIndex ] = this._RequestXMLResult.Row[ 0 ].
					child( this.NoteCaptionBase + noteIndex.toString( ) )[ 0 ];
					
			// Получение свойства класса.
			this._MainTracer.SetClassPropertie
				( MySQLDiskFirstTypeNotesSelector.CLASS_NAME, "RequestArrayResult",
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
			
			// Имя таблицы номенклатур.
			requestPHPFileURLVariables.NomenclaturesTableName                =
				this.NomenclaturesTableName;
			// Имя столбца идентивикаторов в таблице номенклатур.
			requestPHPFileURLVariables.NomenclaturesIDsColumnName            =
				this.NomenclaturesIDsColumnName;
			// Имя столбца артикулов в таблице номенклатур.
			requestPHPFileURLVariables.NomenclaturesArticlesColumnName       =
				this.NomenclaturesArticlesColumnName;
			// Значение артикула изображения.
			requestPHPFileURLVariables.ImageArticleValue = this.ImageArticleValue;
			// Имя столбца названий стран в таблице номенклатур.
			requestPHPFileURLVariables.NomenclaturesCountriesNamesColumnName =
				this.NomenclaturesCountriesNamesColumnName;
			// Имя столбца дат релизов в таблице номенклатур.
			requestPHPFileURLVariables.NomenclaturesReleasesDatesColumnName  =
				this.NomenclaturesReleasesDatesColumnName;
		
			// Имя таблицы категорий товаров и номенклатур.
			requestPHPFileURLVariables.GoodsCategoriesAndNomenclaturesTableName =
				this.GoodsCategoriesAndNomenclaturesTableName;
			// Имя столбца идентивикаторов номенклатур
			// в таблице категорий товаров и номенклатур.
			requestPHPFileURLVariables.
				GoodsCategoriesAndNomenclaturesNomenclaturesIDsColumnName         =
				this.GoodsCategoriesAndNomenclaturesNomenclaturesIDsColumnName;
			// Имя столбца идентивикаторов категорий товаров
			// в таблице категорий товаров и номенклатур.
			requestPHPFileURLVariables.
				GoodsCategoriesAndNomenclaturesGoodsCategoriesIDsColumnName       =
				this.GoodsCategoriesAndNomenclaturesGoodsCategoriesIDsColumnName;
		
			// Имя таблицы категорий товаров.
			requestPHPFileURLVariables.GoodsCategoriesTableName       =
				this.GoodsCategoriesTableName;
			// Имя столбца идентивикаторов в таблице категорий товаров.
			requestPHPFileURLVariables.GoodsCategoriesIDsColumnName   =
				this.GoodsCategoriesIDsColumnName;
			// Имя столбца наименований в таблице категорий товаров.
			requestPHPFileURLVariables.GoodsCategoriesNamesColumnName =			
				this.GoodsCategoriesNamesColumnName;
				
			// Имя таблицы ссылок свойств.
			requestPHPFileURLVariables.PropertiesReferencesTableName =
				this.PropertiesReferencesTableName;
			// Имя столбца идентивикаторов номенклатур в таблице ссылок свойств.
			requestPHPFileURLVariables.
				PropertiesReferencesNomenclaturesIDsColumnName    =
				this.PropertiesReferencesNomenclaturesIDsColumnName;
			// Имя столбца идентивикаторов значений свойств
			// в таблице ссылок свойств.
			requestPHPFileURLVariables.
				PropertiesReferencesPropertiesValuesIDsColumnName =
				this.PropertiesReferencesPropertiesValuesIDsColumnName;
				
			// Имя таблицы значений свойств.
			requestPHPFileURLVariables.PropertiesValuesTableName       =
				this.PropertiesValuesTableName;
			// Имя столбца идентивикаторов в таблице значений свойств.
			requestPHPFileURLVariables.PropertiesValuesIDsColumnName   =
				this.PropertiesValuesIDsColumnName;
			// Имя столбца наименований в таблице значений свойств.
			requestPHPFileURLVariables.PropertiesValuesNamesColumnName =
				this.PropertiesValuesNamesColumnName;				
			
			// URL-переменные PHP-файла запроса к базе данных MySQL.
			return requestPHPFileURLVariables;
		} // RequestPHPFileURLVariables	
	} // MySQLDiskFirstTypeNotesSelector
} // nijanus.customerDesktop.phpAndMySQL.diskNotesSelector