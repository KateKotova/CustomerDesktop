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

	// Класс экрана медиа-плеера.
	public class MediaPlayerScreen extends Sprite
	{
		// Список импортированных классов из других пакетов.

		import flash.events.Event;
		import flash.events.EventDispatcher;
		import flash.events.IOErrorEvent;
		import flash.geom.Rectangle;
		import flash.net.URLLoader;
		import flash.net.URLRequest;
		import nijanus.customerDesktop.phpAndMySQL.MediaPlayerOpener;
		import nijanus.customerDesktop.phpAndMySQL.MySQLParameters;	
		import nijanus.customerDesktop.phpAndMySQL.SlideType;
		import nijanus.customerDesktop.utils.SlideFilePathAndTypeInformation;
		import nijanus.php.PHPRequester;
		import nijanus.utils.Tracer;
		//-----------------------------------------------------------------------
		// Статические константы.
		
		// Имя класса.
		public static const CLASS_NAME: String = "MediaPlayerScreen";
		
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
			"класса MediaPlayerScreen";
		// Сообщение об ошибке загрузки данных из файла демонстрационных
		// статических параметров.
		public static const
			DEMO_STATIC_PARAMETERS_FILE_URL_LOADING_IO_ERROR_MESSAGE:
			String = "Ошибка загрузки данных из файла демонстрационных " +
			"статических параметров класса MediaPlayerScreen";
		//-----------------------------------------------------------------------
		// Статические переменные.
		
		// Статический диспетчер событий.
		private static var _StaticEventDispatcher: EventDispatcher =
			new EventDispatcher( );		
		
		// Интервал в миллисекундах таймера закрытия - интервал
		// между наступлением паузы или остановки проигрывания меда-файла
		// и моментом закрытия медиа-плеера, который считается бездействующим.
		// Copyright Protection: [300000] - Full, [60000] - Demo.
		public static var ClosingTimerDelay:               Number = 60000;//300000;
		// Время в миллисекундах длительности эффекта изменения видимости -
		// время, в течение которого осуществляется эффект появления
		// или исчезновения формы.
		public static var VisibleChangingEffectTime:       Number = 200;
		// Интервал в миллисекундах таймера эффекта изменения видимости.
		public static var VisibleChangingEffectTimerDeley: Number = 20;
		// Интервал в миллисекундах таймера сокрытия формы звука -
		// интервал между моментом покидания кнопки звука
		// или формы звука курсором мыши и моментом сокрытия формы звука.
		public static var SoundFormHidingTimerDeley:       Number = 1000;
		
		// Доля ширины кнопки от её высоты.
		public static var ButtonWidthToHeightRatio:                Number = 1.3;
		// Доля ширины трека прокрутки длительности от ширины командной панели.
		public static var DurationTrackbarWidthToCommandPanelWidthRatio:
			Number = 0.59;
		// Доля высота формы звука от ширины командной панели.
		public static var SoundFormHeightToCommandPanelWidthRatio: Number = 0.31;
		//-----------------------------------------------------------------------
		// Переменные экземпляра класса.
		
		// Параметры базы данных MySQL.
		private var _MySQLDatabaseParameters: MySQLParameters   = null;
		// Информация медиа-файла.
		private var _MediaFileInformation:    SlideFilePathAndTypeInformation;
		// Основной трассировщик.
		private var _MainTracer:              Tracer            = null;
		// Открыватель.
		private var _Opener:                  MediaPlayerOpener = null;

		// Предельный прямоугольник окна медиа-плеера нормального размера -
		// прямоугольник поверх экрана медиа-плеера,
		// меньший, чем он, по размерам, расположенный в композиционном центре
		// относительно экрана информации, на нём размещаются
		// все элементы медиа-плеера.
		private var _NormalWindowLimitRectangle: Rectangle = new Rectangle( );
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
				MediaPlayerScreen.StaticParametersFileURLLoadingCompleteListener );				
			// Регистрирация объекта-прослушивателя события возникновения ошибки
			// при загрузке данных с URL-адреса файла статических параметров.
			staticParametersFileURLLoader.addEventListener( IOErrorEvent.IO_ERROR,
				MediaPlayerScreen.StaticParametersFileURLLoadingIOErrorListener );	
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
				MediaPlayerScreen.
				DemoStaticParametersFileURLLoadingCompleteListener );				
			// Регистрирация объекта-прослушивателя события возникновения ошибки
			// при загрузке данных с URL-адреса файла демонстрационных
			// статических параметров.
			demoStaticParametersFileURLLoader.addEventListener
				( IOErrorEvent.IO_ERROR, MediaPlayerScreen.
				DemoStaticParametersFileURLLoadingIOErrorListener );	
		} // LoadDemoStaticParameters		
		//-----------------------------------------------------------------------
		// Методы экземпляра класса.
		
		// Метод инициализации открывателя.
		private function InitializeOpener( ): void
		{
			// Вызов метода класса.
			this._MainTracer.CallClassMethod( MediaPlayerScreen.CLASS_NAME,
				"InitializeOpener" );			
			
			// Открыватель.
			this._Opener = new MediaPlayerOpener
				( this._MySQLDatabaseParameters.MediaPlayerOpenerRequestPHPFileURL,
				this._MainTracer );
				
			// Имя файла медиа-плеера.
			this._Opener.MediaPlayerFileName         =
				this._MySQLDatabaseParameters.MediaPlayerFileName;
			// Имя файла настроек медиа-плеера.
			this._Opener.MediaPlayerSettingsFileName =
				this._MySQLDatabaseParameters.MediaPlayerSettingsFileName;
		
			// URL-адрес медиа-файла для проигрывания.
			this._Opener.MediaFileURL  = this._MediaFileInformation.PathString;
			// Mедиа-тип, указывающий является ли файл аудио или видео.
			this._Opener.MediaTypeName = this._MediaFileInformation.Type;
			
			// Интервал в миллисекундах таймера закрытия плеера - интервал
			// между наступлением паузы или остановки проигрывания меда-файла
			// и моментом закрытия плеера, который считается бездействующим.
			this._Opener.PlayerClosingTimerDelay         =
				MediaPlayerScreen.ClosingTimerDelay;
			// Время в миллисекундах длительности эффекта изменения видимости -
			// время, в течение которого осуществляется эффект появления
			// или исчезновения формы.
			this._Opener.VisibleChangingEffectTime       =
				MediaPlayerScreen.VisibleChangingEffectTime;
			// Интервал в миллисекундах таймера эффекта изменения видимости.
			this._Opener.VisibleChangingEffectTimerDeley =
				MediaPlayerScreen.VisibleChangingEffectTimerDeley;
			// Интервал в миллисекундах таймера сокрытия формы звука -
			// интервал между моментом покидания кнопки звука
			// или формы звука курсором мыши и моментом сокрытия формы звука.
			this._Opener.SoundFormHidingTimerDeley       =
				MediaPlayerScreen.SoundFormHidingTimerDeley;				
		
			// Абсцисса плеера.
			this._Opener.X      = this._NormalWindowLimitRectangle.x;
			// Ордината плеера.
			this._Opener.Y      = this._NormalWindowLimitRectangle.y;
			// Ширина плеера.
			this._Opener.Width  = this._NormalWindowLimitRectangle.width;
			// Высота плеера.
			this._Opener.Height = this._NormalWindowLimitRectangle.height;
		
			// Доля ширины кнопки плеера от её высоты.
			this._Opener.ButtonWidthToHeightRatio                      =
				MediaPlayerScreen.ButtonWidthToHeightRatio;
			// Доля ширины трека прокрутки длительности от ширины командной панели.
			this._Opener.DurationTrackbarWidthToCommandPanelWidthRatio =
				MediaPlayerScreen.DurationTrackbarWidthToCommandPanelWidthRatio;
			// Доля высота формы звука от ширины командной панели.
			this._Opener.SoundFormHeightToCommandPanelWidthRatio       =
				MediaPlayerScreen.SoundFormHeightToCommandPanelWidthRatio;				
				
			// Загрузка запроса открытия медиа-плеера.
			this._Opener.LoadRequest( );
			// Регистрирация объекта-прослушивателя события успешной загрузки
			// запроса открытия медиа-плеера.
			this._Opener.addEventListener( PHPRequester.REQUEST_LOADING_COMPLETE,
				this.OpenRequestLoadingFinishedListener );
			// Регистрирация объекта-прослушивателя события возникновения ошибки
			// при выполнении запроса открытия медиа-плеера.
			this._Opener.addEventListener( PHPRequester.REQUEST_LOADING_IO_ERROR,
				this.OpenRequestLoadingFinishedListener );	
		} // InitializeOpener		
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
			MediaPlayerScreen.ClosingTimerDelay               =
				staticParametersXML.ClosingTimerDelay[ 0 ];
			// Время в миллисекундах длительности эффекта изменения видимости.
			MediaPlayerScreen.VisibleChangingEffectTime       =
				staticParametersXML.VisibleChangingEffectTime[ 0 ];
			// Интервал в миллисекундах таймера эффекта изменения видимости.
			MediaPlayerScreen.VisibleChangingEffectTimerDeley =
				staticParametersXML.VisibleChangingEffectTimerDeley[ 0 ];
			// Интервал в миллисекундах таймера сокрытия формы звука.
			MediaPlayerScreen.SoundFormHidingTimerDeley       =
				staticParametersXML.SoundFormHidingTimerDeley[ 0 ];				
			
			// Доля ширины кнопки от её высоты.
			MediaPlayerScreen.ButtonWidthToHeightRatio                      =
				staticParametersXML.ButtonWidthToHeightRatio[ 0 ];
			// Доля ширины трека прокрутки длительности от ширины командной панели.
			MediaPlayerScreen.DurationTrackbarWidthToCommandPanelWidthRatio =
				staticParametersXML.
				DurationTrackbarWidthToCommandPanelWidthRatio[ 0 ];
			// Доля высота формы звука от ширины командной панели.
			MediaPlayerScreen.SoundFormHeightToCommandPanelWidthRatio       =
				staticParametersXML.SoundFormHeightToCommandPanelWidthRatio[ 0 ];				
			
			// Передача события успешной загрузки статических параметров,
			// целью - объбектом-получателем - которого является объект
			// статического диспетчера событий данного класса экрана медиа-плеера.
			MediaPlayerScreen._StaticEventDispatcher.dispatchEvent( new Event
				( MediaPlayerScreen.STATIC_PARAMETERS_LOADING_COMPLETE ) );
			// Передача события окончания загрузки статических параметров,
			// целью - объбектом-получателем - которого является объект
			// статического диспетчера событий данного класса экрана медиа-плеера.
			MediaPlayerScreen._StaticEventDispatcher.dispatchEvent( new Event
				( MediaPlayerScreen.STATIC_PARAMETERS_LOADING_FINISHED ) );
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
			trace( MediaPlayerScreen.
				STATIC_PARAMETERS_FILE_URL_LOADING_IO_ERROR_MESSAGE );
			// Передача события возникновения ошибки
			// при загрузке статических параметров,
			// целью - объбектом-получателем - которого является объект
			// статического диспетчера событий данного класса экрана медиа-плеера.
			MediaPlayerScreen._StaticEventDispatcher.dispatchEvent( new Event
				( MediaPlayerScreen.STATIC_PARAMETERS_LOADING_IO_ERROR ) );			
			// Передача события окончания загрузки статических параметров,
			// целью - объбектом-получателем - которого является объект
			// статического диспетчера событий данного класса экрана медиа-плеера.
			MediaPlayerScreen._StaticEventDispatcher.dispatchEvent( new Event
				( MediaPlayerScreen.STATIC_PARAMETERS_LOADING_FINISHED ) );
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
			MediaPlayerScreen.VisibleChangingEffectTime       =
				demoStaticParametersXML.VisibleChangingEffectTime[ 0 ];
			// Интервал в миллисекундах таймера эффекта изменения видимости.
			MediaPlayerScreen.VisibleChangingEffectTimerDeley =
				demoStaticParametersXML.VisibleChangingEffectTimerDeley[ 0 ];
			// Интервал в миллисекундах таймера сокрытия формы звука.
			MediaPlayerScreen.SoundFormHidingTimerDeley       =
				demoStaticParametersXML.SoundFormHidingTimerDeley[ 0 ];				
			
			// Передача события окончания загрузки демонстрационных
			// статических параметров, целью - объбектом-получателем - которого
			// является объект статического диспетчера событий
			// данного класса экрана медиа-плеера.
			MediaPlayerScreen._StaticEventDispatcher.dispatchEvent( new Event
				( MediaPlayerScreen.DEMO_STATIC_PARAMETERS_LOADING_FINISHED ) );
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
			trace( MediaPlayerScreen.
				DEMO_STATIC_PARAMETERS_FILE_URL_LOADING_IO_ERROR_MESSAGE );
			// Передача события возникновения ошибки
			// при загрузке демонстрационных статических параметров,
			// целью - объбектом-получателем - которого является объект
			// статического диспетчера событий данного класса экрана медиа-плеера.
			MediaPlayerScreen._StaticEventDispatcher.dispatchEvent( new Event
				( MediaPlayerScreen.DEMO_STATIC_PARAMETERS_LOADING_IO_ERROR ) );			
			// Передача события окончания загрузки демонстрационных
			// статических параметров, целью - объбектом-получателем - которого
			// является объект статического диспетчера событий
			// данного класса экрана медиа-плеера.
			MediaPlayerScreen._StaticEventDispatcher.dispatchEvent( new Event
				( MediaPlayerScreen.DEMO_STATIC_PARAMETERS_LOADING_FINISHED ) );
		} // DemoStaticParametersFileURLLoadingIOErrorListener
		
		// Метод-прослушиватель события завершения выполнения запроса
		// открытия медиа-плеера.
		// Параметры:
		// parEvent - событие.
		protected function OpenRequestLoadingFinishedListener
			( parEvent: Event ): void
		{
			// Вызов метода-обработчика события класса.
			this._MainTracer.CallClassEventListener( MediaPlayerScreen.CLASS_NAME,
				"OpenRequestLoadingFinishedListener", parEvent );				
		
			// Передача события наступления момента времени закрытия
			// в поток событий, целью - объбектом-получателем - которого
			// является данный объект экрана медиа-плеера.
			this.dispatchEvent( new Event( MediaPlayerScreen.SHOULD_CLOSE ) );
		} // OpenRequestLoadingFinishedListener		
		//-----------------------------------------------------------------------	
		// Методы-конструкторы.
		
		// Метод-конструктор экземпляра экрана медиа-плеера.
		// Параметры:
		// parMySQLDatabaseParameters    - парараметры базы данных MySQL,		
		// parMediaFileInformation       - информация медиа-файла,
		// parMainTracer                 - основной трассировщик,
		// parAreaRectangle - прямоугольная область экрана медиа-плеера,
		// parNormalWindowLimitRectangle - предельный прямоугольник
		//   окна медиа-плеера нормального размера.
		public function MediaPlayerScreen
		(
		 	parMySQLDatabaseParameters:    MySQLParameters,			
			parMediaFileInformation:       SlideFilePathAndTypeInformation,
			parMainTracer:                 Tracer,
			parAreaRectangle,	
			parNormalWindowLimitRectangle: Rectangle			
		): void
		{
			// Вызов метода-конструктора суперкласса Sprite.
			super( );	
			
			// Парараметры базы данных MySQL.
			this._MySQLDatabaseParameters = parMySQLDatabaseParameters;	
			// Информация медиа-файла.
			this._MediaFileInformation    = parMediaFileInformation;
			// Ocновной трассировщик.
			this._MainTracer              = parMainTracer;
			
			// Создание нового экземпляра класса.
			this._MainTracer.CreateClassNewInstance( MediaPlayerScreen.CLASS_NAME,
				parMySQLDatabaseParameters, parMediaFileInformation, parMainTracer,
				parAreaRectangle, parNormalWindowLimitRectangle );			
		
			// Если тип медиа-файла - не видео и не аудио,
			// то этот файл не будет проигрываться и плеер следует закрыть.
			if
			(
				( this._MediaFileInformation.Type != SlideType.VIDEO ) &&
				( this._MediaFileInformation.Type != SlideType.AUDIO )
			)
			{
				// Передача события наступления момента времени закрытия
				// в поток событий, целью - объбектом-получателем - которого
				// является данный объект экрана медиа-плеера.
				this.dispatchEvent( new Event( MediaPlayerScreen.SHOULD_CLOSE ) );
				// Больше ничего не происходит.
				return;
			} // if	
			
			// Абсцисса экрана медиа-плеера.
			this.x          = parAreaRectangle.x;
			// Ордината экрана медиа-плеера.
			this.y          = parAreaRectangle.y;
			// Определение прямоугольной области прокрутки экрана медиа-плеера
			// заданной высоты и ширины.
			this.scrollRect = new Rectangle( 0, 0, parAreaRectangle.width,
				parAreaRectangle.height );

			// Предельный прямоугольник окна медиа-плеера нормального размера.
			this._NormalWindowLimitRectangle = parNormalWindowLimitRectangle;			
			// Для полного покрытия области выделенной под медиа-плеер
			// его размеры инкрементируются.				
			// Инкремент ширины предельного прямоугольника окна медиа-плеера.
			this._NormalWindowLimitRectangle.width++;
			// Инкремент высоты предельного прямоугольника окна медиа-плеера.
			this._NormalWindowLimitRectangle.height++;
			
			// Во весь экрана медиа-плеера,
			// рисутеся полностью прозрачный прямоугольник.
			
			// Начало рисования на экране медиа-плеера в заданном режиме:
			// сплошная заливка чёрным цветом с абсолютной прозрачностью.
			this.graphics.beginFill( 0x0, 0 );
			// Рисуется прозрачный прямоугольник во весь экран медиа-плеера.
			this.graphics.drawRect( 0, 0, parAreaRectangle.width,
				parAreaRectangle.height );
			// Окончание рисования на экране медиа-плеера в заданном режиме.
			this.graphics.endFill( );			
			
			// Инициализация открывателя.
			this.InitializeOpener( );		
		} // MediaPlayerScreen
		//-----------------------------------------------------------------------
		// Get- и set-методы.
		
		// Get-метод получения статического диспетчера событий.
		// Результат: статический диспетчер событий.
		public static function get StaticEventDispatcher( ): EventDispatcher
		{
			// Статический диспетчер событий.
			return MediaPlayerScreen._StaticEventDispatcher;
		} // StaticEventDispatcher		
	} // MediaPlayerScreen
} // nijanus.customerDesktop.display