// CustomerDesktop
// Author Kate Kotova
// NIJANUS Copyright © 2004-2010
// nijanus@ymail.com
// http://nijanus.narod2.ru
//---------------------------------------------------------------------------
// Пакет классов, взаимодействующих с PHP и MySQL.
package nijanus.php.mySQL
{
	// Список импортированных классов из других пакетов.
	import nijanus.php.XMLDataPHPRequester;
	//-------------------------------------------------------------------------
		
	// Класс выборщика данных MySQL.
	public class MySQLDataSelector extends XMLDataPHPRequester
	{
		// Список импортированных классов из других пакетов.

		import flash.events.Event;
		import flash.net.URLLoaderDataFormat;
		import flash.net.URLVariables;
		import flash.utils.ByteArray;
		import nijanus.php.PHPRequester;
		import nijanus.utils.Tracer;		
		//-----------------------------------------------------------------------				
		// Статические константы.
		
		// Имя класса.
		public static const CLASS_NAME: String = "MySQLDataSelector";		
		//-----------------------------------------------------------------------		
		// Переменные экземпляра класса.

		// Aтрибуты соединения с базой данных MySQL.
		protected var _ConnectionAttributes: MySQLConnectionAttributes = null;
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
			this._MainTracer.CallClassMethod( MySQLDataSelector.CLASS_NAME,
				"LoadRequest", parPHPFileURLLoaderDataFormat );			
			
			// Загрузка запроса с получением данных в виде объекта ByteArray,
			// содержащего необработанные двоичные данные.
			// Вызов метода суперкласса XMLDataPHPRequester.
			super.LoadRequest( URLLoaderDataFormat.BINARY );
		} // LoadRequest		
		//-----------------------------------------------------------------------
		// Методы-прослушиватели событий.
		
		// Метод-прослушиватель события
		// успешной загрузки данных с URL-адреса PHP-файла.
		// Параметры:
		// parEvent - событие.
		override protected function PHPFileURLLoadingCompleteListener
			( parEvent: Event ): void
		{
			// Вызов метода-обработчика события класса.
			this._MainTracer.CallClassEventListener( MySQLDataSelector.CLASS_NAME,
				"PHPFileURLLoadingCompleteListener", parEvent );				
			
			// Результат выполненного запроса к базе данных MySQL в виде
			// необработанных двоичных данных, получаемый из данных загрузчика
			// с URL-адреса PHP-файла - объбекта-получателя события.
			var requestByteArrayResult: ByteArray =
				parEvent.target.data as ByteArray;
			// XML-результат выполненного запроса к базе данных MySQL, полученный
			// при считывании из потока байт двоичного массива многобайтовой строки
			// с использованием набора символов, используемого в базе данных.
			this._RequestXMLResult = new XML( requestByteArrayResult.readMultiByte
				( requestByteArrayResult.length,
				this._ConnectionAttributes.DatabaseСharSetName ) );
			
			// Передача события успешной загрузки запроса,
			// целью - объбектом-получателем - которого
			// является данный объект PHP-запросчика.
			this.dispatchEvent( new Event
				( PHPRequester.REQUEST_LOADING_COMPLETE ) );
		} // PHPFileURLLoadingCompleteListener
		//-----------------------------------------------------------------------
		// Методы-конструкторы.
	
		// Метод-конструктор экземпляра выборщика данных MySQL.
		// Параметры:
		// parConnectionAttributes - атрибуты соединения с базой данных MySQL,
		// parRequestPHPFileURL    - URL-адрес PHP-файла запроса
		//   к базе данных MySQL,
		// parMainTracer           - основной трассировщик.
		public function MySQLDataSelector
		(
			parConnectionAttributes: MySQLConnectionAttributes,
			parRequestPHPFileURL:    String,
			parMainTracer:           Tracer
		): void
		{
			// Вызов метода-конструктора суперкласса XMLDataPHPRequester.
			super( parRequestPHPFileURL, parMainTracer );			
			// Aтрибуты соединения с базой данных MySQL.
			this._ConnectionAttributes = parConnectionAttributes;
			
			// Создание нового экземпляра класса.
			this._MainTracer.CreateClassNewInstance( MySQLDataSelector.CLASS_NAME,
				parConnectionAttributes, parRequestPHPFileURL, parMainTracer );			
		} // MySQLDataSelector
		//-----------------------------------------------------------------------			
		// Get- и set-методы.
		
		// Get-метод получения атрибутов соединения с базой данных MySQL.
		// Результат: атрибуты соединения с базой данных MySQL.
		public function get ConnectionAttributes( ): MySQLConnectionAttributes
		{
			// Aтрибуты соединения с базой данных MySQL.
			return this._ConnectionAttributes;
		} // ConnectionAttributes
		
		// Get-метод получения URL-переменных PHP-файла
		// запроса к базе данных MySQL.
		// Результат: URL-переменные PHP-файла запроса к базе данных MySQL.
		override public function get RequestPHPFileURLVariables( ): URLVariables
		{
			// Создание URL-переменных PHP-файла запроса к базе данных MySQL,
			// осуществляющих передачу данных между приложением и сервером.
			var requestPHPFileURLVariables: URLVariables = new URLVariables( );
			
			// Добавление URL-переменных атрибутов соединения с базой данных MySQL.
			this._ConnectionAttributes.AddURLVariables
				( requestPHPFileURLVariables );
		
			// URL-переменные PHP-файла запроса к базе данных MySQL.
			return requestPHPFileURLVariables;
		} // RequestPHPFileURLVariables	
	} // MySQLDataSelector
} // nijanus.php.mySQL