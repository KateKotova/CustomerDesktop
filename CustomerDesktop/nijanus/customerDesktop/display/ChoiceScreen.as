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

	// Класс экрана выбора.
	public class ChoiceScreen extends Sprite
	{
		// Список импортированных классов из других пакетов.

		import fl.controls.Button;
		import fl.controls.ButtonLabelPlacement;
		import flash.display.DisplayObjectContainer;
		import flash.events.Event;
		import flash.events.EventDispatcher;
		import flash.events.IOErrorEvent;
		import flash.events.MouseEvent;
		import flash.events.TimerEvent;		
		import flash.geom.Rectangle;
		import flash.geom.Point;
		import flash.net.URLLoader;		
		import flash.net.URLRequest;		
		import flash.utils.Dictionary;	
		import flash.utils.Timer;
		import nijanus.customerDesktop.phpAndMySQL.
			MySQLMenuButtonsLabelsSelector;		
		import nijanus.customerDesktop.phpAndMySQL.MySQLParameters;
		import nijanus.customerDesktop.phpAndMySQL.imagesNamesSelector.
			ChoiceScreenType;
		import nijanus.customerDesktop.phpAndMySQL.imagesNamesSelector.
			ImagesLineType;
		import nijanus.customerDesktop.phpAndMySQL.imagesNamesSelector.
			ImagesNamesSelector;		
		import nijanus.customerDesktop.text.TextParameters;		
		import nijanus.customerDesktop.utils.ImageFilePathAndArticleInformation;
		import nijanus.display.GlowButton;
		import nijanus.display.GlowButtonParameters;
		import nijanus.display.ImagesLine;
		import nijanus.display.ImageSpriteEvent;
		import nijanus.php.PHPRequester;
		import nijanus.utils.Tracer;
		//-----------------------------------------------------------------------
		// Статические константы.
		
		// Имя класса.
		public static const CLASS_NAME: String = "ChoiceScreen";
		
		// Название типа события окончания загрузки статических параметров.
		public static const STATIC_PARAMETERS_LOADING_FINISHED: String =
			"StaticParametersLoadingFinished";	
		// Название типа события возникновения ошибки
		// при загрузке статических параметров.
		public static const STATIC_PARAMETERS_LOADING_IO_ERROR: String =
			"StaticParametersLoadingIOError";			
		// Сообщение об ошибке загрузки данных из файла статических параметров.
		public static const STATIC_PARAMETERS_FILE_URL_LOADING_IO_ERROR_MESSAGE:
			String = "Ошибка загрузки данных из файла статических параметров " +
			"класса ChoiceScreen";		
		
		// Количество строк изображений.
		public static const IMAGES_LINES_NUMBER: uint = 3;
		//-----------------------------------------------------------------------
		// Статические переменные.
		
		// Статический диспетчер событий.
		private static var _StaticEventDispatcher: EventDispatcher =
			new EventDispatcher( );		
		
		// Коэффициент отношения ширины спрайта изображения
		// строки изображений к высоте.
		public static var ImagesLineImageSpriteWidthToHeightRatio:
			Number = 125/170;		
		// Коэффициент отношения высоты кнопки меню к высоте экрана выбора.
		public static var MenuButtonHeightToThisHeightRatio:
			Number = 50/575;
			
		// Задержка в миллисекундах таймера установки типа по умолчанию -
		// задержка между последним отпусканием кнопки мыши на экране выбора
		// и установкой типа экрана выбора по умолчанию.
		// Copyright Protection: [300000] - Full, [60000] - Demo.
		public static var DefaultTypeSettingTimerDelay: Number = 60000;//300000;			
		//-----------------------------------------------------------------------
		// Переменные экземпляра класса.
		
		// Парараметры базы данных MySQL.
		private var _MySQLDatabaseParameters: MySQLParameters = null;
		// Основные текстовые параметры.
		private var _MainTextParameters:      TextParameters  = null;	
		// Основной трассировщик.
		private var _MainTracer:              Tracer          = null;
		
		// Тип.
		private var _Type:            String     = ChoiceScreenType.DEFAULT;
		// Словарь типов, ключами которого являются объекты
		// соответствующих кнопок меню: нажатие на кнопку меню
		// означает выбор типа экрана выбора, закреплённого за ней.
		private var _TypesDictionary: Dictionary = new Dictionary( );		
		
		// Выборщик текстовых меток кнопок меню из таблиц MySQL.
		private var _MenuButtonsLablesSelector:
			MySQLMenuButtonsLabelsSelector = null;			
		// Массив выборщиков названий изображений строк изображений.
		private var _ImagesLinesImagesNamesSelectors: Array =
			new Array( ChoiceScreen.IMAGES_LINES_NUMBER );
			
		// Для удаления кнопок меню, соответствующих типам,
		// для которых все строки изображений будут пусты, проводится тест:
		// просматриваются все известные типы
		// и подсчитывается количество изображений в каждой строке изображений,
		// хранящей информацию в соответствии с текущим просматриваемым типом,
		// если для какого-то типа количество изображений
		// во всех строках изображений окажется нулевым,
		// то для такого типа кнопка меню создаваться не будет.
		
		// Массив количеств названий изображений в строках изображений,
		// хранящих информацию в соответствии с типами - массив,
		// элементы которого соответствуют известным типам экрана выбора,
		// кроме типа по умолачанию, и элементы этого массива - массивы,
		// элементы каждого из которых соответствуют типам строк изображений
		// и содаржат количество изображений в этих строках.
		private var _TypesImagesLinesImagesNamesCounts: Array =
			new Array( ChoiceScreenType.VALUES.length - 1 );
		// Массив суммарных количеств названий изображений
		// в строках изображений - массив, элементы которого соответствуют
		// индексам известных типов экрана выбора, кроме типа по умолачанию,
		// и содаржат суммарное количество изображений в строках для этих типов.
		private var _TypesImagesLinesImagesNamesCountsSums: Array =
			new Array( ChoiceScreenType.VALUES.length );		
		// Количество протестированных строк изображений,
		// хранящих информацию, соответствующую текущему тестируемому типу.
		private var _TestCurrentTypeImagesLinesCount: uint  = 0;
			
		// Массив строк изображений.
		private var _ImagesLines: Array =
			new Array( ChoiceScreen.IMAGES_LINES_NUMBER );	
		// Массив кнопок меню.
		private var _MenuButtons: Array = null;
		// Выбранная - нажатая - кнопка-переключатель из множества кнопок меню.
		private var _SelectedMenuButton: GlowButton = null;		
		
		// Таймер установки типа по умолчанию, который запускается 1 раз -
		// тогда устанавливается тип по умолчанию, а потом останавливается.
		private var _DefaultTypeSettingTimer: Timer  =
			new Timer( ChoiceScreen.DefaultTypeSettingTimerDelay, 1 );
		// Признак необходимости установки типа по умолчанию:
		// если медиа-плеер не закрыт, то тип по умолчанию устновить пока нельзя
		// и этот признак становится истинным, чтобы, когда медиа-плеер закрылся,
		// наконец установить тип по умолчанию.
		private var _ShouldSetDefaultType:    Boolean = false;
			
		// Экран информации.
		private var _InformationScreen: InformationScreen;
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
				ChoiceScreen.StaticParametersFileURLLoadingCompleteListener );				
			// Регистрирация объекта-прослушивателя события возникновения ошибки
			// при загрузке данных с URL-адреса файла статических параметров.
			staticParametersFileURLLoader.addEventListener( IOErrorEvent.IO_ERROR,
				ChoiceScreen.StaticParametersFileURLLoadingIOErrorListener );	
		} // LoadStaticParameters		
		//-----------------------------------------------------------------------
		// Методы экземпляра класса.
		
		// Метод проведения очередного теста по подсчёту
		// количеств названий изображений в строках изображений,
		// хранящих информацию в соответствии с типами.
		public function NextTest( ): void
		{
			// Вызов метода класса.
			this._MainTracer.CallClassMethod( ChoiceScreen.CLASS_NAME,
				"NextTest" );
			
			// Инкремент количества протестированных строк изображений
			// для текущего тестируемого типа.
			this._TestCurrentTypeImagesLinesCount++;
			
			// Если для текущего тестируемого типа
			// просмотрены все строки изображений.
			if ( this._TestCurrentTypeImagesLinesCount ==
				ChoiceScreen.IMAGES_LINES_NUMBER )
			{
				// Индекс текущего тестируемого типа.
				var testCurrentTypeIndex   =
					ChoiceScreenType.IndexOfValue( this._Type );
				// Сумма количеств названий изображений в строках изображений
				// для текущего тестируемого типа.
				this._TypesImagesLinesImagesNamesCountsSums
					[ testCurrentTypeIndex ] = 0;
				// Индекс типа строки изображений.
				var imagesLineTypeIndex: uint;
				// Тип текущей строки изображений.
				var imagesLineType:      String;		
				
				// Последовательный просмотр выборщиков названий изображений
				// строк изображений.
				for
				(
					imagesLineTypeIndex  = ImagesLineType.KNOWN_VALUE_MINIMUM_INDEX;
					imagesLineTypeIndex <= ImagesLineType.KNOWN_VALUE_MAXIMUM_INDEX;
					imagesLineTypeIndex++
				)
				{
					// Тип текущей строки изображений.
					imagesLineType = ImagesLineType.ValueOfIndex
						( imagesLineTypeIndex );						
					// Сумма количеств названий изображений в строках изображений
					// для текущего тестируемого типа.
					this._TypesImagesLinesImagesNamesCountsSums
						[ testCurrentTypeIndex ] += 
						this._TypesImagesLinesImagesNamesCounts
						[ this._Type ][ imagesLineType ];
				} // for				
				
				// Если протестирован последний из известных типов.
				if ( testCurrentTypeIndex ==
					ChoiceScreenType.KNOWN_VALUE_MAXIMUM_INDEX )
				{
					// Инициализация.
					this.Initialize( );
					// Завершение тестов.
					return;
				} // if				
				
				// Текущий тестируемый тип - следующий.
				this._Type = ChoiceScreenType.ValueOfIndex
					( ChoiceScreenType.IndexOfValue( this._Type ) + 1 );
				// Массив количеств названий изображений в строках изображений,
				// хранящих информацию в соответствии с типами.
				// Новый элемент текущего тестируемого типа - массив,
				// элементы которого соответствуют типам строк изображений.
				this._TypesImagesLinesImagesNamesCounts[ this._Type ] =
					new Array( ChoiceScreen.IMAGES_LINES_NUMBER );					
				// Количество протестированных строк изображений,
				// хранящих информацию, соответствующую текущему тестируемому типу.
				this._TestCurrentTypeImagesLinesCount = 0;				
					
				// Последовательный просмотр выборщиков названий изображений
				// строк изображений.
				for
				(
					imagesLineTypeIndex  = ImagesLineType.KNOWN_VALUE_MINIMUM_INDEX;
					imagesLineTypeIndex <= ImagesLineType.KNOWN_VALUE_MAXIMUM_INDEX;
					imagesLineTypeIndex++
				)
				{
					// Тип текущей строки изображений.
					imagesLineType = ImagesLineType.ValueOfIndex
						( imagesLineTypeIndex );						
					// Установка текущего тестируемого типа экрана выбора
					// для текущего выборщика названий изображений строки изображений.
					this._ImagesLinesImagesNamesSelectors[ imagesLineType ].
						ChoiceScreenTypeValue = this._Type;
					// Загрузка XML-результата при выполнении тестового запроса
					// к базе данных MySQL для подсчёта количества изображений
					// строки изображений.
					this._ImagesLinesImagesNamesSelectors[ imagesLineType ].
						LoadRequest( );					
				} // for				
			} // if			
		} // NextTest
		
		// Метод инициализации выборщика текстовых меток кнопок меню
		// из таблиц MySQL.
		private function InitializeMenuButtonsLablesSelector( ): void			
		{
			// Вызов метода класса.
			this._MainTracer.CallClassMethod( ChoiceScreen.CLASS_NAME,
				"InitializeMenuButtonsLablesSelector" );
			
			// Выборщик текстовых меток кнопок меню из таблиц MySQL.
			this._MenuButtonsLablesSelector =
				new MySQLMenuButtonsLabelsSelector
				(
					this._MySQLDatabaseParameters.ConnectionAttributes,
					this._MySQLDatabaseParameters.
						MenuButtonsLabelsSelectorRequestPHPFileURL,
					this._MainTracer						
				); // new MySQLMenuButtonsLabelsSelector
				
			// Имя таблицы кнопок меню.
			this._MenuButtonsLablesSelector.MenuButtonsTableName        =
				this._MySQLDatabaseParameters.MenuButtonsTableName;
			// Имя столбца текстовых меток кнопок меню.
			this._MenuButtonsLablesSelector.MenuButtonsLablesColumnName =
				this._MySQLDatabaseParameters.MenuButtonsLablesColumnName;
			
			// Имя упорядочивающего столбца.
			this._MenuButtonsLablesSelector.OrderingColumnName =
				this._MySQLDatabaseParameters.MenuButtonsLablesOrderingColumnName;
			// Направление упорядочения.
			this._MenuButtonsLablesSelector.OrderingAscentSign =
				this._MySQLDatabaseParameters.MenuButtonsLablesOrderingAscendantSign;
				
			// Загрузка XML-результата при выполнении запроса к базе данных MySQL
			// для получения текстовых меток кнопок меню.
			this._MenuButtonsLablesSelector.LoadRequest( );
			// Регистрирация объекта-прослушивателя события успешной загрузки
			// XML-результата при выполнении запроса к базе данных MySQL
			// для получения текстовых меток кнопок меню.		
			this._MenuButtonsLablesSelector.addEventListener
				( PHPRequester.REQUEST_LOADING_COMPLETE,
				this.MenuButtonsLablesRequestXMLResultLoadingCompleteListener );
		} // InitializeMenuButtonsLablesSelector
		
		// Метод инициализации.
		private function Initialize( ): void	
		{
			// Вызов метода класса.
			this._MainTracer.CallClassMethod( ChoiceScreen.CLASS_NAME,
				"Initialize" );			
			
			// Инициализация выборщика текстовых меток кнопок меню из таблиц MySQL.
			this.InitializeMenuButtonsLablesSelector( );				
			// Тип - тип по умолчанию.
			this._Type                   = ChoiceScreenType.DEFAULT;				
			// Высота строки изображений.
			var imagesLineHeight: Number = this.ImagesLineHeight;
			
			// Последовательный просмотр строк изображений
			// и выборщиков названий изображений строк изображений.
			for
			(
				var imagesLineTypeIndex: uint =
					ImagesLineType.KNOWN_VALUE_MINIMUM_INDEX;
				imagesLineTypeIndex          <=
					ImagesLineType.KNOWN_VALUE_MAXIMUM_INDEX;
				imagesLineTypeIndex++
			)
			{
				// Тип текущей строки изображений.
				var imagesLineType: String =
					ImagesLineType.ValueOfIndex( imagesLineTypeIndex );
				
				// Создание строки изображений.
				this._ImagesLines[ imagesLineType ] =
					new ImagesLine					
					(
						0,
						imagesLineHeight *
							(
								imagesLineTypeIndex -
								ImagesLineType.KNOWN_VALUE_MINIMUM_INDEX
							),
						this.scrollRect.width,
						imagesLineHeight
					); // new ImagesLine
				// Помещение объекта строки изображений в объект экрана выбора.
				this.addChild( this._ImagesLines[ imagesLineType ] );					
				// Регистрирация объекта-прослушивателя события
				// клика мыши на спрайте изображения строки изображений.
				this._ImagesLines[ imagesLineType ].addEventListener
					( ImageSpriteEvent.IMAGE_SPRITE_CLICK,
					this.ImagesLineImageSpriteClickListener );
					
				// Установка текущего типа экрана выбора
				// для текущего выборщика названий изображений строки изображений.
				this._ImagesLinesImagesNamesSelectors[ imagesLineType ].
					ChoiceScreenTypeValue = this._Type;
				// Загрузка XML-результата при выполнении запроса к базе данных MySQL
				// для получения названий изображений строк изображений.
				this._ImagesLinesImagesNamesSelectors[ imagesLineType ].
					LoadRequest( );
					
				// Отмена регистрирации объекта-прослушивателя события
				// успешной загрузки XML-результата при выполнении тестового запроса
				// к базе данных MySQL для подсчёта количества изображений
				// строк изображений.	
				this._ImagesLinesImagesNamesSelectors[ imagesLineType ].
					removeEventListener( PHPRequester.REQUEST_LOADING_COMPLETE,
				this.TestRequestXMLResultLoadingCompleteListener );
				// Отмена регистрирации объекта-прослушивателя события
				// возникновения ошибки при загрузке XML-результата
				// при выполнении тестового запроса к базе данных MySQL
				// для подсчёта количества изображений строк изображений.	
				this._ImagesLinesImagesNamesSelectors[ imagesLineType ].
					removeEventListener( PHPRequester.REQUEST_LOADING_IO_ERROR,
				this.TestRequestXMLResultLoadingIOErrorListener );					
				// Регистрирация объекта-прослушивателя события успешной загрузки
				// XML-результата при выполнении запроса к базе данных MySQL
				// для получения названий изображений строк изображений.	
				this._ImagesLinesImagesNamesSelectors[ imagesLineType ].
					addEventListener( PHPRequester.REQUEST_LOADING_COMPLETE,
				this.ImagesLinesImagesNamesRequestXMLResultLoadingCompleteListener );				
			} // for

			// Регистрирация объекта-прослушивателя события
			// отпускания кнопки мыши на экране выбора.
			this.addEventListener( MouseEvent.MOUSE_UP, this.MouseUpListener );
			// Регистрирация объекта-прослушивателя события достижения таймером
			// установки типа по умолчанию интервала задержки в миллисекундах
			// между последним отпусканием кнопки мыши на экране выбора
			// и установкой типа экрана выбора по умолчанию.
			this._DefaultTypeSettingTimer.addEventListener( TimerEvent.TIMER,
				this.DefaultTypeSettingTimerTimerListener );			
		} // Initialize
		
		// Метод закрытия экрана информации.
		private function CloseInformationScreen( ): void
		{
			// Вызов метода класса.
			this._MainTracer.CallClassMethod( ChoiceScreen.CLASS_NAME,
				"CloseInformationScreen" );				
			
			// Если экран информации определён.
			if ( this._InformationScreen != null )
			{
				// Удаление объекта экрана информации
				// из списка потомков экземпляра данного эрана выбора.
				this.removeChild( this._InformationScreen );
				// Очищение объекта экрана информации.
				this._InformationScreen = null;
			} // if
		} // CloseInformationScreen
		
		// Метод установки типа по умолчанию.
		private function SetDefaultType( ): void
		{
			// Вызов метода класса.
			this._MainTracer.CallClassMethod( ChoiceScreen.CLASS_NAME,
				"SetDefaultType" );			
			
			// Если экран информации не закрыт.
			if ( this._InformationScreen != null )
			{
				// Если медиа-плеер не закрыт.
				if ( ! this._InformationScreen.MediaPlayerScreenIsClosed )
				{
					// Установить тип по умолчанию пока нельзя, но признак
					// необходимости установки типа по умолчанию становится истинным.
					this._ShouldSetDefaultType = true;
					// Ничего пока больше не изменяется.
					return;
				} // if
				
				// Закрытие экрана информации.
				this.CloseInformationScreen( );
			} // if
			
			// Установка типа экрана выбора по умолчанию.
			this.Type = ChoiceScreenType.DEFAULT;	
			
			// Если предыдущая выбранная кнопка-переключатель меню определена,
			// то есть если до этого в множестве кнопок меню
			// одна из них была в нажатом состоянимм.
			if ( this._SelectedMenuButton != null )
			{
				// Предыдущая выбранная кнопка меню
				// устанавливается в отжатое состояние.
				this._SelectedMenuButton.selected = false;
				// Передача события покидания выбранной кнопки меню
				// указателем мыши в поток событий,
				// целью - объбектом-получателем - которого
				// является выбранная кнопка меню.
				this._SelectedMenuButton.dispatchEvent
					( new MouseEvent( MouseEvent.ROLL_OUT ) );				
			} // if
			
			// Выбранная кнопка-переключатель меню становится неопрделённой.
			this._SelectedMenuButton   = null;			
			// Тип по умолчанию уже установлен и больше не надо помнить
			// о необходимости его установки.
			this._ShouldSetDefaultType = false;
		} // SetDefaultType		
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
			
			// Коэффициент отношения ширины спрайта изображения
			// строки изображений к высоте.
			ChoiceScreen.ImagesLineImageSpriteWidthToHeightRatio =
				staticParametersXML.ImagesLineImageSpriteWidthToHeightRatio[ 0 ];
			// Коэффициент отношения высоты кнопки меню к высоте экрана выбора.
			ChoiceScreen.MenuButtonHeightToThisHeightRatio =
				staticParametersXML.MenuButtonHeightToThisHeightRatio[ 0 ];
				
			// Задержка в миллисекундах таймера установки типа по умолчанию -
			// задержка между последним отпусканием кнопки мыши на экране выбора
			// и установкой типа экрана выбора по умолчанию.
			ChoiceScreen.DefaultTypeSettingTimerDelay =
				staticParametersXML.DefaultTypeSettingTimerDelay[ 0 ];
			
			// Передача события окончания загрузки статических параметров,
			// целью - объбектом-получателем - которого является объект
			// статического диспетчера событий данного класса экрана выбора.
			ChoiceScreen._StaticEventDispatcher.dispatchEvent( new Event
				( ChoiceScreen.STATIC_PARAMETERS_LOADING_FINISHED ) );
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
			trace( ChoiceScreen.
				STATIC_PARAMETERS_FILE_URL_LOADING_IO_ERROR_MESSAGE );
			// Передача события возникновения ошибки
			// при загрузке статических параметров,
			// целью - объбектом-получателем - которого является объект
			// статического диспетчера событий данного класса экрана выбора.
			ChoiceScreen._StaticEventDispatcher.dispatchEvent( new Event
				( ChoiceScreen.STATIC_PARAMETERS_LOADING_IO_ERROR ) );			
			// Передача события окончания загрузки статических параметров,
			// целью - объбектом-получателем - которого является объект
			// статического диспетчера событий данного класса экрана выбора.
			ChoiceScreen._StaticEventDispatcher.dispatchEvent( new Event
				( ChoiceScreen.STATIC_PARAMETERS_LOADING_FINISHED ) );			
		} // StaticParametersFileURLLoadingIOErrorListener		
		
		// Метод-прослушиватель события успешной загрузки XML-результата
		// при выполнении тестового запроса к базе данных MySQL
		// для подсчёта количества изображений строк изображений.	
		// Параметры:
		// parEvent - событие.
		private function TestRequestXMLResultLoadingCompleteListener
			( parEvent: Event ): void		
		{
			// Вызов метода-обработчика события класса.
			this._MainTracer.CallClassEventListener( ChoiceScreen.CLASS_NAME,
				"TestRequestXMLResultLoadingCompleteListener", parEvent );				
			
			// Выборщик имён изображений - объбект-получатель события.
			var imagesNamesSelector: ImagesNamesSelector =
				ImagesNamesSelector( parEvent.target );				
			// Тип текущей строки изображений.
			var imagesLineType: String = imagesNamesSelector.ImagesLineTypeValue;		
			// Массив артикулов изображений.
			var imagesArticles: Array  = imagesNamesSelector.RequestArrayResult;
			
			// Запись количества загруженных артикулов изображений,
			// равных количеству изображений, в массив
			// по текущему тестируемому типу и текущему типу строки изображений.
			this._TypesImagesLinesImagesNamesCounts
				[ this._Type ][ imagesLineType ] = imagesArticles.length;				
			// Проведения очередного теста по подсчёту
			// количеств названий изображений в строках изображений,
			// хранящих информацию в соответствии с типами.
			this.NextTest( );		
		} // TestRequestXMLResultLoadingCompleteListener
		
		// Метод-прослушиватель события возникновения ошибки
		// при загрузке XML-результата при выполнении тестового запроса
		// к базе данных MySQL для подсчёта количества изображений
		// строк изображений.	
		// Параметры:
		// parEvent - событие.
		private function TestRequestXMLResultLoadingIOErrorListener
			( parEvent: Event ): void		
		{
			// Вызов метода-обработчика события класса.
			this._MainTracer.CallClassEventListener( ChoiceScreen.CLASS_NAME,
				"TestRequestXMLResultLoadingIOErrorListener", parEvent );			
			
			// Выборщик имён изображений - объбект-получатель события.
			var imagesNamesSelector: ImagesNamesSelector =
				ImagesNamesSelector( parEvent.target );				
			// Тип текущей строки изображений.
			var imagesLineType: String = imagesNamesSelector.ImagesLineTypeValue;		
			
			// Запись нулевого количества загруженных артикулов изображений,
			// равных количеству изображений, в массив
			// по текущему тестируемому типу и текущему типу строки изображений.
			this._TypesImagesLinesImagesNamesCounts
				[ this._Type ][ imagesLineType ] = 0;
			// Проведения очередного теста по подсчёту
			// количеств названий изображений в строках изображений,
			// хранящих информацию в соответствии с типами.
			this.NextTest( );
		} // TestRequestXMLResultLoadingIOErrorListener
		
		// Метод-прослушиватель события успешной загрузки XML-результата
		// при выполнении запроса к базе данных MySQL
		// для получения текстовых меток кнопок меню.		
		// Параметры:
		// parEvent - событие.
		private function MenuButtonsLablesRequestXMLResultLoadingCompleteListener
			( parEvent: Event ): void
		{
			// Вызов метода-обработчика события класса.
			this._MainTracer.CallClassEventListener( ChoiceScreen.CLASS_NAME,
				"MenuButtonsLablesRequestXMLResultLoadingCompleteListener",
				parEvent );			
			
			// Массив текстовых меток кнопок меню -
			// массив-результат выполненного запроса к базе данных MySQL
			// для получения текстовых меток кнопок меню.
			var menuButtonsLabels: Array =
				this._MenuButtonsLablesSelector.RequestArrayResult;
				
			// Количество известных известных типов экрана выбора,
			// кроме типа по умолчанию (и неизвестного типа).
			var choiceScreenTypesCount = ChoiceScreenType.VALUES.length - 2;
			// Количество текстовых меток кнопок меню - минимальное число из двух:
			// количества элементов массива-результата выполненного запроса
			// к базе данных MySQL для получения текстовых меток кнопок меню
			// и количества известных типов экрана выбора, кроме типа по умолчанию.
			var menuButtonsLabelsCount: uint =
				menuButtonsLabels.length < choiceScreenTypesCount ?
				menuButtonsLabels.length : choiceScreenTypesCount;				
			// Количество кнопок меню.
			var menuButtonsCount:       uint = 0;

			// Индекс текстовой метки кнопки меню.
			var menuButtonLabelIndex:  uint;
			// Индекс типа экрана выбора.
			var choiceScreenTypeIndex: uint;
			// Индекс типа экрана выбора, первый после типа по умолчанию.
			var firstAfterDefaultChoiceScreenTypeIndex =
				ChoiceScreenType.IndexOfValue( ChoiceScreenType.DEFAULT ) + 1;
			
			// Последовательный просмотр текстовых меток кнопок меню 
			// и известных типов экрана выбора, кроме типа по умолчанию.
			for
			(
				menuButtonLabelIndex  = 0,
				choiceScreenTypeIndex = firstAfterDefaultChoiceScreenTypeIndex;
				menuButtonLabelIndex  < menuButtonsLabelsCount;
				menuButtonLabelIndex++,
				choiceScreenTypeIndex++
			)
				// Если сумма количеств названий изображений в строках изображений
				// для текущего типа экрана выбора ненулевая.
				if ( this._TypesImagesLinesImagesNamesCountsSums
						[ choiceScreenTypeIndex ] > 0 )
					// Текущему типу экрана выбора будет соответствовать кнопка меню.
					menuButtonsCount++;
			
			// Создание кнопок меню.
			this._MenuButtons = new Array( menuButtonsCount );
			
			// Ширина кнопки меню - частное ширины области прокрутки экрана выбора
			// и количества кнопок меню.
			var menuButtonWidth  = this.scrollRect.width / menuButtonsCount;			
			// Высота кнопки меню.
			var menuButtonHeight = this.MenuButtonHeight;
			// Ордината кнопки меню:
			// разность высоты области прокрутки экрана выбора
			// и высоты кнопки меню.
			var menuButtonY      = this.scrollRect.height - menuButtonHeight;
			
			// Максимальная длина текста текстовой метки кнопки меню.
			var menuButtonLabelMaximumLength = 0;			
			// Последовательный просмотр текстовых меток кнопок меню 
			// и известных типов экрана выбора, кроме типа по умолчанию.
			for
			(
				menuButtonLabelIndex  = 0,
				choiceScreenTypeIndex = firstAfterDefaultChoiceScreenTypeIndex;
				menuButtonLabelIndex  < menuButtonsLabelsCount;
				menuButtonLabelIndex++,
				choiceScreenTypeIndex++
			)
				// Если сумма количеств названий изображений в строках изображений
				// для текущего типа экрана выбора ненулевая.
				if ( this._TypesImagesLinesImagesNamesCountsSums
					[ choiceScreenTypeIndex ] > 0 )
				{
					// Длина текста текстовой метки текущей кнопки меню.
					var menuButtonLabelLength =
						menuButtonsLabels[ menuButtonLabelIndex ].toString( ).length;
					// Если длина текста текстовой метки текущей кнопки меню
					// превышает максимальную длину текста
					// текстовой метки кнопки меню.
					if ( menuButtonLabelLength > menuButtonLabelMaximumLength )
						// Максимальная длина текста текстовой метки кнопки меню -
						// длниа текста текстовой метки текущей кнопки меню.
						menuButtonLabelMaximumLength = menuButtonLabelLength;
				} // if
			
			// Добавление к максимальной длине текста текстовой метки кнопки меню
			// количества символов-отступов текстовой метки светящейся кнопки.
			menuButtonLabelMaximumLength +=
				this._MainTextParameters.GlowButtonLabelIndentionSymbolsCount;
					
			// Основной шрифт - не жирный.
			this._MainTextParameters.MainFontIsBold   = false;
			// Основной шрифт - не курсивный.
			this._MainTextParameters.MainFontIsItalic = false;				
				
			// Размер шрифта текстовой метки кнопки меню.
			var menuButtonLabelFontSize: uint =
				this._MainTextParameters.MainFontParameters.GetTextAreaFontSize
				(
					// Размер области текста - размер кнопки меню.
					new Point( menuButtonWidth, menuButtonHeight ),
					// Коэффициент сжатия ширины строки текста -
					// коэффициент сжатия ширины текстовой метки светящейся кнопки.
					this._MainTextParameters.GlowButtonLabelWidthCompressionRatio,
					// Коэффициент сжатия высоты строки текста -
					// коэффициент сжатия высоты текстовой метки светящейся кнопки.
					this._MainTextParameters.GlowButtonLabelHeightCompressionRatio,
					// Минимальный размер шрифта.
					this._MainTextParameters.MainFontMinimumSize,
					// Количество символов в строке текста -
					// максимальная длина текста текстовой метки кнопки меню.
					menuButtonLabelMaximumLength
				); // GetTextAreaFontSize
				
			// Параметры кнопки меню.
			var menuButtonParameters: GlowButtonParameters =
				new GlowButtonParameters( );
			// Имя шрифта текстовой метки.
			menuButtonParameters.LabelFontName        =
				this._MainTextParameters.MainFontParameters.Name;
			// Размер шрифта текстовой метки.
			menuButtonParameters.LabelFontSize        = menuButtonLabelFontSize;
			// Светлый цвет шрифта текстовой метки.
			menuButtonParameters.LabelFontLightColor  =
				this._MainTextParameters.GlowButtonLabelFontLightColor;
			// Тёмный цвет шрифта текстовой метки.
			menuButtonParameters.LabelFontDarkColor   =
				this._MainTextParameters.GlowButtonLabelFontDarkColor;
			// Признак жирности шрифта текстовой метки.
			menuButtonParameters.LabelFontIsBold      =
				this._MainTextParameters.MainFontParameters.IsBold;
			// Признак курсивного нечертания шрифта текстовой метки.
			menuButtonParameters.LabelFontIsItalic    =
				this._MainTextParameters.MainFontParameters.IsItalic;
			// Признак подчёркнутого нечертания шрифта текстовой метки.
			menuButtonParameters.LabelFontIsUnderline = false;
			// Цвет свечения в шестнадцатеричном формате 0xRRGGBB.
			menuButtonParameters.GlowColor            =
				this._MainTextParameters.GlowButtonGlowColor;
				
			// Индекс кнопки меню.
			var menuButtonIndex: uint = 0;			
			// Размещение кнопок меню на экране выбора.
			for
			(
				menuButtonLabelIndex  = 0,
				choiceScreenTypeIndex = firstAfterDefaultChoiceScreenTypeIndex;
				menuButtonLabelIndex  < menuButtonsLabelsCount;
				menuButtonLabelIndex++,
				choiceScreenTypeIndex++
			)
			{
				// Если сумма количеств названий изображений в строках изображений
				// для текущего типа экрана выбора неположительная.
				if ( this._TypesImagesLinesImagesNamesCountsSums
						[ choiceScreenTypeIndex ] <= 0 )
					// Переход к следующему типу экрана выбора.
					continue;	
				
				// Создание кнопки меню.
				this._MenuButtons[ menuButtonIndex ] = new GlowButton
					( menuButtonParameters );					
				// Добавление кнопки меню на экран выбора.
				this.addChild( this._MenuButtons[ menuButtonIndex ] );				
			
				// Текстовая метка для кнопки меню.
				this._MenuButtons[ menuButtonIndex ].label =
					String( menuButtonsLabels[ menuButtonLabelIndex ] );
				// Признак того, что кнопка меню является кнопкой-переключателем.
				this._MenuButtons[ menuButtonIndex ].toggle = true;
				
				// Ширина кнопки меню.
				this._MenuButtons[ menuButtonIndex ].width  = menuButtonWidth;
				// Высота кнопки меню.
				this._MenuButtons[ menuButtonIndex ].height = menuButtonHeight;				
				// Абсцисса кнопки меню:
				// произведение ширины кнопки меню и её индекса.
				this._MenuButtons[ menuButtonIndex ].x      = menuButtonWidth *
					menuButtonIndex;
				// Ордината кнопки меню.
				this._MenuButtons[ menuButtonIndex ].y      = menuButtonY;
			
				// Запись текущего типа экрана выбора в словарь по ключу,
				// являющемуся текущей кнопкой меню.
				this._TypesDictionary[ this._MenuButtons[ menuButtonIndex ] ] =
					ChoiceScreenType.ValueOfIndex( choiceScreenTypeIndex );
					
				// Регистрирация объекта-прослушивателя события
				// клика мыши на кнопке меню.
				this._MenuButtons[ menuButtonIndex ].addEventListener
					( MouseEvent.CLICK, this.MenuButtonClickListener );
					
				// Инкремент индекса кнопки меню.
				menuButtonIndex++;					
			} // for
		} // MenuButtonsLablesRequestXMLResultLoadingCompleteListener
		
		// Метод-прослушиватель события успешной загрузки
		// XML-результата при выполнении запроса к базе данных MySQL
		// для получения названий изображений строк изображений.			
		// Параметры:
		// parEvent - событие.
		private function
			ImagesLinesImagesNamesRequestXMLResultLoadingCompleteListener
			( parEvent: Event ): void
		{	
			// Вызов метода-обработчика события класса.
			this._MainTracer.CallClassEventListener( ChoiceScreen.CLASS_NAME,
				"ImagesLinesImagesNamesRequestXMLResultLoadingCompleteListener",
				parEvent );			
		
			// Выборщик имён изображений - объбект-получатель события.
			var imagesNamesSelector: ImagesNamesSelector =
				ImagesNamesSelector( parEvent.target );				
			// Тип текущей строки изображений.
			var imagesLineType: String = imagesNamesSelector.ImagesLineTypeValue;		
		
			// Массив артикулов изображений.
			var imagesArticles:     Array = imagesNamesSelector.RequestArrayResult;
			// Массив текстовых строк URL-адресов файлов изображений.
			var imagesURLsStrings:  Array = imagesNamesSelector.
				GetURLsArray( imagesArticles );
			// Массив информаций изображений.
			var imagesInformations: Array = new Array( imagesURLsStrings.length );
			
			// Заполнение всех элементов массива информаций изображений.
			for ( var imageIndex: uint = 0; imageIndex < imagesURLsStrings.length;
					imageIndex++ )
				// Создание информации текущего изображения.
				imagesInformations[ imageIndex ] =
					new ImageFilePathAndArticleInformation
					(
					 	// Артикул текущего изображения.
						imagesArticles[ imageIndex ],
						// Текстовая строка URL-адреса файла текущего изображения.
						imagesURLsStrings[ imageIndex ]
					); // new ImageFilePathAndCodeInformation
			
			// Загрузка изображений, хранящихся по путям из массива выполненного
			// запроса к базе данных MySQL, в текущую строку изображений.
			this._ImagesLines[ imagesLineType ].LoadImages
			(
			 	// Коэффициент отношения ширины спрайта изображения к высоте.
				ChoiceScreen.ImagesLineImageSpriteWidthToHeightRatio,
				// Массив текстовых строк URL-адресов файлов изображений.
				imagesURLsStrings,
				// Массив информаций изображений.
				imagesInformations
			); // LoadImages
		} // ImagesLinesImagesNamesRequestXMLResultLoadingCompleteListener
		
		// Метод-прослушиватель события клика мыши на кнопке меню.		
		// Параметры:
		// parMouseEvent - событие мыши.
		private function MenuButtonClickListener
			( parMouseEvent: MouseEvent ): void
		{
			// Вызов метода-обработчика события класса.
			this._MainTracer.CallClassEventListener( ChoiceScreen.CLASS_NAME,
				"MenuButtonClickListener", parMouseEvent );			
			
			// Объект, в котором находится объект-приёмник события -
			// кнопка меню, на которой был клик мыши.
			var menuButton: GlowButton = GlowButton
				( parMouseEvent.currentTarget );
			// Установка кнопки меню - кнопки-переключателя - в нажатое состояние.
			menuButton.selected = true;
			
			// Установка типа экрана выбора, соответствующего нажатой кнопке меню.
			this.Type = this._TypesDictionary[ menuButton ];
			
			// Если предыдущая выбранная кнопка-переключатель меню определена,
			// то есть если до этого в множестве кнопок меню одна из них была
			// в нажатом состоянимм, и если предыдущая и текущая выбранная
			// кнопка-переключатель меню не одна и та же.
			if
			(
				( this._SelectedMenuButton != null       ) &&
				( this._SelectedMenuButton != menuButton ) 
			)
			{
				// Предыдущая выбранная кнопка меню
				// устанавливается в отжатое состояние.
				this._SelectedMenuButton.selected = false;
				// Передача события покидания выбранной кнопки меню
				// указателем мыши в поток событий,
				// целью - объбектом-получателем - которого
				// является выбранная кнопка меню.
				this._SelectedMenuButton.dispatchEvent
					( new MouseEvent( MouseEvent.ROLL_OUT ) );
			} // if
			
			// Выбранной кнопкой-переключателем меню
			// становится текущая нажатая кнопка меню.
			this._SelectedMenuButton = menuButton;
		} // MenuButtonClickListener
		
		// Метод-прослушиватель события отпускания кнопки мыши на экране выбора.
		// Параметры:
		// parMouseEvent - событие мыши.
		private function MouseUpListener( parMouseEvent: MouseEvent ): void
		{
			// Вызов метода-обработчика события класса.
			this._MainTracer.CallClassEventListener( ChoiceScreen.CLASS_NAME,
				"MouseUpListener", parMouseEvent );			
			
			// Объект, в котором находится объект-приёмник события -
			// экран выбора, на котором была отжата кнопка мыши.
			var сhoiceScreen: ChoiceScreen = ChoiceScreen
				( parMouseEvent.currentTarget );			
			// Переустановка и запуск таймера
			// установки типа по умолчанию экрана выбора.
			сhoiceScreen._DefaultTypeSettingTimer.reset( );
			сhoiceScreen._DefaultTypeSettingTimer.start( );				
		} // MouseUpListener		
		
		// Метод-прослушиватель события достижения таймером
		// установки типа по умолчанию интервала задержки в миллисекундах
		// между последним отпусканием кнопки мыши на экране выбора
		// и установкой типа экрана выбора по умолчанию.
		// Параметры:
		// parTimerEvent - событие таймера.
		private function DefaultTypeSettingTimerTimerListener
			( parTimerEvent: TimerEvent ): void
		{
			// Вызов метода-обработчика события класса.
			this._MainTracer.CallClassEventListener( ChoiceScreen.CLASS_NAME,
				"DefaultTypeSettingTimerTimerListener", parTimerEvent );			
			
			// Установка типа по умолчанию.
			this.SetDefaultType( );
		} // DefaultTypeSettingTimerTimerListener
		
		// Метод-прослушиватель события
		// клика мыши на спрайте изображения строки изображений.
		// Параметры:
		// parImageSpriteEvent - событие спрайта изображения.
		private function ImagesLineImageSpriteClickListener
			( parImageSpriteEvent: ImageSpriteEvent ): void
		{
			// Вызов метода-обработчика события класса.
			this._MainTracer.CallClassEventListener( ChoiceScreen.CLASS_NAME,
				"ImagesLineImageSpriteClickListener", parImageSpriteEvent );			
		
			// Создание объекта экрана информации.
			this._InformationScreen =	new InformationScreen
				(
				 	// Парараметры базы данных MySQL.
					this._MySQLDatabaseParameters,				 
					// Информация диска.
					ImageFilePathAndArticleInformation
						( parImageSpriteEvent.TargetImageSprite.Information ),
					// Основные текстовые параметры.
					this._MainTextParameters,	
					// Ocновной трассировщик.
					this._MainTracer,
					// Прямоугольная область экрана информации.
					this.getBounds( this ),
					// Отступ фонового прямоугольник
					// от нижнего края экрана информации -
					// высота области кнопок меню данного экрана выбора.
					this.MenuButtonHeight					
				); // new InformationScreen
				
			// Помещение объекта экрана информации в объект экрана выбора.
			this.addChild( this._InformationScreen );				
			// Регистрирация объекта-прослушивателя события наступления
			// момента времени закрытия экрана информации.
			this._InformationScreen.addEventListener
				( InformationScreen.SHOULD_CLOSE,
				this.InformationScreenShouldCloseListener );
			// Регистрирация объекта-прослушивателя события
			// закрытия экрана медиа-плеера.
			this._InformationScreen.addEventListener
				( InformationScreen.MEDIA_PLAYER_SCREEN_CLOSED,
				this.InformationScreenMediaPlayerScreenClosedListener );			
		} // ImagesLineImageSpriteClickListener
		
		// Метод-прослушиватель события наступления момента времени
		// закрытия экрана информации.
		// Параметры:
		// parEvent - событие.
		private function InformationScreenShouldCloseListener
			( parEvent: Event ): void
		{
			// Вызов метода-обработчика события класса.
			this._MainTracer.CallClassEventListener( ChoiceScreen.CLASS_NAME,
				"InformationScreenShouldCloseListener", parEvent );
			
			// Закрытие экрана информации.
			this.CloseInformationScreen( );
		} // InformationScreenShouldCloseListener
		
		// Метод-прослушиватель события закрытия экрана медиа-плеера.
		// Параметры:
		// parEvent - событие.
		private function InformationScreenMediaPlayerScreenClosedListener
			( parEvent: Event ): void
		{
			// Вызов метода-обработчика события класса.
			this._MainTracer.CallClassEventListener( ChoiceScreen.CLASS_NAME,
				"InformationScreenMediaPlayerScreenClosedListener", parEvent );
			
			// Если необходимо установить тип по умолчанию.
			if ( this._ShouldSetDefaultType )
			{
				// Установка типа по умолчанию.
				this.SetDefaultType( );
				// Переустановка и запуск таймера
				// установки типа по умолчанию экрана выбора.
				this._DefaultTypeSettingTimer.reset( );
				this._DefaultTypeSettingTimer.start( );						
			} // if
		} // InformationScreenMediaPlayerScreenClosedListener
		//-----------------------------------------------------------------------
		// Методы-конструкторы.
		
		// Метод-конструктор экземпляра экрана выбора.
		// Параметры:
		// parMySQLDatabaseParameters - парараметры базы данных MySQL,
		// parMainTextParameters      - основные текстовые параметры,
		// parMainTracer              - основной трассировщик,
		// parAreaRectangle           - прямоугольная область экрана выбора.		
		public function ChoiceScreen
		(
			parMySQLDatabaseParameters: MySQLParameters,
			parMainTextParameters:      TextParameters,
			parMainTracer:              Tracer,
			parAreaRectangle:           Rectangle			
		): void
		{
			// Вызов метода-конструктора суперкласса Sprite.
			super( );
			
			// Парараметры базы данных MySQL.
			this._MySQLDatabaseParameters = parMySQLDatabaseParameters;
			// Основные текстовые параметры.
			this._MainTextParameters      = parMainTextParameters;	
			// Ocновной трассировщик.
			this._MainTracer              = parMainTracer;
			// Абсцисса экрана выбора.
			this.x                        = parAreaRectangle.x;
			// Ордината экрана выбора.
			this.y                        = parAreaRectangle.y;
			// Определение прямоугольной области прокрутки экрана выбора
			// заданной высоты и ширины.
			this.scrollRect = new Rectangle( 0, 0, parAreaRectangle.width,
				parAreaRectangle.height );
			
			// Создание нового экземпляра класса.
			this._MainTracer.CreateClassNewInstance( ChoiceScreen.CLASS_NAME,
				parMySQLDatabaseParameters, parMainTextParameters, parMainTracer,
				parAreaRectangle );			
			
			// Для удаления кнопок меню, соответствующих типам,
			// для которых все строки изображений будут пусты, проводится тест:
			// просматриваются все известные типы
			// и подсчитывается количество изображений в каждой строке изображений,
			// хранящей информацию в соответствии с текущим просматриваемым типом,
			// если для какого-то типа количество изображений
			// во всех строках изображений окажется нулевым,
			// то для такого типа кнопка меню создаваться не будет.	
			
			// Текущий тестируемый тип - первый после типа по умолчанию.
			this._Type = ChoiceScreenType.ValueOfIndex
				( ChoiceScreenType.IndexOfValue( ChoiceScreenType.DEFAULT ) + 1 );
			// Массив количеств названий изображений в строках изображений,
			// хранящих информацию в соответствии с типами.
			// Новый элемент текущего тестируемого типа - массив,
			// элементы которого соответствуют типам строк изображений.
			this._TypesImagesLinesImagesNamesCounts[ this._Type ] =
				new Array( ChoiceScreen.IMAGES_LINES_NUMBER );
			// Количество протестированных строк изображений,
			// хранящих информацию, соответствующую текущему тестируемому типу.
			this._TestCurrentTypeImagesLinesCount = 0;				
			
			// Последовательный просмотр выборщиков названий изображений
			// строк изображений.
			for
			(
				var imagesLineTypeIndex: uint =
					ImagesLineType.KNOWN_VALUE_MINIMUM_INDEX;
				imagesLineTypeIndex          <=
					ImagesLineType.KNOWN_VALUE_MAXIMUM_INDEX;
				imagesLineTypeIndex++
			)
			{
				// Тип текущей строки изображений.
				var imagesLineType: String =
					ImagesLineType.ValueOfIndex( imagesLineTypeIndex );
				
				// Создание выборщика названий изображений строки изображений.
				this._ImagesLinesImagesNamesSelectors[ imagesLineType ] =
					new ImagesNamesSelector
					(
					 	this._MySQLDatabaseParameters,
					 	this._Type,
						imagesLineType,
						this._MainTracer
					); // new ImagesNamesSelector
					
				// Загрузка XML-результата при выполнении тестового запроса
				// к базе данных MySQL для подсчёта количества изображений
				// строки изображений.
				this._ImagesLinesImagesNamesSelectors[ imagesLineType ].
					LoadRequest( );					
				// Регистрирация объекта-прослушивателя события успешной загрузки
				// XML-результата при выполнении тестового запроса
				// к базе данных MySQL для подсчёта количества изображений
				// строк изображений.	
				this._ImagesLinesImagesNamesSelectors[ imagesLineType ].
					addEventListener( PHPRequester.REQUEST_LOADING_COMPLETE,
				this.TestRequestXMLResultLoadingCompleteListener );
				// Регистрирация объекта-прослушивателя события
				// возникновения ошибки при загрузке XML-результата
				// при выполнении тестового запроса к базе данных MySQL
				// для подсчёта количества изображений строк изображений.	
				this._ImagesLinesImagesNamesSelectors[ imagesLineType ].
					addEventListener( PHPRequester.REQUEST_LOADING_IO_ERROR,
				this.TestRequestXMLResultLoadingIOErrorListener );
			} // for
		} // ChoiceScreen
		//-----------------------------------------------------------------------
		// Get- и set-методы.
		
		// Get-метод получения статического диспетчера событий.
		// Результат: статический диспетчер событий.
		public static function get StaticEventDispatcher( ): EventDispatcher
		{
			// Статический диспетчер событий.
			return ChoiceScreen._StaticEventDispatcher;
		} // StaticEventDispatcher
		
		// Get-метод получения парараметров базы данных MySQL.
		// Результат: парараметры базы данных MySQL.
		public function get MySQLDatabaseParameters( ): MySQLParameters
		{
			// Парараметры базы данных MySQL.
			return this._MySQLDatabaseParameters;
		} // MySQLDatabaseParameters
		
		// Get-метод получения основных текстовых параметров.
		// Результат: основные текстовые параметры.
		public function get MainTextParameters( ): TextParameters
		{
			// Основные текстовые параметры.
			return this._MainTextParameters;
		} // MainTextParameters		
		
		// Get-метод получения типа.
		// Результат: тип.
		public function get Type( ): String
		{
			// Тип.
			return this._Type;
		} // Type

		// Set-метод установки типа.
		// Параметры:
		// parType - тип.
		public function set Type( parType: String ): void
		{
			// Установка свойства класса.
			this._MainTracer.SetClassPropertie( ChoiceScreen.CLASS_NAME,
				"Type", parType );
			
			// Получение нового типа.
			parType = ChoiceScreenType.GetValueFromString( parType );			
			// Признак равенства старого и нового типов.
			var oldAndNewTypesAreEqual: Boolean;
			
			// Если новый тип равен прежнему.
			if ( this._Type == parType )
				// Признак равенства старого и нового типов истинен.
				oldAndNewTypesAreEqual = true;
			// Если новый тип не равен прежнему.
			else
			{
				// Признак равенства старого и нового типов ложен.
				oldAndNewTypesAreEqual = false;
				// Устновка нового типа.
				this._Type = parType;
			} // else
			
			// Последовательный просмотр
			// выборщиков названий изображений строк изображений.
			for
			(
				var imagesLineTypeIndex: uint =
					ImagesLineType.KNOWN_VALUE_MINIMUM_INDEX;
				imagesLineTypeIndex          <=
					ImagesLineType.KNOWN_VALUE_MAXIMUM_INDEX;
				imagesLineTypeIndex++
			)
			{
				// Тип текущей строки изображений.				
				var imagesLineType: String =
					ImagesLineType.ValueOfIndex( imagesLineTypeIndex );
				// Остановка движения текущей строки изображений.
				this._ImagesLines[ imagesLineType ].StopMotion( );						
					
				// Если новый тип не равен прежнему.
				if ( ! oldAndNewTypesAreEqual )
				{
					// Смена типа экрана выбора текущего выбощика
					// названий изображений строки изображений.
					this._ImagesLinesImagesNamesSelectors[ imagesLineType ].
						ChoiceScreenTypeValue = this._Type;
					// Загрузка XML-результата при выполнении запроса
					// к базе данных MySQL для получения
					// названий изображений строк изображений.
					this._ImagesLinesImagesNamesSelectors[ imagesLineType ].
						LoadRequest( );
				} // if
				// Если новый тип не равен прежнему.
				else
					// Установка прямоугольной области прокрутки
					// текущей строки изображений в исходное положение.
					this._ImagesLines[ imagesLineType ].
						SetScrollRectangleToHomePosition( );
			} // for			
		} // Type		

		// Get-метод получения высоты кнопки меню.
		// Результат: высота кнопки меню.
		public function get MenuButtonHeight( ): Number
		{
			// Высота кнопки меню относится к высоте области 
			// прокрутки экрана выбора с определённым коэффициентом.
			return this.scrollRect.height *
				ChoiceScreen.MenuButtonHeightToThisHeightRatio;
		} // MenuButtonHeight
		
		// Get-метод получения высоты строки изображений.
		// Результат: высота строки изображений.
		public function get ImagesLineHeight( ): Number
		{
			// Высота строки изображений - частное
			// разности высоты области прокрутки экрана выбора
			// и высоты области кнопок меню и количества строк изображений.
			return this.scrollRect.height *
				( 1 - ChoiceScreen.MenuButtonHeightToThisHeightRatio ) /
				ChoiceScreen.IMAGES_LINES_NUMBER;
		} // ImagesLineHeight
	} // ChoiceScreen
} // nijanus.customerDesktop.display