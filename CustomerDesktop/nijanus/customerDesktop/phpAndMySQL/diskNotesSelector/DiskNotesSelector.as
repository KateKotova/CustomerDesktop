// CustomerDesktop
// Author Kate Kotova
// NIJANUS Copyright © 2004-2010
// nijanus@ymail.com
// http://nijanus.narod2.ru
//---------------------------------------------------------------------------
// Пакет классов рабочего стола покупателя, взаимодействующих с PHP и MySQL
// для выбора имён изображений.
package nijanus.customerDesktop.phpAndMySQL.diskNotesSelector
{
	// Список импортированных классов из других пакетов.
	import nijanus.php.mySQL.MySQLDataSelector;
	//-------------------------------------------------------------------------
	
	// Класс выборщика примечаний диска.
	public class DiskNotesSelector extends MySQLDataSelector
	{
		// Список импортированных классов из других пакетов.
		
		import flash.events.Event;
		import flash.net.URLLoaderDataFormat;
		import flash.net.URLVariables;		
		import nijanus.customerDesktop.phpAndMySQL.MySQLParameters;
		import nijanus.customerDesktop.text.TextParameters;
		import nijanus.php.PHPRequester;
		import nijanus.php.mySQL.MySQLConnectionAttributes;
		import nijanus.utils.Tracer;
		//-----------------------------------------------------------------------
		// Статические константы.
		
		// Имя класса.
		public static const CLASS_NAME: String = "DiskNotesSelector";	
		//-----------------------------------------------------------------------	
		// Переменные экземпляра класса.
		
		// Парараметры базы данных MySQL.
		protected var _MySQLDatabaseParameters: MySQLParameters   = null;
		// Тип примечаний диска.
		protected var _DiskNotesType:    String = DiskNotesType.UNKNOWN;
		// Выборщик.
		protected var _Selector:                MySQLDataSelector = null;
		// Значение артикула изображения.
		public    var ImageArticleValue: String = null;
		//-----------------------------------------------------------------------
		// Методы экземпляра класса.
		
		// Метод инициализации выборщика примечаний первого типа диска
		// из таблиц MySQL.
		private function InitializeDiskFirstTypeNotesSelector( ): void
		{
			// Вызов метода класса.
			this._MainTracer.CallClassMethod( DiskNotesSelector.CLASS_NAME,
				"InitializeDiskFirstTypeNotesSelector" );			
			
			// Выборщик примечаний первого типа диска из таблиц MySQL.
			var selector: MySQLDiskFirstTypeNotesSelector =
				new MySQLDiskFirstTypeNotesSelector		
				(
					// Атрибуты соединения с базой данных MySQL.
					this._ConnectionAttributes,
					// URL-адрес PHP-файла запроса к базе данных MySQL.
					this._MySQLDatabaseParameters.
						DiskFirstTypeNotesSelectorRequestPHPFileURL,	
					// Основной трассировщик.
					this._MainTracer	
				); // new MySQLDiskFirstTypeNotesSelector
				
			// Имя таблицы номенклатур.
			selector.NomenclaturesTableName     = this._MySQLDatabaseParameters.
				NomenclaturesTableName;
			// Имя столбца идентивикаторов в таблице номенклатур.
			selector.NomenclaturesIDsColumnName = this._MySQLDatabaseParameters.
				NomenclaturesIDsColumnName;
			// Имя столбца артикулов в таблице номенклатур.
			selector.NomenclaturesArticlesColumnName       =
				this._MySQLDatabaseParameters.NomenclaturesArticlesColumnName;
			// Значение артикула изображения.
			selector.ImageArticleValue          = this.ImageArticleValue;
			// Имя столбца названий стран в таблице номенклатур.
			selector.NomenclaturesCountriesNamesColumnName =
				this._MySQLDatabaseParameters.NomenclaturesCountriesNamesColumnName;
			// Имя столбца дат релизов в таблице номенклатур.
			selector.NomenclaturesReleasesDatesColumnName  =
				this._MySQLDatabaseParameters.NomenclaturesReleasesDatesColumnName;
		
			// Имя таблицы категорий товаров и номенклатур.
			selector.GoodsCategoriesAndNomenclaturesTableName                    =
				this._MySQLDatabaseParameters.
				GoodsCategoriesAndNomenclaturesTableName;
			// Имя столбца идентивикаторов номенклатур
			// в таблице категорий товаров и номенклатур.
			selector.GoodsCategoriesAndNomenclaturesNomenclaturesIDsColumnName   =
				this._MySQLDatabaseParameters.
				GoodsCategoriesAndNomenclaturesNomenclaturesIDsColumnName;
			// Имя столбца идентивикаторов категорий товаров
			// в таблице категорий товаров и номенклатур.
			selector.GoodsCategoriesAndNomenclaturesGoodsCategoriesIDsColumnName =
				this._MySQLDatabaseParameters.
				GoodsCategoriesAndNomenclaturesGoodsCategoriesIDsColumnName;
		
			// Имя таблицы категорий товаров.
			selector.GoodsCategoriesTableName     = this._MySQLDatabaseParameters.
				GoodsCategoriesTableName;
			// Имя столбца идентивикаторов в таблице категорий товаров.
			selector.GoodsCategoriesIDsColumnName = this._MySQLDatabaseParameters.
				GoodsCategoriesIDsColumnName;
			// Имя столбца наименований в таблице категорий товаров.
			selector.GoodsCategoriesNamesColumnName =
				this._MySQLDatabaseParameters.GoodsCategoriesNamesColumnName;
				
			// Имя таблицы ссылок свойств.
			selector.PropertiesReferencesTableName = this._MySQLDatabaseParameters.
				PropertiesReferencesTableName;
			// Имя столбца идентивикаторов номенклатур в таблице ссылок свойств.
			selector.PropertiesReferencesNomenclaturesIDsColumnName    =
				this._MySQLDatabaseParameters.
				PropertiesReferencesNomenclaturesIDsColumnName;
			// Имя столбца идентивикаторов значений свойств
			// в таблице ссылок свойств.
			selector.PropertiesReferencesPropertiesValuesIDsColumnName =
				this._MySQLDatabaseParameters.
				PropertiesReferencesPropertiesValuesIDsColumnName;
		
			// Имя таблицы значений свойств.
			selector.PropertiesValuesTableName     = this._MySQLDatabaseParameters.
				PropertiesValuesTableName;
			// Имя столбца идентивикаторов в таблице значений свойств.
			selector.PropertiesValuesIDsColumnName = this._MySQLDatabaseParameters.
				PropertiesValuesIDsColumnName;
			// Имя столбца наименований в таблице значений свойств.
			selector.PropertiesValuesNamesColumnName =
				this._MySQLDatabaseParameters.PropertiesValuesNamesColumnName;				
			
			// Основа заголовка примечания.
			selector.NoteCaptionBase = MySQLParameters.DISKS_NOTES_CAPTION_BASE;	
			
			// Выборщик - выборщик примечаний первого типа диска из таблиц MySQL.
			this._Selector = selector;			
		} // InitializeDiskFirstTypeNotesSelector
		
		// Метод инициализации выборщика примечаний второго типа диска
		// из таблиц MySQL.
		private function InitializeDiskSecondTypeNotesSelector( ): void
		{
			// Вызов метода класса.
			this._MainTracer.CallClassMethod( DiskNotesSelector.CLASS_NAME,
				"InitializeDiskSecondTypeNotesSelector" );			
			
			// Выборщик примечаний второго типа диска из таблиц MySQL.
			var selector: MySQLDiskSecondTypeNotesSelector =
				new MySQLDiskSecondTypeNotesSelector				
				(
					// Атрибуты соединения с базой данных MySQL.
					this._ConnectionAttributes,
					// URL-адрес PHP-файла запроса к базе данных MySQL.
					this._MySQLDatabaseParameters.
						DiskSecondTypeNotesSelectorRequestPHPFileURL,
					// Основной трассировщик.
					this._MainTracer						
				); // new MySQLDiskSecondTypeNotesSelector
				
			// Имя таблицы номенклатур.
			selector.NomenclaturesTableName     = this._MySQLDatabaseParameters.
				NomenclaturesTableName;
			// Имя столбца идентивикаторов в таблице номенклатур.
			selector.NomenclaturesIDsColumnName = this._MySQLDatabaseParameters.
				NomenclaturesIDsColumnName;
			// Имя столбца артикулов в таблице номенклатур.
			selector.NomenclaturesArticlesColumnName      =
				this._MySQLDatabaseParameters.NomenclaturesArticlesColumnName;
			// Значение артикула изображения.
			selector.ImageArticleValue          = this.ImageArticleValue;
			// Имя столбца дат релизов в таблице номенклатур.
			selector.NomenclaturesReleasesDatesColumnName =
				this._MySQLDatabaseParameters.NomenclaturesReleasesDatesColumnName;
		
			// Имя таблицы категорий товаров и номенклатур.
			selector.GoodsCategoriesAndNomenclaturesTableName                    =	
				this._MySQLDatabaseParameters.
				GoodsCategoriesAndNomenclaturesTableName;
			// Имя столбца идентивикаторов номенклатур
			// в таблице категорий товаров и номенклатур.
			selector.GoodsCategoriesAndNomenclaturesNomenclaturesIDsColumnName   =
				this._MySQLDatabaseParameters.
				GoodsCategoriesAndNomenclaturesNomenclaturesIDsColumnName;
			// Имя столбца идентивикаторов категорий товаров
			// в таблице категорий товаров и номенклатур.
			selector.GoodsCategoriesAndNomenclaturesGoodsCategoriesIDsColumnName =
				this._MySQLDatabaseParameters.
				GoodsCategoriesAndNomenclaturesGoodsCategoriesIDsColumnName;
		
			// Имя таблицы категорий товаров.
			selector.GoodsCategoriesTableName     = this._MySQLDatabaseParameters.
				GoodsCategoriesTableName;
			// Имя столбца идентивикаторов в таблице категорий товаров.
			selector.GoodsCategoriesIDsColumnName = this._MySQLDatabaseParameters.
				GoodsCategoriesIDsColumnName;
			// Имя столбца наименований в таблице категорий товаров.
			selector.GoodsCategoriesNamesColumnName =
				this._MySQLDatabaseParameters.GoodsCategoriesNamesColumnName;
	
			// Имя таблицы ссылок свойств.
			selector.PropertiesReferencesTableName = this._MySQLDatabaseParameters.
				PropertiesReferencesTableName;
			// Имя столбца идентивикаторов номенклатур в таблице ссылок свойств.
			selector.PropertiesReferencesNomenclaturesIDsColumnName    =
				this._MySQLDatabaseParameters.
				PropertiesReferencesNomenclaturesIDsColumnName;
			// Имя столбца идентивикаторов значений свойств
			// в таблице ссылок свойств.
			selector.PropertiesReferencesPropertiesValuesIDsColumnName =
				this._MySQLDatabaseParameters.
				PropertiesReferencesPropertiesValuesIDsColumnName;
		
			// Имя таблицы значений свойств.
			selector.PropertiesValuesTableName     = this._MySQLDatabaseParameters.
				PropertiesValuesTableName;
			// Имя столбца идентивикаторов в таблице значений свойств.
			selector.PropertiesValuesIDsColumnName = this._MySQLDatabaseParameters.
				PropertiesValuesIDsColumnName;
			// Имя столбца наименований в таблице значений свойств.
			selector.PropertiesValuesNamesColumnName =
				this._MySQLDatabaseParameters.PropertiesValuesNamesColumnName;		
			
			// Основа заголовка примечания.
			selector.NoteCaptionBase = MySQLParameters.DISKS_NOTES_CAPTION_BASE;			
				
			// Выборщик - выборщик примечаний второго типа диска из таблиц MySQL.
			this._Selector = selector;			
		} // InitializeDiskSecondTypeNotesSelector
		
		// Метод установки выборщика.
		protected function SetSelector( ): void
		{
			// Вызов метода класса.
			this._MainTracer.CallClassMethod( DiskNotesSelector.CLASS_NAME,
				"SetSelector" );			
			
			// Удаление выбощика.
			this._Selector = null;			
			
			// Если тип примечаний диска не известен.
			if ( this._DiskNotesType == DiskNotesType.UNKNOWN )
				// Установка обобщённого выборщика.
				this._Selector = new MySQLDataSelector( this._ConnectionAttributes,
					null, this._MainTracer );
				
			else
			{
				// Класс селектор зависит от типа примечаний диска:
				// для примечаний первого типа - выборщик
				// примечаний первого типа диска из таблиц MySQ,
				// для примечаний второго типа - выборщик
				// примечаний второго типа диска из таблиц MySQ.
				if ( this._DiskNotesType == DiskNotesType.FIRST )
					// Инициализация выборщика примечаний первого типа диска
					// из таблиц MySQL.
					this.InitializeDiskFirstTypeNotesSelector( );		
				else
					// Инициализация выборщика примечаний второго типа диска
					// из таблиц MySQL.
					this.InitializeDiskSecondTypeNotesSelector( );
			} // else

			// Регистрирация объекта-прослушивателя события
			// успешной загрузки XML-результата
			// при выполнении запроса к базе данных MySQL.
			this._Selector.addEventListener( PHPRequester.REQUEST_LOADING_COMPLETE,
				this.RequestXMLResultLoadingCompleteListener );					
		} // SetSelector		
		
		// Метод загрузки запроса.
		// Параметры:
		// parPHPFileURLLoaderDataFormat - формат загружаемых данных
		//   с URL-адреса PHP-файла.
		override public function LoadRequest
			( parPHPFileURLLoaderDataFormat: String	=
			URLLoaderDataFormat.BINARY ): void
		{
			// Вызов метода класса.
			this._MainTracer.CallClassMethod( DiskNotesSelector.CLASS_NAME,
				"LoadRequest", parPHPFileURLLoaderDataFormat );			
			
			// Загрузка запроса выборщика.
			this._Selector.LoadRequest( parPHPFileURLLoaderDataFormat );
		} // LoadRequest		
		//-----------------------------------------------------------------------
		// Методы-прослушиватели событий.

		// Метод-прослушиватель события
		// успешной загрузки XML-результата
		// при выполнении запроса к базе данных MySQL.
		// Параметры:
		// parEvent - событие.
		protected function RequestXMLResultLoadingCompleteListener
			( parEvent: Event ): void
		{
			// Вызов метода-обработчика события класса.
			this._MainTracer.CallClassEventListener( DiskNotesSelector.CLASS_NAME,
				"RequestXMLResultLoadingCompleteListener", parEvent );			
			
			// Передача события успешной загрузки XML-результата
			// при выполнении запроса к базе данных MySQL в поток событий,
			// целью - объбектом-получателем - которого
			// является данный объект выборщика данных MySQL.
			this.dispatchEvent( new Event
				( PHPRequester.REQUEST_LOADING_COMPLETE ) );
		} // RequestXMLResultLoadingCompleteListener		
		//-----------------------------------------------------------------------		
		// Методы-конструкторы.
		
		// Метод-конструктор экземпляра выборщика примечаний диска.
		// Параметры:
		// parMySQLDatabaseParameters - парараметры базы данных MySQL,		 
		// parDiskNotesType           - тип примечаний диска,
		// parImageArticleValue       - значение артикула изображения,
		// parMainTracer              - основной трассировщик.
		public function DiskNotesSelector
		(
			parMySQLDatabaseParameters: MySQLParameters,
			parDiskNotesType,
			parImageArticleValue:       String,
			parMainTracer:              Tracer
		): void
		{
			// Вызов метода-конструктора суперкласса MySQLDataSelector.
			super( parMySQLDatabaseParameters.ConnectionAttributes, null,
				parMainTracer );
		
			// Создание нового экземпляра класса.
			this._MainTracer.CreateClassNewInstance( DiskNotesSelector.CLASS_NAME,
				parMySQLDatabaseParameters, parDiskNotesType, parImageArticleValue,
				parMainTracer );						
			
			// Парараметры базы данных MySQL.
			this._MySQLDatabaseParameters = parMySQLDatabaseParameters;			
			// Тип примечаний диска.
			this._DiskNotesType           = DiskNotesType.GetValueFromString
				( parDiskNotesType );
			// Значение артикула изображения.
			this.ImageArticleValue        = parImageArticleValue;

			// Установка выборщика.
			this.SetSelector( );
		} // DiskNotesSelector
		//-----------------------------------------------------------------------			
		// Get- и set-методы.
		
		// Get-метод получения парараметров базы данных MySQL.
		// Результат: парараметры базы данных MySQL.
		public function get MySQLDatabaseParameters( ): MySQLParameters
		{
			// Парараметры базы данных MySQL.
			return this._MySQLDatabaseParameters;
		} // MySQLDatabaseParameters		
		
		// Get-метод получения типа примечаний диска.
		// Результат: тип примечаний диска.
		public function get DiskNotesTypeValue( ): String
		{
			// Типа примечаний диска.
			return this._DiskNotesType;
		} // DiskNotesTypeValue

		// Set-метод установки типа примечаний диска.
		// Параметры:
		// parDiskNotesType - тип примечаний диска.
		public function set DiskNotesTypeValue( parDiskNotesType: String ): void
		{
			// Установка свойства класса.
			this._MainTracer.SetClassPropertie( DiskNotesSelector.CLASS_NAME,
				"DiskNotesTypeValue", parDiskNotesType );			
			
			// Получение нового типа примечаний диска.
			parDiskNotesType = DiskNotesType.GetValueFromString
				( parDiskNotesType );
				
			// Если новый тип примечаний диска равен прежнему.
			if ( this._DiskNotesType == parDiskNotesType )
				// Ничего не происходит.
				return;
			// Если новый тип примечаний диска не равен прежнему.
			else
			{
				// Устновка нового типа примечаний диска.
				this._DiskNotesType = parDiskNotesType;
				// Установка выборщика.
				this.SetSelector( );				
			} // else
		} // DiskNotesTypeValue
		
		// Get-метод получения URL-адреса PHP-файла запроса к базе данных MySQL.
		// Результат: URL-адрес PHP-файла запроса к базе данных MySQL.
		override public function get RequestPHPFileURL( ): String
		{
			// URL-адрес PHP-файла запроса выборщика к базе данных MySQL.
			return this._Selector.RequestPHPFileURL;
		} // ConnectionAttributes		

		// Get-метод получения атрибутов соединения с базой данных MySQL.
		// Результат: атрибуты соединения с базой данных MySQL.
		override public function get ConnectionAttributes( ):
			MySQLConnectionAttributes
		{
			// Aтрибуты соединения выборщика с базой данных MySQL.
			return this._Selector.ConnectionAttributes;
		} // ConnectionAttributes
		
		// Get-метод получения XML-результата выполненного запроса
		// к базе данных MySQL.
		// Результат: XML-результат выполненного запроса к базе данных MySQL.
		override public function get RequestXMLResult( ): XML
		{
			// XML-результат выполненного запроса выборщика к базе данных MySQL.
			return this._Selector.RequestXMLResult;
		} // RequestXMLResult
		
		// Get-метод получения массива-результата выполненного запроса
		// к базе данных MySQL.
		// Результат: массива-результат выполненного запроса к базе данных MySQL.
		override public function get RequestArrayResult( ): Array
		{
			// Массив-результат выполненного запроса выборщика к базе данных MySQL.
			return this._Selector.RequestArrayResult;			
		} // RequestArrayResult
		
		// Get-метод получения URL-переменных PHP-файла
		// запроса к базе данных MySQL.
		// Результат: URL-переменные PHP-файла запроса к базе данных MySQL.
		override public function get RequestPHPFileURLVariables( ): URLVariables
		{
			// URL-переменные PHP-файла запроса выборщика к базе данных MySQL.
			return this._Selector.RequestPHPFileURLVariables;					
		} // RequestPHPFileURLVariables	
	} // DiskNotesSelector
} // nijanus.customerDesktop.phpAndMySQL.diskNotesSelector