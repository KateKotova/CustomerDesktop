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
	import nijanus.php.XMLDataPHPRequester;
	//-------------------------------------------------------------------------
	
	// Класс выборщика URL-адресов слайдов определённого типа диска.
	public class DiskSlidesFilesURLsSelector extends XMLDataPHPRequester
	{
		// Список импортированных классов из других пакетов.
		
		import flash.net.URLVariables;
		import nijanus.utils.Tracer;			
		//-----------------------------------------------------------------------
		// Статические константы.
		
		// Имя класса.
		public static const CLASS_NAME: String = "DiskSlidesFilesURLsSelector";		
		//-----------------------------------------------------------------------		
		// Переменные экземпляра класса.
		
		// URL-адрес компьютера-хранилища.
		public var WarehouseURL:                 String = null;
		// Путь к директорию, хранящему документы на компьютере-хранилище.
		public var WarehouseDocumentRoot:        String = null;
		// Путь к директорию, харанящему файлы слайдов диска.
		public var DiskSlidesFilesDirectoryPath: String = null;
	
		// Значение артикула диска.
		public var DiskArticleValue:       String = null;
		// Аффикс имени файла слайда диска.
		public var DiskSlideFileNameAffix: String = null;
		// Расширение файла слайда диска.
		public var DiskSlideFileExtension: String = null;
		
		// Заголовок файла слайда диска.
		public var DiskSlideFileCaption: String = null;
		//-----------------------------------------------------------------------
		// Методы-конструкторы.
		
		// Метод-конструктор экземпляра
		// выборщика URL-адресов слайдов определённого типа диска.
		// Параметры:
		// parRequestPHPFileURL - URL-адрес PHP-файла запроса,
		// parMainTracer        - основной трассировщик.
		public function DiskSlidesFilesURLsSelector
		(
			parRequestPHPFileURL: String,
			parMainTracer:        Tracer
		): void
		{
			// Вызов метода-конструктора суперкласса XMLDataPHPRequester.
			super( parRequestPHPFileURL, parMainTracer );
			
			// Создание нового экземпляра класса.
			this._MainTracer.CreateClassNewInstance
				( DiskSlidesFilesURLsSelector.CLASS_NAME,
				parRequestPHPFileURL, parMainTracer );			
		} // DiskSlidesFilesURLsSelector
		//-----------------------------------------------------------------------			
		// Get- и set-методы.
	
		// Get-метод получения массива-результата выполненного запроса.
		// Результат: массива-результат выполненного запроса.
		override public function get RequestArrayResult( ): Array
		{
			// Результат выполненного запроса
			// возвращается в формате XML следующего вида:
			// <DiskSlidesFiles>
			//     <Row>
			//         <{$diskSlideFileCaption}>
			//             $diskSlideFileURL[ 0 ]
			//         </{$diskSlideFileCaption}>
			//     </Row>
			//     <Row>
			//         <{$diskSlideFileCaption}>
			//             $diskSlideFileURL[ 0 ]
			//         </{$diskSlideFileCaption}>
			//     </Row>
			//     . . .
			// </DiskSlidesFiles>			
			
			// Массив-результат выполненного запроса.
			var requestArrayResult: Array = new Array
				( this._RequestXMLResult.children( ).length( ) );
			
			// Последовательный просмотр всех дочерних элементов -
			// строк, именованных как "Row" - XML-результата выполненного запроса.
			for ( var requestXMLResultRowIndex: uint = 0;
					requestXMLResultRowIndex <
					this._RequestXMLResult.children( ).length( );
					requestXMLResultRowIndex++ )
				// Запись очередного
				// дочернего элемента - файла слайда диска -
				// дочернего элемента - строки -
				// XML-результата выполненного запроса в массив.			
				requestArrayResult[ requestXMLResultRowIndex ] =
					this._RequestXMLResult.Row[ requestXMLResultRowIndex ].
					child( this.DiskSlideFileCaption )[ 0 ];
					
			// Получение свойства класса.
			this._MainTracer.SetClassPropertie
				( DiskSlidesFilesURLsSelector.CLASS_NAME, "RequestArrayResult",
				requestArrayResult );					

			// Массив-результат выполненного запроса к базе данных MySQL.
			return requestArrayResult;
		} // RequestArrayResult
		
		// Get-метод получения URL-переменных PHP-файла запроса.
		// Результат: URL-переменные PHP-файла запроса.
		override public function get RequestPHPFileURLVariables( ): URLVariables
		{
			// Создание URL-переменных PHP-файла запроса,
			// осуществляющих передачу данных между приложением и сервером.
			var requestPHPFileURLVariables: URLVariables = new URLVariables( );			
			
			// Добавление URL-переменных запроса.
			
			// URL-адрес компьютера-хранилища.
			requestPHPFileURLVariables.WarehouseURL = this.WarehouseURL;
			// Путь к директорию, хранящему документы на компьютере-хранилище.
			requestPHPFileURLVariables.WarehouseDocumentRoot        =
				this.WarehouseDocumentRoot;
			// Путь к директорию, харанящему файлы слайдов диска.
			requestPHPFileURLVariables.DiskSlidesFilesDirectoryPath =
				this.DiskSlidesFilesDirectoryPath;
		
			// Значение артикула диска.
			requestPHPFileURLVariables.DiskArticleValue = this.DiskArticleValue;
			// Аффикс имени файла слайда диска.
			requestPHPFileURLVariables.DiskSlideFileNameAffix =
				this.DiskSlideFileNameAffix;
			// Расширение файла слайда диска.
			requestPHPFileURLVariables.DiskSlideFileExtension =
				this.DiskSlideFileExtension;

			// URL-переменные PHP-файла запроса.
			return requestPHPFileURLVariables;
		} // RequestPHPFileURLVariables	
	} // DiskSlidesFilesURLsSelector
} // nijanus.customerDesktop.phpAndMySQL