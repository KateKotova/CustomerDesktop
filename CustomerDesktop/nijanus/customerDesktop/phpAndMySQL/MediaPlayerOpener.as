// CustomerDesktop
// Author Kate Kotova
// NIJANUS Copyright © 2004-2010
// nijanus@ymail.com
// http://nijanus.narod2.ru
//---------------------------------------------------------------------------
// Пакет классов, взаимодействующих с PHP.
package nijanus.customerDesktop.phpAndMySQL
{
	// Список импортированных классов из других пакетов.
	import nijanus.php.PHPRequester;
	//-------------------------------------------------------------------------
	
	// Класс открывателя медиа-плеера.
	public class MediaPlayerOpener extends PHPRequester
	{
		// Список импортированных классов из других пакетов.
		
		import flash.net.URLLoaderDataFormat;		
		import flash.net.URLVariables;
		import nijanus.utils.Tracer;
		//-----------------------------------------------------------------------
		// Статические константы.
		
		// Имя класса.
		public static const CLASS_NAME: String = "MediaPlayerOpener";		
		//-----------------------------------------------------------------------						
		// Статические переменные.
		
		// Счётчик загрузок запроса.
		// Он вводится для того, чтобы запрос, даже если его параметры
		// одни и те же, выполнялся каждый раз, а не только впервые,
		// как почему-то происходит обычно.
		private static var _ReqeustLoadingsCounter: uint = 0;
		//-----------------------------------------------------------------------		
		// Переменные экземпляра класса.
		
		// Имя файла медиа-плеера.
		public var MediaPlayerFileName:         String = null;
		// Имя файла настроек медиа-плеера.
		public var MediaPlayerSettingsFileName: String = null;
	
		// URL-адрес медиа-файла для проигрывания.
		public var MediaFileURL:  String = null;
		// Mедиа-тип, указывающий является ли файл аудио или видео.
		public var MediaTypeName: String = null;
		
		// Интервал в миллисекундах таймера закрытия плеера -
		// интервал между наступлением паузы или остановки проигрывания меда-файла
		// и моментом закрытия плеера, который считается бездействующим.
		public var PlayerClosingTimerDelay:         uint = 0;
		// Время в миллисекундах длительности эффекта изменения видимости -
		// время, в течение которого осуществляется эффект появления
		// или исчезновения формы.
		public var VisibleChangingEffectTime:       uint = 0;
		// Интервал в миллисекундах таймера эффекта изменения видимости.
		public var VisibleChangingEffectTimerDeley: uint = 0;
		// Интервал в миллисекундах таймера сокрытия формы звука -
		// интервал между моментом покидания кнопки звука
		// или формы звука курсором мыши и моментом сокрытия формы звука.
		public var SoundFormHidingTimerDeley:       uint = 0;		
	
		// Абсцисса плеера.
		public var X:      int  = 0;
		// Ордината плеера.
		public var Y:      int  = 0;
		// Ширина плеера.
		public var Width:  uint = 0;
		// Высота плеера.
		public var Height: uint = 0;
	
		// Доля ширины кнопки плеера от её высоты.
		public var ButtonWidthToHeightRatio:                Number = undefined;
		// Доля ширины трека прокрутки длительности от ширины командной панели.
		public var DurationTrackbarWidthToCommandPanelWidthRatio:
			Number = undefined;
		// Доля высота формы звука от ширины командной панели.
		public var SoundFormHeightToCommandPanelWidthRatio: Number = undefined;		
		//-----------------------------------------------------------------------
		// Статические методы.
		
		// Метод инкрементирования счётчика загрузок запроса.
		private static function IncrementReqeustLoadingsCounter( )
		{
			// Если значение счётчика загрузок запроса максимальное.
			if ( MediaPlayerOpener._ReqeustLoadingsCounter == uint.MAX_VALUE )
				// Увеличивать значение счётчика загрузок запроса больше некуда
				// и он обнуляется.
				MediaPlayerOpener._ReqeustLoadingsCounter = 0;
			// Значение счётчика загрузок запроса находится в допустимых пределах.
			else
				// Инкремент счётчика загрузок запроса.
				MediaPlayerOpener._ReqeustLoadingsCounter++;
		} // IncrementReqeustLoadingsCounter		
		//-----------------------------------------------------------------------
		// Методы экземпляра класса.

		// Метод загрузки запроса.
		// Параметры:
		// parPHPFileURLLoaderDataFormat - формат загружаемых данных
		//   с URL-адреса PHP-файла.
		override public function LoadRequest
			( parPHPFileURLLoaderDataFormat: String	=
			URLLoaderDataFormat.TEXT ): void
		{
			// Вызов метода класса.
			this._MainTracer.CallClassMethod( MediaPlayerOpener.CLASS_NAME,
				"LoadRequest", parPHPFileURLLoaderDataFormat );					
			
			// Инкремент счётчика загрузок запроса. 
			MediaPlayerOpener.IncrementReqeustLoadingsCounter( );
			// Вызов метода суперкласса PHPRequester.
			super.LoadRequest( parPHPFileURLLoaderDataFormat );
		} // LoadRequest
		//-----------------------------------------------------------------------
		// Методы-конструкторы.
	
		// Метод-конструктор экземпляра открывателя медиа-плеера.
		// Параметры:
		// parRequestPHPFileURL - URL-адрес PHP-файла запроса,
		// parMainTracer        - основной трассировщик.
		public function MediaPlayerOpener
		(
			parRequestPHPFileURL: String,
			parMainTracer:        Tracer
		): void		
		{
			// Вызов метода-конструктора суперкласса PHPRequester.
			super( parRequestPHPFileURL, parMainTracer );
			
			// Создание нового экземпляра класса.
			this._MainTracer.CreateClassNewInstance( MediaPlayerOpener.CLASS_NAME,
				parRequestPHPFileURL, parMainTracer );			
		} // MediaPlayerOpener
		//-----------------------------------------------------------------------			
		// Get- и set-методы.
		
		// Get-метод получения URL-переменных PHP-файла запроса.
		// Результат: URL-переменные PHP-файла запроса.
		override public function get RequestPHPFileURLVariables( ): URLVariables
		{
			// Создание URL-переменных PHP-файла запроса,
			// осуществляющих передачу данных между приложением и сервером.
			var requestPHPFileURLVariables: URLVariables = new URLVariables( );			
			
			// Добавление URL-переменных запроса.
			
			// Счётчик загрузок запроса.
			// Фактически он не задействован в выполнении запроса,
			// но вводится для того, чтобы запрос при неоднократном вызове
			// с одними и теми же параметрыми выполнялся всякий раз,
			// а не только впервые, как почему-то происходит обычно.
			// Таким образом, строки запроса с одинаковыми параметрами 
			// становятся различны, поскольку содержат значения
			// статической переменной счётчика загрузок запроса.
			requestPHPFileURLVariables.Counter =
				MediaPlayerOpener._ReqeustLoadingsCounter;
			
			// Имя файла медиа-плеера.
			requestPHPFileURLVariables.MediaPlayerFileName         =
				this.MediaPlayerFileName;
			// Имя файла настроек медиа-плеера.
			requestPHPFileURLVariables.MediaPlayerSettingsFileName =
				this.MediaPlayerSettingsFileName;
		
			// URL-адрес медиа-файла для проигрывания.
			requestPHPFileURLVariables.MediaFileURL  = this.MediaFileURL;
			// Mедиа-тип, указывающий является ли файл аудио или видео.
			requestPHPFileURLVariables.MediaTypeName = this.MediaTypeName;
			
			// Интервал в миллисекундах таймера закрытия плеера -
			// интервал между наступлением паузы или остановки
			// проигрывания меда-файла и моментом закрытия плеера,
			// который считается бездействующим.
			requestPHPFileURLVariables.PlayerClosingTimerDelay         =
				this.PlayerClosingTimerDelay;
			// Время в миллисекундах длительности эффекта изменения видимости -
			// время, в течение которого осуществляется эффект появления
			// или исчезновения формы.
			requestPHPFileURLVariables.VisibleChangingEffectTime       =
				this.VisibleChangingEffectTime;
			// Интервал в миллисекундах таймера эффекта изменения видимости.
			requestPHPFileURLVariables.VisibleChangingEffectTimerDeley =
				this.VisibleChangingEffectTimerDeley;
			// Интервал в миллисекундах таймера сокрытия формы звука -
			// интервал между моментом покидания кнопки звука
			// или формы звука курсором мыши и моментом сокрытия формы звука.
			requestPHPFileURLVariables.SoundFormHidingTimerDeley       =
				this.SoundFormHidingTimerDeley;				
		
			// Абсцисса плеера.
			requestPHPFileURLVariables.X      = this.X;
			// Ордината плеера.
			requestPHPFileURLVariables.Y      = this.Y;
			// Ширина плеера.
			requestPHPFileURLVariables.Width  = this.Width;
			// Высота плеера.
			requestPHPFileURLVariables.Height = this.Height;
		
			// Доля ширины кнопки плеера от её высоты.
			requestPHPFileURLVariables.ButtonWidthToHeightRatio                =
				this.ButtonWidthToHeightRatio;
			// Доля ширины трека прокрутки длительности от ширины командной панели.
			requestPHPFileURLVariables.
				DurationTrackbarWidthToCommandPanelWidthRatio                    =
				this.DurationTrackbarWidthToCommandPanelWidthRatio;
			// Доля высота формы звука от ширины командной панели.
			requestPHPFileURLVariables.SoundFormHeightToCommandPanelWidthRatio =
				this.SoundFormHeightToCommandPanelWidthRatio;				

			// URL-переменные PHP-файла запроса.
			return requestPHPFileURLVariables;
		} // RequestPHPFileURLVariables	
	} // MediaPlayerOpener
} // nijanus.customerDesktop.phpAndMySQL