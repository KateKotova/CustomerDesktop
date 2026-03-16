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

	// Класс выборщика кода группы диска из таблиц MySQL.
	public class MySQLDiskGroupCodeSelector extends MySQLDataSelector
	{
		// Список импортированных классов из других пакетов.
		import flash.net.URLVariables;
		import nijanus.php.mySQL.MySQLConnectionAttributes;
		import nijanus.utils.Tracer;
		//-----------------------------------------------------------------------
		// Статические константы.
		
		// Имя класса.
		public static const CLASS_NAME: String = "MySQLDiskGroupCodeSelector";		
		//-----------------------------------------------------------------------	
		// Переменные экземпляра класса.
		
		// Имя таблицы номенклатур.
		public var NomenclaturesTableName:             String = null;
		// Имя столбца артикулов в таблице номенклатур.
		public var NomenclaturesArticlesColumnName:    String = null;
		// Значение артикула изображения.
		public var ImageArticleValue:                  String = null;
		// Имя столбца кодов групп в таблице номенклатур.
		public var NomenclaturesGroupsCodesColumnName: String = null;
		//-----------------------------------------------------------------------
		// Методы-конструкторы.

		// Метод-конструктор экземпляра
		// выборщика кода группы диска из таблиц MySQL.
		// Параметры:
		// parConnectionAttributes - атрибуты соединения с базой данных MySQL,
		// parRequestPHPFileURL    - URL-адрес PHP-файла запроса
		//   к базе данных MySQL,
		// parMainTracer           - основной трассировщик.
		public function MySQLDiskGroupCodeSelector
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
				( MySQLDiskGroupCodeSelector.CLASS_NAME, parConnectionAttributes,
				parRequestPHPFileURL, parMainTracer );			
		} // MySQLDiskGroupCodeSelector
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
			//         <{$parNomenclaturesGroupsCodesColumnName}>
			//             $mySQLQueryFetch
			//             [ $parNomenclaturesGroupsCodesColumnName ][ 0 ]
			//         </{$parNomenclaturesGroupsCodesColumnName}>
			//     </Row>
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
				// дочернего элемента - столбца кодов групп в таблице номенклатур -
				// дочернего элемента - строки -
				// XML-результата выполненного запроса к базе данных MySQL в массив.			
				requestArrayResult[ requestXMLResultRowIndex ] =
					this._RequestXMLResult.Row[ requestXMLResultRowIndex ].
					child( this.NomenclaturesGroupsCodesColumnName )[ 0 ];
					
			// Получение свойства класса.
			this._MainTracer.SetClassPropertie
				( MySQLDiskGroupCodeSelector.CLASS_NAME, "RequestArrayResult",
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
			requestPHPFileURLVariables.NomenclaturesTableName             =
				this.NomenclaturesTableName;
			// Имя столбца артикулов в таблице номенклатур.
			requestPHPFileURLVariables.NomenclaturesArticlesColumnName    =
				this.NomenclaturesArticlesColumnName;
			// Значение артикула изображения.
			requestPHPFileURLVariables.ImageArticleValue = this.ImageArticleValue;
			// Имя столбца кодов групп в таблице номенклатур.
			requestPHPFileURLVariables.NomenclaturesGroupsCodesColumnName =
				this.NomenclaturesGroupsCodesColumnName;
				
			// URL-переменные PHP-файла запроса к базе данных MySQL.
			return requestPHPFileURLVariables;
		} // RequestPHPFileURLVariables	
	} // MySQLDiskGroupCodeSelector
} // nijanus.customerDesktop.phpAndMySQL