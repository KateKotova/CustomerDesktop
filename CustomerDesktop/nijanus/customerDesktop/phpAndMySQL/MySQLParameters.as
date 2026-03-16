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
	import flash.events.EventDispatcher;
	//-------------------------------------------------------------------------

	// Класс парараметров MySQL.
	public class MySQLParameters extends EventDispatcher
	{
		// Список импортированных классов из других пакетов.
		import flash.events.Event;
		import flash.events.IOErrorEvent;
		import flash.net.URLLoader;
		import flash.net.URLRequest;
		import nijanus.customerDesktop.phpAndMySQL.DiskGroup;
		import nijanus.customerDesktop.phpAndMySQL.diskNotesSelector.
			DiskNotesType;
		import nijanus.customerDesktop.phpAndMySQL.imagesNamesSelector.
			ChoiceScreenType;
		import nijanus.customerDesktop.phpAndMySQL.imagesNamesSelector.
			ImagesLineType;
		import nijanus.customerDesktop.phpAndMySQL.imagesNamesSelector.
			ImagesNamesFilteringType;
		import nijanus.customerDesktop.phpAndMySQL.imagesNamesSelector.
			ImagesNamesOrderingType;
		import nijanus.customerDesktop.phpAndMySQL.imagesNamesSelector.
			ImagesNamesSelectorParameters;
		import nijanus.customerDesktop.text.TextParameters;
		import nijanus.php.mySQL.MySQLConnectionAttributes;
		import nijanus.utils.Tracer;		
		//-----------------------------------------------------------------------		
		// Статические константы.
		
		// Имя класса.
		public static const CLASS_NAME: String = "MySQLParameters";
		
		// Название типа события окончания инициализации парараметров MySQL.
		public static const INITIALIZED: String = "Initialized";
		// Сообщение об ошибке загрузки данных из файла настроек.
		public static const SETTINGS_FILE_URL_LOADING_IO_ERROR_MESSAGE: String =
			"Ошибка загрузки данных из файла настроек: ";
		// Сообщение об ошибке загрузки данных из файла
		// демонстрационных настроек.
		public static const
			DEMO_SETTINGS_FILE_URL_LOADING_IO_ERROR_MESSAGE:
			String = "Ошибка загрузки данных из файла демонстрационных настроек: ";
			
		// Протокол http.
		public static const HTTP_PROTOCOL: String = "http";			
			
		// Значения категорий дисков.
		public static const DISKS_CATEGORIES_VALUES: Object =
		{
			// Неизвестная категория диска.
			UNKNOWN:             null,
			
			// Категория диска приключений.
			ADVENTURES:          1,
			// Категория диска драмы.
			DRAMA:               2,
			// Категория диска мультфильмов.
			ANIMATION:           3,
			// Категория диска прочего.
			MISCELLANEOUS:       4,
			// Категория диска советских.
			SOVIET:              5,
			// Категория диска познавательных.
			STUDY:               6,			
			
			// Категория диска Blu-ray-новинок.
			BLU_RAY_NOVELTIES:   7,
			// Категория диска Blu-ray-зарубежных.
			BLU_RAY_OVERSEAS:    8,	
			// Категория диска Blu-ray-отечественных.
			BLU_RAY_DOMESTIC:    9,
			
			// Категория диска PS3.
			PS3:                 10,
			// Категория диска Xbox360.
			XBOX360:             11,
			// Категория диска Nintendo.
			NINTENDO:            12,			
			
			// Категория диска новинок игр для ПК.
			PC_GAMES_NOVELTIES:  13,
			// Категория диска зарубежных игр для ПК.
			PC_GAMES_OVERSEAS:   14,
			// Категория диска отечественных игр для ПК.
			PC_GAMES_DOMESTIC:   15,
			
			// Категория диска новинок DVD-музыки.
			DVD_MUSIC_NOVELTIES: 16,
			// Категория диска зарубежной DVD-музыки.
			DVD_MUSIC_OVERSEAS:  17,
			// Категория диска отечественной DVD-музыки.
			DVD_MUSIC_DOMESTIC:  18,
			
			// Категория диска новинок CD-музыки.
			CD_MUSIC_NOVELTIES:  19,
			// Категория диска зарубежной CD-музыки.
			CD_MUSIC_OVERSEAS:   20,
			// Категория диска отечественной CD-музыки.
			CD_MUSIC_DOMESTIC:   21
		}; // DISKS_CATEGORIES_VALUES
		
		// Значения групп дисков.
		public static const DISKS_GROUPS_VALUES: Object =
		{
			// Неизвестная группа диска.
			UNKNOWN:   null,
			
			// Группа диска DVD-фильмов.
			DVD_FILMS: 1,	
			// Группа диска Blu-ray.
			BLU_RAY:   2,			
			// Группа диска DVD-музыки.
			DVD_MUSIC: 3,		
			// Группа диска игор.
			GAMES:     4,
			// Группа диска игор для ПК.
			PC_GAMES:  5,		
			// Группа диска CD-музыки.
			CD_MUSIC:  6	
		}; // DISKS_GROUPS_VALUES
		
		// Типы примечаний дисков.
		public static const DISKS_NOTES_TYPES: Object =
		{
			// Неизвестная группа диска.
			UNKNOWN:   DiskNotesType.SECOND,
			
			// Группа диска DVD-фильмов.
			DVD_FILMS: DiskNotesType.FIRST,	
			// Группа диска Blu-ray.
			BLU_RAY:   DiskNotesType.FIRST,			
			// Группа диска DVD-музыки.
			DVD_MUSIC: DiskNotesType.SECOND,	
			// Группа диска игор.
			GAMES:     DiskNotesType.SECOND,
			// Группа диска игор для ПК.
			PC_GAMES:  DiskNotesType.SECOND,		
			// Группа диска CD-музыки.
			CD_MUSIC:  DiskNotesType.SECOND	
		}; // DISKS_NOTES_TYPES		
		
		// Основа заголовка примечания диска.
		public static const DISKS_NOTES_CAPTION_BASE:  String = "Note";
		// Основа заголовка разновидности диска.
		public static const DISK_VARIETY_CAPTION_BASE: String = "DiskVariety";
		// Заголовок файла слайда диска.
		public static const DISK_SLIDE_FILE_CAPTION:   String = "DiskSlideFile";
		
		// Максимальное количество характеристик дисков.
		// Имя таблицы названий характеристик дисков.
		public static const DISKS_CHARACTERISTICS_MAXIMUN_COUNT: uint = 15;
		//-----------------------------------------------------------------------		
		// Переменные экземпляра класса.
		
		// Путь к файлу настроек.
		private var _SettingsFilePath:     String = TextParameters.EMPTY_STRNG;
		// Путь к файлу демонстрационных настроек.
		private var _DemoSettingsFilePath: String = TextParameters.EMPTY_STRNG;
		// Основной трассировщик.
		private var _MainTracer:           Tracer = null;				
		
		// URL-адрес компьютера-сервера.
		
		// Протокол.
		public  var Protocol:                   String = "http";
		// Имя или сетевой адрес компьютера-сервера.
		public  var ServerNameOrNetworkAddress: String = "127.0.0.1";
		// Путь к директорию, хранящему документы на компьютере-сервере.
		public  var ServerDocumentRoot:         String = "Z:/home/localhost/www";
		// URL-адрес компьютера-сервера.
		private var _ServerURL:                 String;
		
		// URL-адрес компьютера-клиента.		
		
		// IP-адрес локального хоста.
		public  var Localhost:          String = "127.0.0.1";
		// Путь к директорию, хранящему документы на компьютере-клиенте.
		public  var ClientDocumentRoot: String = "Z:/home/localhost/www";		
		// URL-адрес компьютера-клиента.
		private var _ClientURL:         String;
		
		// Aтрибуты соединения с базой данных MySQL.
		
		// Имя хоста.
		public var HostName:               String = "localhost";
		// Имя пользователя.
		public var UserName:               String = "root";
		// Пароль пользователя.
		public var UserPassword:           String = "";
		// Имя базы данных.
		public var DatabaseName:           String = "db_TA7";
		// Название набора символов,
		// используемого для интерпретации байтов в базе данных.
		public var DatabaseCharSetName:    String = "windows-1251";
		// Aтрибуты соединения с базой данных MySQL.
		private var _ConnectionAttributes: MySQLConnectionAttributes;		
		
		// Мультимедиа-файлы дисков.
		
		// Комьютер-хранилище файлов кадров фильмов дисков.
		public var DisksFramesFilesWarehouse: String = WarehouseType.SERVER;
		// Комьютер-хранилище видео-файлов дисков.
		public var DisksVideosFilesWarehouse: String = WarehouseType.CLIENT;
		// Комьютер-хранилище аудио-файлов дисков.
		public var DisksAudiosFilesWarehouse: String = WarehouseType.SERVER;
		
		// Путь PHP-файла запроса выборщика URL-адресов
		// слайдов определённого типа диска.
		public var DiskSlidesFilesURLsSelectorRequestPHPFilePath:        String =
			"RequestsPHPFiles/SelectDiskSlidesFilesURLs.php";
		// URL-адрес PHP-файла запроса выборщика URL-адресов
		// слайдов определённого типа диска на компьютере-сервере.
		private var _ServerDiskSlidesFilesURLsSelectorRequestPHPFileURL: String;		
		// URL-адрес PHP-файла запроса выборщика URL-адресов
		// слайдов определённого типа диска на компьютере-клиенте.
		private var _ClientDiskSlidesFilesURLsSelectorRequestPHPFileURL: String;		
		
		// Путь к директорию, харанящему файлы изображений дисков.
		public var DisksImagesFilesDirectoryPath: String = "pic";	
		// Путь к директорию, харанящему файлы кадров фильмов дисков.
		public var DisksFramesFilesDirectoryPath: String = "scrn";	
		// Путь к директорию, харанящему видео-файлы дисков.
		public var DisksVideosFilesDirectoryPath: String = "video";	
		// Путь к директорию, харанящему аудио-файлы дисков.
		public var DisksAudiosFilesDirectoryPath: String = "audio";
		
		// Аффикс имени файла изображения диска.
		public var DiskImageFileNameAffix: String = "_pic";
		// Аффикс имени файла кадра фильма диска.
		public var DiskFrameFileNameAffix: String = "_scrshot";
		// Аффикс имени видео-файла диска.
		public var DiskVideoFileNameAffix: String = "_video";
		// Аффикс имени аудио-файла диска.
		public var DiskAudioFileNameAffix: String = "_audio";
		
		// Расширение файла изображения диска.
		public var DiskImageFileExtension: String = "jpg";			
		// Расширение файла кадра фильма диска.
		public var DiskFrameFileExtension: String = "jpg";			
		// Расширение видео-файла диска.
		public var DiskVideoFileExtension: String = "avi";			
		// Расширение аудио-файла диска.
		public var DiskAudioFileExtension: String = "mp3";			
		
		// Пути PHP-файлов запросов к базе данных MySQL.
		
		// Путь PHP-файла запроса к базе данных MySQL
		// выборщика текстовых меток кнопок меню.
		public var MenuButtonsLabelsSelectorRequestPHPFilePath:      String =
			"RequestsPHPFiles/SelectMenuButtonsLabels.php";
		// Путь PHP-файла запроса к базе данных MySQL
		// выборщика артикулов изображений из таблиц MySQL.
		public var ImagesArticlesSelectorRequestPHPFilePath:         String =
			"RequestsPHPFiles/SelectImagesArticles.php";
		// Путь PHP-файла запроса к базе данных MySQL
		// выборщика артикулов изображений, отфильтрованных по категоиям,
		// из таблиц MySQL.
		public var ImagesArticlesFilteredByCategoriesSelectorRequestPHPFilePath:
			String =
			"RequestsPHPFiles/SelectImagesArticlesFilteredByCategories.php";
		// Путь PHP-файла запроса к базе данных MySQL
		// выборщика описания диска из таблиц MySQL.
		public var DiskDescriptionSelectorRequestPHPFilePath:        String =
			"RequestsPHPFiles/SelectDiskDescription.php";		
		// Путь PHP-файла запроса к базе данных MySQL
		// выборщика кода группы диска из таблиц MySQL.
		public var DiskGroupCodeSelectorRequestPHPFilePath:          String =
			"RequestsPHPFiles/SelectDiskGroupCode.php";
		// Путь PHP-файла запроса к базе данных MySQL
		// выборщика примечаний первого типа диска из таблиц MySQL.
		public var DiskFirstTypeNotesSelectorRequestPHPFilePath:     String =
			"RequestsPHPFiles/SelectDiskFirstTypeNotes.php";
		// Путь PHP-файла запроса к базе данных MySQL
		// выборщика примечаний второго типа диска из таблиц MySQL.
		public var DiskSecondTypeNotesSelectorRequestPHPFilePath:    String =
			"RequestsPHPFiles/SelectDiskSecondTypeNotes.php";			
		// Путь PHP-файла запроса к базе данных MySQL
		// выборщика характеристик разновидностей дисков из таблиц MySQL.
		public var DiskVarietiesCharacteristicsSelectorRequestPHPFilePath:
			String = "RequestsPHPFiles/SelectDiskVarietiesCharacteristics.php";	
		// Путь PHP-файла запроса к базе данных MySQL
		// выборщика цен разновидностей дисков из таблиц MySQL.
		public var DiskVarietiesCostsSelectorRequestPHPFilePath:     String =
			"RequestsPHPFiles/SelectDiskVarietiesCosts.php";			
		// Путь PHP-файла запроса к базе данных MySQL
		// выборщика данных продаж разновидностей дисков из таблиц MySQL.
		public var DiskVarietiesSalesDataSelectorRequestPHPFilePath: String =
			"RequestsPHPFiles/SelectDiskVarietiesSalesData.php";	
		// Путь PHP-файла запроса к базе данных MySQL
		// добавителя данных продажи разновидности диска
		// в корзину покупок в таблицах MySQL.
		public var DiskVarietySaleDataToShoppingCartAdderRequestPHPFilePath:
			String = "RequestsPHPFiles/AddDiskVarietySaleDataToShoppingCart.php";	
				
		// URL-адреса PHP-файлов запросов к базе данных MySQL.
	
		// URL-адрес PHP-файла запроса к базе данных MySQL
		// выборщика текстовых меток кнопок меню.
		private var _MenuButtonsLabelsSelectorRequestPHPFileURL:      String;
		// URL-адрес PHP-файла запроса к базе данных MySQL
		// выборщика артикулов изображений из таблиц MySQL.
		private var _ImagesArticlesSelectorRequestPHPFileURL:         String;
		// URL-адрес PHP-файла запроса к базе данных MySQL
		// выборщика артикулов изображений, отфильтрованных по категоиям,
		// из таблиц MySQL.
		private var _ImagesArticlesFilteredByCategoriesSelectorRequestPHPFileURL:
			String;		
		// URL-адрес PHP-файла запроса к базе данных MySQL
		// выборщика описания диска из таблиц MySQL.
		private var _DiskDescriptionSelectorRequestPHPFileURL:        String;
		// URL-адрес PHP-файла запроса к базе данных MySQL
		// выборщика кода группы диска из таблиц MySQL.
		private var _DiskGroupCodeSelectorRequestPHPFileURL:          String;	
		// URL-адрес PHP-файла запроса к базе данных MySQL
		// выборщика примечаний первого типа диска из таблиц MySQL.
		private var _DiskFirstTypeNotesSelectorRequestPHPFileURL:     String;
		// URL-адрес PHP-файла запроса к базе данных MySQL
		// выборщика примечаний второго типа диска из таблиц MySQL.
		private var _DiskSecondTypeNotesSelectorRequestPHPFileURL:    String;
		// URL-адрес PHP-файла запроса к базе данных MySQL
		// выборщика характеристик разновидностей дисков из таблиц MySQL.
		private var _DiskVarietiesCharacteristicsSelectorRequestPHPFileURL:
			String;
		// URL-адрес PHP-файла запроса к базе данных MySQL
		// выборщика цен разновидностей дисков из таблиц MySQL.
		private var _DiskVarietiesCostsSelectorRequestPHPFileURL:     String;
		// URL-адрес PHP-файла запроса к базе данных MySQL
		// выборщика данных продаж разновидностей дисков из таблиц MySQL.
		private var _DiskVarietiesSalesDataSelectorRequestPHPFileURL: String;		
		// URL-адрес PHP-файла запроса к базе данных MySQL
		// добавителя данных продажи разновидности диска
		// в корзину покупок в таблицах MySQL.
		private var _DiskVarietySaleDataToShoppingCartAdderRequestPHPFileURL:
			String;		
		
		// Таблица кнопок меню.
		
		// Имя таблицы кнопок меню.
		public var MenuButtonsTableName:         String = "v8_reference170";		
		// Имя столбца текстовых меток в таблице кнопок меню.
		public var MenuButtonsLablesColumnName:  String = "V8_Description";
		// Имя столбца в таблице кнопок меню, упорядочивающего текстовые метки.
		public var MenuButtonsLablesOrderingColumnName:    String  = "V8_Code";
		// Направление упорядочения текстовых меток в таблице кнопок меню.
		public var MenuButtonsLablesOrderingAscendantSign: Boolean = true;			
		
		// Таблица розничных товаров.
		
		// Имя таблицы розничных товаров.
		public var RetailGoodsTableName: String = "v8_accumreg845";
		// Имя столбца идентивикаторов номенклатур в таблице розничных товаров.
		public var RetailGoodsNomenclaturesIDsColumnName:  String = "V8_Fld5206";
		// Имя столбца идентивикаторов разновидностей дисков
		// в таблице розничных товаров.
		public var RetailGoodsDisksVarietiesIDsColumnName: String = "V8_Fld5207";		
		// Имя столбца количеств в таблице розничных товаров.
		public var RetailGoodsCountsColumnName:            String = "V8_Fld5210";
		// Имя столбца цен в таблице розничных товаров.
		public var RetailGoodsCostsColumnName:             String = "V8_Fld5211";
		// Имя столбца номеров ячеек в таблице розничных товаров.
		public var RetailGoodsCellsNumbersColumnName:      String = "V8_Fld5205";
		
		// Таблица номенклатур.
		
		// Имя таблицы номенклатур.
		public var NomenclaturesTableName: String = "v8_reference118";
		// Имя столбца идентивикаторов в таблице номенклатур.
		public var NomenclaturesIDsColumnName:            String = "V8_ID";
		// Имя столбца артикулов в таблице номенклатур.
		public var NomenclaturesArticlesColumnName:       String = "V8_Fld312";
		// Имя столбца описаний в таблице номенклатур.
		public var NomenclaturesDescriptionsColumnName:   String = "V8_Fld338";
		// Имя столбца названий стран в таблице номенклатур.
		public var NomenclaturesCountriesNamesColumnName: String = "V8_Fld321";
		
		// Имя столбца дат релизов в таблице номенклатур.
		public var NomenclaturesReleasesDatesColumnName: String = "V8_Fld339";	
		// Имя столбца наименований в таблице номенклатур.
		public var NomenclaturesNamesColumnName: String = "V8_Description";
		
		// Направление упорядочения артикулов по дате в таблице номенклатур.
		// Copyright Protection: [false] - Full, [true] - Demo.
		public var NomenclaturesArticlesDateOrderingAscentSign: Boolean = true;//false;
		// Направление упорядочения артикулов по наименованию
		// в таблице номенклатур.
		// Copyright Protection: [true] - Full, [false] - Demo.
		public var NomenclaturesArticlesNameOrderingAscentSign: Boolean = false;//true;		
		
		// Имя столбца признаков витрины в таблице номенклатур.
		public var NomenclaturesShopWindowFlagsColumnName: String = "V8_Fld344";
		// Имя столбца признаков новинок в таблице номенклатур.
		public var NomenclaturesNoveltiesFlagsColumnName:  String = "V8_Fld342";
		// Имя столбца признаков стран в таблице номенклатур.
		public var NomenclaturesCountriesFlagsColumnName:  String = "V8_Fld343";
		// Имя столбца признаков групп в таблице номенклатур.
		public var NomenclaturesGroupsFlagsColumnName:     String = "V8_Fld341";
		
		// Таблица категорий товаров и номенклатур.
		
		// Имя таблицы категорий товаров и номенклатур.
		public var GoodsCategoriesAndNomenclaturesTableName:
			String = "v8_reference118_vt119";
		// Имя столбца идентивикаторов номенклатур
		// в таблице категорий товаров и номенклатур.
		public var GoodsCategoriesAndNomenclaturesNomenclaturesIDsColumnName:
			String = "V8_ID";
		// Имя столбца идентивикаторов категорий товаров
		// в таблице категорий товаров и номенклатур.
		public var GoodsCategoriesAndNomenclaturesGoodsCategoriesIDsColumnName:
			String = "V8_Fld345";		
			
		// Таблица категорий товаров.
		
		// Имя таблицы категорий товаров.
		public var GoodsCategoriesTableName:       String = "v8_reference168";
		// Имя столбца идентивикаторов в таблице категорий товаров.
		public var GoodsCategoriesIDsColumnName:   String = "V8_ID";
		// Имя столбца кодов в таблице категорий товаров.
		public var GoodsCategoriesCodesColumnName: String = "V8_Code";
		// Имя столбца наименований в таблице категорий товаров.
		public var GoodsCategoriesNamesColumnName: String = "V8_Description";
		
		// Таблица ссылок свойств.
		
		// Имя таблицы ссылок свойств.
		public var PropertiesReferencesTableName: String = "v8_inforeg715";
		// Имя столбца идентивикаторов номенклатур в таблице ссылок свойств.
		public var PropertiesReferencesNomenclaturesIDsColumnName:
			String = "V8_Fld4278_RRef";
		// Имя столбца идентивикаторов значений свойств
		// в таблице ссылок свойств.
		public var PropertiesReferencesPropertiesValuesIDsColumnName:
			String = "V8_Fld4280_RRef";
			
		// Таблица значений свойств.
			
		// Имя таблицы значений свойств.
		public var PropertiesValuesTableName:     String   = "v8_reference88";
		// Имя столбца идентивикаторов в таблице значений свойств.
		public var PropertiesValuesIDsColumnName: String   = "V8_ID";
		// Имя столбца наименований в таблице значений свойств.
		public var PropertiesValuesNamesColumnName: String = "V8_Description";
		
		// Таблица групп товаров.
		
		// Имя таблицы групп товаров.
		public var GoodsGroupsTableName:       String = "v8_reference167";
		// Имя столбца кодов в таблице групп товаров.
		public var GoodsGroupsCodesColumnName: String = "V8_Code";
		// Имя столбца наименований в таблице групп товаров.
		public var GoodsGroupsNamesColumnName: String = "V8_Description";
		
		// Таблица разновидностей дисков.
		
		// Направление упорядочения разновидностей дисков по идентификатору.
		public var DisksVarietiesIDOrderingAscentSign: Boolean = true;
		
		// Таблица ссылок разновидностей дисков.
		
		// Имя таблицы ссылок разновидностей дисков.
		public var DisksVarietiesReferencesTableName: String = "v8_inforeg793";
		// Имя столбца идентивикаторов номенклатур
		// в таблице ссылок разновидностей дисков.
		public var DisksVarietiesReferencesNomenclaturesIDsColumnName:
			String = "V8_Fld4743";
		// Имя столбца идентивикаторов характеристик разновидностей дисков
		// в таблице ссылок разновидностей дисков.
		public var
			DisksVarietiesReferencesDisksVarietiesCharacteristicsIDsColumnName:
			String = "V8_Fld4745";
		// Имя столбца идентивикаторов разновидностей дисков
		// в таблице ссылок разновидностей дисков.
		public var DisksVarietiesReferencesDisksVarietiesIDsColumnName:
			String = "V8_Fld4744";		
		
		// Таблица названий характеристик дисков.
		
		// Имя таблицы названий характеристик дисков.
		public  var DisksCharacteristicsNamesTableName:
			String = "v8_reference165";
		// Имя столбца наименований групп в таблице названий характеристик дисков.
		public  var DisksCharacteristicsNamesGroupsNamesColumnName:
			String = "V8_Description";
		
		// Таблица характеристик разновидностей дисков.
		
		// Имя таблицы характеристик разновидностей дисков.
		public var DisksVarietiesCharacteristicsTableName:
			String = "v8_reference165";
		// Имя столбца идентификаторов
		// в таблице характеристик разновидностей дисков.
		public var DisksVarietiesCharacteristicsIDsColumnName: String = "V8_ID";
		
		// Таблица корзины покупок.
		
		// Имя таблицы корзины покупок.
		public var ShoppingCartTableName:                   String = "korz";
		// Имя столбца идентивикаторов в таблице корзины покупок.
		public var ShoppingCartIDsColumnName:               String = "id";	
		// Имя столбца идентивикаторов номенклатур в таблице корзины покупок.
		public var ShoppingCartNomenclaturesIDsColumnName:  String = "disk_id";	
		// Имя столбца идентивикаторов разновидностей дисков
		// в таблице корзины покупок.
		public var ShoppingCartDisksVarietiesIDsColumnName: String = "raz_id";
		// Имя столбца цен в таблице корзины покупок.
		public var ShoppingCartCostsColumnName:             String = "cena";
		// Имя столбца номеров ячеек в таблице корзины покупок.
		public var ShoppingCartCellsNumbersColumnName:      String = "cell_num";
		
		// Массивы параметров выбора изображений дисков.			
			
		// Имена столбцов, фильтрующих изображения дисков.
		private var _DisksImagesFilteringColumnsNames: Array = new Array( );
		// Имена столбцов, упорядочивающих изображения дисков.
		private var _DisksImagesOrderingColumnsNames:  Array = new Array( );	
		// Направления упорядочения изображений дисков.
		private var _DisksImagesOrderingAscentSigns:   Array = new Array( );
		
		// Параметры выбора изображений дисков.
		private var _DisksImagesChoiceParameters: Object =
		{
			// Неизвестный экран выбора.
			UNKNOWN: null,
			
			// Экран выбора по умолчанию.
			DEFAULT:
			{
				// Неизвестная строка изображений.
				UNKNOWN: null,			
				
				// Верхняя строка изображений.
				UPPER:
					// Новинки кино.
					new ImagesNamesSelectorParameters
					(
						// Тип фильрации - витрина.
						ImagesNamesFilteringType.SHOP_WINDOW,
						// Значение фильтра.
						1,
						// Тип упорядочения - по дате.
						ImagesNamesOrderingType.DATE
					), // ImagesLineType.UPPER
					
				// Средняя строка изображений.
				MIDDLE:
					// Новинки игр.				
					new ImagesNamesSelectorParameters
					(
						// Тип фильрации - витрина.
						ImagesNamesFilteringType.SHOP_WINDOW,
						// Значение фильтра.
						2,
						// Тип упорядочения - по дате.
						ImagesNamesOrderingType.DATE 
					), // ImagesLineType.MIDDLE	

				// Нижняя строка изображений.
				LOWER:
					// Новинки музыки.				
					new ImagesNamesSelectorParameters
					(
						// Тип фильрации - витрина.
						ImagesNamesFilteringType.SHOP_WINDOW,
						// Значение фильтра.
						3,
						// Тип упорядочения - по дате.
						ImagesNamesOrderingType.DATE 
					) // ImagesLineType.LOWER				
			}, // ChoiceScreenType.DEFAULT
			
			// Экран выбора новых DVD.
			NEW_DVD:
			{
				// Неизвестная строка изображений.
				UNKNOWN: null,
				
				// Верхняя строка изображений.
				UPPER:
					// Новинки.
					new ImagesNamesSelectorParameters
					(
						// Тип фильрации - новинка.
						ImagesNamesFilteringType.NOVELTY,
						// Значение фильтра.
						1,
						// Тип упорядочения - по дате.
						ImagesNamesOrderingType.DATE		 
					), // ImagesLineType.UPPER

				// Средняя строка изображений.
				MIDDLE:
					// Зарубежные.				
					new ImagesNamesSelectorParameters
					(
						// Тип фильрации - страна.
						ImagesNamesFilteringType.COUNTRY,
						// Значение фильтра.
						2,
						// Тип упорядочения - по наименованию.
						ImagesNamesOrderingType.NAME		 
					), // ImagesLineType.MIDDLE

				// Нижняя строка изображений.
				LOWER:
					// Отечественные.				
					new ImagesNamesSelectorParameters
					(
						// Тип фильрации - страна.
						ImagesNamesFilteringType.COUNTRY,
						// Значение фильтра.
						1,
						// Тип упорядочения - по наименованию.
						ImagesNamesOrderingType.NAME		 
					) // ImagesLineType.LOWER				
			}, // ChoiceScreenType.NEW_DVD	
			
			// Экран выбора первых хитов.
			FIRST_HITS:
			{
				// Неизвестная строка изображений.
				UNKNOWN: null,		
				
				// Верхняя строка изображений.
				UPPER:
					// Blu-ray.
					new ImagesNamesSelectorParameters
					(
						// Тип фильрации - группа.
						ImagesNamesFilteringType.GROUP,
						// Значение фильтра.
						MySQLParameters.DISKS_GROUPS_VALUES[ DiskGroup.BLU_RAY ],
						// Тип упорядочения - по наименованию.
						ImagesNamesOrderingType.NAME	 
					), // ImagesLineType.UPPER
					
				// Средняя строка изображений.
				MIDDLE:
					// DVD-фильмы.				
					new ImagesNamesSelectorParameters
					(
						// Тип фильрации - группа.
						ImagesNamesFilteringType.GROUP,
						// Значение фильтра.
						MySQLParameters.DISKS_GROUPS_VALUES[ DiskGroup.DVD_FILMS ],
						// Тип упорядочения - по наименованию.
						ImagesNamesOrderingType.NAME	 
					), // ImagesLineType.MIDDLE
				
				// Нижняя строка изображений.
				LOWER:
					//  DVD-музыка.				
					new ImagesNamesSelectorParameters
					(
						// Тип фильрации - группа.
						ImagesNamesFilteringType.GROUP,
						// Значение фильтра.
						MySQLParameters.DISKS_GROUPS_VALUES[ DiskGroup.DVD_MUSIC ],
						// Тип упорядочения - по наименованию.
						ImagesNamesOrderingType.NAME	 
					) // ImagesLineType.LOWER
			}, // ChoiceScreenType.FIRST_HITS
			
			// Экран выбора вторых хитов.
			SECOND_HITS:
			{
				// Неизвестная строка изображений.
				UNKNOWN: null,
				
				// Верхняя строка изображений.
				UPPER:
					// PS3.
					new ImagesNamesSelectorParameters
					(
						// Тип фильрации - группа.
						ImagesNamesFilteringType.GROUP,
						// Значение фильтра.
						MySQLParameters.DISKS_GROUPS_VALUES[ DiskGroup.GAMES ],
						// Тип упорядочения - по наименованию.
						ImagesNamesOrderingType.NAME	 
					), // ImagesLineType.UPPER				

				// Средняя строка изображений.
				MIDDLE:
					// ПК.				
					new ImagesNamesSelectorParameters
					(
						// Тип фильрации - группа.
						ImagesNamesFilteringType.GROUP,
						// Значение фильтра.
						MySQLParameters.DISKS_GROUPS_VALUES[ DiskGroup.PC_GAMES ],
						// Тип упорядочения - по наименованию.
						ImagesNamesOrderingType.NAME		 
					), // ImagesLineType.MIDDLE	
					
				// Нижняя строка изображений.
				LOWER:
					// СD.				
					new ImagesNamesSelectorParameters
					(
						// Тип фильрации - группа.
						ImagesNamesFilteringType.GROUP,
						// Значение фильтра.
						MySQLParameters.DISKS_GROUPS_VALUES[ DiskGroup.CD_MUSIC ],
						// Тип упорядочения - по наименованию.
						ImagesNamesOrderingType.NAME	 
					) // ImagesLineType.LOWER
			}, // ChoiceScreenType.SECOND_HITS
			
			// Экран выбора первых DVD.
			FIRST_DVD:
			{
				// Неизвестная строка изображений.
				UNKNOWN: null,
				
				// Верхняя строка изображений.
				UPPER:
					// Приключения.
					new ImagesNamesSelectorParameters
					(
						// Тип фильрации - категория.
						ImagesNamesFilteringType.CATEGORY,
						// Значение фильтра.
						MySQLParameters.DISKS_CATEGORIES_VALUES
							[ DiskCategory.ADVENTURES ],
						// Тип упорядочения - по наименованию.
						ImagesNamesOrderingType.NAME		 
					), // ImagesLineType.UPPER
					
				// Средняя строка изображений.
				MIDDLE:
					// Драма.				
					new ImagesNamesSelectorParameters
					(
						// Тип фильрации - категория.
						ImagesNamesFilteringType.CATEGORY,
						// Значение фильтра.
						MySQLParameters.DISKS_CATEGORIES_VALUES[ DiskCategory.DRAMA ],
						// Тип упорядочения - по наименованию.
						ImagesNamesOrderingType.NAME		 
					), // ImagesLineType.MIDDLE
					
				// Нижняя строка изображений.
				LOWER:
					// Мультфильмы.				
					new ImagesNamesSelectorParameters
					(
						// Тип фильрации - категория.
						ImagesNamesFilteringType.CATEGORY,
						// Значение фильтра.
						MySQLParameters.DISKS_CATEGORIES_VALUES
							[ DiskCategory.ANIMATION ],
						// Тип упорядочения - по наименованию.
						ImagesNamesOrderingType.NAME 
					) // ImagesLineType.LOWER
			}, // ChoiceScreenType.FIRST_DVD
			
			// Экран выбора вторых DVD.
			SECOND_DVD:
			{
				// Неизвестная строка изображений.
				UNKNOWN: null,
				
				// Верхняя строка изображений.
				UPPER:
					// Прочее.
					new ImagesNamesSelectorParameters
					(
						// Тип фильрации - категория.
						ImagesNamesFilteringType.CATEGORY,
						// Значение фильтра.
						MySQLParameters.DISKS_CATEGORIES_VALUES
							[ DiskCategory.MISCELLANEOUS ],
						// Тип упорядочения - по наименованию.
						ImagesNamesOrderingType.NAME			 
					), // ImagesLineType.UPPER
					
				// Средняя строка изображений.
				MIDDLE:
					// Советские.		
					new ImagesNamesSelectorParameters
					(
						// Тип фильрации - категория.
						ImagesNamesFilteringType.CATEGORY,
						// Значение фильтра.
						MySQLParameters.DISKS_CATEGORIES_VALUES[ DiskCategory.SOVIET ],
						// Тип упорядочения - по наименованию.
						ImagesNamesOrderingType.NAME	 
					), // ImagesLineType.MIDDLE
						
				// Нижняя строка изображений.
				LOWER:
					// Познавательные.
					new ImagesNamesSelectorParameters
					(
						// Тип фильрации - категория.
						ImagesNamesFilteringType.CATEGORY,
						// Значение фильтра.
						MySQLParameters.DISKS_CATEGORIES_VALUES[ DiskCategory.STUDY ],
						// Тип упорядочения - по наименованию.
						ImagesNamesOrderingType.NAME		 
					) // ImagesLineType.UPPER
			}, // ChoiceScreenType.SECOND_DVD
			
			// Экран выбора Blu-ray.
			BLU_RAY:
			{
				// Неизвестная строка изображений.
				UNKNOWN: null,	
				
				// Верхняя строка изображений.
				UPPER:
					// Blu-ray-новинки.
					new ImagesNamesSelectorParameters
					(
						// Тип фильрации - категория.
						ImagesNamesFilteringType.CATEGORY,
						// Значение фильтра.
						MySQLParameters.DISKS_CATEGORIES_VALUES
							[ DiskCategory.BLU_RAY_NOVELTIES ],
						// Тип упорядочения - по дате.
						ImagesNamesOrderingType.DATE		 
					), // ImagesLineType.UPPER
						
				// Средняя строка изображений.
				MIDDLE:
					// Blu-ray-зарубежные.				
					new ImagesNamesSelectorParameters
					(
						// Тип фильрации - категория.
						ImagesNamesFilteringType.CATEGORY,
						// Значение фильтра.
						MySQLParameters.DISKS_CATEGORIES_VALUES
							[ DiskCategory.BLU_RAY_OVERSEAS ],
						// Тип упорядочения - по наименованию.
						ImagesNamesOrderingType.NAME	 
					), // ImagesLineType.MIDDLE
						
				// Нижняя строка изображений.
				LOWER:
					// Blu-ray-отечественные.				
					new ImagesNamesSelectorParameters
					(
						// Тип фильрации - категория.
						ImagesNamesFilteringType.CATEGORY,
						// Значение фильтра.
						MySQLParameters.DISKS_CATEGORIES_VALUES
							[ DiskCategory.BLU_RAY_DOMESTIC ],
						// Тип упорядочения - по наименованию.
						ImagesNamesOrderingType.NAME	 
					) // ImagesLineType.LOWER
			}, // ChoiceScreenType.BLU_RAY
			
			// Экран выбора игр.
			GAMES:
			{
				// Неизвестная строка изображений.
				UNKNOWN: null,	
				
				// Верхняя строка изображений.
				UPPER:
					// PS3.
					new ImagesNamesSelectorParameters
					(
						// Тип фильрации - категория.
						ImagesNamesFilteringType.CATEGORY,
						// Значение фильтра.
						MySQLParameters.DISKS_CATEGORIES_VALUES[ DiskCategory.PS3 ],
						// Тип упорядочения - по наименованию.
						ImagesNamesOrderingType.NAME		 
					), // ImagesLineType.UPPER
					
				// Средняя строка изображений.
				MIDDLE:
					// XBox360.				
					new ImagesNamesSelectorParameters
					(
						// Тип фильрации - категория.
						ImagesNamesFilteringType.CATEGORY,
						// Значение фильтра.
						MySQLParameters.DISKS_CATEGORIES_VALUES[ DiskCategory.XBOX360 ],
						// Тип упорядочения - по наименованию.
						ImagesNamesOrderingType.NAME	 
					), // ImagesLineType.MIDDLE
					
				// Нижняя строка изображений.
				LOWER:
					// Nintendo.				
					new ImagesNamesSelectorParameters
					(
						// Тип фильрации - категория.
						ImagesNamesFilteringType.CATEGORY,
						// Значение фильтра.
						MySQLParameters.DISKS_CATEGORIES_VALUES[ DiskCategory.NINTENDO ],
						// Тип упорядочения - по наименованию.
						ImagesNamesOrderingType.NAME	 
					) // ImagesLineType.LOWER
			}, // ChoiceScreenType.GAMES
			
			// Экран выбора игр для ПК.
			PC_GAMES:
			{
				// Неизвестная строка изображений.
				UNKNOWN: null,		
				
				// Верхняя строка изображений.
				UPPER:
					// Новинки игр для ПК.
					new ImagesNamesSelectorParameters
					(
						// Тип фильрации - категория.
						ImagesNamesFilteringType.CATEGORY,
						// Значение фильтра.
						MySQLParameters.DISKS_CATEGORIES_VALUES
							[ DiskCategory.PC_GAMES_NOVELTIES ],
						// Тип упорядочения - по дате.
						ImagesNamesOrderingType.DATE		 
					), // ImagesLineType.UPPER
						
				// Средняя строка изображений.
				MIDDLE:
					// Зарубежные игры для ПК.		
					new ImagesNamesSelectorParameters
					(
						// Тип фильрации - категория.
						ImagesNamesFilteringType.CATEGORY,
						// Значение фильтра.
						MySQLParameters.DISKS_CATEGORIES_VALUES
							[ DiskCategory.PC_GAMES_OVERSEAS ],
						// Тип упорядочения - по наименованию.
						ImagesNamesOrderingType.NAME 
					), // ImagesLineType.MIDDLE,
						
				// Нижняя строка изображений.
				LOWER:
					// Отечественные игры для ПК.	
					new ImagesNamesSelectorParameters
					(
						// Тип фильрации - категория.
						ImagesNamesFilteringType.CATEGORY,
						// Значение фильтра.
						MySQLParameters.DISKS_CATEGORIES_VALUES
							[ DiskCategory.PC_GAMES_DOMESTIC ],
						// Тип упорядочения - по наименованию.
						ImagesNamesOrderingType.NAME		 
					) // ImagesLineType.LOWER
			}, // ChoiceScreenType.PC_GAMES			
			
			// Экран выбора музыки DVD.
			DVD_MUSIC:
			{
				// Неизвестная строка изображений.
				UNKNOWN: null,	
				
				// Верхняя строка изображений.
				UPPER:
					// Новинки DVD-музыки.
					new ImagesNamesSelectorParameters
					(
						// Тип фильрации - категория.
						ImagesNamesFilteringType.CATEGORY,
						// Значение фильтра.
						MySQLParameters.DISKS_CATEGORIES_VALUES
							[ DiskCategory.DVD_MUSIC_NOVELTIES ],
						// Тип упорядочения - по дате.
						ImagesNamesOrderingType.DATE	 
					), // ImagesLineType.UPPER
						
				// Средняя строка изображений.
				MIDDLE:
					// Зарубежная DVD-музыка.		
					new ImagesNamesSelectorParameters
					(
						// Тип фильрации - категория.
						ImagesNamesFilteringType.CATEGORY,
						// Значение фильтра.
						MySQLParameters.DISKS_CATEGORIES_VALUES
							[ DiskCategory.DVD_MUSIC_OVERSEAS ],
						// Тип упорядочения - по наименованию.
						ImagesNamesOrderingType.NAME 
					), // ImagesLineType.MIDDLE
						
				// Нижняя строка изображений.
				LOWER:
					// Отечественная DVD-музыка.
					new ImagesNamesSelectorParameters
					(
						// Тип фильрации - категория.
						ImagesNamesFilteringType.CATEGORY,
						// Значение фильтра.
						MySQLParameters.DISKS_CATEGORIES_VALUES
							[ DiskCategory.DVD_MUSIC_DOMESTIC ],
						// Тип упорядочения - по наименованию.
						ImagesNamesOrderingType.NAME	 
					) // ImagesLineType.LOWER
			}, // ChoiceScreenType.DVD_MUSIC	
			
			// Экран выбора музыки CD.
			CD_MUSIC:
			{
				// Неизвестная строка изображений.
				UNKNOWN: null,
				
				// Верхняя строка изображений.
				UPPER:
					// Новинки CD-музыки.
					new ImagesNamesSelectorParameters
					(
						// Тип фильрации - категория.
						ImagesNamesFilteringType.CATEGORY,
						// Значение фильтра.
						MySQLParameters.DISKS_CATEGORIES_VALUES
							[ DiskCategory.CD_MUSIC_NOVELTIES ],
						// Тип упорядочения - по дате.
						ImagesNamesOrderingType.DATE			 
					), // ImagesLineType.UPPER
						
				// Средняя строка изображений.
				MIDDLE:
					// Зарубежная CD-музыка.				
					new ImagesNamesSelectorParameters
					(
						// Тип фильрации - категория.
						ImagesNamesFilteringType.CATEGORY,
						// Значение фильтра.
						MySQLParameters.DISKS_CATEGORIES_VALUES
							[ DiskCategory.CD_MUSIC_OVERSEAS ],
						// Тип упорядочения - по наименованию.
						ImagesNamesOrderingType.NAME	 
					), // ImagesLineType.MIDDLE
						
				// Нижняя строка изображений.
				LOWER:
					// Отечественная CD-музыка.	
					new ImagesNamesSelectorParameters
					(
						// Тип фильрации - категория.
						ImagesNamesFilteringType.CATEGORY,
						// Значение фильтра.
						MySQLParameters.DISKS_CATEGORIES_VALUES
							[ DiskCategory.CD_MUSIC_DOMESTIC ],
						// Тип упорядочения - по наименованию.
						ImagesNamesOrderingType.NAME 
					) // ImagesLineType.LOWER
			} // ChoiceScreenType.CD_MUSIC			
		} // _DisksImagesChoiceParameters
		
		// Массивы имён столбцов таблиц.
		
		// Строка-разделитель элементов массивов.
		public var ArraysSeparatorString: String = "|";
		
		// Массив имён столбцов названий в таблице названий характеристик дисков.
		private var _DisksCharacteristicsNamesNamesColumnsNames: Array =
		[
			"V8_Fld559",
			"V8_Fld560",
			"V8_Fld561",
			"V8_Fld562",
			"V8_Fld563",
			"V8_Fld564",
			"V8_Fld565",
			"V8_Fld566",
			"V8_Fld567",
			"V8_Fld568",
			"V8_Fld569",
			"V8_Fld570",
			"V8_Fld571",
			"V8_Fld572",
			"V8_Fld573"
		]; // _DisksCharacteristicsNamesNamesColumnsNames
		
		// Массив имён столбцов характеристик
		// в таблице характеристик разновидностей дисков.
		private var _DisksVarietiesCharacteristicsCharacteristicsColumnsNames:
			Array =
		[
			"V8_Fld559",
			"V8_Fld560",
			"V8_Fld561",
			"V8_Fld562",
			"V8_Fld563",
			"V8_Fld564",
			"V8_Fld565",
			"V8_Fld566",
			"V8_Fld567",
			"V8_Fld568",
			"V8_Fld569",
			"V8_Fld570",
			"V8_Fld571",
			"V8_Fld572",
			"V8_Fld573"
		]; // _DisksVarietiesCharacteristicsCharacteristicsColumnsNames
		
		// Медиа-плеер.
		
		// Путь к директорию на localhost клиента, хранящему файлы медиа-плеера.
		public  var MediaPlayerDirectoryPath: String = "ZMediaPlayer_32";
		
		// Имя файла PHP-файла запроса открывателя медиа-плеера
		// в директории на localhost, хранящем файлы медиа-плеера.
		public  var MediaPlayerOpenerRequestPHPFileName: String =
			"OpenMediaPlayer.php";
		// URL-адрес PHP-файла запроса открывателя медиа-плеера.
		private var _MediaPlayerOpenerRequestPHPFileURL: String;
		
		// Имя файла медиа-плеера.
		public  var MediaPlayerFileName:         String = "ZMediaPlayer.exe";
		// Имя файла настроек медиа-плеера.
		public  var MediaPlayerSettingsFileName: String =
			"ZMediaPayerSettings.xml";
		//-----------------------------------------------------------------------
		// Методы экземпляра класса.
		
		// Метод загрузки настроек.
		public function LoadSettings( ): void
		{
			// Загрузчик данных с URL-адреса файла настроек.
			var settingsFileURLLoader: URLLoader = new URLLoader( );
			// Загрузка данных с URL-адреса файла настроек.
			settingsFileURLLoader.load
				( new URLRequest( this._SettingsFilePath ) );
				
			// Регистрирация объекта-прослушивателя события
			// успешной загрузки данных с URL-адреса файла настроек.
			settingsFileURLLoader.addEventListener( Event.COMPLETE,
				this.SettingsFileURLLoadingCompleteListener );
			// Регистрирация объекта-прослушивателя события возникновения ошибки
			// при загрузке данных с URL-адреса файла настроек.
			settingsFileURLLoader.addEventListener( IOErrorEvent.IO_ERROR,
				this.SettingsFileURLLoadingIOErrorListener );		
		} // LoadSettings		
		
		// Метод загрузки демонстрационных настроек.
		public function LoadDemoSettings( ): void
		{
			// Загрузчик данных с URL-адреса файла демонстрационных настроек.
			var demoSettingsFileURLLoader: URLLoader = new URLLoader( );
			// Загрузка данных с URL-адреса файла демонстрационных настроек.
			demoSettingsFileURLLoader.load
				( new URLRequest( this._DemoSettingsFilePath ) );
				
			// Регистрирация объекта-прослушивателя события успешной загрузки
			// данных с URL-адреса файла демонстрационных настроек.
			demoSettingsFileURLLoader.addEventListener( Event.COMPLETE,
				this.DemoSettingsFileURLLoadingCompleteListener );
			// Регистрирация объекта-прослушивателя события возникновения ошибки
			// при загрузке данных с URL-адреса файла демонстрационных настроек.
			demoSettingsFileURLLoader.addEventListener( IOErrorEvent.IO_ERROR,
				this.DemoSettingsFileURLLoadingIOErrorListener );		
		} // LoadDemoSettings		
		
		// Метод получения пути к директорию,
		// хранящему документы на компьютере-хранилище.
		// Параметры:
		// parWarehouse - компьютер-хранилище.
		// Результат: путь к директорию,
		// хранящему документы на компьютере-хранилище.
		public function GetWarehouseDocumentRoot( parWarehouse: String ): String
		{
			// Вызов метода класса.
			this._MainTracer.CallClassMethod( MySQLParameters.CLASS_NAME,
				"GetWarehouseDocumentRoot", parWarehouse );			
			
			// Компьютер-хранилище.
			parWarehouse = WarehouseType.GetValueFromString( parWarehouse );
			// Если хранилище - сервер.
			if ( parWarehouse == WarehouseType.SERVER )
				// Путь к директорию, хранящему документы на компьютере-сервере.
				return this.ServerDocumentRoot;
			// Если хранилище - не сервер.
			else
				// Путь к директорию, хранящему документы на компьютере-клиенте.
				return this.ClientDocumentRoot;
		} // GetWarehouseDocumentRoot
		
		// Метод получения URL-адреса компьютера-хранилища.
		// Параметры:
		// parWarehouse - компьютер-хранилище.
		// Результат: URL-адрес компьютера-хранилища.
		public function GetWarehouseURL( parWarehouse: String ): String
		{
			// Вызов метода класса.
			this._MainTracer.CallClassMethod( MySQLParameters.CLASS_NAME,
				"GetWarehouseURL", parWarehouse );			
			
			// Компьютер-хранилище.
			parWarehouse = WarehouseType.GetValueFromString( parWarehouse );
			// Если хранилище - сервер.
			if ( parWarehouse == WarehouseType.SERVER )
				// URL-адрес компьютера-сервера.
				return this._ServerURL;
			// Если хранилище - не сервер.
			else
				// URL-адрес компьютера-клиента.
				return this._ClientURL;
		} // GetWarehouseURL
		
		// Метод получения URL-адреса PHP-файла запроса выборщика URL-адресов
		// слайдов определённого типа диска на компьютере-хранилище.
		// Параметры:
		// parWarehouse - компьютер-хранилище.
		// Результат: URL-адрес PHP-файла запроса выборщика URL-адресов
		// слайдов определённого типа диска на компьютере-хранилище.
		public function GetWarehouseDiskSlidesFilesURLsSelectorRequestPHPFileURL
			( parWarehouse: String ): String
		{
			// Вызов метода класса.
			this._MainTracer.CallClassMethod( MySQLParameters.CLASS_NAME,
				"GetWarehouseDiskSlidesFilesURLsSelectorRequestPHPFileURL",
				parWarehouse );			
			
			// Компьютер-хранилище.
			parWarehouse = WarehouseType.GetValueFromString( parWarehouse );
			// Если хранилище - сервер.
			if ( parWarehouse == WarehouseType.SERVER )
				// URL-адрес PHP-файла запроса выборщика URL-адресов
				// слайдов определённого типа диска на компьютере-сервере.
				return this._ServerDiskSlidesFilesURLsSelectorRequestPHPFileURL;
			// Если хранилище - не сервер.
			else
				// URL-адрес PHP-файла запроса выборщика URL-адресов
				// слайдов определённого типа диска на компьютере-клиенте.
				return this._ClientDiskSlidesFilesURLsSelectorRequestPHPFileURL;
		} // GetWarehouseDiskSlidesFilesURLsSelectorRequestPHPFileURL		
		
		// Метод получения группы диска.
		// Параметры:
		// parDiskGroupValue - значение группы диска.
		// Результат: группа диска.
		public static function GetDiskGroup( parDiskGroupValue: Object ): String
		{
			// Последовательный просмотр всех известных групп дисков.
			for ( var diskGroupIndex: uint =
				DiskGroup.KNOWN_VALUE_MINIMUM_INDEX; diskGroupIndex <
				DiskGroup.KNOWN_VALUE_MAXIMUM_INDEX; diskGroupIndex++ )
			{
				// Текущая группа диска.
				var diskGroup: String = DiskGroup.ValueOfIndex( diskGroupIndex );
					
				// Если значение текущей группы диска равно заданному.
				if ( MySQLParameters.DISKS_GROUPS_VALUES[ diskGroup ] ==
						parDiskGroupValue )
					// Искомая группа диска - текущая.
					return diskGroup;
			} // for
				
			// Группа диска не определена, значит, она не известна.
			return DiskGroup.UNKNOWN;			
		} // GetDiskGroup
		
		// Метод получения типа примечаний группы диска.
		// Параметры:
		// parDiskGroup - группа диска.
		// Результат: тип примечаний диска.
		public function GetDiskGroupNotesType
			( parDiskGroup: String ): String
		{
			// Вызов метода класса.
			this._MainTracer.CallClassMethod( MySQLParameters.CLASS_NAME,
				"GetDiskGroupNotesType", parDiskGroup );			
			
			// Группа диска.
			parDiskGroup = DiskGroup.GetValueFromString( parDiskGroup );
			// Тип примечаний диска, определённый по его группе.
			return MySQLParameters.DISKS_NOTES_TYPES[ parDiskGroup ];
		} // GetDiskGroupNotesType
		
		// Методы массива имён столбцов названий
		// в таблице названий характеристик дисков.
		
		// Метод получения имени столбца названий
		// в таблице названий характеристик дисков.
		// Параметры:
		// parColumnNameIndex - индекс имени столбца названий
		//   в таблице названий характеристик дисков.
		// Результат: имя столбца названий
		// в таблице названий характеристик дисков.
		public function GetDisksCharacteristicsNamesNamesColumnName
			( parColumnNameIndex: uint ): String
		{
			// Вызов метода класса.
			this._MainTracer.CallClassMethod( MySQLParameters.CLASS_NAME,
				"GetDisksCharacteristicsNamesNamesColumnName", parColumnNameIndex );
			
			// Если индекс имени столбца находится вне допустимых границ.
			if ( parColumnNameIndex >=
					this._DisksCharacteristicsNamesNamesColumnsNames.length )
				// Имя столбца названий в таблице названий характеристик дисков
				// не определено.
				return null;
			// Имя столбца названий в таблице названий характеристик дисков
			// по заданному индексу.
			return this._DisksCharacteristicsNamesNamesColumnsNames
				[ parColumnNameIndex ];
		} // GetDisksCharacteristicsNamesNamesColumnName	
		
		// Метод установки имени столбца названий
		// в таблице названий характеристик дисков.
		// Параметры:
		// parColumnNameIndex - индекс имени столбца названий
		//   в таблице названий характеристик дисков,
		// parColumnName      - имя столбца названий
		//   в таблице названий характеристик дисков.
		public function SetDisksCharacteristicsNamesNamesColumnName
		(
			parColumnNameIndex: uint,
			parColumnName:      String
		): void	
		{
			// Вызов метода класса.
			this._MainTracer.CallClassMethod( MySQLParameters.CLASS_NAME,
				"SetDisksCharacteristicsNamesNamesColumnName", parColumnNameIndex,
				parColumnName );			
			
			// Если индекс имени столбца находится вне допустимых границ.
			if ( parColumnNameIndex >=
					MySQLParameters.DISKS_CHARACTERISTICS_MAXIMUN_COUNT )
				// Имя столбца названий в таблице названий характеристик дисков
				// не устанавливается.
				return;
			// Установка имени столбца названий
			// в таблице названий характеристик дисков по заданному индексу.
			this._DisksCharacteristicsNamesNamesColumnsNames
				[ parColumnNameIndex ] = parColumnName;
		} // SetDisksCharacteristicsNamesNamesColumnName

		// Метод получения строки массива имён столбцов названий
		// в таблице названий характеристик дисков.
		// Результат: строка массива имён столбцов названий
		// в таблице названий характеристик дисков.
		public function GetDisksCharacteristicsNamesNamesColumnsNamesString
			( ): String
		{
			// Вызов метода класса.
			this._MainTracer.CallClassMethod( MySQLParameters.CLASS_NAME,
				"GetDisksCharacteristicsNamesNamesColumnsNamesString" );		
			
			// Строка элементов массива имён столбцов названий
			// в таблице названий характеристик дисков,
			// отделённых друг от друга строкой-разделителем элементов массивов.
			return this._DisksCharacteristicsNamesNamesColumnsNames.join
				( this.ArraysSeparatorString );	
			/*		
			// Строка массива имён столбцов названий
			// в таблице названий характеристик дисков.
			var arrayString: String = TextParameters.EMPTY_STRNG;
			// Индекс последнего имени столбца названий
			// в таблице названий характеристик дисков.
			var lastColumnNameIndex =
				this._DisksCharacteristicsNamesNamesColumnsNames.length - 1;
			
			// Последовательный просмотр всех имён столбцов названий
			// в таблице названий характеристик дисков, кроме последнего.
			for ( var columnNameIndex: uint = 0; columnNameIndex <
					lastColumnNameIndex; columnNameIndex++ )
				// Добавление текущего имени столбца названий
				// в таблице названий характеристик дисков
				// и строки-разделителя элементов массивов в строку массива.
				arrayString += this._DisksCharacteristicsNamesNamesColumnsNames
					[ columnNameIndex ] + this.ArraysSeparatorString;					
			// Добавление последнего имени столбца названий
			// в таблице названий характеристик дисков в строку массива.
			arrayString += this._DisksCharacteristicsNamesNamesColumnsNames
				[ lastColumnNameIndex ];
				
			// Строка массива имён столбцов названий
			// в таблице названий характеристик дисков.
			return arrayString;
		*/		
		} // GetDisksCharacteristicsNamesNamesColumnsNamesString
		
		// Методы массива имён столбцов характеристик
		// в таблице характеристик разновидностей дисков.
		
		// Метод получения имени столбца характеристик
		// в таблице характеристик разновидностей дисков.
		// Параметры:
		// parColumnNameIndex - индекс имени столбца характеристик
		//   в таблице характеристик разновидностей дисков.
		// Результат: имя столбца характеристик
		// в таблице характеристик разновидностей дисков.
		public function GetDisksVarietiesCharacteristicsCharacteristicsColumnName
			( parColumnNameIndex: uint ): String
		{
			// Вызов метода класса.
			this._MainTracer.CallClassMethod( MySQLParameters.CLASS_NAME,
				"GetDisksVarietiesCharacteristicsCharacteristicsColumnName",
				parColumnNameIndex );				
			
			// Если индекс имени столбца находится вне допустимых границ.
			if ( parColumnNameIndex >=
					this._DisksVarietiesCharacteristicsCharacteristicsColumnsNames.
					length )
				// Имя столбца характеристик в таблице
				// характеристик разновидностей дисков не определено.
				return null;
			// Имя столбца характеристик в таблице
			// характеристик разновидностей дисков по заданному индексу.
			return this._DisksVarietiesCharacteristicsCharacteristicsColumnsNames
				[ parColumnNameIndex ];
		} // GetDisksVarietiesCharacteristicsCharacteristicsColumnName
		
		// Метод установки имени столбца характеристик
		// в таблице характеристик разновидностей дисков.
		// Параметры:
		// parColumnNameIndex - индекс имени столбца характеристик
		//   в таблице характеристик разновидностей дисков,
		// parColumnName      - имя названий характеристик
		//   в таблице характеристик разновидностей дисков.
		public function SetDisksVarietiesCharacteristicsCharacteristicsColumnName
		(
			parColumnNameIndex: uint,
			parColumnName:      String
		): void	
		{
			// Вызов метода класса.
			this._MainTracer.CallClassMethod( MySQLParameters.CLASS_NAME,
				"SetDisksVarietiesCharacteristicsCharacteristicsColumnName",
				parColumnNameIndex, parColumnName );			
			
			// Если индекс имени столбца находится вне допустимых границ.
			if ( parColumnNameIndex >=
					MySQLParameters.DISKS_CHARACTERISTICS_MAXIMUN_COUNT )
				// Имя столбца характеристик в таблице характеристик
				// разновидностей дисков не устанавливается.
				return;
			// Установка имени столбца характеристик в таблице характеристик
			// разновидностей дисков по заданному индексу.
			this._DisksVarietiesCharacteristicsCharacteristicsColumnsNames
				[ parColumnNameIndex ] = parColumnName;
		} // SetDisksVarietiesCharacteristicsCharacteristicsColumnName		
		
		// Метод получения строки массива имён столбцов характеристик
		// в таблице характеристик разновидностей дисков.
		// Результат: строка массива имён столбцов характеристик
		// в таблице характеристик разновидностей дисков.
		public function
			GetDisksVarietiesCharacteristicsCharacteristicsColumnsNamesString
			( ): String
		{
			// Вызов метода класса.
			this._MainTracer.CallClassMethod( MySQLParameters.CLASS_NAME,
		"GetDisksVarietiesCharacteristicsCharacteristicsColumnsNamesString" );
			
			// Строка элементов массива имён столбцов характеристик
			// в таблице характеристик разновидностей дисков,
			// отделённых друг от друга строкой-разделителем элементов массивов.
			return this._DisksVarietiesCharacteristicsCharacteristicsColumnsNames.
				join( this.ArraysSeparatorString );				
			/*			
			// Строка массива имён столбцов характеристик
			// в таблице характеристик разновидностей дисков.
			var arrayString: String = TextParameters.EMPTY_STRNG;
			// Индекс последнего имени столбца характеристик
			// в таблице характеристик разновидностей дисков.
			var lastColumnNameIndex = this.
				_DisksVarietiesCharacteristicsCharacteristicsColumnsNames.length - 1;
			
			// Последовательный просмотр всех имён столбцов характеристик
			// в таблице характеристик разновидностей дисков, кроме последнего.
			for ( var columnNameIndex: uint = 0; columnNameIndex <
					lastColumnNameIndex; columnNameIndex++ )
				// Добавление текущего имени столбца характеристик
				// в таблице характеристик разновидностей дисков
				// и строки-разделителя элементов массивов в строку массива.
				arrayString +=
					this._DisksVarietiesCharacteristicsCharacteristicsColumnsNames
					[ columnNameIndex ] + this.ArraysSeparatorString;					
			// Добавление последнего имени столбца характеристик
			// в таблице характеристик разновидностей дисков в строку массива.
			arrayString += this.
				_DisksVarietiesCharacteristicsCharacteristicsColumnsNames
				[ lastColumnNameIndex ];
				
			// Строка массива имён столбцов характеристик
			// в таблице характеристик разновидностей дисков.
			return arrayString;			
			*/
		} // GetDisksVarietiesCharacteristicsCharacteristicsColumnsNamesString		
		
		// Методы инициализации.
		
		// Метод инициализации URL-адреса компьютера-сервера.
		private function InitializeServerURL( ): void
		{				
			// Вызов метода класса.
			this._MainTracer.CallClassMethod( MySQLParameters.CLASS_NAME,
				"InitializeServerURL" );
		
			// URL-адрес компьютера-сервера.
			this._ServerURL =
				// Протокол.
				this.Protocol                   +
				// Двоеточие.
				TextParameters.COLON            +
				// Косая черта.				
				TextParameters.SLASH            +
				// Косая черта.				
				TextParameters.SLASH            +
				// Имя или сетевой адрес компьютера-сервера.				
				this.ServerNameOrNetworkAddress +
				// Косая черта.				
				TextParameters.SLASH;
		} // InitializeServerURL		
		
		// Метод инициализации URL-адреса компьютера-клиента.
		private function InitializeClientURL( ): void
		{
			// Вызов метода класса.
			this._MainTracer.CallClassMethod( MySQLParameters.CLASS_NAME,
				"InitializeClientURL" );			
			
			// URL-адрес компьютера-клиента.
			this._ClientURL =
				// Протокол http.
				MySQLParameters.HTTP_PROTOCOL +
				// Двоеточие.
				TextParameters.COLON          +
				// Косая черта.				
				TextParameters.SLASH          +
				// Косая черта.				
				TextParameters.SLASH          +
				// IP-адрес локального хоста.			
				this.Localhost                +
				// Косая черта.				
				TextParameters.SLASH;
		} // InitializeClientURL		
		
		// Метод инициализации атрибутов соединения с базой данных MySQL.
		private function InitializeConnectionAttributes( ): void
		{
			// Вызов метода класса.
			this._MainTracer.CallClassMethod( MySQLParameters.CLASS_NAME,
				"InitializeConnectionAttributes" );			
			
			// Aтрибуты соединения с базой данных MySQL.
			this._ConnectionAttributes =
				new MySQLConnectionAttributes
				(
					// Имя хоста.
					this.HostName,
					// Имя пользователя.
					this.UserName,
					// Пароль пользователя.
					this.UserPassword,
					// Имя базы данных.
					this.DatabaseName,
					// Название набора символов,
					// используемого для интерпретации байтов в базе данных.					
					this.DatabaseCharSetName
				); // new MySQLConnectionAttributes	
		} // InitializeConnectionAttributes		
		
		// Метод инициализации URL-адресов PHP-файлов запросов.
		private function InitializeRequestsPHPFilesURLs( ): void
		{
			// Каждый URL-адрес PHP-файла запроса к базе данных MySQL
			// складывается из URL-адреса компьютера-хранилища
			// и пути PHP-файла запроса к базе данных MySQL.
			
			// URL-адрес PHP-файла запроса выборщика URL-адресов
			// слайдов определённого типа диска на компьютере-сервере.
			this._ServerDiskSlidesFilesURLsSelectorRequestPHPFileURL =
				this._ServerURL + this.DiskSlidesFilesURLsSelectorRequestPHPFilePath;
			// URL-адрес PHP-файла запроса выборщика URL-адресов
			// слайдов определённого типа диска на компьютере-клиенте.
			this._ClientDiskSlidesFilesURLsSelectorRequestPHPFileURL =
				this._ClientURL + this.DiskSlidesFilesURLsSelectorRequestPHPFilePath;				
			
			// URL-адрес PHP-файла запроса к базе данных MySQL
			// выборщика текстовых меток кнопок меню.
			this._MenuButtonsLabelsSelectorRequestPHPFileURL   = this._ServerURL +
				this.MenuButtonsLabelsSelectorRequestPHPFilePath;
			// URL-адрес PHP-файла запроса к базе данных MySQL
			// выборщика артикулов изображений из таблиц MySQL.
			this._ImagesArticlesSelectorRequestPHPFileURL      = this._ServerURL +
				this.ImagesArticlesSelectorRequestPHPFilePath;
			// URL-адрес PHP-файла запроса к базе данных MySQL
			// выборщика артикулов изображений, отфильтрованных по категоиям,
			// из таблиц MySQL.
			this._ImagesArticlesFilteredByCategoriesSelectorRequestPHPFileURL =
				this._ServerURL +
				this.ImagesArticlesFilteredByCategoriesSelectorRequestPHPFilePath;
			// URL-адрес PHP-файла запроса к базе данных MySQL
			// выборщика описания диска из таблиц MySQL.
			this._DiskDescriptionSelectorRequestPHPFileURL     = this._ServerURL +
				this.DiskDescriptionSelectorRequestPHPFilePath;
			// URL-адрес PHP-файла запроса к базе данных MySQL
			// выборщика кода группы диска из таблиц MySQL.
			this._DiskGroupCodeSelectorRequestPHPFileURL       = this._ServerURL +
				this.DiskGroupCodeSelectorRequestPHPFilePath;
			// URL-адрес PHP-файла запроса к базе данных MySQL
			// выборщика примечаний первого типа диска из таблиц MySQL.
			this._DiskFirstTypeNotesSelectorRequestPHPFileURL  = this._ServerURL +
				this.DiskFirstTypeNotesSelectorRequestPHPFilePath;
			// URL-адрес PHP-файла запроса к базе данных MySQL
			// выборщика примечаний второго типа диска из таблиц MySQL.
			this._DiskSecondTypeNotesSelectorRequestPHPFileURL = this._ServerURL +
				this.DiskSecondTypeNotesSelectorRequestPHPFilePath;				
			// URL-адрес PHP-файла запроса к базе данных MySQL
			// выборщика характеристик разновидностей дисков из таблиц MySQL.
			this._DiskVarietiesCharacteristicsSelectorRequestPHPFileURL       =
				this._ServerURL +
				this.DiskVarietiesCharacteristicsSelectorRequestPHPFilePath;	
			// URL-адрес PHP-файла запроса к базе данных MySQL
			// выборщика цен разновидностей дисков из таблиц MySQL.
			this._DiskVarietiesCostsSelectorRequestPHPFileURL  = this._ServerURL +
				this.DiskVarietiesCostsSelectorRequestPHPFilePath;
			// URL-адрес PHP-файла запроса к базе данных MySQL
			// выборщика данных продаж разновидностей дисков из таблиц MySQL.
			this._DiskVarietiesSalesDataSelectorRequestPHPFileURL             =
				this._ServerURL +
				this.DiskVarietiesSalesDataSelectorRequestPHPFilePath;
			// URL-адрес PHP-файла запроса к базе данных MySQL
			// добавителя данных продажи разновидности диска
			// в корзину покупок в таблицах MySQL.
			this._DiskVarietySaleDataToShoppingCartAdderRequestPHPFileURL     =
				this._ServerURL +
				this.DiskVarietySaleDataToShoppingCartAdderRequestPHPFilePath;
				
			// URL-адрес PHP-файла запроса открывателя медиа-плеера.
			this._MediaPlayerOpenerRequestPHPFileURL =
				this._ClientURL               +
				this.MediaPlayerDirectoryPath +
				TextParameters.SLASH          +
				this.MediaPlayerOpenerRequestPHPFileName;				
		} // InitializeRequestsPHPFilesURLs
		
		// Метод инициализации имёна столбцов, фильтрующих изображения дисков.
		private function InitializeDisksImagesFilteringColumnsNames( ): void	
		{
			// Вызов метода класса.
			this._MainTracer.CallClassMethod( MySQLParameters.CLASS_NAME,
				"InitializeDisksImagesFilteringColumnsNames" );			
			
			// Имя столбца, фильтрующего по неизвестному признаку.
			this._DisksImagesFilteringColumnsNames
				[ ImagesNamesFilteringType.UNKNOWN     ] = null;
			// Имя столбца, фильтрующего по витрине -
			// имя столбца признаков витрины в таблице номенклатур.
			this._DisksImagesFilteringColumnsNames
				[ ImagesNamesFilteringType.SHOP_WINDOW ] =
					this.NomenclaturesShopWindowFlagsColumnName;
			// Имя столбца, фильтрующего по новинке -
			// имя столбца признаков новинок в таблице номенклатур.
			this._DisksImagesFilteringColumnsNames
				[ ImagesNamesFilteringType.NOVELTY     ] =
					this.NomenclaturesNoveltiesFlagsColumnName;
			// Имя столбца, фильтрующего по стране -
			// имя столбца признаков стран в таблице номенклатур.
			this._DisksImagesFilteringColumnsNames
				[ ImagesNamesFilteringType.COUNTRY     ] =
					this.NomenclaturesCountriesFlagsColumnName;
			// Имя столбца, фильтрующего по группе -
			// имя столбца признаков групп в таблице номенклатур.
			this._DisksImagesFilteringColumnsNames
				[ ImagesNamesFilteringType.GROUP       ] =
					this.NomenclaturesGroupsFlagsColumnName;
			// Имя столбца, фильтрующего по категории -
			// имя столбца кодов в таблице категорий товаров.
			this._DisksImagesFilteringColumnsNames
				[ ImagesNamesFilteringType.CATEGORY    ] =
					this.GoodsCategoriesCodesColumnName;
		} // InitializeDisksImagesFilteringColumnsNames
		
		// Метод инициализации имёна столбцов,
		// упорядочивающих изображения дисков.
		private function InitializeDisksImagesOrderingColumnsNames( ): void
		{
			// Вызов метода класса.
			this._MainTracer.CallClassMethod( MySQLParameters.CLASS_NAME,
				"InitializeDisksImagesOrderingColumnsNames" );			
			
			// Имя столбца, упорядочивающего по неизвестному признаку.
			this._DisksImagesOrderingColumnsNames
				[ ImagesNamesOrderingType.UNKNOWN ] = null;
			// Имя столбца, упорядочивающего по дате -
			// имя столбца дат релизов в таблице номенклатур.
			this._DisksImagesOrderingColumnsNames[ ImagesNamesOrderingType.DATE ] =
					this.NomenclaturesReleasesDatesColumnName;
			// Имя столбца, упорядочивающего по наименованию -
			// имя столбца наименований в таблице номенклатур.
			this._DisksImagesOrderingColumnsNames[ ImagesNamesOrderingType.NAME ] =
				this.NomenclaturesNamesColumnName;
		} // InitializeDisksImagesOrderingColumnsNames
		
		// Метод инициализации направлений упорядочения изображений дисков.
		private function InitializeDisksImagesOrderingAscentSigns( ): void	
		{
			// Вызов метода класса.
			this._MainTracer.CallClassMethod( MySQLParameters.CLASS_NAME,
				"InitializeDisksImagesOrderingAscentSigns" );						
			
			// Направление упорядочения по неизвестному признаку.
			this._DisksImagesOrderingAscentSigns
				[ ImagesNamesOrderingType.UNKNOWN ] = null;
			// Направление упорядочения по дате -
			// направление упорядочения артикулов по дате в таблице номенклатур.
			this._DisksImagesOrderingAscentSigns
				[ ImagesNamesOrderingType.DATE    ] =
					this.NomenclaturesArticlesDateOrderingAscentSign;
			// Направление упорядочения по наименованию -
			// направление упорядочения артикулов по наименованию
			// в таблице номенклатур.
			this._DisksImagesOrderingAscentSigns
				[ ImagesNamesOrderingType.NAME    ] =
					this.NomenclaturesArticlesNameOrderingAscentSign;
		} // InitializeDisksImagesOrderingAscentSigns
		
		// Метод инициализации параметров выбора изображений дисков.
		private function InitializeDisksImagesChoiceParameters( ): void
		{
			// Вызов метода класса.
			this._MainTracer.CallClassMethod( MySQLParameters.CLASS_NAME,
				"InitializeDisksImagesChoiceParameters" );			
			
			// Последовательный просмотр всех известных типов экрана выбора.
			for
			(
				var сhoiceScreenTypeIndex: uint =
					ChoiceScreenType.KNOWN_VALUE_MINIMUM_INDEX;
				сhoiceScreenTypeIndex < ChoiceScreenType.KNOWN_VALUE_MAXIMUM_INDEX;
				сhoiceScreenTypeIndex++
			)
			{
				// Текущий тип экрана выбора.
				var сhoiceScreenType: String = ChoiceScreenType.ValueOfIndex
					( сhoiceScreenTypeIndex );				
				
				// Последовательный просмотр всех известных типов строк изображений.
				for
				(
					var imagesLineTypeIndex: uint =
						ImagesLineType.KNOWN_VALUE_MINIMUM_INDEX;
					imagesLineTypeIndex < ImagesLineType.KNOWN_VALUE_MAXIMUM_INDEX;
					imagesLineTypeIndex++
				)
				{
					// Текущий тип строки изображений.
					var imagesLineType: String = ImagesLineType.ValueOfIndex
						( imagesLineTypeIndex );						
					// Текущий тип упорядочения параметров выборщика имён изображений
					// для текущего экрана выбора и текущей строки изображений.
					var orderingType:   String =
						ImagesNamesOrderingType.GetValueFromString
						(
							ImagesNamesSelectorParameters
							(
								this._DisksImagesChoiceParameters
									[ сhoiceScreenType ][ imagesLineType ]
							).OrderingType
						); // GetValueFromString
						
					// Установка текущего признака упорядочения по возрастанию
					// параметров выборщика имён изображений
					// для текущего экрана выбора и текущей строки изображений,
					// равного направлению упорядочения изображений дисков,
					// соответствующему текущему типу упорядочения.
					ImagesNamesSelectorParameters
					(
						this._DisksImagesChoiceParameters
							[ сhoiceScreenType ][ imagesLineType ]
					).OrderingIsAscendant =
						this._DisksImagesOrderingAscentSigns[ orderingType ];
				} // for
			} // for			
		} // InitializeDisksImagesChoiceParameters
		
		// Метод инициализации.
		private function Initialize( ): void
		{
			// Вызов метода класса.
			this._MainTracer.CallClassMethod( MySQLParameters.CLASS_NAME,
				"Initialize" );
			
			// Инициализация URL-адреса компьютера-сервера.
			this.InitializeServerURL( );	
			// Инициализация URL-адреса компьютера-клиента.
			this.InitializeClientURL( );
			// Инициализация атрибутов соединения с базой данных MySQL.
			this.InitializeConnectionAttributes( );
			// Инициализация URL-адресов PHP-файлов запросов.
			this.InitializeRequestsPHPFilesURLs( );
			// Инициализация имёна столбцов, фильтрующих изображения дисков.
			this.InitializeDisksImagesFilteringColumnsNames( );			
			// Инициализация имёна столбцов, упорядочивающих изображения дисков.
			this.InitializeDisksImagesOrderingColumnsNames( );	
			// Инициализация направлений упорядочения изображений дисков.
			this.InitializeDisksImagesOrderingAscentSigns( );	
			// Инициализация параметров выбора изображений дисков.
			this.InitializeDisksImagesChoiceParameters( );			
			
			// Передача события окончания инициализации парараметров MySQL,
			// целью - объбектом-получателем - которого
			// является данный объект парараметров MySQL.
			this.dispatchEvent( new Event( MySQLParameters.INITIALIZED ) );			
		} // Initialize			
		//-----------------------------------------------------------------------		
		// Методы-прослушиватели событий.
		
		// Метод-прослушиватель события
		// успешной загрузки данных с URL-адреса файла настроек.
		// Параметры:
		// parEvent - событие.
		protected function SettingsFileURLLoadingCompleteListener
			( parEvent: Event ): void
		{
			// Вызов метода-обработчика события класса.
			this._MainTracer.CallClassEventListener( MySQLParameters.CLASS_NAME,
				"SettingsFileURLLoadingCompleteListener", parEvent );			
			
			// XML-данные настроек, полученные из данных загрузчика
			// с URL-адреса файла настроек - объбекта-получателя события.
			var settingsXML = XML( parEvent.target.data );
			
			// URL-адрес компьютера-сервера.
			
			// Протокол.
			this.Protocol                   = settingsXML.Protocol[ 0 ];
			// Имя или сетевой адрес компьютера-сервера.
			this.ServerNameOrNetworkAddress =
				settingsXML.ServerNameOrNetworkAddress[ 0 ];
			// Путь к директорию, хранящему документы на компьютере-сервере.
			this.ServerDocumentRoot         = settingsXML.ServerDocumentRoot[ 0 ];				
			// Инициализация URL-адреса компьютера-сервера.
			this.InitializeServerURL( );
			
			// URL-адрес компьютера-клиента.			
			
			// IP-адрес локального хоста.
			this.Localhost          = settingsXML.Localhost[ 0 ];
			// Путь к директорию, хранящему документы на компьютере-клиенте.
			this.ClientDocumentRoot = settingsXML.ClientDocumentRoot[ 0 ];
			// Инициализация URL-адреса компьютера-клиента.
			this.InitializeClientURL( );	
			
			// Aтрибуты соединения с базой данных MySQL.
		
			// Имя хоста.
			this.HostName            = settingsXML.HostName[ 0 ];
			// Имя пользователя.
			this.UserName            = settingsXML.UserName[ 0 ];
			// Пароль пользователя.
			this.UserPassword        = settingsXML.UserPassword[ 0 ];
			// Имя базы данных.
			this.DatabaseName        = settingsXML.DatabaseName[ 0 ];
			// Название набора символов,
			// используемого для интерпретации байтов в базе данных.
			this.DatabaseCharSetName = settingsXML.DatabaseCharSetName[ 0 ];
			
			// Мультимедиа-файлы дисков.
			
			// Комьютер-хранилище файлов кадров фильмов дисков.
			this.DisksFramesFilesWarehouse =
				settingsXML.DisksFramesFilesWarehouse[ 0 ];
			// Комьютер-хранилище видео-файлов дисков.
			this.DisksVideosFilesWarehouse =
				settingsXML.DisksVideosFilesWarehouse[ 0 ];
			// Комьютер-хранилище аудио-файлов дисков.
			this.DisksAudiosFilesWarehouse =
				settingsXML.DisksAudiosFilesWarehouse[ 0 ];
				
			// Путь PHP-файла запроса выборщика URL-адресов
			// слайдов определённого типа диска.
			this.DiskSlidesFilesURLsSelectorRequestPHPFilePath =	
				settingsXML.DiskSlidesFilesURLsSelectorRequestPHPFilePath[ 0 ];					
				
			// Путь к директорию, харанящему файлы изображений дисков.
			this.DisksImagesFilesDirectoryPath =
				settingsXML.DisksImagesFilesDirectoryPath[ 0 ];
			// Путь к директорию, харанящему файлы кадров фильмов дисков.
			this.DisksFramesFilesDirectoryPath =
				settingsXML.DisksFramesFilesDirectoryPath[ 0 ];
			// Путь к директорию, харанящему видео-файлы дисков.
			this.DisksVideosFilesDirectoryPath =
				settingsXML.DisksVideosFilesDirectoryPath[ 0 ];
			// Путь к директорию, харанящему аудио-файлы дисков.
			this.DisksAudiosFilesDirectoryPath =
				settingsXML.DisksAudiosFilesDirectoryPath[ 0 ];
			
			// Аффикс имени файла изображения диска.
			this.DiskImageFileNameAffix = settingsXML.DiskImageFileNameAffix[ 0 ];
			// Аффикс имени файла кадра фильма диска.
			this.DiskFrameFileNameAffix = settingsXML.DiskFrameFileNameAffix[ 0 ];
			// Аффикс имени видео-файла диска.
			this.DiskVideoFileNameAffix = settingsXML.DiskVideoFileNameAffix[ 0 ];
			// Аффикс имени аудио-файла диска.
			this.DiskAudioFileNameAffix = settingsXML.DiskAudioFileNameAffix[ 0 ];
			
			// Расширение файла изображения диска.
			this.DiskImageFileExtension = settingsXML.DiskImageFileExtension[ 0 ];
			// Расширение файла кадра фильма диска.
			this.DiskFrameFileExtension = settingsXML.DiskFrameFileExtension[ 0 ];
			// Расширение видео-файла диска.
			this.DiskVideoFileExtension = settingsXML.DiskVideoFileExtension[ 0 ];
			// Расширение аудио-файла диска.
			this.DiskAudioFileExtension = settingsXML.DiskAudioFileExtension[ 0 ];
			
			// Пути PHP-файлов запросов к базе данных MySQL.
			
			// Путь PHP-файла запроса к базе данных MySQL
			// выборщика текстовых меток кнопок меню.
			this.MenuButtonsLabelsSelectorRequestPHPFilePath                  =
				settingsXML.MenuButtonsLabelsSelectorRequestPHPFilePath[ 0 ];
			// выборщика артикулов изображений из таблиц MySQL.
			this.ImagesArticlesSelectorRequestPHPFilePath                     =
				settingsXML.ImagesArticlesSelectorRequestPHPFilePath[ 0 ];
			// Путь PHP-файла запроса к базе данных MySQL
			// выборщика артикулов изображений, отфильтрованных по категоиям,
			// из таблиц MySQL.
			this.ImagesArticlesFilteredByCategoriesSelectorRequestPHPFilePath =
				settingsXML.
				ImagesArticlesFilteredByCategoriesSelectorRequestPHPFilePath[ 0 ];
			// Путь PHP-файла запроса к базе данных MySQL
			// выборщика описания диска из таблиц MySQL.
			this.DiskDescriptionSelectorRequestPHPFilePath                    =
				settingsXML.DiskDescriptionSelectorRequestPHPFilePath[ 0 ];
			// Путь PHP-файла запроса к базе данных MySQL
			// выборщика кода группы диска из таблиц MySQL.
			this.DiskGroupCodeSelectorRequestPHPFilePath                      =
				settingsXML.DiskGroupCodeSelectorRequestPHPFilePath[ 0 ];
			// Путь PHP-файла запроса к базе данных MySQL
			// выборщика примечаний первого типа диска из таблиц MySQL.
			this.DiskFirstTypeNotesSelectorRequestPHPFilePath                 =
				settingsXML.DiskFirstTypeNotesSelectorRequestPHPFilePath[ 0 ];
			// Путь PHP-файла запроса к базе данных MySQL
			// выборщика примечаний второго типа диска из таблиц MySQL.
			this.DiskSecondTypeNotesSelectorRequestPHPFilePath                =
				settingsXML.DiskSecondTypeNotesSelectorRequestPHPFilePath[ 0 ];
			// Путь PHP-файла запроса к базе данных MySQL
			// выборщика характеристик разновидностей дисков из таблиц MySQL.
			this.DiskVarietiesCharacteristicsSelectorRequestPHPFilePath       =
				settingsXML.
				DiskVarietiesCharacteristicsSelectorRequestPHPFilePath[ 0 ];
			// Путь PHP-файла запроса к базе данных MySQL
			// выборщика цен разновидностей дисков из таблиц MySQL.
			this.DiskVarietiesCostsSelectorRequestPHPFilePath                 =
				settingsXML.DiskVarietiesCostsSelectorRequestPHPFilePath[ 0 ];
			// Путь PHP-файла запроса к базе данных MySQL
			// выборщика данных продаж разновидностей дисков из таблиц MySQL.
			this.DiskVarietiesSalesDataSelectorRequestPHPFilePath             =
				settingsXML.DiskVarietiesSalesDataSelectorRequestPHPFilePath[ 0 ];
			// Путь PHP-файла запроса к базе данных MySQL
			// добавителя данных продажи разновидности диска
			// в корзину покупок в таблицах MySQL.
			this.DiskVarietySaleDataToShoppingCartAdderRequestPHPFilePath     =
				settingsXML.
				DiskVarietySaleDataToShoppingCartAdderRequestPHPFilePath[ 0 ];
				
			// Таблица кнопок меню.
			
			// Имя таблицы кнопок меню.
			this.MenuButtonsTableName = settingsXML.MenuButtonsTableName[ 0 ];
			// Имя столбца текстовых меток в таблице кнопок меню.
			this.MenuButtonsLablesColumnName            =
				settingsXML.MenuButtonsLablesColumnName[ 0 ];
			// Имя столбца в таблице кнопок меню, упорядочивающего текстовые метки.
			this.MenuButtonsLablesOrderingColumnName    =
				settingsXML.MenuButtonsLablesOrderingColumnName[ 0 ];
			// Направление упорядочения текстовых меток в таблице кнопок меню.
			this.MenuButtonsLablesOrderingAscendantSign = Boolean( int
				( settingsXML.MenuButtonsLablesOrderingAscendantSign[ 0 ] ) );
			
			// Таблица розничных товаров.
			
			// Имя таблицы розничных товаров.
			this.RetailGoodsTableName = settingsXML.RetailGoodsTableName[ 0 ];
			// Имя столбца идентивикаторов номенклатур в таблице розничных товаров.
			this.RetailGoodsNomenclaturesIDsColumnName  =
				settingsXML.RetailGoodsNomenclaturesIDsColumnName[ 0 ];
			// Имя столбца идентивикаторов разновидностей дисков
			// в таблице розничных товаров.
			this.RetailGoodsDisksVarietiesIDsColumnName =
				settingsXML.RetailGoodsDisksVarietiesIDsColumnName[ 0 ];
			// Имя столбца количеств в таблице розничных товаров.
			this.RetailGoodsCountsColumnName            =
				settingsXML.RetailGoodsCountsColumnName[ 0 ];
			// Имя столбца цен в таблице розничных товаров.
			this.RetailGoodsCostsColumnName             =
				settingsXML.RetailGoodsCostsColumnName[ 0 ];
			// Имя столбца номеров ячеек в таблице розничных товаров.
			this.RetailGoodsCellsNumbersColumnName      =
				settingsXML.RetailGoodsCellsNumbersColumnName[ 0 ];			
			
			// Таблица номенклатур.
		
			// Имя таблицы номенклатур.
			this.NomenclaturesTableName = settingsXML.NomenclaturesTableName[ 0 ];	
			// Имя столбца идентивикаторов в таблице номенклатур.
			this.NomenclaturesIDsColumnName            =
				settingsXML.NomenclaturesIDsColumnName[ 0 ];			
			// Имя столбца артикулов в таблице номенклатур.
			this.NomenclaturesArticlesColumnName       =
				settingsXML.NomenclaturesArticlesColumnName[ 0 ];
			// Имя столбца описаний в таблице номенклатур.
			this.NomenclaturesDescriptionsColumnName   =
				settingsXML.NomenclaturesDescriptionsColumnName[ 0 ];
			// Имя столбца названий стран в таблице номенклатур.
			this.NomenclaturesCountriesNamesColumnName =
				settingsXML.NomenclaturesCountriesNamesColumnName[ 0 ];
		
			// Имя столбца дат релизов в таблице номенклатур.
			this.NomenclaturesReleasesDatesColumnName =
				settingsXML.NomenclaturesReleasesDatesColumnName[ 0 ];
			// Имя столбца наименований в таблице номенклатур.
			this.NomenclaturesNamesColumnName         =
				settingsXML.NomenclaturesNamesColumnName[ 0 ];
				
			// Направление упорядочения артикулов по дате в таблице номенклатур.
			this.NomenclaturesArticlesDateOrderingAscentSign = Boolean( int
				( settingsXML.NomenclaturesArticlesDateOrderingAscentSign[ 0 ] ) );
			// Направление упорядочения артикулов по наименованию
			// в таблице номенклатур.
			this.NomenclaturesArticlesNameOrderingAscentSign = Boolean( int
				( settingsXML.NomenclaturesArticlesNameOrderingAscentSign[ 0 ] ) );
				
			// Имя столбца признаков витрины в таблице номенклатур.
			this.NomenclaturesShopWindowFlagsColumnName =
				settingsXML.NomenclaturesShopWindowFlagsColumnName[ 0 ];
			// Имя столбца признаков новинок в таблице номенклатур.
			this.NomenclaturesNoveltiesFlagsColumnName  =
				settingsXML.NomenclaturesNoveltiesFlagsColumnName[ 0 ];
			// Имя столбца признаков стран в таблице номенклатур.
			this.NomenclaturesCountriesFlagsColumnName  =	
				settingsXML.NomenclaturesCountriesFlagsColumnName[ 0 ];
			// Имя столбца признаков групп в таблице номенклатур.
			this.NomenclaturesGroupsFlagsColumnName     =
				settingsXML.NomenclaturesGroupsFlagsColumnName[ 0 ];
				
			// Таблица категорий товаров и номенклатур.
		
			// Имя таблицы категорий товаров и номенклатур.
			this.GoodsCategoriesAndNomenclaturesTableName                    =
				settingsXML.GoodsCategoriesAndNomenclaturesTableName[ 0 ];		
			// Имя столбца идентивикаторов номенклатур
			// в таблице категорий товаров и номенклатур.
			this.GoodsCategoriesAndNomenclaturesNomenclaturesIDsColumnName   =
				settingsXML.
				GoodsCategoriesAndNomenclaturesNomenclaturesIDsColumnName[ 0 ];		
			// Имя столбца идентивикаторов категорий товаров
			// в таблице категорий товаров и номенклатур.
			this.GoodsCategoriesAndNomenclaturesGoodsCategoriesIDsColumnName =
				settingsXML.
				GoodsCategoriesAndNomenclaturesGoodsCategoriesIDsColumnName[ 0 ];	
				
			// Таблица категорий товаров.
		
			// Имя таблицы категорий товаров.
			this.GoodsCategoriesTableName       =
				settingsXML.GoodsCategoriesTableName[ 0 ];		
			// Имя столбца идентивикаторов в таблице категорий товаров.
			this.GoodsCategoriesIDsColumnName   =
				settingsXML.GoodsCategoriesIDsColumnName[ 0 ];
			// Имя столбца кодов в таблице категорий товаров.
			this.GoodsCategoriesCodesColumnName =
				settingsXML.GoodsCategoriesCodesColumnName[ 0 ];
			// Имя столбца наименований в таблице категорий товаров.
			this.GoodsCategoriesNamesColumnName =
				settingsXML.GoodsCategoriesNamesColumnName[ 0 ];			
				
			// Таблица ссылок свойств.
			
			// Имя таблицы ссылок свойств.
			this.PropertiesReferencesTableName                     =
				settingsXML.PropertiesReferencesTableName[ 0 ];	
			// Имя столбца идентивикаторов номенклатур в таблице ссылок свойств.
			this.PropertiesReferencesNomenclaturesIDsColumnName    =
				settingsXML.PropertiesReferencesNomenclaturesIDsColumnName[ 0 ];	
			// Имя столбца идентивикаторов значений свойств
			// в таблице ссылок свойств.
			this.PropertiesReferencesPropertiesValuesIDsColumnName =
				settingsXML.PropertiesReferencesPropertiesValuesIDsColumnName[ 0 ];
				
			// Таблица значений свойств.
				
			// Имя таблицы значений свойств.
			this.PropertiesValuesTableName       =
				settingsXML.PropertiesValuesTableName	[ 0 ];		
			// Имя столбца идентивикаторов в таблице значений свойств.
			this.PropertiesValuesIDsColumnName   =
				settingsXML.PropertiesValuesIDsColumnName[ 0 ];
			// Имя столбца наименований в таблице значений свойств.
			this.PropertiesValuesNamesColumnName =
				settingsXML.PropertiesValuesNamesColumnName[ 0 ];
				
			// Таблица групп товаров.
			
			// Имя таблицы групп товаров.
			this.GoodsGroupsTableName = settingsXML.GoodsGroupsTableName[ 0 ];
			// Имя столбца кодов в таблице групп товаров.
			this.GoodsGroupsCodesColumnName =
				settingsXML.GoodsGroupsCodesColumnName[ 0 ];
			// Имя столбца наименований в таблице групп товаров.
			this.GoodsGroupsNamesColumnName =
				settingsXML.GoodsGroupsNamesColumnName[ 0 ];
				
			// Таблица разновидностей дисков.
			
			// Направление упорядочения разновидностей дисков по идентификатору.
			this.DisksVarietiesIDOrderingAscentSign = Boolean( int
				( settingsXML.DisksVarietiesIDOrderingAscentSign[ 0 ] ) );
				
			// Таблица ссылок разновидностей дисков.
			
			// Имя таблицы ссылок разновидностей дисков.
			this.DisksVarietiesReferencesTableName =
				settingsXML.DisksVarietiesReferencesTableName[ 0 ];
			// Имя столбца идентивикаторов номенклатур
			// в таблице ссылок разновидностей дисков.
			this.DisksVarietiesReferencesNomenclaturesIDsColumnName =
				settingsXML.DisksVarietiesReferencesNomenclaturesIDsColumnName[ 0 ];
			// Имя столбца идентивикаторов характеристик разновидностей дисков
			// в таблице ссылок разновидностей дисков.
			this.
				DisksVarietiesReferencesDisksVarietiesCharacteristicsIDsColumnName =
				settingsXML.
				DisksVarietiesReferencesDisksVarietiesCharacteristicsIDsColumnName
				[ 0 ];
			// Имя столбца идентивикаторов разновидностей дисков
			// в таблице ссылок разновидностей дисков.
			this.DisksVarietiesReferencesDisksVarietiesIDsColumnName =
				settingsXML.DisksVarietiesReferencesDisksVarietiesIDsColumnName[ 0 ];
			
			// Таблица названий характеристик дисков.
			
			// Имя таблицы названий характеристик дисков.
			this.DisksCharacteristicsNamesTableName             =
				settingsXML.DisksCharacteristicsNamesTableName[ 0 ];
			// Имя столбца наименований групп
			// в таблице названий характеристик дисков.
			this.DisksCharacteristicsNamesGroupsNamesColumnName =
				settingsXML.DisksCharacteristicsNamesGroupsNamesColumnName[ 0 ];
				
			// Таблица характеристик разновидностей дисков.
			
			// Имя таблицы характеристик разновидностей дисков.
			this.DisksVarietiesCharacteristicsTableName     =
				settingsXML.DisksVarietiesCharacteristicsTableName[ 0 ];
			// Имя столбца идентификаторов
			// в таблице характеристик разновидностей дисков.
			this.DisksVarietiesCharacteristicsIDsColumnName =
				settingsXML.DisksVarietiesCharacteristicsIDsColumnName[ 0 ];
				
			// Таблица корзины покупок.
			
			// Имя таблицы корзины покупок.
			this.ShoppingCartTableName = settingsXML.ShoppingCartTableName[ 0 ];
			// Имя столбца идентивикаторов в таблице корзины покупок.
			this.ShoppingCartIDsColumnName               =
				settingsXML.ShoppingCartIDsColumnName[ 0 ];
			// Имя столбца идентивикаторов номенклатур в таблице корзины покупок.
			this.ShoppingCartNomenclaturesIDsColumnName  =
				settingsXML.ShoppingCartNomenclaturesIDsColumnName[ 0 ];
			// Имя столбца идентивикаторов разновидностей дисков
			// в таблице корзины покупок.
			this.ShoppingCartDisksVarietiesIDsColumnName =
				settingsXML.ShoppingCartDisksVarietiesIDsColumnName[ 0 ];
			// Имя столбца цен в таблице корзины покупок.
			this.ShoppingCartCostsColumnName             =
				settingsXML.ShoppingCartCostsColumnName[ 0 ];
			// Имя столбца номеров ячеек в таблице корзины покупок.
			this.ShoppingCartCellsNumbersColumnName      =
				settingsXML.ShoppingCartCellsNumbersColumnName[ 0 ];					
				
			// Массивы имён столбцов таблиц.
			
			// Строка-разделитель элементов массивов.
			this.ArraysSeparatorString = settingsXML.ArraysSeparatorString[ 0 ];
			// Индекс элемента массива.
			var arrayElementIndex: uint;
			
			// Массив имён столбцов названий
			// в таблице названий характеристик дисков.
		
			// Установка количества элементов массива имён столбцов названий
			// в таблице названий характеристик дисков.
			this._DisksCharacteristicsNamesNamesColumnsNames.length =
				settingsXML.DisksCharacteristicsNamesNamesColumnsNames[ 0 ].
				children( ).length( );
				
			// Последовательный просмотр всех имён столбцов названий
			// в таблице названий характеристик дисков.
			for ( arrayElementIndex = 0; arrayElementIndex <
					this._DisksCharacteristicsNamesNamesColumnsNames.length;
					arrayElementIndex++ )
				// Имя столбца текущего названия
				// в таблице названий характеристик дисков.
				this._DisksCharacteristicsNamesNamesColumnsNames
					[ arrayElementIndex ] =
					settingsXML.DisksCharacteristicsNamesNamesColumnsNames[ 0 ].
					DisksCharacteristicsNamesNameColumnName[ arrayElementIndex ];
					
			// Массив имён столбцов характеристик
			// в таблице характеристик разновидностей дисков.
			
			// Установка количества элементов массива имён столбцов характеристик
			// в таблице характеристик разновидностей дисков.
			this._DisksVarietiesCharacteristicsCharacteristicsColumnsNames.length =
				settingsXML.
				DisksVarietiesCharacteristicsCharacteristicsColumnsNames[ 0 ].
				children( ).length( );
				
			// Последовательный просмотр всех имён столбцов характеристик
			// в таблице характеристик разновидностей дисков.
			for ( arrayElementIndex = 0; arrayElementIndex <
					this._DisksVarietiesCharacteristicsCharacteristicsColumnsNames.
					length; arrayElementIndex++ )
				// Имя столбца текущей характеристики
				// в таблице характеристик разновидностей дисков.
				this._DisksVarietiesCharacteristicsCharacteristicsColumnsNames
					[ arrayElementIndex ] = settingsXML.
					DisksVarietiesCharacteristicsCharacteristicsColumnsNames[ 0 ].
					DisksVarietiesCharacteristicsCharacteristicColumnName
					[ arrayElementIndex ];
					
			// Медиа-плеер.
			
			// Путь к директорию на localhost клиента,
			// хранящему файлы медиа-плеера.
			this.MediaPlayerDirectoryPath            =
				settingsXML.MediaPlayerDirectoryPath[ 0 ];
				
			// Имя файла PHP-файла запроса открывателя медиа-плеера
			// в директории на localhost, хранящем файлы медиа-плеера.
			this.MediaPlayerOpenerRequestPHPFileName =
				settingsXML.MediaPlayerOpenerRequestPHPFileName[ 0 ];
			// Имя файла медиа-плеера.
			this.MediaPlayerFileName = settingsXML.MediaPlayerFileName[ 0 ];
			// Имя файла настроек медиа-плеера.
			this.MediaPlayerSettingsFileName      =
				settingsXML.MediaPlayerSettingsFileName[ 0 ];
				
			// Инициализация с использованием данных, полученных из файла настроек.
			this.Initialize( );
		} // SettingsFileURLLoadingCompleteListener		
		
		// Метод-прослушиватель события возникновения ошибки
		// при загрузке данных с URL-адреса файла настроек.
		// Параметры:
		// parIOErrorEvent - событие возникновения ошибки при выполнении
		//   операция отправки или загрузки.
		protected function SettingsFileURLLoadingIOErrorListener
			( parIOErrorEvent: IOErrorEvent ): void
		{
			// Вызов метода-обработчика события класса.
			this._MainTracer.CallClassEventListener( MySQLParameters.CLASS_NAME,
				"SettingsFileURLLoadingIOErrorListener", parIOErrorEvent );
			// Послание сообщения об ошибке.
			this._MainTracer.SendErrorMessage
				( MySQLParameters.SETTINGS_FILE_URL_LOADING_IO_ERROR_MESSAGE +
				this._SettingsFilePath );			
			
			// Вывод сообщения об ошибке загрузки данных из настроек.
			trace( MySQLParameters.SETTINGS_FILE_URL_LOADING_IO_ERROR_MESSAGE +
				this._SettingsFilePath );
			// Загрузка демонстрационных настроек.
			this.LoadDemoSettings( );			
		} // SettingsFileURLLoadingIOErrorListener
		
		// Метод-прослушиватель события успешной загрузки данных
		// с URL-адреса файла демонстрационных настроек.
		// Параметры:
		// parEvent - событие.
		protected function DemoSettingsFileURLLoadingCompleteListener
			( parEvent: Event ): void
		{
			// Вызов метода-обработчика события класса.
			this._MainTracer.CallClassEventListener( MySQLParameters.CLASS_NAME,
				"DemoSettingsFileURLLoadingCompleteListener", parEvent );			
			
			// XML-данные демонстрационных настроек, полученные из данных
			// загрузчика с URL-адреса файла демонстрационных настроек -
			// объбекта-получателя события.
			var demoSettingsXML = XML( parEvent.target.data );
			
			// URL-адрес компьютера-сервера.
			
			// Имя или сетевой адрес компьютера-сервера.
			this.ServerNameOrNetworkAddress =
				demoSettingsXML.ServerNameOrNetworkAddress[ 0 ];
			// Путь к директорию, хранящему документы на компьютере-сервере.
			this.ServerDocumentRoot         =
				demoSettingsXML.ServerDocumentRoot[ 0 ];				
			// Инициализация URL-адреса компьютера-сервера.
			this.InitializeServerURL( );
			
			// URL-адрес компьютера-клиента.			
			
			// Путь к директорию, хранящему документы на компьютере-клиенте.
			this.ClientDocumentRoot = demoSettingsXML.ClientDocumentRoot[ 0 ];
			// Инициализация URL-адреса компьютера-клиента.
			this.InitializeClientURL( );	
			
			// Aтрибуты соединения с базой данных MySQL.
		
			// Имя хоста.
			this.HostName     = demoSettingsXML.HostName[ 0 ];
			// Имя базы данных.
			this.DatabaseName = demoSettingsXML.DatabaseName[ 0 ];
			
			// Мультимедиа-файлы дисков.
			
			// Комьютер-хранилище файлов кадров фильмов дисков.
			this.DisksFramesFilesWarehouse =
				demoSettingsXML.DisksFramesFilesWarehouse[ 0 ];
			// Комьютер-хранилище видео-файлов дисков.
			this.DisksVideosFilesWarehouse =
				demoSettingsXML.DisksVideosFilesWarehouse[ 0 ];
			// Комьютер-хранилище аудио-файлов дисков.
			this.DisksAudiosFilesWarehouse =
				demoSettingsXML.DisksAudiosFilesWarehouse[ 0 ];
				
			// Инициализация с использованием данных, полученных из файла настроек.
			this.Initialize( );
		} // DemoSettingsFileURLLoadingCompleteListener		
		
		// Метод-прослушиватель события возникновения ошибки при загрузке данных
		// с URL-адреса файла демонстрационных настроек.
		// Параметры:
		// parIOErrorEvent - событие возникновения ошибки при выполнении
		//   операция отправки или загрузки.
		protected function DemoSettingsFileURLLoadingIOErrorListener
			( parIOErrorEvent: IOErrorEvent ): void
		{
			// Вызов метода-обработчика события класса.
			this._MainTracer.CallClassEventListener( MySQLParameters.CLASS_NAME,
				"DemoSettingsFileURLLoadingIOErrorListener", parIOErrorEvent );
			// Послание сообщения об ошибке.
			this._MainTracer.SendErrorMessage
				( MySQLParameters.DEMO_SETTINGS_FILE_URL_LOADING_IO_ERROR_MESSAGE +
				this._DemoSettingsFilePath );			
			
			// Вывод сообщения об ошибке загрузки данных
			// из демонстрационных настроек.
			trace( MySQLParameters.
				DEMO_SETTINGS_FILE_URL_LOADING_IO_ERROR_MESSAGE +
				this._DemoSettingsFilePath );
			// Инициализация с использованием данных по умолчанию.
			this.Initialize( );			
		} // DemoSettingsFileURLLoadingIOErrorListener		
		//-----------------------------------------------------------------------		
		// Методы-конструкторы.
		
		// Метод-конструктор экземпляра парараметров MySQL.
		// Параметры:
		// parSettingsFilePath     - путь к файлу настроек,
		// parDemoSettingsFilePath - путь к файлу демонстрационных настроек,
		// parMainTracer           - основной трассировщик.
		public function MySQLParameters
		(
			parSettingsFilePath,
			parDemoSettingsFilePath: String,
			parMainTracer:           Tracer
		): void
		{
			// Ocновной трассировщик.
			this._MainTracer = parMainTracer;			
			// Создание нового экземпляра класса.
			this._MainTracer.CreateClassNewInstance( MySQLParameters.CLASS_NAME,
				parSettingsFilePath, parDemoSettingsFilePath, parMainTracer );			
			
			// Путь к файлу настроек.
			this._SettingsFilePath     = parSettingsFilePath;	
			// Путь к файлу демонстрационных настроек.
			this._DemoSettingsFilePath = parDemoSettingsFilePath;
			
			// Загрузка настроек.
			this.LoadSettings( );					
		} // MySQLParameters
		//-----------------------------------------------------------------------
		// Get- и set-методы.
		
		// Get-метод получения пути к файлу настроек.
		// Результат: путь к файлу настроек.
		public function get SettingsFilePath( ): String
		{
			// Путь к файлу настроек.
			return this._SettingsFilePath;
		} // SettingsFilePath
		
		// Get-метод получения URL-адреса компьютера-сервера.
		// Результат: URL-адрес компьютера-сервера.
		public function get ServerURL( ): String
		{
			// URL-адрес компьютера-сервера.
			return this._ServerURL;
		} // ServerURL		
		
		// Get-метод получения атрибутов соединения с базой данных MySQL.
		// Результат: атрибуты соединения с базой данных MySQL.
		public function get ConnectionAttributes( ): MySQLConnectionAttributes
		{
			// Атрибуты соединения с базой данных MySQL.
			return this._ConnectionAttributes;
		} // ConnectionAttributes
		
		// Get-метод получения URL-адреса PHP-файла запроса выборщика URL-адресов
		// слайдов определённого типа диска на компьютере-сервере.
		// Результат: URL-адрес PHP-файла запроса выборщика URL-адресов
		// слайдов определённого типа диска на компьютере-сервере.
		public function get
			ServerDiskSlidesFilesURLsSelectorRequestPHPFileURL( ): String
		{
			// URL-адрес PHP-файла запроса выборщика URL-адресов
			// слайдов определённого типа диска на компьютере-сервере.
			return this._ServerDiskSlidesFilesURLsSelectorRequestPHPFileURL;
		} // ServerDiskSlidesFilesURLsSelectorRequestPHPFileURL
		
		// Get-метод получения URL-адреса PHP-файла запроса выборщика URL-адресов
		// слайдов определённого типа диска на компьютере-клиенте.
		// Результат: URL-адрес PHP-файла запроса выборщика URL-адресов
		// слайдов определённого типа диска на компьютере-клиенте.
		public function get
			ClientDiskSlidesFilesURLsSelectorRequestPHPFileURL( ): String
		{
			// URL-адрес PHP-файла запроса выборщика URL-адресов
			// слайдов определённого типа диска на компьютере-клиенте.
			return this._ClientDiskSlidesFilesURLsSelectorRequestPHPFileURL;
		} // ClientDiskSlidesFilesURLsSelectorRequestPHPFileURL		
		
		// Get-метод получения URL-адреса PHP-файла запроса к базе данных MySQL
		// выборщика текстовых меток кнопок меню.
		// Результат: URL-адрес PHP-файла запроса к базе данных MySQL
		// выборщика текстовых меток кнопок меню.
		public function get MenuButtonsLabelsSelectorRequestPHPFileURL( ): String
		{
			// URL-адрес PHP-файла запроса к базе данных MySQL
			// выборщика текстовых меток кнопок меню.
			return this._MenuButtonsLabelsSelectorRequestPHPFileURL;
		} // MenuButtonsLabelsSelectorRequestPHPFileURL		
		
		// Get-метод получения URL-адреса PHP-файла запроса к базе данных MySQL
		// выборщика артикулов изображений из таблиц MySQL.
		// Результат: URL-адрес PHP-файла запроса к базе данных MySQL
		// выборщика артикулов изображений из таблиц MySQL.
		public function get ImagesArticlesSelectorRequestPHPFileURL( ): String
		{
			// URL-адрес PHP-файла запроса к базе данных MySQL
			// выборщика артикулов изображений из таблиц MySQL.
			return this._ImagesArticlesSelectorRequestPHPFileURL;
		} // ImagesArticlesSelectorRequestPHPFileURL	
		
		// Get-метод получения URL-адреса PHP-файла запроса к базе данных MySQL
		// выборщика артикулов изображений, отфильтрованных по категоиям,
		// из таблиц MySQL.
		// Результат: URL-адрес PHP-файла запроса к базе данных MySQL
		// выборщика артикулов изображений, отфильтрованных по категоиям,
		// из таблиц MySQL.
		public function get
			ImagesArticlesFilteredByCategoriesSelectorRequestPHPFileURL( ): String
		{
			// URL-адрес PHP-файла запроса к базе данных MySQL
			// выборщика артикулов изображений, отфильтрованных по категоиям,
			// из таблиц MySQL.
			return this.
				_ImagesArticlesFilteredByCategoriesSelectorRequestPHPFileURL;
		} // ImagesArticlesFilteredByCategoriesSelectorRequestPHPFileURL
		
		// Get-метод получения URL-адреса PHP-файла запроса к базе данных MySQL
		// выборщика описания диска из таблиц MySQL.
		// Результат: URL-адрес PHP-файла запроса к базе данных MySQL
		// выборщика описания диска из таблиц MySQL.
		public function get DiskDescriptionSelectorRequestPHPFileURL( ): String
		{
			// URL-адрес PHP-файла запроса к базе данных MySQL
			// выборщика описания диска из таблиц MySQL.
			return this._DiskDescriptionSelectorRequestPHPFileURL;
		} // DiskDescriptionSelectorRequestPHPFileURL
		
		// Get-метод получения URL-адреса PHP-файла запроса к базе данных MySQL
		// выборщика кода группы диска из таблиц MySQL.
		// Результат: URL-адрес PHP-файла запроса к базе данных MySQL
		// выборщика кода группы диска из таблиц MySQL.
		public function get DiskGroupCodeSelectorRequestPHPFileURL( ): String
		{
			// URL-адрес PHP-файла запроса к базе данных MySQL
			// выборщика кода группы диска из таблиц MySQL.
			return this._DiskGroupCodeSelectorRequestPHPFileURL;
		} // DiskGroupCodeSelectorRequestPHPFileURL		
		
		// Get-метод получения URL-адреса PHP-файла запроса к базе данных MySQL
		// выборщика примечаний первого типа диска из таблиц MySQL.
		// Результат: URL-адрес PHP-файла запроса к базе данных MySQL
		// выборщика примечаний первого типа диска из таблиц MySQL.
		public function get
			DiskFirstTypeNotesSelectorRequestPHPFileURL( ): String
		{
			// URL-адрес PHP-файла запроса к базе данных MySQL
			// выборщика примечаний первого типа диска из таблиц MySQL.
			return this._DiskFirstTypeNotesSelectorRequestPHPFileURL;
		} // DiskFirstTypeNotesSelectorRequestPHPFileURL		
		
		// Get-метод получения URL-адреса PHP-файла запроса к базе данных MySQL
		// выборщика примечаний второго типа диска из таблиц MySQL.
		// Результат: URL-адрес PHP-файла запроса к базе данных MySQL
		// выборщика примечаний второго типа диска из таблиц MySQL.
		public function get
			DiskSecondTypeNotesSelectorRequestPHPFileURL( ): String
		{
			// URL-адрес PHP-файла запроса к базе данных MySQL
			// выборщика примечаний второго типа диска из таблиц MySQL.
			return this._DiskSecondTypeNotesSelectorRequestPHPFileURL;
		} // DiskSecondTypeNotesSelectorRequestPHPFileURL
		
		// Get-метод получения URL-адреса PHP-файла запроса к базе данных MySQL
		// выборщика характеристик разновидностей дисков из таблиц MySQL.
		// Результат: URL-адрес PHP-файла запроса к базе данных MySQL
		// выборщика характеристик разновидностей дисков из таблиц MySQL.
		public function get
			DiskVarietiesCharacteristicsSelectorRequestPHPFileURL( ): String
		{
			// URL-адрес PHP-файла запроса к базе данных MySQL
			// выборщика характеристик разновидностей дисков из таблиц MySQL.
			return this._DiskVarietiesCharacteristicsSelectorRequestPHPFileURL;
		} // DiskVarietiesCharacteristicsSelectorRequestPHPFileURL
		
		// Get-метод получения URL-адреса PHP-файла запроса к базе данных MySQL
		// выборщика цен разновидностей дисков из таблиц MySQL.
		// Результат: URL-адрес PHP-файла запроса к базе данных MySQL
		// выборщика цен разновидностей дисков из таблиц MySQL.
		public function get
			DiskVarietiesCostsSelectorRequestPHPFileURL( ): String
		{
			// URL-адрес PHP-файла запроса к базе данных MySQL
			// выборщика цен разновидностей дисков из таблиц MySQL.
			return this._DiskVarietiesCostsSelectorRequestPHPFileURL;
		} // DiskVarietiesCostsSelectorRequestPHPFileURL
		
		// Get-метод получения URL-адреса PHP-файла запроса к базе данных MySQL
		// выборщика данных продаж разновидностей дисков из таблиц MySQL.
		// Результат: URL-адрес PHP-файла запроса к базе данных MySQL
		// выборщика данных продаж разновидностей дисков из таблиц MySQL.
		public function get
			DiskVarietiesSalesDataSelectorRequestPHPFileURL( ): String
		{
			// URL-адрес PHP-файла запроса к базе данных MySQL
			// выборщика данных продаж разновидностей дисков из таблиц MySQL.
			return this._DiskVarietiesSalesDataSelectorRequestPHPFileURL;
		} // DiskVarietiesSalesDataSelectorRequestPHPFileURL
		
		// Get-метод получения URL-адреса PHP-файла запроса к базе данных MySQL
		// добавителя данных продажи разновидности диска
		// в корзину покупок в таблицах MySQL.
		// Результат: URL-адрес PHP-файла запроса к базе данных MySQL
		// добавителя данных продажи разновидности диска
		// в корзину покупок в таблицах MySQL.
		public function get
			DiskVarietySaleDataToShoppingCartAdderRequestPHPFileURL( ): String
		{
			// URL-адрес PHP-файла запроса к базе данных MySQL
			// добавителя данных продажи разновидности диска
			// в корзину покупок в таблицах MySQL.
			return this._DiskVarietySaleDataToShoppingCartAdderRequestPHPFileURL;
		} // DiskVarietySaleDataToShoppingCartAdderRequestPHPFileURL		
	
		// Get-метод получения имён столбцов, фильтрующих изображения дисков.
		// Результат: имена столбцов, фильтрующих изображения дисков.
		public function get DisksImagesFilteringColumnsNames( ): Array
		{
			// Имена столбцов, фильтрующих изображения дисков.
			return this._DisksImagesFilteringColumnsNames;
		} // DisksImagesFilteringColumnsNames

		// Get-метод получения имён столбцов, упорядочивающих изображения дисков.
		// Результат: имена столбцов, упорядочивающих изображения дисков.
		public function get DisksImagesOrderingColumnsNames( ): Array
		{
			// Имена столбцов, упорядочивающих изображения дисков.
			return this._DisksImagesOrderingColumnsNames;
		} // DisksImagesOrderingColumnsNames		
		
		// Get-метод получения направлений упорядочения изображений дисков.
		// Результат: направления упорядочения изображений дисков.
		public function get DisksImagesOrderingAscentSigns( ): Array
		{
			// Направления упорядочения изображений дисков.
			return this._DisksImagesOrderingAscentSigns;
		} // DisksImagesOrderingAscentSigns
		
		// Get-метод получения параметров выбора изображений дисков.
		// Результат: параметры выбора изображений дисков.
		public function get DisksImagesChoiceParameters( ): Object
		{
			// Параметры выбора изображений дисков.
			return this._DisksImagesChoiceParameters;
		} // DisksImagesChoiceParameters	
		
		// Get-метод получения массива имён столбцов названий
		// в таблице названий характеристик дисков.
		// Результат: массив имён столбцов названий
		// в таблице названий характеристик дисков.
		public function get DisksCharacteristicsNamesNamesColumnsNames( ): Array
		{
			// Массив имён столбцов названий
			// в таблице названий характеристик дисков.
			return this._DisksCharacteristicsNamesNamesColumnsNames;
		} // DisksCharacteristicsNamesNamesColumnsNames

		// Set-метод установки массива имён столбцов названий
		// в таблице названий характеристик дисков.
		// Параметры:
		// parDisksCharacteristicsNamesNamesColumnsNames - массив имён столбцов
		//   названий в таблице названий характеристик дисков.
		public function set DisksCharacteristicsNamesNamesColumnsNames
			( parDisksCharacteristicsNamesNamesColumnsNames: Array ): void
		{			
			// Последовательный просмотр всех имён столбцов названий
			// в таблице названий характеристик дисков.
			for ( var columnNameIndex: uint = 0; columnNameIndex <
					MySQLParameters.DISKS_CHARACTERISTICS_MAXIMUN_COUNT;
					columnNameIndex++ )
				// Запись текущего имени столбца названий
				// в таблице названий характеристик дисков.
				this._DisksCharacteristicsNamesNamesColumnsNames[ columnNameIndex ] =
					parDisksCharacteristicsNamesNamesColumnsNames[ columnNameIndex ];			
		} // DisksCharacteristicsNamesNamesColumnsNames
		
		// Get-метод получения массива имён столбцов характеристик
		// в таблице характеристик разновидностей дисков.
		// Результат: массив имён столбцов характеристик
		// в таблице характеристик разновидностей дисков.
		public function get
			DisksVarietiesCharacteristicsCharacteristicsColumnsNames( ): Array
		{
			// Массив имён столбцов характеристик
			// в таблице характеристик разновидностей дисков.
			return this._DisksVarietiesCharacteristicsCharacteristicsColumnsNames;
		} // DisksVarietiesCharacteristicsCharacteristicsColumnsNames

		// Set-метод установки массива имён столбцов характеристик
		// в таблице характеристик разновидностей дисков.
		// Параметры:
		// parDisksVarietiesCharacteristicsCharacteristicsColumnsNames -
		//   массив имён столбцов характеристик
		//   в таблице характеристик разновидностей дисков.
		public function set
			DisksVarietiesCharacteristicsCharacteristicsColumnsNames
			( parDisksVarietiesCharacteristicsCharacteristicsColumnsNames:
			Array ): void
		{			
			// Последовательный просмотр всех имён столбцов характеристик
			// в таблице названий характеристик дисков.
			for ( var columnNameIndex: uint = 0; columnNameIndex <
					MySQLParameters.DISKS_CHARACTERISTICS_MAXIMUN_COUNT;
					columnNameIndex++ )
				// Запись текущего имени столбца характеристик
				// в таблице названий характеристик дисков.
				this._DisksVarietiesCharacteristicsCharacteristicsColumnsNames
					[ columnNameIndex ] =
					parDisksVarietiesCharacteristicsCharacteristicsColumnsNames
					[ columnNameIndex ];			
		} // DisksVarietiesCharacteristicsCharacteristicsColumnsNames
		
		// Get-метод получения URL-адреса компьютера-клиента.
		// Результат: URL-адрес компьютера-клиента.
		public function get ClientURL( ): String
		{
			// URL-адрес компьютера-клиента.
			return this._ClientURL;
		} // ClientURL		
		
		// Get-метод получения URL-адреса PHP-файла запроса открывателя
		// медиа-плеера.
		// Результат: URL-адрес PHP-файла запроса открывателя медиа-плеера.
		public function get MediaPlayerOpenerRequestPHPFileURL( ): String
		{
			// URL-адрес PHP-файла запроса открывателя медиа-плеера.
			return this._MediaPlayerOpenerRequestPHPFileURL;
		} // MediaPlayerOpenerRequestPHPFileURL
	} // MySQLParameters
} // nijanus.customerDesktop.phpAndMySQL