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
	
	// Класс выборщика текстовых меток кнопок меню из таблиц MySQL.
	public class MySQLMenuButtonsLabelsSelector extends MySQLDataSelector
	{
		// Список импортированных классов из других пакетов.
		
		import flash.net.URLVariables;
		import nijanus.php.mySQL.MySQLConnectionAttributes;
		import nijanus.utils.Tracer;
		//-----------------------------------------------------------------------
		// Статические константы.
		
		// Имя класса.
		public static const CLASS_NAME: String =
			"MySQLMenuButtonsLabelsSelector";	
		//-----------------------------------------------------------------------		
		// Переменные экземпляра класса.
		
		// Имя таблицы кнопок меню.
		public var MenuButtonsTableName:        String = null;
		// Имя столбца текстовых меток кнопок меню.
		public var MenuButtonsLablesColumnName: String = null;
		
		// Имя упорядочивающего столбца.
		public var OrderingColumnName: String  = null;
		// Направление упорядочения:
		// true - упорядочение по возрастанию упорядочивающего столбца,
		// false - упорядочение по убыванию упорядочивающего столбца.
		public var OrderingAscentSign: Boolean = true;
		//-----------------------------------------------------------------------
		// Методы-конструкторы.
		
		// Метод-конструктор экземпляра
		// выборщика текстовых меток кнопок меню из таблиц MySQL.
		// Параметры:
		// parConnectionAttributes - атрибуты соединения с базой данных MySQL,
		// parRequestPHPFileURL    - URL-адрес PHP-файла запроса
		//   к базе данных MySQL,
		// parMainTracer           - основной трассировщик.
		public function MySQLMenuButtonsLabelsSelector
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
				( MySQLMenuButtonsLabelsSelector.CLASS_NAME, parConnectionAttributes,
				parRequestPHPFileURL, parMainTracer );			
		} // MySQLMenuButtonsLabelsSelector
		//-----------------------------------------------------------------------			
		// Get- и set-методы.
		
		// Get-метод получения массива-результата выполненного запроса
		// к базе данных MySQL.
		// Результат: массива-результат выполненного запроса к базе данных MySQL.
		override public function get RequestArrayResult( ): Array
		{
			// Результат выполненного запроса к базе данных MySQL возвращается
			// в формате XML следующего вида:
			// <{$parMenuButtonsTableName}>
			//     <Row>
			//         <{$parMenuButtonsLablesColumnName}>
			//             $mySQLQueryFetch
			//             [ $parMenuButtonsLablesColumnName ][ 0 ]
			//         </{$parMenuButtonsLablesColumnName}>
			//     </Row>
			//     <Row>
			//         <{$parMenuButtonsLablesColumnName}>
			//             $mySQLQueryFetch
			//             [ $parMenuButtonsLablesColumnName ][ 0 ]
			//         </{$parMenuButtonsLablesColumnName}>
			//     </Row>
			//     . . .
			// </{$parMenuButtonsTableName}>
			
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
				// дочернего элемента - столбца текстовых меток кнопок меню -
				// дочернего элемента - строки -
				// XML-результата выполненного запроса к базе данных MySQL в массив.			
				requestArrayResult[ requestXMLResultRowIndex ] =
					this._RequestXMLResult.Row[ requestXMLResultRowIndex ].
					child( this.MenuButtonsLablesColumnName )[ 0 ];
					
			// Получение свойства класса.
			this._MainTracer.SetClassPropertie
				( MySQLMenuButtonsLabelsSelector.CLASS_NAME, "RequestArrayResult",
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
			
			// Имя таблицы кнопок меню.
			requestPHPFileURLVariables.MenuButtonsTableName        =
				this.MenuButtonsTableName;
			// Имя столбца текстовых меток кнопок меню.
			requestPHPFileURLVariables.MenuButtonsLablesColumnName =
				this.MenuButtonsLablesColumnName;
				
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
	} // MySQLMenuButtonsLabelsSelector
} // nijanus.customerDesktop.phpAndMySQL