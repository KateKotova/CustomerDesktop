// CustomerDesktop
// Author Kate Kotova
// NIJANUS Copyright © 2004-2010
// nijanus@ymail.com
// http://nijanus.narod2.ru
//---------------------------------------------------------------------------
// Пакет классов, взаимодействующих с PHP.
package nijanus.php
{
	// Список импортированных классов из других пакетов.
	import flash.events.EventDispatcher;
	//-------------------------------------------------------------------------

	// Класс PHP-запросчика.
	public class PHPRequester extends EventDispatcher
	{
		// Список импортированных классов из других пакетов.

		import flash.events.Event;
		import flash.events.IOErrorEvent;
		import flash.net.URLLoader;
		import flash.net.URLLoaderDataFormat;
		import flash.net.URLRequest;
		import flash.net.URLVariables;
		import nijanus.utils.Tracer;
		//-----------------------------------------------------------------------				
		// Статические константы.
		
		// Имя класса.
		public static const CLASS_NAME: String = "PHPRequester";

		// Название типа события успешной загрузки запроса.
		public static const REQUEST_LOADING_COMPLETE:              String =
			"RequestLoadingComplete";
		// Название типа события возникновения ошибки при загрузке запроса.
		public static const REQUEST_LOADING_IO_ERROR:              String =
			"RequestLoadingIOError";		
		// Сообщение об ошибке загрузки данных с URL-адреса PHP-файла.
		public static const PHP_FILE_URL_LOADING_IO_ERROR_MESSAGE: String =
			"Ошибка загрузки данных с URL-адреса PHP-файла: ";
		//-----------------------------------------------------------------------		
		// Переменные экземпляра класса.

		// URL-адрес PHP-файла запроса.
		protected var _RequestPHPFileURL: String = null;
		// Основной трассировщик.
		protected var _MainTracer:        Tracer = null;		
		//-----------------------------------------------------------------------
		// Методы экземпляра класса.
		
		// Метод загрузки запроса.
		// Параметры:
		// parPHPFileURLLoaderDataFormat - формат загружаемых данных
		//   с URL-адреса PHP-файла.
		public function LoadRequest 
			( parPHPFileURLLoaderDataFormat: String	=
			URLLoaderDataFormat.TEXT ): void
		{
			// Вызов метода класса.
			this._MainTracer.CallClassMethod( PHPRequester.CLASS_NAME,
				"LoadRequest", parPHPFileURLLoaderDataFormat );
			
			// URL-запрос к PHP-файлу,
			// фиксирующий все сведения в одном запросе HTTP к PHP-файлу.
			var phpFileURLRequest: URLRequest = new URLRequest
				( this._RequestPHPFileURL );
			// Данные, передаваемые с URL-запросом к PHP-файлу - URL-переменные.
			phpFileURLRequest.data = this.RequestPHPFileURLVariables;	
			
			// Загрузчик данных с URL-адреса PHP-файла.
			var phpFileURLLoader: URLLoader = new URLLoader( );
			// Формат загружаемых данных с URL-адреса PHP-файла.
			phpFileURLLoader.dataFormat     = parPHPFileURLLoaderDataFormat;
			// Регистрирация объекта-прослушивателя события
			// возникновения ошибки при загрузке данных с URL-адреса PHP-файла.
			phpFileURLLoader.addEventListener
				( IOErrorEvent.IO_ERROR, this.PHPFileURLLoadingIOErrorListener );		
				
			// Загрузка данных с URL-адреса PHP-файла. 
			phpFileURLLoader.load( phpFileURLRequest );
			// Регистрирация объекта-прослушивателя события
			// успешной загрузки данных с URL-адреса PHP-файла.
			phpFileURLLoader.addEventListener( Event.COMPLETE,
				this.PHPFileURLLoadingCompleteListener );		
		} // LoadRequest		
		//-----------------------------------------------------------------------
		// Методы-прослушиватели событий.

		// Метод-прослушиватель события
		// успешной загрузки данных с URL-адреса PHP-файла.
		// Параметры:
		// parEvent - событие.
		protected function PHPFileURLLoadingCompleteListener
			( parEvent: Event ): void
		{
			// Вызов метода-обработчика события класса.
			this._MainTracer.CallClassEventListener( PHPRequester.CLASS_NAME,
				"PHPFileURLLoadingCompleteListener", parEvent );			
			
			// Передача события успешной загрузки запроса,
			// целью - объбектом-получателем - которого
			// является данный объект PHP-запросчика.
			this.dispatchEvent( new Event
				( PHPRequester.REQUEST_LOADING_COMPLETE ) );
		} // PHPFileURLLoadingCompleteListener
		
		// Метод-прослушиватель события
		// возникновения ошибки при загрузке данных с URL-адреса PHP-файла.
		// Параметры:
		// parIOErrorEvent - событие возникновения ошибки при выполнении
		//                   операция отправки или загрузки.
		protected function PHPFileURLLoadingIOErrorListener
			( parIOErrorEvent: IOErrorEvent ): void
		{
			// Вызов метода-обработчика события класса.
			this._MainTracer.CallClassEventListener( PHPRequester.CLASS_NAME,
				"PHPFileURLLoadingIOErrorListener", parIOErrorEvent );
			// Послание сообщения об ошибке.
			this._MainTracer.SendErrorMessage
				( PHPRequester.PHP_FILE_URL_LOADING_IO_ERROR_MESSAGE +
				this._RequestPHPFileURL );
			
			// Вывод сообщения об ошибке загрузки данных с URL-адреса PHP-файла.
			trace( PHPRequester.PHP_FILE_URL_LOADING_IO_ERROR_MESSAGE,
				this._RequestPHPFileURL );
			// Передача события возникновения ошибки при загрузке запроса,
			// целью - объбектом-получателем - которого
			// является данный объект PHP-запросчика.
			this.dispatchEvent( new Event
				( PHPRequester.REQUEST_LOADING_IO_ERROR ) );			
		} // PHPFileURLLoadingIOErrorListener		
		//-----------------------------------------------------------------------
		// Методы-конструкторы.
		
		// Метод-конструктор экземпляра PHP-запросчика.
		// Параметры:
		// parRequestPHPFileURL - URL-адрес PHP-файла запроса,
		// parMainTracer        - основной трассировщик.
		public function PHPRequester
		(
			parRequestPHPFileURL: String,
			parMainTracer:        Tracer
		): void
		{
			// URL-адрес PHP-файла запроса.
			this._RequestPHPFileURL = parRequestPHPFileURL;
			// Ocновной трассировщик.
			this._MainTracer        = parMainTracer;			
			
			// Создание нового экземпляра класса.
			this._MainTracer.CreateClassNewInstance( PHPRequester.CLASS_NAME,
				parRequestPHPFileURL, parMainTracer );			
		} // PHPRequester
		//-----------------------------------------------------------------------			
		// Get- и set-методы.
		
		// Get-метод получения URL-адреса PHP-файла запроса
		// Результат: URL-адрес PHP-файла запроса.
		public function get RequestPHPFileURL( ): String
		{
			// URL-адрес PHP-файла запроса.
			return this._RequestPHPFileURL;
		} // RequestPHPFileURL		

		// Get-метод получения URL-переменных PHP-файла запроса.
		// Результат: URL-переменные PHP-файла запроса.
		public function get RequestPHPFileURLVariables( ): URLVariables
		{
			// Создание URL-переменных PHP-файла запроса,
			// осуществляющих передачу данных между приложением и сервером.
			var requestPHPFileURLVariables: URLVariables = new URLVariables( );			
			// URL-переменные PHP-файла запроса.
			return requestPHPFileURLVariables;
		} // RequestPHPFileURLVariables	
	} // PHPRequester
} // nijanus.php