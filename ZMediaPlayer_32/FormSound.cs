using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Drawing.Imaging;
using System.Text;
using System.Windows.Forms;

using SkinEngine;
using Win32;
using DrawingPseudo3D;

namespace zap
{
	/// <summary>
	/// Форма звука.
	/// </summary>
	public partial class FormSound : Form
	{
		/// <summary>
		/// Событие изменения значения трека прокрутки звука.
		/// </summary>
		public event EventHandler TrackbarSoundValueChanged;


		#region Fields


		/// <summary>
		/// Имя класса.
		/// </summary>
		private const string CLASS_NAME = "FormSound";
		/// <summary>
		/// Ширина белого бордюра по краю формы -
		/// расстояние от основной части формы до светлой окаймляющей форму линии.
		/// </summary>
		public const int WHITE_BORDER_WIDTH = 6;
		/// <summary>
		/// Максимальное значение непрозрачности.
		/// </summary>
		public const double MAXIMUM_OPACITY = 1;

		/// <summary>
		/// Высота горизонтальной границы вертикального трека прокрутки звука.
		/// </summary>
		private float _TrackbarSoundBorderHeight = 0;
		/// <summary>
		/// Кнопка, вызывающая форму звука.
		/// </summary>
		private Button _ButtonOpen = null;

		/// <summary>
		/// Минимальная высота формы звука.
		/// </summary>
		private int _MinimumHeight = 0;
		/// <summary>
		/// Максимальная высота формы звука.
		/// </summary>
		private int _MaximumHeight = int.MaxValue;

		/// <summary>
		/// Признак активности таймера эффекта изменения видимости формы звука.
		/// </summary>
		private bool _TimerFormVisibleChangingEffectIsActive = false;
		/// <summary>
		/// Признак необходимости последующей активации
		/// таймера эффекта изменения видимости формы звука:
		/// если этот таймер не активен, то после появления или исчезновения
		/// формы звука без эффекта этот таймер активируется и последующие
		/// изменения видимости формы звука происходят уже с эффектом.
		/// </summary>
		private bool _TimerFormVisibleChangingEffectShouldActivate = false;
		/// <summary>
		/// Интервал в миллисекундах таймера эффекта
		/// изменения видимости формы звука.
		/// </summary>
		private int _TimerFormVisibleChangingEffectInterval = 100;
		/// <summary>
		/// Время в миллисекундах длительности эффекта
		/// изменения видимости формы звука -
		/// время, в течение которого осуществляется эффект
		/// появления или исчезновения формы звука.
		/// </summary>
		private int _VisibleChangingEffectTime = 1000;

		/// <summary>
		/// Приращение высоты эффекта изменения видимости формы звука.
		/// </summary>
		private int _VisibleChangingEffectHeightIncrementation = 0;
		/// <summary>
		/// Приращение непрозрачности эффекта изменения видимости формы звука.
		/// </summary>
		private double _VisibleChangingEffectOpacityIncrementation = 0;


		#endregion Fields


		/// <summary>
		/// Создание формы звука.
		/// </summary>
		public FormSound( )
		{
			// Создание нового экземпляра класса.
			Program.MainTracer.CreateClassNewInstance( FormSound.CLASS_NAME );

			InitializeComponent( );

			this._PictureBoxFormImageCopy.Visible = false;

			// Игнорирование сообщения WM_ERASEBKGND: метод OnPaintBackgrouund
			// вызывается непосредстванно из обработчика сообщения WM_PAINT
			// для уменьшения мерцания
			this.SetStyle( ControlStyles.AllPaintingInWmPaint, true );
			// Оптимизированный двойной буфер
			this.SetStyle( ControlStyles.OptimizedDoubleBuffer, true );
			// Перерисовка во время изменения размеров
			this.SetStyle( ControlStyles.ResizeRedraw, true );
			// Поддержка прозрачного цвета фона
			this.SetStyle( ControlStyles.SupportsTransparentBackColor, true );
			// Признак отрисовки компонента собственными средствами, до того,
			// как его отрисовывает операционная система
			this.SetStyle( ControlStyles.UserPaint, true );
		} // FormSound


		#region Methods


		/// <summary>
		/// Прямоугльная рабочая область элемента управления
		/// в координатах прямоугольной рабочей области формы звука.
		/// </summary>
		/// <param name="parControl">Элемент управления.</param>
		/// <returns>Прямоугльная рабочая область элемента управления
		/// в координатах прямоугольной рабочей области формы звука.</returns>
		private Rectangle ControlClientRectangleToThisClientRectangle
			( Control parControl )
		{
			Rectangle rectangle = this.RectangleToClient
				( parControl.RectangleToScreen( parControl.ClientRectangle ) );
			// Ординату почему-то надо пересчитывать, чтобы панель
			// выравнивания формы рисовалась на своём месте.
			rectangle.Y -= this._TableLayoutPanelForm.Location.Y - this.Height +
				this._TableLayoutPanelForm.Height;
			return rectangle;
		} // ControlClientRectangleToThisClientRectangle

		/// <summary>
		/// Сторона элемента управления для растянутого расположения
		/// фонового изображения.
		/// </summary>
		/// <param name="parControlSide">Сторона элемента управления.</param>
		/// <returns>Преобразованная сторона элемента управления
		/// для растянутого расположения фонового изображения.</returns>
		private static int ControlSideForStretchBackgroundImageLayout
			( int parControlSide )
		{
			// Это нужно, чтобы не было тёмных полос снизу или справа,
			// как на треке прокрутке.
			return ( int ) ( 1.2f * parControlSide );
		} // ControlSideForStretchBackgroundImageLayout

		/// <summary>
		/// Отрисовка.
		/// </summary>
		public void Draw( Graphics g )
		{
			SolidBrush myBrush;
			// Фон формы.
			/*SolidBrush myBrush = new SolidBrush( this.BackColor );
			g.FillRectangle( myBrush, this.ClientRectangle );
			myBrush.Dispose( );*/

			#region Панели выравнивания
			/*myBrush = new SolidBrush( this._TableLayoutPanelForm.BackColor );
			g.FillRectangle( myBrush,
				this.ControlClientRectangleToThisClientRectangle
				( this._TableLayoutPanelForm ) );
			myBrush.Dispose( );*/

			myBrush = new SolidBrush( this._TableLayoutPanelTrackbarSound.BackColor );
			g.FillRectangle( myBrush,
				this.ControlClientRectangleToThisClientRectangle
				( this._TableLayoutPanelTrackbarSound ) );
			myBrush.Dispose( );
			#endregion Панели выравнивания

			Bitmap bmp;
			Rectangle srceRect;
			Rectangle destRect;

			#region Окончания трека прокрутки
			bmp = new Bitmap( this._PictureBoxTrackbarSoundUpBorder.
				BackgroundImage );
			srceRect = new Rectangle( 0, 0, bmp.Width, bmp.Height );
			destRect = this.ControlClientRectangleToThisClientRectangle
				( this._PictureBoxTrackbarSoundUpBorder );
			g.DrawImage( bmp, destRect, srceRect, GraphicsUnit.Pixel );
			this._SkinTrackbarSound.DrawPictureBoxProgressLineLeftOrTopEnd
				( g, destRect );
			bmp.Dispose( );

			bmp = new Bitmap( this._PictureBoxTrackbarSoundDownBorder.
				BackgroundImage );
			srceRect = new Rectangle( 0, 0, bmp.Width, bmp.Height );
			destRect = this.ControlClientRectangleToThisClientRectangle
				( this._PictureBoxTrackbarSoundDownBorder );
			g.DrawImage( bmp, destRect, srceRect, GraphicsUnit.Pixel );
			this._SkinTrackbarSound.DrawPictureBoxProgressLineRightOrBottomEnd
				( g, destRect );
			bmp.Dispose( );
			#endregion Окончания трека прокрутки

			#region Бордюры по сторонам
			bmp = new Bitmap( this._PictureBoxUpBorder.BackgroundImage );
			srceRect = new Rectangle( 0, 0, bmp.Width, bmp.Height );
			destRect = this.ControlClientRectangleToThisClientRectangle
				( this._PictureBoxUpBorder );
			destRect.Width = FormSound.ControlSideForStretchBackgroundImageLayout
				( destRect.Width );
			g.DrawImage( bmp, destRect, srceRect, GraphicsUnit.Pixel );
			bmp.Dispose( );

			bmp = new Bitmap( this._PictureBoxDownBorder.BackgroundImage );
			srceRect = new Rectangle( 0, 0, bmp.Width, bmp.Height );
			destRect = this.ControlClientRectangleToThisClientRectangle
				( this._PictureBoxDownBorder );
			destRect.Width = FormSound.ControlSideForStretchBackgroundImageLayout
				( destRect.Width );
			g.DrawImage( bmp, destRect, srceRect, GraphicsUnit.Pixel );
			bmp.Dispose( );

			bmp = new Bitmap( this._PictureBoxLeftBorder.BackgroundImage );
			srceRect = new Rectangle( 0, 0, bmp.Width, bmp.Height );
			destRect = this.ControlClientRectangleToThisClientRectangle
				( this._PictureBoxLeftBorder );
			destRect.Height = FormSound.ControlSideForStretchBackgroundImageLayout
				( destRect.Height );
			g.DrawImage( bmp, destRect, srceRect, GraphicsUnit.Pixel );
			bmp.Dispose( );

			bmp = new Bitmap( this._PictureBoxRightBorder.BackgroundImage );
			srceRect = new Rectangle( 0, 0, bmp.Width, bmp.Height );
			destRect = this.ControlClientRectangleToThisClientRectangle
				( this._PictureBoxRightBorder );
			destRect.Height = FormSound.ControlSideForStretchBackgroundImageLayout
				( destRect.Height );
			g.DrawImage( bmp, destRect, srceRect, GraphicsUnit.Pixel );
			bmp.Dispose( );
			#endregion Бордюры по сторонам

			#region Бордюры по углам
			bmp = new Bitmap( this._PictureBoxLeftUpBorder.BackgroundImage );
			srceRect = new Rectangle( 0, 0, bmp.Width, bmp.Height );
			destRect = this.ControlClientRectangleToThisClientRectangle
				( this._PictureBoxLeftUpBorder );
			g.DrawImage( bmp, destRect, srceRect, GraphicsUnit.Pixel );
			bmp.Dispose( );

			bmp = new Bitmap( this._PictureBoxRightUpBorder.BackgroundImage );
			srceRect = new Rectangle( 0, 0, bmp.Width, bmp.Height );
			destRect = this.ControlClientRectangleToThisClientRectangle
				( this._PictureBoxRightUpBorder );
			g.DrawImage( bmp, destRect, srceRect, GraphicsUnit.Pixel );
			bmp.Dispose( );

			bmp = new Bitmap( this._PictureBoxLeftDownBorder.BackgroundImage );
			srceRect = new Rectangle( 0, 0, bmp.Width, bmp.Height );
			destRect = this.ControlClientRectangleToThisClientRectangle
				( this._PictureBoxLeftDownBorder );
			g.DrawImage( bmp, destRect, srceRect, GraphicsUnit.Pixel );
			bmp.Dispose( );

			bmp = new Bitmap( this._PictureBoxRightDownBorder.BackgroundImage );
			srceRect = new Rectangle( 0, 0, bmp.Width, bmp.Height );
			destRect = this.ControlClientRectangleToThisClientRectangle
				( this._PictureBoxRightDownBorder );
			g.DrawImage( bmp, destRect, srceRect, GraphicsUnit.Pixel );
			bmp.Dispose( );
			#endregion Бордюры по углам

			#region Трек прокрутки звука
			bmp = new Bitmap( this._SkinTrackbarSound.Width,
				this._SkinTrackbarSound.Height );
			Graphics trackbarSoundGraphics = Graphics.FromImage( bmp );

			this._SkinTrackbarSound.Draw( trackbarSoundGraphics );
			// Release graphics
			trackbarSoundGraphics.Dispose( );

			srceRect = new Rectangle( 0, 0, bmp.Width, bmp.Height );
			destRect = this.ControlClientRectangleToThisClientRectangle
				( this._SkinTrackbarSound );
			g.DrawImage( bmp, destRect, srceRect, GraphicsUnit.Pixel );
			bmp.Dispose( );
			#endregion Трек прокрутки звука
		} // Draw

		/// <summary>
		/// Отрисовка копии изображения формы.
		/// </summary>
		private void DrawFormImageCopy( )
		{
			this._PictureBoxFormImageCopy.Parent = this;
			this._PictureBoxFormImageCopy.Location = new Point( 0, 0 );
			this._PictureBoxFormImageCopy.Width = this.Width;
			this._PictureBoxFormImageCopy.Height = this.Height;

			// Начало двойной буферизации.

			// Create a memory bitmap to use as double buffer
			Bitmap offScreenBmp;
			offScreenBmp = new Bitmap( this.Width, this.Height );
			Graphics graphics = Graphics.FromImage( offScreenBmp );

			// Отрисовка всего изображённого на форме.
			this.Draw( graphics );

			// Окончание двойной буферизации.

			// Release graphics
			graphics.Dispose( );

			this._PictureBoxFormImageCopy.BackgroundImage = offScreenBmp;
			this._PictureBoxFormImageCopy.Refresh( );
			this._PictureBoxFormImageCopy.Visible = true;
			this._TableLayoutPanelForm.Visible = false;
		} // DrawFormImageCopy

		/// <summary>
		/// Признак того, что курсор находится вне заданного прямоугольника.
		/// </summary>
		/// <param name="parCursorPosition">Позиция курсора мыши.</param>
		/// <param name="parRectangle">Прямоугольник.</param>
		private static bool CursorIsOutOfRectangle( Point parCursorPosition,
			Rectangle parRectangle )
		{
			// Вызов метода класса.
			Program.MainTracer.CallClassMethod( FormSound.CLASS_NAME,
				"CursorIsOutOfRectangle", parCursorPosition, parRectangle );

			if
			(
				( parCursorPosition.X < parRectangle.Left ) ||
				( parCursorPosition.X > parRectangle.Right ) ||
				( parCursorPosition.Y < parRectangle.Top ) ||
				( parCursorPosition.Y > parRectangle.Bottom )
			)
				return true;
			else
				return false;
		} // CursorIsOutOfRectangle

		/// <summary>
		/// Установка параметров эффекта изменения видимости формы звука.
		/// </summary>
		private void GetVisibleChangingEffectParameters( )
		{
			// Вызов метода класса.
			Program.MainTracer.CallClassMethod( FormSound.CLASS_NAME,
				"GetVisibleChangingEffectParameters" );

			// Количество интервалов запуска таймера эффекта изменения видимости.
			int timerFormVisibleChangingEffectIntervalsCount =
				this._VisibleChangingEffectTime /
				this._TimerFormVisibleChangingEffectInterval;
			// Приращение высоты эффекта изменения видимости формы звука.
			this._VisibleChangingEffectHeightIncrementation = ( int ) Math.Round
				( ( ( float ) ( this._MaximumHeight - this.MinimumHeight ) ) /
				( ( float ) timerFormVisibleChangingEffectIntervalsCount ) );
			// Приращение непрозрачности эффекта изменения видимости формы звука.
			this._VisibleChangingEffectOpacityIncrementation =
				FormSound.MAXIMUM_OPACITY /
				timerFormVisibleChangingEffectIntervalsCount;
		} // GetVisibleChangingEffectParameters

		/// <summary>
		/// Показ формы звука.
		/// </summary>
		/// <param name="parOwner">Владелец.</param>
		new public void Show( IWin32Window parOwner )
		{
			// Вызов метода класса.
			Program.MainTracer.CallClassMethod( FormSound.CLASS_NAME,
				"Show", parOwner );

			// Владелец.
			this.Owner = ( Form ) parOwner;
			// В любом случае таймер эффекта скорытия останавливается.
			this._TimerFormHidingEffect.Enabled = false;

			// Приращения становятся положительными, если таковыми не являются.
			if ( this._VisibleChangingEffectHeightIncrementation < 0 )
				this._VisibleChangingEffectHeightIncrementation *= -1;
			if ( this._VisibleChangingEffectOpacityIncrementation < 0 )
				this._VisibleChangingEffectOpacityIncrementation *= -1;

			// Если таймер эффекта изменения видимости формы звука активен.
			if ( this._TimerFormVisibleChangingEffectIsActive )
			{
				// Если форма звука не видима.
				if ( ! this.Visible )
				{
					this.GetVisibleChangingEffectParameters( );

					this.Opacity = 0;
					this.VisibleHeight = this.MinimumHeight;
					// Форма стновится видимой.
					this.Visible = true;
				} // if

				// Если эффект появления ещё не происходит и он нужен,
				// то он начинается.
				if ( ( this.VisibleHeight < this.MaximumHeight ) &&
					( ! this._TimerFormShowingEffect.Enabled ) )
				{
					this.DrawFormImageCopy( );
					this._TimerFormShowingEffect.Enabled = true;
				} // if
			} // if
			else
			{
				this._VisibleChangingEffectHeightIncrementation = 0;
				this._VisibleChangingEffectOpacityIncrementation = 0;

				this._TableLayoutPanelForm.Visible = true;
				this._PictureBoxFormImageCopy.Visible = false;

				// Таймер эффекта показа останавливается
				// и устанавливаются максимальные значения параметров.
				this._TimerFormShowingEffect.Enabled = false;
				/*this.Opacity = FormSound.MAXIMUM_OPACITY;*/
				this.VisibleHeight = this.MaximumHeight;
				// Если следует активировать таймер эффекта изменения видимости
				// формы звука для последующих её появлений и исчезновений,
				// то он активируется.
				if ( this._TimerFormVisibleChangingEffectShouldActivate )
					this._TimerFormVisibleChangingEffectIsActive = true;
				// Форма стновится видимой.
				this.Visible = true;
			} // else
		} // Show

		/// <summary>
		/// Показ формы звука.
		/// </summary>
		new public void Show( )
		{
			// Вызов метода класса.
			Program.MainTracer.CallClassMethod( FormSound.CLASS_NAME, "Show" );

			this.Show( null );
		} // Show

		/// <summary>
		/// Сокрытие формы звука.
		/// </summary>
		new public void Hide( )
		{
			// Вызов метода класса.
			Program.MainTracer.CallClassMethod( FormSound.CLASS_NAME, "Hide" );

			// Если форма уже сокрыта, то её не надо скрывать.
			if ( ! this.Visible )
				return;

			// В любом случае таймер эффекта показа останавливается.
			this._TimerFormShowingEffect.Enabled = false;

			// Приращения становятся отрицательными, если таковыми не являются.
			if ( this._VisibleChangingEffectHeightIncrementation > 0 )
				this._VisibleChangingEffectHeightIncrementation *= -1;
			if ( this._VisibleChangingEffectOpacityIncrementation > 0 )
				this._VisibleChangingEffectOpacityIncrementation *= -1;

			// Если таймер эффекта изменения видимости формы звука активен.
			if ( this._TimerFormVisibleChangingEffectIsActive )
			{
				// Если эффект исчезновения ещё не происходит и он нужен,
				// то он начинается.
				if ( ( this.VisibleHeight > this.MinimumHeight ) &&
					( ! this._TimerFormHidingEffect.Enabled ) )
				{
					this.GetVisibleChangingEffectParameters( );
					this._VisibleChangingEffectHeightIncrementation *= -1;
					this._VisibleChangingEffectOpacityIncrementation *= -1;

					this.Opacity = FormSound.MAXIMUM_OPACITY;
					this.VisibleHeight = this.MaximumHeight;

					this.DrawFormImageCopy( );
					this._TimerFormHidingEffect.Enabled = true;
					// Форма пока всё ещё видима.
					this.Visible = true;
				} // if
			} // if
			else
			{
				this._VisibleChangingEffectHeightIncrementation = 0;
				this._VisibleChangingEffectOpacityIncrementation = 0;

				this._TableLayoutPanelForm.Visible = true;
				this._PictureBoxFormImageCopy.Visible = false;

				// Таймер эффекта сокрытия останавливается
				// и устанавливаются минимальные значения параметров.
				this._TimerFormHidingEffect.Enabled = false;
				/*this.Opacity = 0;
				this.VisibleHeight = this.MinimumHeight;*/
				// Если следует активировать таймер эффекта изменения видимости
				// формы звука для последующих её появлений и исчезновений,
				// то он активируется.
				if ( this._TimerFormVisibleChangingEffectShouldActivate )
					this._TimerFormVisibleChangingEffectIsActive = true;
				// Форма становится невидимой.
				this.Visible = false;
			} // else
		} // Hide


		#region Events Handlers


		/// <summary>
		/// Изменение значения трека прокрутки звука.
		/// </summary>
		/// <param name="sender">Источник.</param>
		/// <param name="e">Аргументы.</param>
		private void OnSkinTrackbarSoundValueChanged
			( object parSender, EventArgs parEventArgs )
		{
			// Вызов метода-обработчика события класса.
			Program.MainTracer.CallClassEventHandler( FormSound.CLASS_NAME,
				"OnSkinTrackbarSoundValueChanged", parSender, parEventArgs );

			// Передача события изменения значения трека прокрутки звука.
			this.TrackbarSoundValueChanged( parSender, parEventArgs );
		} // OnSkinTrackbarSoundValueChanged

		/// <summary>
		/// Появление формы - препятствие её исчезновения
		/// в случае применения его эффекта - при наведении курсора на объект.
		/// </summary>
		/// <param name="sender">Источник.</param>
		/// <param name="e">Аргументы.</param>
		private void OnMouseEnter( object parSender, EventArgs parEventArgs )
		{
			// Вызов метода-обработчика события класса.
			Program.MainTracer.CallClassEventHandler( FormSound.CLASS_NAME,
				"OnMouseEnter", parSender, parEventArgs );

			this.Show( this.Owner );
		} // OnMouseEnter

		/// <summary>
		/// Возможное сокрытие формы звука при покидании объекта курсором.
		/// </summary>
		/// <param name="sender">Источник.</param>
		/// <param name="e">Аргументы.</param>
		private void OnMouseLeave( object parSender, EventArgs parEventArgs )
		{
			// Вызов метода-обработчика события класса.
			Program.MainTracer.CallClassEventHandler( FormSound.CLASS_NAME,
				"OnMouseLeave", parSender, parEventArgs );

			if ( ( this._TimerFormVisibleChangingEffectIsActive ) &&
				 ( this.Visible ) )
				this._TimerFormHiding.Enabled = true;
		} // OnMouseLeave

		/// <summary>
		/// Наступление момента времени возможного сокрытия формы звука.
		/// </summary>
		/// <param name="sender">Источник.</param>
		/// <param name="e">Аргументы.</param>
		private void OnTimerFormHidingTick
			( object parSender, EventArgs parEventArgs )
		{
			// Вызов метода-обработчика события класса.
			Program.MainTracer.CallClassEventHandler( FormSound.CLASS_NAME,
				"OnTimerFormHidingTick", parSender, parEventArgs );

			// Позиция курсора.
			Point cursorPosition = Cursor.Position;

			// Если курсор находится вне формы звука.
			if ( FormSound.CursorIsOutOfRectangle( cursorPosition,
				this.RectangleToScreen( this._TableLayoutPanelForm.
				ClientRectangle ) ) )
			{
				// Если определена кнопка вызова.
				if ( this._ButtonOpen != null )
				{
					// Если курсор находится вне кнопки вызова.
					if ( FormSound.CursorIsOutOfRectangle( cursorPosition,
							this._ButtonOpen.RectangleToScreen
							( this._TableLayoutPanelForm.ClientRectangle ) ) )
						this.Hide( );
				} // if
				else
					this.Hide( );
			} // if

			this._TimerFormHiding.Enabled = false;
		} // OnTimerFormHidingTick

		/// <summary>
		/// Достичежние таймером эффекта появления формы
		/// очередного интервала времени.
		/// </summary>
		/// <param name="sender">Источник.</param>
		/// <param name="e">Аргументы.</param>
		private void OnTimerFormShowingEffectTick
			( object parSender, EventArgs parEventArgs )
		{
			// Вызов метода-обработчика события класса.
			Program.MainTracer.CallClassEventHandler( FormSound.CLASS_NAME,
				"OnTimerFormShowingEffectTick", parSender, parEventArgs );

			if ( ! this._TimerFormVisibleChangingEffectIsActive )
			{
				this._TimerFormShowingEffect.Enabled = false;
				return;
			} // if

			// Прежняя высота.
			int oldHeight = this.VisibleHeight;
			// Инкремент параметров эффекта появления.
			double opacity = this.Opacity +
				this._VisibleChangingEffectOpacityIncrementation;
			int height = this.VisibleHeight +
				this._VisibleChangingEffectHeightIncrementation;

			// Если прозрачность или высота достигла максимального значения,
			// то устанавливаются максимальные параметры
			// и эффект появления формы завершается.
			if ( ( opacity >= FormSound.MAXIMUM_OPACITY ) ||
				( height >= this.MaximumHeight ) )
			{
				this.Opacity = FormSound.MAXIMUM_OPACITY;
				this.VisibleHeight = this.MaximumHeight;
				this.DrawFormImageCopy( );

				this._TableLayoutPanelForm.Visible = true;
				this._PictureBoxFormImageCopy.Visible = false;
				this._TimerFormShowingEffect.Enabled = false;
			} // if
			else
			{
				this.Opacity = opacity;
				this.VisibleHeight = height;
				this.DrawFormImageCopy( );
			} // else
/*
			// Новая орината смещается на приращение высота.
			this.Location = new Point( this.Location.X,
				this.Location.Y - this.Height + oldHeight );
*/
		} // OnTimerFormShowingEffectTick

		/// <summary>
		/// Достичежние таймером эффекта исчезновения формы
		/// очередного интервала времени.
		/// </summary>
		/// <param name="sender">Источник.</param>
		/// <param name="e">Аргументы.</param>
		private void OnTimerFormHidingEffectTick
			( object parSender, EventArgs parEventArgs )
		{
			// Вызов метода-обработчика события класса.
			Program.MainTracer.CallClassEventHandler( FormSound.CLASS_NAME,
				"OnTimerFormHidingEffectTick", parSender, parEventArgs );

			if ( ! this._TimerFormVisibleChangingEffectIsActive )
			{
				this._TimerFormHidingEffect.Enabled = false;
				return;
			} // if

			// Прежняя высота.
			int oldHeight = this.VisibleHeight;
			// Декремент параметров эффекта появления.
			double opacity = this.Opacity +
				this._VisibleChangingEffectOpacityIncrementation;
			int height = this.VisibleHeight +
				this._VisibleChangingEffectHeightIncrementation;

			// Если прозрачность или высота достигла минимального значения,
			// то устанавливаются минимальные параметры,
			// форма наконец становится невидимой
			// и эффект исчезновения формы завершается.
			if ( ( opacity <= 0 ) || ( height <= this.MinimumHeight ) )
			{
				this.Opacity = 0;
				this.VisibleHeight = this.MinimumHeight;
				this.DrawFormImageCopy( );

				this._TableLayoutPanelForm.Visible = true;
				this._PictureBoxFormImageCopy.Visible = false;
				this.Visible = false;
				this._TimerFormHidingEffect.Enabled = false;
			} // if
			else
			{
				this.Opacity = opacity;
				this.VisibleHeight = height;
				this.DrawFormImageCopy( );
			} // else
/*
			// Новая орината смещается на приращение высота.
			this.Location = new Point( this.Location.X,
				this.Location.Y - this.Height + oldHeight );
*/
		} // OnTimerFormHidingEffectTick


		#endregion Events Handlers


		#endregion Methods


		#region Properties


		/// <summary>
		/// Минимальная высота формы звука.
		/// </summary>
		public int MinimumHeight
		{
			get
			{
				return this._MinimumHeight;
			} // get
			set
			{
				if ( value < 0 )
					this._MinimumHeight = 0;
				else
					if ( value > this._MaximumHeight )
						this._MinimumHeight = this._MaximumHeight;
					else
						this._MinimumHeight = value;
			} // set
		} // MinimumHeight

		/// <summary>
		/// Максимальная высота формы звука.
		/// </summary>
		public int MaximumHeight
		{
			get
			{
				return this._MaximumHeight;
			} // get
			set
			{
				if ( value < this._MinimumHeight )
					this._MaximumHeight = this._MinimumHeight;
				else
					this._MaximumHeight = value;
			} // set
		} // MaximumHeight

		/// <summary>
		/// Видимая высота формы звука - высота видимой панели
		/// выравнивания невидимой формы звука, занимающей всю нижнюю её часть.
		/// </summary>
		public int VisibleHeight
		{
			get
			{
				return this._TableLayoutPanelForm.Height;
			} // get
			set
			{
				if ( value < 0 )
					this._TableLayoutPanelForm.Height = 0;
				else
					if ( value > this.Height )
						this._TableLayoutPanelForm.Height = this.Height;
					else
						this._TableLayoutPanelForm.Height = value;
			} // set
		} // VisibleHeight

		/// <summary>
		/// Ширина трека прокрутки звука.
		/// </summary>
		public int TrackbarSoundWidth
		{
			get
			{
				return ( int )
					this._TableLayoutPanelTrackbarSound.ColumnStyles[ 1 ].Width;
			} // get
			set
			{
				if ( value < 0 )
					this._TableLayoutPanelTrackbarSound.ColumnStyles[ 1 ].Width = 0;
				else
					this._TableLayoutPanelTrackbarSound.ColumnStyles[ 1 ].Width = value;
			} // set
		} // TrackbarSoundWidth

		/// <summary>
		/// Высота горизонтальной границы вертикального трека прокрутки звука.
		/// </summary>
		public float TrackbarSoundBorderHeight
		{
			get
			{
				return this._TrackbarSoundBorderHeight;
			} // get
			set
			{
				if ( value < 0 )
					this._TrackbarSoundBorderHeight = 0;
				else
					this._TrackbarSoundBorderHeight = value;

				this._TableLayoutPanelTrackbarSound.RowStyles[ 0 ].Height =
					this._TrackbarSoundBorderHeight;
				this._TableLayoutPanelTrackbarSound.RowStyles[ 2 ].Height =
					this._TrackbarSoundBorderHeight;
			} // set
		} // TrackbarSoundBorderHeight

		/// <summary>
		/// Ширина бегунка трека прокрутки звука.
		/// </summary>
		public int TrackbarSoundThumbWidth
		{
			get
			{
				return this._SkinTrackbarSound.ThumbWidth;
			} // get
			set
			{
				this._SkinTrackbarSound.ThumbWidth = value;
			} // set
		} // TrackbarSoundThumbWidth

		/// <summary>
		/// Высота бегунка трека прокрутки звука.
		/// </summary>
		public int TrackbarSoundThumbHeight
		{
			get
			{
				return this._SkinTrackbarSound.ThumbHeight;
			} // get
			set
			{
				this._SkinTrackbarSound.ThumbHeight = value;
			} // set
		} // TrackbarSoundThumbHeight

		/// <summary>
		/// Значение полосы прокрутки звука.
		/// </summary>
		public double TrackbarSoundValue
		{
			get
			{
				return this._SkinTrackbarSound.Value;
			} // get
			set
			{
				this._SkinTrackbarSound.Value = value;
			} // set
		} // TrackbarSoundValue

		/// <summary>
		/// Кнопка, вызывающая форму звука.
		/// </summary>
		public Button ButtonOpen
		{
			get
			{
				return this._ButtonOpen;
			} // get
			set
			{
				if ( this._ButtonOpen != null )
					try
					{
						this._ButtonOpen.MouseLeave -= this.OnMouseLeave;
					}
					catch
					{
					}

				this._ButtonOpen = value;

				if ( this._ButtonOpen != null )
					try
					{
						this._ButtonOpen.MouseLeave += this.OnMouseLeave;
					}
					catch
					{
					}
			} // set
		} // ButtonOpen

		/// <summary>
		/// Интервал в миллисекундах таймера сокрытия формы звука -
		/// интервал между моментом покидания кнопки вызова
		/// или формы звука курсором мыши и моментом сокрытия формы звука.
		/// </summary>
		public int TimerFormHidingInterval
		{
			get
			{
				return this._TimerFormHiding.Interval;
			} // get
			set
			{
				this._TimerFormHiding.Interval = value;
			} // set
		} // TimerFormHidingInterval

		/// <summary>
		/// Признак активности таймера эффекта изменения видимости формы звука.
		/// </summary>
		public bool TimerFormVisibleChangingEffectIsActive
		{
			get
			{
				return this._TimerFormVisibleChangingEffectIsActive;
			} // get
			set
			{
				this._TimerFormVisibleChangingEffectIsActive = value;
			} // set
		} // TimerFormVisibleChangingEffectIsActive

		/// <summary>
		/// Признак необходимости последующей активации
		/// таймера эффекта изменения видимости формы звука:
		/// если этот таймер не активен, то после появления или исчезновения
		/// формы звука без эффекта этот таймер активируется и последующие
		/// изменения видимости формы звука происходят уже с эффектом.
		/// </summary>
		public bool TimerFormVisibleChangingEffectShouldActivate
		{
			get
			{
				return this._TimerFormVisibleChangingEffectShouldActivate;
			} // get
			set
			{
				this._TimerFormVisibleChangingEffectShouldActivate = value;
			} // set
		} // TimerFormVisibleChangingEffectShouldActivate

		/// <summary>
		/// Интервал в миллисекундах таймера эффекта
		/// изменения видимости формы звука.
		/// </summary>
		public int TimerFormVisibleChangingEffectInterval
		{
			get
			{
				return this._TimerFormVisibleChangingEffectInterval;
			} // get
			set
			{
				if ( value > this._VisibleChangingEffectTime )
					this._TimerFormVisibleChangingEffectInterval =
						this._VisibleChangingEffectTime;
				else
					this._TimerFormVisibleChangingEffectInterval = value;

				this._TimerFormShowingEffect.Interval =
					this._TimerFormVisibleChangingEffectInterval;
				this._TimerFormHidingEffect.Interval =
					this._TimerFormVisibleChangingEffectInterval;
			} // set
		} // TimerFormVisibleChangingEffectInterval

		/// <summary>
		/// Время в миллисекундах длительности эффекта
		/// изменения видимости формы звука -
		/// время, в течение которого осуществляется эффект
		/// появления или исчезновения формы звука.
		/// </summary>
		public int VisibleChangingEffectTime
		{
			get
			{
				return this._VisibleChangingEffectTime;
			} // get
			set
			{
				if ( value < this._TimerFormVisibleChangingEffectInterval )
					this._VisibleChangingEffectTime =
						this._TimerFormVisibleChangingEffectInterval;
				else
					this._VisibleChangingEffectTime = value;
			} // set
		} // VisibleChangingEffectTime

		/// <summary>
		/// Приращение высоты эффекта изменения видимости формы звука.
		/// </summary>
		private int VisibleChangingEffectHeightIncrementation
		{
			get
			{
				return this._VisibleChangingEffectHeightIncrementation;
			} // get
		} // VisibleChangingEffectHeightIncrementation

		/// <summary>
		/// Приращение непрозрачности эффекта изменения видимости формы звука.
		/// </summary>
		private double VisibleChangingEffectOpacityIncrementation
		{
			get
			{
				return this._VisibleChangingEffectOpacityIncrementation;
			} // get
		} // VisibleChangingEffectOpacityIncrementation


		#endregion Properties


	} // FormSound
} // zap