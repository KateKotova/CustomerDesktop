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

	// Класс спрайта с эффектом - спрайта,
	// появляющегося с увеличением из ценрта
	// и исчезающего с уменьшением в центр.
	public class AppearingWithIncreaseSprite extends Sprite
	{
		// Список импортированных классов из других пакетов.
		
		import flash.events.Event;
		import flash.geom.Point;
		import flash.geom.Rectangle;
		//-----------------------------------------------------------------------
		// Статические константы.
		
		// Название типа события завершения эффекта появления.
		public static const SHOWING_EFFECT_EXECUTING_FINISHED: String =
			"ShowingEffectExecutingFinished";
		// Название типа события завершения эффекта исчезновения.
		public static const HIDING_EFFECT_EXECUTING_FINISHED:  String =
			"HidingEffectExecutingFinished";
			
		// Предел приращения времени в миллисекундах.
		public static const TIME_INTERVAL_LIMIT = 500;
		//-----------------------------------------------------------------------
		// Переменные экземпляра класса.
		
		// Признак выполнения эффекта появления в текущий момент.
		private var _ShowingEffectIsExecuting: Boolean = false;
		// Признак выполнения эффекта исчезновения в текущий момент.
		private var _HidingEffectIsExecuting:  Boolean = false;
		
		// Прямоугольник максимальных границ.
		private var _MaximumBoundsRectangle: Rectangle = new Rectangle( );
		
		// Время в миллисекундах длительности эффекта изменения видимости -
		// время, в течение которого осуществляется эффект появления
		// или исчезновения спрайта с эффектом.
		private var _EffectTime:                      Number = undefined;			
		// Коэффициент отношения реальной скорости эффекта появления
		// к реальной скорости эффекта исчезновения.
		private var _ShowingEffectVelocityToHidingEffectVelocityRatio:
			Number = undefined;			
		// Текущий начальный момент времени равномерного выполнения эффекта
		// в миллисекундах.
		private var _EffectExecutionCurrentStartTime: Number = undefined;
		
		// Скорость изменения абсциссы эффекта изменения видимости
		// в пикселах за миллисекунду.
		private var _EffectXChangingVelocity:      Number = undefined;
		// Скорость изменения ординаты эффекта изменения видимости
		// в пикселах за миллисекунду.
		private var _EffectYChangingVelocity:      Number = undefined;
		// Скорость изменения ширины   эффекта изменения видимости
		// в пикселах за миллисекунду.
		private var _EffectWidthChangingVelocity:  Number = undefined;
		// Скорость изменения высоты   эффекта изменения видимости
		// в пикселах за миллисекунду.
		private var _EffectHeightChangingVelocity: Number = undefined;	
		
		// Параметры изменения альфа-прозрачности объектов-потомков,
		// содержащихся на спрайте с эффектом.
		private var _ChildrenAlphaChangingParameters: Array = new Array( );
		//-----------------------------------------------------------------------
		// Методы экземпляра класса.
		
		// Установка параметров эффекта изменения видимости.
		public function GetEffectParameters( ): void
		{
			// Скорость изменения ширины эффекта изменения видимости:
			// частное разности максимальной и минимальной ширины
			// и времени в миллисекундах длительности эффекта изменения видимости.
			this._EffectWidthChangingVelocity  =
				( this._MaximumBoundsRectangle.width  - 1 ) / this._EffectTime;
			// Скорость изменения высоты эффекта изменения видимости:
			// частное разности максимальной и минимальной высоты
			// и времени в миллисекундах длительности эффекта изменения видимости.
			this._EffectHeightChangingVelocity =
				( this._MaximumBoundsRectangle.height - 1 ) / this._EffectTime;
				
			// Скорость изменения абсциссы эффекта изменения видимости -
			// половина скорости изменения ширины эффекта изменения видимости.
			this._EffectXChangingVelocity = this._EffectWidthChangingVelocity  / 2;
			// Скорость изменения ординаты эффекта изменения видимости -
			// половина скорости изменения высоты эффекта изменения видимости.
			this._EffectYChangingVelocity = this._EffectHeightChangingVelocity / 2;
				
			// Очищение массива параметров изменения альфа-прозрачности
			// объектов-потомков.
			this._ChildrenAlphaChangingParameters.length = 0;
			// Последовательный просмотр всех потомков спрайта с эффектом.
			for ( var childIndex: int = 0; childIndex < this.numChildren;
				childIndex++ )
			{
				// Параметры изменения альфа-прозрачности текущего потомка.
				var childAlphaChangingParameters = new AlphaChangingParameters( );
				// Максимальная альфа-прозрачность текущего потомка -
				// альфа-прозрачность потомка на момент вызова этого метода.
				childAlphaChangingParameters.MaximumAlpha          =
					this.getChildAt( childIndex ).alpha;
				// Скорость изменения альфа-прозрачности текущего потомка
				// в единицах альфа-прозрачности за миллисекунду:
				// частное разности максимальной и минимальной (нулевой)
				// альфа-прозрачности текущего потомка и времени в миллисекундах
				// длительности эффекта изменения видимости.				
				childAlphaChangingParameters.AlphaChangingVelocity =
					childAlphaChangingParameters.MaximumAlpha / this._EffectTime;
				
				// Добавление параметров изменения альфа-прозрачности
				// текущего потомка в массив.
				this._ChildrenAlphaChangingParameters[ childIndex ] =
					childAlphaChangingParameters;
			} // for
		} // GetEffectParameters
		
		// Установка максимальных значений эффекта изменения видимости.
		public function SetEffectMaximumValues( ): void
		{
			// Спрайт с эффектом приобретает границы, соответствующие
			// прямоугольнику максимальных границ.

			// Абсцисса спрайта с эффектом -
			// абсцисса прямоугольника максимальных границ.
			this.x      = this._MaximumBoundsRectangle.x;
			// Ордината спрайта с эффектом -
			// ордината прямоугольника максимальных границ.
			this.y      = this._MaximumBoundsRectangle.y;
			// Ширина спрайта с эффектом -
			// ширина прямоугольника максимальных границ.
			this.width  = this._MaximumBoundsRectangle.width;
			// Высота спрайта с эффектом -
			// высота прямоугольника максимальных границ.
			this.height = this._MaximumBoundsRectangle.height;
			
			// Для всех потомков спрайта с эффектом устанавливаются
			// максимальные альфа-прозрачности.

			// Последовательный просмотр всех потомков спрайта с эффектом.
			for ( var childIndex: int = 0; childIndex < this.numChildren;
					childIndex++ )
				// У текущего потомка устанавливается максимальная
				// альфа-прозрачность, соответствующая ему.
				this.getChildAt( childIndex ).alpha =
					this._ChildrenAlphaChangingParameters[ childIndex ].MaximumAlpha;
		} // SetEffectMaximumValues
		
		// Установка минимальных значений эффекта изменения видимости.
		public function SetEffectMinimumValues( ): void		
		{
			// Для всех потомков спрайта с эффектом устанавливается
			// минимальная альфа-прозрачность.
			
			// Последовательный просмотр всех потомков спрайта с эффектом.
			for ( var childIndex: int = 0; childIndex < this.numChildren;
					childIndex++ )
				// Установка минимальной альфа-прозрачности текущего потомка.
				this.getChildAt( childIndex ).alpha = 0;					
			
			// Спрайт с эффектом размещается по центру прямоугольника
			// максимальных границ и имеет минимальные размеры.
			
			// Координаты центра прямоугольника максимальных границ.
			var centre: Point = this.MaximumBoundsRectangleCentre;
			// Абсцисса спрайта с эффектом - абсцисса центра
			// прямоугольника максимальных границ.
			this.x      = centre.x;
			// Ордината спрайта с эффектом - ордината центра
			// прямоугольника максимальных границ.
			this.y      = centre.y;
			// Ширина спрайта с эффектом - минимальная, единичная.
			this.width  = 1;
			// Высота спрайта с эффектом - минимальная, единичная.
			this.height = 1;			
		} // SetEffectMinimumValues
		
		// Метод показа.
		public function Show( ): void
		{
			// Если происходит эффект исчезновения.
			if ( this._HidingEffectIsExecuting )
			{
				// Эффект исчезновения прекращается.
				this._HidingEffectIsExecuting = false;
				// Отмена регистрирации объекта-прослушивателя события
				// перехода точки воспроизведения в новый кадр
				// при выполнении эффекта исчезновения.
				this.removeEventListener( Event.ENTER_FRAME,
					this.HidingEffectEnterFrameListener );
			} // if
			
			// Если эффект появления ещё не происходит и он нужен,
			// то он начинается.
			/*if
			(
				( ! this._ShowingEffectIsExecuting ) &&
				(
					( this.width  < this._MaximumBoundsRectangle.width  ) ||
					( this.height < this._MaximumBoundsRectangle.height )
				)
			)*/			
			if ( ! this._ShowingEffectIsExecuting )
			{
				// Эффект появления начинается.
				this._ShowingEffectIsExecuting        = true;
				// Установка минимальных значений эффекта изменения видимости.
				this.SetEffectMinimumValues( );			
				// Текущий начальный момент времени равномерного выполнения эффекта
				// в миллисекундах - настоящий момент времени.
				this._EffectExecutionCurrentStartTime = ( new Date( ) ).time;				
				// Регистрирация объекта-прослушивателя события
				// перехода точки воспроизведения в новый кадр
				// при выполнении эффекта появления.
				this.addEventListener( Event.ENTER_FRAME,
					this.ShowingEffectEnterFrameListener );
			} // if
		} // Show
		
		// Метод сокрытия.
		public function Hide( ): void
		{
			// Если происходит эффект появления.
			if ( this._ShowingEffectIsExecuting )
			{
				// Эффект появления прекращается.
				this._ShowingEffectIsExecuting = false;
				// Отмена регистрирации объекта-прослушивателя события
				// перехода точки воспроизведения в новый кадр
				// при выполнении эффекта появления.
				this.removeEventListener( Event.ENTER_FRAME,
					this.ShowingEffectEnterFrameListener );
			} // if				
			
			// Если эффект исчезновения ещё не происходит и он нужен,
			// то он начинается.
			/*if
			(
				( ! this._HidingEffectIsExecuting ) &&
				(
					( this.width  > 1 ) ||
					( this.height > 1 )
				)
			)*/	
			if ( ! this._HidingEffectIsExecuting )
			{
				// Эффект исчезновения начинается.
				this._HidingEffectIsExecuting         = true;				
				// Установка максимальных значений эффекта изменения видимости.
				this.SetEffectMaximumValues( );
				// Текущий начальный момент времени равномерного выполнения эффекта
				// в миллисекундах - настоящий момент времени.
				this._EffectExecutionCurrentStartTime = ( new Date( ) ).time;				
				// Регистрирация объекта-прослушивателя события
				// перехода точки воспроизведения в новый кадр
				// при выполнении эффекта исчезновения.
				this.addEventListener( Event.ENTER_FRAME,
					this.HidingEffectEnterFrameListener );
			} // if
		} // Hide
		//-----------------------------------------------------------------------
		// Методы-прослушиватели событий.
		
		// Метод-прослушиватель события перехода точки воспроизведения
		// в новый кадр при выполнении эффекта появления.
		// Параметры:
		// parEvent - событие.
		private function ShowingEffectEnterFrameListener
			( parEvent: Event ): void
		{		
			// Текущий момент времени в миллисекундах.
			var currentTime:   Number = ( new Date( ) ).time;			
			// Приращение вермени в миллисекундах:
			// разность текущего момента времени в миллисекундах и текущего
			// начального момента времени равномерного выполнения эффекта
			// в миллисекундах.
			var timeIncrement: Number =  currentTime -
				this._EffectExecutionCurrentStartTime;
			// Нормирование приращения времени - запись остатка от деления
			// на предел приращения времени.
			// При этом могут произойти потери в скорости и увеличиться общее время
			// эффекта появления, но зато гарантируется предотвращение ситуации,
			// когда приращение времени превышает суммарное время.
			timeIncrement %= AppearingWithIncreaseSprite.TIME_INTERVAL_LIMIT;
			
			// Инкремент координат и размеров эффекта появления.
			
			// Новая абсцисса:
			// разность прежней абсциссы и произведения скорости изменения абсциссы
			// эффекта изменения видимости и приращения вермени.
			var newX:      Number = this.x      -
				this._EffectXChangingVelocity      * timeIncrement;
			// Новая ордината:
			// разность прежней ординаты и произведения скорости изменения ординаты
			// эффекта изменения видимости и приращения вермени.				
			var newY:      Number = this.y      -
				this._EffectYChangingVelocity      * timeIncrement;
			// Новая ширина:
			// сумма прежней ширины и произведения скорости изменения ширины
			// эффекта изменения видимости и приращения вермени.				
			var newWidth:  Number = this.width  +
				this._EffectWidthChangingVelocity  * timeIncrement;
			// Новая высота:
			// сумма прежней высоты и произведения скорости изменения высоты
			// эффекта изменения видимости и приращения вермени.				
			var newHeight: Number = this.height +
				this._EffectHeightChangingVelocity * timeIncrement;
				
			// Если хотя бы одно из значений координат и размеров эффекта появления
			// достигло предела, то все значения эффекта появления
			// становятся предельными и эффект завершается.
			if
			(
				( newX      <= this._MaximumBoundsRectangle.x      ) ||
				( newY      <= this._MaximumBoundsRectangle.y      ) ||
				( newWidth  >= this._MaximumBoundsRectangle.width  ) ||
				( newHeight >= this._MaximumBoundsRectangle.height )
			)
			{
				// Установка максимальных значений эффекта изменения видимости.
				this.SetEffectMaximumValues( );
				// Отмена регистрирации объекта-прослушивателя события
				// перехода точки воспроизведения в новый кадр
				// при выполнении эффекта появления.
				this.removeEventListener( Event.ENTER_FRAME,
					this.ShowingEffectEnterFrameListener );
				
				// Эффект появления заканчивается.
				this._ShowingEffectIsExecuting = false;
				// Передача события завершения эффекта появления, целью -
				// объбектом-получателем - которого является представляемый
				// объект класса спрайта с эффектом.
				this.dispatchEvent( new Event( AppearingWithIncreaseSprite.
					SHOWING_EFFECT_EXECUTING_FINISHED ) );
			} // if
			
			else
			{
				// Установка новых координат и размеров эффекта появления.
				
				// Новая абсцисса.
				this.x      = newX;
				// Новая ордината.
				this.y      = newY;
				// Новая ширина.
				this.width  = newWidth;
				// Новая высота.
				this.height = newHeight;
				
				// Для всех потомков спрайта с эффектом
				// инкрементируется альфа-прозрачность.
				
				// Последовательный просмотр всех потомков спрайта с эффектом.
				for ( var childIndex: int = 0; childIndex < this.numChildren;
						childIndex++ )
					// Альфа-прозрачность компонента увеличивается
					// на произведение соответствующей ему скорости изменения
					// альфа-прозрачности и приращения вермени.
					this.getChildAt( childIndex ).alpha +=
						this._ChildrenAlphaChangingParameters[ childIndex ].
						AlphaChangingVelocity * timeIncrement;
						
				// Текущий начальный момент времени равномерного выполнения эффекта
				// переносится в настоящий момент времени.
				this._EffectExecutionCurrentStartTime = currentTime;
			} // else
		} // ShowingEffectEnterFrameListener
		
		// Метод-прослушиватель события перехода точки воспроизведения
		// в новый кадр при выполнении эффекта исчезновения.
		// Параметры:
		// parEvent - событие.
		private function HidingEffectEnterFrameListener
			( parEvent: Event ): void
		{			
			// Текущий момент времени в миллисекундах.
			var currentTime:   Number = ( new Date( ) ).time;			
			// Приращение вермени в миллисекундах:
			// разность текущего момента времени в миллисекундах и текущего
			// начального момента времени равномерного выполнения эффекта
			// в миллисекундах.
			var timeIncrement: Number =  currentTime -
				this._EffectExecutionCurrentStartTime;
			// Нормирование приращения времени - запись остатка от деления
			// на предел приращения времени.
			// При этом могут произойти потери в скорости и увеличиться общее время
			// эффекта появления, но зато гарантируется предотвращение ситуации,
			// когда приращение времени превышает суммарное время.
			timeIncrement %= AppearingWithIncreaseSprite.TIME_INTERVAL_LIMIT;				
				
			// Инкремент координат и размеров эффекта появления.
			
			// Новая абсцисса:
			// сумма прежней абсциссы и произведения скорости изменения абсциссы
			// эффекта изменения видимости и приращения вермени.
			var newX:      Number = this.x      +
				this._EffectXChangingVelocity      * timeIncrement /
				this._ShowingEffectVelocityToHidingEffectVelocityRatio;
			// Новая ордината:
			// сумма прежней ординаты и произведения скорости изменения ординаты
			// эффекта изменения видимости и приращения вермени.				
			var newY:      Number = this.y      +
				this._EffectYChangingVelocity      * timeIncrement /
				this._ShowingEffectVelocityToHidingEffectVelocityRatio;
			// Новая ширина:
			// разность прежней ширины и произведения скорости изменения ширины
			// эффекта изменения видимости и приращения вермени.				
			var newWidth:  Number = this.width  -
				this._EffectWidthChangingVelocity  * timeIncrement /
				this._ShowingEffectVelocityToHidingEffectVelocityRatio;
			// Новая высота:
			// разность прежней высоты и произведения скорости изменения высоты
			// эффекта изменения видимости и приращения вермени.				
			var newHeight: Number = this.height -
				this._EffectHeightChangingVelocity * timeIncrement /
				this._ShowingEffectVelocityToHidingEffectVelocityRatio;
				
			// Координаты центра прямоугольника максимальных границ.
			var centre: Point = this.MaximumBoundsRectangleCentre;
			
			// Если хотя бы одно из значений координат и размеров
			// эффекта исчезновения достигло предела, то все значения
			// эффекта исчезновения становятся предельными и эффект завершается.
			if
			(
				( newX      >= centre.x ) ||
				( newY      >= centre.y ) ||
				( newWidth  <= 1        ) ||
				( newHeight <= 1        )
			)			
			{
				// Установка минимальных значений эффекта изменения видимости.
				this.SetEffectMinimumValues( );
				// Отмена регистрирации объекта-прослушивателя события
				// перехода точки воспроизведения в новый кадр
				// при выполнении эффекта исчезновения.
				this.removeEventListener( Event.ENTER_FRAME,
					this.HidingEffectEnterFrameListener );
				
				// Эффект исчезновения заканчивается.
				this._HidingEffectIsExecuting = false;				
				// Передача события завершения эффекта исчезновения, целью -
				// объбектом-получателем - которого является представляемый
				// объект класса спрайта с эффектом.
				this.dispatchEvent( new Event( AppearingWithIncreaseSprite.
					HIDING_EFFECT_EXECUTING_FINISHED ) );				
			} // if				
				
			else
			{
				// Установка новых координат и размеров эффекта появления.

				// Новая абсцисса.
				this.x      = newX;
				// Новая ордината.
				this.y      = newY;
				// Новая ширина.
				this.width  = newWidth;
				// Новая высота.
				this.height = newHeight;
				
				// Для всех потомков спрайта с эффектом
				// декрементируется альфа-прозрачность.
				
				// Последовательный просмотр всех потомков спрайта с эффектом.
				for ( var childIndex: int = 0; childIndex < this.numChildren;
						childIndex++ )
					// Альфа-прозрачность компонента уменьшается
					// на произведение соответствующей ему скорости изменения
					// альфа-прозрачности и приращения вермени.
					this.getChildAt( childIndex ).alpha -=
						this._ChildrenAlphaChangingParameters[ childIndex ].
						AlphaChangingVelocity * timeIncrement /
						this._ShowingEffectVelocityToHidingEffectVelocityRatio;
						
				// Текущий начальный момент времени равномерного выполнения эффекта
				// переносится в настоящий момент времени.
				this._EffectExecutionCurrentStartTime = currentTime;
			} // else				
		} // HidingEffectEnterFrameListener		
		//-----------------------------------------------------------------------	
		// Методы-конструкторы.
		
		// Метод-конструктор экземпляра спрайта, появляющегося с увеличением
		// из ценрта и исчезающего с уменьшением в центр.
		// Параметры:
		// parAreaRectangle - прямоугольная область спрайта с эффектом,
		// parEffectTime    - время в миллисекундах длительности эффекта
		//   изменения видимости,
		// parShowingEffectVelocityToHidingEffectVelocityRatio - коэффициент
		//   отношения реальной скорости эффекта появления к реальной скорости
		//   эффекта исчезновения.
		public function AppearingWithIncreaseSprite
		(
			parAreaRectangle:                                    Rectangle,
			parEffectTime,
			parShowingEffectVelocityToHidingEffectVelocityRatio: Number
		): void
		{
			// Вызов метода-конструктора суперкласса Sprite.
			super( );	
			
			// Абсцисса спрайта с эффектом.
			this.x           = parAreaRectangle.x;
			// Ордината спрайта с эффектом.
			this.y           = parAreaRectangle.y;
			// Определение прямоугольной области прокрутки спрайта с эффектом
			// заданной высоты и ширины.
			this.scrollRect  = new Rectangle( 0, 0, parAreaRectangle.width,
				parAreaRectangle.height );
			
			// Прямоугольник максимальных границ - предельная прямоугольная область
			// спрайта с эффектом.
			this._MaximumBoundsRectangle = parAreaRectangle;
			// Время в миллисекундах длительности эффекта изменения видимости.
			this._EffectTime             = parEffectTime;
			// Коэффициент отношения реальной скорости эффекта появления
			// к реальной скорости эффекта исчезновения.
			this._ShowingEffectVelocityToHidingEffectVelocityRatio =
				parShowingEffectVelocityToHidingEffectVelocityRatio;
			
			// Во весь спрайт с эффектом
			// рисутеся полностью прозрачный прямоугольник.
			
			// Начало рисования на спрайте с эффектом в заданном режиме:
			// сплошная заливка чёрным цветом с абсолютной прозрачностью.
			this.graphics.beginFill( 0x0, 0 );
			// Рисуется прозрачный прямоугольник во весь спрайт с эффектом.
			this.graphics.drawRect( 0, 0, parAreaRectangle.width,
				parAreaRectangle.height );
			// Окончание рисования на спрайте с эффектом в заданном режиме.
			this.graphics.endFill( );
		} // AppearingWithIncreaseSprite
		//-----------------------------------------------------------------------
		// Get- и set-методы.
		
		// Get-метод получения признака выполнения эффекта появления
		// в текущий момент.
		// Результат: признак выполнения эффекта появления в текущий момент.
		public function get ShowingEffectIsExecuting( ): Boolean
		{
			// Признак выполнения эффекта появления в текущий момент.
			return this._ShowingEffectIsExecuting;
		} // ShowingEffectIsExecuting
		
		// Get-метод получения признака выполнения эффекта исчезновения
		// в текущий момент.
		// Результат: признак выполнения эффекта исчезновения в текущий момент.
		public function get HidingEffectIsExecuting( ): Boolean
		{
			// Признак выполнения эффекта исчезновения в текущий момент.
			return this._HidingEffectIsExecuting;
		} // HidingEffectIsExecuting		
		
		// Get-метод получения времени в миллисекундах
		// длительности эффекта изменения видимости.
		// Результат: время в миллисекундах длительности эффекта
		// изменения видимости.
		public function get EffectTime( ): Number
		{
			// Время в миллисекундах длительности эффекта изменения видимости.
			return this._EffectTime;
		} // EffectTime
		
		// Get-метод получения коэффициента отношения реальной скорости
		// эффекта появления к реальной скорости эффекта исчезновения.
		// Результат: коэффициент тношения реальной скорости эффекта появления
		// к реальной скорости эффекта исчезновения.
		public function get
			ShowingEffectVelocityToHidingEffectVelocityRatio( ): Number
		{
			// Коэффициент отношения реальной скорости эффекта появления
			// к реальной скорости эффекта исчезновения.
			return this._ShowingEffectVelocityToHidingEffectVelocityRatio;
		} // ShowingEffectVelocityToHidingEffectVelocityRatio		
		
		// Get-метод получения координат центра
		// прямоугольника максимальных границ.
		// Результат: координаты центра прямоугольника максимальных границ.
		public function get MaximumBoundsRectangleCentre( ): Point
		{
			// Координаты центра прямоугольника максимальных границ.
			return new Point
			(
				this._MaximumBoundsRectangle.x + 
					this._MaximumBoundsRectangle.width  / 2,
				this._MaximumBoundsRectangle.y +
					this._MaximumBoundsRectangle.height / 2
			); // new Point
		} // MaximumBoundsRectangleCentre
	} // AppearingWithIncreaseSprite
} // nijanus.display