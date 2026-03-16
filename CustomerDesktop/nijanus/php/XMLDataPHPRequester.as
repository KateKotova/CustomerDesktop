// CustomerDesktop
// Author Kate Kotova
// NIJANUS Copyright © 2004-2010
// nijanus@ymail.com
// http://nijanus.narod2.ru
//---------------------------------------------------------------------------
// Пакет классов, взаимодействующих с PHP.
package nijanus.php
{
	// Класс PHP-запросчика XML-данных.
	public class XMLDataPHPRequester extends PHPRequester
	{
		// Список импортированных классов из других пакетов.
		
		import flash.events.Event;
		import flash.events.IOErrorEvent;
		import nijanus.utils.Tracer;		
		//-----------------------------------------------------------------------				
		// Статические константы.
		
		// Имя класса.
		public static const CLASS_NAME: String = "XMLDataPHPRequester";		
		//-----------------------------------------------------------------------		
		// Переменные экземпляра класса.

		// XML-результат выполненного запроса.
		protected var _RequestXMLResult: XML = null;		
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
			this._MainTracer.CallClassEventListener
				( XMLDataPHPRequester.CLASS_NAME,
				"PHPFileURLLoadingCompleteListener", parEvent );				
			
			// Результат выполненного запроса в виде XML,
			// получаемый из данных загрузчика с URL-адреса PHP-файла -
			// объбекта-получателя события.
			this._RequestXMLResult = XML( parEvent.target.data as String );
			// Вызов метода суперкласса PHPRequester.
			super.PHPFileURLLoadingCompleteListener( parEvent );
		} // PHPFileURLLoadingCompleteListener
		
		// Метод-прослушиватель события
		// возникновения ошибки при загрузке данных с URL-адреса PHP-файла.
		// Параметры:
		// parIOErrorEvent - событие возникновения ошибки при выполнении
		//                   операция отправки или загрузки.
		override protected function PHPFileURLLoadingIOErrorListener
			( parIOErrorEvent: IOErrorEvent ): void
		{
			// Вызов метода-обработчика события класса.
			this._MainTracer.CallClassEventListener
				( XMLDataPHPRequester.CLASS_NAME,
				"PHPFileURLLoadingIOErrorListener", parIOErrorEvent );			
			
			// XML-результат выполненного запроса не определён.
			this._RequestXMLResult = null;	
			// Вызов метода суперкласса PHPRequester.
			super.PHPFileURLLoadingIOErrorListener( parIOErrorEvent );
		} // PHPFileURLLoadingIOErrorListener		
		//-----------------------------------------------------------------------
		// Методы-конструкторы.
	
		// Метод-конструктор экземпляра PHP-запросчика XML-данных.
		// Параметры:
		// parRequestPHPFileURL - URL-адрес PHP-файла запроса,
		// parMainTracer        - основной трассировщик.
		public function XMLDataPHPRequester
		(
			parRequestPHPFileURL: String,
			parMainTracer:        Tracer
		): void
		{
			// Вызов метода-конструктора суперкласса PHPRequester.
			super( parRequestPHPFileURL, parMainTracer );
			
			// Создание нового экземпляра класса.
			this._MainTracer.CreateClassNewInstance
				( XMLDataPHPRequester.CLASS_NAME,
				parRequestPHPFileURL, parMainTracer );			
		} // XMLDataPHPRequester
		//-----------------------------------------------------------------------			
		// Get- и set-методы.
		
		// Get-метод получения XML-результата выполненного запроса.
		// Результат: XML-результат выполненного запроса.
		public function get RequestXMLResult( ): XML
		{
			// XML-результат выполненного запроса.
			return this._RequestXMLResult;
		} // RequestXMLResult
		
		// Get-метод получения массива-результата выполненного запроса.
		// Результат: массива-результат выполненного запроса.
		public function get RequestArrayResult( ): Array
		{			
			// Массив-результат выполненного запроса.
			var requestArrayResult: Array = new Array
				( this._RequestXMLResult.children( ).length( ) );
			
			// Последовательный просмотр всех дочерних элементов
			// XML-результата выполненного запроса.
			for ( var requestXMLResultRowIndex: uint = 0;
					requestXMLResultRowIndex <
					this._RequestXMLResult.children( ).length( );
					requestXMLResultRowIndex++ )
				// Запись очередного дочернего элемента
				// XML-результата выполненного запроса.
				requestArrayResult[ requestXMLResultRowIndex ] =
					this._RequestXMLResult.children( )[ requestXMLResultRowIndex ];
					
			// Получение свойства класса.
			this._MainTracer.SetClassPropertie( XMLDataPHPRequester.CLASS_NAME,
				"RequestArrayResult", requestArrayResult );					
					
			// Массив-результат выполненного запроса.
			return requestArrayResult;
		} // RequestArrayResult
	} // XMLDataPHPRequester
} // nijanus.php