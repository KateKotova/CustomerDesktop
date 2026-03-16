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
	import flash.display.Sprite;
	//-------------------------------------------------------------------------

	// Класс светящейся полосы прокрутки.
	public class GlowScrollBar extends Sprite
	{
		// Список импортированных классов из других пакетов.
		
		import flash.display.DisplayObject;
    import flash.events.MouseEvent;
		import flash.geom.Rectangle;
		import flash.text.TextField;		
		//-----------------------------------------------------------------------		
		// Статические константы.

		// Пустая текстовая метка для бегунка прокрутки - светящейся кнопки.
		public static const SCROLL_THUMB_EMPTY_LABEL:   String = "";		
		// Поворот в градусах по часовой стрелке бегунка прокрутки -
		// светящейся кнопки - относительно его исходной ориентации.			
		public static const SCROLL_THUMB_ROTATION:      Number = -90;
		
		// Альфа-прозрачность дорожки прокрутки по умолчанию.
		public static const SCROLL_TRACK_DEFAULT_ALPHA: Number = 0.5;
		// Альфа-прозрачность бегунка прокртки по умолчанию.
		public static const SCROLL_THUMB_DEFAULT_ALPHA: Number = 1;			
		//-----------------------------------------------------------------------
		// Переменные экземпляра класса.
		
		// Дорожка прокрутки.
		private var _ScrollTrack: GlowScrollTrack_skin =
			new GlowScrollTrack_skin( );
		// Бегунок прокрутки.
		private var _ScrollThumb: GlowButton           = new GlowButton( );
		// Цель прокрутки - текстовое поле,
		// прокручиваемое с помощью светящейся полосы прокрутки. 
		private var _ScrollTarget: TextField           = null;
		
		// Признак доступности.
		private var _IsEnabled:                  Boolean = true;		
		
		// Ордината нажатия кнопки мыши на бегунке прокрутки
		// относитльно бегункa прокрутки.
		private var _ScrollThumbMouseDownLocalY:       Number;
		// Количество текстовых строк,
		// отображаемых в текстовом поле цели прокрутки.
		private var _ScrollTargetDisplayedLinesNumber: Number;
		//-----------------------------------------------------------------------
		// Методы экземпляра класса.

		// Метод получения ординаты экранного объекта в системе координат сцены.
		// Параметры:
		// parDisplayObject - экранный объет.
		// Результат: ордината экранного объекта в системе координат сцены.
		public static function GetStageY
			( parDisplayObject: DisplayObject ): Number
		{
			// Ордината экранного объекта в системе координат сцены -
			// ордината прямоугольника, определяющего область экранного объекта,
			// которая относится к системе координат объекта сцены.
			return parDisplayObject.getBounds( parDisplayObject.stage ).y;
		} //GetStageY
		//-----------------------------------------------------------------------
		// Методы-прослушиватели событий.

		// Метод-прослушиватель события нажатия кнопки мыши на бегунке прокрутки.
		// Параметры:
		// parMouseEvent - событие мыши.
		private function ScrollThumbMouseDownListener
			( parMouseEvent: MouseEvent ): void
		{
			// Бегунок прокрутки - объект-получатель события.
			var scrollThumb: GlowButton =
				GlowButton( parMouseEvent.currentTarget );				
			
			// Ордината нажатия кнопки мыши на бегунке прокрутки
			// относитльно бегункa прокрутки:
			// разность вертикальной координаты события
			// в глобальных координатах рабочей области
			// и ординаты бегунка прокрутки в системе координат сцены.
			this._ScrollThumbMouseDownLocalY = parMouseEvent.stageY -
				GlowScrollBar.GetStageY( scrollThumb );		
			
			// Отмена регистрирации объекта-прослушивателя события
			// нажатия кнопки мыши на бегунке прокрутки.
			scrollThumb.removeEventListener
				( MouseEvent.MOUSE_DOWN, ScrollThumbMouseDownListener );
			// Регистрирация объекта-прослушивателя события
			// перемещения курсора мыши над объектом-получателем данного события -
			// бегунком прокрутки.
			scrollThumb.addEventListener
				( MouseEvent.MOUSE_MOVE, this.ScrollThumbMouseMoveListener );
			// Регистрирация объекта-прослушивателя события отпускания кнопки мыши
			// на бегунке прокрутки.
			scrollThumb.addEventListener 
				( MouseEvent.MOUSE_UP,  	this.ScrollThumbMouseUpListener );
			// Регистрирация объекта-прослушивателя события
			// покидания бегунка прокрутки указателем мыши.
			scrollThumb.addEventListener
				( MouseEvent.ROLL_OUT, 		this.ScrollThumbRollOutListener );
				
			// Начало перетаскивания бегунка прокрутки
			// по заданной вертикальной линии.
			scrollThumb.startDrag( false, this.ScrollThumbDragRectangle );
		} // ScrollThumbMouseDownListener
		
		// Метод-прослушиватель события перемещения курсора мыши
		// над бегунком прокрутки.
		// Параметры:
		// parMouseEvent - событие мыши.
		private function ScrollThumbMouseMoveListener
			( parMouseEvent: MouseEvent ): void
		{
			// Для вертикальной прокрутки текста в текстовом поле
			// существует свойство, определяющее вертикальное положение текста
			// в текстовом поле, единицей измерения которого являются строки.
			
			// При перетаскивании, к сожалению, нельзя считывать координаты
			// перетаскиваемого объекта: они почему-то сохраняют позицию момента,
			// с которого перетаскивание началось. Поэтому надо использовать
			// координату указателя мыши относительно сцены.
			
			// Текущая координата бегунка прокрутки отностильно сцены:
			// разность вертикальной координаты события мыши
			// в глобальных координатах рабочей области,
			// ординаты светящейся полосы прокрутки в системе координат сцены
			// и ординаты нажатия кнопки мыши на бегунке прокрутки
			// относитльно бегункa прокрутки.
			var scrollThumbCurrentY:                    Number =
				parMouseEvent.stageY            -
				GlowScrollBar.GetStageY( this ) -
				this._ScrollThumbMouseDownLocalY;
				
			// Максимально возможная длина пути бегунка прокрутки:
			// разность высоты дорожки прокрутки и высоты бегунка прокрутки.
			var scrollThumbMaximumDistance:             Number =
				this._ScrollTrack.height -
				this.ScrollThumbHeight;
				
			// Количество текстовых строк,
			// неотображаемых в текстовом поле цели прокрутки:
			// разность общего количества строк текста
			// в многострочном текстовом поле цели прокрутки,
			// учитывающего увеличение количества строкри при переносе текста,
			// и количества текстовых строк,
			// отображаемых в текстовом поле цели прокрутки.
			var scrollTargetInvisibleLinesNumber:       Number =
				this._ScrollTarget.numLines -
				this._ScrollTargetDisplayedLinesNumber;
				
			// Длина пути бегунка прокрутки, необходимого бегунку прокрутки
			// для прокрутки одной строки текста текстового поля цели прокрутки -
			// количество пикселей, расчитанное	на прокрутку одной строки текста
			// текстового поля цели прокрутки:
			// частное максимально возможной длины пути бегунка прокрутки
			// и количества текстовых строк,
			// неотображаемых в текстовом поле цели прокрутки.
			var scrollTargetOneLineScrollThumbDistance: Number =
				scrollThumbMaximumDistance / scrollTargetInvisibleLinesNumber;
			
			// Текущее вертикальное положение текста в текстовом поле
			// цели прокрутки, единицей измерения которого являются строки -
			// количество строк, измеряемых в пикселях, содержащихся
			// в расстоянии, пройденном бегунком рокрутки:
			// частное текущей координаты бегунка прокрутки отностильно сцены
			// и длины пути бегунка прокрутки, необходимого бегунку прокрутки
			// для прокрутки одной строки текста текстового поля цели прокрутки.
			this._ScrollTarget.scrollV = scrollThumbCurrentY /
				scrollTargetOneLineScrollThumbDistance;
		} // ScrollThumbMouseMoveListener			
		
		// Метод-прослушиватель события отпускания кнопки мыши
		// на бегунке прокрутки.
		// Параметры:
		// parMouseEvent - событие мыши.
		private function ScrollThumbMouseUpListener
			( parMouseEvent: MouseEvent ): void
		{
			// Бегунок прокрутки - объект-получатель события.
			var scrollThumb: GlowButton =
				GlowButton( parMouseEvent.currentTarget );
				
			// Отмена регистрирации объекта-прослушивателя события
			// перемещения курсора мыши над бегунком прокрутки.
			scrollThumb.removeEventListener
				( MouseEvent.MOUSE_MOVE, ScrollThumbMouseMoveListener );
			// Отмена регистрирации объекта-прослушивателя события
			// отпускания кнопки мыши на бегунке прокрутки.
			scrollThumb.removeEventListener 
				( MouseEvent.MOUSE_UP,  	this.ScrollThumbMouseUpListener );
			// Отмена регистрирации объекта-прослушивателя события
			// покидания бегунка прокрутки указателем мыши.
			scrollThumb.removeEventListener
				( MouseEvent.ROLL_OUT, 		this.ScrollThumbRollOutListener );				
			// Регистрирация объекта-прослушивателя события нажатия кнопки мыши
			// на бегунке прокрутки.
			scrollThumb.addEventListener
				( MouseEvent.MOUSE_DOWN, this.ScrollThumbMouseDownListener );			
				
			// Окончание перетаскивания бегунка прокрутки.
			scrollThumb.stopDrag( );	
		} // ScrollThumbMouseUpListener		
		
		// Метод-прослушиватель события покидания бегунка прокрутки
		// указателем мыши.
		// Параметры:
		// parMouseEvent - событие мыши.
		private function ScrollThumbRollOutListener
			( parMouseEvent: MouseEvent ): void
		{
			// Покидание бегунка прокрутки указателем мыши
			// эквивалентно отпусканию кнопки мыши на бегунке прокрутки.
			
			// Отпускание кнопки мыши на бегунке прокрутки.
			this.ScrollThumbMouseUpListener( parMouseEvent );		
		} // ScrollThumbRollOutListener
		//-----------------------------------------------------------------------
		// Методы-конструкторы.

		// Метод-конструктор экземпляра светящейся полосы прокрутки.
		// Параметры:
		// parScrollTarget - цель прокрутки,
		// parWidth        - ширина,
		// parHeight       - высота бегунка прокрутки.
		public function GlowScrollBar
		(
			parScrollTarget:      TextField,
			parWidth,			
			parScrollThumbHeight: Number			
		): void		
		{
			// Вызов метода-конструктора суперкласса Sprite.
			super( );		
			// Добавление объекта дорожки прокрутки
			// в объект светящейся полосы прокрутки.
			this.addChild( this._ScrollTrack );
			// Добавление объекта бегунка прокрутки
			// в объект светящейся полосы прокрутки.
			this.addChild( this._ScrollThumb );			
			
			// Цель прокрутки.
			this._ScrollTarget = parScrollTarget;
			
			// Ширина светящейся полосы прокрутки, ширина дорожки прокрутки
			// и ширина бегунка прокрутки равны.	
			
			// Ширина дорожки прокрутки.
			this._ScrollTrack.width = parWidth;
			// Ширина бегунка прокрутки.
			this.ScrollThumbWidth   = parWidth;
			// Ширина.
			this.width              = parWidth;				
			
			// Высота бегунка прокрутки.
			this.ScrollThumbHeight = parScrollThumbHeight;
			
			// Дорожка прокрутки и бегунок прокрутки находятся
			// в левом верхнем углу светящейся полосы прокрутки.
			
			// Абсцисса дорожки прокрутки.
			this._ScrollTrack.x = 0;
			// Ордината дорожки прокрутки.
			this._ScrollTrack.y = 0;			
			// Абсцисса бегунка прокрутки.
			this.ScrollThumbX   = 0;
			// Ордината бегунка прокрутки.
			this.ScrollThumbY   = 0;
						
			// Если цель прокрутки не определена.
			if ( parScrollTarget == null )
			{
				// Координаты светящейся полосы прокрутки обнуляются.
				
				// Абсцисса.
				this.x = 0;
				// Ордината.
				this.y = 0;
				
				// Высота светящейся полосы прокрутки и высота дорожки прокрутки
				// приравниваются к высоте бегунка прокрутки.
				
				// Высота дорожки прокрутки.
				this._ScrollTrack.height = parScrollThumbHeight;
				// Высота.
				this.height              = parScrollThumbHeight;								
				
				// Бегунок прокрутки недоступен.
				this._ScrollThumb.enabled = false;				
				return;
			} // if
			
			// Светящаяся полоса прокрутки располагается слева от цели прокрутки,
			// то есть абсцисса левой стороны светящейся полосы прокрутки -
			// абсцисса правой стороны цели прокрутки,
			// а ордината верхей стороны светящейся полосы прокрутки -
			// ордината верхней стороны цели прокрутки.
			
			// Абсцисса:
			// сумма абсциссы цели прокрутки и её ширины.
			this.x = parScrollTarget.x + parScrollTarget.width;
			// Ордината - ордината цели прокрутки.
			this.y = parScrollTarget.y;
			
			// Высота светящейся полосы прокрутки и высота дорожки прокрутки равны
			// и равны высоте цели прокрутки.
			
			// Высота дорожки прокрутки.
			this._ScrollTrack.height = parScrollTarget.height;
			// Высота.
			this.height              = parScrollTarget.height;			
		
			// Ширина и масштабирование от точки регистрации
			// почему-то по ходу изменяются, поэтому они восстанавливаются.
			
			// Ширина.
			this.width = parWidth;	
			// Горизонтальное масштабирование от точки регистрации - 100 %.
			this.scaleX = 1;
			// Вертикальное   масштабирование от точки регистрации - 100 %.
			this.scaleY = 1;
			
			// Установка вертикального положение текста
			// в текстовом поле цели прокрутки в первую строку,
			// начало отсчёта которого - единица, а единица измерения - строки.
			parScrollTarget.scrollV = 1;
			// Теперь целое число (индекс, отсчитываемый от 1), соответствующее
			// самой нижней строке, которую видно в текстовом поле цели прокрутки,
			// равно количеству текстовых строк, отображаемых
			// в текстовом поле цели прокрутки.
			this._ScrollTargetDisplayedLinesNumber = parScrollTarget.bottomScrollV;
		
			// Альфа-прозрачность дорожки прокрутки - по умолчанию.
			this._ScrollTrack.alpha = GlowScrollBar.SCROLL_TRACK_DEFAULT_ALPHA;
			// Альфа-прозрачность бегунка прокрутки - по умолчанию.
			this._ScrollThumb.alpha = GlowScrollBar.SCROLL_THUMB_DEFAULT_ALPHA;	
			
			// Пустая текстовая метка для бегунка прокрутки.
			this._ScrollThumb.label    = GlowScrollBar.SCROLL_THUMB_EMPTY_LABEL;
			// Поворот в градусах по часовой стрелке бегунка прокрутки -
			// светящейся кнопки - относительно его исходной ориентации.	
			this._ScrollThumb.rotation = GlowScrollBar.SCROLL_THUMB_ROTATION;
			
			// Если высота текста цели прокрутки в пикселах не превышает
			// высоту цели прокрутки, то полоса прокрутки не нужна.
			if ( parScrollTarget.textHeight <= parScrollTarget.height )
			{
/*				
				// Ширина цели прокрутки увеличивается на ширину
				// светящейся полосы прокрутки, которая исчезнет.
				parScrollTarget.width += this.width;
*/				
				// Светящаяся полоса прокрутки становится недоступной.
				this.IsEnabled         = false;
				// Светящаяся полоса прокрутки становится невидимой.
				this.visible           = false;				
				return;
			} // if			
			
			// Регистрирация объекта-прослушивателя события нажатия кнопки мыши
			// на бегунке прокрутки.
			this._ScrollThumb.addEventListener( MouseEvent.MOUSE_DOWN,
				this.ScrollThumbMouseDownListener );
		} // GlowScrollBar		
		//-----------------------------------------------------------------------		
		// Get- и set-методы.
		
		// Get-метод получения текстового поля,
		// прокручиваемого с помощью светящейся полосы прокрутки. 
		// Результат: текстовое поле,
		// прокручиваемое с помощью светящейся полосы прокрутки. 
		public function get ScrollTarget( ): TextField
		{
			// Текстовое поле,
			// прокручиваемое с помощью светящейся полосы прокрутки.
			return this._ScrollTarget;
		} // ScrollTarget
		
		// Get-метод получения прямоугольной области относительно координат
		// светящейся полосы прокрутки, в пределах которой
		// может перетасикаться бегунок прокрутки.
		// Результат: прямоугольная область относительно координат
		// светящейся полосы прокрутки, в пределах которой
		// может перетасикаться бегунок прокрутки.
		private function get ScrollThumbDragRectangle( ): Rectangle
		{
			// Чтобы бегунок прокрутки перемещался строго вертикально,
			// прямоугольник - нулевой ширины -
			// вырождается в вертикальную прямую линию.
			
			// Прямоугольная область относительно координат
			// светящейся полосы прокрутки, в пределах которой
			// может перетасикаться бегунок прокрутки.
			return new Rectangle
				(		
					// Абсцисса прямоугольной области перетаскивания
					// бегунка прокрутки - его повернуная ордината и она нулевая,
					// потому что левая сторона бегунка прокрутки
					// лежит на левой стороне дорожки прокрутки.
					0,
					// Ордината прямоугольной области перетаскивания
					// бегунка прокрутки - его повернуная абсцисса,
					// которая оказалась внизу, поэтому, чтобы верхняя сторона
					// бегунка прокрутки лежала на верхней стороне дорожки прокрутки,
					// надо сделать поправку на высоту бегунка прокрутки -
					// его повёрнутую ширину.
					this.ScrollThumbHeight,
					// Ширина прямоугольной области перетаскивания бегунка прокрутки -
					// нулевая, потому что бегунок прокрутки перемещался
					// строго вертикально.
					0,
					// Высота прямоугольной области перетаскивания бегунка прокрутки -
					// высота дорожки прокрутки без высоты бегунка прокрутки,
					// потому что бегунок прокрутки не должен выходить за пределы
					// дорожки прокрутки и его нижняя предельная ордината
					// нижней стороны - ордината нижней стороны дорожки прокрутки.
					this._ScrollTrack.height - this.ScrollThumbHeight
				); // return 
		} // ScrollThumbDragRectangle
		
		// Get-метод получения альфа-прозрачности дорожки прокрутки.
		// Результат: альфа-прозрачность дорожки прокрутки.
		public function get ScrollTrackAlpha( ): Number
		{
			// Альфа-прозрачность дорожки прокрутки.
			return this._ScrollTrack.alpha;
		} // ScrollTrackAlpha

		// Set-метод установки альфа-прозрачности дорожки прокрутки.
		// Параметры:
		// parScrollTrackAlpha - альфа-прозрачность дорожки прокрутки.
		public function set ScrollTrackAlpha( parScrollTrackAlpha: Number ): void
		{
			// Альфа-прозрачность дорожки прокрутки.			
			this._ScrollTrack.alpha = parScrollTrackAlpha;
		} // ScrollTrackAlpha
		
		// Get-метод получения альфа-прозрачности бегунка прокрутки.
		// Результат: альфа-прозрачность бегунка прокрутки.
		public function get ScrollThumbAlpha( ): Number
		{
			// Альфа-прозрачность бегунка прокрутки.
			return this._ScrollThumb.alpha;
		} // ScrollThumbAlpha

		// Set-метод установки альфа-прозрачности бегунка прокрутки.
		// Параметры:
		// parScrollThumbAlpha - альфа-прозрачность бегунка прокрутки.
		public function set ScrollThumbAlpha( parScrollThumbAlpha: Number ): void
		{
			// Альфа-прозрачность бегунка прокрутки.			
			this._ScrollThumb.alpha = parScrollThumbAlpha;
		} // ScrollThumbAlpha
		
		// Get-метод получения признака доступности.
		// Результат: признак доступности.
		public function get IsEnabled( ): Boolean
		{
			// Признак доступности.
			return this._IsEnabled;
		} // IsEnabled

		// Set-метод установки признака доступности.
		// Параметры:
		// parIsEnabled - признак доступности.
		public function set IsEnabled( parIsEnabled: Boolean ): void
		{
			// Если признак допустимости не изменился, ничто не меняется.
			if ( this._IsEnabled == parIsEnabled )
				return;
			
			// Признак доступности.
			this._IsEnabled = parIsEnabled;
			
			// Если признак доступности истинен.
			if ( parIsEnabled )
			{
				// Бегунок рокрутки доступен.
				this._ScrollThumb.enabled = true;
				// Регистрирация объекта-прослушивателя события нажатия кнопки мыши
				// на бегунке прокрутки.
				this._ScrollThumb.addEventListener( MouseEvent.MOUSE_DOWN,
					this.ScrollThumbMouseDownListener );				
			} // if
			
			// Если признак доступности ложен.	
			else
			{
				// Бегунок рокрутки не доступен.
				this._ScrollThumb.enabled = false;
				// Передача события отпускания кнопки мыши на бегунке прокрутки
				// в поток событий, целью - объбектом-получателем - которого
				// является бегунок прокрутки.
				this._ScrollThumb.dispatchEvent
					( new MouseEvent( MouseEvent.MOUSE_UP ) );
				// Отмена регистрирации объекта-прослушивателя события
				// нажатия кнопки мыши на бегунке прокрутки.
				this._ScrollThumb.removeEventListener
					( MouseEvent.MOUSE_DOWN, ScrollThumbMouseDownListener );					
			} // else
		} // IsEnabled		
		
		// Get-метод получения ширины бегунка прокрутки.
		// Результат: ширина бегунка прокрутки.
		public function get ScrollThumbWidth( ): Number
		{
			// Ширина бегунка прокрутки - его действительная высота,
			// так как бегунок прокрутки - светящаяся кнопка,
			// повёрнутая на 90 градусов против часовой стрелки.
			return this._ScrollThumb.height;
		} // ScrollThumbWidth

		// Set-метод установки ширины бегунка прокрутки.
		// Параметры:
		// parScrollThumbWidth - ширина бегунка прокрутки.
		public function set ScrollThumbWidth
			( parScrollThumbWidth: Number ): void
		{
			// Действительная высота бегунка прокрутки - его заданная ширина,
			// так как бегунок прокрутки - светящаяся кнопка,
			// повёрнутая на 90 градусов против часовой стрелки.			
			this._ScrollThumb.height = parScrollThumbWidth;
		} // ScrollThumbWidth		
		
		// Get-метод получения высоты бегунка прокрутки.
		// Результат: высота бегунка прокрутки.
		public function get ScrollThumbHeight( ): Number
		{
			// Высота бегунка прокрутки - его действительная ширина,
			// так как бегунок прокрутки - светящаяся кнопка,
			// повёрнутая на 90 градусов против часовой стрелки.			
			return this._ScrollThumb.width;
		} // ScrollThumbHeight

		// Set-метод установки высоты бегунка прокрутки.
		// Параметры:
		// parScrollThumbHeight - высота бегунка прокрутки.
		public function set ScrollThumbHeight
			( parScrollThumbHeight: Number ): void
		{
			// Действительная ширина бегунка прокрутки - его заданная высота,
			// так как бегунок прокрутки - светящаяся кнопка,
			// повёрнутая на 90 градусов против часовой стрелки.			
			this._ScrollThumb.width = parScrollThumbHeight;
		} // ScrollThumbHeight		
		
		// Get-метод получения абсциссы бегунка прокрутки.
		// Результат: абсцисса бегунка прокрутки.
		public function get ScrollThumbX( ): Number
		{
			// Абсцисса бегунка прокрутки - его повернуная ордината.
			return this._ScrollThumb.x;
		} // ScrollThumbX

		// Set-метод установки абсциссы бегунка прокрутки.
		// Параметры:
		// parScrollThumbX - абсцисса бегунка прокрутки.
		public function set ScrollThumbX
			( parScrollThumbX: Number ): void
		{
			// Абсцисса бегунка прокрутки - его повернуная ордината.
			this._ScrollThumb.x = parScrollThumbX;
		} // ScrollThumbX	
		
		// Get-метод получения ординаты бегунка прокрутки.
		// Результат: ордината бегунка прокрутки.
		public function get ScrollThumbY( ): Number
		{
			// Ордината бегунка прокрутки - его повёрнутая абсцисса,
			// которая оказалась внизу, так что её значение теперь показывает
			// ординату нижней стороны бегунка прокрутки,
			// ордината же его верхней стороны - это разность
			// ординаты его нижней стороны и его высоты.
			return this._ScrollThumb.y - this.ScrollThumbHeight;
		} // ScrollThumbY

		// Set-метод установки ординаты бегунка прокрутки.
		// Параметры:
		// parScrollThumbY - ордината бегунка прокрутки.
		public function set ScrollThumbY
			( parScrollThumbY: Number ): void
		{
			// Ордината бегунка прокрутки - его повёрнутая абсцисса,
			// которая оказалась внизу, так что её значение теперь показывает
			// ординату нижней стороны бегунка прокрутки -
			// сумму ординаты его нижней стороны и его высоты.
			this._ScrollThumb.y = parScrollThumbY + this.ScrollThumbHeight;
		} // ScrollThumbY
	} // GlowScrollBar
} // nijanus.display	