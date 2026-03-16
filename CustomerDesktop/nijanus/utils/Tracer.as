// CustomerDesktop
// Author Kate Kotova
// NIJANUS Copyright © 2004-2010
// nijanus@ymail.com
// http://nijanus.narod2.ru
//---------------------------------------------------------------------------
// Пакет дополнительных полезных классов.
package nijanus.utils
{
	// Класс трассировщика.
	public class Tracer
	{
		// Список импортированных классов из других пакетов.
		
		import flash.display.DisplayObjectContainer;
		import flash.geom.Rectangle;
		import flash.text.TextField;
		import flash.text.TextFormat;		
		import nijanus.display.GlowScrollBar;		
		import nijanus.display.TranslucentBlackSprite;
		import nijanus.text.TahomaFontParameters;
		//-----------------------------------------------------------------------
		// Статические константы.
		
		// Символ новой строки.
		public static const NEW_LINE:            String = "\n";
		// Двойная красная строка.
		public static const DOUBLE_NEW_LINE:     String =
			Tracer.NEW_LINE + Tracer.NEW_LINE;		
		// Точка.
		public static const POINT:               String = ".";
		// Запятая.
		public static const COMMA:               String = ", ";
		// Открывающая кругая скобка.
		public static const OPENING_PARENTHESIS: String = "( ";
		// Закрывающая кругая скобка.
		public static const CLOSING_PARENTHESIS: String = " )";
		// Равенство.
		public static const EQUALITY:            String = " = ";
		// Строка null-значения.
		public static const NULL_STRING:         String = "null";
				
		// Сообщение о создании нового экземпляра класса.
		public static const NEW_CLASS_INSTANCE_CREATION_MESSAGE: String =
			"Create a new instance of the class ";
		// Сообщение о вызове метода класса.
		public static const CALL_CLASS_METHOD_MESSAGE:           String =
			"Call the class method ";
		// Сообщение о вызове метода-обработчика события класса.
		public static const CALL_CLASS_EVENT_LISTENER_MESSAGE:   String =
			"Call the class event listener ";	
		// Сообщение о получении свойства класса.
		public static const GET_CLASS_PROPERTIE_MESSAGE:         String =
			"Get the class propertie ";			
		// Сообщение об установке свойства класса.
		public static const SET_CLASS_PROPERTIE_MESSAGE:         String =
			"Set the class propertie ";
		// Сообщение о возникновении ошибки.
		public static const SEND_ERROR_MESSAGE:                  String =
			"The error is occurred: ";			 
			
		// Отступ окна.
		public static const WINDOW_INDENTION:        uint = 10;
		// Двойной отступ окна.
		public static const WINDOW_DOUBLE_INDENTION: uint =
			2 * Tracer.WINDOW_INDENTION;		
			
		// Ширина полосы прокрутки текстового поля сообщения окна.
		public static const WINDOW_MESSAGE_TEXT_FIELD_SCROLL_BAR_WIDTH:
			uint = 30;
		// Высота бегунка прокрутки текстового поля сообщения окна.
		public static const WINDOW_MESSAGE_TEXT_FIELD_SCROLL_THUMB_HEIGHT:
			uint = 50;
			
		// Имя шрифта сообщения окна.
		public static const WINDOW_MESSAGE_FONT_NAME:  String =
			TahomaFontParameters.NAME;
		// Размер шрифта сообщения окна.
		public static const WINDOW_MESSAGE_FONT_SIZE:  uint   = 14;
		// Цвет шрифта сообщения окна.
		public static const WINDOW_MESSAGE_FONT_COLOR: uint   = 0xEFBBFF;
		//-----------------------------------------------------------------------
		// Переменные экземпляра класса.

		// Трасса - строка страссировки.
		public var Trace:                             String  = "";
		
		// Родительский объект-контейнер окна.
		private var _WindowParent:                    DisplayObjectContainer;
		// Признак показа окна.
		private var _WindowIsShowing:                 Boolean = false;
		// Фоновый спрайт окна.
		private var _WindowBackgroundSprite:          TranslucentBlackSprite; 
		// Текстовое поле сообщения окна.
		private var _WindowMessageTextField:          TextField;
		// Полоса прокрутки текстового поля сообщения окна.
		private var _WindowMessageTextFieldScrollBar: GlowScrollBar;
		//-----------------------------------------------------------------------
		// Статические методы.

		// Метод получения строкового представления объекта.
		// Параметры:
		// parObject - объект.
		// Результат: строковое представлние значения объекта.
		private static function GetObjectValueString( parObject: Object ): String
		{
			// Если объект не определён, то возвращается строка null-значения,
			// иначе - значение объекта, приведённое к строке.
			if ( parObject == null )
				return Tracer.NULL_STRING;
			else
				return parObject.toString( );
		} // GetObjectValueString
		//-----------------------------------------------------------------------
		// Методы экземпляра класса.
		
		// Методы трассы.
		
		// Вызов функции.
		// Параметры:
		// parFunctionName       - имя функции,
		// parFunctionParameters - массив параметров функции.
		private function CallFunction
		(
			parFunctionName:       String,
			parFunctionParameters: Array
		): void
		{
			// Добавление назания функции и открывающей круглой скобки в трассу.
			this.Trace += parFunctionName + Tracer.OPENING_PARENTHESIS;
			
			// Если список параметров функции не пуст.
			if
			(
				( parFunctionParameters        != null ) &&
				( parFunctionParameters.length != 0 )
			)
			{
				// Максимальный индекс параметра функции.
				var functionParameterMaximumIndex = parFunctionParameters.length - 1;
				
				// Просмотр всех параметров функции, кроме последнего.
				for ( var functionParameterIndex: uint = 0; functionParameterIndex <
						functionParameterMaximumIndex; functionParameterIndex++ )
					// Добавление текущего параметра функции и запятой в трассу.
					this.Trace += Tracer.GetObjectValueString
						( parFunctionParameters[ functionParameterIndex ] ) +
						Tracer.COMMA;
						
				// Добавление последнего параметра функции в трассу.
				this.Trace += Tracer.GetObjectValueString
					( parFunctionParameters[ functionParameterMaximumIndex ] );
			} // if
			
			// Добавление закрывающей круглой скобки в трассу.
			this.Trace += Tracer.CLOSING_PARENTHESIS;			
		} // CallFunction	
		
		// Создание нового экземпляра класса.
		// Параметры:
		// parClassName             - имя класса,
		// parConstructorParameters - массив параметров конструктора.
		public function CreateClassNewInstance
		(
			   parClassName: String,
			...parConstructorParameters
		): void
		{
			// Добавление красной строки в трассу.
			this.Trace += Tracer.NEW_LINE;			
			// Добавление сообщения о создании нового экземпляра класса в трассу.
			this.Trace += Tracer.NEW_CLASS_INSTANCE_CREATION_MESSAGE;
			// Вызов функции-коструктора класса.
			this.CallFunction( parClassName, parConstructorParameters );
			// Добавление двойной красной строки в трассу.
			this.Trace += Tracer.DOUBLE_NEW_LINE;	
		} // CreateClassNewInstance
		
		// Вызов метода класса.
		// Параметры:
		// parClassName        - имя класса,
		// parMethodName       - имя метода,
		// parMethodParameters - массив параметров метода.
		public function CallClassMethod
		(
			   parClassName,
				 parMethodName: String,
			...parMethodParameters
		): void		
		{
			// Добавление сообщения о вызове метода класса в трассу.
			this.Trace += Tracer.CALL_CLASS_METHOD_MESSAGE;
			// Полное имя метода класса:
			// имя класса, точка, имя метода.
			var classMethodName = parClassName + Tracer.POINT + parMethodName;
			// Вызов функции-метода класса.
			this.CallFunction( classMethodName, parMethodParameters );
			// Добавление двойной красной строки в трассу.
			this.Trace += Tracer.DOUBLE_NEW_LINE;				
		} // CallClassMethod
		
		// Вызов метода-обработчика события класса.
		// Параметры:
		// parClassName               - имя класса,
		// parEventListenerName       - имя метода-обработчика события,
		// parEventListenerParameters - массив параметров
		//   метода-обработчика события.
		public function CallClassEventListener
		(
			   parClassName,
				 parEventListenerName: String,
			...parEventListenerParameters
		): void	
		{
			// Добавление сообщения о вызове метода-обработчика события класса
			// в трассу.
			this.Trace += Tracer.CALL_CLASS_EVENT_LISTENER_MESSAGE;
			// Полное имя метода-обработчика события класса:
			// имя класса, точка, имя метода-обработчика события.
			var classEventListenerName = parClassName + Tracer.POINT +
				parEventListenerName;
			// Вызов функции-метода-обработчика события класса.
			this.CallFunction( classEventListenerName,
				parEventListenerParameters );
			// Добавление двойной красной строки в трассу.
			this.Trace += Tracer.DOUBLE_NEW_LINE;			
		} // CallClassEventListener
		
		// Получение свойства класса.
		// Параметры:
		// parClassName      - имя класса,
		// parPropertieName  - имя свойства,
		// parPropertieValue - значение свойства.
		public function GetClassPropertie
		(
			parClassName,
			parPropertieName:  String,
			parPropertieValue: Object
		): void				
		{
			// Добавление сообщения о получении свойства класса в трассу.
			this.Trace += Tracer.GET_CLASS_PROPERTIE_MESSAGE;
			// Полное имя свойства класса:
			// имя класса, точка, имя свойства.
			var classPropertieName = parClassName + Tracer.POINT +
				parPropertieName;				
			// Добавление полного имени свойства, знака равенства
			// и значения свойства в трассу.
			this.Trace += classPropertieName + Tracer.EQUALITY +
				parPropertieValue.toString( );
			// Добавление двойной красной строки в трассу.
			this.Trace += Tracer.DOUBLE_NEW_LINE;			
		} // GetClassPropertie			
		
		// Установка свойства класса.
		// Параметры:
		// parClassName      - имя класса,
		// parPropertieName  - имя свойства,
		// parPropertieValue - значение свойства.
		public function SetClassPropertie
		(
			parClassName,
			parPropertieName:  String,
			parPropertieValue: Object
		): void				
		{
			// Добавление сообщения об установке свойства класса в трассу.
			this.Trace += Tracer.SET_CLASS_PROPERTIE_MESSAGE;
			// Полное имя свойства класса:
			// имя класса, точка, имя свойства.
			var classPropertieName = parClassName + Tracer.POINT +
				parPropertieName;				
			// Добавление полного имени свойства, знака равенства
			// и значения свойства в трассу.
			this.Trace += classPropertieName + Tracer.EQUALITY +
				parPropertieValue.toString( );
			// Добавление двойной красной строки в трассу.
			this.Trace += Tracer.DOUBLE_NEW_LINE;			
		} // SetClassPropertie		
		
		// Послание сообщения об ошибке.
		// Параметры:
		// parErrorMessage - сообщение об ошбике.
		public function SendErrorMessage( parErrorMessage: String )
		{
			// Добавление сообщения о возникновении ошибки,
			// сообщения об ошбике и двойной красной строки в трассу.
			this.Trace += Tracer.SEND_ERROR_MESSAGE + parErrorMessage +
				Tracer.DOUBLE_NEW_LINE;		
		} // SendErrorMessage
		
		// Послание сообщения.
		// Параметры:
		// parMessage - сообщение.
		public function SendMessage( parMessage: String )
		{
			// Добавление сообщения и двойной красной строки в трассу.
			this.Trace += parMessage + Tracer.DOUBLE_NEW_LINE;		
		} // SendMessage
		
		// Методы окна.
		
		// Метод инициализации фонового спрайта окна.
		// Параметры:
		// parWindowRectangle - прямоугольная область окна.
		private function InitializeWindowBackgroundSprite
			( parWindowRectangle: Rectangle ): void
		{
			// Удаление прежнего фонового спрайта окна.
			if ( this._WindowBackgroundSprite != null )
				this._WindowBackgroundSprite = null;				
			// Создание фонового спрайта окна.
			this._WindowBackgroundSprite = new TranslucentBlackSprite( );
			
			// Координаты фонового спрайта окна.
			this._WindowBackgroundSprite.x      = parWindowRectangle.x;
			this._WindowBackgroundSprite.y      = parWindowRectangle.y;
			// Размеры фонового спрайта окна.
			this._WindowBackgroundSprite.width  = parWindowRectangle.width;
			this._WindowBackgroundSprite.height = parWindowRectangle.height;			
		} // InitializeWindowBackgroundSprite
		
		// Метод инициализации текстового поля сообщения окна.
		private function InitializeWindowMessageTextField( ): void
		{
			// Удаление прежнего текстового поля сообщения окна.
			if ( this._WindowMessageTextField != null )
				this._WindowMessageTextField = null;
			// Создание текстового поля сообщения окна.
			this._WindowMessageTextField = new TextField( );
			
			// Коодинаты текстового поля сообщения окна.
			this._WindowMessageTextField.x      = 
				this._WindowBackgroundSprite.BoundsWithoutBorder.x      +
				Tracer.WINDOW_INDENTION;
			this._WindowMessageTextField.y      =
				this._WindowBackgroundSprite.BoundsWithoutBorder.y      +
				Tracer.WINDOW_INDENTION;
			// Размеры текстового поля сообщения окна.
			this._WindowMessageTextField.width  = 
				this._WindowBackgroundSprite.BoundsWithoutBorder.width  -
				Tracer.WINDOW_MESSAGE_TEXT_FIELD_SCROLL_BAR_WIDTH       -
				Tracer.WINDOW_DOUBLE_INDENTION;
			this._WindowMessageTextField.height =
				this._WindowBackgroundSprite.BoundsWithoutBorder.height -
				Tracer.WINDOW_DOUBLE_INDENTION;	
				
			// Признак выполнения автоматической прокрутки
			// многострочного текстового поля сообщения окна,
			// когда пользователь щелкает по нему нему мышью
			// и вращает её колёсико.
			this._WindowMessageTextField.mouseWheelEnabled = false;				
			// Признак многострочности текстового поля сообщения окна.
			this._WindowMessageTextField.multiline         = true;
			// Признак наличия возможности выделения
			// текстового поля сообщения окна.
			this._WindowMessageTextField.selectable        = false;
			// Признак применения переноса по словам
			// к текстовому полю сообщения окна.
			this._WindowMessageTextField.wordWrap          = true;
			// Формат шрифта текстового поля сообщения окна по умолчанию.
			this._WindowMessageTextField.defaultTextFormat =
				new TextFormat
				(
					// Имя шрифта сообщения окна.
					Tracer.WINDOW_MESSAGE_FONT_NAME,
					// Размер шрифта сообщения окна.
					Tracer.WINDOW_MESSAGE_FONT_SIZE,
					// Цвет шрифта сообщения окна.
					Tracer.WINDOW_MESSAGE_FONT_COLOR
				); // new TextFormat
		} // InitializeWindowMessageTextField
		
		// Метод инициализации полосы прокрутки текстового поля сообщения окна.
		private function InitializeWindowMessageTextFieldScrollBar( ): void	
		{
			// Удаление прежней полосы прокрутки текстового поля сообщения окна.
			if ( this._WindowMessageTextFieldScrollBar != null )
				this._WindowMessageTextFieldScrollBar = null;			
			// Создание полосы прокрутки текстового поля сообщения окна.
			this._WindowMessageTextFieldScrollBar =
				new GlowScrollBar
				(
				 	// Цель прокрутки - текстовое поле сообщения окна.
					this._WindowMessageTextField,
					// Ширина.
					Tracer.WINDOW_MESSAGE_TEXT_FIELD_SCROLL_BAR_WIDTH,
					// Высота бегунка прокрутки.
					Tracer.WINDOW_MESSAGE_TEXT_FIELD_SCROLL_THUMB_HEIGHT
				); // new GlowScrollBar
		} // InitializeDiskDescriptionScrollBar
		
		// Метод создания окна.
		// Параметры:
		// parWindowParent    - родительский объект-контейнер окна,
		// parWindowRectangle - прямоугольная область окна.
		public function CreateWindow
		(
			parWindowParent:    DisplayObjectContainer,
			parWindowRectangle: Rectangle
		): void
		{
			// Родительский объект-контейнер окна.			
			this._WindowParent = parWindowParent;			
			// Инициализация фонового спрайта окна.
			this.InitializeWindowBackgroundSprite( parWindowRectangle );
			// Инициализация текстового поля сообщения окна.
			this.InitializeWindowMessageTextField( );
		} // InitialiazeWindow
		
		// Метод обновления текстового поля сообщения окна.
		public function RefreshWindowMessageTextField( ): void
		{
			// Показ трассы в текстовом поле сообщения окна.
			this._WindowMessageTextField.text = this.Trace;
			// Инициализация полосы прокрутки текстового поля сообщения окна.
			this.InitializeWindowMessageTextFieldScrollBar( );			
		} // RefreshWindowMessageTextField
		
		// Метод показа окна.
		public function ShowWindow( ): void
		{
			// Если окно уже показывается, то ещё раз показывать нет смысла.
			if ( this._WindowIsShowing )
				return;
			
			// Обновление текстового поля сообщения окна.
			this.RefreshWindowMessageTextField( );
			// Добавление компонентов на родительский контейнер.
			this._WindowParent.addChild( this._WindowBackgroundSprite );
			this._WindowParent.addChild( this._WindowMessageTextField );
			this._WindowParent.addChild( this._WindowMessageTextFieldScrollBar );
			
			// Признак показа окна истинен.
			this._WindowIsShowing = true;
		} // ShowWindow 
		
		// Метод сокрытия окна.
		public function HideWindow( ): void		
		{
			// Если окно уже спрятано, то ещё раз прятать нет смысла.
			if ( ! this._WindowIsShowing )
				return;				
				
			// Удаление компонентов с родительского контейнера.
			if ( this._WindowBackgroundSprite.parent          != null )
				this._WindowParent.removeChild( this._WindowBackgroundSprite );
			if ( this._WindowMessageTextField.parent          != null )
				this._WindowParent.removeChild( this._WindowMessageTextField );
			if ( this._WindowMessageTextFieldScrollBar.parent != null )
				this._WindowParent.removeChild
					( this._WindowMessageTextFieldScrollBar );	
				
			// Признак показа окна ложен.
			this._WindowIsShowing = false;				
		} // HideWindow
		//-----------------------------------------------------------------------
		// Методы-конструкторы.

		// Метод-конструктор экземпляра трассировщика.
		public function Tracer( ): void
		{
		} // Tracer
		//-----------------------------------------------------------------------		
		// Get- и set-методы.

		// Get-метод получения признака показа окна.
		// Результат: признак показа окна.
		public function get WindowIsShowing( ): Boolean
		{
			// Признак показа окна.
			return this._WindowIsShowing;
		} // WindowIsShowing		
	} // Tracer
} // nijanus.utils