// CustomerDesktop
// Author Kate Kotova
// NIJANUS Copyright © 2004-2010
// nijanus@ymail.com
// http://nijanus.narod2.ru
//---------------------------------------------------------------------------
// Пакет классов рабочего стола покупателя.
package nijanus.customerDesktop
{
	// Список импортированных классов из других пакетов.
	import flash.display.MovieClip;
	//-------------------------------------------------------------------------
	
	// Класс рабочего стола покупателя - основной класс.
	public class CustomerDesktop extends MovieClip
	{
		// Список импортированных классов из других пакетов.

		import flash.display.StageAlign;
		import flash.display.StageDisplayState;
		import flash.display.StageQuality;
		import flash.display.StageScaleMode;
		import flash.events.Event;
		import flash.events.EventDispatcher;
		import flash.events.MouseEvent;
		import flash.events.TimerEvent;		
		import flash.geom.Rectangle;
		import flash.system.fscommand;
		import flash.utils.Timer;
		import nijanus.customerDesktop.display.ChoiceScreen;
		import nijanus.customerDesktop.display.InformationScreen;
		import nijanus.customerDesktop.display.MediaPlayerScreen;
		import nijanus.customerDesktop.display.ShopingCartScreen;
		import nijanus.customerDesktop.phpAndMySQL.MySQLParameters;
		import nijanus.customerDesktop.text.TextParameters;
		import nijanus.display.GlowButton;
		import nijanus.display.GlowButtonParameters;
		import nijanus.display.ImagesLine;
		import nijanus.utils.Tracer;
		//-----------------------------------------------------------------------
		// Статические константы.
		
		// Имя класса.
		public static const CLASS_NAME: String = "CustomerDesktop";
		
		// Пути к файлам парараметров.
		
		// Путь к файлу статических параметров класса строки изображений.
		public static const IMAGES_LINE_STATIC_PARAMETERS_FILE_PATH:   String =
			"ImagesLineStaticParameters.xml";	
		// Путь к файлу статических параметров класса экрана выбора.
		public static const CHOICE_SCREEN_STATIC_PARAMETERS_FILE_PATH: String =
			"ChoiceScreenStaticParameters.xml";
		// Путь к файлу статических параметров класса экрана информации.
		public static const INFORMATION_SCREEN_STATIC_PARAMETERS_FILE_PATH:
			String = "InformationScreenStaticParameters.xml";
		// Путь к файлу демонстрационных статических параметров
		// класса экрана информации.
		public static const DEMO_INFORMATION_SCREEN_STATIC_PARAMETERS_FILE_PATH:
			String = "DemoInformationScreenStaticParameters.xml";			
		// Путь к файлу статических параметров класса экрана медиа-плеера.
		public static const MEDIA_PLAYER_SCREEN_STATIC_PARAMETERS_FILE_PATH:
			String = "MediaPlayerScreenStaticParameters.xml";
		// Путь к файлу демонстрационных статических параметров
		// класса экрана медиа-плеера.
		public static const DEMO_MEDIA_PLAYER_SCREEN_STATIC_PARAMETERS_FILE_PATH:
			String = "DemoMediaPlayerScreenStaticParameters.xml";	
		// Путь к файлу статических параметров класса экрана корзины покупок.
		public static const SHOPING_CART_SCREEN_STATIC_PARAMETERS_FILE_PATH:
			String = "ShopingCartScreenStaticParameters.xml";	
		// Путь к файлу демонстрационных статических параметров
		// класса экрана корзины покупок.
		public static const DEMO_SHOPING_CART_SCREEN_STATIC_PARAMETERS_FILE_PATH:
			String = "DemoShopingCartScreenStaticParameters.xml";	
		// Путь к файлу настроек основных парараметров MySQL.
		public static const MAIN_MYSQL_PARAMETERS_SETTINGS_FILE_PATH:  String =
			"MySQLParametersSettings.xml";
		// Путь к файлу демонстрационных настроек основных парараметров MySQL.
		public static const DEMO_MAIN_MYSQL_PARAMETERS_SETTINGS_FILE_PATH:
			String = "DemoMySQLParametersSettings.xml";
			
		// Сообщения.
			
		// Заголовок программы.
		public static const PROGRAM_TITLE:                            String =
			"CustomerDesktop 0.102, ZMediaPlayer 32. "         +
			"Created by NIJANUS in 2010. Author Kate Kotova. " +
			"nijanus@ymail.com, http://nijanus.narod2.ru";
		// Сообщение о неудачной загрузке параметров.
		public static const PARAMETERS_FAILED_LOADING_MESSAGE:        String =
			"не успешно :(";
		// Сообщение о загрузке параметров сцены.
		public static const STAGE_INITIALIZING_MESSAGE:               String =
			"Загрузка параметров сцены...";
		// Сообщение о загрузке параметров строки изображений.
		public static const IMAGES_LINE_STATIC_PARAMETERS_LOADING_MESSAGE:
			String = "Загрузка параметров строки изображений...";
		// Сообщение о загрузке параметров экрана выбора.
		public static const CHOICE_SCREEN_STATIC_PARAMETERS_LOADING_MESSAGE:
			String = "Загрузка параметров экрана выбора...";
		// Сообщение о загрузке параметров экрана информации.
		public static const
			INFORMATION_SCREEN_STATIC_PARAMETERS_LOADING_MESSAGE:       String =
			"Загрузка параметров экрана информации...";
		// Сообщение о загрузке демонстрационных параметров экрана информации.
		public static const
			DEMO_INFORMATION_SCREEN_STATIC_PARAMETERS_LOADING_MESSAGE:  String =
			"Загрузка демонстрационных параметров экрана информации...";			
		// Сообщение о загрузке параметров экрана медиа-плеера.
		public static const
			MEDIA_PLAYER_SCREEN_STATIC_PARAMETERS_LOADING_MESSAGE:      String =
			"Загрузка параметров экрана медиа-плеера...";
		// Сообщение о загрузке демонстрационных параметров экрана медиа-плеера.
		public static const
			DEMO_MEDIA_PLAYER_SCREEN_STATIC_PARAMETERS_LOADING_MESSAGE: String =
			"Загрузка демонстрационных параметров экрана медиа-плеера...";
		// Сообщение о загрузке параметров экрана корзины покупок.
		public static const
			SHOPING_CART_SCREEN_STATIC_PARAMETERS_LOADING_MESSAGE:      String =
			"Загрузка параметров экрана корзины покупок...";
		// Сообщение о загрузке демонстрационных параметров
		// экрана корзины покупок.
		public static const
			DEMO_SHOPING_CART_SCREEN_STATIC_PARAMETERS_LOADING_MESSAGE: String =
			"Загрузка демонстрационных параметров экрана корзины покупок...";
		// Сообщение о загрузке параметров PHP и MySQL.
		public static const MAIN_MYSQL_PARAMETERS_SETTINGS_LOADING_MESSAGE:
			String = "Загрузка параметров PHP и MySQL...";
			
		// Denwer.
			
		// Команда, выполняющая приложение из проекта. 
		public static const EXECUTING_APPLICATION_COMMAND: String = "exec";
		// Текстовая строка пути к файлу запуска Денвера. 
		public static const DENWER_START_FILE_PATH_STRING:
			String = "DenwerStart.exe";		
		// Задержка в миллисекундах таймера запуска Денвера -
		// задержка между открытием командного окна запуска Денвера
		// и его закрытием, когда Денвер запущен
		// и уже можно загружать компоненты программы рабочего стола покупателя.
		public static const DENWER_START_TIMER_DELAY:             Number = 90000;
		// Размер шрифта текстовой метки кнопки запуска программы.
		public static const PROGRAM_START_BUTTON_LABEL_FONT_SIZE: uint   = 25;		
		// Текстовая метка для кнопки запуска программы.
		public static const PROGRAM_START_BUTTON_LABEL:
			String = "Можно нажимать, если запущен Денвер";		
		// Коэффициент отношения ширины кнопки запуска программы к ширине сцены.
		public static const PROGRAM_START_BUTTON_WIDTH_TO_STAGE_WIDTH_RATIO:
			Number = 0.5;	
		// Коэффициент отношения высоты кнопки запуска программы к высоте сцены.
		public static const PROGRAM_START_BUTTON_HEIGHT_TO_STAGE_HEIGHT_RATIO:
			Number = 0.2;
			
		// Частота кадров рабочей области - число кадров в секунду.
		public static const STAGE_FRAME_RATE: Number = 200;
		//-----------------------------------------------------------------------
		// Переменные экземпляра класса.
		
		// Таймер запуска Денвера, который запускается 1 раз -
		// тогда, запустившись, программа рабочего стола покупателя
		// запускает Денвер, а потом по истечении времени таймера
		// загружает свои компоненты.
		private var _DenwerStartTimer:   Timer =
			new Timer( CustomerDesktop.DENWER_START_TIMER_DELAY, 1 );		
		// Кнопка запуска программы.
		private var _ProgramStartButton: GlowButton;
		
		// Основные парараметры MySQL.
		private var _MainMySQLParameters: MySQLParameters;		
		// Основные текстовые параметры.
		private var _MainTextParameters:  TextParameters = new TextParameters( );
		// Основной трассировщик.
		private var _MainTracer:            Tracer       = new Tracer( );
		// Трассировщик загрузки установок.
		private var _LoadingSettingsTracer: Tracer       = new Tracer( );		
		//-----------------------------------------------------------------------
		// Методы экземпляра класса.
		
		// Метод инициализации сцены.
		private function InitializeStage( ): void	
		{
			// Вызов метода класса.
			this._MainTracer.CallClassMethod( CustomerDesktop.CLASS_NAME,
				"InitializeStage" );			
			// Сообщение о загрузке параметров сцены.
			this._LoadingSettingsTracer.SendMessage
				( CustomerDesktop.STAGE_INITIALIZING_MESSAGE );		
			
			// Класс Stage представляет основную область рисования.
			// К объекту Stage нет глобального доступа.
			// Доступ к нему осуществляется через свойство stage
			// экземпляра DisplayObject.
			
			// Выравнивание рабочей области
			// в проигрывателе Flash Player или обозревателе:
			// выравнивание по вертикали - верхний край,
			// выравнивание по горизонтали - левый край.
			this.stage.align                  = StageAlign.TOP_LEFT;
			// Состояние отображения:
			// рабочая область разворачивается на весь экран пользователя,
			// а ввод с клавиатуры отключается.
			this.stage.displayState           = StageDisplayState.FULL_SCREEN;
			// Частота кадров рабочей области - число кадров в секунду.
			this.stage.frameRate              = CustomerDesktop.STAGE_FRAME_RATE;
			// Качество визуализации:
			// очень высокое качество визуализации, графика сглаживается
			// по сетке 4 x 4 пиксела, растровые изображения всегда смягчаются.
			this.stage.quality                = StageQuality.BEST;
			// Режим масштабирования:
			// фиксируется размер всего приложения, так что он сохраняется даже
			// при изменении размеров окна проигрывателя, если окно проигрывателя
			// меньше размеров содержимого, может возникнуть усечение.
			this.stage.scaleMode              = StageScaleMode.NO_SCALE;
			// Отображение или скрытие элементов по умолчанию
			// в контекстном меню Flash Player:
			// true - появляются все элементы контекстного меню,
			// false - отображаются только элементы меню "Параметры"
			// и "О проигрывателе Adobe Flash Player".
			this.stage.showDefaultContextMenu = false;
			// Признак отображения светящейся рамки вокруг объектов в фокусе. 
			this.stage.stageFocusRect         = false;
			// Признак включения перехода между потомками объекта с помощью Tab.
			this.stage.tabChildren            = false;
		} // InitializeStage
		
		// Метод инициализации кнопки запуска программы.
		private function InitializeProgramStartButton( ): void
		{
			// Параметры кнопки запуска программы.
			var programStartButtonParameters: GlowButtonParameters =
				new GlowButtonParameters( );
			// Размер шрифта текстовой метки кнопки запуска программы.
			programStartButtonParameters.LabelFontSize             =
				CustomerDesktop.PROGRAM_START_BUTTON_LABEL_FONT_SIZE;
			// Жирный шрифт  текстовой метки кнопки запуска программы.
			programStartButtonParameters.LabelFontIsBold           = true;			
			// Создание кнопки запуска программы.
			this._ProgramStartButton = new GlowButton
				( programStartButtonParameters );
			
			// Добавление кнопки запуска программы на сцену.
			this.addChild( this._ProgramStartButton );			
			// Текстовая метка для кнопки запуска программы.
			this._ProgramStartButton.label =
				CustomerDesktop.PROGRAM_START_BUTTON_LABEL;	
			
			// Ширина кнопки запуска программы:
			// произведение ширины сцены и коэффициента отношения
			// ширины кнопки запуска программы к ширине сцены.
			this._ProgramStartButton.width  = this.stage.stageWidth   *
				CustomerDesktop.PROGRAM_START_BUTTON_WIDTH_TO_STAGE_WIDTH_RATIO;
			// Высота кнопки запуска программы:
			// произведение высоты сцены и коэффициента отношения
			// высоты кнопки запуска программы к высоте сцены.
			this._ProgramStartButton.height = this.stage.stageHeight  *
				CustomerDesktop.PROGRAM_START_BUTTON_HEIGHT_TO_STAGE_HEIGHT_RATIO;
			// Абсцисса кнопки запуска программы:
			// половина разности ширины сцены и ширины кнопки запуска программы.
			this._ProgramStartButton.x      = ( this.stage.stageWidth  -
				this._ProgramStartButton.width  ) / 2;
			// Ордината кнопки запуска программы:
			// половина разности высоты сцены и высоты кнопки запуска программы.
			this._ProgramStartButton.y      = ( this.stage.stageHeight -
				this._ProgramStartButton.height ) / 2;
			
			// Регистрирация объекта-прослушивателя события
			// наступления момента времени запуска программы.
			this._ProgramStartButton.addEventListener ( MouseEvent.CLICK,
				this.ProgramStartTimeListener );
		} // InitializeProgramStartButton
		
		// Метод инициализации объекта экрана выбора.
		private function InitializeChoiceScreen( ): void	
		{
			// Вызов метода класса.
			this._MainTracer.CallClassMethod( CustomerDesktop.CLASS_NAME,
				"InitializeChoiceScreen" );			
			
			// Создание объекта экрана выбора.
			var choiceScreen: ChoiceScreen =
				new ChoiceScreen
				(
				 	// Основные парараметры MySQL.
					this._MainMySQLParameters,
					// Основные текстовые параметры.
					this._MainTextParameters,
					// Основной трассировщик.
					this._MainTracer,				
					// Прямоугольная область экрана выбора.
					new Rectangle
					(
						// Абсцисса - абсцисса сцены.
						0,
						// Ордината - ордината сцены.
						0,
						// Ширина   - ширина сцены.
						this.stage.stageWidth,
						// Высота   - высота сцены.
						this.stage.stageHeight	
					) // new Rectangle
				); // new ChoiceScreen
			// Помещение объекта экрана выбора на сцену.
			this.addChild( choiceScreen );
			
			// Сокрытие окна трассировщика загрузки установок.
			this._LoadingSettingsTracer.HideWindow( );			
		} // InitializeChoiceScreen
		
		// Метод загрузки статических параметров класса экрана медиа-плеера.
		private function LoadMediaPlayerScreenStaticParameters( ): void
		{
			// Загрузка статических параметров класса экрана медиа-плеера.
			MediaPlayerScreen.LoadStaticParameters
				( CustomerDesktop.MEDIA_PLAYER_SCREEN_STATIC_PARAMETERS_FILE_PATH );
			// Регистрирация объекта-прослушивателя события возникновения ошибки
			// при загрузке статических параметров класса экрана медиа-плеера.
			MediaPlayerScreen.StaticEventDispatcher.addEventListener
				( MediaPlayerScreen.STATIC_PARAMETERS_LOADING_IO_ERROR,
				this.MediaPlayerScreenStaticParametersLoadingIOErrorListener );
			// Регистрирация объекта-прослушивателя события успешной загрузки
			// статических параметров класса экрана медиа-плеера.
			MediaPlayerScreen.StaticEventDispatcher.addEventListener
				( MediaPlayerScreen.STATIC_PARAMETERS_LOADING_COMPLETE,
				this.MediaPlayerScreenStaticParametersLoadingCompleteListener );

			// Сообщение о загрузке параметров экрана медиа-плеера.
			this._LoadingSettingsTracer.SendMessage( CustomerDesktop.
				MEDIA_PLAYER_SCREEN_STATIC_PARAMETERS_LOADING_MESSAGE );
			// Обновление текстового поля сообщения окна
			// трассировщика загрузки установок.
			this._LoadingSettingsTracer.RefreshWindowMessageTextField( );
		} // LoadMediaPlayerScreenStaticParameters
		
		// Метод загрузки статических параметров класса экрана корзины покупок.
		private function LoadShopingCartScreenStaticParameters( ): void
		{		
			// Загрузка статических параметров класса экрана корзины покупок.
			ShopingCartScreen.LoadStaticParameters
				( CustomerDesktop.SHOPING_CART_SCREEN_STATIC_PARAMETERS_FILE_PATH );
			// Регистрирация объекта-прослушивателя события возникновения ошибки
			// при загрузке статических параметров класса экрана корзины покупок.
			ShopingCartScreen.StaticEventDispatcher.addEventListener
				( ShopingCartScreen.STATIC_PARAMETERS_LOADING_IO_ERROR,
				this.ShopingCartScreenStaticParametersLoadingIOErrorListener );				
			// Регистрирация объекта-прослушивателя события успешной загрузки
			// статических параметров класса экрана корзины покупок.
			ShopingCartScreen.StaticEventDispatcher.addEventListener
				( ShopingCartScreen.STATIC_PARAMETERS_LOADING_COMPLETE,
				this.ShopingCartScreenStaticParametersLoadingCompleteListener );
				
			// Сообщение о загрузке параметров экрана корзины покупок.
			this._LoadingSettingsTracer.SendMessage( CustomerDesktop.
				SHOPING_CART_SCREEN_STATIC_PARAMETERS_LOADING_MESSAGE );
			// Обновление текстового поля сообщения окна
			// трассировщика загрузки установок.
			this._LoadingSettingsTracer.RefreshWindowMessageTextField( );
		} // LoadShopingCartScreenStaticParameters
		
		// Метод загрузки основных параметров MySQL.
		private function LoadMainMySQLParameters( ): void
		{
			// Основные парараметры MySQL.
			this._MainMySQLParameters = new MySQLParameters
				( CustomerDesktop.MAIN_MYSQL_PARAMETERS_SETTINGS_FILE_PATH,
				CustomerDesktop.DEMO_MAIN_MYSQL_PARAMETERS_SETTINGS_FILE_PATH,
				this._MainTracer );	
			// Регистрирация объекта-прослушивателя события
			// окончания инициализации основных парараметров MySQL.
			this._MainMySQLParameters.addEventListener
				( MySQLParameters.INITIALIZED,
				this.MainMySQLParametersInitializedListener );
				
			// Сообщение о загрузке параметров PHP и MySQL.
			this._LoadingSettingsTracer.SendMessage
				( CustomerDesktop.MAIN_MYSQL_PARAMETERS_SETTINGS_LOADING_MESSAGE );
			// Обновление текстового поля сообщения окна
			// трассировщика загрузки установок.
			this._LoadingSettingsTracer.RefreshWindowMessageTextField( );		
		} // LoadMainMySQLParameters
		//-----------------------------------------------------------------------		
		// Методы-прослушиватели событий.
		
		// Метод-прослушиватель события
		// наступления момента времени запуска программы.
		// Параметры:
		// parEvent - событие.
		private function ProgramStartTimeListener( parEvent: Event ): void		
		{
			// Отмена регистрирации объектов-прослушивателей события
			// наступления момента времени запуска программы.
			this._DenwerStartTimer.removeEventListener  ( TimerEvent.TIMER,
				this.ProgramStartTimeListener );
			this._ProgramStartButton.removeEventListener( MouseEvent.CLICK,
				this.ProgramStartTimeListener );
			
			// Удаление кнопки запуска программы со сцены.
			this.removeChild( this._ProgramStartButton );			
			// Удаление кнопки запуска программы.
			this._ProgramStartButton = null;
			
			// Создания окна трассировщика загрузки установок.
			this._LoadingSettingsTracer.CreateWindow
			(
			 	// Родительский объект-контейнер окна.
				this,
				// Прямоугольная область окна.	
				new Rectangle( 0, 0, this.stage.stageWidth, this.stage.stageHeight )
			); // this._LoadingSettingsTracer.CreateWindow
			// Показ окна трассировщика загрузки установок.
			this._LoadingSettingsTracer.ShowWindow( );			
			
			// Загрузка статических параметров класса строки изображений.
			ImagesLine.LoadStaticParameters
				( CustomerDesktop.IMAGES_LINE_STATIC_PARAMETERS_FILE_PATH );
			// Регистрирация объекта-прослушивателя события возникновения ошибки
			// при загрузке статических параметров класса строки изображений.
			ImagesLine.StaticEventDispatcher.addEventListener
				( ImagesLine.STATIC_PARAMETERS_LOADING_IO_ERROR,
				this.ImagesLineStaticParametersLoadingIOErrorListener );				
			// Регистрирация объекта-прослушивателя события окончания загрузки
			// статических параметров класса строки изображений.
			ImagesLine.StaticEventDispatcher.addEventListener
				( ImagesLine.STATIC_PARAMETERS_LOADING_FINISHED,
				this.ImagesLineStaticParametersLoadingFinishedListener );
				
			// Сообщение о загрузке параметров строки изображений.
			this._LoadingSettingsTracer.SendMessage
				( CustomerDesktop.IMAGES_LINE_STATIC_PARAMETERS_LOADING_MESSAGE );
			// Обновление текстового поля сообщения окна
			// трассировщика загрузки установок.
			this._LoadingSettingsTracer.RefreshWindowMessageTextField( );
		} // ProgramStartTimeListener		
		
		// Метод-прослушиватель события клика мыши.
		// Параметры:
		// parMouseEvent - событие мыши.
		private function ClickListener( parMouseEvent: MouseEvent ):void
		{
			// Если одновременно с кликом мыши была нажата клавиша <Ctrl>.
			if ( parMouseEvent.ctrlKey )
			{	
				// Если окно основного трассировщика показано.
				if ( this._MainTracer.WindowIsShowing )
					// Сокрытие окна основного трассировщика.
					this._MainTracer.HideWindow( );
				// Если окно основного трассировщика не показано.
				else
					// Показ окна основного трассировщика.
					this._MainTracer.ShowWindow( );
			} // if
		} // ClickListener		
		
		// Метод-прослушиватель события возникновения ошибки
		// при загрузке статических параметров класса строки изображений.
		// Параметры:
		// parEvent - событие.
		private function ImagesLineStaticParametersLoadingIOErrorListener
			( parEvent: Event ): void
		{
			// Вызов метода-обработчика события класса.
			this._MainTracer.CallClassEventListener( CustomerDesktop.CLASS_NAME,
				"ImagesLineStaticParametersLoadingIOErrorListener", parEvent );
			// Послание сообщения об ошибке.
			this._MainTracer.SendErrorMessage
				( ImagesLine.STATIC_PARAMETERS_FILE_URL_LOADING_IO_ERROR_MESSAGE );
				
			// Сообщение о неудачной загрузке параметров.
			this._LoadingSettingsTracer.SendMessage
				( CustomerDesktop.PARAMETERS_FAILED_LOADING_MESSAGE );
			// Обновление текстового поля сообщения окна
			// трассировщика загрузки установок.
			this._LoadingSettingsTracer.RefreshWindowMessageTextField( );				
		} // ImagesLineStaticParametersLoadingIOErrorListener
		
		// Метод-прослушиватель события завершения загрузки
		// статических параметров класса строки изображений.
		// Параметры:
		// parEvent - событие.
		private function ImagesLineStaticParametersLoadingFinishedListener
			( parEvent: Event ): void
		{
			// Вызов метода-обработчика события класса.
			this._MainTracer.CallClassEventListener( CustomerDesktop.CLASS_NAME,
				"ImagesLineStaticParametersLoadingFinishedListener", parEvent );
			
			// Загрузка статических параметров класса экрана выбора.
			ChoiceScreen.LoadStaticParameters
				( CustomerDesktop.CHOICE_SCREEN_STATIC_PARAMETERS_FILE_PATH );
			// Регистрирация объекта-прослушивателя события возникновения ошибки
			// при загрузке статических параметров класса экрана выбора.
			ChoiceScreen.StaticEventDispatcher.addEventListener
				( ChoiceScreen.STATIC_PARAMETERS_LOADING_IO_ERROR,
				this.ChoiceScreenStaticParametersLoadingIOErrorListener );				
			// Регистрирация объекта-прослушивателя события окончания загрузки
			// статических параметров класса экрана выбора.
			ChoiceScreen.StaticEventDispatcher.addEventListener
				( ChoiceScreen.STATIC_PARAMETERS_LOADING_FINISHED,
				this.ChoiceScreenStaticParametersLoadingFinishedListener );	
				
			// Сообщение о загрузке параметров экрана выбора.
			this._LoadingSettingsTracer.SendMessage
				( CustomerDesktop.CHOICE_SCREEN_STATIC_PARAMETERS_LOADING_MESSAGE );
			// Обновление текстового поля сообщения окна
			// трассировщика загрузки установок.
			this._LoadingSettingsTracer.RefreshWindowMessageTextField( );				
		} // ImagesLineStaticParametersLoadingFinishedListener
		
		// Метод-прослушиватель события возникновения ошибки
		// при загрузке статических параметров класса экрана выбора.
		// Параметры:
		// parEvent - событие.
		private function ChoiceScreenStaticParametersLoadingIOErrorListener
			( parEvent: Event ): void
		{
			// Вызов метода-обработчика события класса.
			this._MainTracer.CallClassEventListener( CustomerDesktop.CLASS_NAME,
				"ChoiceScreenStaticParametersLoadingIOErrorListener", parEvent );
			// Послание сообщения об ошибке.
			this._MainTracer.SendErrorMessage
				( ChoiceScreen.STATIC_PARAMETERS_FILE_URL_LOADING_IO_ERROR_MESSAGE );
				
			// Сообщение о неудачной загрузке параметров.
			this._LoadingSettingsTracer.SendMessage
				( CustomerDesktop.PARAMETERS_FAILED_LOADING_MESSAGE );
			// Обновление текстового поля сообщения окна
			// трассировщика загрузки установок.
			this._LoadingSettingsTracer.RefreshWindowMessageTextField( );				
		} // ChoiceScreenStaticParametersLoadingIOErrorListener		
		
		// Метод-прослушиватель события завершения загрузки
		// статических параметров класса экрана выбора.
		// Параметры:
		// parEvent - событие.
		private function ChoiceScreenStaticParametersLoadingFinishedListener
			( parEvent: Event ): void
		{
			// Вызов метода-обработчика события класса.
			this._MainTracer.CallClassEventListener( CustomerDesktop.CLASS_NAME,
				"ChoiceScreenStaticParametersLoadingFinishedListener", parEvent );
			
			// Загрузка статических параметров класса экрана информации.
			InformationScreen.LoadStaticParameters
				( CustomerDesktop.INFORMATION_SCREEN_STATIC_PARAMETERS_FILE_PATH );
			// Регистрирация объекта-прослушивателя события возникновения ошибки
			// при загрузке статических параметров класса экрана информации.
			InformationScreen.StaticEventDispatcher.addEventListener
				( InformationScreen.STATIC_PARAMETERS_LOADING_IO_ERROR,
				this.InformationScreenStaticParametersLoadingIOErrorListener );			
			// Регистрирация объекта-прослушивателя события успешной загрузки
			// статических параметров класса экрана информации.
			InformationScreen.StaticEventDispatcher.addEventListener
				( InformationScreen.STATIC_PARAMETERS_LOADING_COMPLETE,
				this.InformationScreenStaticParametersLoadingCompleteListener );
			
			// Сообщение о загрузке параметров экрана информации.
			this._LoadingSettingsTracer.SendMessage( CustomerDesktop.
				INFORMATION_SCREEN_STATIC_PARAMETERS_LOADING_MESSAGE );
			// Обновление текстового поля сообщения окна
			// трассировщика загрузки установок.
			this._LoadingSettingsTracer.RefreshWindowMessageTextField( );				
		} // ChoiceScreenStaticParametersLoadingFinishedListener
		
		// Метод-прослушиватель события возникновения ошибки
		// при загрузке статических параметров класса экрана информации.
		// Параметры:
		// parEvent - событие.
		private function InformationScreenStaticParametersLoadingIOErrorListener
			( parEvent: Event ): void
		{
			// Вызов метода-обработчика события класса.
			this._MainTracer.CallClassEventListener( CustomerDesktop.CLASS_NAME,
				"InformationScreenStaticParametersLoadingIOErrorListener",
				parEvent );
			// Послание сообщения об ошибке.
			this._MainTracer.SendErrorMessage( InformationScreen.
				STATIC_PARAMETERS_FILE_URL_LOADING_IO_ERROR_MESSAGE );
			
			// Сообщение о неудачной загрузке параметров.
			this._LoadingSettingsTracer.SendMessage
				( CustomerDesktop.PARAMETERS_FAILED_LOADING_MESSAGE );
			// Обновление текстового поля сообщения окна
			// трассировщика загрузки установок.
			this._LoadingSettingsTracer.RefreshWindowMessageTextField( );
			
			// Загрузка демонстрационных статических параметров
			// класса экрана информации.
			InformationScreen.LoadDemoStaticParameters( CustomerDesktop.
				DEMO_INFORMATION_SCREEN_STATIC_PARAMETERS_FILE_PATH );
			// Регистрирация объекта-прослушивателя события возникновения ошибки
			// при загрузке демонстрационных статических параметров
			// класса экрана информации.
			InformationScreen.StaticEventDispatcher.addEventListener
				( InformationScreen.DEMO_STATIC_PARAMETERS_LOADING_IO_ERROR,
				this.DemoInformationScreenStaticParametersLoadingIOErrorListener );
			// Регистрирация объекта-прослушивателя события окончания загрузки
			// демонстрационных статических параметров класса экрана информации.
			InformationScreen.StaticEventDispatcher.addEventListener
				( InformationScreen.DEMO_STATIC_PARAMETERS_LOADING_FINISHED,
				this.DemoInformationScreenStaticParametersLoadingFinishedListener );
			
			// Сообщение о загрузке демонстрационных параметров экрана информации.
			this._LoadingSettingsTracer.SendMessage( CustomerDesktop.
				DEMO_INFORMATION_SCREEN_STATIC_PARAMETERS_LOADING_MESSAGE );
			// Обновление текстового поля сообщения окна
			// трассировщика загрузки установок.
			this._LoadingSettingsTracer.RefreshWindowMessageTextField( );			
		} // InformationScreenStaticParametersLoadingIOErrorListener		
		
		// Метод-прослушиватель события успешной загрузки
		// статических параметров класса экрана информации.
		// Параметры:
		// parEvent - событие.
		private function InformationScreenStaticParametersLoadingCompleteListener
			( parEvent: Event ): void
		{
			// Вызов метода-обработчика события класса.
			this._MainTracer.CallClassEventListener( CustomerDesktop.CLASS_NAME,
				"InformationScreenStaticParametersLoadingCompleteListener",
				parEvent );
			
			// Загрузка статических параметров класса экрана медиа-плеера.
			this.LoadMediaPlayerScreenStaticParameters( );
		} // InformationScreenStaticParametersLoadingCompleteListener
		
		// Метод-прослушиватель события возникновения ошибки при загрузке
		// демонстрационных статических параметров класса экрана информации.
		// Параметры:
		// parEvent - событие.
		private function
			DemoInformationScreenStaticParametersLoadingIOErrorListener
			( parEvent: Event ): void
		{
			// Вызов метода-обработчика события класса.
			this._MainTracer.CallClassEventListener( CustomerDesktop.CLASS_NAME,
				"DemoInformationScreenStaticParametersLoadingIOErrorListener",
				parEvent );
			// Послание сообщения об ошибке.
			this._MainTracer.SendErrorMessage( InformationScreen.
				DEMO_STATIC_PARAMETERS_FILE_URL_LOADING_IO_ERROR_MESSAGE );
			
			// Сообщение о неудачной загрузке параметров.
			this._LoadingSettingsTracer.SendMessage
				( CustomerDesktop.PARAMETERS_FAILED_LOADING_MESSAGE );
			// Обновление текстового поля сообщения окна
			// трассировщика загрузки установок.
			this._LoadingSettingsTracer.RefreshWindowMessageTextField( );
		} // DemoInformationScreenStaticParametersLoadingIOErrorListener
		
		// Метод-прослушиватель события завершения загрузки демонстрационных
		// статических параметров класса экрана информации.
		// Параметры:
		// parEvent - событие.
		private function
			DemoInformationScreenStaticParametersLoadingFinishedListener
			( parEvent: Event ): void
		{
			// Вызов метода-обработчика события класса.
			this._MainTracer.CallClassEventListener( CustomerDesktop.CLASS_NAME,
				"DemoInformationScreenStaticParametersLoadingFinishedListener",
				parEvent );
		
			// Загрузка статических параметров класса экрана медиа-плеера.
			this.LoadMediaPlayerScreenStaticParameters( );
		} // DemoInformationScreenStaticParametersLoadingFinishedListener
	
		// Метод-прослушиватель события возникновения ошибки
		// при загрузке статических параметров класса экрана медиа-плеера.
		// Параметры:
		// parEvent - событие.
		private function MediaPlayerScreenStaticParametersLoadingIOErrorListener
			( parEvent: Event ): void
		{
			// Вызов метода-обработчика события класса.
			this._MainTracer.CallClassEventListener( CustomerDesktop.CLASS_NAME,
				"MediaPlayerScreenStaticParametersLoadingIOErrorListener",
				parEvent );
			// Послание сообщения об ошибке.
			this._MainTracer.SendErrorMessage( MediaPlayerScreen.
				STATIC_PARAMETERS_FILE_URL_LOADING_IO_ERROR_MESSAGE );
			
			// Сообщение о неудачной загрузке параметров.
			this._LoadingSettingsTracer.SendMessage
				( CustomerDesktop.PARAMETERS_FAILED_LOADING_MESSAGE );
			// Обновление текстового поля сообщения окна
			// трассировщика загрузки установок.
			this._LoadingSettingsTracer.RefreshWindowMessageTextField( );	
			
			// Загрузка демонстрационных статических параметров
			// класса экрана медиа-плеера.
			MediaPlayerScreen.LoadDemoStaticParameters( CustomerDesktop.
				DEMO_MEDIA_PLAYER_SCREEN_STATIC_PARAMETERS_FILE_PATH );
			// Регистрирация объекта-прослушивателя события возникновения ошибки
			// при загрузке демонстрационных статических параметров
			// класса экрана медиа-плеера.
			MediaPlayerScreen.StaticEventDispatcher.addEventListener
				( MediaPlayerScreen.DEMO_STATIC_PARAMETERS_LOADING_IO_ERROR,
				this.DemoMediaPlayerScreenStaticParametersLoadingIOErrorListener );
			// Регистрирация объекта-прослушивателя события окончания загрузки
			// демонстрационных статических параметров
			// класса экрана медиа-плеера.
			MediaPlayerScreen.StaticEventDispatcher.addEventListener
				( MediaPlayerScreen.DEMO_STATIC_PARAMETERS_LOADING_FINISHED,
				this.DemoMediaPlayerScreenStaticParametersLoadingFinishedListener );
			
			// Сообщение о загрузке демонстрационных параметров
			// экрана медиа-плеера.
			this._LoadingSettingsTracer.SendMessage( CustomerDesktop.
				DEMO_MEDIA_PLAYER_SCREEN_STATIC_PARAMETERS_LOADING_MESSAGE );
			// Обновление текстового поля сообщения окна
			// трассировщика загрузки установок.
			this._LoadingSettingsTracer.RefreshWindowMessageTextField( );			
		} // MediaPlayerScreenStaticParametersLoadingIOErrorListener	
		
		// Метод-прослушиватель события успешной загрузки
		// статических параметров класса экрана медиа-плеера.
		// Параметры:
		// parEvent - событие.
		private function MediaPlayerScreenStaticParametersLoadingCompleteListener
			( parEvent: Event ): void
		{
			// Вызов метода-обработчика события класса.
			this._MainTracer.CallClassEventListener( CustomerDesktop.CLASS_NAME,
				"MediaPlayerScreenStaticParametersLoadingCompleteListener",
				parEvent );
		
			// Загрузка статических параметров класса экрана корзины покупок.
			this.LoadShopingCartScreenStaticParameters( );
		} // MediaPlayerScreenStaticParametersLoadingCompleteListener
		
		// Метод-прослушиватель события возникновения ошибки при загрузке
		// демонстрационных статических параметров класса экрана медиа-плеера.
		// Параметры:
		// parEvent - событие.
		private function
			DemoMediaPlayerScreenStaticParametersLoadingIOErrorListener
			( parEvent: Event ): void
		{
			// Вызов метода-обработчика события класса.
			this._MainTracer.CallClassEventListener( CustomerDesktop.CLASS_NAME,
				"DemoMediaPlayerScreenStaticParametersLoadingIOErrorListener",
				parEvent );
			// Послание сообщения об ошибке.
			this._MainTracer.SendErrorMessage( MediaPlayerScreen.
				DEMO_STATIC_PARAMETERS_FILE_URL_LOADING_IO_ERROR_MESSAGE );
			
			// Сообщение о неудачной загрузке параметров.
			this._LoadingSettingsTracer.SendMessage
				( CustomerDesktop.PARAMETERS_FAILED_LOADING_MESSAGE );
			// Обновление текстового поля сообщения окна
			// трассировщика загрузки установок.
			this._LoadingSettingsTracer.RefreshWindowMessageTextField( );
		} // DemoMediaPlayerScreenStaticParametersLoadingIOErrorListener
		
		// Метод-прослушиватель события завершения загрузки демонстрационных
		// статических параметров класса экрана медиа-плеера.
		// Параметры:
		// parEvent - событие.
		private function
			DemoMediaPlayerScreenStaticParametersLoadingFinishedListener
			( parEvent: Event ): void
		{
			// Вызов метода-обработчика события класса.
			this._MainTracer.CallClassEventListener( CustomerDesktop.CLASS_NAME,
				"DemoMediaPlayerScreenStaticParametersLoadingFinishedListener",
				parEvent );
		
			// Загрузка статических параметров класса экрана корзины покупок.
			this.LoadShopingCartScreenStaticParameters( );
		} // DemoMediaPlayerScreenStaticParametersLoadingFinishedListener
		
		// Метод-прослушиватель события возникновения ошибки
		// при загрузке статических параметров класса экрана корзины покупок.
		// Параметры:
		// parEvent - событие.
		private function ShopingCartScreenStaticParametersLoadingIOErrorListener
			( parEvent: Event ): void
		{
			// Вызов метода-обработчика события класса.
			this._MainTracer.CallClassEventListener( CustomerDesktop.CLASS_NAME,
				"ShopingCartScreenStaticParametersLoadingIOErrorListener",
				parEvent );
			// Послание сообщения об ошибке.
			this._MainTracer.SendErrorMessage( ShopingCartScreen.
				STATIC_PARAMETERS_FILE_URL_LOADING_IO_ERROR_MESSAGE );
			
			// Сообщение о неудачной загрузке параметров.
			this._LoadingSettingsTracer.SendMessage
				( CustomerDesktop.PARAMETERS_FAILED_LOADING_MESSAGE );
			// Обновление текстового поля сообщения окна
			// трассировщика загрузки установок.
			this._LoadingSettingsTracer.RefreshWindowMessageTextField( );
			
			// Загрузка демонстрационных статических параметров
			// класса экрана корзины покупок.
			ShopingCartScreen.LoadDemoStaticParameters( CustomerDesktop.
				DEMO_SHOPING_CART_SCREEN_STATIC_PARAMETERS_FILE_PATH );
			// Регистрирация объекта-прослушивателя события возникновения ошибки
			// при загрузке демонстрационных статических параметров
			// класса экрана корзины покупок.
			ShopingCartScreen.StaticEventDispatcher.addEventListener
				( ShopingCartScreen.DEMO_STATIC_PARAMETERS_LOADING_IO_ERROR,
				this.DemoShopingCartScreenStaticParametersLoadingIOErrorListener );				
			// Регистрирация объекта-прослушивателя события окончания загрузки
			// демонстрационных статических параметров
			// класса экрана корзины покупок.
			ShopingCartScreen.StaticEventDispatcher.addEventListener
				( ShopingCartScreen.DEMO_STATIC_PARAMETERS_LOADING_FINISHED,
				this.DemoShopingCartScreenStaticParametersLoadingFinishedListener );
				
			// Сообщение о загрузке демонстрационных параметров
			// экрана корзины покупок.
			this._LoadingSettingsTracer.SendMessage( CustomerDesktop.
				DEMO_SHOPING_CART_SCREEN_STATIC_PARAMETERS_LOADING_MESSAGE );
			// Обновление текстового поля сообщения окна
			// трассировщика загрузки установок.
			this._LoadingSettingsTracer.RefreshWindowMessageTextField( );			
		} // ShopingCartScreenStaticParametersLoadingIOErrorListener
		
		// Метод-прослушиватель события успешной загрузки
		// статических параметров класса экрана корзины покупок.
		// Параметры:
		// parEvent - событие.
		private function ShopingCartScreenStaticParametersLoadingCompleteListener
			( parEvent: Event ): void
		{
			// Вызов метода-обработчика события класса.
			this._MainTracer.CallClassEventListener( CustomerDesktop.CLASS_NAME,
				"ShopingCartScreenStaticParametersLoadingCompleteListener",
				parEvent );
			
			// Загрузка основных параметров MySQL.
			this.LoadMainMySQLParameters( );
		} // ShopingCartScreenStaticParametersLoadingCompleteListener
		
		// Метод-прослушиватель события возникновения ошибки при загрузке
		// демонстрационных статических параметров класса экрана корзины покупок.
		// Параметры:
		// parEvent - событие.
		private function
			DemoShopingCartScreenStaticParametersLoadingIOErrorListener
			( parEvent: Event ): void
		{
			// Вызов метода-обработчика события класса.
			this._MainTracer.CallClassEventListener( CustomerDesktop.CLASS_NAME,
				"DemoShopingCartScreenStaticParametersLoadingIOErrorListener",
				parEvent );
			// Послание сообщения об ошибке.
			this._MainTracer.SendErrorMessage( ShopingCartScreen.
				DEMO_STATIC_PARAMETERS_FILE_URL_LOADING_IO_ERROR_MESSAGE );
			
			// Сообщение о неудачной загрузке параметров.
			this._LoadingSettingsTracer.SendMessage
				( CustomerDesktop.PARAMETERS_FAILED_LOADING_MESSAGE );
			// Обновление текстового поля сообщения окна
			// трассировщика загрузки установок.
			this._LoadingSettingsTracer.RefreshWindowMessageTextField( );			
		} // DemoShopingCartScreenStaticParametersLoadingIOErrorListener		
		
		// Метод-прослушиватель события завершения загрузки демонстрационных
		// статических параметров класса экрана корзины покупок.
		// Параметры:
		// parEvent - событие.
		private function
			DemoShopingCartScreenStaticParametersLoadingFinishedListener
			( parEvent: Event ): void
		{
			// Вызов метода-обработчика события класса.
			this._MainTracer.CallClassEventListener( CustomerDesktop.CLASS_NAME,
				"DemoShopingCartScreenStaticParametersLoadingFinishedListener",
				parEvent );
			
			// Загрузка основных параметров MySQL.
			this.LoadMainMySQLParameters( );
		} // DemoShopingCartScreenStaticParametersLoadingFinishedListener		
		
		// Метод-прослушиватель события
		// окончания инициализации основных парараметров MySQL.
		// Параметры:
		// parEvent - событие.
		private function MainMySQLParametersInitializedListener
			( parEvent: Event ): void
		{
			// Вызов метода-обработчика события класса.
			this._MainTracer.CallClassEventListener( CustomerDesktop.CLASS_NAME,
				"MainMySQLParametersInitializedListener", parEvent );
			
			// Инициализация объекта экрана выбора.
			this.InitializeChoiceScreen( );			
		} // MainMySQLParametersInitializedListener
		//-----------------------------------------------------------------------		
		// Методы-конструкторы.

		// Метод-конструктор экземпляра рабочего стола покупателя -
		// точка входа в программу.
		public function CustomerDesktop( ): void
		{
			// Создание нового экземпляра класса.
			this._MainTracer.CreateClassNewInstance( CustomerDesktop.CLASS_NAME );			
			// Заголовок программы.
			this._LoadingSettingsTracer.SendMessage
				( CustomerDesktop.PROGRAM_TITLE );
				
			// Вызов команды, запускающей Денвер. 
			fscommand( CustomerDesktop.EXECUTING_APPLICATION_COMMAND,
				CustomerDesktop.DENWER_START_FILE_PATH_STRING );			
			// Регистрирация объекта-прослушивателя события
			// наступления момента времени запуска программы.
			this._DenwerStartTimer.addEventListener( TimerEvent.TIMER,
				this.ProgramStartTimeListener );
			// Запуск таймера запуска Денвера.
			this._DenwerStartTimer.start( );				

			// Инициализация сцены.
			this.InitializeStage( );
			
			// Создания окна основного трассировщика.
			this._MainTracer.CreateWindow
			(
			 	// Родительский объект-контейнер окна.
				this,
				// Прямоугольная область окна.	
				new Rectangle( 0, 0, this.stage.stageWidth, this.stage.stageHeight )
			); // this._MainTracer.CreateWindow
			// Регистрирация объекта-прослушивателя события клика мыши
			// для вызова осноного трассировщика.
			this.addEventListener( MouseEvent.CLICK , this.ClickListener );
			
			// Инициализация кнопки запуска программы.
			this.InitializeProgramStartButton( );
		} // CustomerDesktop
	} // CustomerDesktop
} // nijanus.customerDesktop