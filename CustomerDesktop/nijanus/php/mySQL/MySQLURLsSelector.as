// CustomerDesktop
// Author Kate Kotova
// NIJANUS Copyright © 2004-2010
// nijanus@ymail.com
// http://nijanus.narod2.ru
//---------------------------------------------------------------------------
// Пакет классов, взаимодействующих с PHP и MySQL.
package nijanus.php.mySQL
{
	// Класс выборщика URL-адресов из данных MySQL.
	public class MySQLURLsSelector extends MySQLDataSelector
	{
		// Список импортированных классов из других пакетов.
		
		import flash.net.URLVariables;
		import nijanus.utils.Tracer;			
		//-----------------------------------------------------------------------
		// Статические константы.
		
		// Имя класса.
		public static const CLASS_NAME: String = "MySQLURLsSelector";		
		//-----------------------------------------------------------------------		
		// Переменные экземпляра класса.
		
		// URL-адрес компьютера-сервера.
		protected var _ServerURL: String = null;
		//-----------------------------------------------------------------------
		// Методы экземпляра класса.
		
		// Метод получения массива URL-адресов.
		// Параметры:
		// parArray - массив.
		// Результат: массив URL-адресов.
		public function GetURLsArray( parArray: Array ): Array
		{
			// Вызов метода класса.
			this._MainTracer.CallClassMethod( MySQLURLsSelector.CLASS_NAME,
				"GetURLsArray", parArray );			
			
			// Массив URL-адресов.
			var urlsArray: Array = new Array( parArray.length );
			
			// Заполняется массив URL-адресов.
			for( var index = 0; index < parArray.length; index++ )
				// Текущий URL-адрес.
				urlsArray[ index ] =
					// URL-адрес компьютера-сервера.
					this._ServerURL +
					// Текущий элемент массива.
					parArray[ index ];
					
			// Массив URL-адресов.
			return urlsArray;			
		} // GetURLsArray		
		//-----------------------------------------------------------------------
		// Методы-конструкторы.
		
		// Метод-конструктор экземпляра выборщика URL-адресов из данных MySQL.
		// Параметры:
		// parServerURL            - URL-адрес компьютера-сервера,
		// parConnectionAttributes - атрибуты соединения с базой данных MySQL,
		// parRequestPHPFileURL    - URL-адрес PHP-файла запроса
		//   к базе данных MySQL,
		// parMainTracer           - основной трассировщик.
		public function MySQLURLsSelector
		(
		 	parServerURL:            String,
			parConnectionAttributes: MySQLConnectionAttributes,
			parRequestPHPFileURL:    String,
			parMainTracer:           Tracer
		): void
		{
			// Вызов метода-конструктора суперкласса MySQLDataSelector.
			super( parConnectionAttributes, parRequestPHPFileURL, parMainTracer );			
			// URL-адрес компьютера-сервера.
			this._ServerURL = parServerURL;	
			
			// Создание нового экземпляра класса.
			this._MainTracer.CreateClassNewInstance( MySQLURLsSelector.CLASS_NAME,
				parServerURL, parConnectionAttributes, parRequestPHPFileURL,
				parMainTracer );			
		} // MySQLURLsSelector
		//-----------------------------------------------------------------------			
		// Get- и set-методы.
		
		// Get-метод получения URL-адреса компьютера-сервера.
		// Результат: URL-адрес компьютера-сервера.
		public function get ServerURL( ): String
		{
			// URL-адрес компьютера-сервера.
			return this._ServerURL;
		} // ServerURL

		// Set-метод установки URL-адреса компьютера-сервера.
		// Параметры:
		// parServerURL - URL-адрес компьютера-сервера.
		public function set ServerURL( parServerURL: String ): void
		{
			// URL-адрес компьютера-сервера.
			this._ServerURL = parServerURL;
		} // ServerURL
		
		// Get-метод получения результата выполненного запроса
		// в виде массива URL-адресов.
		// Результат: результат выполненного запроса в виде массива URL-адресов.
		public function get RequestURLsArrayResult( ): Array
		{
			// Результат выполненного запроса в виде массива URL-адресов -
			// массив URL-адресов, полученный из массива-результата
			// выполненного запроса.
			return this.GetURLsArray( this.RequestArrayResult );	
		} // RequestURLsArrayResult
	} // MySQLURLsSelector
} // nijanus.php.mySQL