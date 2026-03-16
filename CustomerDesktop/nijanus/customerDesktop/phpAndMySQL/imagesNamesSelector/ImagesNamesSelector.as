// CustomerDesktop
// Author Kate Kotova
// NIJANUS Copyright © 2004-2010
// nijanus@ymail.com
// http://nijanus.narod2.ru
//---------------------------------------------------------------------------
// Пакет классов рабочего стола покупателя, взаимодействующих с PHP и MySQL
// для выбора имён изображений.
package nijanus.customerDesktop.phpAndMySQL.imagesNamesSelector
{
	// Список импортированных классов из других пакетов.
	import nijanus.php.mySQL.MySQLURLsSelector;
	//-------------------------------------------------------------------------
	
	// Класс выборщика имён изображений.
	public class ImagesNamesSelector extends MySQLURLsSelector
	{
		// Список импортированных классов из других пакетов.
		
		import flash.events.Event;
		import flash.net.URLLoaderDataFormat;
		import flash.net.URLVariables;	
		import nijanus.customerDesktop.phpAndMySQL.MySQLParameters;		
		import nijanus.customerDesktop.text.TextParameters;
		import nijanus.php.PHPRequester;
		import nijanus.php.mySQL.MySQLConnectionAttributes;
		import nijanus.php.mySQL.MySQLDataSelector;
		import nijanus.utils.Tracer;
		//-----------------------------------------------------------------------
		// Статические константы.
		
		// Имя класса.
		public static const CLASS_NAME: String = "ImagesNamesSelector";	
		//-----------------------------------------------------------------------		
		// Переменные экземпляра класса.
		
		// Парараметры базы данных MySQL.
		protected var _MySQLDatabaseParameters: MySQLParameters   = null;
		// Тип экрана выбора.
		protected var _ChoiceScreenType: String = ChoiceScreenType.UNKNOWN;
		// Тип строки изображений.
		protected var _ImagesLineType:   String = ImagesLineType.UNKNOWN;
		// Выборщик.
		protected var _Selector:                MySQLDataSelector = null;
		//-----------------------------------------------------------------------
		// Методы экземпляра класса.
		
		// Метод, определяющий, является ли хотя бы один из типов:
		// экрана выбора или строки изображений - неизвестным.
		// Результат: признак неизвестности хотя бы одного из типов:
		// экрана выбора или строки изображений.
		protected function ChoiceScreenTypeOrImagesLineTypeIsUnknown( ): Boolean
		{
			// Вызов метода класса.
			this._MainTracer.CallClassMethod( ImagesNamesSelector.CLASS_NAME,
				"ChoiceScreenTypeOrImagesLineTypeIsUnknown" );			
			
			// Если тип экрана выбора или тип строки изображений не известен.
			if
			(
				( this._ChoiceScreenType == ChoiceScreenType.UNKNOWN ) ||
				( this._ImagesLineType   == ImagesLineType.UNKNOWN   )
			)
				// Признак истинен.
				return true;
			// Если тип экрана выбора и тип строки изображений известны.
			else
				// Признак ложен.
				return false;
		} // ChoiceScreenTypeOrImagesLineTypeIsUnknown	
		
		// Метод инициализации выборщика артикулов изображений из таблиц MySQL.
		// Параметры:
		// parSelectorParameters - параметры выборщика.
		private function InitializeImagesArticlesSelector
			( parSelectorParameters: ImagesNamesSelectorParameters ): void
		{
			// Вызов метода класса.
			this._MainTracer.CallClassMethod( ImagesNamesSelector.CLASS_NAME,
				"InitializeImagesArticlesSelector", parSelectorParameters );			
			
			// Выборщик артикулов изображений из таблиц MySQL.
			var selector: MySQLImagesArticlesSelector =
				new MySQLImagesArticlesSelector
				(
					// Атрибуты соединения с базой данных MySQL.
					this._ConnectionAttributes,
					// URL-адрес PHP-файла запроса к базе данных MySQL.
					this._MySQLDatabaseParameters.
						ImagesArticlesSelectorRequestPHPFileURL,
					this._MainTracer
				); // new MySQLImagesArticlesSelector
				
			// Имя таблицы розничных товаров.
			selector.RetailGoodsTableName        = this._MySQLDatabaseParameters.
				RetailGoodsTableName;
			// Имя столбца идентивикаторов номенклатур в таблице розничных товаров.
			selector.RetailGoodsNomenclaturesIDsColumnName =
				this._MySQLDatabaseParameters.RetailGoodsNomenclaturesIDsColumnName;
			// Имя столбца количеств в таблице розничных товаров.
			selector.RetailGoodsCountsColumnName = this._MySQLDatabaseParameters.
				RetailGoodsCountsColumnName;
		
			// Имя таблицы номенклатур.
			selector.NomenclaturesTableName     = this._MySQLDatabaseParameters.
				NomenclaturesTableName;
			// Имя столбца идентивикаторов в таблице номенклатур.
			selector.NomenclaturesIDsColumnName = this._MySQLDatabaseParameters.
				NomenclaturesIDsColumnName;
			// Имя столбца артикулов в таблице номенклатур.
			selector.NomenclaturesArticlesColumnName =
				this._MySQLDatabaseParameters.NomenclaturesArticlesColumnName;
		
			// Имя фильтрующего столбца.
			selector.FilteringColumnName = this._MySQLDatabaseParameters.
				DisksImagesFilteringColumnsNames
				[ parSelectorParameters.FilteringType ];
			// Значение фильтра.
			selector.FilterValue         = parSelectorParameters.FilterValue;
		
			// Имя упорядочивающего столбца.
			selector.OrderingColumnName = this._MySQLDatabaseParameters.
				DisksImagesOrderingColumnsNames
				[ parSelectorParameters.OrderingType ];
			// Направление упорядочения.
			selector.OrderingAscentSign =
				parSelectorParameters.OrderingIsAscendant;
				
			// Выборщик - выборщик артикулов изображений из таблиц MySQL.
			this._Selector = selector;			
		} // InitializeImagesArticlesSelector
		
		// Метод инициализации выборщика артикулов изображений,
		// отфильтрованных по категоиям, из таблиц MySQL.
		// Параметры:
		// parSelectorParameters - параметры выборщика.
		private function
			InitializeImagesArticlesFilteredByCategoriesSelector
			( parSelectorParameters: ImagesNamesSelectorParameters ): void
		{
			// Вызов метода класса.
			this._MainTracer.CallClassMethod( ImagesNamesSelector.CLASS_NAME,
				"InitializeImagesArticlesFilteredByCategoriesSelector",
				parSelectorParameters );			
			
			// Выборщик артикулов изображений, отфильтрованных по категоиям,
			// из таблиц MySQL.			
			var selector: MySQLImagesArticlesFilteredByCategoriesSelector =
				new MySQLImagesArticlesFilteredByCategoriesSelector
				(
					// Атрибуты соединения с базой данных MySQL.
					this._ConnectionAttributes,
					// URL-адрес PHP-файла запроса к базе данных MySQL.
					this._MySQLDatabaseParameters.
						ImagesArticlesFilteredByCategoriesSelectorRequestPHPFileURL,
					this._MainTracer
				); // new MySQLImagesArticlesFilteredByCategoriesSelector
				
			// Имя таблицы розничных товаров.
			selector.RetailGoodsTableName        = this._MySQLDatabaseParameters.
				RetailGoodsTableName;
			// Имя столбца идентивикаторов номенклатур в таблице розничных товаров.
			selector.RetailGoodsNomenclaturesIDsColumnName =
				this._MySQLDatabaseParameters.RetailGoodsNomenclaturesIDsColumnName;
			// Имя столбца количеств в таблице розничных товаров.
			selector.RetailGoodsCountsColumnName = this._MySQLDatabaseParameters.
				RetailGoodsCountsColumnName;
		
			// Имя таблицы номенклатур.
			selector.NomenclaturesTableName     = this._MySQLDatabaseParameters.
				NomenclaturesTableName;
			// Имя столбца идентивикаторов в таблице номенклатур.
			selector.NomenclaturesIDsColumnName = this._MySQLDatabaseParameters. 
				NomenclaturesIDsColumnName;
			// Имя столбца артикулов в таблице номенклатур.
			selector.NomenclaturesArticlesColumnName =
				this._MySQLDatabaseParameters.NomenclaturesArticlesColumnName;
			
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
			// Имя столбца кодов в таблице категорий товаров -
			// имя фильтрующего столбца.
			selector.GoodsCategoriesCodesColumnName =
				this._MySQLDatabaseParameters.DisksImagesFilteringColumnsNames
				[ parSelectorParameters.FilteringType ];
			// Значение кода категории товара - значение фильтра.
			selector.GoodCategoryCodeValue = parSelectorParameters.FilterValue;
		
			// Имя упорядочивающего столбца.
			selector.OrderingColumnName = this._MySQLDatabaseParameters.
				DisksImagesOrderingColumnsNames
				[ parSelectorParameters.OrderingType ];
			// Направление упорядочения.
			selector.OrderingAscentSign =
				parSelectorParameters.OrderingIsAscendant;
				
			// Выборщик - выборщик артикулов изображений,
			// отфильтрованных по категоиям, из таблиц MySQL.			
			this._Selector = selector;		
		} // ImagesArticlesFilteredByCategoriesSelector	
		
		// Метод установки выборщика.
		protected function SetSelector( ): void
		{
			// Вызов метода класса.
			this._MainTracer.CallClassMethod( ImagesNamesSelector.CLASS_NAME,
				"SetSelector" );			
			
			// Удаление выбощика.
			this._Selector = null;			
			
			// Если тип экрана выбора или тип строки изображений не известен.
			if ( this.ChoiceScreenTypeOrImagesLineTypeIsUnknown( ) )
				// Установка обобщённого выборщика.
				this._Selector = new MySQLDataSelector( this._ConnectionAttributes,
					null, this._MainTracer );
				
			else
			{
				// Определение параметров выброщика.
				var selectorParameters: ImagesNamesSelectorParameters =
					this._MySQLDatabaseParameters.DisksImagesChoiceParameters
					[ this._ChoiceScreenType ] [ this._ImagesLineType ]
					as ImagesNamesSelectorParameters;
					
				// Класс селектор зависит от типа фильтрации:
				// для фильтрации по категории    - выборщик артикулов изображений,
				// отфильтрованных по категоиям, из таблиц MySQL,
				// для остальных типов фильтрации - выборщик артикулов изображений
				// из таблиц MySQL.
				if ( selectorParameters.FilteringType ==
						ImagesNamesFilteringType.CATEGORY )
					// Инициализация выборщика артикулов изображений,
					// отфильтрованных по категоиям, из таблиц MySQL.
					this.InitializeImagesArticlesFilteredByCategoriesSelector
						( selectorParameters );
				else
					// Инициализация выборщика артикулов изображений из таблиц MySQL.
					this.InitializeImagesArticlesSelector( selectorParameters );
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
			this._MainTracer.CallClassMethod( ImagesNamesSelector.CLASS_NAME,
				"LoadRequest", parPHPFileURLLoaderDataFormat );			
			
			// Загрузка запроса выборщика.
			this._Selector.LoadRequest( parPHPFileURLLoaderDataFormat );
		} // LoadRequest	
		
		// Метод получения массива URL-адресов файлов изображений
		// из массива кодов изображений.
		// Параметры:
		// parImagesArticles - массив артикулов изображений.
		// Результат: массив URL-адресов файлов изображений.
		override public function GetURLsArray( parImagesArticles: Array ): Array
		{
			// Вызов метода класса.
			this._MainTracer.CallClassMethod( ImagesNamesSelector.CLASS_NAME,
				"GetURLsArray", parImagesArticles );			
			
			// Массив URL-адресов файлов изображений.
			var imagesFilesURLs: Array = new Array( parImagesArticles.length );
			
			// Заполняется массив URL-адресов файлов изображений.
			for( var imageIndex = 0; imageIndex < parImagesArticles.length;
					imageIndex++ )
				// URL-адрес файла текущего изображения.
				imagesFilesURLs[ imageIndex ] =
					// URL-адрес компьютера-сервера.
					this._ServerURL                                             +
					// Путь к директорию, харанящему файлы изображений дисков.
					this._MySQLDatabaseParameters.DisksImagesFilesDirectoryPath +
					// Косая черта.				
				  TextParameters.SLASH                                        +
					// Артикул текущего изображения.
					parImagesArticles[ imageIndex ]                             +
					// Аффикс имени файла изображения диска.
					this._MySQLDatabaseParameters.DiskImageFileNameAffix        +
					// Точка.
					TextParameters.POINT                                        +
					// Расширение файла изображения диска.
					this._MySQLDatabaseParameters.DiskImageFileExtension;	
					
			// Массив URL-адресов файлов изображений.
			return imagesFilesURLs;			
		} // GetURLsArray		
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
			this._MainTracer.CallClassEventListener
				( ImagesNamesSelector.CLASS_NAME,
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

		// Метод-конструктор экземпляра выборщика имён изображений.
		// Параметры:
		// parMySQLDatabaseParameters - парараметры базы данных MySQL,		 
		// parChoiceScreenType        - тип экрана выбора,
		// parImagesLineType          - тип строки изображений,
		// parMainTracer              - основной трассировщик.
		public function ImagesNamesSelector
		(
			parMySQLDatabaseParameters: MySQLParameters,
			parChoiceScreenType,
			parImagesLineType:          String,
			parMainTracer:              Tracer
		): void
		{
			// Вызов метода-конструктора суперкласса MySQLURLsSelector.
			super( parMySQLDatabaseParameters.ServerURL,
				parMySQLDatabaseParameters.ConnectionAttributes, null,
				parMainTracer );	
			
			// Создание нового экземпляра класса.
			this._MainTracer.CreateClassNewInstance
				( ImagesNamesSelector.CLASS_NAME, parMySQLDatabaseParameters,
				parChoiceScreenType, parImagesLineType, parMainTracer );			
			
			// Парараметры базы данных MySQL.
			this._MySQLDatabaseParameters = parMySQLDatabaseParameters;			
			// Тип экрана выбора.
			this._ChoiceScreenType        =
				ChoiceScreenType.GetValueFromString( parChoiceScreenType );
			// Тип строки изображений.
			this._ImagesLineType          =
				ImagesLineType.GetValueFromString( parImagesLineType );

			// Установка выборщика.
			this.SetSelector( );
		} // ImagesNamesSelector
		//-----------------------------------------------------------------------			
		// Get- и set-методы.
		
		// Get-метод получения парараметров базы данных MySQL.
		// Результат: парараметры базы данных MySQL.
		public function get MySQLDatabaseParameters( ): MySQLParameters
		{
			// Парараметры базы данных MySQL.
			return this._MySQLDatabaseParameters;
		} // MySQLDatabaseParameters		
		
		// Get-метод получения типа экрана выбора.
		// Результат: тип экрана выбора.
		public function get ChoiceScreenTypeValue( ): String
		{
			// Типа экрана выбора.
			return this._ChoiceScreenType;
		} // ChoiceScreenTypeValue

		// Set-метод установки типа экрана выбора.
		// Параметры:
		// parChoiceScreenType - тип экрана выбора.
		public function set ChoiceScreenTypeValue
			( parChoiceScreenType: String ): void
		{
			// Установка свойства класса.
			this._MainTracer.SetClassPropertie( ImagesNamesSelector.CLASS_NAME,
				"ChoiceScreenTypeValue", parChoiceScreenType );			
			
			// Получение нового типа экрана выбора.
			parChoiceScreenType = ChoiceScreenType.GetValueFromString
				( parChoiceScreenType );
				
			// Если новый тип экрана выбора равен прежнему.
			if ( this._ChoiceScreenType == parChoiceScreenType )
				// Ничего не происходит.
				return;
			// Если новый тип экрана выбора не равен прежнему.
			else
			{
				// Устновка нового типа экрана выбора.
				this._ChoiceScreenType = parChoiceScreenType;
				// Установка выборщика.
				this.SetSelector( );				
			} // else
		} // ChoiceScreenTypeValue
		
		// Get-метод получения типа строки изображений.
		// Результат: тип строки изображений.
		public function get ImagesLineTypeValue( ): String
		{
			// Тип строки изображений.
			return this._ImagesLineType;
		} // ImagesLineTypeValue

		// Set-метод установки типа строки изображений.
		// Параметры:
		// parImagesLineType - тип строки изображений.
		public function set ImagesLineTypeValue
			( parImagesLineType: String ): void
		{
			// Установка свойства класса.
			this._MainTracer.SetClassPropertie( ImagesNamesSelector.CLASS_NAME,
				"ImagesLineTypeValue", parImagesLineType );			
			
			// Получение нового типа строки изображений.
			parImagesLineType = ImagesLineType.GetValueFromString
				( parImagesLineType );
				
			// Если новый тип строки изображений равен прежнему.
			if ( this._ImagesLineType == parImagesLineType )
				// Ничего не происходит.
				return;
			// Если новый тип строки изображений не равен прежнему.
			else
			{
				// Устновка нового типа строки изображений.
				this._ImagesLineType = parImagesLineType;
				// Установка выборщика.
				this.SetSelector( );				
			} // else			
		} // ImagesLineTypeValue
		
		// Get-метод получения типа фильтрации.
		// Результат: тип фильтрации.
		public function get FilteringType( ): String
		{
			// Если тип экрана выбора или тип строки изображений не известен.
			if ( this.ChoiceScreenTypeOrImagesLineTypeIsUnknown( ) )
				// Тип фильтрации также не известен.
				return ImagesNamesFilteringType.UNKNOWN;				
			// Иначе типа фильтрации находится из параметров выбора.
			else
				return this._MySQLDatabaseParameters.DisksImagesChoiceParameters
					[ this._ChoiceScreenType ][ this._ImagesLineType ].FilteringType;
		} // FilteringType
		
		// Get-метод получения значения фильтра.
		// Результат: значение фильтра.
		public function get FilterValue( ): Object
		{
			// Если тип экрана выбора или тип строки изображений не известен.
			if ( this.ChoiceScreenTypeOrImagesLineTypeIsUnknown( ) )
				// Значение фильтра также не изветно.
				return undefined;				
			// Иначе значение фильтра находится из параметров выбора.
			else
				return this._MySQLDatabaseParameters.DisksImagesChoiceParameters
					[ this._ChoiceScreenType ][ this._ImagesLineType ].FilterValue;
		} // FilterValue		
		
		// Get-метод получения типа упорядочения.
		// Результат: тип упорядочения.
		public function get OrderingType( ): String
		{
			// Если тип экрана выбора или тип строки изображений не известен.
			if ( this.ChoiceScreenTypeOrImagesLineTypeIsUnknown( ) )
				// Тип упорядочения также не известен.
				return ImagesNamesOrderingType.UNKNOWN;
			// Иначе типа упорядочения находится из параметров выбора.
			else
				return this._MySQLDatabaseParameters.DisksImagesChoiceParameters
					[ this._ChoiceScreenType ][ this._ImagesLineType ].OrderingType;
		} // OrderingType		
		
		// Get-метод получения признака упорядочения по возрастанию.
		// Результат: признак упорядочения по возрастанию.
		public function get OrderingIsAscendant( ): Boolean
		{
			// Если тип экрана выбора или тип строки изображений не известен.
			if ( this.ChoiceScreenTypeOrImagesLineTypeIsUnknown( ) )
				// Признак упорядочения по возрастанию также не известен.
				return undefined;				
			// Иначе признак упорядочения по возрастанию
			// находится из параметров выбора.
			else
				return this._MySQLDatabaseParameters.DisksImagesChoiceParameters
					[ this._ChoiceScreenType ][ this._ImagesLineType ].
					OrderingIsAscendant;
		} // OrderingIsAscendant		
		
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
	} // ImagesNamesSelector
} // nijanus.customerDesktop.phpAndMySQL.imagesNamesSelector