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

	// Класс экрана корзины покупок.
	public class ShopingCartScreen extends Sprite
	{
		// Список импортированных классов из других пакетов.

		import flash.events.Event;
		import flash.events.EventDispatcher;
		import flash.events.IOErrorEvent;
		import flash.events.TimerEvent;	
		import flash.geom.Point;		
		import flash.geom.Rectangle;	
		import flash.net.URLLoader;		
		import flash.net.URLRequest;		
		import flash.text.TextField;
		import flash.text.TextFormat;
		import flash.text.TextFormatAlign;		
		import flash.utils.Timer;		
		import nijanus.customerDesktop.phpAndMySQL.DiskVarietySaleData;
		import nijanus.customerDesktop.phpAndMySQL.
			MySQLDiskVarietySaleDataToShoppingCartAdder;
		import nijanus.customerDesktop.phpAndMySQL.MySQLParameters;
		import nijanus.customerDesktop.text.TextParameters;
		import nijanus.display.AppearingWithIncreaseSprite;
		import nijanus.display.RectangleWithPerimeterBorder;
		import nijanus.display.TranslucentGraySprite;
		import nijanus.php.PHPRequester;
		import nijanus.utils.Tracer;
		//-----------------------------------------------------------------------
		// Статические константы.
		
		// Имя класса.
		public static const CLASS_NAME: String = "ShopingCartScreen";	
		
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
		public static const SHOULD_CLOSE: String = "ShouldClose";			
			
		// Сообщение об ошибке загрузки данных из файла статических параметров.
		public static const STATIC_PARAMETERS_FILE_URL_LOADING_IO_ERROR_MESSAGE:
			String = "Ошибка загрузки данных из файла статических параметров " +
			"класса ShopingCartScreen";
		// Сообщение об ошибке загрузки данных из файла демонстрационных
		// статических параметров.
		public static const
			DEMO_STATIC_PARAMETERS_FILE_URL_LOADING_IO_ERROR_MESSAGE:
			String = "Ошибка загрузки данных из файла демонстрационных " +
			"статических параметров класса ShopingCartScreen";
		// Сообщение об успешной загрузке данных продажи разновидности диска
		// в корзину покупок.
		public static const DISK_VARIETY_SALE_DATA_LOADING_COMPLETE_MESSAGE:
			String = "Добавлено в корзину покупок";
		// Сообщение об ошибке загрузки данных продажи разновидности диска
		// в корзину покупок.
		public static const DISK_VARIETY_SALE_DATA_LOADING_IO_ERROR_MESSAGE:
			String = "Не получается добавить в корзину покупок";
		//-----------------------------------------------------------------------
		// Статические переменные.
		
		// Статический диспетчер событий.
		private static var _StaticEventDispatcher: EventDispatcher =
			new EventDispatcher( );		
			
		// Интервал в миллисекундах таймера закрытия -
		// интервал между появлением экрана корзины покупок
		// и наступлением момента необходимости его закрытия.
		// Copyright Protection: [2000] - Full, [5000] - Demo.
		public static var ClosingTimerDelay: Number = 5000;//2000;		
		// Время в миллисекундах длительности эффекта изменения видимости -
		// время, в течение которого осуществляется эффект появления
		// или исчезновения спрайта с эффектом.
		public static var EffectTime:        Number = 400;
		// Коэффициент отношения реальной скорости эффекта появления
		// к реальной скорости эффекта исчезновения.
		public static var ShowingEffectVelocityToHidingEffectVelocityRatio:
			Number = 2.5;		
		
		// Коэффициент отношения высоты текстового поля сообщения
		// к высоте спрайт окна.
		public static var MessageTextFieldHeightToWindowSpriteHeightRatio:
			Number = 0.08;		
		// Коэффициент сжатия ширины строки текстового поля сообщения.
		public static var MessageTextFieldLineWidthCompressionRatio: Number = 5;
		// Коэффициент сжатия высоты строки текстового поля сообщения.
		public static var MessageTextFieldLineHeightCompressionRatio:
			Number = 1.1;	
		//-----------------------------------------------------------------------
		// Переменные экземпляра класса.
		
		// Параметры базы данных MySQL.
		private var _MySQLDatabaseParameters: MySQLParameters     = null;
		// Данные продажи разновидности диска.
		private var _SaleData:                DiskVarietySaleData = null;
		// Основные текстовые параметры.
		private var _MainTextParameters:      TextParameters      = null;
		// Основной трассировщик.
		private var _MainTracer:              Tracer              = null;
		// Добавитель данных продажи разновидности диска.
		private var _DiskVarietySaleDataAdder:
			MySQLDiskVarietySaleDataToShoppingCartAdder             = null;	
			
		// Таймер закрытия, который запускается 1 раз -
		// тогда, появившись, экран корзины покупок не передаёт событие
		// наступления момента времени его закрытия,
		// а потом по истечении времени таймера
		// экран корзины покупок уже передаёт это событие.
		private var _ClosingTimer: Timer =
			new Timer( ShopingCartScreen.ClosingTimerDelay, 1 );	
			
		// Фоновый спрайт - полупрозрачный фоновый спрайт,
		// полностью покрывающий экран корзины покупок.
		private var _BackgroundSprite:  TranslucentBackgroundSprite =
			new TranslucentBackgroundSprite( );
		// Спрайт с эффектом - спрайт, появляющийся с увеличением из ценрта
		// и исчезающий с уменьшением в центр, расположенный
		// поверх фонового спрайта, меньший, чем он, по размерам,
		// находящийся в композиционном центре относительно экрана информации,
		// на нём располагаются все элементы, кроме фонового спрайта,
		// и к ним применяется эффект.
		private var _EffectSprite:      AppearingWithIncreaseSprite;
		// Спрайт окна - серый полупрозрачный спрайт поверх фонового спрайта,
		// меньший, чем он, по размерам, расположенный в композиционном центре
		// относительно экрана информации, на нём размещается сообщение.
		private var _WindowSprite:      TranslucentGraySprite       =
			new	TranslucentGraySprite( );
		// Текстовое поле сообщения.
		private var _MessageTextField:  TextField = new TextField( );
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
				ShopingCartScreen.StaticParametersFileURLLoadingCompleteListener );				
			// Регистрирация объекта-прослушивателя события возникновения ошибки
			// при загрузке данных с URL-адреса файла статических параметров.
			staticParametersFileURLLoader.addEventListener( IOErrorEvent.IO_ERROR,
				ShopingCartScreen.StaticParametersFileURLLoadingIOErrorListener );	
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
				ShopingCartScreen.
				DemoStaticParametersFileURLLoadingCompleteListener );				
			// Регистрирация объекта-прослушивателя события возникновения ошибки
			// при загрузке данных с URL-адреса файла демонстрационных
			// статических параметров.
			demoStaticParametersFileURLLoader.addEventListener
				( IOErrorEvent.IO_ERROR, ShopingCartScreen.
				DemoStaticParametersFileURLLoadingIOErrorListener );	
		} // LoadDemoStaticParameters		
		//-----------------------------------------------------------------------
		// Методы экземпляра класса.
		
		// Метод инициализации фонового спрайта.
		private function InitializeBackgroundSprite( ): void		
		{
			// Вызов метода класса.
			this._MainTracer.CallClassMethod( ShopingCartScreen.CLASS_NAME,
				"InitializeBackgroundSprite" );			
			
			// Добавление фонового спрайта на экран корзины покупок.
			this.addChild( this._BackgroundSprite );	
			
			// Координаты фонового спрайта -
			// левый верхний угол экрана корзины покупок.
			this._BackgroundSprite.x      = 0;
			this._BackgroundSprite.y      = 0;
			// Размеры фонового спрайта - размеры экрана корзины покупок.
			this._BackgroundSprite.width  = this.width;
			this._BackgroundSprite.height = this.height;
		} // InitializeBackgroundSprite
		
		// Метод инициализации спрайта с эффектом.
		// Параметры:
		// parWindowRectangle - прямоугольник окна.
		private function InitializeEffectSprite
			( parWindowRectangle: Rectangle ): void
		{			
			// Вызов метода класса.
			this._MainTracer.CallClassMethod( ShopingCartScreen.CLASS_NAME,
				"InitializeEffectSprite", parWindowRectangle );
			
			// Прямоугольник окна - это границы без бордюра спрайта окна,
			// надо установить его истинные границы - с бордюром.
			
			// Границы - прямоугольник с бордюром по периметру,
			// соответствующий границам серого полупрозрачного спрайта,
			// каким является спрайт окна, нулевых размеров с теневым бордюром.
			var bounds: RectangleWithPerimeterBorder =
				new RectangleWithPerimeterBorder
				( TranslucentGraySprite.SHADOW_BORDER_WIDTH );				
			// Границы без бордюра - прямоугольник окна.
			bounds.BoundsWithoutBorder = parWindowRectangle;
			
			// Создание спрайта с эффектом
			// с границами прямоугольника окна с учётом бордюра.
			this._EffectSprite = new AppearingWithIncreaseSprite
				( bounds.BoundsWithBorder, ShopingCartScreen.EffectTime,
				ShopingCartScreen.ShowingEffectVelocityToHidingEffectVelocityRatio );
		} // InitializeEffectSprite
		
		// Метод инициализации спрайта окна.
		// Параметры:
		// parWindowRectangle - прямоугольник окна.
		private function InitializeWindowSprite
			( parWindowRectangle: Rectangle ): void
		{			
			// Вызов метода класса.
			this._MainTracer.CallClassMethod( ShopingCartScreen.CLASS_NAME,
				"InitializeWindowSprite", parWindowRectangle );			
		
			// Добавление спрайта окна на спрайт с эффектом.
			this._EffectSprite.addChild( this._WindowSprite );			
			// Устновка границ с бордюром спрайта окна
			// по границам внутреней области спрайта с эффектом.
			this._WindowSprite.BoundsWithBorder = this._EffectSprite.getBounds
				( this._EffectSprite );
		} // InitializeWindowSprite			
		
		// Метод инициализации текстового поля сообщения.
		private function InitializeMessageTextField( ): void	
		{
			// Вызов метода класса.
			this._MainTracer.CallClassMethod( ShopingCartScreen.CLASS_NAME,
				"InitializeMessageTextField" );			
			
			// Добавление текстового поля сообщения на спрайт с эффектом.
			this._EffectSprite.addChild( this._MessageTextField );

			// Ширина текстового поля сообщения - ширина спрайта окна без бордюра.
			this._MessageTextField.width  =
				this._WindowSprite.BoundsWithoutBorder.width;
			// Высота текстового поля сообщения:
			// произведение высота спрайта окна и коэффициента отношения
			// высоты текстового поля сообщения к высоте спрайт окна.
			this._MessageTextField.height = this._WindowSprite.height *
				ShopingCartScreen.MessageTextFieldHeightToWindowSpriteHeightRatio;
			// Абсциса текстового поля сообщения -
			// абсцисса спрайта окна без бордюра.
			this._MessageTextField.x = this._WindowSprite.BoundsWithoutBorder.x;
			// Ордината текстового поля сообщения:
			// сумма ординаты спрайта окна и половины разности
			// высоты спрайта окна и текстового поля сообщения.
			this._MessageTextField.y = this._WindowSprite.y +
				( this._WindowSprite.height - this._MessageTextField.height ) / 2;
				
			// Максимальное количество символов в строке сообщения.
			var messageMaximumLength: uint = uint
				(
					Math.max
					(
						ShopingCartScreen.
							DISK_VARIETY_SALE_DATA_LOADING_COMPLETE_MESSAGE.length,
						ShopingCartScreen.
							DISK_VARIETY_SALE_DATA_LOADING_IO_ERROR_MESSAGE.length
					) // Math.max
				); // uint
				
			// Признак получения сообщений мыши.
			this._MessageTextField.mouseEnabled      = false;			
			// Признак выполнения автоматической прокрути
			// многострочного текстового поля при вращении колёски мыши.
			this._MessageTextField.mouseWheelEnabled = false;			
			// Признак многострочности текстового поля.
			this._MessageTextField.multiline         = true;			
			// Признак наличия возможности выборра текстового поля.
			this._MessageTextField.selectable        = false;			
			// Признак влючения в последовательность перехода
			// с помощью клавиши Tab.
			this._MessageTextField.tabEnabled        = false;			
			// Цвет текста в текстовом поле -
			// светлый цвет шрифта текстовой метки особой светящейся кнопки.
			this._MessageTextField.textColor         =
				this._MainTextParameters.SpecialGlowButtonLabelFontLightColor;
			// Признак применения переноса по словам к текстовому полю.
			this._MessageTextField.wordWrap          = true;
			
			// Основной шрифт - не жирный.
			this._MainTextParameters.MainFontIsBold   = true;
			// Основной шрифт - не курсивный.
			this._MainTextParameters.MainFontIsItalic = false;
			
			// Размер шрифта текстового поля сообщения.
			var messageTextFieldFontSize: uint =
				this._MainTextParameters.MainFontParameters.GetTextAreaFontSize
				(
					// Размер области текста - размер текстового поля сообщения.
					new Point( this._MessageTextField.width,
						this._MessageTextField.height ),
					// Коэффициент сжатия ширины строки текста -
					// коэффициент сжатия ширины строки текстового поля сообщения.
					ShopingCartScreen.MessageTextFieldLineWidthCompressionRatio,
					// Коэффициент сжатия высоты строки текста -
					// коэффициент сжатия высоты строки текстового поля сообщения.
					ShopingCartScreen.MessageTextFieldLineHeightCompressionRatio,
					// Минимальный размер шрифта.
					this._MainTextParameters.MainFontMinimumSize,
					// Количество символов в строке текста -
					// максимальное количество символов в строке сообщения.
					messageMaximumLength
				); // GetTextAreaFontSize
				
			// Формат текста текстового поля сообщения по умолчанию,
			// применяемый ещё перед загрузкой туда текста.
			this._MessageTextField.defaultTextFormat =
				new TextFormat
				(
					// Имя шрифта для текста в виде строки.
					this._MainTextParameters.MainFontParameters.Name,
					// Размер шрифта текстового поля сообщения.
					messageTextFieldFontSize,
					// Светлый цвет шрифта текстовой метки особой светящейся кнопки.
					this._MainTextParameters.SpecialGlowButtonLabelFontLightColor,
					// Признак жирности шрифта текстового поля сообщения.
					this._MainTextParameters.MainFontParameters.IsBold,
					// Признак курсивного начертания шрифта текстового поля сообщения.
					this._MainTextParameters.MainFontParameters.IsItalic,
					// Признак подчёркнутого начертания шрифта
					// текстового поля сообщения.
					false,
					// URL-адрес, на который ссылается текст с этим форматом.
					// Если url представлен пустой строкой,
					// текст не имеет гиперссылки.
					TextParameters.EMPTY_STRNG,
					// Целевое окно, где отображается гиперссылка.
					null,
					// Выравнивание абзаца - по центру
					// в пределах текстового поля сообщения.
					TextFormatAlign.CENTER,
					// Левое поле абзаца (в пикселах).
					0,
					// Правое поле абзаца (в пикселах).
					0,
					// Целое число, указывающее отступ от левого поля
					// до первого символа в абзаце.
					0,
					// Число, указывающее величину
					// вертикального интервала между строками.
					0
				); // new TextFormat		
		} // InitializeMessageTextField		
		
		// Метод инициализации добавителя данных продажи разновидности диска.
		private function InitializeDiskVarietySaleDataAdder( ): void		
		{
			// Вызов метода класса.
			this._MainTracer.CallClassMethod( ShopingCartScreen.CLASS_NAME,
				"InitializeDiskVarietySaleDataAdder" );			
			
			// Добавитель данных продажи разновидности диска.
			this._DiskVarietySaleDataAdder =
				new MySQLDiskVarietySaleDataToShoppingCartAdder
				(
					this._MySQLDatabaseParameters.ConnectionAttributes,
					this._MySQLDatabaseParameters.
						DiskVarietySaleDataToShoppingCartAdderRequestPHPFileURL,
					this._MainTracer
				); // new MySQLDiskVarietySaleDataToShopingCartAdder
				
			// Имя таблицы корзины покупок.
			this._DiskVarietySaleDataAdder.ShoppingCartTableName     =
				this._MySQLDatabaseParameters.ShoppingCartTableName;
			// Имя столбца идентивикаторов в таблице корзины покупок.
			this._DiskVarietySaleDataAdder.ShoppingCartIDsColumnName =
				this._MySQLDatabaseParameters.ShoppingCartIDsColumnName;
			
			// Имя столбца идентивикаторов номенклатур в таблице корзины покупок.
			this._DiskVarietySaleDataAdder.ShoppingCartNomenclaturesIDsColumnName =
				this._MySQLDatabaseParameters.ShoppingCartNomenclaturesIDsColumnName;
			// Имя столбца идентивикаторов разновидностей дисков
			// в таблице корзины покупок.
			this._DiskVarietySaleDataAdder.
				ShoppingCartDisksVarietiesIDsColumnName =
				this._MySQLDatabaseParameters.ShoppingCartDisksVarietiesIDsColumnName;
			// Имя столбца цен в таблице корзины покупок.
			this._DiskVarietySaleDataAdder.ShoppingCartCostsColumnName            =
				this._MySQLDatabaseParameters.ShoppingCartCostsColumnName;
			// Имя столбца номеров ячеек в таблице корзины покупок.
			this._DiskVarietySaleDataAdder.ShoppingCartCellsNumbersColumnName     =
				this._MySQLDatabaseParameters.ShoppingCartCellsNumbersColumnName;
			
			// Данные продажи разновидности диска.
			this._DiskVarietySaleDataAdder.SaleData = this._SaleData;
				
			// Загрузка XML-результата при выполнении запроса к базе данных MySQL
			// на добавление данных продажи разновидности диска в корзину покупок.
			this._DiskVarietySaleDataAdder.LoadRequest( );
			// Регистрирация объекта-прослушивателя события успешной загрузки
			// XML-результата при выполнении запроса к базе данных MySQL
			// на добавление данных продажи разновидности диска в корзину покупок.
			this._DiskVarietySaleDataAdder.addEventListener
				( PHPRequester.REQUEST_LOADING_COMPLETE,
				this.DiskVarietySaleDataRequestXMLResultLoadingCompleteListener );				
			// Регистрирация объекта-прослушивателя события возникновения ошибки
			// при выполнении запроса к базе данных MySQL
			// на добавление данных продажи разновидности диска в корзину покупок.
			this._DiskVarietySaleDataAdder.addEventListener
				( PHPRequester.REQUEST_LOADING_IO_ERROR,
				this.DiskVarietySaleDataRequestXMLResultLoadingIOErrorListener );
		} // InitializeDiskVarietySaleDataAdder
		
		// Показ спрайта эффекта.
		public function ShowEffectSprite( ): void
		{
			// Вызов метода класса.
			this._MainTracer.CallClassMethod( ShopingCartScreen.CLASS_NAME,
				"ShowEffectSprite" );			
			
			// Установка параметров эффекта изменения видимости спрайта с эффектом.
			this._EffectSprite.GetEffectParameters( );
			// Показ спрайта с эффектом.
			this._EffectSprite.Show( );
			// Добавление спрайта с эффектом на экран корзины покупок.
			this.addChild( this._EffectSprite );
			// Регистрирация объекта-прослушивателя события завершения
			// эффекта появления спрайта с эффектом.
			this._EffectSprite.addEventListener
				( AppearingWithIncreaseSprite.SHOWING_EFFECT_EXECUTING_FINISHED,
				this.EffectSpriteShowingEffectExecutingFinishedListener );
		} // ShowEffectSprite		
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
			
			// Интервал в миллисекундах таймера закрытия.
			ShopingCartScreen.ClosingTimerDelay =
				staticParametersXML.ClosingTimerDelay[ 0 ];
			// Время в миллисекундах длительности эффекта изменения видимости.
			ShopingCartScreen.EffectTime = staticParametersXML.EffectTime[ 0 ];
			// Коэффициент отношения реальной скорости эффекта появления
			// к реальной скорости эффекта исчезновения.
			ShopingCartScreen.ShowingEffectVelocityToHidingEffectVelocityRatio =
				staticParametersXML.
				ShowingEffectVelocityToHidingEffectVelocityRatio[ 0 ];
				
			// Коэффициент отношения высоты текстового поля сообщения
			// к высоте спрайт окна.
			ShopingCartScreen.MessageTextFieldHeightToWindowSpriteHeightRatio =
				staticParametersXML.
				MessageTextFieldHeightToWindowSpriteHeightRatio[ 0 ];
			// Коэффициент сжатия ширины строки текстового поля сообщения.
			ShopingCartScreen.MessageTextFieldLineWidthCompressionRatio       =
				staticParametersXML.MessageTextFieldLineWidthCompressionRatio[ 0 ];
			// Коэффициент сжатия высоты строки текстового поля сообщения.
			ShopingCartScreen.MessageTextFieldLineHeightCompressionRatio      =
				staticParametersXML.MessageTextFieldLineHeightCompressionRatio[ 0 ];
			
			// Передача события успешной загрузки статических параметров,
			// целью - объбектом-получателем - которого является объект
			// статического диспетчера событий данного класса корзины покупок.
			ShopingCartScreen._StaticEventDispatcher.dispatchEvent( new Event
				( ShopingCartScreen.STATIC_PARAMETERS_LOADING_COMPLETE ) );
			// Передача события окончания загрузки статических параметров,
			// целью - объбектом-получателем - которого является объект
			// статического диспетчера событий данного класса корзины покупок.
			ShopingCartScreen._StaticEventDispatcher.dispatchEvent( new Event
				( ShopingCartScreen.STATIC_PARAMETERS_LOADING_FINISHED ) );
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
			trace( ShopingCartScreen.
				STATIC_PARAMETERS_FILE_URL_LOADING_IO_ERROR_MESSAGE );
			// Передача события возникновения ошибки
			// при загрузке статических параметров,
			// целью - объбектом-получателем - которого является объект
			// статического диспетчера событий данного класса корзины покупок.
			ShopingCartScreen._StaticEventDispatcher.dispatchEvent( new Event
				( ShopingCartScreen.STATIC_PARAMETERS_LOADING_IO_ERROR ) );			
			// Передача события окончания загрузки статических параметров,
			// целью - объбектом-получателем - которого является объект
			// статического диспетчера событий данного класса корзины покупок.
			ShopingCartScreen._StaticEventDispatcher.dispatchEvent( new Event
				( ShopingCartScreen.STATIC_PARAMETERS_LOADING_FINISHED ) );
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
			
			// Время в миллисекундах длительности эффекта изменения видимости.
			ShopingCartScreen.EffectTime = demoStaticParametersXML.EffectTime[ 0 ];
			// Коэффициент отношения реальной скорости эффекта появления
			// к реальной скорости эффекта исчезновения.
			ShopingCartScreen.ShowingEffectVelocityToHidingEffectVelocityRatio =
				demoStaticParametersXML.
				ShowingEffectVelocityToHidingEffectVelocityRatio[ 0 ];
				
			// Передача события окончания загрузки демонстрационных
			// статических параметров, целью - объбектом-получателем - которого
			// является объект статического диспетчера событий
			// данного класса корзины покупок.
			ShopingCartScreen._StaticEventDispatcher.dispatchEvent( new Event
				( ShopingCartScreen.DEMO_STATIC_PARAMETERS_LOADING_FINISHED ) );
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
			trace( ShopingCartScreen.
				DEMO_STATIC_PARAMETERS_FILE_URL_LOADING_IO_ERROR_MESSAGE );
			// Передача события возникновения ошибки
			// при загрузке демонстрационных статических параметров,
			// целью - объбектом-получателем - которого является объект
			// статического диспетчера событий данного класса корзины покупок.
			ShopingCartScreen._StaticEventDispatcher.dispatchEvent( new Event
				( ShopingCartScreen.DEMO_STATIC_PARAMETERS_LOADING_IO_ERROR ) );			
			// Передача события окончания загрузки демонстрационных
			// статических параметров, целью - объбектом-получателем - которого
			// является объект статического диспетчера событий
			// данного класса корзины покупок.
			ShopingCartScreen._StaticEventDispatcher.dispatchEvent( new Event
				( ShopingCartScreen.DEMO_STATIC_PARAMETERS_LOADING_FINISHED ) );
		} // DemoStaticParametersFileURLLoadingIOErrorListener
		
		// Метод-прослушиватель события успешной загрузки
		// XML-результата при выполнении запроса к базе данных MySQL
		// на добавление данных продажи разновидности диска в корзину покупок.
		// Параметры:
		// parEvent - событие.
		private function
			DiskVarietySaleDataRequestXMLResultLoadingCompleteListener
			( parEvent: Event ): void
		{
			// Вызов метода-обработчика события класса.
			this._MainTracer.CallClassEventListener( ShopingCartScreen.CLASS_NAME,
				"DiskVarietySaleDataRequestXMLResultLoadingCompleteListener",
				parEvent );				
			
			// Вывод сообщения об успешной загрузке данных продажи
			// разновидности диска в корзину покупок.
			this._MessageTextField.text =
				ShopingCartScreen.DISK_VARIETY_SALE_DATA_LOADING_COMPLETE_MESSAGE;
			// Показ спрайта эффекта.
			this.ShowEffectSprite( );				
		} // DiskVarietySaleDataRequestXMLResultLoadingCompleteListener
		
		// Метод-прослушиватель события возникновения ошибки
		// при выполнении запроса к базе данных MySQL
		// на добавление данных продажи разновидности диска в корзину покупок.
		// Параметры:
		// parIOErrorEvent - событие возникновения ошибки при выполнении
		//   операция отправки или загрузки.
		private function
			DiskVarietySaleDataRequestXMLResultLoadingIOErrorListener
			( parIOErrorEvent: IOErrorEvent ): void
		{
			// Вызов метода-обработчика события класса.
			this._MainTracer.CallClassEventListener( ShopingCartScreen.CLASS_NAME,
				"DiskVarietySaleDataRequestXMLResultLoadingIOErrorListener",
				parIOErrorEvent );			
			
			// Вывод сообщения об ошибке загрузки данных продажи
			// разновидности диска в корзину покупок.
			this._MessageTextField.text =
				ShopingCartScreen.DISK_VARIETY_SALE_DATA_LOADING_IO_ERROR_MESSAGE;
			// Показ спрайта эффекта.
			this.ShowEffectSprite( );				
		} // DiskVarietySaleDataRequestXMLResultLoadingIOErrorListener
		
		// Метод-прослушиватель события завершения эффекта появления
		// спрайта с эффектом.
		// Параметры:
		// parEvent - событие.
		private function EffectSpriteShowingEffectExecutingFinishedListener
			( parEvent: Event ): void
		{
			// Вызов метода-обработчика события класса.
			this._MainTracer.CallClassEventListener( ShopingCartScreen.CLASS_NAME,
				"EffectSpriteShowingEffectExecutingFinishedListener", parEvent );			
			
			// Запуск таймера закрытия.
			this._ClosingTimer.start( );
		} // EffectSpriteShowingEffectExecutingFinishedListener
		
		// Метод-прослушиватель события достижения таймером закрытия
		// интервала в миллисекундах между появлением экрана корзины покупок
		// и наступлением момента, необходимости его закрытия.
		// Параметры:
		// parTimerEvent - событие таймера.
		private function ClosingTimerTimerListener
			( parTimerEvent: TimerEvent ): void
		{
			// Вызов метода-обработчика события класса.
			this._MainTracer.CallClassEventListener( ShopingCartScreen.CLASS_NAME,
				"ClosingTimerTimerListener", parTimerEvent );	
			
			// Сокрытие спрайта с эффектом.
			this._EffectSprite.Hide( );
			// Регистрирация объекта-прослушивателя события завершения
			// эффекта исчезновения спрайта с эффектом.
			this._EffectSprite.addEventListener
				( AppearingWithIncreaseSprite.HIDING_EFFECT_EXECUTING_FINISHED,
				this.EffectSpriteHidingEffectExecutingFinishedListener );			
		} // ClosingTimerTimerListener
		
		// Метод-прослушиватель события завершения эффекта исчезновения
		// спрайта с эффектом.
		// Параметры:
		// parEvent - событие.
		private function EffectSpriteHidingEffectExecutingFinishedListener
			( parEvent: Event ): void
		{
			// Вызов метода-обработчика события класса.
			this._MainTracer.CallClassEventListener( ShopingCartScreen.CLASS_NAME,
				"EffectSpriteHidingEffectExecutingFinishedListener", parEvent );			
			
			// Событие таймера закрытия передаётся, когда прошло время показа
			// экрана корзины покупок, перед тем, как его надо закрыть.
			
			// Передача события наступления момента времени закрытия
			// в поток событий, целью - объбектом-получателем - которого
			// является данный объект экрана корзины покупок.
			this.dispatchEvent( new Event( ShopingCartScreen.SHOULD_CLOSE ) );
		} // EffectSpriteHidingEffectExecutingFinishedListener
		//-----------------------------------------------------------------------	
		// Методы-конструкторы.
		
		// Метод-конструктор экземпляра экрана корзины покупок.
		// Параметры:
		// parMySQLDatabaseParameters - парараметры базы данных MySQL,		
		// parSaleData                - данные продажи разновидности диска,
		// parMainTextParameters      - основные текстовые параметры,
		// parMainTracer              - основной трассировщик,
		// parAreaRectangle - прямоугольная область экрана корзины покупок,
		// parWindowRectangle         - прямоугольник окна.
		public function ShopingCartScreen
		(
		 	parMySQLDatabaseParameters: MySQLParameters,			
			parSaleData:                DiskVarietySaleData,
			parMainTextParameters:      TextParameters,
			parMainTracer:              Tracer,
			parAreaRectangle,
			parWindowRectangle:         Rectangle
		): void
		{
			// Вызов метода-конструктора суперкласса Sprite.
			super( );	
			
			// Парараметры базы данных MySQL.
			this._MySQLDatabaseParameters = parMySQLDatabaseParameters;	
			// Данные продажи разновидности диска.
			this._SaleData                = parSaleData;
			// Основные текстовые параметры.
			this._MainTextParameters      = parMainTextParameters;
			// Ocновной трассировщик.
			this._MainTracer              = parMainTracer;			
			// Абсцисса экрана корзины покупок.
			this.x                        = parAreaRectangle.x;
			// Ордината экрана корзины покупок.
			this.y                        = parAreaRectangle.y;
			// Определение прямоугольной области прокрутки экрана корзины покупок
			// заданной высоты и ширины.
			this.scrollRect = new Rectangle( 0, 0, parAreaRectangle.width,
				parAreaRectangle.height );
			
			// Создание нового экземпляра класса.
			this._MainTracer.CreateClassNewInstance( ShopingCartScreen.CLASS_NAME,
				parMySQLDatabaseParameters, parSaleData, parMainTextParameters,
				parMainTracer, parAreaRectangle, parWindowRectangle );			
			
			// Во весь экрана корзины покупок
			// рисутеся полностью прозрачный прямоугольник.
			
			// Начало рисования на экране корзины покупок в заданном режиме:
			// сплошная заливка чёрным цветом с абсолютной прозрачностью.
			this.graphics.beginFill( 0x0, 0 );
			// Рисуется прозрачный прямоугольник во весь экран корзины покупок.
			this.graphics.drawRect( 0, 0, parAreaRectangle.width,
				parAreaRectangle.height );
			// Окончание рисования на экране корзины покупок в заданном режиме.
			this.graphics.endFill( );
			
			// Инициализация фонового спрайта.
			this.InitializeBackgroundSprite( );
			// Инициализация спрайта с эффектом.
			this.InitializeEffectSprite( parWindowRectangle );
			// Инициализация спрайта окна.
			this.InitializeWindowSprite( parWindowRectangle );
			// Инициализация текстового поля сообщения.
			this.InitializeMessageTextField( );				
			// Инициализация добавителя данных продажи разновидности диска.
			this.InitializeDiskVarietySaleDataAdder( );
			
			// Регистрирация объекта-прослушивателя события достижения
			// таймером закрытия интервала в миллисекундах между появлением экрана
			// корзины покупок и наступлением момента, необходимости его закрытия.
			this._ClosingTimer.addEventListener( TimerEvent.TIMER,
				this.ClosingTimerTimerListener );
		} // ShopingCartScreen
		//-----------------------------------------------------------------------
		// Get- и set-методы.
		
		// Get-метод получения статического диспетчера событий.
		// Результат: статический диспетчер событий.
		public static function get StaticEventDispatcher( ): EventDispatcher
		{
			// Статический диспетчер событий.
			return ShopingCartScreen._StaticEventDispatcher;
		} // StaticEventDispatcher		
	} // ShopingCartScreen
} // nijanus.customerDesktop.display