// CustomerDesktop
// Author Kate Kotova
// NIJANUS Copyright © 2004-2010
// nijanus@ymail.com
// http://nijanus.narod2.ru
//---------------------------------------------------------------------------
// Пакет классов, связанных с отображением.
package nijanus.display
{ 
	// Список импортированных классов из других пакетов.
	import flash.events.MouseEvent;
	//-------------------------------------------------------------------------

	// Класс события спрайта изображения.
	public class ImageSpriteEvent extends MouseEvent
	{
		// Список импортированных классов из других пакетов.

		import flash.display.InteractiveObject;
		import flash.events.Event;
		//-----------------------------------------------------------------------		
		// Статические константы.

		// Название типа события успешной загрузки изображения
		// на спрайт изображения.
		public static const IMAGE_SPRITE_IMAGE_LOADING_COMPLETE:
			String = "ImageSpriteImageLoadingComplete";
		// Название типа события возникновения ошибки при загрузки изображения
		// на спрайт изображения.
		public static const IMAGE_SPRITE_IMAGE_LOADING_IO_ERROR:
			String = "ImageSpriteImageLoadingIOError";			
		// Название типа события клика мыши на спрайте изображения.
		public static const IMAGE_SPRITE_CLICK: String = "ImageSpriteClick";
		//-----------------------------------------------------------------------		
		// Переменные экземпляра класса.

		// Спрайт изображения, на котором произошло событие.
		private var _TargetImageSprite: ImageSprite = null;
		//-----------------------------------------------------------------------
		// Методы экземпляра класса.
		
		// Метод, создающий копию объекта события спрайта изображения
		// и задающий значение каждого свойства, совпадающее с оригиналом.
		// Результат: новый объект события спрайта изображения,
		// значения свойств которого соответствуют значениям оригинала.
		override public function clone( ): Event
		{
			// Создание экземпляра события спрайта изображения.
			return new ImageSpriteEvent
			(
				this.type,
				this._TargetImageSprite,
				this.bubbles,
				this.cancelable,
				this.localX,
				this.localY,
				this.relatedObject,
				this.ctrlKey,
				this.altKey,
				this.shiftKey,
				this.buttonDown,
				this.delta
			); // return
		} // clone
		
		// Метод получения строки, содержащей все свойства
		// объекта события спрайта изображения.
		// Результат: строка, содержащая все свойства
		// объекта события спрайта изображения.
		override public function toString( ): String
		{ 
			// Служебная функция для реализации метода toString( )
			// в пользовательских классах для вывода всех свойств,
			// где eventPhase - текущая фаза в потоке событий.
			return formatToString
			(
			 	"ImageSpriteEvent",
				"type",
				"TargetImageSprite",				
				"bubbles",
				"cancelable",
				"eventPhase",
				"localX",
				"localY",
				"stageX",
				"stageY",
				"relatedObject",
				"ctrlKey",
				"altKey",
				"shiftKey",
				"delta"			
			); // return 
		}	// toString	
		//-----------------------------------------------------------------------
		// Методы-конструкторы.
		
		// Метод-конструктор экземпляра события спрайта изображения.
		// Параметры:
		// parType                - тип события,		
		// parTargetImageSprite   - спрайт изображения,
		//   на котором произошло событие,		
		// parBubbles             - признак участия события на этапе
		//   восходящей цепочки процесса события,		
		// parCancelable          - признак возможности отмены события,		
		// parLocalX              - горизонтальная координата события
		//   относительно спрайта-контейнера,		
		// parLocalY              - вертикальная координата события
		//   относительно спрайта-контейнера,		
		// parRelatedObject       - дополняющий экземпляр InteractiveObject,
		//   на который влияет событие,		
		// parCtrlKey             - признак активирования клавиши Control,		
		// parAltKey              - признак активирования клавиши Alt,		
		// parShiftKey            - признак активирования клавиши Shift,		
		// parButtonDown          - признак нажатия основной кнопки мыши,		
		// parDelta               - расстояние прокрутки в строках
		//   на единицу вращения колесика мыши.
		public function ImageSpriteEvent
		(
			parType:                String,
			parTargetImageSprite:   ImageSprite       = null,
			parBubbles:             Boolean           = true,
			parCancelable:          Boolean           = false,
			parLocalX:              Number            = NaN,
			parLocalY:              Number            = NaN,
			parRelatedObject:       InteractiveObject = null,
			parCtrlKey:             Boolean           = false,
			parAltKey:              Boolean           = false,
			parShiftKey:            Boolean           = false,
			parButtonDown:          Boolean           = false,
			parDelta:               int               = 0
		): void
		{
			// Вызов метода-конструктора суперкласса MouseEvent.
			super
			(
				parType,
				parBubbles,
				parCancelable,
				parLocalX,
				parLocalY,
				parRelatedObject,
				parCtrlKey,
				parAltKey,
				parShiftKey,
				parButtonDown,
				parDelta
			); // super
			
			// Спрайт изображения, на котором произошло событие.
			this._TargetImageSprite = parTargetImageSprite;
		} // ImageSpriteEvent
		//-----------------------------------------------------------------------			
		// Get- и set-методы.
		
		// Get-метод получения спрайта изображения, на котором произошло событие.
		// Результат: спрайт изображения, на котором произошло событие.
		public function get TargetImageSprite( ): ImageSprite
		{
			// Спрайт изображения, на котором произошло событие.
			return this._TargetImageSprite;
		} // TargetImageSprite
	} // ImageSpriteEvent
} // nijanus.display