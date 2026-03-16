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

	// Класс строки изображений.
	public class ImagesLine extends Sprite
	{
		// Список импортированных классов из других пакетов.

		import flash.display.Bitmap;
		import flash.display.BitmapData;
		import flash.display.DisplayObjectContainer;
		import flash.display.Loader;
		import flash.display.PixelSnapping;
		import flash.display.StageAlign;
		import flash.display.StageScaleMode;
		import flash.events.Event;
		import flash.events.EventDispatcher;
		import flash.events.IOErrorEvent;
		import flash.events.MouseEvent;
		import flash.events.TimerEvent;
		import flash.geom.Rectangle;
		import flash.net.URLLoader;		
		import flash.net.URLRequest;
		//-----------------------------------------------------------------------
		// Статические константы.
		
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
			"класса ImagesLine";
			
		// Количество серий во фрагменте серий последовательностей
		// спрайтов изображений.
		public static const
			IMAGES_SPRITES_SEQUENCES_RANGES_FRAGMENT_RANGES_COUNT: uint = 3;		
		//-----------------------------------------------------------------------
		// Статические переменные.
		
		// Статический диспетчер событий.
		private static var _StaticEventDispatcher: EventDispatcher =
			new EventDispatcher( );
		
		// Максимальный модуль смещения от точки нажатия до точки отпускания
		// кнопки мыши по оси абсцисс в области клика мыши.
		public static var ClickXMaximumAbsoluteOffset: Number = 30;		
		// Минимальный интервал времени совершения клика мышью.
		public static var ClickTimeMinimumInterval:    Number = 250;
		// Максимальный интервал времени совершения клика мышью.
		public static var ClickTimeMaximumInterval:    Number = 2000;		
	
		// Модуль ускорения равнозамедленного движения
		// в пикселях в миллисекунду за миллисекунду.
		public static var DeceleratedMotionAbsoluteAcceleRation: Number = 0.0004;		
		//-----------------------------------------------------------------------
		// Переменные экземпляра класса.
		
		// Коэффициент отношения ширины спрайта изображения к высоте.
		private var _ImageSpriteWidthToHeightRatio: Number = 1;		
		// Массив спрайтов изображений.
		private var _ImagesSprites:                 Array  = new Array( );
		
		// Абсцисса левой серии последовательностей спрайтов изображений -
		// начало фрагмента.
		private var _ImagesSpritesSequencesLeftRangeX:   Number = 0;
		// Абсцисса центральной серии последовательностей спрайтов изображений.
		private var _ImagesSpritesSequencesMiddleRangeX: Number = 0;
		// Абсцисса правой серии последовательностей спрайтов изображений.
		private var _ImagesSpritesSequencesRightRangeX:  Number = 0;		
		
		// Признак неподвижности строки изображений.
		private var _IsStill: Boolean = true;		

		// Признак того, что кнопка мыши была нажата на строке изображений.
		private var _MouseDownWasOnThis:        Boolean = false;
		// Абсцисса спрайта изображения, на котором была нажата кнопка мыши.
		private var _MouseDownImageSpriteX:     Number  = undefined;
		// Абсцисса прямоугольной области прокрутки строки изображений
		// в момент нажатия кнопки мыши.
		private var _MouseDownScrollRectangleX: Number  = undefined;		
		// Абсцисса точки сцены, в которой была нажата кнопка мыши.
		private var _MouseDownStageX:           Number  = undefined;
		// Момент времени, в которой была нажата кнопка мыши -
		// число миллисекунд с полуночи 01.01.1970.
		private var _MouseDownTime:             Number  = undefined;		

		// Максимальный модуль смещения по оси абсцисс
		// в процессе управления движением мышью
		// (когда указатель мыши ещё не отпустил строку изображений).
		private var _MouseMoveXMaximumAbsoluteOffset:   Number = 0;
		
		// Текущая скорость равнозамедленного движения в пикселях в миллисекунду.
		private var _DeceleratedMotionCurrentVelocity:  Number = undefined;
		// Ускорение равнозамедленного движения
		// в пикселях в миллисекунду за миллисекунду.
		private var _DeceleratedMotionAcceleration:     Number = undefined;	
		// Текущий начальный момент времени равнозамедленного движения
		// в миллисекундах.
		private var _DeceleratedMotionCurrentStartTime: Number = undefined;
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
				ImagesLine.StaticParametersFileURLLoadingCompleteListener );				
			// Регистрирация объекта-прослушивателя события возникновения ошибки
			// при загрузке данных с URL-адреса файла статических параметров.
			staticParametersFileURLLoader.addEventListener( IOErrorEvent.IO_ERROR,
				ImagesLine.StaticParametersFileURLLoadingIOErrorListener );	
		} // LoadStaticParameters		
		//-----------------------------------------------------------------------
		// Методы экземпляра класса.
		
		// Метод загрузки изображения.
		// Параметры:
		// parImageIndex           - индекс изображения,
		// parImagePathString      - текстовая строка пути к изображению,
		// parImageInformation     - информация изображения,
		// parImageSpriteRectangle - прямоугольная область спрайта изображения.
		private function LoadImage
		(
		 	parImageIndex:           uint,
			parImagePathString:      String,
			parImageInformation:     Object,
			parImageSpriteRectangle: Rectangle
		): void
		{
			// Если ещё не существует спрайта изображения
			// для изображения с заданным индексом, то он создаётся.
			if ( this._ImagesSprites[ parImageIndex ] == null )
			{
				// Создание спрайта для размещения изображения.
				this._ImagesSprites[ parImageIndex ] = new ImageSprite
					( this._ImageSpriteWidthToHeightRatio, parImageInformation );
				// Добавление спрайта изображения в строку изображений.
				this.addChild( this._ImagesSprites[ parImageIndex ] );
					
				// Абсцисса спрайта изображения.
				this._ImagesSprites[ parImageIndex ].x = parImageSpriteRectangle.x;
				// Ордината спрайта изображения.
				this._ImagesSprites[ parImageIndex ].y = parImageSpriteRectangle.y;					
				// Ширина спрайта изображения.
				this._ImagesSprites[ parImageIndex ].width  =
					parImageSpriteRectangle.width;
				// Высота спрайта изображения.
				this._ImagesSprites[ parImageIndex ].height =
					parImageSpriteRectangle.height;
				
				// Регистрирация объекта-прослушивателя события
				// успешной загрузки изображения на спрайт изображения.
				this._ImagesSprites[ parImageIndex ].addEventListener
					( ImageSpriteEvent.IMAGE_SPRITE_IMAGE_LOADING_COMPLETE,
					this.ImageSpriteImageLoadindCompleteListener );
				// Регистрирация объекта-прослушивателя события
				// возникновения ошибки при загрузки изображения
				// на спрайт изображения.
				this._ImagesSprites[ parImageIndex ].addEventListener
					( ImageSpriteEvent.IMAGE_SPRITE_IMAGE_LOADING_IO_ERROR,
					this.ImageSpriteImageLoadindIOErrorListener );					
			} // if
			
			// Иначе просто меняется информация
			// уже существующего спрайта изображения.
			else
				this._ImagesSprites[ parImageIndex ].Information =
					parImageInformation;

			// Загрузка изображения из файла по заданному пути
			// на спрайт изображения.
			this._ImagesSprites[ parImageIndex ].LoadImage( parImagePathString );
		} // LoadImage		
		
		// Метод загрузки изображений.
		// Параметры:
		// parImageSpriteWidthToHeightRatio - коэффициент отношения 
		//   ширины спрайта изображения к высоте,
		// parImagesPathsStrings - массив текстовых строк путей к изображениям,
		// parImagesInformations - массив информаций изображений.
		public function LoadImages
		(
		 	parImageSpriteWidthToHeightRatio: Number,
			parImagesPathsStrings,
			parImagesInformations:            Array
		): void
		{
			// Коэффициент отношения ширины спрайта изображения к высоте.
			this._ImageSpriteWidthToHeightRatio = parImageSpriteWidthToHeightRatio;	
			
			// Задан массив текстовых строк путей к изображениям.
			// Из его элементов будут загружены изображения на спрайты.
			// Эти спрайты будут располагаться последовательно
			// и иметь одинаковые размеры.
			// Это есть ПОЛЕДОВАТЕЛЬНОСТЬ спрайтов изображений.
			
			// Количество изображений для последовательности спрайтов изображений.
			var imagesSpritesSequenceImagesCount: uint   =
				parImagesPathsStrings.length;
			// Ширина последовательности спрайтов изображений.
			var imagesSpritesSequenceWidth:       Number =
				imagesSpritesSequenceImagesCount * this.ImageSpriteWidth;				
			// Количество информаций изображений для последовательности
			// спрайтов изображений должно соответствовать
			// количеству эти изображений.
			parImagesInformations.length = imagesSpritesSequenceImagesCount;
				
			// Прямоугольная область прокрутки строки изображений
			// должна быть полностью запонена спрайтами изображений,
			// чтобы не было областей пустого пространства.
			// Она запоняется последовательностью спрайтов изображений,
			// ширина которой может отличаться от ширины самой
			// прямоугольной области прокрутки строки изображений.
			
			// Если ширина последовательности спрайтов изображений меньше
			// ширины прямоугольной области прокрутки строки изображений,
			// то следом за этой последовательностью добавляются ещё точно такие же
			// последовательности спрайтов изображений до тех пор,
			// пока суммарная длина этих последовательностей будет не меньше,
			// чем ширина прямоугольной области прокрутки строки изображений.
			// Такая последовательность посделовательностей спрайтов изображений
			// есть СЕРИЯ ПОСЛЕДОВАТЕЛЬНОСТЕЙ спрайтов изображений.
			
			// Если же ширина последовательности спрайтов изображений и так
			// не меньше ширины прямоугольной области прокрутки строки изображений,
			// то серия последовательностей спрайтов изображений
			// состоит всего из одной последовательности спрайтов изображений.
			
			// Количество последовательностей
			// в серии последовательностей спрайтов изображений.
			var imagesSpritesSequencesRangeSequencesCount: uint   = Math.ceil
				( this.scrollRect.width / imagesSpritesSequenceWidth );
			// Количество изображений для серии последовательностей
			// спрайтов изображений.
			var imagesSpritesSequencesRangeImagesCount:    uint   =
				imagesSpritesSequenceImagesCount *
				imagesSpritesSequencesRangeSequencesCount;
			// Ширина серии последовательностей спрайтов изображений.
			var imagesSpritesSequencesRangeWidth:          Number =
				imagesSpritesSequenceWidth       *
				Number( imagesSpritesSequencesRangeSequencesCount );
				
			// Массив текстовых строк путей к изображениям
			// серии последовательностей спрайтов изображений.
			var imagesSpritesSequencesRangeImagesPathsStrings: Array =
				new Array( );
			// Массив информаций изображений
			// серии последовательностей спрайтов изображений.
			var imagesSpritesSequencesRangeImagesInformations: Array =
				new Array( );
			
			// Последовательный просмотр всех последовательностей
			// в серии последовательностей спрайтов изображений.
			for
			(
				var imagesSpritesSequenceIndex: uint = 0;
				imagesSpritesSequenceIndex <
					imagesSpritesSequencesRangeSequencesCount;
				imagesSpritesSequenceIndex++ 
			)
			{
				// Добавление массива текстовых строк путей к изображениям
				// в массив текстовых строк путей к изображениям
				// серии последовательностей спрайтов изображений
				// для текущей последовательности спрайтов изображений.
				imagesSpritesSequencesRangeImagesPathsStrings =
					imagesSpritesSequencesRangeImagesPathsStrings.
					concat( parImagesPathsStrings );
				// Добавление массива информаций изображений
				// в массив информаций изображений
				// серии последовательностей спрайтов изображений
				// для текущей последовательности спрайтов изображений.
				imagesSpritesSequencesRangeImagesInformations =
					imagesSpritesSequencesRangeImagesInformations.
					concat( parImagesInformations );
			} // for
			
			// Количество элементов массива текстовых строк путей к изображениям
			// серии последовательностей спрайтов изображений.
			imagesSpritesSequencesRangeImagesPathsStrings.length =
				imagesSpritesSequencesRangeImagesCount;
			// Количество элементов массива информаций изображений
			// серии последовательностей спрайтов изображений.
			imagesSpritesSequencesRangeImagesInformations.length =
				imagesSpritesSequencesRangeImagesCount;
				
			// Требуется "закольцевать" движение строки изображений,
			// сделать его непрерывным, бесконечным, но это физически не возможно:
			// видимое движение строки изображений происходит из-за изменения
			// абсциссы прямоугольной области прокрутки строки изображений
			// (в действительности координаты самой строки изобржений
			// не изменяются) - конечного вещественного числа, имеющего пределы,
			// и создавать большое количество спрайтов с одинаковыми изображениями -
			// большое количество последовательностей спрайтов изображений -
			// ужасно нерационально.
			
			// Было найдено следующее решение.
			// Строка изображений будет представлять собой конечный ФРАГМЕНТ,
			// состоящий из ТРЁХ СЕРИЙ последовательностей спрайтов изображений:
			// ЛЕВОЙ, ЦЕНТРАЛЬНОЙ и ПРАВОЙ серии.
			
			// В исходном положении абсцисса прямоугольной области прокрутки
			// строки изображений - абсцисса начала центральной серии.
			// Если в процессе движения абсцисса прямоугольной области прокрутки
			// строки изображений достигнет абсциссы левой серии (начала фрагмента)
			// или абсциссы правой серии, то она должна переместиться
			// в исходное положение - в абсциссу центральной серии.
			
			// Абсцисса левой серии последовательностей спрайтов изображений -
			// начало фрагмента.
			this._ImagesSpritesSequencesLeftRangeX   = 0;
			// Абсцисса центральной серии последовательностей спрайтов изображений.
			this._ImagesSpritesSequencesMiddleRangeX =
				imagesSpritesSequencesRangeWidth;
			// Абсцисса правой серии последовательностей спрайтов изображений.
			this._ImagesSpritesSequencesRightRangeX  =
				this._ImagesSpritesSequencesMiddleRangeX +
				imagesSpritesSequencesRangeWidth;
			// Установка прямоугольной области прокрутки
			// строки изображений в исходное положение.
			this.SetScrollRectangleToHomePosition( );	
				
			// Количество изображений для фрагмента серий последовательностей
			// спрайтов изображений.
			var imagesSpritesSequencesRangesFragmentImagesCount: uint =
				imagesSpritesSequencesRangeImagesCount *
				ImagesLine.IMAGES_SPRITES_SEQUENCES_RANGES_FRAGMENT_RANGES_COUNT;
			
			// Массив текстовых строк путей к изображениям
			// фрагмента серий последовательностей спрайтов изображений.
			var imagesSpritesSequencesRangsFragmentImagesPathsStrings: Array =
				new Array( );
			// Массив информаций изображений
			// фрагмента серий последовательностей спрайтов изображений.
			var imagesSpritesSequencesRangsFragmentImagesInformations: Array =
				new Array( );
				
			// Последовательный просмотр всех серий
			// во фрагменте серий последовательностей спрайтов изображений.
			for
			(
				var imagesSpritesSequencesRangeIndex: uint = 0;
				imagesSpritesSequencesRangeIndex <
					ImagesLine.IMAGES_SPRITES_SEQUENCES_RANGES_FRAGMENT_RANGES_COUNT;
				imagesSpritesSequencesRangeIndex++ 
			)
			{
				// Добавление массива текстовых строк путей к изображениям
				// серии последовательностей спрайтов изображений
				// в массив текстовых строк путей к изображениям
				// фрагмента серий последовательностей спрайтов изображений
				// для текущей серии последовательностей спрайтов изображений.
				imagesSpritesSequencesRangsFragmentImagesPathsStrings =
					imagesSpritesSequencesRangsFragmentImagesPathsStrings.
					concat( imagesSpritesSequencesRangeImagesPathsStrings );
				// Добавление массива информаций изображений
				// серии последовательностей спрайтов изображений
				// в массив информаций изображений
				// фрагмента серий последовательностей спрайтов изображений
				// для текущей серии последовательностей спрайтов изображений.
				imagesSpritesSequencesRangsFragmentImagesInformations =
					imagesSpritesSequencesRangsFragmentImagesInformations.
					concat( imagesSpritesSequencesRangeImagesInformations );
			} // for

			// Количество элементов массива текстовых строк путей к изображениям
			// фрагмента серий последовательностей спрайтов изображений.
			imagesSpritesSequencesRangsFragmentImagesPathsStrings.length =
				imagesSpritesSequencesRangesFragmentImagesCount;
			// Количество элементов массива информаций изображений
			// фрагмента серий последовательностей спрайтов изображений.
			imagesSpritesSequencesRangsFragmentImagesInformations.length =
				imagesSpritesSequencesRangesFragmentImagesCount;		
			
			// Индекс изображения.
			var imageIndex:   uint;
			
			// Если прежнее количество спрайтов изображений
			// превышает количество изображений фрагмента.
			if ( imagesSpritesSequencesRangesFragmentImagesCount <
					this._ImagesSprites.length )
				// Последовательный просмотр последних лишних спрайтов изображений.
				for ( imageIndex = imagesSpritesSequencesRangesFragmentImagesCount;
					imageIndex < this._ImagesSprites.length; imageIndex++ )
				{
					// Удаление спрайта изображения из строки изображений.
					this.removeChild( this._ImagesSprites[ imageIndex ] );
					// Установка неопределённого значения
					// для текщего спрайта изображения.
					this._ImagesSprites[ imageIndex ] = null;
				} // for			
			
			// Количество спрайтов изображений
			// соответствует количеству изображений фрагмента.
			this._ImagesSprites.length    =
				imagesSpritesSequencesRangesFragmentImagesCount;			
			// Высота спрайта изображения.
			var imageSpriteHeight: Number = this.ImageSpriteHeight;			
			// Ширина спрайта изображения.
			var imageSpriteWidth:  Number = this.ImageSpriteWidth;
			
			// Последовательная загрузка всех изображений.
			for ( imageIndex = 0; imageIndex <
				imagesSpritesSequencesRangesFragmentImagesCount; imageIndex++ )
			{
				// Загрузка текущего изображения.
				this.LoadImage
				(
				 	// Индекс изображения - текущий.
				 	imageIndex,
					// Текстовая строка пути к изображению.
					imagesSpritesSequencesRangsFragmentImagesPathsStrings
						[ imageIndex ],
					// Информация изображения.
					imagesSpritesSequencesRangsFragmentImagesInformations
						[ imageIndex ],
					// Прямоугольная область спрайта изображения.
					new Rectangle
					(
						// Абсцисса:
						// произведение индекса текущего изображения
						// и ширины спрайта изображения.					 
						imageIndex * imageSpriteWidth,
						// Ордината.
						0,	
						// Ширина.
						imageSpriteWidth,
						// Высота.
						imageSpriteHeight
					) // new Rectangle
				) // this.LoadImage
			} // for
		} // LoadImages		
		
		// Метод получения спрайта изображения по индексу из массива.
		// Индексация спрайтов изображений в массиве начинается с нуля.
		// Параметры:
		// parImageSpriteIndex - индекс спрайта изображения.		
		// Результат: спрайт изображения по индексу из массива.
		public function ImageSpriteOfIndex
			( parImageSpriteIndex: int ): ImageSprite
		{
			// Спрайт изображения по индексу из массива.
			return this._ImagesSprites[ parImageSpriteIndex ];
		} // ImageSpriteOfIndex		
		
		// Метод остановки движения строки изображений.
		public function StopMotion( ): void
		{
			// При выполнении покадрового движения по инерции
			// проверяется признак неподвижности строки изображений:
			// чтобы движение осуществлялось, этот признак должен быть ложным,
			// следовательно, чтобы остановить движение, надо сделать его истинным.
			this._IsStill = true;
		} // StopMotion	
		
		// Метод устновки абсциссы прямоугольной области прокрутки
		// строки изображений.
		// Параметры:
		// parScrollRectangleX - абсцисса прямоугольной области прокрутки
		//   строки изображений.		
		private function SetScrollRectangleX( parScrollRectangleX: Number ): void
		{
			// Прямоугольная область прокрутки.
			var scrollRectangle: Rectangle = this.scrollRect;			
			
			// Если заданная абсцисса прямоугольной области
			// прокрутки строки изображений находится в пределах 
			// между абсциссой левой серии последовательностей спрайтов изображений
			// и абсциссой правой серии последовательностей спрайтов изображений,
			// то есть она не уйдёт сильно вправо, когда слева от строки изображений
			// в её области прокрутки может появиться пустое место,
			// и не уйдёт сильно влево, когда справа от строки изображений
			// в её области прокрутки также может появиться пустое место.
			if 
			(
				( parScrollRectangleX >= this._ImagesSpritesSequencesLeftRangeX  ) &&
				( parScrollRectangleX <= this._ImagesSpritesSequencesRightRangeX )
			)
				// Установка заданной абсциссы прямоугольной области прокрутки.
				scrollRectangle.x = parScrollRectangleX;
				
			// Если заданная абсцисса прямоугольной области
			// прокрутки строки изображений находится вне пределов
			// воплощения иллюзии афинной бесконечности строки изображений.
			else
			{
				// Для воплощения иллюзии афинной бесконечности строки изображений
				// абсцисса прямоугольной области прокрутки строки изображений
				// должна установиться в исходное положение - в абсциссу
				// центральной серии последовательностей спрайтов изображений.
				
				// При этом может произойти подёргивание, так как только перемещение
				// из абсциссы левой серии последовательностей спрайтов изображений
				// или абсциссы правой серии последовательностей спрайтов изображений
				// в абсциссу центральной серии последовательностей
				// спрайтов изображений даст плавный переход.
				
				// Поэтому следует учесть смещение заданной абсциссы
				// прямоугольной области прокрутки строки изображений
				// от контрольной точки - абсциссы правой серии последовательностей
				// спрайтов изображений или абсциссы правой серии последовательностей
				// спрайтов изображений.
			 
				// Это смещение будет смещением от абсциссы центральной серии
				// последовательностей спрайтов изображений при перемещении в неё
				// абсциссы прямоугольной области прокрутки строки изображений.
				
				// Смещение абсциссы прямоугольной области прокрутки
				// строки изображений от абсциссы центральной серии
				// последовательностей спрайтов изображений.
				var scrollRectangleXOffset: Number = 0;
				
				// Если абсцисса прямоугольной области прокрутки строки изображений
				// слева от строки изображений.
				if ( parScrollRectangleX < this._ImagesSpritesSequencesLeftRangeX )
					// Смещение абсциссы прямоугольной области прокрутки
					// строки изображений от абсциссы левой серии
					// последовательностей спрайтов изображений.
					scrollRectangleXOffset = parScrollRectangleX -
						this._ImagesSpritesSequencesLeftRangeX;
				// Если абсцисса прямоугольной области прокрутки строки изображений
				// справа от строки изображений.
				//if ( parScrollRectangleX > this._ImagesSpritesSequencesRightRangeX )
				else
					// Смещение абсциссы прямоугольной области прокрутки
					// строки изображений от абсциссы правой серии
					// последовательностей спрайтов изображений.				
					scrollRectangleXOffset = parScrollRectangleX -
						this._ImagesSpritesSequencesRightRangeX;

				// Установка абсциссы прямоугольной области прокрутки
				// в абсциссу центральной серии последовательностей
				// спрайтов изображений со смещением.
				scrollRectangle.x = this._ImagesSpritesSequencesMiddleRangeX +
					scrollRectangleXOffset;				
			} // else
			
			// Переустановка прямоугольной области прокрутки.
			this.scrollRect = scrollRectangle;			
		} // SetScrollRectangleX
		
		// Метод установки прямоугольной области прокрутки
		// строки изображений в исходное положение.
		public function SetScrollRectangleToHomePosition( ): void
		{
			// Установка абсциссы прямоугольной области прокрутки в абсциссу
			// центральной серии последовательностей спрайтов изображений.
			this.SetScrollRectangleX( this._ImagesSpritesSequencesMiddleRangeX );
		} // SetScrollRectangleToHomePosition
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
			
			// Максимальный модуль смещения от точки нажатия до точки отпускания
			// кнопки мыши по оси абсцисс в области клика мыши.
			ImagesLine.ClickXMaximumAbsoluteOffset =
				staticParametersXML.ClickXMaximumAbsoluteOffset[ 0 ];
			// Минимальный интервал времени совершения клика мышью.
			ImagesLine.ClickTimeMinimumInterval    =
				staticParametersXML.ClickTimeMinimumInterval[ 0 ];
			// Максимальный интервал времени совершения клика мышью.
			ImagesLine.ClickTimeMaximumInterval    =
				staticParametersXML.ClickTimeMaximumInterval[ 0 ];	
		
			// Модуль ускорения равнозамедленного движения
			// в пикселях в миллисекунду за миллисекунду.
			ImagesLine.DeceleratedMotionAbsoluteAcceleRation =
				staticParametersXML.DeceleratedMotionAbsoluteAcceleRation[ 0 ];	
			
			// Передача события окончания загрузки статических параметров,
			// целью - объбектом-получателем - которого является объект
			// статического диспетчера событий данного класса строки изображений.
			ImagesLine._StaticEventDispatcher.dispatchEvent( new Event
				( ImagesLine.STATIC_PARAMETERS_LOADING_FINISHED ) );
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
			trace( ImagesLine.
				STATIC_PARAMETERS_FILE_URL_LOADING_IO_ERROR_MESSAGE );
			// Передача события возникновения ошибки
			// при загрузке статических параметров,
			// целью - объбектом-получателем - которого является объект
			// статического диспетчера событий данного класса строки изображений.
			ImagesLine._StaticEventDispatcher.dispatchEvent( new Event
				( ImagesLine.STATIC_PARAMETERS_LOADING_IO_ERROR ) );			
			// Передача события окончания загрузки статических параметров,
			// целью - объбектом-получателем - которого является объект
			// статического диспетчера событий данного класса строки изображений.
			ImagesLine._StaticEventDispatcher.dispatchEvent( new Event
				( ImagesLine.STATIC_PARAMETERS_LOADING_FINISHED ) );
		} // StaticParametersFileURLLoadingIOErrorListener		
		
		// Метод-прослушиватель события
		// успешной загрузки изображения на спрайт изображения.
		// Параметры:
		// parImageSpriteEvent - событие спрайта изображения.
		private function ImageSpriteImageLoadindCompleteListener
			( parImageSpriteEvent: ImageSpriteEvent ): void
		{
			// Передача события успешной загрузки изображения
			// на спрайт изображения в поток событий, целью -
			// объбектом-получателем - которого является данный объект
			// строки изображений - объект, в котором находится
			// объект-приёмник обрабатываемого события, а спрайтом изображения,
			// на котором произошло событие успешной загрузки изображения
			// на спрайт изображения - объект-приёмник обрабатываемого события.
			this.dispatchEvent
			(
				new ImageSpriteEvent
				(
					ImageSpriteEvent.IMAGE_SPRITE_IMAGE_LOADING_COMPLETE,
					ImageSprite( parImageSpriteEvent.target )
				) // new ImageSpriteEvent
			); // this.dispatchEvent
		} // ImageSpriteImageLoadindCompleteListener

		// Метод-прослушиватель события
		// возникновения ошибки при загрузке изображения
		// на спрайт изображения.
		// Параметры:
		// parImageSpriteEvent - событие спрайта изображения.
		private function ImageSpriteImageLoadindIOErrorListener
			( parImageSpriteEvent: ImageSpriteEvent ): void
		{	
			// Передача события возникновения ошибки при загрузке изображения
			// на спрайт изображения в поток событий, целью -
			// объбектом-получателем - которого является данный объект
			// строки изображений - объект, в котором находится
			// объект-приёмник обрабатываемого события, а спрайтом изображения,
			// на котором произошло событие возникновения ошибки
			// при загрузке изображения на спрайт изображения -
			// объект-приёмник обрабатываемого события.
			this.dispatchEvent
			(
				new ImageSpriteEvent
				(
					ImageSpriteEvent.IMAGE_SPRITE_IMAGE_LOADING_IO_ERROR,
					ImageSprite( parImageSpriteEvent.target )
				) // new ImageSpriteEvent
			); // this.dispatchEvent
		} // ImageSpriteImageLoadindIOErrorListener

		// Метод-прослушиватель события
		// нажатия кнопки мыши на строке изображений.
		// Параметры:
		// parMouseEvent - событие мыши.
		private static function MouseDownListener
			( parMouseEvent: MouseEvent ): void
		{
			// Если была нажата не основная кнопка мыши,
			// то реации на событие мыши не будет.
			if ( ! parMouseEvent.buttonDown )
				return;
				
			// Текущее время в миллисекундах.
			var currentTime: Number  = ( new Date( ) ).time;

			// Объект, в котором находится объект-приёмник события -
			// строка изображений, на которой была нажата кнопка мыши.
			var imagesLine: ImagesLine = ImagesLine( parMouseEvent.currentTarget );
			// Спрайт изображения, на котором была нажата кнопка мыши.
			var imageSprite: ImageSprite;
			// Если объект-приёмник события - спрайт изображения.
			if ( parMouseEvent.target is ImageSprite )
				// Спрайт изображения, на котором была нажата кнопка мыши, -
				// объект-приёмник события.
				imageSprite = ImageSprite( parMouseEvent.target );
			// Если объект-приёмник события - не спрайт изображения.
			else
				// Скорее всего, кнопка мыши была нажата на пиктограмме
				// спрайта изображения - на потомке спрайта изображения,
				// тогда сам спрайт изображения, на котором была нажата кнопка мыши, -
				// предок объекта-приёмника события.
				imageSprite = ImageSprite( parMouseEvent.target.parent );				
				
			// Признак того, что кнопка мыши была нажата на строке изображений.
			imagesLine._MouseDownWasOnThis        = true;	
			// Абсцисса спрайта изображения, на котором была нажата кнопка мыши.
			imagesLine._MouseDownImageSpriteX     = imageSprite.x;
			// Абсцисса прямоугольной области прокрутки строки изображений
			// в момент нажатия кнопки мыши.
			imagesLine._MouseDownScrollRectangleX = imagesLine.scrollRect.x;
			// Абсцисса точки сцены, в которой была нажата кнопка мыши.
			imagesLine._MouseDownStageX           = parMouseEvent.stageX;		
			// Момент времени, в которой была нажата кнопка мыши, в миллисекундах -
			// настоящий момент времени.
			imagesLine._MouseDownTime             = currentTime;
			
			// Максимальный модуль смещения по оси абсцисс в процессе
			// управления движением мышью - нулевой, движение ещё не началось.
			imagesLine._MouseMoveXMaximumAbsoluteOffset = 0;			
			
			// Отмена регистрирации объекта-прослушивателя события
			// нажатия кнопки мыши на строке изображений.
			imagesLine.removeEventListener( MouseEvent.MOUSE_DOWN,
				ImagesLine.MouseDownListener );
			// Отмена регистрирации объекта-прослушивателя события
			// перехода точки воспроизведения в новый кадр.
			imagesLine.removeEventListener( Event.ENTER_FRAME,
				ImagesLine.EnterFrameListener );			
			
			// Регистрирация объекта-прослушивателя события
			// перемещения курсора мыши за пределы области строки изображений.
			imagesLine.addEventListener( MouseEvent.ROLL_OUT,
				ImagesLine.RollOutListener );			
			// Регистрирация объекта-прослушивателя события
			// перемещения курсора мыши над строкой изображений.
			imagesLine.addEventListener( MouseEvent.MOUSE_MOVE,
				ImagesLine.MouseMoveListener );
			// Регистрирация объекта-прослушивателя
			// отпускания кнопки мыши на строке изображений.
			imagesLine.addEventListener( MouseEvent.MOUSE_UP,
				ImagesLine.MouseUpListener );			
		} // MouseDownListener		
		
		// Метод-прослушиватель события события
		// перемещения курсора мыши за пределы области строки изображений.
		// Параметры:
		// parMouseEvent - событие мыши.
		private static function RollOutListener
			( parMouseEvent: MouseEvent ): void
		{
			// Объект, в котором находится объект-приёмник события - строка
			// изображений, за пределы области которой переместился курсор мыши.
			var imagesLine: ImagesLine = ImagesLine( parMouseEvent.currentTarget );
			// Признак того, что кнопка мыши была нажата на строке изображений,
			// теперь ложный: он нужен, если указатель мыши не покидает строку.
			imagesLine._MouseDownWasOnThis = false;

			// Отмена регистрирации объекта-прослушивателя события
			// перемещения курсора мыши за пределы области строкой изображений.
			imagesLine.removeEventListener( MouseEvent.ROLL_OUT,
				ImagesLine.RollOutListener );
			// Отмена регистрирации объекта-прослушивателя события
			// перемещения курсора мыши над строкой изображений.
			imagesLine.removeEventListener( MouseEvent.MOUSE_MOVE,
				ImagesLine.MouseMoveListener );
			// Отмена регистрирации объекта-прослушивателя события
			// отпускания кнопки мыши на строке изображений.
			imagesLine.removeEventListener( MouseEvent.MOUSE_UP,
				ImagesLine.MouseUpListener );		
			
			// Регистрирация объекта-прослушивателя события
			// нажатия кнопки мыши над строкой изображений.
			imagesLine.addEventListener( MouseEvent.MOUSE_DOWN,
				ImagesLine.MouseDownListener );
		} // RollOutListeners		

		// Метод-прослушиватель события перемещения курсора мыши над строкой.
		// Параметры:
		// parMouseEvent - событие мыши.
		private static function MouseMoveListener
			( parMouseEvent: MouseEvent ): void
		{
			// Объект, в котором находится объект-приёмник события - строка
			// изображений по которой перемещается курсор мыши.
			var imagesLine: ImagesLine = ImagesLine( parMouseEvent.currentTarget );
			
			// Если основная кнопка мыши не была нажата на линии изображений,
			// то реации на событие мыши не будет.
			if ( ! imagesLine._MouseDownWasOnThis )
				return;
				
			// Смещение курсора мыши по оси абсцисс от точки нажатия
			// основной кнопки мыши в процессе управления движением мышью.
			var mouseMoveXOffset:         Number = parMouseEvent.stageX -
				imagesLine._MouseDownStageX;
			// Модуль смещения курсора мыши по оси абсцисс от точки нажатия
			// основной кнопки мыши в процессе управления движением мышью.
			var mouseMoveXAbsoluteOffset: Number = Math.abs( mouseMoveXOffset );
			// Если текущий модуль смещения курсора по оси абсцисс от точки нажатия
			// основной кнопки мыши в процессе управления движением мышью
			// превышает максимальный, то становится таковым.
			if ( mouseMoveXAbsoluteOffset >
					imagesLine._MouseMoveXMaximumAbsoluteOffset )
				imagesLine._MouseMoveXMaximumAbsoluteOffset =
					mouseMoveXAbsoluteOffset;				
					
			// Устанавливается новая абсцисса прямоугольной области прокрутки
			// строки изображений.
			imagesLine.SetScrollRectangleX( imagesLine._MouseDownScrollRectangleX -
				mouseMoveXOffset );
		} // MouseMoveListener

		// Метод-прослушиватель события
		// отпускания кнопки мыши на строке изображений.
		// Параметры:
		// parMouseEvent - событие мыши.
		private static function MouseUpListener
			( parMouseEvent: MouseEvent ): void
		{
			// Объект, в котором находится объект-приёмник события -
			// строка изображений, на которой была отжата кнопка мыши.
			var imagesLine: ImagesLine = ImagesLine( parMouseEvent.currentTarget );
			
			// Если кнопка мыши не была нажата на строке изображений,
			// то реации на событие мыши не будет.
			if ( ! imagesLine._MouseDownWasOnThis )
				return;
				
			// Текущее время в миллисекундах.
			var currentTime: Number  = ( new Date( ) ).time;
				
			// Признак того, что кнопка мыши была нажата на строке изображений
			// теперь ложный в ожидании следующего нажатия кнопки мыши.
			imagesLine._MouseDownWasOnThis = false;

			// Отмена регистрирации объекта-прослушивателя события
			// перемещения курсора мыши за пределы области строкой изображений.
			imagesLine.removeEventListener( MouseEvent.ROLL_OUT,
				ImagesLine.RollOutListener );			
			// Отмена регистрирации объекта-прослушивателя события
			// перемещения курсора мыши над строкой изображений.
			imagesLine.removeEventListener( MouseEvent.MOUSE_MOVE,
				ImagesLine.MouseMoveListener );
			// Отмена регистрирации объекта-прослушивателя события
			// отпускания кнопки мыши на строке изображений.
			imagesLine.removeEventListener( MouseEvent.MOUSE_UP,
				ImagesLine.MouseUpListener );
			
			// Регистрирация объекта-прослушивателя события
			// нажатия кнопки мыши над строкой изображений.
			imagesLine.addEventListener( MouseEvent.MOUSE_DOWN,
				ImagesLine.MouseDownListener );			
			
			// Спрайт изображения, на котором была отжата кнопка мыши.
			var mouseUpImageSprite: ImageSprite;			
			// Если объект-приёмник события - спрайт изображения.
			if ( parMouseEvent.target is ImageSprite )
				// Спрайт изображения, на котором была отжата кнопка мыши, -
				// объект-приёмник события.
				mouseUpImageSprite = ImageSprite( parMouseEvent.target );
			// Если объект-приёмник события - не спрайт изображения.
			else
				// Скорее всего, кнопка мыши была отжата на пиктограмме
				// спрайта изображения - на потомке спрайта изображения,
				// тогда сам спрайт изображения, на котором была отжата кнопка мыши, -
				// предок объекта-приёмника события.
				mouseUpImageSprite = ImageSprite( parMouseEvent.target.parent );
				
			// Интервал времени в миллисекундах, прошедний от момента нажатия
			// до момента отпускания кнопки мыши.
			var sinceMouseDownTimeInterval: Number = currentTime -
				imagesLine._MouseDownTime;	
				
			// Проверяется был ли произведён клик мышью.
			// Для этого должный выполняться следующие условия:
			// 1) максимальный модуль смещения по оси абсцисс в процессе движения
			// не должен превышать максимальный модуль смещения по оси абсцисс
			// в области клика мыши;
			// 2) спрайт изображения, на котором была нажата кнопка мыши
			// должен быть тем же спрайтом изображения, на котором кнопка мыши
			// была отпущена - проверяются абсциссы спрайтов на строке изображений.
			if
			(
				(
					imagesLine._MouseMoveXMaximumAbsoluteOffset <=
					ImagesLine.ClickXMaximumAbsoluteOffset
				) &&
				(
				 	int( mouseUpImageSprite.x )         ==
					int( imagesLine._MouseDownImageSpriteX )
				)
			)
			{
				// Проверяется был ли выбран текущий спрайт изображения.
				// Для этого должный выполняться следующие условия:
				// 1) строка изображений должна быть неподвижна;
				// 2) интервал времени между нажатием и отпусканием кнопки мыши
				// должен быть в диапазоне между минимальным и максимальным
				// интервалами времени совершения клика мышью.	
				if
				(
					( imagesLine._IsStill ) &&
					(	
						sinceMouseDownTimeInterval >=
						ImagesLine.ClickTimeMinimumInterval
					) &&
					(	
						sinceMouseDownTimeInterval <=
						ImagesLine.ClickTimeMaximumInterval
					)
				)
					// Передача события клика мыши на спрайте изображения
					// в поток событий, целью - объбектом-получателем - которого
					// является объект строки изображений - объект, в котором находится
					// cпрайт изображения, на котором была отжата кнопка мыши,
					// а спрайтом изображения, на котором произошло событие клика мыши -
					// cпрайт изображения, на котором была отжата кнопка мыши.
					imagesLine.dispatchEvent
					(
						new ImageSpriteEvent
						(
							ImageSpriteEvent.IMAGE_SPRITE_CLICK,
							ImageSprite( mouseUpImageSprite ), 
							parMouseEvent.bubbles,
							parMouseEvent.cancelable,
							parMouseEvent.localX,
							parMouseEvent.localY,
							parMouseEvent.relatedObject,
							parMouseEvent.ctrlKey,
							parMouseEvent.altKey,
							parMouseEvent.shiftKey,
							parMouseEvent.buttonDown,
							parMouseEvent.delta
						)
					); // imagesLine.dispatchEvent					
					
				// В любом случае строка изображений останавливается.
				imagesLine._IsStill = true;				
				return;
			} // if

			// Начинается равнозамедленное движение, и строка изображений
			// начинает двигаться по инерции.
			imagesLine._IsStill = false;
			
			// Текущий начальный момент времени равнозамедленного движения
			// в миллисекундах - настоящий момент времени.
			imagesLine._DeceleratedMotionCurrentStartTime = currentTime;
			// Проекция перемещения в пикселях курсора мыши на ось абсцисс
			// от точки нажатия до точки отпускания кнопки мыши.
			var mouseMoveXProjection: Number = parMouseEvent.stageX -
				imagesLine._MouseDownStageX;
				
			// Поскольку известна проекция перемещения в пикселях курсора мыши
			// на ось абсцисс от точки нажатия до точки отпускания кнопки мыши
			// и интервал времени в миллисекундах, прошедний от момента нажатия
			// до момента отпускания кнопки мыши, то можно найти
			// проекцию на ось абсцисс в пикселях за миллисекунду средней скорости
			// движения указателя мыши от момента нажания до момента отпускания
			// кнопки мыши как частное этих величин.
					
			// Текущая скорость равнозамедленного движения
			// в момент отпускания кнопки мыши принимается равной
			// проекции на ось абсцисс в пикселях за миллисекунду средней скорости
			// движения указателя мыши от момента нажания до момента отпускания
			// кнопки мыши, поскольку строка изображений начинает двигаться
			// самостоятельно, равнозамедленно, с ускорением
			// и параллельно оси абсцисс, по оси же ординат проекция
			// вектора перемещения нулевая.			
			imagesLine._DeceleratedMotionCurrentVelocity = mouseMoveXProjection /
				sinceMouseDownTimeInterval;			
			
			// Вектора перемещения и скорости сонаправлены
			// и их проекции имеют одинаковые знаки, а вектор ускорения
			// при равнозамедленном движении направлен противоположно им,
			// поэтому его проекция имеет противоположный знак.
			if ( mouseMoveXProjection > 0 )
				imagesLine._DeceleratedMotionAcceleration =
					-ImagesLine.DeceleratedMotionAbsoluteAcceleRation;
			else
				imagesLine._DeceleratedMotionAcceleration =
					ImagesLine.DeceleratedMotionAbsoluteAcceleRation;	
			
			// Регистрирация объекта-прослушивателя события
			// перехода точки воспроизведения в новый кадр.
			imagesLine.addEventListener( Event.ENTER_FRAME,
				ImagesLine.EnterFrameListener );
		} // MouseUpListener
		
		// Метод-прослушиватель события
		// перехода точки воспроизведения в новый кадр.
		// Параметры:
		// parEvent - событие.
		private static function EnterFrameListener( parEvent: Event ): void
		{
			// Текущий момент времени в миллисекундах.
			var currentTime:   Number     = ( new Date( ) ).time;			
			// Объект, в котором находится объект-приёмник события -
			// строка изображений для которой сменился кадр.
			var imagesLine:    ImagesLine = ImagesLine( parEvent.currentTarget );
			// Приращение вермени в миллисекундах:
			// разность текущего момента времени в миллисекундах
			// и текущего начального момента времени равнозамедленного движения
			// в миллисекундах
			var timeIncrement: Number     =  currentTime -
				imagesLine._DeceleratedMotionCurrentStartTime;
				
			// Новая абсцисса прямоугольной области прокрутки
			// строки изображений при равнозамедленном движенении
			// изменяется в сторону, противоположную направлению движения:
			// разность текущей абсциссы прямоугольной области прокрутки
			// строки изображений и суммы
			// произведения текущей скорости равнозамедленного движения
			// в пикселях в миллисекунду и приращения вермени в миллисекундах
			// и произведения половины ускорения равнозамедленного движения
			// в пикселях в миллисекунду за миллисекунду
			// и квадрата приращения вермени в миллисекундах в квадрате.
			var imagesLineScrollRectangleNewX: Number = imagesLine.scrollRect.x -
				( imagesLine._DeceleratedMotionCurrentVelocity * timeIncrement +
				( imagesLine._DeceleratedMotionAcceleration * timeIncrement *
				timeIncrement ) / 2.0 );
				
			// Если строка изображений неподвижна, то есть была остановлена,
			// или текущая скорость равнозамедленного движения
			// изменилась настолько, что приобрела противоположный знак
			// (она стала сонаправленной с ускорением равнозамедленного движения),
			// то происходит остановка движения строки изображений.
			if
			(
			 	imagesLine._IsStill                            ||
				(
					imagesLine._DeceleratedMotionCurrentVelocity *
					imagesLine._DeceleratedMotionAcceleration    >= 0
				)
			)
			{
				// Строка изображений становится неподвижной.
				imagesLine._IsStill = true;
				// Отмена регистрирации объекта-прослушивателя события
				// перехода точки воспроизведения в новый кадр.
				imagesLine.removeEventListener( Event.ENTER_FRAME,
					ImagesLine.EnterFrameListener );				
			} // if
			
			else
			{
				// Установка новой абсциссы прямоугольной области прокрутки
				// строки изображений при равнозамедленном движенении.
				imagesLine.SetScrollRectangleX( imagesLineScrollRectangleNewX );
				// Текущий начальный момент времени равнозамедленного движения
				// в миллисекундах переносится в настоящий момент времени.
				imagesLine._DeceleratedMotionCurrentStartTime = currentTime;
				// Текущая скорость равнозамедленного движения
				// в пикселях в миллисекунду изменяется на произведение
				// ускорения равнозамедленного движения в пикселях в миллисекунду
				// за миллисекунду и приращения вермени в миллисекундах.
				imagesLine._DeceleratedMotionCurrentVelocity +=
					imagesLine._DeceleratedMotionAcceleration * timeIncrement;
			} // else
		} // EnterFrameListener
		//-----------------------------------------------------------------------
		// Методы-конструкторы.
		
		// Метод-конструктор экземпляра строки изображения.
		// Параметры:
		// parX      - абсцисса строки изображений,
		// parY      - ордината строки изображений,
		// parWidth  - ширина   строки изображений,		
		// parHeight - высота   строки изображений.		
		public function ImagesLine
		(
			parX,
			parY,
			parWidth,
			parHeight: Number
		): void
		{
			// Вызов метода-конструктора суперкласса Sprite.
			super( );			
			
			// Абсцисса строки изображения.
			this.x                              = parX;
			// Ордината строки изображения.
			this.y                              = parY;
			// Определение прямоугольной области прокрутки строки изображений
			// заданной высоты.
			this.scrollRect = new Rectangle( 0, 0, parWidth, parHeight );
			
			// Регистрирация объекта-прослушивателя события
			// нажатия кнопки мыши на строке изображений.
			this.addEventListener( MouseEvent.MOUSE_DOWN,
				ImagesLine.MouseDownListener );
		} // ImagesLine		
		//-----------------------------------------------------------------------
		// Get- и set-методы.
		
		// Get-метод получения статического диспетчера событий.
		// Результат: статический диспетчер событий.
		public static function get StaticEventDispatcher( ): EventDispatcher
		{
			// Статический диспетчер событий.
			return ImagesLine._StaticEventDispatcher;
		} // StaticEventDispatcher
		
		// Get-метод получения коэффициента отношения
		// ширины спрайта изображения к высоте.
		// Результат: коэффициент отношения ширины спрайта изображения к высоте.
		public function get ImageSpriteWidthToHeightRatio( ): Number
		{
			// Коэффициент отношения ширины спрайта изображения к высоте.
			return this._ImageSpriteWidthToHeightRatio;
		} // ImageSpriteWidthToHeightRatio

		// Get-метод получения высоты спрайта изображения.
		// Результат: высота спрайта изображения в строке.
		public function get ImageSpriteHeight( ): Number
		{
			// Высота изображения - высота области прокрутки строки.
			return this.scrollRect.height;
		} // ImageSpriteHeight

		// Get-метод получения ширины спрайта изображения.
		// Результат: ширина спрайта изображения в строке.
		public function get ImageSpriteWidth( ): Number
		{
			// Ширина изображения относится к высоте с определённым коэффициентом.
			return this.scrollRect.height * this._ImageSpriteWidthToHeightRatio;
		} // ImageSpriteWidth
		
		// Get-метод получения ширины спрайтов изображений - суммарной ширины
		// всех спрайтов изображений из массива.
		// Результат: ширина спрайтов изображений - суммарная ширина
		// всех спрайтов изображений из массива.
		public function get ImagesSpritesWidth( ): Number
		{
			// Ширина спрайтов изображений - суммарная ширина
			// всех спрайтов изображений из массива.
			return this._ImagesSprites.length * this.ImageSpriteWidth;
		} // ImagesSpritesWidth		
	} // ImagesLine
} // nijanus.display