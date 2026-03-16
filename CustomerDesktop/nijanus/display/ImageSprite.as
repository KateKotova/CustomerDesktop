// CustomerDesktop
// Author Kate Kotova
// NIJANUS Copyright © 2004-2010
// nijanus@ymail.com
// http://nijanus.narod2.ru
//---------------------------------------------------------------------------
// Пакет классов, связанных с отображением.
package nijanus.display
{
	// Класс спрайта изображения.
	public class ImageSprite extends GradientBlackSprite
	{
		// Список импортированных классов из других пакетов.

		import flash.display.Bitmap;
		import flash.display.BitmapData;
		import flash.display.Loader;
		import flash.display.LoaderInfo;
		import flash.display.PixelSnapping;	
		import flash.display.Sprite;
		import flash.events.Event;
		import flash.events.IOErrorEvent;
		import flash.geom.Rectangle;		
		import flash.net.URLRequest;
		//-----------------------------------------------------------------------
		// Статические константы.

		// Максимальная ширина изображения.
		public static const IMAGE_MAXIMUM_WIDTH:  Number = 1024;
		// Максимальная высота изображения.
		public static const IMAGE_MAXIMUM_HEIGHT: Number = 1024;
		
		// Сообщение об ошибке загрузки изображения.
		public static const IMAGE_LOADING_IO_ERROR_MESSAGE:            String =
			"Ошибка загрузки изображения из файла по заданному пути: ";
		// Сообщение о том, что ширина изображения превышает максимальную.
		public static const GREATER_THAN_MAXIMUM_IMAGE_WIDTH_MESSAGE:  String =
			"Ширина изображения превышает максимальную: " +
			ImageSprite.IMAGE_MAXIMUM_WIDTH.toString( ) + " < ";
		// Сообщение о том, что высота изображения превышает максимальную.
		public static const GREATER_THAN_MAXIMUM_IMAGE_HEIGHT_MESSAGE: String =
			"Высота изображения превышает максимальную: " +
			ImageSprite.IMAGE_MAXIMUM_HEIGHT.toString( ) + " < ";
		//-----------------------------------------------------------------------
		// Переменные экземпляра класса.
		
		// Коэффициент отношения ширины спрайта изображения к высоте.
		private var _WidthToHeightRatio: Number = 1;		
		// Смещение изображения по ширине - по оси абсцисс.
		private var _ImageXOffset:       Number = 0;	
		// Смещение изображения по высоте - по оси ординат.
		private var _ImageYOffset:       Number = 0;		
		// Информация.
		private var _Information:        Object = null;
		//-----------------------------------------------------------------------
		// Методы экземпляра класса.
		
		// Метод очистики спрайта от изображения.
		public function ClearImage( ): void
		{
			// Если на спрайте есть изображение - второй потомок,
			// то есть, если количество потомков спрайта больше либо равно двум.
			if ( this.numChildren >= 2 )
				// Второй потомок спрайта, хранящийся по первому индексу
				// (нумерация потомков от нуля) - изображение - удаляется.
				this.removeChildAt( 1 );
		} // ClearImage
		
		// Метод очистики спрайта от пиктограммы.
		public function ClearIcon( ): void
		{
			// Если на спрайте есть пиктограмма - третий потомок,
			// то есть, если количество потомков спрайта больше либо равно трём.
			if ( this.numChildren >= 3 )
				// Третий потомок спрайта, хранящийся по второму индексу
				// (нумерация потомков от нуля) - пиктограмма - удаляется.
				this.removeChildAt( 2 );
		} // ClearIcon
		
		// Метод очистики спрайта от изображения и пиктограммы.
		public function Clear( ): void
		{
			// Очистика спрайта от пиктограммы.
			this.ClearIcon( );	
			// Очистика спрайта от изображения.
			this.ClearImage( );
		} // Clear
		
		// Метод загрузки изображения из файла по заданному пути на спрайт.
		// Параметры:
		// parImagePathString - текстовая строка пути к изображению.
		public function LoadImage( parImagePathString: String ): void
		{
			// Создание загрузчика изображения.
			var imageLoader: Loader = new Loader( );
			// Регистрирация объекта-прослушивателя события
			// возникновения ошибки при загрузки изображения.
			imageLoader.contentLoaderInfo.addEventListener
				( IOErrorEvent.IO_ERROR, this.ImageLoadingIOErrorListener );

			// Загрузка изображения по заданному пути.
			imageLoader.load( new URLRequest( parImagePathString ) );
			// Регистрирация объекта-прослушивателя события
			// успешной загрузки изображения.
			imageLoader.contentLoaderInfo.addEventListener( Event.COMPLETE,
				this.ImageLoadingCompleteListener );
		} // LoadImage
		
		// Метод добавления изображения на спрайт.
		// Параметры:
		// parImage - изображение.
		public function AddImage( parImage: Bitmap ): void
		{
			// Если ширина изображения превышает максимальную, выводится сообщение.
			if ( parImage.width > ImageSprite.IMAGE_MAXIMUM_WIDTH )
				trace( ImageSprite.GREATER_THAN_MAXIMUM_IMAGE_WIDTH_MESSAGE +
					parImage.width.toString( ) );
			// Если высота изображения превышает максимальную, выводится сообщение.				
			if ( parImage.height > ImageSprite.IMAGE_MAXIMUM_HEIGHT )
				trace( ImageSprite.GREATER_THAN_MAXIMUM_IMAGE_HEIGHT_MESSAGE +
					parImage.height.toString( ) );
				
			// Определение прямоугольной области прокрутки спрайта изображения
			// заданной высоты и ширины изображений.
			this.scrollRect = new Rectangle( 0, 0, this.width / this.scaleX,
				this.height / this.scaleY );			
			
			// Очистика спрайта от изображения.
			this.ClearImage( );	
			// Помещение изображения на спрайт на второй уровень -
			// по первому индексу.
			this.addChildAt( parImage, 1 );

			// Поскольку спрайт масштабируется в пределах заданных границ,
			// если изображение покроет всю область спрайта, то оно исказится:
			// отношение высоты к ширине изменится.

			// Поэтому пропорции изображения надо сохранить, есть два решения:
			// 1) показать всё изображение, уменьшив, так, чтобы его площадь
			// не превышала площадь спрайта - при этом могут появиться полосы там,
			// где сторона спрайта больше стороны изображения;
			// 2) кадрировать изображение, уменьшив, так, чтобы одна из сторон
			// была равной соответствующей стороне спрайта, а вторая
			// может оказаться больше - тогда надо отцентровать изображение:
			// середина покажется, а края, вышедшие за границы, будут не видны.

			// Чтобы избежать полос по краям, луше выбрать второй кадрирование.

			// Горизонтальное масштабирование изображения - 100%.
			parImage.scaleX = 1;
			// Вертикальное масштабирование изображения - 100%.
			parImage.scaleY = 1;

			// Коэффициент отношения ширины спрайта
			// к ширине изображения.
			var thisWidthToImageWidthRatio:   Number = this.width  /
				parImage.width;
			// Коэффициент отношения высоты спрайта изображения
			// к высоте изображения.
			var thisHeightToImageHeightRatio: Number = this.height /
				parImage.height;
			// Коэффициент масштабирования изображения - больший из двух -
			// коэффициент отношения стороны спрайта изображения
			// к стороне изображения.
			var thisSideToImageSideRatio:     Number =
				( thisWidthToImageWidthRatio     >=
				  thisHeightToImageHeightRatio ) ?
				  thisWidthToImageWidthRatio     : 
					thisHeightToImageHeightRatio;

			// Изображение, которое масштабрируется находится на спрайте,
			// который также масштабируется, поэтому нельзя так просто 
			// задать коэффициент масштабирования изображения в качестве
			// самого масштабирования изображения.

			// Получается, изображение масштабируется дважды: само по себе
			// и как содержимое спрайта.

			// Размеры изображения масштабируются всесте со спрайтом, то есть
			// размеры изображения умножеются на соответствующие значения
			// масштабирования спрайта, следовательно, чтобы сохранить пропорции,
			// надо коффициент масштабирования изображения, наоборот, разделить
			// на соответствующие значения масштабирования спрайта.

			// Горизонтальное масштабирование изображения
			parImage.scaleX = thisSideToImageSideRatio / this.scaleX;
			// Вертикальное масштабирование изображения.
			parImage.scaleY = thisSideToImageSideRatio / this.scaleY;

			// Левый верхний угол изображения позиционируется в левый верхний угол
			// спрайта. Для того, чтобы отцентровать изображение,
			// следовало бы сместить каждую из сторон изображения на величину
			// равную половине разности длин сторон спрайта и изображения.

			// Однако, и изображение, и спрайт масштибируются и эта формула
			// даже с учётом коэффициентов масштабирования не работает.
			// Поэтому хорошее решение - просто прокрутить изображение в пределах
			// его собственной области прокрутки.

			// Коэффициент отношения ширины спрайта изображения к высоте известен.
			// Если отношение ширины изображения к высоте больше коэффициента,
			// то происходит прокрутка изобаржения по шрине, иначе - по высоте,
			// таким образом, изображение на спрайте оказывается по отцентрованным.

			// Коэффициент отношения ширины изображения к высоте.
			var imageWidthToHeightRatio: Number = parImage.bitmapData.width /
				parImage.bitmapData.height;

			// Если коэффициент отношения ширины изображения к высоте не равен
			// коэффициенту отношения ширины спрайта изображения к высоте,
			// то изображение не по центру.
			if ( imageWidthToHeightRatio != this._WidthToHeightRatio )
			{
				// Если коэффициент изображения больше коэффициента спрайта,
				// то изображение прокручивается по ширине.
				if ( imageWidthToHeightRatio > this._WidthToHeightRatio )
				{
					// Смещение изображения по ширине - по оси абсцисс.
					this._ImageXOffset = ( this._WidthToHeightRatio *
						parImage.bitmapData.height - parImage.bitmapData.width ) / 2;
					// Смещение изображения по высоте - по оси ординат.
					this._ImageYOffset = 0;
				} // if

				// Если коэффициент изображения меньше коэффициента спрайта,
				// то изображение прокручивается по высоте.
				else
				{
					// Смещение изображения по ширине - по оси абсцисс.
					this._ImageXOffset = 0;
					// Смещение изображения по высоте - по оси ординат.
					this._ImageYOffset = ( parImage.bitmapData.width /
						this._WidthToHeightRatio - parImage.bitmapData.height ) / 2;
				} // else
					
				// Прокрутка изображения по ширине на величину смещения.
				// Края за пределами области прокрутки остаются без изменений.
				parImage.bitmapData.scroll( this._ImageXOffset, this._ImageYOffset );
			} // if
			
			// Если коэффициент отношения ширины изображения к высоте равен
			// коэффициенту отношения ширины спрайта изображения к высоте,
			// то изображение уже по центру.
			else
			{
				// Смещение изображения по ширине - по оси абсцисс.
				this._ImageXOffset = 0;
				// Смещение изображения по высоте - по оси ординат.
				this._ImageYOffset = 0;				
			} // else
		} // AddImage
		
		// Метод добавления пиктограммы на спрайт.
		// Параметры:
		// parIcon - пиктограмма.
		public function AddIcon( parIcon: Sprite ): void
		{
			// Если пиктограмма не определена.
			if ( parIcon == null )
				// Ничего не добавляется.
				return;
				
			// Очистика спрайта от пиктограммы.
			this.ClearIcon( );	
			// Помещение пиктограммы на спрайт на третий уровень -
			// по второму индексу.
			this.addChildAt( parIcon, 2 );
			
			// Формулы абсциссы и ординаты пиктограммы
			// подогнаны и не совсем верны!!!
			
			// Абсцисса пиктограммы.
			parIcon.x = ( this.width  - parIcon.width  + this._ImageXOffset *
				this._WidthToHeightRatio ) / this.scaleX / 2;
			// Ордината пиктограммы.				
			parIcon.y = ( this.height - parIcon.height + this._ImageYOffset *
				this._WidthToHeightRatio ) / this.scaleY / 2;

			// Ширина пиктограммы делится
			// на горизонтальное масштабирование спрайта.		
			parIcon.width  /= this.scaleX;
			// Ордината пиктограммы делится
			// на вертикальное масштабирование спрайта.
			parIcon.height /= this.scaleY;
		} // AddIcon		
		//-----------------------------------------------------------------------
		// Методы-прослушиватели событий.

		// Метод-прослушиватель события успешной загрузки изображения.
		// Параметры:
		// parEvent - событие.
		private function ImageLoadingCompleteListener( parEvent: Event ): void
		{
			// Загрузчик изображения - загрузчик объбекта-получателя события.
			var imageLoader: Loader = LoaderInfo( parEvent.target ).loader;
			// Получение загруженного изображения из контента загрузчика.
			var image:       Bitmap = imageLoader.content as Bitmap;
			// Изображение не должно привязываться к ближайшему пикселу.
			image.pixelSnapping     = PixelSnapping.NEVER;
			// Установка сглаживания изображения при масштабировании.
			image.smoothing         = true;	
			// Добавление изображения на спрайт изображения.
			this.AddImage( image );
			
			// Передача события успешной загрузки изображения
			// на спрайт изображения в поток событий, целью -
			// объбектом-получателем - которого является данный спрайт изображения.
			this.dispatchEvent( new ImageSpriteEvent
				( ImageSpriteEvent.IMAGE_SPRITE_IMAGE_LOADING_COMPLETE ) );
		} // ImageLoadingCompleteListener

		// Метод-прослушиватель события
		// возникновения ошибки при загрузки изображения.
		// Параметры:
		// parIOErrorEvent - событие возникновения ошибки при выполнении
		//                   операция отправки или загрузки.
		private function ImageLoadingIOErrorListener
			( parIOErrorEvent: IOErrorEvent ): void
		{	
			// Очистика спрайта от изображения.
			this.ClearImage( );		
			// Вывод сообщения об ошибке загрузки изображения c указанием
			// URL-адреса загружаемого изображения в окно среды разработки.
			trace( ImageSprite.IMAGE_LOADING_IO_ERROR_MESSAGE +
				LoaderInfo( parIOErrorEvent.target ).url );
			
			// Передача события возникновения ошибки при загрузки изображения
			// на спрайт изображения в поток событий, целью -
			// объбектом-получателем - которого является данный спрайт изображения.
			this.dispatchEvent( new ImageSpriteEvent
				( ImageSpriteEvent.IMAGE_SPRITE_IMAGE_LOADING_IO_ERROR ) );			
		} // ImageLoadingIOErrorListener		
		//-----------------------------------------------------------------------
		// Методы-конструкторы.

		// Метод-конструктор экземпляра спрайта изображения.
		// Параметры:
		// parWidthToHeightRatio - коэффициент отношения ширины
		//                         спрайта изображения к высоте,
		// parInformation        - информация.
		public function ImageSprite
		(
		 	parWidthToHeightRatio: Number,
			parInformation:        Object
		): void
		{
			// Вызов метода-конструктора суперкласса GradientBlackSprite.
			super( );
			// Коэффициент отношения ширины спрайта изображения к высоте.
			this._WidthToHeightRatio = parWidthToHeightRatio;
			// Информация.
			this._Information        = parInformation;
		} // ImageSprite
		//-----------------------------------------------------------------------
		// Get- и set-методы.
		
		// Get-метод получения коэффициента отношения
		// ширины спрайта изображения к высоте.
		// Результат: коэффициент отношения ширины спрайта изображения к высоте.
		public function get WidthToHeightRatio( ): Object
		{
			// Коэффициент отношения ширины спрайта изображения к высоте.
			return this._WidthToHeightRatio;
		} // WidthToHeightRatio
		
		// Get-метод получения смещения изображения по ширине - по оси абсцисс.
		// Результат: смещение изображения по ширине - по оси абсцисс.
		public function get ImageXOffset( ): Number
		{
			// Смещение изображения по ширине - по оси абсцисс.
			return this._ImageXOffset;
		} // ImageXOffset
		
		// Get-метод получения смещения изображения по высоте - по оси ординат.
		// Результат: смещение изображения по высоте - по оси ординат.
		public function get ImageYOffset( ): Number
		{
			// Смещение изображения по высоте - по оси ординат.
			return this._ImageYOffset;
		} // ImageYOffset		
		
		// Get-метод получения информации.
		// Результат: информация.
		public function get Information( ): Object
		{
			// Информация.
			return this._Information;
		} // Information

		// Set-метод установки информации.
		// Параметры:
		// parInformation - информация.
		public function set Information( parInformation: Object ): void
		{
			// Информация.
			this._Information = parInformation;
		} // Information
	} // ImageSprite
} // nijanus.display