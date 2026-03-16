// CustomerDesktop
// Author Kate Kotova
// NIJANUS Copyright © 2004-2010
// nijanus@ymail.com
// http://nijanus.narod2.ru
//---------------------------------------------------------------------------
// Пакет классов рабочего стола покупателя, связанных с отображением.
package nijanus.customerDesktop.display
{
	// Список импортированных классов из других пакетов.
	import flash.display.Sprite;
	//-------------------------------------------------------------------------

	// Класс экрана информации.
	public class InformationScreen extends Sprite
	{
		// Список импортированных классов из других пакетов.

		import flash.display.BitmapData;
		import flash.display.DisplayObjectContainer;
		import flash.events.Event;
		import flash.events.EventDispatcher;		
		import flash.events.IOErrorEvent;		
		import flash.events.MouseEvent;
		import flash.events.TimerEvent;			
		import flash.filters.BitmapFilterQuality;
		import flash.filters.GlowFilter;			
		import flash.geom.Point;
		import flash.geom.Rectangle;
		import flash.net.URLLoader;
		import flash.net.URLRequest;
		import flash.text.TextField;
		import flash.text.TextFieldType;
		import flash.text.TextFormat;
		import flash.text.TextFormatAlign;
		import flash.utils.Dictionary;			
		import flash.utils.Timer;
		import nijanus.customerDesktop.phpAndMySQL.DiskGroup;
		import nijanus.customerDesktop.phpAndMySQL.DiskSlidesFilesURLsSelector;
		import nijanus.customerDesktop.phpAndMySQL.DiskVarietySaleData;
		import nijanus.customerDesktop.phpAndMySQL.MySQLDiskDescriptionSelector;
		import nijanus.customerDesktop.phpAndMySQL.MySQLDiskGroupCodeSelector;		
		import nijanus.customerDesktop.phpAndMySQL.
			MySQLDiskVarietiesCharacteristicsSelector;
		import nijanus.customerDesktop.phpAndMySQL.
			MySQLDiskVarietiesCostsSelector;
		import nijanus.customerDesktop.phpAndMySQL.
			MySQLDiskVarietiesSalesDataSelector;
		import nijanus.customerDesktop.phpAndMySQL.MySQLParameters;
		import nijanus.customerDesktop.phpAndMySQL.SlideType;
		import nijanus.customerDesktop.phpAndMySQL.diskNotesSelector.
			DiskNotesSelector;
		import nijanus.customerDesktop.phpAndMySQL.diskNotesSelector.
			DiskNotesType;
		import nijanus.customerDesktop.text.TextParameters;
		import nijanus.customerDesktop.utils.ImageFilePathAndArticleInformation;
		import nijanus.customerDesktop.utils.SlideFilePathAndTypeInformation;
		import nijanus.display.AppearingWithIncreaseSprite;		
		import nijanus.display.ExitGlowButton;
		import nijanus.display.GlowButton;
		import nijanus.display.GlowButtonParameters;
		import nijanus.display.GlowScrollBar;
		import nijanus.display.ImagesLine;
		import nijanus.display.ImageSprite;
		import nijanus.display.ImageSpriteEvent;
		import nijanus.display.RectangleWithPerimeterBorder;		
		import nijanus.display.TetragonCornersCoordinates;
		import nijanus.display.TextFieldsColumn;
		import nijanus.display.TextFieldsGrid;
		import nijanus.display.TextFieldsGridProperties;
		import nijanus.display.TranslucentBlackSprite;
		import nijanus.php.PHPRequester;
		import nijanus.php.mySQL.MySQLURLsSelector;
		import nijanus.utils.FilePathInformation;
		import nijanus.utils.Tracer;
		import silin.bitmap.DistortImage;
		//-----------------------------------------------------------------------
		// Статические константы.
		
		// Имя класса.
		public static const CLASS_NAME: String = "InformationScreen";
		
		// Название типа события успешной загрузки статических параметров.
		public static const STATIC_PARAMETERS_LOADING_COMPLETE:      String =
			"StaticParametersLoadingFComplete";
		// Название типа события окончания загрузки статических параметров.
		public static const STATIC_PARAMETERS_LOADING_FINISHED:      String =
			"StaticParametersLoadingFinished";
		// Название типа события возникновения ошибки
		// при загрузке статических параметров.
		public static const STATIC_PARAMETERS_LOADING_IO_ERROR:      String =
			"StaticParametersLoadingIOError";			
		// Название типа события окончания загрузки демонстрационных
		// статических параметров.
		public static const DEMO_STATIC_PARAMETERS_LOADING_FINISHED: String =
			"DemoStaticParametersLoadingFinished";
		// Название типа события возникновения ошибки
		// при загрузке демонстрационных статических параметров.
		public static const DEMO_STATIC_PARAMETERS_LOADING_IO_ERROR: String =
			"DemoStaticParametersLoadingIOError";
		// Название типа события наступления момента времени закрытия.
		public static const SHOULD_CLOSE:               String = "ShouldClose";
		// Название типа события закрытия экрана медиа-плеера.
		public static const MEDIA_PLAYER_SCREEN_CLOSED:              String =
			"MediaPlayerScreenClosed";			
			
		// Сообщение об ошибке загрузки данных из файла статических параметров.
		public static const STATIC_PARAMETERS_FILE_URL_LOADING_IO_ERROR_MESSAGE:
			String = "Ошибка загрузки данных из файла статических параметров " +
			"класса InformationScreen";	
		// Сообщение об ошибке загрузки данных из файла демонстрационных
		// статических параметров.
		public static const
			DEMO_STATIC_PARAMETERS_FILE_URL_LOADING_IO_ERROR_MESSAGE:
			String = "Ошибка загрузки данных из файла демонстрационных " +
			"статических параметров класса InformationScreen";
		// Сообщение об ошибке загрузки данных
		// с URL-адреса текста описания диска.
		public static const DISK_DESCRIPTION_TEXT_URL_LOADING_IO_ERROR_MESSAGE:
			String = "Ошибка загрузки данных с URL-адреса текста описания диска: ";
			
		// Значение альфа-прозрачности цвета фильтра эффекта свечения
		// проекции перспективы лицевой поверхности изображения диска.
		public static const
			DISK_IMAGE_FRONT_SURFACE_PERSPECTIVE_PROJ_GLOW_FILTER_ALPHA:
			Number = 0.4;
		// Значение альфа-прозрачности цвета фильтра эффекта свечения
		// проекции перспективы боковины изображения диска.
		public static const
			DISK_IMAGE_SIDEWALL_PERSPECTIVE_PROJ_GLOW_FILTER_ALPHA: Number = 0.65;
	
		// Коэффициент степени размытия фильтра эффекта свечения
		// проекции перспективы лицевой поверхности изображения диска.
		public static const
			DISK_IMAGE_FRONT_SURFACE_PERSPECTIVE_PROJ_GLOW_FILTER_BLUR_RATIO:
			Number = 0.2;
		// Коэффициент степени размытия фильтра эффекта свечения
		// проекции перспективы боковины изображения диска.
		public static const
			DISK_IMAGE_SIDEWALL_PERSPECTIVE_PROJ_GLOW_FILTER_BLUR_RATIO:
			Number = 1;
			
		// Степень вдавливания или растискивания фильтра эффекта свечения
		// проекции перспективы лицевой поверхности изображения диска.
		public static const
			DISK_IMAGE_FRONT_SURFACE_PERSPECTIVE_PROJ_GLOW_FILTER_STRENGTH:
			Number = 1.1;
		// Степень вдавливания или растискивания фильтра эффекта свечения
		// проекции перспективы боковины изображения диска.
		public static const
			DISK_IMAGE_SIDEWALL_PERSPECTIVE_PROJ_GLOW_FILTER_STRENGTH: Number = 2;
		
		// Качество применения фильтра эффекта свечения проекции перспективы
		// изображения диска - высшее.
		public static const
			DISK_IMAGE_PERSPECTIVE_PROJECTION_GLOW_FILTER_QUALITY:
			int = BitmapFilterQuality.HIGH;			
		//-----------------------------------------------------------------------
		// Статические переменные.
		
		// Статический диспетчер событий.
		private static var _StaticEventDispatcher: EventDispatcher =
			new EventDispatcher( );		
			
		// Временные интервалы.
	
		// Задержка в миллисекундах таймера минимального показа -
		// задержка между появлением экрана информации и наступлением момента,
		// когда он уже может передавать событие клика мыши на кнопке выхода.
		public static var MinimumShowingTimerDelay: Number = 1000;
		// Время в миллисекундах длительности внешнего эффекта
		// изменения видимости - время, в течение которого осуществляется
		// эффект появления или исчезновения внешнего спрайта с эффектом.
		public static var OuterEffectTime:          Number = 1000;
		// Коэффициент отношения реальной скорости внешнего эффекта появления
		// к реальной скорости внешнего эффекта исчезновения.
		public static var OuterEffectShowingVelocityToHidingVelocityRatio:
			Number = 1;
		// Время в миллисекундах длительности эффекта изменения видимости
		// проекции перспективы изображения диска - время, в течение которого
		// осуществляется эффект появления или исчезновения спрайта с эффектом
		// проекции перспективы изображения диска.
		public static var ProjectionEffectTime:     Number = 500;
		// Коэффициент отношения реальной скорости эффекта появления
		// проекции перспективы изображения диска к реальной скорости
		// эффекта исчезновения проекции перспективы изображения диска.
		public static var ProjectionEffectShowingVelocityToHidingVelocityRatio:
			Number = 1.1;

		// Обрамляющие прямоугольники.		
		
		// Коэффициент отношения отступа от края прямоугольника информации
		// до внешнего прямоугльника без бордюра
		// к большей стороне прямоугольника информации.
		public static var
			OuterRectangleWBIndentionToGreaterInformationRectangleSideRatio:
			Number = 0.03;
		// Коэффициент отношения отступа
		// от края внешнего прямоугльника без бордюра
		// до внутреннего прямоугльника
		// к большей стороне внешнего прямоугльника без бордюра.
		public static var
			InnerRectangleIndentionToGreaterOuterRectangleWBSideRatio:
			Number = 0.016;
		// Коэффициент отношения ширины прямоугольника изображений
		// к ширине внутреннего прямоугольника.
		public static var ImagesRectangleWidthToInnerRectangleWidthRatio:
			Number = 3/8;
			
		// Элементы прямоугольника изображений.			
			
		// Коэффициент отношения высоты прямоугольника изображения диска
		// к высоте прямоугольника изображений.
		public static var DiskImageRectangleHeightToImagesRectangleHeightRatio:			
			Number = 70/92;
		// Коэффициент отношения ширины границ проекции перспективы
		// изображения диска и ширины границ прямоугольника изображения диска.
		public static var
			DiskImagePerspectiveProjBndsWidthToDiskImageRectBndsWidthRatio:
			Number = 0.7;
		// Коэффициент отношения высоты границ проекции перспективы
		// изображения диска и высоты границ прямоугольника изображения диска.
		public static var
			DiskImagePerspectiveProjBndsHeightToDiskImageRectBndsHeightTRatio:
			Number = 0.85;
			
		// Проекции перспективы изображения диска.
			
		// Угол наклона в градусах проекции перспективы
		// верхней грани изображения диска к оси абсцисс.
		public static var DiskImageTopPerspectiveProjectionAngle:    int = -5;
		// Угол наклона в градусах проекции перспективы
		// нижней грани изображения диска к оси абсцисс.
		public static var DiskImageBottomPerspectiveProjectionAngle: int = 15;
		// Коэффициент отношения ширины проекции перспективы боковины
		// изображения диска к ширине прямоугольника изображения диска.
		public static var
			DiskImageSidewallPerspectiveProjWidthToDiskImageRectWidth:
			Number = 0.07;
			
		// Строка слайдов.
			
		// Коэффициент отношения ширины спрайта изображения
		// строки слайдов к высоте.
		public static var SlidesLineImageSpriteWidthToHeightRatio:
			Number = 34/25;
		// Коэффициент отношения стороны пиктограммы мультимедиа-файла диска
		// к большей стороне спрайта изображения строки слайдов.
		public static var DiskMultimediaFileIconSideToGreaterSlideSideRatio:
			Number = 3/5;
		// Альфа-прозрачность пиктограммы мультимедиа-файла диска.
		public static var DiskMultimediaFileIconAlpha: Number = 0.65;
		
		// Элементы прямоугольника описания диска.
			
		// Коэффициент отношения высоты прямоугольника описания диска
		// к высоте прямоугольника текстов.
		public static var
			DiskDescriptionRectangleHeightToTextsRectangleHeightRatio: 
			Number = 35/92;
		// Коэффициент отношения ширины полоса прокрутки описания диска
		// к ширине прямоугольника описания диска.
		public static var DiskDescrScrollBarWidthToDiskDescrRectangleWidthRatio:
			Number = 0.08;
		// Коэффициент отношения высоты бегунка полосы прокрутки описания диска
		// к высоте её дорожки.
		public static var DiskDescriptionScrollBarThumbHeightToTrackHeightRatio:
			Number = 1/3;
			
		// Текстовое поле описания диска.
			
		// Коэффициент сжатия ширины строки текстового поля описания диска.
		public static var DiskDescriptionTextFieldLineWidthCompressionRatio:
			Number = 5;
		// Коэффициент сжатия высоты строки текстового поля описания диска.
		public static var DiskDescriptionTextFieldLineHeightCompressionRatio:
			Number = 6/5;
		// Минимальное количество символов в строке
		// текстового поля описания диска.
		public static var DiskDescriptionTextFieldLineSymbolsMinimumCount:
			uint   = 75;
		// Минимальное количество строк в текстовом поле описания диска.
		public static var DiskDescriptionTextFieldLinesMinimumCount: uint = 12;
		// Вертикальный межстрочный интервал в текстовом поле описания диска.
		public static var DiskDescriptionTextFieldLinesLeadingVerticalSpace:
			Number = 0;
			
		// Таблица примечаний.
			
		// Коэффициент отношения высоты таблицы примечаний
		// к высоте прямоугольника таблиц.
		public static var NotesGridHeightToGridsRectangleHeightRatio:
			Number = 4/54;
		// Коэффициент сжатия ширины текста ячейки таблицы примечаний.
		public static var NotesGridCellTextWidthCompressionRatio:  Number = 3;
		// Коэффициент сжатия высоты текста ячейки таблицы примечаний.
		public static var NotesGridCellTextHeightCompressionRatio: Number = 0.7;	
		
		// Элементы прямоугольника кнопок выбора.
	
		// Коэффициент отношения высоты прямоугольника кнопок выбора
		// к высоте прямоугольника таблиц.
		public static var
			ChoiceButtonsRectangleHeightToGridsRectangleHeightRatio: Number = 8/54;
		// Коэффициент отношения максимальной ширины кнопки выбора
		// к ширине прямоугольника кнопок выбора.
		public static var
			ChoiceButtonMaximumWidthToChoiceButtonsRectangleWidthRatio:
			Number = 1/3;
		// Текстовая метка для кнопки выбора.
		// Copyright Protection: [Выбрать] - Full, [ВыБРаtь] - Demo.		
		public static var ChoiceButtonLabel: String = "ВыБРаtь";//"Выбрать";
		
		// Кнопка выхода.
		
		// Максимальный коэффициент отношения стороны пиктограммы кнопки выхода
		// к соответствующей стороне кнопки выхода -
		// коэффициент, максимальный из двух:
		// отношения ширины пиктограммы к ширине кнопки выхода
		// и отношения высоты пиктограммы к высоте кнопки выхода.		
		public static var ExitButtonIconSideToExitButtonSameSideMaximumRatio:
			Number = 0.55;		
		
		// Таблица стоимостей.
			
		// Коэффициент отношения высоты таблицы стоимостей
		// к высоте прямоугольника таблиц.
		public static var CostsGridHeightToGridsRectangleHeightRatio:
			Number = 6/54;
		// Коэффициент сжатия ширины текста ячейки таблицы стоимостей.
		public static var CostsGridCellTextWidthCompressionRatio:  Number = 1;
		// Коэффициент сжатия высоты текста ячейки таблицы стоимостей.
		public static var CostsGridCellTextHeightCompressionRatio: Number = 0.7;	
		
		// Таблица характеристик.
			
		// Коэффициент отношения ширины области названий характеристик
		// к ширине прямоугольника таблиц.
		public static var
			CharacteristicsNamesAreaWidthToGridsRectangleWidthRatio: Number = 2/10;
		// Коэффициент отношения ширины символа таблицы характеристик
		// к ширине таблицы характеристик.
		public static var CharacteristicsGridSymbolWidthToWidthRatio:
			Number = 1/250;
		// Коэффициент сжатия ширины текста ячейки
		// столбца назаний характеристик таблицы характеристик.
		public static var
			CharacteristicsGridNamesColumnCellTextWidthCompressionRatio:
			Number = 2.6;
		// Коэффициент сжатия высоты текста ячейки
		// столбца назаний характеристик таблицы характеристик.
		public static var
			CharacteristicsGridNamesColumnCellTextHeightCompressionRatio:
			Number = 0.9;
		// Коэффициент сжатия ширины текста ячейки
		// столбца категорий диска таблицы характеристик.
		public static var
			CharacteristicsGridCategoriesColumnCellTextWidthCompressionRatio:
			Number = 2.6;
		// Коэффициент сжатия высоты текста ячейки
		// столбца категорий диска таблицы характеристик.
		public static var
			CharacteristicsGridCategoriesColumnCellTextHeightCompressionRatio:
			Number = 0.9;
		//-----------------------------------------------------------------------
		// Переменные экземпляра класса.
		
		// Основныйе элементы.
		
		// Парараметры базы данных MySQL.
		private var _MySQLDatabaseParameters: MySQLParameters            = null;
		// Информация диска.
		private var _DiskInformation: ImageFilePathAndArticleInformation = null;
		// Основные текстовые параметры.
		private var _MainTextParameters:      TextParameters             = null;
		// Основной трассировщик.
		private var _MainTracer:              Tracer                     = null;
		
		// Выборщики данных.
		
		// Выборщик описания диска из таблиц MySQL.
		private var _DiskDescriptionSelector:
			MySQLDiskDescriptionSelector                    = null;
		// Выборщик кода группы диска из таблиц MySQL.
		private var _DiskGroupCodeSelector:
			MySQLDiskGroupCodeSelector                      = null;
		// Выборщик примечаний диска из таблиц MySQL.
		private var _DiskNotesSelector: DiskNotesSelector = null;		
		// Выборщик цен разновидностей дисков из таблиц MySQL.
		private var _DiskVarietiesCostsSelector:
			MySQLDiskVarietiesCostsSelector                 = null;			
		// Выборщик характеристик разновидностей дисков из таблиц MySQL.
		private var _DiskVarietiesCharacteristicsSelector:
			MySQLDiskVarietiesCharacteristicsSelector       = null;
		// Выборщик URL-адресов кадров фильмов диска.
		private var _DiskFramesFilesURLsSelector:
			DiskSlidesFilesURLsSelector                     = null;
		// Выборщик URL-адресов видео-файлов диска.
		private var _DiskVideosFilesURLsSelector:
			DiskSlidesFilesURLsSelector                     = null;
		// Выборщик URL-адресов аудио-файлов диска.
		private var _DiskAudiosFilesURLsSelector:
			DiskSlidesFilesURLsSelector                     = null;
		// Выборщик данных продаж разновидностей дисков из таблиц MySQL.
		private var _DiskVarietiesSalesDataSelector:
			MySQLDiskVarietiesSalesDataSelector             = null;
			
		// Классификации диска.
			
		// Группа диска.
		private var _DiskGroup:                        String     = null;
		// Тип примечаний диска.
		private var _DiskNotesType:                    String     = null;		
		// Словарь данных продаж разновидностей диска,
		// ключами которого являются объекты соответствующих кнопок выбора:
		// нажатие на кнопку выбора означает выбор в корзину покупок
		// диска с данными продажи, закреплёнными за этой кнопкой выбора.
		private var _DiskVarietiesSalesDataDictionary: Dictionary =
			new Dictionary( );
		
		// Таймер минимального показа, который запускается 1 раз -
		// тогда, появившись, экран информации не передаёт событие
		// клика мыши на кнопке выхода, а потом по истечении времени таймера
		// при клике мыши на кнопке выхода, экран информации
		// уже передаёт это событие.
		private var _MinimumShowingTimer: Timer =
			new Timer( InformationScreen.MinimumShowingTimerDelay, 1 );
			
		// Отступы прямоугольников.
		
		// Отступ прямоугольника информации от нижнего края экрана информации.
		private var _InformationRectangleBottomIndention:  Number;		
		// Отступ внешнего прямоугольника без бордюра
		// от краёв прямоугольника информации.
		private var _OuterRectangleWithoutBorderIndention: Number;
		// Отступ внутреннего прямоугольника
		// от краёв внешнего прямоугльника без бордюра.
		private var _InnerRectangleIndention:              Number;
		
		// Параметры элементов прямоугольника изображений.
		
		// Коэффициент отношения ширины прямоугольника изображения диска
		// к высоте.
		private var _DiskImageRectangleWidthToHeightRatio:             Number;
		// Ордината проекции перспективы правого верхнего угла изображения диска.
		private var _DiskImageTopRightCornerPerspectiveProjectionY:    Number;
		// Ордината проекции перспективы правого нижнего угла изображения диска.
		private var _DiskImageBottomRightCornerPerspectiveProjectionY: Number;
		// Сторона пиктограммы мультимедиа-файла диска.
		private var _DiskMultimediaFileIconSide:                       Number;
		
		// Параметры категорий диска.
		
		// Ширина области названий характеристик.
		private var _CharacteristicsNamesAreaWidth: Number;
		// Количество категорий диска.
		private var _DiskCategoriesCount:           uint  = 0;
		// Ширина области категории диска.
		private var _DiskCategoryAreaWidth:         Number;		
		// Массив кнопок выбора.
		private var _ChoiceButtons:                 Array = null;
		
		// Обрамляющие прямоугольники.
		
		// Фоновый прямоугольник - полупрозрачный фоновый спрайт,
		// полностью покрывающий экран информации.
		private var _BackgroundRectangle:  TranslucentBackgroundSprite =
			new TranslucentBackgroundSprite( );			
		// Прямоугольник информации - прямоугольник
		// поверх фонового прямоугольника, меньший, чем он, по размерам,
		// расположенный в композиционном центре относительно экрана выбора,
		// на нём размещаются все элементы экрана информации.
		private var _InformationRectangle:        Rectangle = new Rectangle( );		
		// Внешний спрайт с эффектом - спрайт, появляющийся с увеличением
		// из ценрта и исчезающий с уменьшением в центр, расположенный
		// в центре прямоугольника информации, меньший, чем он, по размерам,		
		// на нём располагаются все элементы, кроме фонового прямоугольника
		// и прямоугольника информации, и к ним применяется эффект.
		private var _OuterEffectSprite:    AppearingWithIncreaseSprite;		
		// Внешний прямоугольник - чёрный полупрозрачный спрайт,
		// расположенный в центре прямоугольника информации, меньший, чем он,
		// по размерам, на нём размещаются все информационные элементы.
		private var _OuterRectangle:       TranslucentBlackSprite      =
			new	TranslucentBlackSprite( );			
		// Внешний прямоугольник без бордюра -
		// граница закруглённого прямоугольника без тени,
		// являющаяся границей внешнего прямоугольником только без тени.
		private var _OuterRectangleWithoutBorder: Rectangle = new Rectangle( );	
		// Внутренний прямоугольник - прямоугольник, расположенный
		// в центре внешнего прямоугольника, меньший, чем он, по размерам,
		// на нём размещаются все информационные элементы.
		private var _InnerRectangle:              Rectangle = new Rectangle( );		
		// Внутренний прямоугольник в системе координат экрана информации.
		private var _InnerRectangleInThisCoordinateSpace: Rectangle;		
		// Прямоугольник изображений - прямоугольник, занимающий левую часть
		// внутреннего прямоугольника, меньший, чем он, по размерам,
		// на нём размещаются информационные элементы изображений.	
		private var _ImagesRectangle:             Rectangle = new Rectangle( );
		// Прямоугольник текстов - прямоугольник, занимающий правую часть
		// внутреннего прямоугольника, меньший, чем он, по размерам,
		// на нём размещаются информационные элементы текстов.
		private var _TextsRectangle:              Rectangle = new Rectangle( );
		
		// Элемента прямоугольника изображений.
		
		// Прямоугольник изображения диска - градиентный прямоугольник,
		// занимающий левый верхний угол прямоугольника изображений,
		// меньший, чем он, по размерам,
		// на нём размещается проекция перспективы изображения диска.
		private var _DiskImageRectangle:                         ImageSprite;
		// Границы прямоугольника изображения диска.
		private var _DiskImageRectangleBounds:                   Rectangle;
		// Границы проекции перспективы изображения диска.
		private var _DiskImagePerspectiveProjectionBounds:       Rectangle =
			new Rectangle( );			
		// Спрайт с эффектом проекции перспективы изображения диска -
		// спрайт, появляющийся с увеличением из ценрта и исчезающий
		// с уменьшением в центр, имеющий границы проекции перспективы
		// изображения диска,	на нём располагаются проекции перспективы
		// изображения диска, и к ним применяется эффект.
		private var _DiskImagePerspectiveProjectionEffectSprite:
			AppearingWithIncreaseSprite;
		// Координаты вершин четырёхугольника проекции перспективы
		// лицевой поверхности изображения диска.
		private var
			_DiskImageFrontSurfacePerspectiveProjectionCornersCoordinates:
			TetragonCornersCoordinates = new TetragonCornersCoordinates( );		
		// Координаты вершин четырёхугольника проекции перспективы
		// боковины изображения диска.		
		private var _DiskImageSidewallPerspectiveProjectionCornersCoordinates:
			TetragonCornersCoordinates = new TetragonCornersCoordinates( );			
		// Проекция перспективы лицевой поверхности изображения диска -
		// спрайт с механизмом отрисовки текстуры в произволные точки -
		// прямоугольник, искажённый построением проеции перспективы,
		// находящийся поверх прямоугольника изображения диска,
		// меньший, чем он, по размерам.
		private var _DiskImageFrontSurfacePerspectiveProjection: DistortImage;
		// Проекция перспективы боковины изображения диска -
		// спрайт с механизмом отрисовки текстуры в произволные точки -
		// прямоугольник, искажённый построением проеции перспективы,
		// находящийся поверх прямоугольника изображения диска,
		// меньший, чем он, по размерам, слева от проеции перспективы
		// лицевой поверхности изображения диска, имея с ней смежную сторону.
		private var _DiskImageSidewallPerspectiveProjection:     DistortImage;		
		// Строка слайдов - строка изображений, занимающая нижнюю часть
		// прямоугольника изображений, меньшая, чем он, по размерам,
		// на ней размещаются спрайты изображений слайдов.
		private var  _SlidesLine:                                ImagesLine;
		
		// Элемента прямоугольника текстов.		
		
		// Прямоугольник описания диска - прямоугольник, занимающей верхнюю часть
		// прямоугольника текстов, меньший, чем он, по размерам,
		// на нём размещаются информационные элементы описания диска.
		private var _DiskDescriptionRectangle: Rectangle = new Rectangle( );
		// Текстовое поле описания диска - текстовое поле, занимающее левую часть
		// прямоугольника описания диска, меньшее, чем он, по размерам.
		private var _DiskDescriptionTextField: TextField = new TextField( );		
		// Полоса прокрутки описания диска - светящаяся полоса прокрутки,
		// занимающая правую часть прямоугольника описания диска,
		// меньшая, чем он, по размерам,
		// предназначенная для прокрутки текстового поля описания диска.
		private var _DiskDescriptionScrollBar: GlowScrollBar;		
		// Прямоугольник таблиц - прямоугольник, занимающей нижнюю часть
		// прямоугольника текстов, меньший, чем он, по размерам,
		// на нём размещаются все элементы информационных таблиц.
		private var _GridsRectangle:           Rectangle = new Rectangle( );
		// Таблица примечаний - таблица, занимающая верхнюю часть
		// прямоугольника таблиц, меньшая, чем он, по размерам.
		private var _NotesGrid:                TextFieldsGrid;
		// Прямоугольник кнопок выбора - прямоугольник, расположенный
		// под таблицей примечаний поверх прямоугольника таблиц,
		// меньший чем он, по размерам.
		private var _ChoiceButtonsRectangle:   Rectangle = new Rectangle( );
		// Таблица стоимостей - таблица, расположенная
		// под прямоугольником кнопок выбора поверх прямоугольника таблиц,
		// меньшая, чем он, по размерам.
		private var _CostsGrid:                TextFieldsGrid;
		// Таблица характеристик - таблица, занимающая нижнюю часть
		// прямоугольника таблиц, меньшая, чем он, по размерам.		
		private var _CharacteristicsGrid:      TextFieldsGrid;
		// Кнопка выхода.
		private var _ExitButton:               ExitGlowButton;
		
		// Экраны.
		
		// Экран кадра медиа-плеера.
		private var _MediaPlayerScreen: MediaPlayerScreen;	
		// Экран корзины покупок.
		private var _ShopingCartScreen: ShopingCartScreen;
		//-----------------------------------------------------------------------
		// Статические методы.
		
		// Метод загрузки статических параметров.
		// Параметры:
		// parStaticParametersFilePath - путь к файлу статических параметров.
		public static function LoadStaticParameters
			( parStaticParametersFilePath: String ): void
		{
			// Загрузчик данных с URL-адреса файла статических параметров.
			var staticParametersFileURLLoader: URLLoader = new URLLoader( );			
			// Загрузка данных с URL-адреса файла статических параметров.
			staticParametersFileURLLoader.load( new URLRequest
				( parStaticParametersFilePath ) );			
			
			// Регистрирация объекта-прослушивателя события
			// успешной загрузки данных с URL-адреса файла статических параметров.
			staticParametersFileURLLoader.addEventListener( Event.COMPLETE,
				InformationScreen.StaticParametersFileURLLoadingCompleteListener );				
			// Регистрирация объекта-прослушивателя события возникновения ошибки
			// при загрузке данных с URL-адреса файла статических параметров.
			staticParametersFileURLLoader.addEventListener( IOErrorEvent.IO_ERROR,
				InformationScreen.StaticParametersFileURLLoadingIOErrorListener );	
		} // LoadStaticParameters		
		
		// Метод загрузки демонстрационных статических параметров.
		// Параметры:
		// parDemoStaticParametersFilePath - путь к файлу демонстрационных
		//   статических параметров.
		public static function LoadDemoStaticParameters
			( parDemoStaticParametersFilePath: String ): void
		{
			// Загрузчик данных с URL-адреса файла демонстрационных
			// статических параметров.
			var demoStaticParametersFileURLLoader: URLLoader = new URLLoader( );			
			// Загрузка данных с URL-адреса файла демонстрационных
			// статических параметров.
			demoStaticParametersFileURLLoader.load( new URLRequest
				( parDemoStaticParametersFilePath ) );			
			
			// Регистрирация объекта-прослушивателя события успешной загрузки
			// данных с URL-адреса файла демонстрационных статических параметров.
			demoStaticParametersFileURLLoader.addEventListener( Event.COMPLETE,
				InformationScreen.
				DemoStaticParametersFileURLLoadingCompleteListener );				
			// Регистрирация объекта-прослушивателя события возникновения ошибки
			// при загрузке данных с URL-адреса файла демонстрационных
			// статических параметров.
			demoStaticParametersFileURLLoader.addEventListener
				( IOErrorEvent.IO_ERROR, InformationScreen.
				DemoStaticParametersFileURLLoadingIOErrorListener );	
		} // LoadDemoStaticParameters		
		
		// Метод получения угла от 0 до 360 градусов для вычисления тангенса.
		// Параметры:
		// parAngleInDegrees - угол в градусах.
		// Результат: угол в градусах, приведённый к диапазону
		// от 0 до 360 градусов с исключением недействительных значений
		// для вычисления тангенса.
		private static function GetAngleFrom0To360DegreesForTangent
			( parAngleInDegrees: int ): int
		{
			// Один полный оборот координатного круга в градусах - 360 градусов.
			const ONE_WHOLE_TURN_IN_DEGREES: int = 360;
			// Угол приводится к диапазону ( -360; 360 ) в градусах.
			parAngleInDegrees %= ONE_WHOLE_TURN_IN_DEGREES;
			
			// Угол приводится к диапазону [ 0; 360 ) в градусах.
			// Если угол получился отрицательным.
			if ( parAngleInDegrees < 0 )
				// Для приведения угла к диапазону [ 0; 360 ) в градусах
				// добавляется 360 градусов.
				parAngleInDegrees += ONE_WHOLE_TURN_IN_DEGREES;
				
			// Четверть оборота координатного круга в градусах - 90 градусов.
			const QUARTER_OF_TURN_IN_DEGREES: int = 90;
			
			// Угол приводится к действительному значению в градусах
			// для вычисления тангенса.
			// Если угол соответствует значению 90 или 270 градусов.
			if ( ( parAngleInDegrees == QUARTER_OF_TURN_IN_DEGREES ) ||
					( parAngleInDegrees == 3 * QUARTER_OF_TURN_IN_DEGREES ) )
				// Тангенс от этого угла не определён, его значение недействительно,
				// поэтому угол заменяется нулевым.
				parAngleInDegrees = 0;
				
			// Возврат преобразованного угла в градусах.
			return parAngleInDegrees;
		} // GetAngleFrom0To360DegreesForTangent
		
		// Метод получения коэффициента смещения по оси ординат точки на грани
		// прямогольного изображения при выполении перспективной проекции.
		// Параметры:
		// parAngleFrom0To360Degrees - угол в диапазоне от 0 до 360 градусов
		//   отклонения перспективной проекции грани изображения,
		//   содержащей заданную точку, относительно оси абсцисс.
		// Результат: коэффициент, равный 1 или (-1), задающий знак смещения
		// по оси ординат заданной точки.
		private static function GetPointPerspectiveProjectionYOffsetRatio
			( parAngleFrom0To360Degrees: int ): int
		{
			// Угол должен быть заранее приведён к диапазону [ 0; 360 ) в градусах.
			// Должны быть исключены значения 90 и 270 градусов,
			// так как в этом случае тангенс угла не действителен.
			
			// В первой половине координатного круга
			// рассматриваемое смещение точки отрицательно.
			if
			(
				( parAngleFrom0To360Degrees >= 0   ) &&
				( parAngleFrom0To360Degrees <= 180 ) &&
				( parAngleFrom0To360Degrees != 90  )
			)
				// Возврат отрицательного знакового коэффициента.
				return -1;
			else
				// Во второй половине координатного круга
				// рассматриваемое смещение точки положительно.
				if
				(
					( parAngleFrom0To360Degrees  > 180 ) &&
					( parAngleFrom0To360Degrees  < 360 ) &&
					( parAngleFrom0To360Degrees != 270 )
				)
					// Возврат положительного знакового коэффициента.
					return 1;
				// В остальных случаях.
				else
				{
					// Угол не нормирован и поэтому устанавливается угол
					// от 0 до 360 градусов для вычисления тангенса.
					parAngleFrom0To360Degrees = InformationScreen.
						GetAngleFrom0To360DegreesForTangent( parAngleFrom0To360Degrees );
					// Производится повторная попытка
					// вычисления знакового коэффициента.
					return InformationScreen.GetPointPerspectiveProjectionYOffsetRatio
						( parAngleFrom0To360Degrees );
				} // else			
		} // GetPointPerspectiveProjectionYOffsetRatio
		
		// Метод получения смещения по оси ординат вершины
		// прямогольного изображения при выполении перспективной проекции.
		// Параметры:
		// parAngleInDegrees    - угол в градусах отклонения
		//   перспективной проекции грани изображения, содержащей
		//   заданную вершину, относительно оси абсцисс,
		// parEdgeOriginalWidth - оригинальная длина грани изображения,
		//   содержащей заданную вершину, до выполнения перспективной проекции
		//   с получением заданного угла отклонения относительно оси абсцисс.
		// Результат: смещение по оси ординат заданной вершины
		// при выполении её перспективной проекции.
		private static function GetCornerPerspectiveProjectionYOffset
		(
			parAngleInDegrees:    int,
			parEdgeOriginalWidth: Number
		): Number
		{
			// Приведение угла к значению в диапазоне от 0 до 360 градусов,
			// соответствующего действительному значению тангенса от этого угла.
			parAngleInDegrees = InformationScreen.
				GetAngleFrom0To360DegreesForTangent( parAngleInDegrees );
			// Смещение по оси ординат заданной вершины при выполении
			// её перспективной проекции:
			// произведение коэффициента смещения по оси ординат вершины
			// при выполении её перспективной проекции и модуля произведения
			// тангенса угла в радианах отклонения перспективной проекции
			// грани изображения, содержащей вершину, относительно оси абсцисс
			// и оригинальной длины этой грани изображения до проецирования.
			return InformationScreen.GetPointPerspectiveProjectionYOffsetRatio
				( parAngleInDegrees ) * Math.abs( Math.tan( parAngleInDegrees *
				Math.PI / 180 ) * parEdgeOriginalWidth );
		} // GetCornerPerspectiveProjectionYOffset
		//-----------------------------------------------------------------------
		// Методы экземпляра класса.
		
		// Методы геометрических и визуальных компонентов.
		
		// Метод инициализации фонового прямоугольника.
		private function InitializeBackgroundRectangle( ): void		
		{
			// Вызов метода класса.
			this._MainTracer.CallClassMethod( InformationScreen.CLASS_NAME,
				"InitializeBackgroundRectangle" );			
			
			// Добавление фонового прямоугольника на экран информации.
			this.addChild( this._BackgroundRectangle );	
			
			// Координаты фонового прямоугольника -
			// левый верхний угол экрана информации.
			this._BackgroundRectangle.x      = 0;
			this._BackgroundRectangle.y      = 0;
			// Размеры фонового прямоугольника - размеры экрана информации.
			this._BackgroundRectangle.width  = this.width;
			this._BackgroundRectangle.height = this.height;
		} // InitializeInformationRectangle
		
		// Метод инициализации прямоугольника информации.
		private function InitializeInformationRectangle( ): void		
		{
			// Вызов метода класса.
			this._MainTracer.CallClassMethod( InformationScreen.CLASS_NAME,
				"InitializeInformationRectangle" );			
			
			// Экран информации размещается поверх экрана выбора
			// и покрывает его прозрачным прямоугольником.
			// Экран выбора композиционно разбит на две области:
			// область кнопок меню, расположенную внизу,
			// и область строк изображений.
			
			// Чтобы элементы экрана информации были композиционно отцентрованы,
			// они должны быть отцентрованы относительно области
			// строк изображений экрана выбора,
			// поэтому прямоугольник информации создаётся как область
			// сосредоточения всех элементов экрана выбора, он покрывает область
			// строк изображений экрана выбора,
			// и отходит от нижнего края экрана информации на величину отступа,
			// соответствующего высоте области кнопок меню экрана выбора.	
			
			// Прямоугольник информации не добавляется на экран информации,
			// он нужен для хранения его параметров.			
			
			// Координаты прямоугольника информации -
			// левый верхний угол экрана информации.
			this._InformationRectangle.x      = 0;
			this._InformationRectangle.y      = 0;
			// Ширина прямоугольника информации - ширина экрана информации.
			this._InformationRectangle.width  = this.width;
			// Высота прямоугольника информации:
			// разность высоты экрана информации и величины отступа
			// прямоугольника информации от нижнего края экрана информации.
			this._InformationRectangle.height = this.height -
				this._InformationRectangleBottomIndention;						
		} // InitializeInformationRectangle
		
		// Метод инициализации внешнего прямоугольника без бордюра.
		private function InitializeOuterRectangleWithoutBorder( ): void
		{	
			// Вызов метода класса.
			this._MainTracer.CallClassMethod( InformationScreen.CLASS_NAME,
				"InitializeOuterRectangleWithoutBorder" );		
		
			// Большая сторона прямоугольника информации.
			var informationRectangleGreaterSide: Number =
				(
					this._InformationRectangle.height >=
					this._InformationRectangle.width
				) ?
					this._InformationRectangle.height :
					this._InformationRectangle.width;
			
			// Отступ внешнего прямоугольника без бордюра
			// от краёв прямоугольника информации:
			// произведение большей стороны прямоугольника информации
			// на коэффициент отношения отступа от края прямоугольника информации
			// до внешнего прямоугльника без бордюра
			// к большей стороне прямоугольника информации.
			this._OuterRectangleWithoutBorderIndention             =
				informationRectangleGreaterSide * InformationScreen.
				OuterRectangleWBIndentionToGreaterInformationRectangleSideRatio;
			// Удвоенный отступ внешнего прямоугольника без бордюра
			// от краёв прямоугольника информации.
			var outerRectangleWithoutBorderDoubleIndention: Number =
				this._OuterRectangleWithoutBorderIndention * 2;
			
			// Внешний прямоугольник без бордюра не добавляется
			// на экран информации, он нужен для хранения его параметров.	

			// Координаты внешнего прямоугольника без бордюра:
			// стороны внешнего прямоугольника без бордюра находятся на расстоянии
			// от краёв прямоугольника информации, равном отступу
			// внешнего прямоугольника без бордюра
			// от краёв прямоугольника информации.
			this._OuterRectangleWithoutBorder.x      =
				this._OuterRectangleWithoutBorderIndention;
			this._OuterRectangleWithoutBorder.y      =
				this._OuterRectangleWithoutBorderIndention;
			// Размеры внешнего прямоугольника без бордюра:
			// стороны внешнего прямоугольника без бордюра
			// равны соответствующим сторонам прямоугольника информации
			// за вычетом удвоенных отступов:
			// по ширине - отступы справа и слева,
			// по высоте - отступы сверху и снизу.
			this._OuterRectangleWithoutBorder.width  =
				this._InformationRectangle.width  -
				outerRectangleWithoutBorderDoubleIndention;
			this._OuterRectangleWithoutBorder.height =
				this._InformationRectangle.height -
				outerRectangleWithoutBorderDoubleIndention;	
		} // InitializeOuterRectangleWithoutBorder	
		
		// Метод инициализации внешнего спрайта с эффектом.
		private function InitializeOuterEffectSprite( ): void
		{
			// Вызов метода класса.
			this._MainTracer.CallClassMethod( InformationScreen.CLASS_NAME,
				"InitializeOuterEffectSprite" );
			
			// Внешний прямоугольник без бордюра - это границы без бордюра
			// внешнего прямоугольника, надо установить его истинные границы -
			// с бордюром.
			
			// Границы - прямоугольник с бордюром по периметру,
			// соответствующий границам чёрного полупрозрачного спрайта,
			// каким является внешний прямоугольник,
			// нулевых размеров с теневым бордюром.
			var bounds: RectangleWithPerimeterBorder =
				new RectangleWithPerimeterBorder
				( TranslucentBlackSprite.SHADOW_BORDER_WIDTH );				
			// Границы без бордюра - внешний прямоугольник без бордюра.
			bounds.BoundsWithoutBorder = this._OuterRectangleWithoutBorder;
			
			// Создание внешнего спрайта с эффектом
			// с границами внешнего прямоугольника с учётом бордюра.
			this._OuterEffectSprite = new AppearingWithIncreaseSprite
				( bounds.BoundsWithBorder, InformationScreen.OuterEffectTime,
				InformationScreen.OuterEffectShowingVelocityToHidingVelocityRatio );
		} // InitializeOuterEffectSprite
		
		// Метод инициализации внешнего прямоугольника.
		private function InitializeOuterRectangle( ): void
		{		
			// Вызов метода класса.
			this._MainTracer.CallClassMethod( InformationScreen.CLASS_NAME,
				"InitializeOuterRectangle" );		
		
			// Добавление внешнего прямоугольника на внешний спрайт с эффектом.
			this._OuterEffectSprite.addChild( this._OuterRectangle );			
			// Устновка границ с бордюром внешнего прямоугольника
			// по границам внутреней области внешнего спрайта с эффектом.
			this._OuterRectangle.BoundsWithBorder =
				this._OuterEffectSprite.getBounds( this._OuterEffectSprite );
		} // InitializeOuterRectangle			
		
		// Метод инициализации внутреннего прямоугольника.
		private function InitializeInnerRectangle( ): void
		{		
			// Вызов метода класса.
			this._MainTracer.CallClassMethod( InformationScreen.CLASS_NAME,
				"InitializeInnerRectangle" );	
			
			// Большая сторона внешнего прямоугльника без бордюра.
			var outerRectangleWithoutBorderGreaterSide: Number =
				(
					this._OuterRectangleWithoutBorder.height >=
					this._OuterRectangleWithoutBorder.width
				) ?
					this._OuterRectangleWithoutBorder.height :
					this._OuterRectangleWithoutBorder.width;
			
			// Отступ внутреннего прямоугольника
			// от краёв внешнего прямоугльника без бордюра:
			// произведение большей стороны внешнего прямоугльника без бордюра
			// на коэффициент отношения отступа
			// от края внешнего прямоугльника без бордюра
			// до внутреннего прямоугльника
			// к большей стороне внешнего прямоугльника без бордюра.
			this._InnerRectangleIndention                                =
				outerRectangleWithoutBorderGreaterSide * InformationScreen.
				InnerRectangleIndentionToGreaterOuterRectangleWBSideRatio;
			// Отступ внутреннего прямоугольника от краёв
			// внешнего спрайта с эффектом:
			// сумма отступа внутреннего прямоугольника
			// от краёв внешнего прямоугльника без бордюра
			// и ширина теневого бордюра внешнего прямоугольника.
			var innerRectangleIndentionToOuterEffectSprite:       Number =
				this._InnerRectangleIndention +
				TranslucentBlackSprite.SHADOW_BORDER_WIDTH;
			// Удвоенный отступ внутреннего прямоугольника
			// от краёв внешнего спрайта с эффектом.
			var innerRectangleDoubleIndentionToOuterEffectSprite: Number =
				innerRectangleIndentionToOuterEffectSprite * 2;
			
			// Внутренний прямоугольник не добавляется
			// на внешний спрайт с эффектом, он нужен для хранения его параметров.
			
			// Координаты внутреннего прямоугольника:
			// стороны внутреннего прямоугольника находятся на расстоянии
			// от краёв внешнего спрайта с эффектом, равном отступу
			// внутреннего прямоугольника от краёв внешнего спрайта с эффектом.
			this._InnerRectangle.x = innerRectangleIndentionToOuterEffectSprite;
			this._InnerRectangle.y = innerRectangleIndentionToOuterEffectSprite;
			// Размеры внутреннего прямоугольника:
			// стороны внутреннего прямоугольника равны соответствующим сторонам
			// внешнего спрайта с эффектом за вычетом удвоенных отступов:
			// по ширине - отступы справа и слева,
			// по высоте - отступы сверху и снизу.
			this._InnerRectangle.width  = this._OuterEffectSprite.width  -
				innerRectangleDoubleIndentionToOuterEffectSprite;
			this._InnerRectangle.height = this._OuterEffectSprite.height -
				innerRectangleDoubleIndentionToOuterEffectSprite;
				
			// Внутренний прямоугольник в системе координат экрана информации -
			// внутренний прямоугольник в системе координат
			// внешнего спрайта с эффектом с поправкой на координаты
			// внешнего спрайта с эффектом в системе координат экрана информации.
			this._InnerRectangleInThisCoordinateSpace    =
				this._InnerRectangle.clone( );
			this._InnerRectangleInThisCoordinateSpace.x +=
				this._OuterEffectSprite.x;
			this._InnerRectangleInThisCoordinateSpace.y +=
				this._OuterEffectSprite.y;
		} // InitializeInnerRectangle
		
		// Метод инициализации прямоугольника изображений.
		private function InitializeImagesRectangle( ): void
		{
			// Вызов метода класса.
			this._MainTracer.CallClassMethod( InformationScreen.CLASS_NAME,
				"InitializeImagesRectangle" );			
			
			// Прямоугольник изображений не добавляется
			// на внешний спрайт с эффектом, он нужен для хранения его параметров.
			
			// Координаты прямоугольника изображений -
			// левый верхний угол внутреннего прямоугольника.
			this._ImagesRectangle.x      = this._InnerRectangle.x;
			this._ImagesRectangle.y      = this._InnerRectangle.y;
			// Ширина прямоугольника изображений:
			// произведение ширины внутреннего прямоугольника
			// на коэффициент отношения ширины прямоугольника изображений
			// к ширине внутреннего прямоугольника.
			this._ImagesRectangle.width  = this._InnerRectangle.width *
				InformationScreen.ImagesRectangleWidthToInnerRectangleWidthRatio;
			// Высота прямоугольника изображений -
			// высота внутреннего прямоугольника.
			this._ImagesRectangle.height = this._InnerRectangle.height;
		} // InitializeImagesRectangle		
		
		// Метод инициализации прямоугольника текстов.
		private function InitializeTextsRectangle( ): void
		{
			// Вызов метода класса.
			this._MainTracer.CallClassMethod( InformationScreen.CLASS_NAME,
				"InitializeTextsRectangle" );			
			
			// Прямоугольник изображений покрывает левую часть
			// внутреннего прямоугольника, прямоугольник текстов - правую,
			// между ними проходит свободная полоса, по ширине равная величине
			// отступа внутреннего прямоугольника от краёв внешнего прямоугльника.
			
			// Прямоугольник текстов не добавляется
			// на внешний спрайт с эффектом, он нужен для хранения его параметров.
			
			// Левая сторона прямоугольника текстов находится на расстоянии
			// от правой стороны прямоугольника изображений, равном величине 
			// отступа внутреннего прямоугольника
			// от краёв внешнего прямоугльника без бордюра.
			this._TextsRectangle.left   = this._ImagesRectangle.right +
				this._InnerRectangleIndention;
			// Верхняя сторона прямоугольника текстов
			// лежит на верхней стороне внутреннего прямоугольника.				
			this._TextsRectangle.top    = this._InnerRectangle.top;
			// Ширина прямоугольника текстов:
			// разность ширины внутреннего прямоугольника,
			// ширины прямоугольника изображений и величины
			// отступа внутреннего прямоугольника
			// от краёв внешнего прямоугльника без бордюра.
			this._TextsRectangle.width  = this._InnerRectangle.width -
				this._ImagesRectangle.width - this._InnerRectangleIndention;
			// Высота прямоугольника текстов - высота внутреннего прямоугольника.
			this._TextsRectangle.height = this._InnerRectangle.height;			
		} // InitializeTextsRectangle
		
		// Метод инициализации прямоугольника изображения диска.
		private function InitializeDiskImageRectangle( ): void
		{
			// Вызов метода класса.
			this._MainTracer.CallClassMethod( InformationScreen.CLASS_NAME,
				"InitializeDiskImageRectangle" );			
			
			// Ширина прямоугольника изображения диска -
			// ширины прямоугольника изображений.
			var diskImageRectangleWidth: Number  = this._ImagesRectangle.width;			
			// Высота прямоугольника изображения диска:
			// произведение высоты прямоугольника изображения
			// и коэффициента отношения высоты прямоугольника изображения диска
			// к высоте прямоугольника изображений.
			var diskImageRectangleHeight: Number = this._ImagesRectangle.height *
				InformationScreen.
				DiskImageRectangleHeightToImagesRectangleHeightRatio;
			// Коэффициент отношения ширины прямоугольника изображения диска
			// к высоте: частное ширины и высоты прямоугольника изображения диска.
			this._DiskImageRectangleWidthToHeightRatio =
				diskImageRectangleWidth / diskImageRectangleHeight;
			
			// Создание прямоугольника изображения диска.
			this._DiskImageRectangle = new ImageSprite
				( this._DiskImageRectangleWidthToHeightRatio,
				new FilePathInformation( this._DiskInformation.PathString ) );
				
			// Прямоугольник изображения диска не добавляется
			// на внешний спрайт с эффектом, он нужен для хранения его параметров
			// и проекции перспективы изображения диска.
			
			// Координаты прямоугольника изображения диска -
			// левый верхний угол прямоугольника изображений.
			this._DiskImageRectangle.x      = this._ImagesRectangle.x;
			this._DiskImageRectangle.y      = this._ImagesRectangle.y;
			// Ширина прямоугольника изображения диска.
			this._DiskImageRectangle.width  = diskImageRectangleWidth;			
			// Высота прямоугольника изображения диска.
			this._DiskImageRectangle.height = diskImageRectangleHeight;
			// Границы прямоугольника изображения диска
			// в системе координат экрана информации
			// (должно быть в системе координат внешнего спрайта с эффектом,
			// но это почему-то не работает, и DistortedImage рисуется,
			// похоже, в глобальных координатах сцены).
			this._DiskImageRectangleBounds  =
				this._DiskImageRectangle.getBounds( this/*._OuterEffectSprite*/ );

			// Загрузка изображения на прямоугольник изображения диска из файла.
			this._DiskImageRectangle.LoadImage( this._DiskInformation.PathString );
			// Регистрирация объекта-прослушивателя события успешной загрузки
			// изображения на спрайт изображения - прямоугольник изображения диска.
			this._DiskImageRectangle.addEventListener
				( ImageSpriteEvent.IMAGE_SPRITE_IMAGE_LOADING_COMPLETE,
				this.DiskImageRectangleImageLoadingFinishedListener );
			// Регистрирация объекта-прослушивателя события
			// возникновения ошибки при загрузке изображения
			// на спрайт изображения - прямоугольник изображения диска.
			this._DiskImageRectangle.addEventListener
				( ImageSpriteEvent.IMAGE_SPRITE_IMAGE_LOADING_IO_ERROR,
				this.DiskImageRectangleImageLoadingFinishedListener );
		} // InitializeDiskImageRectangle
		
		// Метод инициализации границ проекции перспективы изображения диска.
		private function InitializeDiskImagePerspectiveProjectionBounds( ): void
		{
			// Вызов метода класса.
			this._MainTracer.CallClassMethod( InformationScreen.CLASS_NAME,
				"InitializeDiskImagePerspectiveProjectionBounds" );	
			
			// Границы проекции перспективы изображения диска находятся посередине
			// внутри границ прямоугольника изображения диска.
			
			// Прямоугольник границ проекции перспективы изображения диска
			// не добавляется на внешний спрайт с эффектом,
			// он нужен для хранения его параметров.
			
			// Ширина границ проекции перспективы изображения диска:
			// произведение ширины границ прямоугольника изображения диска
			// и коэффициента отношения ширины границ проекции перспективы
			// изображения диска и ширины границ прямоугольника изображения диска.
			this._DiskImagePerspectiveProjectionBounds.width  =
				this._DiskImageRectangleBounds.width * InformationScreen.
				DiskImagePerspectiveProjBndsWidthToDiskImageRectBndsWidthRatio;
			// Абсцисса границ проекции перспективы изображения диска:
			// сумма абсциссы границ прямоугольника изображения диска
			// и половины разности ширины границ прямоугольника изображения диска
			// и ширины границ проекции перспективы изображения диска.				
			this._DiskImagePerspectiveProjectionBounds.x      =
				this._DiskImageRectangleBounds.x                    +
				( this._DiskImageRectangleBounds.width              -
				this._DiskImagePerspectiveProjectionBounds.width )  / 2;	
			// Высота границ проекции перспективы изображения диска:
			// произведение высоты границ прямоугольника изображения диска
			// и коэффициента отношения высоты границ проекции перспективы
			// изображения диска и высоты границ прямоугольника изображения диска.
			this._DiskImagePerspectiveProjectionBounds.height =
				this._DiskImageRectangleBounds.height * InformationScreen.
				DiskImagePerspectiveProjBndsHeightToDiskImageRectBndsHeightTRatio;
			// Ордината границ проекции перспективы изображения диска:
			// сумма ординаты границ прямоугольника изображения диска
			// и половины разности высоты границ прямоугольника изображения диска
			// и высоты границ проекции перспективы изображения диска.
			this._DiskImagePerspectiveProjectionBounds.y      =
				this._DiskImageRectangleBounds.y                    +
				( this._DiskImageRectangleBounds.height             -
				this._DiskImagePerspectiveProjectionBounds.height ) / 2;	
		} // InitializeDiskImagePerspectiveProjectionBounds
		
		// Метод инициализации спрайта с эффектом
		// проекции перспективы изображения диска.
		private function
			InitializeDiskImagePerspectiveProjectionEffectSprite( ): void
		{
			// Вызов метода класса.
			this._MainTracer.CallClassMethod( InformationScreen.CLASS_NAME,
				"InitializeDiskImagePerspectiveProjectionEffectSprite" );
			
			// Создание спрайта с эффектом проекции перспективы изображения диска
			// с границами проекции перспективы изображения диска.
			this._DiskImagePerspectiveProjectionEffectSprite =
				new AppearingWithIncreaseSprite
				( this._DiskImagePerspectiveProjectionBounds,
				InformationScreen.ProjectionEffectTime, InformationScreen.
				ProjectionEffectShowingVelocityToHidingVelocityRatio );
			// Добавление спрайта с эффектом проекции перспективы изображения диска
			// на внешний спрайт с эффектом.
			this._OuterEffectSprite.addChild
				( this._DiskImagePerspectiveProjectionEffectSprite );
		} // InitializeDiskImagePerspectiveProjectionEffectSprite		
		
		// Метод инициализации проекции перспективы изображения диска.
		private function InitializeDiskImagePerspectiveProjection( ): void	
		{
			// Вызов метода класса.
			this._MainTracer.CallClassMethod( InformationScreen.CLASS_NAME,
				"InitializeDiskImagePerspectiveProjection" );
			
			// В этом методе прямоугольник изображения диска был заменён
			// на границы проекции перспективы изображения диска:
			// вместо this._DiskImageRectangleBounds применяется
			// this._DiskImagePerspectiveProjectionBounds.
			// Поскольку проекции перспективы изображения диска
			// принадлежат спрайту с эффектом проекции перспективы
			// изображения диска, то используется bounds - рабочая область
			// спрайта с эффектом проекции перспективы изображения диска
			// вместо this._DiskImagePerspectiveProjectionBounds.
			
			// Границы - рабочая область спрайта с эффектом проекции перспективы
			// изображения диска - его границы в его собственной системе координат.
			var bounds: Rectangle =
				this._DiskImagePerspectiveProjectionEffectSprite.getBounds
				( this._DiskImagePerspectiveProjectionEffectSprite );
			
			// Проекции перспективы лицевой поверхности и боковины
			// изображения диска покрывают прямоугольник изображения диска
			// и имеют общую вертикальную грань.
			// Общая грань двух этих проекций параллельна вертикальным сторонам
			// прямоугольника изображения диска, а вершины
			// четырёхугольных проекций, принадлежащие ей,
			// лежат на горизонтальных сторонах прямоугольника изображения диска.			
			// Слева лежит проекция перспективы боковины изображения диска,
			// а справа - проекция перспективы лицевой поверхности
			// изображения диска.
			
			// Левые вершины проекции перспективы боковины изображения диска
			// лежат на левой грани прямоугольника изображения диска.
			
			// Абсцисса левого верхнего угла проекции перспективы боковины
			// изображения диска - абсцисса левой грани прямоугольника
			// изображения диска.
			this._DiskImageSidewallPerspectiveProjectionCornersCoordinates.
				LeftTopCornerX    = bounds.left;
			// Абсцисса левого нижнего угла проекции перспективы боковины
			// изображения диска - абсцисса левой грани прямоугольника
			// изображения диска.				
			this._DiskImageSidewallPerspectiveProjectionCornersCoordinates.
				LeftBottomCornerX = bounds.left;
			
			// Правые вершины проекции перспективы лицевой поверхности
			// изображения диска лежат на правой грани прямоугольника
			// изображения диска.
			
			// Абсцисса правого верхнего угла проекции перспективы
			// лицевой поверхности изображения диска - абсцисса правой грани
			// прямоугольника изображения диска.
			this._DiskImageFrontSurfacePerspectiveProjectionCornersCoordinates.
				RightTopCornerX    = bounds.right;
			// Абсцисса правого нижнего угла проекции перспективы
			// лицевой поверхности изображения диска - абсцисса правой грани
			// прямоугольника изображения диска.
			this._DiskImageFrontSurfacePerspectiveProjectionCornersCoordinates.
				RightBottomCornerX = bounds.right;	
				
			// Правые вершины проекции перспективы боковины изображения диска
			// лежат на горизонтальных гранях прямоугольника изображения диска
			// и совпадают с соответствующими левыми вершинами проекции перспективы
			// лицевой поверхности изображения диска.
			
			// Ордината правого верхнего угла проекции перспективы боковины
			// изображения диска - ордината верхней грани прямоугольника
			// изображения диска.
			this._DiskImageSidewallPerspectiveProjectionCornersCoordinates.
				RightTopCornerY    = bounds.top;
			// Ордината правого нижнего угла проекции перспективы боковины
			// изображения диска - ордината нижней грани прямоугольника
			// изображения диска.
			this._DiskImageSidewallPerspectiveProjectionCornersCoordinates.
				RightBottomCornerY = bounds.bottom;	
			// Ордината левого верхнего угла проекции перспективы
			// лицевой поверхности изображения диска - ордината верхней грани
			// прямоугольника изображения диска.
			this._DiskImageFrontSurfacePerspectiveProjectionCornersCoordinates.
				LeftTopCornerY     = bounds.top;
			// Ордината левого нижнего угла проекции перспективы
			// лицевой поверхности изображения диска - ордината нижней грани
			// прямоугольника изображения диска.
			this._DiskImageFrontSurfacePerspectiveProjectionCornersCoordinates.
				LeftBottomCornerY  = bounds.bottom;
				
			// Ширина проекции перспективы боковины изображения диска:
			// произведение ширины прямоугольника изображения диска
			// и коэффициента отношения ширины проекции перспективы боковины
			// изображения диска к ширине прямоугольника изображения диска.
			var diskImageSidewallPerspectiveProjectionWidth: Number     =
				bounds.width * InformationScreen.
				DiskImageSidewallPerspectiveProjWidthToDiskImageRectWidth;
			// Ширина проекции перспективы лицевой поверхности изображения диска:
			// разность ширины прямоугольника изображения диска
			// и ширины проекции перспективы боковины изображения диска.
			var diskImageFrontSurfacePerspectiveProjectionWidth: Number =
				bounds.width - diskImageSidewallPerspectiveProjectionWidth;
				
			// Правые вершины проекции перспективы боковины изображения диска,
			// совпадающие с соответствующими левыми вершинами проекции перспективы
			// лицевой поверхности изображения диска, лежат на общей грани
			// проекций перспектив, параллельной вертикальным граням прямоугольника
			// изображения диска, которая находится на расстоянии, равном
			// ширине проекции перспективы боковины изображения диска,
			// от левой грани прямоугольника изображения диска.

			// Абсцисса правого верхнего угла проекции перспективы боковины
			// изображения диска:
			// сумма абсциссы левой грани прямоугольника изображения диска
			// и ширины проекции перспективы боковины изображения диска.
			this._DiskImageSidewallPerspectiveProjectionCornersCoordinates.
				RightTopCornerX    = bounds.left +
				diskImageSidewallPerspectiveProjectionWidth;
			// Абсцисса правого нижнего угла проекции перспективы боковины
			// изображения диска.
			this._DiskImageSidewallPerspectiveProjectionCornersCoordinates.
				RightBottomCornerX =
				this._DiskImageSidewallPerspectiveProjectionCornersCoordinates.
				RightTopCornerX;
			// Абсцисса левого верхнего угла проекции перспективы
			// лицевой поверхности изображения диска.
			this._DiskImageFrontSurfacePerspectiveProjectionCornersCoordinates.
				LeftTopCornerX     =
				this._DiskImageSidewallPerspectiveProjectionCornersCoordinates.
				RightTopCornerX;
			// Абсцисса левого нижнего угла проекции перспективы
			// лицевой поверхности изображения диска.
			this._DiskImageFrontSurfacePerspectiveProjectionCornersCoordinates.
				LeftBottomCornerX  =
				this._DiskImageSidewallPerspectiveProjectionCornersCoordinates.
				RightTopCornerX;				
				
			// Правые вершины проекции перспективы лицевой поверхности
			// изображения диска лежат на правой грани прямоугольника
			// изображения диска и их ординаты смещены относительно
			// соответствующих ординат вершин правой грани прямоугольника
			// изображения диска за счёт того, что горизонтальные грани
			// проекции перспективы лицевой поверхности изображения диска
			// повёрнуты на заданные углы относительно оси абсцисс.
			
			// Смещение по оси ординат правой верхней вершины проекции перспективы
			// лицевой поверхности изображения диска.
			var diskImageFrontSurfaceRightTopCornerPerspectiveProjectionYOffset:
				Number = InformationScreen.GetCornerPerspectiveProjectionYOffset
				( InformationScreen.DiskImageTopPerspectiveProjectionAngle,
				diskImageFrontSurfacePerspectiveProjectionWidth );
			// Смещение по оси ординат правой нижений вершины проекции перспективы
			// лицевой поверхности изображения диска.
			var diskImageFrontSurfaceRightBottomCornerPerspectiveProjectionYOffset:
				Number = InformationScreen.GetCornerPerspectiveProjectionYOffset
				( InformationScreen.DiskImageBottomPerspectiveProjectionAngle,
				diskImageFrontSurfacePerspectiveProjectionWidth );	
			
			// Ордината правого верхнего угла проекции перспективы
			// лицевой поверхности изображения диска:
			// оридината верхней грани прямоугольника изображения диска,
			// смещённая на величину, зависещую от  угла наклона
			// проекции перспективы верхней грани изображения диска к оси абсцисс.
			this._DiskImageFrontSurfacePerspectiveProjectionCornersCoordinates.
				RightTopCornerY    = bounds.top    +
				diskImageFrontSurfaceRightTopCornerPerspectiveProjectionYOffset;
			// Ордината правого нижнего угла проекции перспективы
			// лицевой поверхности изображения диска:
			// оридината нижней грани прямоугольника изображения диска,
			// смещённая на величину, зависещую от  угла наклона
			// проекции перспективы нижней грани изображения диска к оси абсцисс.
			this._DiskImageFrontSurfacePerspectiveProjectionCornersCoordinates.
				RightBottomCornerY = bounds.bottom +
				diskImageFrontSurfaceRightBottomCornerPerspectiveProjectionYOffset;		
				
			// Пусть углы, образованные между верхними гранями проекций
			// и осью абсцисс, равны, так же, как и углы, образованные
			// между нижними гранями проекций и осью абсцисс.
			// Тогда можно сказать, что четырёхугольники проекций -
			// трапеции - подобны и отношения их соответствующих сторон равны.
			
			// Коэффициент подобия проекций перспективы изображения диска:
			// частное ширины проекции перспективы боковины изображения диска
			// и ширины проекции перспективы лицевой поверхности изображения диска.
			var diskImagePerspectiveProjectionsResemblanceRatio: Number =
				diskImageSidewallPerspectiveProjectionWidth /
				diskImageFrontSurfacePerspectiveProjectionWidth;
		
			// Ордината левого верхнего угла проекции перспективы боковины
			// изображения диска:
			// оридината верхней грани прямоугольника изображения диска
			// со смещением по оси ординат правой верхней вершины
			// проекции перспективы лицевой поверхности изображения диска,
			// взятым с коэффициентом подобия проекций перспективы
			// изображения диска.
			this._DiskImageSidewallPerspectiveProjectionCornersCoordinates.
				LeftTopCornerY    = bounds.top    +
				diskImageFrontSurfaceRightTopCornerPerspectiveProjectionYOffset    *
				diskImagePerspectiveProjectionsResemblanceRatio;
			// Ордината левого ниженго угла проекции перспективы боковины
			// изображения диска:
			// оридината ниженей грани прямоугольника изображения диска
			// со смещением по оси ординат правой нижней вершины
			// проекции перспективы лицевой поверхности изображения диска,
			// взятым с коэффициентом подобия проекций перспективы
			// изображения диска.				
			this._DiskImageSidewallPerspectiveProjectionCornersCoordinates.
				LeftBottomCornerY = bounds.bottom +
				diskImageFrontSurfaceRightBottomCornerPerspectiveProjectionYOffset *
				diskImagePerspectiveProjectionsResemblanceRatio;
		} // InitializeDiskImagePerspectiveProjection

		// Метод отображения проекции перспективы изображения диска.
		// Параметры:
		// parDiskImagePerspectiveProjection - проекция перспективы
		//   изображения диска,
		// parDiskImageRectangleProjectingRectangleWidth       - ширина
		//   проецируемой прямогольной области прямоугольника изображения диска,		
		// parDiskImagePerspectiveProjectionCornersCoordinates - координаты
		//   вершин четырёхугольника проекции перспективы изображения диска,
		// parGlowFilter                     - фильтр эффекта свечения.		
		private function DisplayDiskImagePerspectiveProjection
		(
			parDiskImagePerspectiveProjection:             DistortImage,
			parDiskImageRectangleProjectingRectangleWidth: Number,
			parDiskImagePerspectiveProjectionCornersCoordinates:
				TetragonCornersCoordinates,
			parGlowFilter:                                 GlowFilter			
		): void
		{
			// Вызов метода класса.
			this._MainTracer.CallClassMethod( InformationScreen.CLASS_NAME,
				"DisplayDiskImagePerspectiveProjection",
				parDiskImagePerspectiveProjection,
				parDiskImageRectangleProjectingRectangleWidth,
				parDiskImagePerspectiveProjectionCornersCoordinates, parGlowFilter );
		
			// Данные растрового изображения прямоугольника изображения диска
			// размеров проецируемой прямогольной области прямоугольника
			// изображения диска в масштабе спрайта изображения
			// с заливкой чёрным цветом с абсолютной прозрачностью.
			var diskImageRectangleBitmapData: BitmapData = new BitmapData
				( parDiskImageRectangleProjectingRectangleWidth,
				ImageSprite.IMAGE_MAXIMUM_HEIGHT, true, 0x0 );
				
			// Отображение прямоугольника изображения диска поверх данных
			// растровыго изображения прямоугольника изображения диска.
			diskImageRectangleBitmapData.draw
			(
				// Исходный объект - прямогольник изображения диска.
				this._DiskImageRectangle,
				// Объект Matrix, используемый для масштабирования, поворота
				// и перемещения координат растрового изображения.
				null,
				// Объект ColorTransform, используемый для настройки значений цвета
				// растрового изображения.
				null,
				// Режим наложения, который будет применен
				// к полученному растровому изображению.
				null,
				// Прямоугольник, определяющий область исходного объекта
				// для рисования, - прямоугольная область прямоугольника
				// изображения диска в масштабе спрайта изображения,
				// начиающаяся от его левой грани, которая будет проецироваться.
				new Rectangle( 0, 0, parDiskImageRectangleProjectingRectangleWidth,
					ImageSprite.IMAGE_MAXIMUM_HEIGHT )/*,
				// Признак применения сглаживания изображения.
				true*/
			); // diskImageRectangleBitmapData.draw
			
			// Применение фильтра эффекта свечения к данным
			// растрового изображения диска.
			diskImageRectangleBitmapData.applyFilter
			(
				// Данные исходного растрового изображения для применения фильтра -
				// данные растровыго изображения прямоугольника изображения диска.
				diskImageRectangleBitmapData,
				// Прямоугольник, определяющий область исходного изображения,
				// которая будет использоваться для фильтрации - прямоугольник
				// всей области данных растровыго изображения
				// прямоугольника изображения диска.
				diskImageRectangleBitmapData.rect,
				// Точка целевого изображения (текущего экземпляра BitmapData),
				// соответствующая левому верхнему углу размещения
				// исходного прямоугольника. 
				new Point( 0, 0 ),
				// Объект фильтра, используемый для выполнения фильтрации -
				// фильтр эффекта свечения.
				parGlowFilter
			); // diskImageRectangleBitmapData.applyFilter	
			
			// Создание проекции перспективы изображения диска.

			// Создание новой проекции перспективы изображения диска
			// с числом сегментов разбивки по горизонтали,
			// равным корню квадратному из ширины
			// данных растровыго изображения прямоугольника изображения диска,
			// и числом сегментов разбивки по вертикили,
			// равным корню квадратному из высоты
			// данных растровыго изображения прямоугольника изображения диска.
			parDiskImagePerspectiveProjection = new DistortImage
			(
			 	diskImageRectangleBitmapData,
				Math.sqrt( diskImageRectangleBitmapData.width ),
				Math.sqrt( diskImageRectangleBitmapData.height )
			); // new DistortImage		
			// Добавление новой проекции перспективы изображения диска
			// на спрайт с эффектом проекции перспективы изображения диска.
			this._DiskImagePerspectiveProjectionEffectSprite.addChild
				( parDiskImagePerspectiveProjection );
					
			// Отрисовка проекции перспективы изображения диска по точкам углов
			// по часовой стрелке, начиная с левого верхнего угла.
			parDiskImagePerspectiveProjection.setTransform
			(
				// Левый верхний угол.
				parDiskImagePerspectiveProjectionCornersCoordinates.LeftTopCornerX,
				parDiskImagePerspectiveProjectionCornersCoordinates.LeftTopCornerY,
				
				// Правый врхний угол.
				parDiskImagePerspectiveProjectionCornersCoordinates.RightTopCornerX,
				parDiskImagePerspectiveProjectionCornersCoordinates.RightTopCornerY,
				
				// Правый нижний угол.
				parDiskImagePerspectiveProjectionCornersCoordinates.
					RightBottomCornerX,
				parDiskImagePerspectiveProjectionCornersCoordinates.
					RightBottomCornerY,
				
				// Левый нижний угол.
				parDiskImagePerspectiveProjectionCornersCoordinates.
					LeftBottomCornerX,
				parDiskImagePerspectiveProjectionCornersCoordinates.
					LeftBottomCornerY
			); // parDiskImagePerspectiveProjection.setTransform
		} // DisplayDiskImagePerspectiveProjection
		
		// Метод отображения проекций перспективы изображения диска.
		private function DisplayDiskImagePerspectiveProjections( ): void
		{
			// Вызов метода класса.
			this._MainTracer.CallClassMethod( InformationScreen.CLASS_NAME,
				"DisplayDiskImagePerspectiveProjections" );
			
			// Если спрайт с эффектом проекции перспективы изображения диска
			// содержит потомков - проекции перспективы изображения диска,
			// то они удаляются.
			
			// Последовательный просмотр всех потомков спрайта с эффектом
			// проекции перспективы изображения диска.
			for ( var childIndex: int =
					this._DiskImagePerspectiveProjectionEffectSprite.numChildren - 1;
					childIndex >= 0; childIndex-- )
				// Удаление текущего потомка спрайта с эффектом проекции перспективы
				// изображения диска.
				this._DiskImagePerspectiveProjectionEffectSprite.removeChildAt
					( childIndex );
			
			// Отображение проекции перспективы лицевой поверхности
			// изображения диска.
			this.DisplayDiskImagePerspectiveProjection
			(
			 	// Проекция перспективы лицевой поверхности изображения диска.
				this._DiskImageFrontSurfacePerspectiveProjection,
				// Ширина проецируемой прямогольной области прямоугольника
				// изображения диска - вся его ширина в масштабе -
				// максимальная ширина спрайта изображения.
				ImageSprite.IMAGE_MAXIMUM_WIDTH,
				// Координаты вершин четырёхугольника проекции перспективы
				// лицевой поверхности изображения диска.
				this._DiskImageFrontSurfacePerspectiveProjectionCornersCoordinates,
				// Фильтр эффекта свечения.
				new GlowFilter
				(
					// Цвет свечения в шестнадцатеричном формате 0xRRGGBB -
					// cветлый цвет шрифта текстовой метки особой светящейся кнопки.
					this._MainTextParameters.SpecialGlowButtonLabelFontLightColor,
					// Значение альфа-прозрачности цвета.
					InformationScreen.
						DISK_IMAGE_FRONT_SURFACE_PERSPECTIVE_PROJ_GLOW_FILTER_ALPHA,
					// Степень размытия по горизонтали.
					ImageSprite.IMAGE_MAXIMUM_WIDTH  * InformationScreen.
						DISK_IMAGE_FRONT_SURFACE_PERSPECTIVE_PROJ_GLOW_FILTER_BLUR_RATIO,
					// Степень размытия по вертикали.
					ImageSprite.IMAGE_MAXIMUM_HEIGHT * InformationScreen.
						DISK_IMAGE_FRONT_SURFACE_PERSPECTIVE_PROJ_GLOW_FILTER_BLUR_RATIO,
					// Степень вдавливания или растискивания.
					InformationScreen.
						DISK_IMAGE_FRONT_SURFACE_PERSPECTIVE_PROJ_GLOW_FILTER_STRENGTH,
					// Качество применения фильтра.
					InformationScreen.
						DISK_IMAGE_PERSPECTIVE_PROJECTION_GLOW_FILTER_QUALITY,
					// Признак того, что свечение внутреннее, а не внешнее.
					true,
					// Признак применения эффекта выбивки.
					false
				) // new GlowFilter		
			); // this.DisplayDiskImagePerspectiveProjection			
			
			// Отображение проекции перспективы боковины изображения диска.
			this.DisplayDiskImagePerspectiveProjection
			(
			 	// Проекция перспективы боковины изображения диска.
				this._DiskImageSidewallPerspectiveProjection,
				// Ширина проецируемой прямогольной области прямоугольника
				// изображения диска - единичная - будет растянута крайняя
				// левая узкая вертикальная полоса.				
				1,
				// Координаты вершин четырёхугольника проекции перспективы
				// боковины изображения диска.	
				this._DiskImageSidewallPerspectiveProjectionCornersCoordinates,
				// Фильтр эффекта свечения.
				new GlowFilter
				(
					// Цвет свечения в шестнадцатеричном формате 0xRRGGBB -
					// тёмный цвет шрифта текстовой метки особой светящейся кнопки.
					this._MainTextParameters.SpecialGlowButtonLabelFontDarkColor,
					// Значение альфа-прозрачности цвета.
					InformationScreen.
						DISK_IMAGE_SIDEWALL_PERSPECTIVE_PROJ_GLOW_FILTER_ALPHA,
					// Степень размытия по горизонтали.
					ImageSprite.IMAGE_MAXIMUM_WIDTH  * InformationScreen.
						DISK_IMAGE_SIDEWALL_PERSPECTIVE_PROJ_GLOW_FILTER_BLUR_RATIO,
					// Степень размытия по вертикали.
					ImageSprite.IMAGE_MAXIMUM_HEIGHT * InformationScreen.
						DISK_IMAGE_SIDEWALL_PERSPECTIVE_PROJ_GLOW_FILTER_BLUR_RATIO,
					// Степень вдавливания или растискивания.
					InformationScreen.
						DISK_IMAGE_SIDEWALL_PERSPECTIVE_PROJ_GLOW_FILTER_STRENGTH,
					// Качество применения фильтра.
					InformationScreen.
						DISK_IMAGE_PERSPECTIVE_PROJECTION_GLOW_FILTER_QUALITY,
					// Признак того, что свечение внутреннее, а не внешнее.
					true,
					// Признак применения эффекта выбивки.
					false
				) // new GlowFilter		
			); // this.DisplayDiskImagePerspectiveProjection			
		} // DisplayDiskImagePerspectiveProjections
		
		// Метод инициализации строки слайдов.
		private function InitializeSlidesLine( ): void	
		{
			// Вызов метода класса.
			this._MainTracer.CallClassMethod( InformationScreen.CLASS_NAME,
				"InitializeSlidesLine" );				
			
			// Строка слайдов располагается в нижней части
			// прямоугольника изображений, под прямоугольником изображения диска,
			// от которого находится на расстоянии,
			// равном величине отступа внутреннего прямоугольника
			// от краёв внешнего прямоугльника без бордюра.
			
			// Создание строки слайдов.
			this._SlidesLine = new ImagesLine
				(
					// Aбсцисса строки слайдов - абсцисса прямоугольника изображений.
					this._ImagesRectangle.x,
					// Ордината строки слайдов -
					// ордината верхней грани строки слайдов -
					// сумма ординаты нижней грани прямоугольника изображения диска
					// и величины отступа внутреннего прямоугольника
					// от краёв внешнего прямоугльника без бордюра.
					this._DiskImageRectangleBounds.bottom +
						this._InnerRectangleIndention,
					// Ширина строки слайдов - ширина прямоугольника изображений.
					this._ImagesRectangle.width,
					// Выcота строки слайдов -
					// разность высоты прямоугольника изображений,
					// высоты прямоугольника изображения диска
					// и величины отступа внутреннего прямоугольника
					// от краёв внешнего прямоугльника без бордюра.
					this._ImagesRectangle.height            -
						this._DiskImageRectangleBounds.height -
						this._InnerRectangleIndention
				); // new ImagesLine
				
			// Помещение объекта строки слайдов
			// в объект внешнего спрайта с эффектом.
			this._OuterEffectSprite.addChild( this._SlidesLine );
			
			// Большая сторона спрайта изображения строки слайдов.
			var slidesLineImageSpriteGreaterSide: Number =
				(
					this._SlidesLine.ImageSpriteWidth >=
					this._SlidesLine.ImageSpriteHeight
				) ?
					this._SlidesLine.ImageSpriteWidth :
					this._SlidesLine.ImageSpriteHeight;
					
			// Сторона пиктограммы мультимедиа-файла диска:
			// частное большей стороны спрайта изображения строки слайдов
			// и коэффициента отношения стороны пиктограммы мультимедиа-файла диска
			// к большей спрайта изображения строки слайдов.
			this._DiskMultimediaFileIconSide = slidesLineImageSpriteGreaterSide *
				InformationScreen.DiskMultimediaFileIconSideToGreaterSlideSideRatio;
		} // InitializeSlidesLine	
		
		// Метод загрузки данных - изображений, информаций и пиктограмм - 
		// строки слайдов.
		private function LoadSlidesLineData( ): void
		{
			// Вызов метода класса.
			this._MainTracer.CallClassMethod( InformationScreen.CLASS_NAME,
				"LoadSlidesLineData" );					
			
			// Если все мультимедиа-файлы были выбраны безуспешно.
			if
			(
				( this._DiskVideosFilesURLsSelector.RequestXMLResult == null ) &&
				( this._DiskAudiosFilesURLsSelector.RequestXMLResult == null ) &&
				( this._DiskFramesFilesURLsSelector.RequestXMLResult == null )
			)
				// Мультимедиа-данные строки слайдов не загружаются.
				return;
			
			// Массив URL-адресов изображений слайдов.
			var slidesImagesURLs:   Array = new Array( 0 );			
			// Массив информаций путей к файлам и типов слайдов.
			var slidesInformations: Array = new Array( 0 );			
			
			// Если URL-адреса видео-файлов диска были выбраны успешно.
			if ( this._DiskVideosFilesURLsSelector.RequestXMLResult != null )
			{
				// Массив URL-адресов	видео-файлов диска.
				var diskVideosFilesURLs:               Array =
					this._DiskVideosFilesURLsSelector.RequestArrayResult as Array;
				// Массив URL-адресов изображений слайдов видео-файлов диска -
				// массив, каждым элементом которого
				// является URL-адрес изображения диска.
				var diskVideosFilesSlidesImagesURLs:   Array =
					new Array( diskVideosFilesURLs.length );
				// Массив информаций путей к файлам и типов слайдов
				// видео-файлов диска.
				var diskVideosFilesSlidesInformations: Array =
					new Array( diskVideosFilesURLs.length );				
					
				// Заполнение элементов массивов:
				// массива URL-адресов изображений слайдов видео-файлов диска
				// и массива информаций путей к файлам и типов слайдов
				// видео-файлов диска.
				for ( var diskVideoFileIndex: uint = 0; diskVideoFileIndex <
						diskVideosFilesURLs.length; diskVideoFileIndex++ )
				{
					// URL-адрес изображения слайда видео-файла диска -
					// URL-адрес изображения диска.
					diskVideosFilesSlidesImagesURLs[ diskVideoFileIndex ] =
						this._DiskInformation.PathString;
						
					// Создание текущей информации пути к файлу и типа слайда
					// видео-файла диска.
					diskVideosFilesSlidesInformations[ diskVideoFileIndex ] =
						new SlideFilePathAndTypeInformation
						(
							// Тип слайда видео-файла диска - видео.
							SlideType.VIDEO,
							// URL-адрес текущего видео-файла диска.
							diskVideosFilesURLs[ diskVideoFileIndex ]
						); // new ImageFilePathAndCodeInformation						
				} // for
				
				// Добавление массива URL-адресов изображений слайдов
				// видео-файлов диска в массив URL-адресов изображений слайдов.
				slidesImagesURLs   = slidesImagesURLs.concat
					( diskVideosFilesSlidesImagesURLs );
				// Добавление массива информаций путей к файлам и типов слайдов
				// видео-файлов диска в массив информаций
				// путей к файлам и типов слайдов.
				slidesInformations = slidesInformations.concat
					( diskVideosFilesSlidesInformations );
			} // if
			
			// Если URL-адреса аудио-файлов диска были выбраны успешно.
			if ( this._DiskAudiosFilesURLsSelector.RequestXMLResult != null )
			{
				// Массив URL-адресов	аудио-файлов диска.
				var diskAudiosFilesURLs:               Array =
					this._DiskAudiosFilesURLsSelector.RequestArrayResult as Array;
				// Массив URL-адресов изображений слайдов аудио-файлов диска -
				// массив, каждым элементом которого
				// является URL-адрес изображения диска.
				var diskAudiosFilesSlidesImagesURLs:   Array =
					new Array( diskAudiosFilesURLs.length );
				// Массив информаций путей к файлам и типов слайдов
				// аудио-файлов диска.
				var diskAudiosFilesSlidesInformations: Array =
					new Array( diskAudiosFilesURLs.length );				
					
				// Заполнение элементов массивов:
				// массива URL-адресов изображений слайдов аудио-файлов диска
				// и массива информаций путей к файлам и типов слайдов
				// аудио-файлов диска.
				for ( var diskAudioFileIndex: uint = 0; diskAudioFileIndex <
						diskAudiosFilesURLs.length; diskAudioFileIndex++ )
				{
					// URL-адрес изображения слайда аудио-файла диска -
					// URL-адрес изображения диска.
					diskAudiosFilesSlidesImagesURLs[ diskAudioFileIndex ] =
						this._DiskInformation.PathString;
						
					// Создание текущей информации пути к файлу и типа слайда
					// аудио-файла диска.
					diskAudiosFilesSlidesInformations[ diskAudioFileIndex ] =
						new SlideFilePathAndTypeInformation
						(
							// Тип слайда аудио-файла диска - аудио.
							SlideType.AUDIO,
							// URL-адрес текущего аудио-файла диска.
							diskAudiosFilesURLs[ diskAudioFileIndex ]
						); // new ImageFilePathAndCodeInformation						
				} // for
				
				// Добавление массива URL-адресов изображений слайдов
				// аудио-файлов диска в массив URL-адресов изображений слайдов.
				slidesImagesURLs   = slidesImagesURLs.concat
					( diskAudiosFilesSlidesImagesURLs );
				// Добавление массива информаций путей к файлам и типов слайдов
				// аудио-файлов диска в массив информаций
				// путей к файлам и типов слайдов.
				slidesInformations = slidesInformations.concat
					( diskAudiosFilesSlidesInformations );
			} // if
			
			// Если URL-адреса кадров фильмов диска были выбраны успешно.
			if ( this._DiskFramesFilesURLsSelector.RequestXMLResult != null )
			{
				// Массив URL-адресов кадров фильмов диска.
				var diskFramesFilesURLs:               Array =
					this._DiskFramesFilesURLsSelector.RequestArrayResult as Array;
				// Массив информаций путей к файлам и типов слайдов
				// кадров фильмов диска.
				var diskFramesFilesSlidesInformations: Array =
					new Array( diskFramesFilesURLs.length );
				
				// Заполнение элементов массива информаций
				// путей к файлам и типов слайдов кадров фильмов диска.
				for ( var diskFrameFileIndex: uint = 0; diskFrameFileIndex <
						diskFramesFilesURLs.length; diskFrameFileIndex++ )
					// Создание текущей информации пути к файлу и типа слайда
					// кадра фильма диска.
					diskFramesFilesSlidesInformations[ diskFrameFileIndex ] =
						new SlideFilePathAndTypeInformation
						(
							// Тип слайда кадра фильма диска - кадр фильма.
							SlideType.FRAME,
							// URL-адрес текущего кадра фильма диска.
							diskFramesFilesURLs[ diskFrameFileIndex ]
						); // new ImageFilePathAndCodeInformation
						
				// Добавление массива URL-адресов кадров фильмов диска
				// в массив URL-адресов изображений слайдов.
				slidesImagesURLs   = slidesImagesURLs.concat( diskFramesFilesURLs );
				// Добавление массива информаций путей к файлам и типов слайдов
				// кадров фильмов диска в массив информаций
				// путей к файлам и типов слайдов.
				slidesInformations = slidesInformations.concat
					( diskFramesFilesSlidesInformations );
			} // if
			
			// Загрузка изображений и информаций слайдов.
			this._SlidesLine.LoadImages
			(
			 	// Коэффициент отношения ширины спрайта изображения
				// строки слайдов к высоте.
				InformationScreen.SlidesLineImageSpriteWidthToHeightRatio,
				// Массив URL-адресов изображений слайдов.
				slidesImagesURLs,
				// Массив информаций путей к файлам и типов слайдов.
				slidesInformations
			); // LoadImages			
			
			// Регистрирация объекта-прослушивателя события
			// успешной загрузки изображения на спрайт изображения строки слайдов.
			this._SlidesLine.addEventListener
				( ImageSpriteEvent.IMAGE_SPRITE_IMAGE_LOADING_COMPLETE,
				this.SlidesLineImageSpriteImageLoadindCompleteListener );		
		} // LoadSlidesLineData
		
		// Метод инициализации прямоугольника описания диска.
		private function InitializeDiskDescriptionRectangle( ): void	
		{
			// Вызов метода класса.
			this._MainTracer.CallClassMethod( InformationScreen.CLASS_NAME,
				"InitializeDiskDescriptionRectangle" );					
			
			// Прямоугольник описания диска не добавляется
			// на внешний спрайт с эффектом, он нужен для хранения его параметров.
			
			// Координаты прямоугольника описания диска -
			// левый верхний угол прямоугольника текстов.
			this._DiskDescriptionRectangle.x      = this._TextsRectangle.x;
			this._DiskDescriptionRectangle.y      = this._TextsRectangle.y;
			// Ширина прямоугольника описания диска -
			// ширина прямоугольника текстов.
			this._DiskDescriptionRectangle.width  = this._TextsRectangle.width;
			// Высота прямоугольника описания диска:
			// произведение высоты прямоугольника текстов
			// и коэффициента отношения высоты прямоугольника описания диска
			// к высоте прямоугольника текстов.
			this._DiskDescriptionRectangle.height = this._TextsRectangle.height *
				InformationScreen.
				DiskDescriptionRectangleHeightToTextsRectangleHeightRatio;	
		} // InitializeDiskDescriptionRectangle
		
		// Метод инициализации текстового поля описания диска.
		private function InitializeDiskDescriptionTextField( ): void	
		{
			// Вызов метода класса.
			this._MainTracer.CallClassMethod( InformationScreen.CLASS_NAME,
				"InitializeDiskDescriptionTextField" );					
		
			// Добавление текстового поля описания диска
			// на внешний спрайт с эффектом.
			this._OuterEffectSprite.addChild( this._DiskDescriptionTextField );
			
			// Координаты текстового поля описания диска -
			// левый верхний угол прямоугольника описания диска.
			this._DiskDescriptionTextField.x = this._DiskDescriptionRectangle.x;
			this._DiskDescriptionTextField.y = this._DiskDescriptionRectangle.y;
			// Ширина текстового поля описания диска:
			// произведение ширины прямоугольника описания диска
			// и разности единицы и коэффициента отношения
			// ширины полоса прокрутки описания диска
			// к ширине прямоугольника описания диска.
			this._DiskDescriptionTextField.width  =
				this._DiskDescriptionRectangle.width * ( 1 - InformationScreen.
				DiskDescrScrollBarWidthToDiskDescrRectangleWidthRatio );
			// Высота текстового поля описания диска -
			// высота прямоугольника описания диска.
			this._DiskDescriptionTextField.height =
				this._DiskDescriptionRectangle.height;
				
			// Признак выполнения автоматической прокрутки
			// многострочного текстового поля описания диска,
			// когда пользователь щелкает по нему нему мышью
			// и вращает её колёсико.
			this._DiskDescriptionTextField.mouseWheelEnabled = false;
			// Признак многострочности текстового поля описания диска.
			this._DiskDescriptionTextField.multiline         = true;
			// Признак наличия возможности выделения
			// текстового поля описания диска.
			this._DiskDescriptionTextField.selectable        = false;
			// Признак применения переноса по словам
			// к текстовому полю описания диска.
			this._DiskDescriptionTextField.wordWrap          = true;
			
			// Основной шрифт - не жирный.
			this._MainTextParameters.MainFontIsBold   = false;
			// Основной шрифт - не курсивный.
			this._MainTextParameters.MainFontIsItalic = false;
			
			// Размер шрифта текстового поля описания диска.
			var diskDescriptionTextFieldFontSize: uint =
				this._MainTextParameters.MainFontParameters.GetTextAreaFontSize
				(
					// Размер области текста - размер текстового поля описания диска.
					new Point
					(
					 	// Ширина текстового поля описания диска
						// без отступа справа.
						this._DiskDescriptionTextField.width -
							this._InnerRectangleIndention,
						this._DiskDescriptionTextField.height
					),
					// Коэффициент сжатия ширины строки текста - коэффициент
					// сжатия ширины строки текстового поля описания диска.
					InformationScreen.
						DiskDescriptionTextFieldLineWidthCompressionRatio,
					// Коэффициент сжатия высоты строки текста - коэффициент
					// сжатия высоты строки текстового поля описания диска.
					InformationScreen.
						DiskDescriptionTextFieldLineHeightCompressionRatio,
					// Минимальный размер шрифта.
					this._MainTextParameters.MainFontMinimumSize,
					// Количество символов в строке текста - минимальное количество
					// символов в строке текстового поля описания диска.
					InformationScreen.DiskDescriptionTextFieldLineSymbolsMinimumCount,
					// Количество строк в тексте - минимальное количество
					// строк в текстовом поле описания диска.
					InformationScreen.DiskDescriptionTextFieldLinesMinimumCount,
					// Вертикальный межстрочный интервал в тексте - вертикальный
					// межстрочный интервал в текстовом поле описания диска.
					InformationScreen.DiskDescriptionTextFieldLinesLeadingVerticalSpace
				); // GetTextAreaFontSize
				
			// Формат текста текстового поля описания диска по умолчанию,
			// применяемый ещё перед загрузкой туда текста.
			this._DiskDescriptionTextField.defaultTextFormat =
				new TextFormat
				(
					// Имя шрифта для текста в виде строки.
					this._MainTextParameters.MainFontParameters.Name,
					// Размер шрифта текстового поля описания диска.
					diskDescriptionTextFieldFontSize,
					// Основной цвет шрифта.
					this._MainTextParameters.MainFontColor,
					// Признак жирности шрифта текстового поля описания диска.
					this._MainTextParameters.MainFontParameters.IsBold,
					// Признак курсивного начертания шрифта
					// текстового поля описания диска.
					this._MainTextParameters.MainFontParameters.IsItalic,
					// Признак подчёркнутого начертания шрифта
					// текстового поля описания диска.
					false,
					// URL-адрес, на который ссылается текст с этим форматом.
					// Если url представлен пустой строкой, текст не имеет гиперссылки.
					TextParameters.EMPTY_STRNG,
					// Целевое окно, где отображается гиперссылка.
					null,
					// Выравнивание абзаца - по ширине в пределах текстового поля.
					TextFormatAlign.JUSTIFY,
					// Левое поле абзаца (в пикселах).
					0,
					// Правое поле абзаца (в пикселах) - значение, равное величине
					// отступа внутреннего прямоугольника
					// от краёв внешнего прямоугльника без бордюра.
					this._InnerRectangleIndention,
					// Целое число, указывающее отступ от левого поля
					// до первого символа в абзаце - значение, равное величине
					// отступа внутреннего прямоугольника
					// от краёв внешнего прямоугльника без бордюра.
					this._InnerRectangleIndention,
					// Число, указывающее величину вертикального интервала между строками.
					InformationScreen.DiskDescriptionTextFieldLinesLeadingVerticalSpace
				); // new TextFormat				
		} // InitializeDiskDescriptionTextField
		
		// Метод инициализации полосы прокрутки описания диска.
		private function InitializeDiskDescriptionScrollBar( ): void	
		{
			// Вызов метода класса.
			this._MainTracer.CallClassMethod( InformationScreen.CLASS_NAME,
				"InitializeDiskDescriptionScrollBar" );			
			
			// Создание полосы прокрутки описания диска. 
			this._DiskDescriptionScrollBar =
				new GlowScrollBar
				(
				 	// Цель прокрутки - текстовое поле описания диска.
					this._DiskDescriptionTextField,
					// Ширина:
					// разность ширины прямоугольника описания диска
					// и ширины текстового поля описания диска.
					this._DiskDescriptionRectangle.width -
						this._DiskDescriptionTextField.width,
					// Высота бегунка прокрутки:
					// произведение высоты дорожки прокрутки
					// полосы прокрутки описания диска -
					// высоты полосы прокрутки описания диска - 
					// высоты прямоугольника описания диска -
					// и коэффициента отношения высоты бегунка
					// полосы прокрутки описания диска к высоте её дорожки.
					this._DiskDescriptionRectangle.height * InformationScreen.
						DiskDescriptionScrollBarThumbHeightToTrackHeightRatio
				); // new GlowScrollBar
				
			// Добавление полосы прокрутки описания диска
			// на внешний спрайт с эффектом.
			this._OuterEffectSprite.addChild( this._DiskDescriptionScrollBar );
		} // InitializeDiskDescriptionScrollBar		
		
		// Метод инициализации прямоугольника таблиц.
		private function InitializeGridsRectangle( ): void	
		{
			// Вызов метода класса.
			this._MainTracer.CallClassMethod( InformationScreen.CLASS_NAME,
				"InitializeGridsRectangle" );			
			
			// Прямоугольник таблиц покрывает нижнюю часть
			// прямоугольника текстов, прямоугольник текстов - верхнюю,
			// между ними проходит свободная полоса, по ширине равная величине
			// отступа внутреннего прямоугольника от краёв внешнего прямоугльника.	
			
			// Прямоугольник таблиц не добавляется на внешний спрайт с эффектом,
			// он нужен для хранения его параметров.
			
			// Левая сторона прямоугольника таблиц лежит
			// на левой стороне прямоугольника текстов.
			this._GridsRectangle.left   = this._TextsRectangle.left;
			// Верхняя сторона прямоугольника таблиц находится на расстоянии
			// от нижней стороны прямоугольника описания диска, равном величине
			// отступа внутреннего прямоугольника
			// от краёв внешнего прямоугльника без бордюра.
			this._GridsRectangle.top    =
				this._DiskDescriptionRectangle.bottom +
				this._InnerRectangleIndention;
			// Правая сторона прямоугольника таблиц лежит
			// на правой стороне прямоугольника текстов.
			this._GridsRectangle.right  = this._TextsRectangle.right;
			// Нижняя сторона прямоугольника таблиц -
			// нижняя сторона прямоугольника текстов.
			this._GridsRectangle.bottom = this._TextsRectangle.bottom;
			
			// Ширина области названий характеристик:
			// произведение ширины прямоугольника таблиц
			// и коэффициента отношения ширины области названий характеристик
			// к ширине прямоугольника таблиц.
			this._CharacteristicsNamesAreaWidth = this._GridsRectangle.width *
				InformationScreen.
				CharacteristicsNamesAreaWidthToGridsRectangleWidthRatio;
		} // InitializeGridsRectangle		
		
		// Метод форматирования таблицы.
		// Параметры:
		// parGrid               - таблица,
		// parGridTextFontSize   - размер шрифта текста в таблице,
		// parGridTextAlign      - выравнивание текста в таблице,
		// parGridTextFontIsBold - признак жирности шрифта текста в таблице,
		// parGridRowHeight      - высота строки таблицы.
		private function FormatGrid
		(
			parGrid:               TextFieldsGrid,
			parGridTextFontSize:   Object,
			parGridTextFontIsBold: Boolean,
			parGridTextAlign:      String,			
			parGridRowHeight:      Number
		): void
		{
			// Вызов метода класса.
			this._MainTracer.CallClassMethod( InformationScreen.CLASS_NAME,
				"FormatGrid", parGrid, parGridTextFontSize, parGridTextFontIsBold,
				parGridTextAlign, parGridRowHeight );			
			
			// Основной шрифт - не курсивный.
			this._MainTextParameters.MainFontIsItalic = false;				
		
			// Данные форматирования символов таблицы.
			var gridTextFormat: TextFormat =
				new TextFormat
				(
					// Имя шрифта для текста в виде строки.
					this._MainTextParameters.MainFontParameters.Name,
					// Целое число, которое обозначает размер в пикселах.
					parGridTextFontSize,
					// Цвет текста, использующего данный формат - основной цвет шрифта.
					this._MainTextParameters.MainFontColor,
					// Логическое значение, указывающее, является ли текст полужирным.
					parGridTextFontIsBold,
					// Признак курсивного начертания шрифта.
					this._MainTextParameters.MainFontParameters.IsItalic,					
					// Признак подчёркнутого начертания шрифта.
					false,
					// URL-адрес, на который ссылается текст с этим форматом.
					// Если url представлен пустой строкой, текст не имеет гиперссылки.
					TextParameters.EMPTY_STRNG,
					// Целевое окно, где отображается гиперссылка.
					null,
					// Выравнивание абзаца.
					parGridTextAlign,
					// Левое поле абзаца (в пикселах).
					0,
					// Правое поле абзаца (в пикселах).
					0,
					// Целое число, указывающее отступ от левого поля
					// до первого символа в абзаце.
					0,
					// Число, указывающее величину вертикального интервала между строками.
					0
				); // new TextFormat				
			
			// Свойства сетки текстовых полей.
			var gridProperties: TextFieldsGridProperties =
				new TextFieldsGridProperties( );				
			// Формат текста столбцов по умолчанию.
			gridProperties.ColumnsDefaultTextFormat = gridTextFormat;
			// Высота строки.
			gridProperties.RowHeight                = parGridRowHeight;
			// Признак многострочности текстовыйх полей столбцов.
			gridProperties.ColumnsAreMultiline      = true;
			// Признак применения переноса по словам к текстовым полям столбцов.
			gridProperties.ColumnsHaveWordWrap      = true;
			// Признак наличия возможности выборра текстовыйх полей столбцов.
			gridProperties.ColumnsAreSelectable     = false;
			// Признак выполнения автоматической прокрути
			// многострочных текстовых полей столбцов при вращении колёски мыши.
			gridProperties.ColumnsMouseWheelEnabled = false;	
			
			// Установка свойств таблицы.
			parGrid.SetProperties( gridProperties );
		} // FormatGrid		
		
		// Метод инициализации таблицы примечаний.
		private function InitializeNotesGrid( ): void
		{
			// Вызов метода класса.
			this._MainTracer.CallClassMethod( InformationScreen.CLASS_NAME,
				"InitializeNotesGrid" );			
			
			// Создание таблицы примечаний.
			this._NotesGrid =
				new TextFieldsGrid	
				(
					// Прямоугольная область таблицы примечаний.
					new Rectangle
					(
						// Абсцисса - абсцисса прямоугольника таблиц.
						this._GridsRectangle.x,
						// Ордината - ордината прямоугольника таблиц.
						this._GridsRectangle.y,
						// Ширина - ширина прямоугольника таблиц.
						this._GridsRectangle.width,
						// Высота:
						// произведение высоты прямоугольника таблиц
						// и коэффициента отношения высоты таблицы примечаний
						// к высоте прямоугольника таблиц.
						this._GridsRectangle.height * InformationScreen.
							NotesGridHeightToGridsRectangleHeightRatio
					) // new Rectangle
				); // new TextFieldsGrid
				
			// Добавление таблицы примечаний на внешний спрайт с эффектом.
			this._OuterEffectSprite.addChild( this._NotesGrid );
			
			// Если XML-данные не содержат примечаний.			
			if
			(
			 	( this._DiskNotesSelector.RequestXMLResult == null ) ||
				( this._DiskNotesSelector.RequestXMLResult.
					children( ).length( )                    == 0    ) ||
				( this._DiskNotesSelector.RequestXMLResult.Row.
					children( ).length( )                    == 0    ) ||
				( this._DiskNotesSelector.RequestXMLResult.Row[ 0 ].
					children( ).length( )                    == 0 )		
			)
				// Тексты ячеек таблицы примечаний не загружаются.
				return;		
				
			// Массив примечаний.
			var notes: Array = this._DiskNotesSelector.RequestArrayResult;				
			// Количество столбцов таблицы примечаний.
			var notesGridColumnsCount = notes.length;				
			// Ширина столбца таблицы примечаний:
			// частное ширины таблицы примечаний и её количества столбцов.
			var notesGridColumnWidth  = this._NotesGrid.width /
				notesGridColumnsCount;					
				
			// Максимальная длина примечания.
			var noteMaximumLength = 0;
			// Индекс примечания.
			var noteIndex: uint;			
			
			// Последовательный просмотр примечаний.
			for ( noteIndex = 0; noteIndex < notesGridColumnsCount; noteIndex++ )
			{
				// Длина текущего примечания.
				var noteLength = notes[ noteIndex ].toString( ).length;
				// Если длина текущего примечания
				// превышает максимальную длину примечания.
				if ( noteLength > noteMaximumLength )
					// Максимальная длина примечания - длина текущего примечания.
					noteMaximumLength = noteLength;
			} // for
			
			// Основной шрифт - не жирный.
			this._MainTextParameters.MainFontIsBold   = false;
			// Основной шрифт - не курсивный.
			this._MainTextParameters.MainFontIsItalic = false;				
				
			// Размер шрифта текста в таблице примечаний.
			var notesGridFontSize: uint =
				this._MainTextParameters.MainFontParameters.GetTextAreaFontSize
				(
					// Размер области текста - размер ячейки таблицы примечаний.
					new Point( notesGridColumnWidth, this._NotesGrid.height ),
					// Коэффициент сжатия ширины строки текста -
					// коэффициент сжатия ширины текста ячейки таблицы примечаний.
					InformationScreen.NotesGridCellTextWidthCompressionRatio,
					// Коэффициент сжатия высоты строки текста -
					// коэффициент сжатия высоты текста ячейки таблицы примечаний.
					InformationScreen.NotesGridCellTextHeightCompressionRatio,	
					// Минимальный размер шрифта.
					this._MainTextParameters.MainFontMinimumSize,
					// Количество символов в строке текста -
					// максимальная длина примечания.
					noteMaximumLength
				); // GetTextAreaFontSize			
				
			// Форматирование таблицы примечаний.
			this.FormatGrid
			(
			 	// Таблица примечаний.
				this._NotesGrid,
				// Размер шрифта текста в таблице примечаний.
				notesGridFontSize,
				// Признак жирности шрифта текста в таблицепримечаний.
				this._MainTextParameters.MainFontParameters.IsBold,		
				// Выравнивание текста в таблице примечаний - по центру.
				TextFormatAlign.CENTER,
				// Высота строки таблицы примечаний - в данном случае единственной -
				// высота таблицы примечаний.
				this._NotesGrid.height
			); // FormatGrid	
			
			// Просмотр столбцов таблицы примечаний.
			for ( noteIndex = 0; noteIndex < notesGridColumnsCount;
					noteIndex++ )
				// Добавление столбца примечания в конец массива столбцов
				// таблицы примечаний.
				this._NotesGrid.AddColumn( this._DiskNotesSelector.RequestXMLResult.
					Row[ 0 ].children( )[ noteIndex ].name( ).toString( ),
					notesGridColumnWidth );
					
			// Загрузка текстов ячеек таблицы примечаний из XML-данных.
			this._NotesGrid.LoadCellsTextsFromXML
				( this._DiskNotesSelector.RequestXMLResult );
		} // InitializeNotesTextFieldsGrid 
		
		// Метод инициализации прямоугольника кнопок выбора.
		private function InitializeChoiceButtonsRectangle( ): void
		{
			// Вызов метода класса.
			this._MainTracer.CallClassMethod( InformationScreen.CLASS_NAME,
				"InitializeChoiceButtonsRectangle" );			
			
			// Прямоугольник кнопок выбора располагается поверх
			// прямоугольника таблиц, находясь на расстоянии от его левой стороны,
			// равном ширине области названий характеристик,			
			// под таблицей примечаний, между ними проходит свободная полоса,
			// по ширине равная величине половины отступа
			// внутреннего прямоугольника от краёв внешнего прямоугльника.	
			
			// Прямоугольник кнопок выбора не добавляется
			// на внешний спрайт с эффектом, он нужен для хранения его параметров.
			
			// Абсцисса прямоугольника кнопок выбора:
			// сумма абсциссы прямоугольника таблиц
			// и ширины бласти названий характеристик.
			this._ChoiceButtonsRectangle.x      = this._GridsRectangle.x +
				this._CharacteristicsNamesAreaWidth;
			// Ордината прямоугольника кнопок выбора:
			// сумма ординаты и высоты таблицы примечаний
			// и половины отступа внутреннего прямоугольника
			// от краёв внешнего прямоугльника без бордюра.
			this._ChoiceButtonsRectangle.y      = this._NotesGrid.y +
				this._NotesGrid.height + this._InnerRectangleIndention / 2;
			// Ширина прямоугольника кнопок выбора:
			// разность ширины прямоугольника таблиц
			// и ширины бласти названий характеристик.
			this._ChoiceButtonsRectangle.width  = this._GridsRectangle.width -
				this._CharacteristicsNamesAreaWidth;
			// Высота прямоугольника кнопок выбора:
			// произведение высоты прямоугольника таблиц
			// и коэффициента отношения высоты прямоугольника кнопок выбора
			// к высоте прямоугольника таблиц.
			this._ChoiceButtonsRectangle.height = this._GridsRectangle.height *
				InformationScreen.
				ChoiceButtonsRectangleHeightToGridsRectangleHeightRatio;
		} // InitializeChoiceButtonsRectangle
		
		// Метод инициализации таблицы стоимостей.
		private function InitializeCostsGrid( ): void
		{
			// Вызов метода класса.
			this._MainTracer.CallClassMethod( InformationScreen.CLASS_NAME,
				"InitializeCostsGrid" );			
			
			// Таблицы стоимостей располагается поверх прямоугольника таблиц,
			// находясь на расстоянии от его левой стороны,
			// равном ширине области названий характеристик,			
			// под прямоугольником кнопок выбора, между ними проходит
			// свободная полоса, по ширине равная величине половины отступа
			// внутреннего прямоугольника от краёв внешнего прямоугльника.
			
			// Создание таблицы стоимостей.
			this._CostsGrid =
				new TextFieldsGrid
				(
					// Прямоугольная область таблицы стоимостей.
					new Rectangle
					(
						// Абсцисса - абсцисса прямоугольника кнопок выбора.
						this._ChoiceButtonsRectangle.x,
						// Ордината:
						// сумма ординаты нижней стороны прямоугольника кнопок выбора
						// и половины отступа внутреннего прямоугольника
						// от краёв внешнего прямоугльника без бордюра.
						this._ChoiceButtonsRectangle.bottom +
							this._InnerRectangleIndention / 2,
						// Ширина - ширина прямоугольника кнопок выбора.
						this._ChoiceButtonsRectangle.width,
						// Высота:
						// произведение высоты прямоугольника таблиц
						// и коэффициента отношения высоты таблицы стоимостей
						// к высоте прямоугольника таблиц.
						this._GridsRectangle.height * InformationScreen.
							CostsGridHeightToGridsRectangleHeightRatio
					) // Rectangle
				); // new TextFieldsGrid			
			
			// Добавление таблицы стоимостей на внешний спрайт с эффектом.
			this._OuterEffectSprite.addChild( this._CostsGrid );
			
			// Если XML-данные не содержат цен разновидностей дисков.			
			if
			(
				( this._DiskVarietiesCostsSelector.RequestXMLResult == null ) ||
				( this._DiskVarietiesCostsSelector.RequestXMLResult.
					children( ).length( )                             == 0    ) ||
				( this._DiskVarietiesCostsSelector.RequestXMLResult.Row.
					children( ).length( )                             == 0    ) ||
				( this._DiskVarietiesCostsSelector.RequestXMLResult.Row[ 0 ].
					children( ).length( )                             == 0    )		
			)
			{
				// Ширина области категории диска - ширина таблицы стоимостей.
				this._DiskCategoryAreaWidth = this._CostsGrid.width;					
				// Тексты ячеек таблицы цен разновидностей дисков не загружаются.
				return;	
			} // if
			
			// Массив стоимостей.
			var costs: Array = this._DiskVarietiesCostsSelector.RequestArrayResult;				
			// Количество категорий диска -
			// количество столбцов таблицы стоимостей.
			this._DiskCategoriesCount   = costs.length;		
			// Ширина области категории диска -
			// ширина столбца таблицы стоимостей:
			// частное ширины таблицы стоимостей и её количества столбцов -
			// количества категорий диска.
			this._DiskCategoryAreaWidth = this._CostsGrid.width /
				this._DiskCategoriesCount;
				
			// Максимальная длина стоимости.
			var costMaximumLength = 0;
			// Индекс стоимости.
			var costIndex: uint;			
			
			// Последовательный просмотр стоимостей.
			for ( costIndex = 0; costIndex < this._DiskCategoriesCount;
				costIndex++ )
			{
				// Длина текущей стоимости.
				var costLength = costs[ costIndex ].toString( ).length;
				// Если длина текущей стоимости
				// превышает максимальную длину стоимости.
				if ( costLength > costMaximumLength )
					// Максимальная длина стоимости - длина текущей стоимости.
					costMaximumLength = costLength;
			} // for
			
			// Основной шрифт - жирный.
			this._MainTextParameters.MainFontIsBold   = true;
			// Основной шрифт - не курсивный.
			this._MainTextParameters.MainFontIsItalic = false;				
			
			// Размер шрифта текста в таблице стоимостей.
			var сostsGridFontSize: uint =
				this._MainTextParameters.MainFontParameters.GetTextAreaFontSize
				(
					// Размер области текста - размер ячейки таблицы стоимостей.
					new Point( this._DiskCategoryAreaWidth, this._CostsGrid.height ),
					// Коэффициент сжатия ширины строки текста -
					// коэффициент сжатия ширины текста ячейки таблицы стоимостей.
					InformationScreen.CostsGridCellTextWidthCompressionRatio,
					// Коэффициент сжатия высоты строки текста -
					// коэффициент сжатия высоты текста ячейки таблицы стоимостей.
					InformationScreen.CostsGridCellTextHeightCompressionRatio,
					// Минимальный размер шрифта.
					this._MainTextParameters.MainFontMinimumSize,
					// Количество символов в строке текста -
					// максимальная длина стоимости.
					costMaximumLength
				); // GetTextAreaFontSize
				
			// Форматирование таблицы стоимостей.
			this.FormatGrid
			(
			 	// Таблица стоимостей.
				this._CostsGrid,
				// Размер шрифта текста в таблице стоимостей.
				сostsGridFontSize,				
				// Признак жирности шрифта текста в таблицестоимостей .
				this._MainTextParameters.MainFontParameters.IsBold,
				// Выравнивание текста в таблице стоимостей - по центру.
				TextFormatAlign.CENTER,
				// Высота строки таблицы стоимостей - в данном случае единственной -
				// высота таблицы стоимостей.
				this._CostsGrid.height
			); // FormatGrid	
			
			// Просмотр столбцов таблицы стоимостей.
			for ( costIndex = 0; costIndex < this._DiskCategoriesCount;
					costIndex++ )
				// Добавление столбца стоимости в конец массива столбцов
				// таблицы стоимостей.
				this._CostsGrid.AddColumn( this._DiskVarietiesCostsSelector.
					RequestXMLResult.Row[ 0 ].children( )[ costIndex ].
					name( ).toString( ), this._DiskCategoryAreaWidth );
					
			// Загрузка текстов ячеек таблицы стоимостей из XML-данных.
			this._CostsGrid.LoadCellsTextsFromXML
				( this._DiskVarietiesCostsSelector.RequestXMLResult );
		} // InitializeCostsGrid	
		
		// Метод инициализации таблицы характеристик.
		private function InitializeCharacteristicsGrid( ): void
		{
			// Вызов метода класса.
			this._MainTracer.CallClassMethod( InformationScreen.CLASS_NAME,
				"InitializeCharacteristicsGrid" );			
			
			// Таблицы характеристик занимает нижнюю часть
			// прямоугольника таблиц и находится под таблицей стоимостей.
			
			// Создание таблицы характеристик.
			this._CharacteristicsGrid =
				new TextFieldsGrid
				(
					// Прямоугольная область таблицы характеристик.
					new Rectangle
					(
						// Абсцисса - абсцисса прямоугольника таблиц.
						this._GridsRectangle.x,
						// Ордината:
						// сумма ординаты таблицы стоимостей и её высоты.
						this._CostsGrid.y + this._CostsGrid.height,
						// Ширина - ширина прямоугольника таблиц.
						this._GridsRectangle.width,
						// Высота:
						// разность высоты прямоугольника таблиц,
						// высоты таблицы примечаний,
						// высоты прямоугольника кнопок выбора, высоты таблицы стоимостей
						// и отступа внутреннего прямоугольника
						// от краёв внешнего прямоугльника без бордюра.
						this._GridsRectangle.height           -
							this._NotesGrid.height              -
							this._ChoiceButtonsRectangle.height -
							this._CostsGrid.height    -
							this._InnerRectangleIndention
					) // new Rectangle
				); // new TextFieldsGrid			
			
			// Добавление таблицы характеристик на внешний спрайт с эффектом.
			this._OuterEffectSprite.addChild( this._CharacteristicsGrid );
			
			// Если XML-данные не содержат характеристик разновидностей дисков.			
			if
			(
			 	( this._DiskVarietiesCharacteristicsSelector.RequestXMLResult
				 	                      == null ) ||
				( this._DiskVarietiesCharacteristicsSelector.RequestXMLResult.
					children( ).length( ) == 0    ) ||
				( this._DiskVarietiesCharacteristicsSelector.RequestXMLResult.Row.
					children( ).length( ) == 0    )
			)
				// Тексты ячеек таблицы характеристик разновидностей дисков
				// не загружаются.
				return;
				
			// Количество столбцов таблицы характеристик.
			var characteristicsGridColumnsCount: uint =
				this._DiskVarietiesCharacteristicsSelector.RequestXMLResult.
				Row[ 0 ].children( ).length( );			
			// Количество категорий диска -
			// количество столбцов категорий диска в таблице характеристик,
			// число которых меньше количества всех столбцов таблицы характеристик
			// на единицу, так как один столбец таблицы характеристик - первый -
			// столбец назания характеристики.			
			this._DiskCategoriesCount   = characteristicsGridColumnsCount - 1;				
			// Ширина области категории диска -
			// ширина столбца категории диска таблицы характеристик:
			// частное разности ширины таблицы характеристик
			// и ширины области названий характеристик
			// и количества столбцов категорий диска таблицы характеристик.
			this._DiskCategoryAreaWidth = ( this._CharacteristicsGrid.width -
				this._CharacteristicsNamesAreaWidth ) / this._DiskCategoriesCount;	
			
			// Массив характеристик разновидностей диска.
			var characteristics:                Array  =
				this._DiskVarietiesCharacteristicsSelector.RequestArrayResult;			
			// Ширина символа таблицы характеристик:
			// произведение ширины таблицы характеристик и коэффициента отношения
			// ширины символа таблицы характеристик к ширине таблицы характеристик.
			var characteristicsGridSymbolWidth: Number =
				this._CharacteristicsGrid.width *
				InformationScreen.CharacteristicsGridSymbolWidthToWidthRatio;
			// Минимальное количество символов в строке ячейки столбца
			// назания характеристики таблицы характеристик:
			// частное ширины столбца назания характеристики таблицы характеристик
			// и ширины символа таблицы характеристик.
			var characteristicsNamesColumnCellTextSymbolsMinimumCount: uint =
				Math.floor( this._CharacteristicsNamesAreaWidth /
				characteristicsGridSymbolWidth );
			// Минимальное количество символов в строке ячейки столбца
			// категорий диска таблицы характеристик:
			// частное ширины столбца категорий диска таблицы характеристик
			// и ширины символа таблицы характеристик.
			var diskCategoriesColumnCellTextSymbolsMinimumCount:       uint =
				Math.floor( this._DiskCategoryAreaWidth         /
				characteristicsGridSymbolWidth );			
				
			// Максимальная длина наименования характеристики диска.
			var characteristicNameMaximumLength         = 0;			
			// Максимальная длина характеристики категории диска.
			var diskCategoryCharacteristicMaximumLength = 0;
			// Индекс наименования характеристики диска.
			var characteristicNameIndex: uint;			
			// Индекс категории диска.
			var diskCategoryIndex:       uint;				
			
			// Просмотр строк наименований характеристик диска.
			for ( characteristicNameIndex = 0; characteristicNameIndex <
				characteristics.length; characteristicNameIndex++ )
			{
				// Длина текущего наименования характеристики диска.
				var characteristicNameLength =
					characteristics[ characteristicNameIndex ][ 0 ].toString( ).length;
				// Если длина текущего наименования характеристики диска
				// превышает максимальную длину наименования характеристики диска.
				if ( characteristicNameLength > characteristicNameMaximumLength )
					// Максимальная длина наименования характеристики диска -
					// длина текущего аименования характеристики диска.
					characteristicNameMaximumLength = characteristicNameLength;
					
				// Просмотр столбцов категорий диска.
				for ( diskCategoryIndex = 1; diskCategoryIndex <
						characteristicsGridColumnsCount; diskCategoryIndex++ )
				{
					// Длина текущей характеристики текущей категории диска.
					var diskCategoryСharacteristicLength = characteristics
						[ characteristicNameIndex ][ diskCategoryIndex ].
						toString( ).length;
					// Если длина текущей характеристики текущей категории диска
					// превышает максимальную длину характеристики категории диска.
					if ( diskCategoryСharacteristicLength >
							diskCategoryCharacteristicMaximumLength )
						// Максимальная длина характеристики категории диска -
						// длина текущей характеристики текущей категории диска.
						diskCategoryCharacteristicMaximumLength =
							diskCategoryСharacteristicLength;
				} // for				
			} // for
					
			// Высота строки в таблице характеристик:
			// частное высоты таблицы характеристики количества её строк.
			var characteristicsGridRowHeight: Number =
				this._CharacteristicsGrid.height / characteristics.length;				
			// Максимальное количество строк текста в ячейке столбца
			// назания характеристики таблицы характеристик:
			// частное максимальной длины наименования характеристики диска
			// и минимального количества символов в строке ячейки столбца
			// назания характеристики таблицы характеристик.
			var characteristicsNamesColumnCellTextRowsMinimumCount: uint =
				Math.ceil( characteristicNameMaximumLength /
				characteristicsNamesColumnCellTextSymbolsMinimumCount );
			// Максимальное количество строк текста в ячейке столбца
			// категорий диска таблицы характеристик:
			// частное максимальной длины характеристики категории диска
			// и минимального количества символов в строке ячейки столбца
			// категорий диска таблицы характеристик.
			var diskCategoriesColumnCellTextRowsMinimumCount:       uint =
				Math.ceil( diskCategoryCharacteristicMaximumLength /
				diskCategoriesColumnCellTextSymbolsMinimumCount );
				
			// Основной шрифт - жирный.
			this._MainTextParameters.MainFontIsBold   = true;
			// Основной шрифт - не курсивный.
			this._MainTextParameters.MainFontIsItalic = false;
			
			// Размер шрифта текста в столбце назания характеристики
			// таблицы характеристик.
			var characteristicsNamesColumnFontSize: uint =
				this._MainTextParameters.MainFontParameters.GetTextAreaFontSize
				(
					// Размер области текста - размер ячейки столбца
					// назания характеристики таблицы характеристик.
					new Point( this._CharacteristicsNamesAreaWidth,
						characteristicsGridRowHeight ),
					// Коэффициент сжатия ширины строки текста -
					// коэффициент сжатия ширины текста ячейки
					// столбца назаний характеристик таблицы характеристик.
					InformationScreen.
						CharacteristicsGridNamesColumnCellTextWidthCompressionRatio,
					// Коэффициент сжатия высоты строки текста -
					// коэффициент сжатия высоты текста ячейки
					// столбца назаний характеристик таблицы характеристик.
					InformationScreen.
						CharacteristicsGridNamesColumnCellTextHeightCompressionRatio,					
					// Минимальный размер шрифта.
					this._MainTextParameters.MainFontMinimumSize,
					// Количество символов в строке текста -
					// максимальная длина наименования характеристики диска.
					characteristicNameMaximumLength,
					// Количество строк в тексте - максимальное количество
					// строк текста в ячейке столбца назания характеристики
					// таблицы характеристик.
					characteristicsNamesColumnCellTextRowsMinimumCount,
					// Вертикальный межстрочный интервал в тексте - вертикальный
					// межстрочный интервал в текстовом поле описания диска.
					0					
				); // GetTextAreaFontSize
				
			// Основной шрифт - не жирный.
			this._MainTextParameters.MainFontIsBold   = false;
			// Основной шрифт - не курсивный.
			this._MainTextParameters.MainFontIsItalic = false;
			
			// Размер шрифта текста в столбце категорий диска
			// таблицы характеристик.
			var diskCategoriesColumnFontSize: uint =
				this._MainTextParameters.MainFontParameters.GetTextAreaFontSize
				(
					// Размер области текста - размер ячейки столбца категорий диска
					// таблицы характеристик.
					new Point( this._DiskCategoryAreaWidth,
						characteristicsGridRowHeight ),
					// Коэффициент сжатия ширины строки текста -
					// коэффициент сжатия ширины текста ячейки
					// столбца категорий диска таблицы характеристик.
					InformationScreen.
						CharacteristicsGridCategoriesColumnCellTextWidthCompressionRatio,
					// Коэффициент сжатия высоты строки текста -
					// коэффициент сжатия высоты текста ячейки
					// столбца категорий диска таблицы характеристик.
					InformationScreen.
				CharacteristicsGridCategoriesColumnCellTextHeightCompressionRatio,					
					// Минимальный размер шрифта.
					this._MainTextParameters.MainFontMinimumSize,
					// Количество символов в строке текста -
					// максимальная длина характеристики категории диска.
					diskCategoryCharacteristicMaximumLength,
					// Количество строк в тексте - максимальное количество
					// строк текста в ячейке столбца категорий диска
					// таблицы характеристик.
					diskCategoriesColumnCellTextRowsMinimumCount,
					// Вертикальный межстрочный интервал в тексте - вертикальный
					// межстрочный интервал в текстовом поле описания диска.
					0					
				); // GetTextAreaFontSize
				
			// Размер нежирного шрифта текста в столбце категорий диска
			// для хорошего восприятия должен быть больше на 1 пункт
			// размера жирного шрифта текста в столбце назания характеристики,
			// если размеры этих шрафтов не равны между собой.
				
			// Если размер шрифта текста в столбце категорий диска
			// превышает размер шрифта текста в столбце назания характеристики.
			if ( diskCategoriesColumnFontSize >
					characteristicsNamesColumnFontSize )
				// Размер шрифта текста в столбце категорий диска изменяется.
				diskCategoriesColumnFontSize =
					characteristicsNamesColumnFontSize + 1;
					
			// Если размер шрифта текста в столбце назания характеристики
			// превышает размер шрифта текста в столбце категорий диска.					
			if ( diskCategoriesColumnFontSize <
					characteristicsNamesColumnFontSize )
				// Размер шрифта текста в столбце назания характеристики изменяется.
				characteristicsNamesColumnFontSize =
					diskCategoriesColumnFontSize - 1;
				
			// Форматирование таблицы характеристик.
			this.FormatGrid
			(
			 	// Таблица характеристик.
				this._CharacteristicsGrid,
				// Размер шрифта текста в таблице характеристик -
				// размер шрифта текста в столбце категорий диска.
				diskCategoriesColumnFontSize,			
				// Признак жирности шрифта текста в таблице характеристик.
				false,				
				// Выравнивание текста в таблице характеристик - по левому краю.
				TextFormatAlign.LEFT,
				// Высота строки таблицы характеристик.
				characteristicsGridRowHeight
			); // FormatGrid		
			
			// Добавление столбца назания характеристики в конец массива столбцов
			// таблицы характеристик.
			this._CharacteristicsGrid.AddColumn
			(
				// Название столбца назания характеристики в таблице характеристик.
				this._DiskVarietiesCharacteristicsSelector.RequestXMLResult.
					Row[ 0 ].children( )[ 0 ].name( ).toString( ),
				// Ширина столбца назания характеристики в таблице характеристик -
				// ширина области названий характеристик.
				this._CharacteristicsNamesAreaWidth
			); // this._CharacteristicsGrid.AddColumn
				
			// Столбец назания характеристики в таблице характеристик.
			var characteristicsNamesColumn: TextFieldsColumn =
				this._CharacteristicsGrid.GetColumnByIndex( 0 );
			// Формат текста по умолчанию для столбца назания характеристики
			// в таблице характеристик.
			var characteristicsNamesColumnDefaultTextFormat: TextFormat =
				characteristicsNamesColumn.CellsDefaultTextFormat;
			// Установка размера текста в формате текста по умолчанию
			// для столбца назания характеристики в таблице характеристик.
			characteristicsNamesColumnDefaultTextFormat.size =
				characteristicsNamesColumnFontSize;				
			// Установка жирного шрифта в формате текста по умолчанию
			// для столбца назания характеристики в таблице характеристик.
			characteristicsNamesColumnDefaultTextFormat.bold = true;
			// Запись формата текста по умолчанию для столбца
			// назания характеристики в таблице характеристик.
			characteristicsNamesColumn.CellsDefaultTextFormat =
				characteristicsNamesColumnDefaultTextFormat;
			
			// Просмотр столбцов категорий диска таблицы характеристик.
			for ( diskCategoryIndex = 1; diskCategoryIndex <
					characteristicsGridColumnsCount; diskCategoryIndex++ )
				// Добавление столбца категории диска в конец массива столбцов
				// таблицы характеристик.
				this._CharacteristicsGrid.AddColumn
					( this._DiskVarietiesCharacteristicsSelector.RequestXMLResult.
					Row[ 0 ].children( )[ diskCategoryIndex ].name( ).toString( ),
					this._DiskCategoryAreaWidth );		
					
			// Загрузка текстов ячеек таблицы характеристик из XML-данных.
			this._CharacteristicsGrid.LoadCellsTextsFromXML
				( this._DiskVarietiesCharacteristicsSelector.RequestXMLResult );				
		} // InitializeCharacteristicsGrid	
		
		// Метод инициализации кнопок выбора.
		private function InitializeChoiceButtons( ): void
		{
			// Вызов метода класса.
			this._MainTracer.CallClassMethod( InformationScreen.CLASS_NAME,
				"InitializeChoiceButtons" );			
			
			// Создание кнопок выбора, количество которых равно
			// количеству категорий диска.
			this._ChoiceButtons = new Array( this._DiskCategoriesCount );
			
			// Ширина кнопки выбора - ширина области категории диска.
			var choiceButtonWidth:  Number = this._DiskCategoryAreaWidth;
			// Высота кнопки выбора - высота прямоугольника кнопок выбора.
			var choiceButtonHeight: Number = this._ChoiceButtonsRectangle.height;			
			
			// Максимальная ширина кнопки выбора:
			// произведение ширины прямоугольника кнопок выбора
			// и коэффициента отношения максимальной ширины кнопки выбора
			// к ширине прямоугольника кнопок выбора.
			var choiceButtonMaximumWidth:        Number =
				this._ChoiceButtonsRectangle.width * InformationScreen.
				ChoiceButtonMaximumWidthToChoiceButtonsRectangleWidthRatio;			
			// Горизонтальный отступ кнопки выбора
			// от вертикального края её области - нулевой.
			var choiceButtonHorizontalIndention: Number = 0;
			
			// Если ширина кнопки выбора превышает максимальную.
			if ( choiceButtonWidth > choiceButtonMaximumWidth )
			{
				// Ширина кнопки выбора - максимальная.
				choiceButtonWidth               = choiceButtonMaximumWidth;
				// Горизонтальный отступ кнопки выбора
				// от вертикального края её области:
				// половина разности ширины области категории диска
				// и максимальной ширины кнопки выбора.
				choiceButtonHorizontalIndention =
					( this._DiskCategoryAreaWidth - choiceButtonWidth ) / 2;
			} // if

			// Длина текста текстовой метки кнопки выбора
			// с символами-отступами текстовой метки светящейся кнопки.
			var choiceButtonLabelLength: Number =
				InformationScreen.ChoiceButtonLabel.length +
				this._MainTextParameters.GlowButtonLabelIndentionSymbolsCount;
				
			// Основной шрифт - жирный.
			this._MainTextParameters.MainFontIsBold   = true;
			// Основной шрифт - не курсивный.
			this._MainTextParameters.MainFontIsItalic = false;
				
			// Размер шрифта текстовой метки кнопки выбора.
			var choiceButtonLabelFontSize: uint =
				this._MainTextParameters.MainFontParameters.GetTextAreaFontSize
				(
					// Размер области текста - размер кнопки выбора.
					new Point( choiceButtonWidth, choiceButtonHeight ),
					// Коэффициент сжатия ширины строки текста -
					// коэффициент сжатия ширины текстовой метки светящейся кнопки.
					this._MainTextParameters.GlowButtonLabelWidthCompressionRatio,
					// Коэффициент сжатия высоты строки текста -
					// коэффициент сжатия высоты текстовой метки светящейся кнопки.
					this._MainTextParameters.GlowButtonLabelHeightCompressionRatio,	
					// Минимальный размер шрифта.
					this._MainTextParameters.MainFontMinimumSize,
					// Количество символов в строке текста -
					// длина текста текстовой метки кнопки выбора.
					choiceButtonLabelLength			
				); // GetTextAreaFontSize
				
			// Массив данных продаж разновидностей дисков.
			var diskVarietiesSalesData: Array = null;	
			// Если XML-данные выборщика данных продаж разновидностей дисков
			// из таблиц MySQL содержат данные продаж разновидностей дисков.			
			if
			(
				( this._DiskVarietiesSalesDataSelector.RequestXMLResult != null ) ||
				( this._DiskVarietiesSalesDataSelector.RequestXMLResult.
					children( ).length( )                                 != 0    )
			)
				// Заполнение массива данных продаж разновидностей дисков.
				diskVarietiesSalesData =
					this._DiskVarietiesSalesDataSelector.RequestArrayResult;
					
			// Параметры кнопки выбора.
			var choiceButtonParameters: GlowButtonParameters =
				new GlowButtonParameters( );
			// Имя шрифта текстовой метки.
			choiceButtonParameters.LabelFontName        =
				this._MainTextParameters.MainFontParameters.Name;
			// Размер шрифта текстовой метки.
			choiceButtonParameters.LabelFontSize = choiceButtonLabelFontSize;
			// Светлый цвет шрифта текстовой метки особой светящейся кнопки.
			choiceButtonParameters.LabelFontLightColor  =
				this._MainTextParameters.SpecialGlowButtonLabelFontLightColor;
			// Тёмный цвет шрифта текстовой метки особой светящейся кнопки.
			choiceButtonParameters.LabelFontDarkColor   =
				this._MainTextParameters.SpecialGlowButtonLabelFontDarkColor;
			// Признак жирности шрифта текстовой метки.
			choiceButtonParameters.LabelFontIsBold      =
				this._MainTextParameters.MainFontParameters.IsBold;
			// Признак курсивного нечертания шрифта текстовой метки.
			choiceButtonParameters.LabelFontIsItalic    =
				this._MainTextParameters.MainFontParameters.IsItalic;
			// Признак подчёркнутого нечертания шрифта текстовой метки.
			choiceButtonParameters.LabelFontIsUnderline = false;
			// Цвет свечения особой светящейся кнопки.
			choiceButtonParameters.GlowColor            =
				this._MainTextParameters.SpecialGlowButtonGlowColor;
					
			// Размещение кнопок выбора на экране информации.
			for ( var сhoiceButtonIndex = 0; сhoiceButtonIndex <
					this._DiskCategoriesCount; сhoiceButtonIndex++ )
				// Если стоимость диска текущей категории неположительна.
				if ( Number ( this._CostsGrid.GetColumnByIndex( сhoiceButtonIndex ).
						GetCell( 0 ).text ) <= 0 )
					// Кнопка выбора не создаётся,
					// чтобы диск не был приобретён по ошибке за бесценок.
					this._ChoiceButtons[ сhoiceButtonIndex ] = null;
					
				// Если стоимость диска текущей категории положительна.
				else
				{
					// Создание кнопки выбора.
					this._ChoiceButtons[ сhoiceButtonIndex ] =
						new GlowButton( choiceButtonParameters );
					// Добавление кнопки выбора на внешний спрайт с эффектом.
					this._OuterEffectSprite.addChild
						( this._ChoiceButtons[ сhoiceButtonIndex ] );				
				
					// Текстовая метка для кнопки выбора.
					this._ChoiceButtons[ сhoiceButtonIndex ].label  =
						InformationScreen.ChoiceButtonLabel;
					// Ширина кнопки выбора.
					this._ChoiceButtons[ сhoiceButtonIndex ].width  =
						choiceButtonWidth;
					// Высота кнопки выбора.
					this._ChoiceButtons[ сhoiceButtonIndex ].height =
						choiceButtonHeight;
					// Абсцисса кнопки выбора:
					// сумма абсциссы прямоугольника кнопок выбора,
					// горизонтального отступа кнопки выбора
					// от вертикального края её области
					// и произведения ширины области категории диска
					// и индекса кнопки выбора.
					this._ChoiceButtons[ сhoiceButtonIndex ].x      =
						this._ChoiceButtonsRectangle.x  +
						choiceButtonHorizontalIndention +
						this._DiskCategoryAreaWidth     *
						сhoiceButtonIndex;
					// Ордината кнопки выбора - ордината прямоугольника кнопок выбора.
					this._ChoiceButtons[ сhoiceButtonIndex ].y      =
						this._ChoiceButtonsRectangle.y;
					// Немедленная отрисовка кнопки выбора - это необходимо,
					// чтобы надпись не уползала вверх при появлении кнопки,
					// что почему-то иногда происходит.
					this._ChoiceButtons[ сhoiceButtonIndex ].drawNow( );
						
					// Если массив данных продаж разновидностей дисков не пуст.
					if ( diskVarietiesSalesData != null )
						// Запись текущих данных продажи текущей разновидности диска
						// в словарь по ключу, являющемуся текущей кнопкой выбора.
						this._DiskVarietiesSalesDataDictionary
							[ this._ChoiceButtons[ сhoiceButtonIndex ] ] =
							diskVarietiesSalesData[ сhoiceButtonIndex ];
	
					// Регистрирация объекта-прослушивателя события
					// клика мыши на кнопке выбора.
					this._ChoiceButtons[ сhoiceButtonIndex ].addEventListener
						( MouseEvent.CLICK, this.ChoiceButtonClickListener );
				} // else
		} // InitializeChoiceButtons
		
		// Метод инициализации кнопки выхода.
		private function InitializeExitButton( ): void
		{
			// Вызов метода класса.
			this._MainTracer.CallClassMethod( InformationScreen.CLASS_NAME,
				"InitializeExitButton" );			
			
			// Параметры кнопки выхода.
			var exitButtonParameters: GlowButtonParameters =
				new GlowButtonParameters( );
			// Цвет свечения в шестнадцатеричном формате 0xRRGGBB.
			exitButtonParameters.GlowColor            =
				this._MainTextParameters.GlowButtonGlowColor;
					
			// Создание кнопки выхода.
			this._ExitButton = new ExitGlowButton( InformationScreen.
				ExitButtonIconSideToExitButtonSameSideMaximumRatio,
				exitButtonParameters );
			// Добавление кнопки выхода на внешний спрайт с эффектом.
			this._OuterEffectSprite.addChild( this._ExitButton );	
			
			// Ширина кнопки выхода - ширины области названий характеристик.
			this._ExitButton.width  = this._CharacteristicsNamesAreaWidth;
			// Высота кнопки выхода:
			// сумма высоты прямоугольника кнопок выбора и высоты
			// таблицы стоимостей, уменьшенная на полтора отступа внутреннего
			// прямоугольника от краёв внешнего прямоугльника без бордюра.
			this._ExitButton.height = this._ChoiceButtonsRectangle.height +
				this._CostsGrid.height - 1.5 * this._InnerRectangleIndention;
			// Абсцисса кнопки выхода - абсцисса прямоугольника таблиц.
			this._ExitButton.x      = this._GridsRectangle.x;
			// Ордината кнопки выхода - ордината прямоугольника кнопок выбора.
			this._ExitButton.y      = this._ChoiceButtonsRectangle.y;
		} // InitializeExitButton		
		
		// Показ внешнего спрайта эффекта.
		public function ShowOuterEffectSprite( ): void
		{
			// Вызов метода класса.
			this._MainTracer.CallClassMethod( InformationScreen.CLASS_NAME,
				"ShowOuterEffectSprite" );			

			// Установка параметров эффекта изменения видимости
			// внешнего спрайта с эффектом.
			this._OuterEffectSprite.GetEffectParameters( );
			// Показ внешнего спрайта с эффектом.
			this._OuterEffectSprite.Show( );			
			// Добавление внешнего спрайта с эффектом на экран информации.
			this.addChild( this._OuterEffectSprite );			
			// Регистрирация объекта-прослушивателя события завершения
			// эффекта появления внешнего спрайта с эффектом.
			this._OuterEffectSprite.addEventListener
				( AppearingWithIncreaseSprite.SHOWING_EFFECT_EXECUTING_FINISHED,
				this.OuterEffectSpriteShowingEffectExecutingFinishedListener );
		} // ShowOuterEffectSprite		
		
		// Методы PHP-запросчиков.
		
		// Метод инициализации выборщика URL-адресов видео-файлов диска.
		private function InitializeDiskVideosFilesURLsSelector( ): void
		{
			// Вызов метода класса.
			this._MainTracer.CallClassMethod( InformationScreen.CLASS_NAME,
				"InitializeDiskVideosFilesURLsSelector" );			
			
			// Выборщик URL-адресов видео-файлов диска.
			this._DiskVideosFilesURLsSelector = new DiskSlidesFilesURLsSelector
				(
					this._MySQLDatabaseParameters.
						GetWarehouseDiskSlidesFilesURLsSelectorRequestPHPFileURL
						( this._MySQLDatabaseParameters.DisksVideosFilesWarehouse ),
					this._MainTracer
				); // new DiskSlidesFilesURLsSelector
				
			// URL-адрес компьютера-хранилища.
			this._DiskVideosFilesURLsSelector.WarehouseURL                 =
				this._MySQLDatabaseParameters.GetWarehouseURL
				( this._MySQLDatabaseParameters.DisksVideosFilesWarehouse );
			// Путь к директорию, хранящему документы на компьютере-хранилище.
			this._DiskVideosFilesURLsSelector.WarehouseDocumentRoot        =
				this._MySQLDatabaseParameters.GetWarehouseDocumentRoot
				( this._MySQLDatabaseParameters.DisksVideosFilesWarehouse );
			// Путь к директорию, харанящему файлы слайдов диска.
			this._DiskVideosFilesURLsSelector.DiskSlidesFilesDirectoryPath =
				this._MySQLDatabaseParameters.DisksVideosFilesDirectoryPath;
		
			// Значение артикула диска.
			this._DiskVideosFilesURLsSelector.DiskArticleValue       =
				this._DiskInformation.Article;
			// Аффикс имени файла слайда диска.
			this._DiskVideosFilesURLsSelector.DiskSlideFileNameAffix =
				this._MySQLDatabaseParameters.DiskVideoFileNameAffix;
			// Расширение файла слайда диска.
			this._DiskVideosFilesURLsSelector.DiskSlideFileExtension =
				this._MySQLDatabaseParameters.DiskVideoFileExtension;
			
			// Заголовок файла слайда диска.
			this._DiskVideosFilesURLsSelector.DiskSlideFileCaption =
				MySQLParameters.DISK_SLIDE_FILE_CAPTION;				
				
			// Загрузка XML-результата при выполнении запроса
			// для получения URL-адресов видео-файлов диска.
			this._DiskVideosFilesURLsSelector.LoadRequest( );
			// Регистрирация объекта-прослушивателя события успешной загрузки
			// XML-результата при выполнении запроса
			// для получения URL-адресов видео-файлов диска.
			this._DiskVideosFilesURLsSelector.addEventListener
				( PHPRequester.REQUEST_LOADING_COMPLETE,
				this.DiskVideosFilesURLsRequestXMLResultLoadingFinishedListener );
			// Регистрирация объекта-прослушивателя события возникновения ошибки
			// при выполнении запроса для получения URL-адресов видео-файлов диска.
			this._DiskVideosFilesURLsSelector.addEventListener
				( PHPRequester.REQUEST_LOADING_IO_ERROR,
				this.DiskVideosFilesURLsRequestXMLResultLoadingFinishedListener );
		} // InitializeDiskVideosFilesURLsSelector		
		
		// Метод инициализации выборщика URL-адресов аудио-файлов диска.
		private function InitializeDiskAudiosFilesURLsSelector( ): void	
		{
			// Вызов метода класса.
			this._MainTracer.CallClassMethod( InformationScreen.CLASS_NAME,
				"InitializeDiskAudiosFilesURLsSelector" );			
			
			// Выборщик URL-адресов аудио-файлов диска.
			this._DiskAudiosFilesURLsSelector = new DiskSlidesFilesURLsSelector
				(
					this._MySQLDatabaseParameters.
						GetWarehouseDiskSlidesFilesURLsSelectorRequestPHPFileURL
						( this._MySQLDatabaseParameters.DisksAudiosFilesWarehouse ),
					this._MainTracer
				); // new DiskSlidesFilesURLsSelector				
				
			// URL-адрес компьютера-хранилища.
			this._DiskAudiosFilesURLsSelector.WarehouseURL                 =
				this._MySQLDatabaseParameters.GetWarehouseURL
				( this._MySQLDatabaseParameters.DisksAudiosFilesWarehouse );
			// Путь к директорию, хранящему документы на компьютере-хранилище.
			this._DiskAudiosFilesURLsSelector.WarehouseDocumentRoot        =
				this._MySQLDatabaseParameters.GetWarehouseDocumentRoot
				( this._MySQLDatabaseParameters.DisksAudiosFilesWarehouse );
			// Путь к директорию, харанящему файлы слайдов диска.
			this._DiskAudiosFilesURLsSelector.DiskSlidesFilesDirectoryPath =
				this._MySQLDatabaseParameters.DisksAudiosFilesDirectoryPath;
		
			// Значение артикула диска.
			this._DiskAudiosFilesURLsSelector.DiskArticleValue       =
				this._DiskInformation.Article;
			// Аффикс имени файла слайда диска.
			this._DiskAudiosFilesURLsSelector.DiskSlideFileNameAffix =
				this._MySQLDatabaseParameters.DiskAudioFileNameAffix;
			// Расширение файла слайда диска.
			this._DiskAudiosFilesURLsSelector.DiskSlideFileExtension =
				this._MySQLDatabaseParameters.DiskAudioFileExtension;
			
			// Заголовок файла слайда диска.
			this._DiskAudiosFilesURLsSelector.DiskSlideFileCaption =
				MySQLParameters.DISK_SLIDE_FILE_CAPTION;				
				
			// Загрузка XML-результата при выполнении запроса
			// для получения URL-адресов аудио-файлов диска.
			this._DiskAudiosFilesURLsSelector.LoadRequest( );
			// Регистрирация объекта-прослушивателя события успешной загрузки
			// XML-результата при выполнении запроса
			// для получения URL-адресов аудио-файлов диска.
			this._DiskAudiosFilesURLsSelector.addEventListener
				( PHPRequester.REQUEST_LOADING_COMPLETE,
				this.DiskAudiosFilesURLsRequestXMLResultLoadingFinishedListener );
			// Регистрирация объекта-прослушивателя события возникновения ошибки
			// при выполнении запроса для получения URL-адресов аудио-файлов диска.
			this._DiskAudiosFilesURLsSelector.addEventListener
				( PHPRequester.REQUEST_LOADING_IO_ERROR,
				this.DiskAudiosFilesURLsRequestXMLResultLoadingFinishedListener );
		} // InitializeDiskAudiosFilesURLsSelector		
		
		// Метод инициализации выборщика URL-адресов кадров фильмов диска.
		private function InitializeDiskFramesFilesURLsSelector( ): void
		{
			// Вызов метода класса.
			this._MainTracer.CallClassMethod( InformationScreen.CLASS_NAME,
				"InitializeDiskFramesFilesURLsSelector" );			
			
			// Выборщик URL-адресов кадров фильмов диска.
			this._DiskFramesFilesURLsSelector = new DiskSlidesFilesURLsSelector
				(
					this._MySQLDatabaseParameters.
						GetWarehouseDiskSlidesFilesURLsSelectorRequestPHPFileURL
						( this._MySQLDatabaseParameters.DisksFramesFilesWarehouse ),
					this._MainTracer
				); // new DiskSlidesFilesURLsSelector				
				
			// URL-адрес компьютера-хранилища.
			this._DiskFramesFilesURLsSelector.WarehouseURL                 =
				this._MySQLDatabaseParameters.GetWarehouseURL
				( this._MySQLDatabaseParameters.DisksFramesFilesWarehouse );
			// Путь к директорию, хранящему документы на компьютере-хранилище.
			this._DiskFramesFilesURLsSelector.WarehouseDocumentRoot        =
				this._MySQLDatabaseParameters.GetWarehouseDocumentRoot
				( this._MySQLDatabaseParameters.DisksFramesFilesWarehouse );
			// Путь к директорию, харанящему файлы слайдов диска.
			this._DiskFramesFilesURLsSelector.DiskSlidesFilesDirectoryPath =
				this._MySQLDatabaseParameters.DisksFramesFilesDirectoryPath;
				
			// Значение артикула диска.
			this._DiskFramesFilesURLsSelector.DiskArticleValue       =
				this._DiskInformation.Article;
			// Аффикс имени файла слайда диска.
			this._DiskFramesFilesURLsSelector.DiskSlideFileNameAffix =
				this._MySQLDatabaseParameters.DiskFrameFileNameAffix;
			// Расширение файла слайда диска.
			this._DiskFramesFilesURLsSelector.DiskSlideFileExtension =
				this._MySQLDatabaseParameters.DiskFrameFileExtension;
			
			// Заголовок файла слайда диска.
			this._DiskFramesFilesURLsSelector.DiskSlideFileCaption =
				MySQLParameters.DISK_SLIDE_FILE_CAPTION;				
				
			// Загрузка XML-результата при выполнении запроса
			// для получения URL-адресов кадров фильмов диска.
			this._DiskFramesFilesURLsSelector.LoadRequest( );
			// Регистрирация объекта-прослушивателя события успешной загрузки
			// XML-результата при выполнении запроса
			// для получения URL-адресов кадров фильмов диска.
			this._DiskFramesFilesURLsSelector.addEventListener
				( PHPRequester.REQUEST_LOADING_COMPLETE,
				this.DiskFramesFilesURLsRequestXMLResultLoadingFinishedListener );
			// Регистрирация объекта-прослушивателя события возникновения ошибки
			// при выполнении запроса для получения URL-адресов
			// кадров фильмов диска.
			this._DiskFramesFilesURLsSelector.addEventListener
				( PHPRequester.REQUEST_LOADING_IO_ERROR,
				this.DiskFramesFilesURLsRequestXMLResultLoadingFinishedListener );
		} // InitializeDiskFramesFilesURLsSelector		
		
		// Метод инициализации выборщика описания диска из таблиц MySQL.
		private function InitializeDiskDescriptionSelector( ): void
		{
			// Вызов метода класса.
			this._MainTracer.CallClassMethod( InformationScreen.CLASS_NAME,
				"InitializeDiskDescriptionSelector" );			
			
			// Выборщик описания диска из таблиц MySQL.
			this._DiskDescriptionSelector =
				new MySQLDiskDescriptionSelector
				(
					this._MySQLDatabaseParameters.ConnectionAttributes,
					this._MySQLDatabaseParameters.
						DiskDescriptionSelectorRequestPHPFileURL,
					this._MainTracer
				); // new MySQLDiskDescriptionSelector
				
			// Имя таблицы номенклатур.
			this._DiskDescriptionSelector.NomenclaturesTableName              =
				this._MySQLDatabaseParameters.NomenclaturesTableName;
			// Имя столбца артикулов в таблице номенклатур.
			this._DiskDescriptionSelector.NomenclaturesArticlesColumnName     =
				this._MySQLDatabaseParameters.NomenclaturesArticlesColumnName;
			// Значение артикула изображения.
			this._DiskDescriptionSelector.ImageArticleValue                   =
				this._DiskInformation.Article;
			// Имя столбца описаний дисков в таблице номенклатур.
			this._DiskDescriptionSelector.NomenclaturesDescriptionsColumnName =
				this._MySQLDatabaseParameters.NomenclaturesDescriptionsColumnName;				
				
			// Загрузка XML-результата при выполнении запроса к базе данных MySQL
			// для получения описания диска.
			this._DiskDescriptionSelector.LoadRequest( );
			// Регистрирация объекта-прослушивателя события успешной загрузки
			// XML-результата при выполнении запроса к базе данных MySQL
			// для получения описания диска.		
			this._DiskDescriptionSelector.addEventListener
				( PHPRequester.REQUEST_LOADING_COMPLETE,
				this.DiskDescriptionRequestXMLResultLoadingFinishedListener );				
			// Регистрирация объекта-прослушивателя события возникновения ошибки
			// при выполнении запроса к базе данных MySQL
			// для получения описания диска.
			this._DiskVideosFilesURLsSelector.addEventListener
				( PHPRequester.REQUEST_LOADING_IO_ERROR,
				this.DiskDescriptionRequestXMLResultLoadingFinishedListener );
		} // InitializeDiskDescriptionSelector
		
		// Метод инициализации выборщика кода группы диска из таблиц MySQL.
		private function InitializeDiskGroupCodeSelector( ): void
		{
			// Вызов метода класса.
			this._MainTracer.CallClassMethod( InformationScreen.CLASS_NAME,
				"InitializeDiskGroupCodeSelector" );			
			
			// Выборщик кода группы диска из таблиц MySQL.
			this._DiskGroupCodeSelector =
				new MySQLDiskGroupCodeSelector
				(
					this._MySQLDatabaseParameters.ConnectionAttributes,
					this._MySQLDatabaseParameters.
						DiskGroupCodeSelectorRequestPHPFileURL,
					this._MainTracer
				); // new MySQLDiskGroupCodeSelector
				
			// Имя таблицы номенклатур.
			this._DiskGroupCodeSelector.NomenclaturesTableName             =
				this._MySQLDatabaseParameters.NomenclaturesTableName;
			// Имя столбца артикулов в таблице номенклатур.
			this._DiskGroupCodeSelector.NomenclaturesArticlesColumnName    =
				this._MySQLDatabaseParameters.NomenclaturesArticlesColumnName;
			// Значение артикула изображения.
			this._DiskGroupCodeSelector.ImageArticleValue                  =
				this._DiskInformation.Article;
			// Имя столбца кодов групп в таблице номенклатур.
			this._DiskGroupCodeSelector.NomenclaturesGroupsCodesColumnName =
				this._MySQLDatabaseParameters.NomenclaturesGroupsFlagsColumnName;
				
			// Загрузка XML-результата при выполнении запроса к базе данных MySQL
			// для получения кода группы диска.
			this._DiskGroupCodeSelector.LoadRequest( );
			// Регистрирация объекта-прослушивателя события успешной загрузки
			// XML-результата при выполнении запроса к базе данных MySQL
			// для получения кода группы диска.		
			this._DiskGroupCodeSelector.addEventListener
				( PHPRequester.REQUEST_LOADING_COMPLETE,
				this.DiskGroupCodeRequestXMLResultLoadingFinishedListener );				
			// Регистрирация объекта-прослушивателя события возникновения ошибки
			// при выполнении запроса к базе данных MySQL
			// для получения кода группы диска.	
			this._DiskGroupCodeSelector.addEventListener
				( PHPRequester.REQUEST_LOADING_IO_ERROR,
				this.DiskGroupCodeRequestXMLResultLoadingFinishedListener );	
		} // InitializeDiskGroupCodeSelector
		
		// Метод инициализации выборщика цен
		// разновидностей дисков из таблиц MySQL.
		private function InitializeDiskVarietiesCostsSelector( ): void
		{
			// Вызов метода класса.
			this._MainTracer.CallClassMethod( InformationScreen.CLASS_NAME,
				"InitializeDiskVarietiesCostsSelector" );			
			
			// Выборщик цен разновидностей дисков из таблиц MySQL.
			this._DiskVarietiesCostsSelector =
				new MySQLDiskVarietiesCostsSelector
				(
					this._MySQLDatabaseParameters.ConnectionAttributes,
					this._MySQLDatabaseParameters.
						DiskVarietiesCostsSelectorRequestPHPFileURL,
					this._MainTracer
				); // new MySQLDiskVarietiesCostsSelector	
				
			// Имя таблицы розничных товаров.
			this._DiskVarietiesCostsSelector.RetailGoodsTableName        =
				this._MySQLDatabaseParameters.RetailGoodsTableName;
			// Имя столбца идентивикаторов номенклатур в таблице розничных товаров.
			this._DiskVarietiesCostsSelector.
				RetailGoodsNomenclaturesIDsColumnName = this._MySQLDatabaseParameters.
				RetailGoodsNomenclaturesIDsColumnName;
			// Имя столбца количеств в таблице розничных товаров.
			this._DiskVarietiesCostsSelector.RetailGoodsCountsColumnName =
				this._MySQLDatabaseParameters.RetailGoodsCountsColumnName;
			// Имя столбца цен в таблице розничных товаров.
			this._DiskVarietiesCostsSelector.RetailGoodsCostsColumnName  =
				this._MySQLDatabaseParameters.RetailGoodsCostsColumnName;
		
			// Имя столбца в таблице розничных товаров, упорядочивающего цены.
			this._DiskVarietiesCostsSelector.RetailGoodsCostsOrderingColumnName =
				this._MySQLDatabaseParameters.RetailGoodsDisksVarietiesIDsColumnName;
			// Направление упорядочения цен в таблице розничных товаров.		
			this._DiskVarietiesCostsSelector.
				RetailGoodsCostsOrderingAscendantSign = this._MySQLDatabaseParameters.
				DisksVarietiesIDOrderingAscentSign;
		
			// Имя таблицы номенклатур.
			this._DiskVarietiesCostsSelector.NomenclaturesTableName          =
				this._MySQLDatabaseParameters.NomenclaturesTableName;
			// Имя столбца идентивикаторов в таблице номенклатур.
			this._DiskVarietiesCostsSelector.NomenclaturesIDsColumnName      =
				this._MySQLDatabaseParameters.NomenclaturesIDsColumnName;
			// Имя столбца артикулов в таблице номенклатур.
			this._DiskVarietiesCostsSelector.NomenclaturesArticlesColumnName =
				this._MySQLDatabaseParameters.NomenclaturesArticlesColumnName;
			// Значение артикула изображения.
			this._DiskVarietiesCostsSelector.ImageArticleValue               =
				this._DiskInformation.Article;
			
			// Имя таблицы ссылок разновидностей дисков.
			this._DiskVarietiesCostsSelector.DisksVarietiesReferencesTableName   =
				this._MySQLDatabaseParameters.DisksVarietiesReferencesTableName;
			// Имя столбца идентивикаторов номенклатур
			// в таблице ссылок разновидностей дисков.
			this._DiskVarietiesCostsSelector.
				DisksVarietiesReferencesNomenclaturesIDsColumnName                 =
				this._MySQLDatabaseParameters.
				DisksVarietiesReferencesNomenclaturesIDsColumnName;
			// Имя столбца идентивикаторов характеристик разновидностей дисков
			// в таблице ссылок разновидностей дисков.
			this._DiskVarietiesCostsSelector.
				DisksVarietiesReferencesDisksVarietiesCharacteristicsIDsColumnName =
				this._MySQLDatabaseParameters.
				DisksVarietiesReferencesDisksVarietiesCharacteristicsIDsColumnName;
			// Имя столбца в таблице ссылок разновидностей дисков,
			// упорядочивающего характеристики разновидностей дисков.
			this._DiskVarietiesCostsSelector.
				DisksVarietiesReferencesCharacteristicsOrderingColumnName          =
				this._MySQLDatabaseParameters.
				DisksVarietiesReferencesDisksVarietiesIDsColumnName;

			// Имя таблицы характеристик разновидностей дисков.
			this._DiskVarietiesCostsSelector.
				DisksVarietiesCharacteristicsTableName     =
				this._MySQLDatabaseParameters.DisksVarietiesCharacteristicsTableName;		
			// Имя столбца идентификаторов
			// в таблице характеристик разновидностей дисков.
			this._DiskVarietiesCostsSelector.
				DisksVarietiesCharacteristicsIDsColumnName =
				this._MySQLDatabaseParameters.
				DisksVarietiesCharacteristicsIDsColumnName;
				
			// Загрузка XML-результата при выполнении запроса к базе данных MySQL
			// для получения цен разновидностей дисков.
			this._DiskVarietiesCostsSelector.LoadRequest( );
			// Регистрирация объекта-прослушивателя события успешной загрузки
			// XML-результата при выполнении запроса к базе данных MySQL
			// для получения цен разновидностей дисков.
			this._DiskVarietiesCostsSelector.addEventListener
				( PHPRequester.REQUEST_LOADING_COMPLETE,
				this.DiskVarietiesCostsRequestXMLResultLoadingFinishedListener );				
			// Регистрирация объекта-прослушивателя события возникновения ошибки
			// при выполнении запроса к базе данных MySQL
			// для получения цен разновидностей дисков.
			this._DiskVarietiesCostsSelector.addEventListener
				( PHPRequester.REQUEST_LOADING_IO_ERROR,
				this.DiskVarietiesCostsRequestXMLResultLoadingFinishedListener );
		} // InitializeDiskVarietiesCostsSelector
		
		// Метод инициализации выборщика кода группы диска из таблиц MySQL.
		private function InitializeDiskVarietiesCharacteristicsSelector( ): void	
		{
			// Вызов метода класса.
			this._MainTracer.CallClassMethod( InformationScreen.CLASS_NAME,
				"InitializeDiskVarietiesCharacteristicsSelector" );			
			
			// Выборщик характеристик разновидностей дисков из таблиц MySQL.
			this._DiskVarietiesCharacteristicsSelector =
				new MySQLDiskVarietiesCharacteristicsSelector
				(
					this._MySQLDatabaseParameters.ConnectionAttributes,
					this._MySQLDatabaseParameters.
						DiskVarietiesCharacteristicsSelectorRequestPHPFileURL,
					this._MainTracer
				); // new MySQLDiskVarietiesCharacteristicsSelector	
				
			// Строка-разделитель элементов массивов.
			this._DiskVarietiesCharacteristicsSelector.ArraysSeparatorString =
				this._MySQLDatabaseParameters.ArraysSeparatorString;	
				
			// Имя таблицы розничных товаров.
			this._DiskVarietiesCharacteristicsSelector.RetailGoodsTableName =
				this._MySQLDatabaseParameters.RetailGoodsTableName;
			// Имя столбца идентивикаторов номенклатур в таблице розничных товаров.
			this._DiskVarietiesCharacteristicsSelector.
				RetailGoodsNomenclaturesIDsColumnName  =
				this._MySQLDatabaseParameters.RetailGoodsNomenclaturesIDsColumnName;
			// Имя столбца идентивикаторов разновидностей дисков
			// в таблице розничных товаров.
			this._DiskVarietiesCharacteristicsSelector.
				RetailGoodsDisksVarietiesIDsColumnName =
				this._MySQLDatabaseParameters.RetailGoodsDisksVarietiesIDsColumnName;
			// Имя столбца количеств в таблице розничных товаров.
			this._DiskVarietiesCharacteristicsSelector.
				RetailGoodsCountsColumnName            =
				this._MySQLDatabaseParameters.RetailGoodsCountsColumnName;	
			
			// Имя таблицы номенклатур.
			this._DiskVarietiesCharacteristicsSelector.NomenclaturesTableName     =
				this._MySQLDatabaseParameters.NomenclaturesTableName;
			// Имя столбца идентивикаторов в таблице номенклатур.
			this._DiskVarietiesCharacteristicsSelector.NomenclaturesIDsColumnName =
				this._MySQLDatabaseParameters.NomenclaturesIDsColumnName;
			// Имя столбца артикулов в таблице номенклатур.
			this._DiskVarietiesCharacteristicsSelector.
				NomenclaturesArticlesColumnName = this._MySQLDatabaseParameters.
				NomenclaturesArticlesColumnName;
			// Значение артикула изображения.
			this._DiskVarietiesCharacteristicsSelector.ImageArticleValue          =
				this._DiskInformation.Article;
			
			// Имя таблицы групп товаров.
			this._DiskVarietiesCharacteristicsSelector.GoodsGroupsTableName       =
				this._MySQLDatabaseParameters.GoodsGroupsTableName;
			// Имя столбца кодов в таблице групп товаров.
			this._DiskVarietiesCharacteristicsSelector.GoodsGroupsCodesColumnName =
				this._MySQLDatabaseParameters.GoodsGroupsCodesColumnName;
			// Значение кода группы диска.
			this._DiskVarietiesCharacteristicsSelector.DiskGroupCodeValue         =
				MySQLParameters.DISKS_GROUPS_VALUES[ this._DiskGroup ];
			// Имя столбца наименований в таблице групп товаров.
			this._DiskVarietiesCharacteristicsSelector.GoodsGroupsNamesColumnName =
				this._MySQLDatabaseParameters.GoodsGroupsNamesColumnName;
			
			// Имя таблицы ссылок разновидностей дисков.
			this._DiskVarietiesCharacteristicsSelector.
				DisksVarietiesReferencesTableName = this._MySQLDatabaseParameters.
				DisksVarietiesReferencesTableName;
			// Имя столбца идентивикаторов номенклатур
			// в таблице ссылок разновидностей дисков.
			this._DiskVarietiesCharacteristicsSelector.
				DisksVarietiesReferencesNomenclaturesIDsColumnName                 =
				this._MySQLDatabaseParameters.
				DisksVarietiesReferencesNomenclaturesIDsColumnName;
			// Имя столбца идентивикаторов характеристик разновидностей дисков
			// в таблице ссылок разновидностей дисков.
			this._DiskVarietiesCharacteristicsSelector.
				DisksVarietiesReferencesDisksVarietiesCharacteristicsIDsColumnName =
				this._MySQLDatabaseParameters.
				DisksVarietiesReferencesDisksVarietiesCharacteristicsIDsColumnName;
			// Имя столбца идентивикаторов разновидностей дисков
			// в таблице ссылок разновидностей дисков.
			this._DiskVarietiesCharacteristicsSelector.
				DisksVarietiesReferencesDisksVarietiesIDsColumnName                =
				this._MySQLDatabaseParameters.
				DisksVarietiesReferencesDisksVarietiesIDsColumnName;
				
			// Имя столбца в таблице ссылок разновидностей дисков,
			// упорядочивающего характеристики разновидностей дисков.
			this._DiskVarietiesCharacteristicsSelector.
				DisksVarietiesReferencesCharacteristicsOrderingColumnName    =
				this._MySQLDatabaseParameters.
				DisksVarietiesReferencesDisksVarietiesIDsColumnName;
			// Направление упорядочения характеристик разновидностей дисков
			// в таблице ссылок разновидностей дисков.
			this._DiskVarietiesCharacteristicsSelector.
				DisksVarietiesReferencesCharacteristicsOrderingAscendantSign = 
				this._MySQLDatabaseParameters.DisksVarietiesIDOrderingAscentSign;
				
			// Имя таблицы названий характеристик дисков.
			this._DiskVarietiesCharacteristicsSelector.
				DisksCharacteristicsNamesTableName = this._MySQLDatabaseParameters.
				DisksCharacteristicsNamesTableName;
			// Имя столбца наименований групп
			// в таблице названий характеристик дисков.
			this._DiskVarietiesCharacteristicsSelector.
				DisksCharacteristicsNamesGroupsNamesColumnName   =
				this._MySQLDatabaseParameters.
				DisksCharacteristicsNamesGroupsNamesColumnName;
			// Строка массива имён столбцов названий
			// в таблице названий характеристик дисков.
			this._DiskVarietiesCharacteristicsSelector.
				DisksCharacteristicsNamesNamesColumnsNamesString =
				this._MySQLDatabaseParameters.
				GetDisksCharacteristicsNamesNamesColumnsNamesString( );
	
			// Имя таблицы характеристик разновидностей дисков.
			this._DiskVarietiesCharacteristicsSelector.
				DisksVarietiesCharacteristicsTableName                            =
				this._MySQLDatabaseParameters.DisksVarietiesCharacteristicsTableName;
			// Имя столбца идентификаторов
			// в таблице характеристик разновидностей дисков.
			this._DiskVarietiesCharacteristicsSelector.
				DisksVarietiesCharacteristicsIDsColumnName                        =
				this._MySQLDatabaseParameters.
				DisksVarietiesCharacteristicsIDsColumnName;
			// Строка массива имён столбцов характеристик
			// в таблице характеристик разновидностей дисков.
			this._DiskVarietiesCharacteristicsSelector.
				DisksVarietiesCharacteristicsCharacteristicsColumnsNamesString    =
				this._MySQLDatabaseParameters.
				GetDisksVarietiesCharacteristicsCharacteristicsColumnsNamesString( );
			
			// Основа заголовка разновидности диска.
			this._DiskVarietiesCharacteristicsSelector.DiskVarietyCaptionBase =
				MySQLParameters.DISK_VARIETY_CAPTION_BASE;				
				
			// Загрузка XML-результата при выполнении запроса к базе данных MySQL
			// для получения характеристик разновидностей дисков.
			this._DiskVarietiesCharacteristicsSelector.LoadRequest( );
			// Регистрирация объекта-прослушивателя события успешной загрузки
			// XML-результата при выполнении запроса к базе данных MySQL
			// для получения характеристик разновидностей дисков.
			this._DiskVarietiesCharacteristicsSelector.addEventListener
				( PHPRequester.REQUEST_LOADING_COMPLETE,
	this.DiskVarietiesCharacteristicsRequestXMLResultLoadingFinishedListener );				
			// Регистрирация объекта-прослушивателя события возникновения ошибки
			// при выполнении запроса к базе данных MySQL
			// для получения характеристик разновидностей дисков.
			this._DiskVarietiesCharacteristicsSelector.addEventListener
				( PHPRequester.REQUEST_LOADING_IO_ERROR,
	this.DiskVarietiesCharacteristicsRequestXMLResultLoadingFinishedListener );				
		} // InitializeDiskVarietiesCharacteristicsSelector
		
		// Метод инициализации выборщика данных продаж
		// разновидностей дисков из таблиц MySQL.
		private function InitializeDiskVarietiesSalesDataSelector( ): void	
		{	
			// Вызов метода класса.
			this._MainTracer.CallClassMethod( InformationScreen.CLASS_NAME,
				"InitializeDiskVarietiesSalesDataSelector" );			
		
			// Выборщик данных продаж разновидностей дисков из таблиц MySQL.
			this._DiskVarietiesSalesDataSelector =
				new MySQLDiskVarietiesSalesDataSelector
				(
					this._MySQLDatabaseParameters.ConnectionAttributes,
					this._MySQLDatabaseParameters.
						DiskVarietiesSalesDataSelectorRequestPHPFileURL,
					this._MainTracer
				); // new MySQLDiskVarietiesSalesDataSelector
				
			// Имя таблицы розничных товаров.
			this._DiskVarietiesSalesDataSelector.RetailGoodsTableName              =
				this._MySQLDatabaseParameters.RetailGoodsTableName;
			// Имя столбца идентивикаторов номенклатур в таблице розничных товаров.
			this._DiskVarietiesSalesDataSelector.
				RetailGoodsNomenclaturesIDsColumnName  = this._MySQLDatabaseParameters.
				RetailGoodsNomenclaturesIDsColumnName;
			// Имя столбца идентивикаторов разновидностей дисков
			// в таблице розничных товаров.
			this._DiskVarietiesSalesDataSelector.
				RetailGoodsDisksVarietiesIDsColumnName = this._MySQLDatabaseParameters.
				RetailGoodsDisksVarietiesIDsColumnName;
			// Имя столбца цен в таблице розничных товаров.
			this._DiskVarietiesSalesDataSelector.RetailGoodsCostsColumnName        =
				this._MySQLDatabaseParameters.RetailGoodsCostsColumnName;
			// Имя столбца номеров ячеек в таблице розничных товаров.
			this._DiskVarietiesSalesDataSelector.RetailGoodsCellsNumbersColumnName =
				this._MySQLDatabaseParameters.RetailGoodsCellsNumbersColumnName;
		
			// Имя столбца в таблице розничных товаров,
			// упорядочивающего данные продаж.
			this._DiskVarietiesSalesDataSelector.
				RetailGoodsSalesDataOrderingColumnName    =
				this._MySQLDatabaseParameters.RetailGoodsDisksVarietiesIDsColumnName;
			// Направление упорядочения данных продаж в таблице розничных товаров.
			this._DiskVarietiesSalesDataSelector.
				RetailGoodsSalesDataOrderingAscendantSign =
				this._MySQLDatabaseParameters.DisksVarietiesIDOrderingAscentSign;
		
			// Имя таблицы номенклатур.
			this._DiskVarietiesSalesDataSelector.NomenclaturesTableName          =
				this._MySQLDatabaseParameters.NomenclaturesTableName;
			// Имя столбца идентивикаторов в таблице номенклатур.
			this._DiskVarietiesSalesDataSelector.NomenclaturesIDsColumnName      =
				this._MySQLDatabaseParameters.NomenclaturesIDsColumnName;
			// Имя столбца артикулов в таблице номенклатур.
			this._DiskVarietiesSalesDataSelector.NomenclaturesArticlesColumnName =
				this._MySQLDatabaseParameters.NomenclaturesArticlesColumnName;
			// Значение артикула изображения.
			this._DiskVarietiesSalesDataSelector.ImageArticleValue               =
				this._DiskInformation.Article;
			
			// Имя таблицы ссылок разновидностей дисков.
			this._DiskVarietiesSalesDataSelector.
				DisksVarietiesReferencesTableName = this._MySQLDatabaseParameters.
				DisksVarietiesReferencesTableName;
			// Имя столбца идентивикаторов номенклатур
			// в таблице ссылок разновидностей дисков.
			this._DiskVarietiesSalesDataSelector.
				DisksVarietiesReferencesNomenclaturesIDsColumnName                 =
				this._MySQLDatabaseParameters.
				DisksVarietiesReferencesNomenclaturesIDsColumnName;
			// Имя столбца идентивикаторов характеристик разновидностей дисков
			// в таблице ссылок разновидностей дисков.
			this._DiskVarietiesSalesDataSelector.
				DisksVarietiesReferencesDisksVarietiesCharacteristicsIDsColumnName =
				this._MySQLDatabaseParameters.
				DisksVarietiesReferencesDisksVarietiesCharacteristicsIDsColumnName;
			// Имя столбца в таблице ссылок разновидностей дисков,
			// упорядочивающего характеристики разновидностей дисков.
			this._DiskVarietiesSalesDataSelector.
				DisksVarietiesReferencesCharacteristicsOrderingColumnName          =
				this._MySQLDatabaseParameters.
				DisksVarietiesReferencesDisksVarietiesIDsColumnName;
				
			// Имя таблицы характеристик разновидностей дисков.
			this._DiskVarietiesSalesDataSelector.
				DisksVarietiesCharacteristicsTableName     =
				this._MySQLDatabaseParameters.DisksVarietiesCharacteristicsTableName;
			// Имя столбца идентификаторов
			// в таблице характеристик разновидностей дисков.
			this._DiskVarietiesSalesDataSelector.
				DisksVarietiesCharacteristicsIDsColumnName =
				this._MySQLDatabaseParameters.
				DisksVarietiesCharacteristicsIDsColumnName;
				
			// Загрузка XML-результата при выполнении запроса к базе данных MySQL
			// для получения данных продаж разновидностей дисков.
			this._DiskVarietiesSalesDataSelector.LoadRequest( );
			// Регистрирация объекта-прослушивателя события успешной загрузки
			// XML-результата при выполнении запроса к базе данных MySQL
			// для получения данных продаж разновидностей дисков.
			this._DiskVarietiesSalesDataSelector.addEventListener
				( PHPRequester.REQUEST_LOADING_COMPLETE,
				this.DiskVarietiesSalesDataRequestXMLResultLoadingFinishedListener );				
			// Регистрирация объекта-прослушивателя события возникновения ошибки
			// при выполнении запроса к базе данных MySQL
			// для получения данных продаж разновидностей дисков.
			this._DiskVarietiesSalesDataSelector.addEventListener
				( PHPRequester.REQUEST_LOADING_IO_ERROR,
				this.DiskVarietiesSalesDataRequestXMLResultLoadingFinishedListener );	
		} // InitializeDiskVarietiesSalesDataSelector
		//-----------------------------------------------------------------------
		// Методы-прослушиватели событий.
		
		// Метод-прослушиватель события
		// успешной загрузки данных с URL-адреса файла статических параметров.
		// Параметры:
		// parEvent - событие.
		private static function StaticParametersFileURLLoadingCompleteListener
			( parEvent: Event ): void
		{
			// XML-данные статических параметров, полученные из данных загрузчика
			// с URL-адреса файла статических параметров -
			// объбекта-получателя события.
			var staticParametersXML = XML( parEvent.target.data );
			
			// Временные интервалы.
			
			// Задержка в миллисекундах таймера минимального показа.
			InformationScreen.MinimumShowingTimerDelay                        =
				staticParametersXML.MinimumShowingTimerDelay[ 0 ];
			// Время в миллисекундах длительности внешнего эффекта
			// изменения видимости.
			InformationScreen.OuterEffectTime                                 =
				staticParametersXML.OuterEffectTime[ 0 ];	
			// Коэффициент отношения реальной скорости внешнего эффекта появления
			// к реальной скорости внешнего эффекта исчезновения.
			InformationScreen.OuterEffectShowingVelocityToHidingVelocityRatio =
				staticParametersXML.
				OuterEffectShowingVelocityToHidingVelocityRatio[ 0 ];				
			// Время в миллисекундах длительности эффекта изменения видимости
			// проекции перспективы изображения диска - время, в течение которого
			// осуществляется эффект появления или исчезновения спрайта с эффектом
			// проекции перспективы изображения диска.
			InformationScreen.ProjectionEffectTime                            =
				staticParametersXML.ProjectionEffectTime[ 0 ];
			// Коэффициент отношения реальной скорости эффекта появления
			// проекции перспективы изображения диска к реальной скорости
			// эффекта исчезновения проекции перспективы изображения диска.
			InformationScreen.
				ProjectionEffectShowingVelocityToHidingVelocityRatio            =
				staticParametersXML.
				ProjectionEffectShowingVelocityToHidingVelocityRatio[ 0 ];
				
			// Обрамляющие прямоугольники.				
	
			// Коэффициент отношения отступа от края прямоугольника информации
			// до внешнего прямоугльника без бордюра
			// к большей стороне прямоугольника информации.
			InformationScreen.
				OuterRectangleWBIndentionToGreaterInformationRectangleSideRatio =
				staticParametersXML.
				OuterRectangleWBIndentionToGreaterInformationRectangleSideRatio[ 0 ];
			// Коэффициент отношения отступа
			// от края внешнего прямоугльника без бордюра
			// до внутреннего прямоугльника
			// к большей стороне внешнего прямоугльника без бордюра.
			InformationScreen.
				InnerRectangleIndentionToGreaterOuterRectangleWBSideRatio       =
				staticParametersXML.
				InnerRectangleIndentionToGreaterOuterRectangleWBSideRatio[ 0 ];
			// Коэффициент отношения ширины прямоугольника изображений
			// к ширине внутреннего прямоугольника.
			InformationScreen.ImagesRectangleWidthToInnerRectangleWidthRatio  =
				staticParametersXML.
				ImagesRectangleWidthToInnerRectangleWidthRatio[ 0 ];
				
			// Элементы прямоугольника изображений.	
			
			// Коэффициент отношения высоты прямоугольника изображения диска
			// к высоте прямоугольника изображений.
			InformationScreen.
				DiskImageRectangleHeightToImagesRectangleHeightRatio              =
				staticParametersXML.
				DiskImageRectangleHeightToImagesRectangleHeightRatio[ 0 ];			
			// Коэффициент отношения ширины границ проекции перспективы
			// изображения диска и ширины границ прямоугольника изображения диска.
			InformationScreen.
				DiskImagePerspectiveProjBndsWidthToDiskImageRectBndsWidthRatio    =
				staticParametersXML.
				DiskImagePerspectiveProjBndsWidthToDiskImageRectBndsWidthRatio[ 0 ];
			// Коэффициент отношения высоты границ проекции перспективы
			// изображения диска и высоты границ прямоугольника изображения диска.
			InformationScreen.
				DiskImagePerspectiveProjBndsHeightToDiskImageRectBndsHeightTRatio =
				staticParametersXML.
				DiskImagePerspectiveProjBndsHeightToDiskImageRectBndsHeightTRatio[ 0 ];
				
			// Проекции перспективы изображения диска.
				
			// Угол наклона в градусах проекции перспективы
			// верхней грани изображения диска к оси абсцисс.
			InformationScreen.DiskImageTopPerspectiveProjectionAngle    =
				staticParametersXML.DiskImageTopPerspectiveProjectionAngle[ 0 ];
			// Угол наклона в градусах проекции перспективы
			// нижней грани изображения диска к оси абсцисс.
			InformationScreen.DiskImageBottomPerspectiveProjectionAngle =
				staticParametersXML.DiskImageBottomPerspectiveProjectionAngle[ 0 ];
			// Коэффициент отношения ширины проекции перспективы боковины
			// изображения диска к ширине прямоугольника изображения диска.
			InformationScreen.
				DiskImageSidewallPerspectiveProjWidthToDiskImageRectWidth =
				staticParametersXML.
				DiskImageSidewallPerspectiveProjWidthToDiskImageRectWidth[ 0 ];				
				
			// Строка слайдов.
				
			// Коэффициент отношения ширины спрайта изображения
			// строки слайдов к высоте.
			InformationScreen.SlidesLineImageSpriteWidthToHeightRatio           =
				staticParametersXML.SlidesLineImageSpriteWidthToHeightRatio[ 0 ];
			// Коэффициент отношения стороны пиктограммы мультимедиа-файла диска
			// к большей стороне спрайта изображения строки слайдов.
			InformationScreen.DiskMultimediaFileIconSideToGreaterSlideSideRatio =
				staticParametersXML.
				DiskMultimediaFileIconSideToGreaterSlideSideRatio[ 0 ];
			// Альфа-прозрачность пиктограммы мультимедиа-файла диска.
			InformationScreen.DiskMultimediaFileIconAlpha                       =
				staticParametersXML.DiskMultimediaFileIconAlpha[ 0 ];				
				
			// Элементы прямоугольника описания диска.				
				
			// Коэффициент отношения высоты прямоугольника описания диска
			// к высоте прямоугольника текстов.
			InformationScreen.
				DiskDescriptionRectangleHeightToTextsRectangleHeightRatio = 
				staticParametersXML.
				DiskDescriptionRectangleHeightToTextsRectangleHeightRatio[ 0 ];
			// Коэффициент отношения ширины полоса прокрутки описания диска
			// к ширине прямоугольника описания диска.
			InformationScreen.
				DiskDescrScrollBarWidthToDiskDescrRectangleWidthRatio     =
				staticParametersXML.
				DiskDescrScrollBarWidthToDiskDescrRectangleWidthRatio[ 0 ];
			// Коэффициент отношения высоты бегунка полосы прокрутки описания диска
			// к высоте её дорожки.
			InformationScreen.
				DiskDescriptionScrollBarThumbHeightToTrackHeightRatio     =
				staticParametersXML.
				DiskDescriptionScrollBarThumbHeightToTrackHeightRatio[ 0 ];
				
			// Текстовое поле описания диска.				
				
			// Коэффициент сжатия ширины строки текстового поля описания диска.
			InformationScreen.DiskDescriptionTextFieldLineWidthCompressionRatio  =
				staticParametersXML.
				DiskDescriptionTextFieldLineWidthCompressionRatio[ 0 ];
			// Коэффициент сжатия высоты строки текстового поля описания диска.
			InformationScreen.DiskDescriptionTextFieldLineHeightCompressionRatio =
				staticParametersXML.
				DiskDescriptionTextFieldLineHeightCompressionRatio[ 0 ];
			// Минимальное количество символов в строке
			// текстового поля описания диска.
			InformationScreen.DiskDescriptionTextFieldLineSymbolsMinimumCount    =
				staticParametersXML.
				DiskDescriptionTextFieldLineSymbolsMinimumCount[ 0 ];
			// Минимальное количество строк в текстовом поле описания диска.
			InformationScreen.DiskDescriptionTextFieldLinesMinimumCount          =
				staticParametersXML.DiskDescriptionTextFieldLinesMinimumCount[ 0 ];
			// Вертикальный межстрочный интервал в текстовом поле описания диска.
			InformationScreen.DiskDescriptionTextFieldLinesLeadingVerticalSpace  =
				staticParametersXML.
				DiskDescriptionTextFieldLinesLeadingVerticalSpace[ 0 ];
				
			// Таблица примечаний.				
				
			// Коэффициент отношения высоты таблицы примечаний
			// к высоте прямоугольника таблиц.
			InformationScreen.NotesGridHeightToGridsRectangleHeightRatio =
				staticParametersXML.NotesGridHeightToGridsRectangleHeightRatio[ 0 ];
			// Коэффициент сжатия ширины текста ячейки таблицы примечаний.
			InformationScreen.NotesGridCellTextWidthCompressionRatio     =
				staticParametersXML.NotesGridCellTextWidthCompressionRatio[ 0 ];
			// Коэффициент сжатия высоты текста ячейки таблицы примечаний.
			InformationScreen.NotesGridCellTextHeightCompressionRatio    =
				staticParametersXML.NotesGridCellTextHeightCompressionRatio[ 0 ];
				
			// Элементы прямоугольника кнопок выбора.				
		
			// Коэффициент отношения высоты прямоугольника кнопок выбора
			// к высоте прямоугольника таблиц.
			InformationScreen.
				ChoiceButtonsRectangleHeightToGridsRectangleHeightRatio    =
				staticParametersXML.
				ChoiceButtonsRectangleHeightToGridsRectangleHeightRatio[ 0 ];
			// Коэффициент отношения максимальной ширины кнопки выбора
			// к ширине прямоугольника кнопок выбора.
			InformationScreen.
				ChoiceButtonMaximumWidthToChoiceButtonsRectangleWidthRatio =
				staticParametersXML.
				ChoiceButtonMaximumWidthToChoiceButtonsRectangleWidthRatio[ 0 ];
			// Текстовая метка для кнопки выбора.
			InformationScreen.ChoiceButtonLabel                          =
				staticParametersXML.ChoiceButtonLabel[ 0 ];
				
			// Кнопка выхода.
			
			// Максимальный коэффициент отношения стороны пиктограммы кнопки выхода
			// к соответствующей стороне кнопки выхода.		
			InformationScreen.ExitButtonIconSideToExitButtonSameSideMaximumRatio =
				staticParametersXML.
				ExitButtonIconSideToExitButtonSameSideMaximumRatio[ 0 ];
			
			// Таблица стоимостей.
				
			// Коэффициент отношения высоты таблицы стоимостей
			// к высоте прямоугольника таблиц.
			InformationScreen.CostsGridHeightToGridsRectangleHeightRatio =
				staticParametersXML.CostsGridHeightToGridsRectangleHeightRatio[ 0 ];
			// Коэффициент сжатия ширины текста ячейки таблицы стоимостей.
			InformationScreen.CostsGridCellTextWidthCompressionRatio     =
				staticParametersXML.CostsGridCellTextWidthCompressionRatio[ 0 ];
			// Коэффициент сжатия высоты текста ячейки таблицы стоимостей.
			InformationScreen.CostsGridCellTextHeightCompressionRatio    =
				staticParametersXML.CostsGridCellTextHeightCompressionRatio[ 0 ];
				
			// Таблица характеристик.				
				
			// Коэффициент отношения ширины области названий характеристик
			// к ширине прямоугольника таблиц.
			InformationScreen.
				CharacteristicsNamesAreaWidthToGridsRectangleWidthRatio           =
				staticParametersXML.
				CharacteristicsNamesAreaWidthToGridsRectangleWidthRatio[ 0 ];
			// Коэффициент отношения ширины символа таблицы характеристик
			// к ширине таблицы характеристик.
			InformationScreen.CharacteristicsGridSymbolWidthToWidthRatio        =
				staticParametersXML.CharacteristicsGridSymbolWidthToWidthRatio[ 0 ];
			// Коэффициент сжатия ширины текста ячейки
			// столбца назаний характеристик таблицы характеристик.
			InformationScreen.
				CharacteristicsGridNamesColumnCellTextWidthCompressionRatio       =
				staticParametersXML.
				CharacteristicsGridNamesColumnCellTextWidthCompressionRatio[ 0 ];
			// Коэффициент сжатия высоты текста ячейки
			// столбца назаний характеристик таблицы характеристик.
			InformationScreen.
				CharacteristicsGridNamesColumnCellTextHeightCompressionRatio      =
				staticParametersXML.
				CharacteristicsGridNamesColumnCellTextHeightCompressionRatio[ 0 ];
			// Коэффициент сжатия ширины текста ячейки
			// столбца категорий диска таблицы характеристик.
			InformationScreen.
				CharacteristicsGridCategoriesColumnCellTextWidthCompressionRatio  =
				staticParametersXML.
		CharacteristicsGridCategoriesColumnCellTextWidthCompressionRatio[ 0 ];
			// Коэффициент сжатия высоты текста ячейки
			// столбца категорий диска таблицы характеристик.
			InformationScreen.
				CharacteristicsGridCategoriesColumnCellTextHeightCompressionRatio =
				staticParametersXML.
		CharacteristicsGridCategoriesColumnCellTextHeightCompressionRatio[ 0 ];
			
			// Передача события успешной загрузки статических параметров,
			// целью - объбектом-получателем - которого является объект
			// статического диспетчера событий данного класса экрана информации.
			InformationScreen._StaticEventDispatcher.dispatchEvent( new Event
				( InformationScreen.STATIC_PARAMETERS_LOADING_COMPLETE ) );			
			// Передача события окончания загрузки статических параметров,
			// целью - объбектом-получателем - которого является объект
			// статического диспетчера событий данного класса экрана информации.
			InformationScreen._StaticEventDispatcher.dispatchEvent( new Event
				( InformationScreen.STATIC_PARAMETERS_LOADING_FINISHED ) );
		} // StaticParametersFileURLLoadingCompleteListener	
		
		// Метод-прослушиватель события возникновения ошибки
		// при загрузке данных с URL-адреса файла статических параметров.
		// Параметры:
		// parIOErrorEvent - событие возникновения ошибки при выполнении
		//  операция отправки или загрузки.
		private static function StaticParametersFileURLLoadingIOErrorListener
			( parIOErrorEvent: IOErrorEvent ): void
		{
			// Вывод сообщения об ошибке загрузки данных с URL-адреса
			// файла статических параметров.
			trace( InformationScreen.
				STATIC_PARAMETERS_FILE_URL_LOADING_IO_ERROR_MESSAGE );
			// Передача события возникновения ошибки
			// при загрузке статических параметров,
			// целью - объбектом-получателем - которого является объект
			// статического диспетчера событий данного класса экрана информации.
			InformationScreen._StaticEventDispatcher.dispatchEvent( new Event
				( InformationScreen.STATIC_PARAMETERS_LOADING_IO_ERROR ) );			
			// Передача события окончания загрузки статических параметров,
			// целью - объбектом-получателем - которого является объект
			// статического диспетчера событий данного класса экрана информации.
			InformationScreen._StaticEventDispatcher.dispatchEvent( new Event
				( InformationScreen.STATIC_PARAMETERS_LOADING_FINISHED ) );
		} // StaticParametersFileURLLoadingIOErrorListener	
		
		// Метод-прослушиватель события успешной загрузки данных
		// с URL-адреса файла демонстрационных статических параметров.
		// Параметры:
		// parEvent - событие.
		private static function
			DemoStaticParametersFileURLLoadingCompleteListener
			( parEvent: Event ): void
		{
			// XML-данные демонстрационных статических параметров, полученные
			// из данных загрузчика с URL-адреса файла статических параметров -
			// объбекта-получателя события.
			var demoStaticParametersXML = XML( parEvent.target.data );
			
			// Время в миллисекундах длительности внешнего эффекта
			// изменения видимости.
			InformationScreen.OuterEffectTime                                 =
				demoStaticParametersXML.OuterEffectTime[ 0 ];	
			// Коэффициент отношения реальной скорости внешнего эффекта появления
			// к реальной скорости внешнего эффекта исчезновения.
			InformationScreen.OuterEffectShowingVelocityToHidingVelocityRatio =
				demoStaticParametersXML.
				OuterEffectShowingVelocityToHidingVelocityRatio[ 0 ];				
			// Время в миллисекундах длительности эффекта изменения видимости
			// проекции перспективы изображения диска - время, в течение которого
			// осуществляется эффект появления или исчезновения спрайта с эффектом
			// проекции перспективы изображения диска.
			InformationScreen.ProjectionEffectTime                            =
				demoStaticParametersXML.ProjectionEffectTime[ 0 ];
			// Коэффициент отношения реальной скорости эффекта появления
			// проекции перспективы изображения диска к реальной скорости
			// эффекта исчезновения проекции перспективы изображения диска.
			InformationScreen.
				ProjectionEffectShowingVelocityToHidingVelocityRatio            =
				demoStaticParametersXML.
				ProjectionEffectShowingVelocityToHidingVelocityRatio[ 0 ];
				
			// Передача события окончания загрузки демонстрационных
			// статических параметров, целью - объбектом-получателем - которого
			// является объект статического диспетчера событий
			// данного класса экрана информации.
			InformationScreen._StaticEventDispatcher.dispatchEvent( new Event
				( InformationScreen.DEMO_STATIC_PARAMETERS_LOADING_FINISHED ) );
		} // DemoStaticParametersFileURLLoadingCompleteListener		
		
		// Метод-прослушиватель события возникновения ошибки при загрузке данных
		// с URL-адреса файла демонстрационных статических параметров.
		// Параметры:
		// parIOErrorEvent - событие возникновения ошибки при выполнении
		//  операция отправки или загрузки.
		private static function
			DemoStaticParametersFileURLLoadingIOErrorListener
			( parIOErrorEvent: IOErrorEvent ): void
		{
			// Вывод сообщения об ошибке загрузки данных с URL-адреса
			// файла демонстрационных статических параметров.
			trace( InformationScreen.
				DEMO_STATIC_PARAMETERS_FILE_URL_LOADING_IO_ERROR_MESSAGE );
			// Передача события возникновения ошибки
			// при загрузке демонстрационных статических параметров,
			// целью - объбектом-получателем - которого является объект
			// статического диспетчера событий данного класса экрана информации.
			InformationScreen._StaticEventDispatcher.dispatchEvent( new Event
				( InformationScreen.DEMO_STATIC_PARAMETERS_LOADING_IO_ERROR ) );			
			// Передача события окончания загрузки демонстрационных
			// статических параметров, целью - объбектом-получателем - которого
			// является объект статического диспетчера событий
			// данного класса экрана информации.
			InformationScreen._StaticEventDispatcher.dispatchEvent( new Event
				( InformationScreen.DEMO_STATIC_PARAMETERS_LOADING_FINISHED ) );
		} // DemoStaticParametersFileURLLoadingIOErrorListener		

		// Метод-прослушиватель события завершения загрузки изображения
		// на прямоугольник изображения диска.
		// Параметры:
		// parImageSpriteEvent - событие спрайта изображения.
		private function DiskImageRectangleImageLoadingFinishedListener
			( parImageSpriteEvent: ImageSpriteEvent ): void
		{
			// Вызов метода-обработчика события класса.
			this._MainTracer.CallClassEventListener( InformationScreen.CLASS_NAME,
				"DiskImageRectangleImageLoadingFinishedListener",
				parImageSpriteEvent );			
			
			// Отображение проекций перспективы изображения диска.
			this.DisplayDiskImagePerspectiveProjections( );
			
			// Отмена регистрирации объекта-прослушивателя события
			// успешной загрузки изображения на спрайт изображения -
			// прямоугольник изображения диска.
			this._DiskImageRectangle.removeEventListener
				( ImageSpriteEvent.IMAGE_SPRITE_IMAGE_LOADING_COMPLETE,
				this.DiskImageRectangleImageLoadingFinishedListener );
			// Отмена регистрирации объекта-прослушивателя события
			// возникновения ошибки при загрузке изображения
			// на спрайт изображения - прямоугольник изображения диска.
			this._DiskImageRectangle.removeEventListener
				( ImageSpriteEvent.IMAGE_SPRITE_IMAGE_LOADING_IO_ERROR,
				this.DiskImageRectangleImageLoadingFinishedListener );			
		
			// Регистрирация объекта-прослушивателя события успешной перезагрузки
			// изображения на спрайт изображения - прямоугольник изображения диска.
			this._DiskImageRectangle.addEventListener
				( ImageSpriteEvent.IMAGE_SPRITE_IMAGE_LOADING_COMPLETE,
				this.DiskImageRectangleImageReloadingFinishedListener );
			// Регистрирация объекта-прослушивателя события
			// возникновения ошибки при перезагрузке изображения
			// на спрайт изображения - прямоугольник изображения диска.
			this._DiskImageRectangle.addEventListener
				( ImageSpriteEvent.IMAGE_SPRITE_IMAGE_LOADING_IO_ERROR,
				this.DiskImageRectangleImageReloadingFinishedListener );
				
			// Установка параметров эффекта изменения видимости
			// спрайта с эффектом проекции перспективы изображения диска.
			this._DiskImagePerspectiveProjectionEffectSprite.
				GetEffectParameters( );				
			// Регистрирация объекта-прослушивателя события завершения
			// эффекта исчезновения спрайта с эффектом проекции перспективы
			// изображения диска.
			this._DiskImagePerspectiveProjectionEffectSprite.addEventListener
				( AppearingWithIncreaseSprite.HIDING_EFFECT_EXECUTING_FINISHED,
				this.ProjectionEffectSpriteHidingEffectExecutingFinishedListener );
		} // DiskImageRectangleImageLoadingFinishedListener
		
		// Метод-прослушиватель события завершения перезагрузки изображения
		// на прямоугольник изображения диска.
		// Параметры:
		// parImageSpriteEvent - событие спрайта изображения.
		private function DiskImageRectangleImageReloadingFinishedListener
			( parImageSpriteEvent: ImageSpriteEvent ): void
		{
			// Вызов метода-обработчика события класса.
			this._MainTracer.CallClassEventListener( InformationScreen.CLASS_NAME,
				"DiskImageRectangleImageReloadingFinishedListener",
				parImageSpriteEvent );
			
			// Если в текущий момент не выолняется эффект появления
			// или эффект исчезновения спрайта с эффектом проекции перспективы
			// изображения диска.
			if
			(
				( ! this._DiskImagePerspectiveProjectionEffectSprite.
					ShowingEffectIsExecuting ) &&
				( ! this._DiskImagePerspectiveProjectionEffectSprite.
					HidingEffectIsExecuting  )
			)
				// Сокрытие спрайта с эффектом проекции перспективы
				// изображения диска, при котором происходит эффект исчезновения.
				this._DiskImagePerspectiveProjectionEffectSprite.Hide( );
		} // DiskImageRectangleImageReloadingFinishedListener
		
		// Метод-прослушиватель события завершения эффекта исчезновения
		// спрайта с эффектом проекции перспективы изображения диска.
		// Параметры:
		// parEvent - событие.
		private function
			ProjectionEffectSpriteHidingEffectExecutingFinishedListener
			( parEvent: Event ): void
		{
			// Вызов метода-обработчика события класса.
			this._MainTracer.CallClassEventListener( InformationScreen.CLASS_NAME,
				"ProjectionEffectSpriteHidingEffectExecutingFinishedListener",
				parEvent );
			
			// Отображение проекций перспективы изображения диска.
			this.DisplayDiskImagePerspectiveProjections( );
			// Показ спрайта с эффектом проекции перспективы изображения диска.
			this._DiskImagePerspectiveProjectionEffectSprite.Show( );			
		} // ProjectionEffectSpriteHidingEffectExecutingFinishedListener		
		
		// Метод-прослушиватель события завершения выполнения запроса
		// для получения URL-адресов видео-файлов диска.
		// Параметры:
		// parEvent - событие спрайта.
		private function
			DiskVideosFilesURLsRequestXMLResultLoadingFinishedListener
			( parEvent: Event ): void
		{
			// Вызов метода-обработчика события класса.
			this._MainTracer.CallClassEventListener( InformationScreen.CLASS_NAME,
				"DiskVideosFilesURLsRequestXMLResultLoadingFinishedListener",
				parEvent );			
			
			// Инициализация выборщика URL-адресов аудио-файлов диска.
			this.InitializeDiskAudiosFilesURLsSelector( );
		} // DiskVideosFilesURLsRequestXMLResultLoadingFinishedListener	
		
		// Метод-прослушиватель события завершения выполнения запроса
		// для получения URL-адресов аудио-файлов диска.
		// Параметры:
		// parEvent - событие спрайта.
		private function
			DiskAudiosFilesURLsRequestXMLResultLoadingFinishedListener
			( parEvent: Event ): void
		{
			// Вызов метода-обработчика события класса.
			this._MainTracer.CallClassEventListener( InformationScreen.CLASS_NAME,
				"DiskAudiosFilesURLsRequestXMLResultLoadingFinishedListener",
				parEvent );			
			
			// Инициализация выборщика URL-адресов кадров фильмов диска.
			this.InitializeDiskFramesFilesURLsSelector( );
		} // DiskAudiosFilesURLsRequestXMLResultLoadingFinishedListener
		
		// Метод-прослушиватель события завершения выполнения запроса
		// для получения URL-адресов кадров фильмов диска.
		// Параметры:
		// parEvent - событие спрайта.
		private function
			DiskFramesFilesURLsRequestXMLResultLoadingFinishedListener
			( parEvent: Event ): void
		{
			// Вызов метода-обработчика события класса.
			this._MainTracer.CallClassEventListener( InformationScreen.CLASS_NAME,
				"DiskFramesFilesURLsRequestXMLResultLoadingFinishedListener",
				parEvent );			
			
			// Загрузка данных - изображений, информаций и пиктограмм - 
			// строки слайдов.
			this.LoadSlidesLineData( );
			// Инициализация прямоугольника описания диска.
			this.InitializeDiskDescriptionRectangle( );
			// Инициализация текстового поля описания диска.
			this.InitializeDiskDescriptionTextField( );
			// Инициализация выборщика описания диска из таблиц MySQL.
			this.InitializeDiskDescriptionSelector( );
		} // DiskFramesFilesURLsRequestXMLResultLoadingFinishedListener
		
		// Метод-прослушиватель события
		// успешной загрузки изображения на спрайт изображения строки слайдов.
		// Параметры:
		// parImageSpriteEvent - событие спрайта изображения.
		private function SlidesLineImageSpriteImageLoadindCompleteListener
			( parImageSpriteEvent: ImageSpriteEvent ): void
		{
			// Вызов метода-обработчика события класса.
			this._MainTracer.CallClassEventListener( InformationScreen.CLASS_NAME,
				"SlidesLineImageSpriteImageLoadindCompleteListener",
				parImageSpriteEvent );			
			
			// Слайд - спрайт изображения строки слайдов, на котором произошло
			// событие успешной загрузки изображения на спрайт изображения.
			var slide: ImageSprite = parImageSpriteEvent.TargetImageSprite;
			
			// Если слайд не определён или не содержит информации,
			// или тип слайда - кадр фильма.
			if
			(
				( slide                  == null            ) ||
				( slide.Information      == null            ) ||
				( slide.Information.Type == SlideType.FRAME )
			)
				// Пиктограмма не загружается на слайд.
				return;
				
			// Пиктограмма мультимедиа-файла диска.
			var diskMultimediaFileIcon: Sprite;
			// Если тип слайда диска - видео.
			if ( slide.Information.Type == SlideType.VIDEO )
				// Пиктограмма мультимедиа-файла диска - видео-спрайт.
				diskMultimediaFileIcon = new VideoSprite( );
			// Если тип слайда диска - аудио.
			else
				// Пиктограмма мультимедиа-файла диска - аудио-спрайт.
				diskMultimediaFileIcon = new AudioSprite( );	
				
			// Пиктограмма мультимедиа-файла диска - квадратная, её стороны равны
			// величине стороны пиктограммы мультимедиа-файла диска.
			diskMultimediaFileIcon.width  = this._DiskMultimediaFileIconSide;
			diskMultimediaFileIcon.height = this._DiskMultimediaFileIconSide;
			// Альфа-прозрачность пиктограммы мультимедиа-файла диска.
			diskMultimediaFileIcon.alpha  =
				InformationScreen.DiskMultimediaFileIconAlpha;			
			
			// Добавление пиктограммы на слайд.
			slide.AddIcon( diskMultimediaFileIcon );
		} // SlidesLineImageSpriteImageLoadindCompleteListener		
		
		// Метод-прослушиватель события завершения выполнения запроса
		// к базе данных MySQL для получения описания диска.
		// Параметры:
		// parEvent - событие.
		private function DiskDescriptionRequestXMLResultLoadingFinishedListener
			( parEvent: Event ): void	
		{
			// Вызов метода-обработчика события класса.
			this._MainTracer.CallClassEventListener( InformationScreen.CLASS_NAME,
				"DiskDescriptionRequestXMLResultLoadingFinishedListener", parEvent );	
			
			// Если описания диска загружено.
			if ( this._DiskDescriptionSelector.RequestXMLResult != null )
			{
				// Текст в текстовом поле описания диска, полученный
				// из первого элемента массива-результата выполненного запроса
				// к базе данных MySQL для получения описания диска.		
				this._DiskDescriptionTextField.text =
					String( this._DiskDescriptionSelector.RequestArrayResult[ 0 ] );
				// Инициализация полосы прокрутки описания диска.
				this.InitializeDiskDescriptionScrollBar( );					
			} // if
				
			// Инициализация прямоугольника таблиц.
			this.InitializeGridsRectangle( );
			// Инициализация выборщика кода группы диска из таблиц MySQL.
			this.InitializeDiskGroupCodeSelector( );
		} // DiskDescriptionRequestXMLResultLoadingFinishedListener
		
		// Метод-прослушиватель события завершения выполнения запроса
		// к базе данных MySQL для получения кода группы диска.	
		// Параметры:
		// parEvent - событие.
		private function DiskGroupCodeRequestXMLResultLoadingFinishedListener
			( parEvent: Event ): void	
		{	
			// Вызов метода-обработчика события класса.
			this._MainTracer.CallClassEventListener( InformationScreen.CLASS_NAME,
				"DiskGroupCodeRequestXMLResultLoadingFinishedListener", parEvent );			
		
			// Если код группы диска загружен.
			if ( this._DiskGroupCodeSelector.RequestXMLResult != null )
			{
				// Группа диска, определённая по коду группы диска, полученному
				// из первого элемента массива-результата выполненного запроса
				// к базе данных MySQL для получения кода группы диска.
				this._DiskGroup     = MySQLParameters.GetDiskGroup
					( this._DiskGroupCodeSelector.RequestArrayResult[ 0 ] );
				// Тип примечаний диска, определённый по его группе.
				this._DiskNotesType = this._MySQLDatabaseParameters.
					GetDiskGroupNotesType( this._DiskGroup );
			} // if
			
			// Если код группы диска не загружен
			// или тип примечаний диска не известен.
			if
			(
				( this._DiskGroupCodeSelector.RequestXMLResult == null ) ||
				( this._DiskNotesType == DiskNotesType.UNKNOWN )
			)
			{
				// Запуск таймера минимального показа.
				this._MinimumShowingTimer.start( );			
				// Больше ничего не загружается,
				// так как оставшиеся элементы зависят от группы диска.
				return;
			} // if
			
			// Выборщик примечаний диска из таблиц MySQL.
			this._DiskNotesSelector =
				new DiskNotesSelector
				(
					this._MySQLDatabaseParameters,
					this._DiskNotesType,
					this._DiskInformation.Article,
					this._MainTracer
				); // new DiskNotesSelector
				
			// Загрузка XML-результата при выполнении запроса к базе данных MySQL
			// для получения примечаний диска.
			this._DiskNotesSelector.LoadRequest( );
			// Регистрирация объекта-прослушивателя события успешной загрузки
			// XML-результата при выполнении запроса к базе данных MySQL
			// для получения примечаний диска.	
			this._DiskNotesSelector.addEventListener
				( PHPRequester.REQUEST_LOADING_COMPLETE,
				this.DiskNotesRequestXMLResultLoadingFinishedListener );				
			// Регистрирация объекта-прослушивателя события возникновения ошибки
			// при выполнении запроса к базе данных MySQL
			// для получения примечаний диска.
			this._DiskNotesSelector.addEventListener
				( PHPRequester.REQUEST_LOADING_IO_ERROR,
				this.DiskNotesRequestXMLResultLoadingFinishedListener );				
		} // DiskGroupCodeRequestXMLResultLoadingFinishedListener
		
		// Метод-прослушиватель события завершения выполнения запроса
		// к базе данных MySQL для получения примечаний диска.
		// Параметры:
		// parEvent - событие.
		private function DiskNotesRequestXMLResultLoadingFinishedListener
			( parEvent: Event ): void	
		{	
			// Вызов метода-обработчика события класса.
			this._MainTracer.CallClassEventListener( InformationScreen.CLASS_NAME,
				"DiskNotesRequestXMLResultLoadingFinishedListener", parEvent );
			
			// Инициализация таблицы примечаний.
			this.InitializeNotesGrid( );
			
			// Если группа диска не известна.
			if ( this._DiskGroup == DiskGroup.UNKNOWN )
			{
				// Запуск таймера минимального показа.
				this._MinimumShowingTimer.start( );			
				// Больше ничего не загружается,
				// так как оставшиеся элементы зависят от группы диска.
				return;
			} // if		
			
			// Инициализация прямоугольника кнопок выбора.
			this.InitializeChoiceButtonsRectangle( );			
			// Метод инициализации выборщика цен
			// разновидностей дисков из таблиц MySQL.
			this.InitializeDiskVarietiesCostsSelector( );
		} // DiskNotesRequestXMLResultLoadingFinishedListener
		
		// Метод-прослушиватель события завершения выполнения запроса
		// к базе данных MySQL для получения цен разновидностей дисков.
		// Параметры:
		// parEvent - событие.
		private function
			DiskVarietiesCostsRequestXMLResultLoadingFinishedListener
			( parEvent: Event ): void	
		{
			// Вызов метода-обработчика события класса.
			this._MainTracer.CallClassEventListener( InformationScreen.CLASS_NAME,
				"DiskVarietiesCostsRequestXMLResultLoadingFinishedListener",
				parEvent );		
			
			// Инициализация таблицы стоимостей.
			this.InitializeCostsGrid( );			
			// Инициализация выборщика кода группы диска из таблиц MySQL.
			this.InitializeDiskVarietiesCharacteristicsSelector( );		
		} // DiskVarietiesCostsRequestXMLResultLoadingFinishedListener
		
		// Метод-прослушиватель события завершения выполнения запроса
		// к базе данных MySQL для получения характеристик разновидностей дисков.
		// Параметры:
		// parEvent - событие.
		private function
			DiskVarietiesCharacteristicsRequestXMLResultLoadingFinishedListener
			( parEvent: Event ): void	
		{
			// Вызов метода-обработчика события класса.
			this._MainTracer.CallClassEventListener( InformationScreen.CLASS_NAME,
				"DiskVarietiesCharacteristicsRequestXMLResultLoadingFinishedListener",
				parEvent );			
			
			// Инициализация таблицы характеристик.
			this.InitializeCharacteristicsGrid( );
			
			// Если цены разновидностей диска не загружен.
			if ( this._DiskVarietiesCostsSelector.RequestXMLResult == null )
			{
				// Запуск таймера минимального показа.
				this._MinimumShowingTimer.start( );			
				// Больше ничего не загружается,
				// так как оставшиеся элементы зависят от группы диска.
				return;
			} // if
			
			// Инициализация выборщика данных продаж
			// разновидностей дисков из таблиц MySQL.
			this.InitializeDiskVarietiesSalesDataSelector( );
		} // DiskVarietiesCharacteristicsRequestXMLResultLoadingFinishedListener
		
		// Метод-прослушиватель события завершения выполнения запроса
		// к базе данных MySQL для получения данных продаж разновидностей дисков.
		// Параметры:
		// parEvent - событие.
		private function
			DiskVarietiesSalesDataRequestXMLResultLoadingFinishedListener
			( parEvent: Event ): void	
		{
			// Вызов метода-обработчика события класса.
			this._MainTracer.CallClassEventListener( InformationScreen.CLASS_NAME,
				"DiskVarietiesSalesDataRequestXMLResultLoadingFinishedListener",
				parEvent );			
			
			// Инициализация кнопок выбора.
			this.InitializeChoiceButtons( );
			// Инициализация кнопки выхода.
			this.InitializeExitButton( );
			// Показ внешнего спрайта эффекта.
			this.ShowOuterEffectSprite( );			
		} // DiskVarietiesSalesDataRequestXMLResultLoadingFinishedListener
		
		// Метод-прослушиватель события завершения эффекта появления
		// внешнего спрайта с эффектом.
		// Параметры:
		// parEvent - событие.
		private function OuterEffectSpriteShowingEffectExecutingFinishedListener
			( parEvent: Event ): void
		{
			// Вызов метода-обработчика события класса.
			this._MainTracer.CallClassEventListener( InformationScreen.CLASS_NAME,
				"OuterEffectSpriteShowingEffectExecutingFinishedListener",
				parEvent );	

			// Запуск таймера минимального показа.
			this._MinimumShowingTimer.start( );
		} // OuterEffectSpriteShowingEffectExecutingFinishedListener		
		
		// Метод-прослушиватель события достижения таймером
		// минимального показа интервала задержки в миллисекундах
		// между появлением экрана информации и наступлением момента,
		// когда он уже может передавать событие клика мыши на кнопке выхода.
		// Параметры:
		// parTimerEvent - событие таймера.
		private function MinimumShowingTimerTimerListener
			( parTimerEvent: TimerEvent ): void
		{
			// Вызов метода-обработчика события класса.
			this._MainTracer.CallClassEventListener( InformationScreen.CLASS_NAME,
				"MinimumShowingTimerTimerListener", parTimerEvent );			
			
			// Событие таймера минимального показа передаётся, когда прошло
			// минимальное время показа экрана информации, перед тем,
			// как его можно закрыть, поэтому теперь дожно прослушиваться событие
			// клика мыши на кнопке выхода, которое должно сигнализировать
			// о необходимости закрытия экрана информации.

			// Регистрирация объекта-прослушивателя события
			// клика мыши на кнопке выхода.
			if ( this._ExitButton != null )
				this._ExitButton.addEventListener( MouseEvent.CLICK,
					this.ExitButtonClickListener );	
			
			// Строка слайдов.
			if ( this._SlidesLine != null )
				// Регистрирация объекта-прослушивателя события
				// клика мыши на спрайте изображения строки слайдов.
				this._SlidesLine.addEventListener
					( ImageSpriteEvent.IMAGE_SPRITE_CLICK,
					this.SlidesLineImageSpriteClickListener );					
		} // MinimumShowingTimerTimerListener
	
		// Метод-прослушиватель события клика мыши на кнопке выхода.
		// Параметры:
		// parMouseEvent - событие мыши.
		private function ExitButtonClickListener
			( parMouseEvent: MouseEvent ): void
		{
			// Вызов метода-обработчика события класса.
			this._MainTracer.CallClassEventListener( InformationScreen.CLASS_NAME,
				"ExitButtonClickListener", parMouseEvent );	

			// Сокрытие внешнего спрайта с эффектом.
			this._OuterEffectSprite.Hide( );
			// Регистрирация объекта-прослушивателя события завершения
			// эффекта исчезновения внешнего спрайта с эффектом.
			this._OuterEffectSprite.addEventListener
				( AppearingWithIncreaseSprite.HIDING_EFFECT_EXECUTING_FINISHED,
				this.OuterEffectSpriteHidingEffectExecutingFinishedListener );			
		} // ExitButtonClickListener
		
		// Метод-прослушиватель события завершения эффекта исчезновения
		// внешнего спрайта с эффектом.
		// Параметры:
		// parEvent - событие.
		private function OuterEffectSpriteHidingEffectExecutingFinishedListener
			( parEvent: Event ): void
		{
			// Вызов метода-обработчика события класса.
			this._MainTracer.CallClassEventListener( InformationScreen.CLASS_NAME,
				"OuterEffectSpriteHidingEffectExecutingFinishedListener", parEvent );			
			
			// Передача события наступления момента времени закрытия
			// в поток событий, целью - объбектом-получателем - которого
			// является данный объект экрана информации.
			this.dispatchEvent( new Event( InformationScreen.SHOULD_CLOSE ) );
		} // OuterEffectSpriteHidingEffectExecutingFinishedListener
		
		// Метод-прослушиватель события
		// клика мыши на спрайте изображения строки слайдов.
		// Параметры:
		// parImageSpriteEvent - событие спрайта изображения.
		private function SlidesLineImageSpriteClickListener
			( parImageSpriteEvent: ImageSpriteEvent ): void
		{
			// Вызов метода-обработчика события класса.
			this._MainTracer.CallClassEventListener( InformationScreen.CLASS_NAME,
				"SlidesLineImageSpriteClickListener", parImageSpriteEvent );			
			
			// Слайд - cпрайт изображения, на котором произошло событие клика мыши.
			var slide: ImageSprite = parImageSpriteEvent.TargetImageSprite;
			
			// Если слайд не определён или не содержит информации.
			if
			(
				( slide             == null ) ||
				( slide.Information == null )
			)
				// Экран кадра фильма не появляется.
				return;			
			
			// Если тип слайда - кадр фильма.
			if ( slide.Information.Type == SlideType.FRAME )
				// Загрузка изображения на прямоугольник изображения диска
				// из файла изображения кадра фильма.
				this._DiskImageRectangle.LoadImage( slide.Information.PathString );
			
			// Если тип слайда - видео или аудио.
			else
			{
				// Создание объекта экрана медиа-плеера.
				this._MediaPlayerScreen =	new MediaPlayerScreen
					(
						// Парараметры базы данных MySQL.
						this._MySQLDatabaseParameters,
						// Информация медиа-файла - информация слайда.
						SlideFilePathAndTypeInformation( slide.Information ),
						// Ocновной трассировщик.
						this._MainTracer,
						// Прямоугольная область экрана медиа-плеера.
						this.getBounds( this ),
						// Предельный прямоугольник окна медиа-плеера
						// нормального размера - внутренний прямоугольник
						// в системе координат экрана информации.
						this._InnerRectangleInThisCoordinateSpace	
					); // new MediaPlayerScreen	
					
				// Помещение объекта экрана медиа-плеера в объект экрана информации.
				this.addChild( this._MediaPlayerScreen );				
				// Регистрирация объекта-прослушивателя события наступления
				// момента времени закрытия экрана медиа-плеера.
				this._MediaPlayerScreen.addEventListener
					( MediaPlayerScreen.SHOULD_CLOSE,
					this.MediaPlayerScreenShouldCloseListener );
			} // else
		} // SlidesLineImageSpriteClickListener
		
		// Метод-прослушиватель события наступления момента времени
		// закрытия экрана медиа-плеера.
		// Параметры:
		// parEvent - событие.
		private function MediaPlayerScreenShouldCloseListener
			( parEvent: Event ): void
		{
			// Вызов метода-обработчика события класса.
			this._MainTracer.CallClassEventListener( InformationScreen.CLASS_NAME,
				"MediaPlayerScreenShouldCloseListener", parEvent );			
			
			// Удаление объекта экрана медиа-плеера
			// из списка потомков экземпляра данного эрана информации.
			this.removeChild( this._MediaPlayerScreen );
			// Очищение объекта экрана медиа-плеера.
			this._MediaPlayerScreen = null;
			// Передача события наступления момента времени
			// закрытия экрана медиа-плеера в поток событий,
			// целью - объбектом-получателем - которого является
			// данный объект экрана информации.
			this.dispatchEvent( new Event
				( InformationScreen.MEDIA_PLAYER_SCREEN_CLOSED ) );	
		} // MediaPlayerScreenShouldCloseListener
		
		// Метод-прослушиватель события клика мыши на кнопке выбора.
		// Параметры:
		// parMouseEvent - событие мыши.
		private function ChoiceButtonClickListener
			( parMouseEvent: MouseEvent ): void
		{
			// Вызов метода-обработчика события класса.
			this._MainTracer.CallClassEventListener( InformationScreen.CLASS_NAME,
				"ChoiceButtonClickListener", parMouseEvent );			
			
			// Объект, в котором находится объект-приёмник события -
			// кнопка выбора, на которой был клик мыши.
			var сhoiceButton: GlowButton = GlowButton
				( parMouseEvent.currentTarget );
			// Данные продажи разновидности диска,
			// закреплённые за нажатой кнопкой выбора.
			var diskVarietySaleData: DiskVarietySaleData =
				this._DiskVarietiesSalesDataDictionary[ сhoiceButton ];
				
			// Если данные продажи разновидности диска не определены.
			if ( diskVarietySaleData == null )
				// Данную разновидность диска нельзя выбрать для покупки
				// и ничего больше не происходит.			
				return;
				
			// Создание объекта экрана корзины покупок.
			this._ShopingCartScreen =	new ShopingCartScreen
				(
					// Парараметры базы данных MySQL.
					this._MySQLDatabaseParameters,		
					// Данные продажи разновидности диска.
					diskVarietySaleData,
					// Основные текстовые параметры.
					this._MainTextParameters,
					// Основные текстовые параметры.
					this._MainTracer,
					// Прямоугольная область экрана корзины покупок.
					this.getBounds( this ),
					// Прямоугольник окна - внутренний прямоугольник
					// в системе координат экрана информации.
					this._InnerRectangleInThisCoordinateSpace						
				); // new ShopingCartScreen
				
			// Помещение объекта экрана корзины покупок в объект экрана информации.
			this.addChild( this._ShopingCartScreen );				
			// Регистрирация объекта-прослушивателя события наступления
			// момента времени закрытия экрана корзины покупок.
			this._ShopingCartScreen.addEventListener
				( ShopingCartScreen.SHOULD_CLOSE,
				this.ShopingCartScreenShouldCloseListener );
		} // ChoiceButtonClickListener
		
		// Метод-прослушиватель события наступления момента времени
		// закрытия экрана корзины покупок.
		// Параметры:
		// parEvent - событие.
		private function ShopingCartScreenShouldCloseListener
			( parEvent: Event ): void
		{
			// Вызов метода-обработчика события класса.
			this._MainTracer.CallClassEventListener( InformationScreen.CLASS_NAME,
				"ShopingCartScreenShouldCloseListener", parEvent );			
			
			// Удаление объекта экрана корзины покупок
			// из списка потомков экземпляра данного эрана информации.
			this.removeChild( this._ShopingCartScreen );
			// Очищение объекта экрана корзины покупок.
			this._ShopingCartScreen = null;
		} // ShopingCartScreenShouldCloseListener
		//-----------------------------------------------------------------------	
		// Методы-конструкторы.

		// Метод-конструктор экземпляра экрана информации.
		// Параметры:
		// parMySQLDatabaseParameters - парараметры базы данных MySQL,
		// parDiskInformation         - информация диска,
		// parMainTextParameters      - основные текстовые параметры,
		// parMainTracer              - основной трассировщик,
		// parAreaRectangle           - прямоугольная область экрана информации,
		// parInformationRectangleBottomIndention - отступ
		//   прямоугольника информации от нижнего края экрана информации.
		public function InformationScreen
		(
		 	parMySQLDatabaseParameters: MySQLParameters,
			parDiskInformation:         ImageFilePathAndArticleInformation,
			parMainTextParameters:      TextParameters,
			parMainTracer:              Tracer,
			parAreaRectangle:           Rectangle,
			parInformationRectangleBottomIndention: Number
		): void
		{
			// Вызов метода-конструктора суперкласса Sprite.
			super( );	
			
			// Парараметры базы данных MySQL.
			this._MySQLDatabaseParameters = parMySQLDatabaseParameters;			
			// Информация диска.
			this._DiskInformation         = parDiskInformation;
			// Основные текстовые параметры.
			this._MainTextParameters      = parMainTextParameters;
			// Ocновной трассировщик.
			this._MainTracer              = parMainTracer;			
			// Абсцисса экрана информации.
			this.x                        = parAreaRectangle.x;
			// Ордината экрана информации.
			this.y                        = parAreaRectangle.y;
			// Определение прямоугольной области прокрутки экрана информации
			// заданной высоты и ширины.
			this.scrollRect = new Rectangle( 0, 0, parAreaRectangle.width,
				parAreaRectangle.height );
			
			// Создание нового экземпляра класса.
			this._MainTracer.CreateClassNewInstance( InformationScreen.CLASS_NAME,
				parMySQLDatabaseParameters, parDiskInformation, parMainTextParameters,
				parMainTracer, parAreaRectangle,
				parInformationRectangleBottomIndention );

			// Во весь экран информации,
			// рисутеся полностью прозрачный прямоугольник.
			
			// Начало рисования на экране информации в заданном режиме:
			// сплошная заливка чёрным цветом с абсолютной прозрачностью.
			this.graphics.beginFill( 0x0, 0 );
			// Рисуется прозрачный прямоугольник во весь экран информации.
			this.graphics.drawRect( 0, 0, parAreaRectangle.width,
				parAreaRectangle.height );
			// Окончание рисования на экране информации в заданном режиме.
			this.graphics.endFill( );
			
			// Отступ прямоугольника информации от нижнего края экрана информации.
			this._InformationRectangleBottomIndention =
				parInformationRectangleBottomIndention;
				
			// Инициализация фонового прямоугольника.
			this.InitializeBackgroundRectangle( );
			// Инициализация прямоугольника информации.
			this.InitializeInformationRectangle( );
			// Инициализация внешнего прямоугольника без бордюра.
			this.InitializeOuterRectangleWithoutBorder( );
			// Инициализация внешнего спрайта с эффектом.
			this.InitializeOuterEffectSprite( );
			// Инициализация внешнего прямоугольника.
			this.InitializeOuterRectangle( );
			// Инициализация внутреннего прямоугольника.
			this.InitializeInnerRectangle( );
			// Инициализация прямоугольника изображений.
			this.InitializeImagesRectangle( );
			// Инициализация прямоугольника текстов.
			this.InitializeTextsRectangle( );			
			// Инициализация прямоугольника изображения диска.
			this.InitializeDiskImageRectangle( );			
			// Инициализация границ проекции перспективы изображения диска.
			this.InitializeDiskImagePerspectiveProjectionBounds( );
			// Инициализация спрайта с эффектом
			// проекции перспективы изображения диска.
			this.InitializeDiskImagePerspectiveProjectionEffectSprite( );			
			// Инициализация проекции перспективы изображения диска.
			this.InitializeDiskImagePerspectiveProjection( );			
			// Инициализация строки слайдов.
			this.InitializeSlidesLine( );			
			// Инициализация выборщика URL-адресов видео-файлов диска.
			this.InitializeDiskVideosFilesURLsSelector( );
			
			// Регистрирация объекта-прослушивателя события достижения
			// таймером минимального показа интервала задержки в миллисекундах
			// между появлением экрана информации и наступлением момента,
			// когда он уже может передавать событие клика мыши на кнопке выхода.
			this._MinimumShowingTimer.addEventListener( TimerEvent.TIMER,
				this.MinimumShowingTimerTimerListener );				
		} // InformationScreen
		//-----------------------------------------------------------------------
		// Get- и set-методы.
		
		// Get-метод получения статического диспетчера событий.
		// Результат: статический диспетчер событий.
		public static function get StaticEventDispatcher( ): EventDispatcher
		{
			// Статический диспетчер событий.
			return InformationScreen._StaticEventDispatcher;
		} // StaticEventDispatcher		
		
		// Get-метод получения парараметров базы данных MySQL.
		// Результат: парараметры базы данных MySQL.
		public function get MySQLDatabaseParameters( ): MySQLParameters
		{
			// Парараметры базы данных MySQL.
			return this._MySQLDatabaseParameters;
		} // MySQLDatabaseParameters	
		
		// Get-метод получения информации диска.
		// Результат: информация диска.
		public function get DiskInformation( ):
			ImageFilePathAndArticleInformation
		{
			// Информация диска.
			return this._DiskInformation;
		} // DiskInformation
		
		// Get-метод получения основных текстовых параметров.
		// Результат: основные текстовые параметры.
		public function get MainTextParameters( ): TextParameters
		{
			// Основные текстовые параметры.
			return this._MainTextParameters;
		} // MainTextParameters		
		
		// Get-метод получения отступа прямоугольника информации
		// от нижнего края экрана информации.
		// Результат: отступ прямоугольника информации
		// от нижнего края экрана информации.
		public function get InformationRectangleBottomIndention( ): Number
		{
			// Отступ прямоугольника информации от нижнего края экрана информации.
			return this._InformationRectangleBottomIndention;
		} // InformationRectangleBottomIndention
		
		// Get-метод получения признака закрытого состояния экрана медиа-плеера.
		public function get MediaPlayerScreenIsClosed( ): Boolean
		{
			// Если экран медиа-плеера не определён.
			if ( this._MediaPlayerScreen == null )
				// Экран медиа-плеера закрыт.
				return true;
			// Если экран медиа-плеера проинициализирован.
			else
				// Экран медиа-плеера открыт.
				return false;
		} // MediaPlayerScreenIsClosed
	} // InformationScreen
} // nijanus.customerDesktop.display