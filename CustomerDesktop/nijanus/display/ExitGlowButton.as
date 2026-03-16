// CustomerDesktop
// Author Kate Kotova
// NIJANUS Copyright © 2004-2010
// nijanus@ymail.com
// http://nijanus.narod2.ru
//---------------------------------------------------------------------------
// Пакет классов, связанных с отображением.
package nijanus.display
{
	// Класс светящейся кнопки выхода.
	public class ExitGlowButton extends ExitGlowButtonBase
	{
		// Список импортированных классов из других пакетов.

    import fl.events.ComponentEvent;
		import flash.display.Sprite;
		import flash.events.MouseEvent;
		//-----------------------------------------------------------------------
		// Переменные экземпляра класса.
		
		// Максимальный коэффициент отношения стороны пиктограммы
		// к соответствующей стороне светящейся кнопки выхода -
		// коэффициент, максимальный из двух:
		// отношения ширины пиктограммы к ширине светящейся кнопки выхода
		// и отношения высоты пиктограммы к высоте светящейся кнопки выхода.		
		protected var _IconSideToThisSameSideMaximumRatio: Number = 29/45;
		//-----------------------------------------------------------------------
		// Методы экземпляра класса.
		
		// Метод выравнивания пиктограммы.
		// Параметры:
		// parIconSprite - спрайт пиктограммы.
		protected function AlignIcon( parIconSprite: Sprite ): void
		{
			// Установка размеров спрайт пиктограммы.
			
			// Коэффициент отношения ширины спрайта пиктограммы к высоте.
			var iconSpriteWidthToHeightRatio: Number = parIconSprite.width /
				parIconSprite.height;			
			
			// Ширина спрайта пиктограммы при использовании коэффициента отношения
			// ширины пиктограммы к ширине светящейся кнопки выхода:
			// произведение ширины светящейся кнопки выхода и коэффициента
			// отношения ширины пиктограммы к ширине светящейся кнопки выхода.
			var iconSpriteWidthForWidthRatio:  Number = this.width  *
				this._IconSideToThisSameSideMaximumRatio;
			// Высота спрайта пиктограммы при использовании коэффициента отношения
			// ширины пиктограммы к ширине светящейся кнопки выхода:
			// частное полученной ширины и коэффициента отношения
			// ширины спрайта пиктограммы к высоте.
			var iconSpriteHeightForWidthRatio: Number =
				iconSpriteWidthForWidthRatio / iconSpriteWidthToHeightRatio;
			
			// Если отношение полученной высоты и высоты светящейся кнопки выхода
			// не первышает максимальный коэффициент отношения стороны пиктограммы
			// к соответствующей стороне светящейся кнопки выхода,
			// то устанавливаются полученные размеры спрайта пиктограммы.
			if ( ( iconSpriteHeightForWidthRatio / this.height ) <=
				this._IconSideToThisSameSideMaximumRatio )
			{
				// Ширина спрайта пиктограммы - полученная.
				parIconSprite.width  = iconSpriteWidthForWidthRatio;
				// Высота спрайта пиктограммы - полученная.
				parIconSprite.height = iconSpriteHeightForWidthRatio;
			} // if
			
			// Иначе размеры спрайта пиктограммы пересчитываются.
			else
			{
				// Высота спрайта пиктограммы при использовании коэффициента
				// отношения высоты пиктограммы к высоте светящейся кнопки выхода:
				// произведение высоты светящейся кнопки выхода и коэффициента
				// отношения высоты пиктограммы к высоте светящейся кнопки выхода.				
				parIconSprite.height = this.height          *
					this._IconSideToThisSameSideMaximumRatio;
				// Ширина спрайта пиктограммы при использовании коэффициента
				// отношения высоты пиктограммы к высоте светящейся кнопки выхода:
				// произведение полученной высоты и коэффициента отношения
				// ширины спрайта пиктограммы к высоте.
				parIconSprite.width  = parIconSprite.height *
					iconSpriteWidthToHeightRatio;					
			} // else
			
			// Размещение спрайта пиктограммы по центру светящейся кнопки выхода.
			parIconSprite.x = ( this.width  - parIconSprite.width  ) / 2;
			parIconSprite.y = ( this.height - parIconSprite.height ) / 2;			
		} // AlignIcon
		
		// Метод выравнивания пиктограмм.
		public function AlignIcons( ): void
		{
			// Выравнивание светлой пиктограммы.
			this.AlignIcon( this.LightIconSprite );
			// Выравнивание тёмной пиктограммы.
			this.AlignIcon( this.DarkIconSprite );
		} // AlignIcons	
		//-----------------------------------------------------------------------		
		// Методы-прослушиватели событий.

		// Метод-прослушиватель события изменения размеров компонента.
		// Параметры:
		// parComponentEvent - событие компонента.
		protected function ResizeListener
			( parComponentEvent: ComponentEvent ): void
		{
			// Пиктограммы выравниваются.
			this.AlignIcons( );
		} // ResizeListener
		
		// Метод-прослушиватель события нажатия кнопки мыши.
		// Параметры:
		// parMouseEvent - событие мыши.
		override protected function MouseDownListener
			( parMouseEvent: MouseEvent ): void
		{
			// Вызов метода суперкласса ExitGlowButtonBase.
			super.MouseDownListener( parMouseEvent );	
			
			// Тёмная пиктограмма видна.
			this.DarkIconSprite.visible  = true;
			// Светлая пиктограмма не видна.
			this.LightIconSprite.visible = false;
		} // MouseDownListener	
		
		// Метод-прослушиватель события клика мыши.		
		// Параметры:
		// parMouseEvent - событие мыши.
		override protected function ClickListener
			( parMouseEvent: MouseEvent ): void
		{
			// Вызов метода суперкласса ExitGlowButtonBase.
			super.ClickListener( parMouseEvent );			
			
			// Если светящаяся кнопка - кнопка-переключатель.
			if ( this.toggle )
			{
				// Тёмная пиктограмма видна.
				this.DarkIconSprite.visible  = true;
				// Светлая пиктограмма не видна.
				this.LightIconSprite.visible = false;
			} // if
			// Если светящаяся кнопка - не кнопка-переключатель.
			else
			{
				// Светлая пиктограмма видна.
				this.LightIconSprite.visible = true;	
				// Тёмная пиктограмма не видна.
				this.DarkIconSprite.visible  = false;			
			} // else
		} // ClickListener		
		
		// Метод-прослушиватель события наведения указателя мыши.
		// Параметры:
		// parMouseEvent - событие мыши.
		override protected function RollOverListener
			( parMouseEvent: MouseEvent ): void
		{
			// Вызов метода суперкласса ExitGlowButtonBase.
			super.RollOverListener( parMouseEvent );	
			
			// Если светящаяся кнопка выбрана.
			if ( this.selected )
			{
				// Тёмная пиктограмма видна.
				this.DarkIconSprite.visible  = true;
				// Светлая пиктограмма не видна.
				this.LightIconSprite.visible = false;				
			} // if
			// Если светящаяся кнопка не выбрана.
			else
			{
				// Светлая пиктограмма видна.
				this.LightIconSprite.visible = true;	
				// Тёмная пиктограмма не видна.
				this.DarkIconSprite.visible  = false;				
			} // else	
		} // RollOverListener	
		
		// Метод-прослушиватель события покидания указателем мыши.
		// Параметры:
		// parMouseEvent - событие мыши.
		override protected function RollOutListener
			( parMouseEvent: MouseEvent ): void
		{
			// Вызов метода суперкласса ExitGlowButtonBase.
			super.RollOutListener( parMouseEvent );			
			
			// Если светящаяся кнопка выбрана.
			if ( this.selected )
			{
				// Тёмная пиктограмма видна.
				this.DarkIconSprite.visible  = true;
				// Светлая пиктограмма не видна.
				this.LightIconSprite.visible = false;			
			} // if
			// Если светящаяся кнопка не выбрана.
			else
			{
				// Светлая пиктограмма видна.
				this.LightIconSprite.visible = true;	
				// Тёмная пиктограмма не видна.
				this.DarkIconSprite.visible  = false;		
			} // else
		} // RollOutListener		
		//-----------------------------------------------------------------------
		// Методы-конструкторы.
		
		// Метод-конструктор экземпляра светящейся кнопки выхода.
		// Параметры:
		// parIconSideToThisSameSideMaximumRatio - максимальный коэффициент
		// отношения стороны пиктограммы к соответствующей стороне
		// светящейся кнопки выхода,
		// parParameters                         - параметры светящейся кнопки.		
		public function ExitGlowButton
		(
			parIconSideToThisSameSideMaximumRatio: Number = undefined,
			parParameters:                         GlowButtonParameters = null	
		): void
		{
			// Вызов метода-конструктора суперкласса ExitGlowButtonBase.
			super( );	
			
			// Если максимальный коэффициент отношения стороны пиктограммы
			// к соответствующей стороне светящейся кнопки выхода не определён,
			// то он остаётся по умолчанию, иначе переопределяется.
			if ( ! isNaN( parIconSideToThisSameSideMaximumRatio ) )		
				// Установка  максимального коэффициента отношения
				// стороны пиктограммы к соответствующей стороне
				// светящейся кнопки выхода.
				this._IconSideToThisSameSideMaximumRatio =
					parIconSideToThisSameSideMaximumRatio;
			
			// Если параметры светящейся кнопки указаны и они не являются
			// параметрами по умолчанию, то они устанавливаются,
			// иначе они уже подготовлены как параметры по умолчанию
			// в конструкторе супер-суперкласса GlowButton.
			if ( ( parParameters != null ) &&
					( parParameters != new GlowButtonParameters( ) ))
				// Установка параметров светящейся кнопки.
				this.SetGlowButtonParameters( parParameters );
				
			// Текстовая метка пуста.
			this.label = GlowButton.LABEL_EMPTY_STRING;
			// Пиктограммы выравниваются.
			this.AlignIcons( );
			
			// Светлая пиктограмма видна.
			this.LightIconSprite.visible = true;	
			// Тёмная пиктограмма не видна.
			this.DarkIconSprite.visible  = false;			
				
			// Регистрирация объекта-прослушивателя события
			// изменения размеров компонента.
			this.addEventListener( ComponentEvent.RESIZE, this.ResizeListener );
		} // ExitGlowButton
	} // ExitGlowButton
} // nijanus.display	