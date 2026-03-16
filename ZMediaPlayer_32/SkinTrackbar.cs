//+--------------------------------------------------------------------------+
//|                                                                          |
//|                            VISTA_Track class                             |
//|                                                                          |
//+--------------------------------------------------------------------------+
//|                                                                          |
//|                         Author Patrice TERRIER                           |
//|                           copyright (c) 2006                             |
//|                                                                          |
//|                        pterrier@zapsolution.com                          |
//|                                                                          |
//|                          www.zapsolution.com                             |
//|                                                                          |
//+--------------------------------------------------------------------------+
//|   Started on : 10-17-2006 (MM-DD-YYYY)                                   |
//| Last revised : 12-15-2006 (MM-DD-YYYY)                                   |
//+--------------------------------------------------------------------------+

//---------------------------------------------------------------------------
// CustomerDesktop
// Co-author Kate Kotova
// NIJANUS Copyright © 2004-2010
// nijanus@ymail.com
// http://nijanus.narod2.ru
//---------------------------------------------------------------------------

using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Data;
using System.Text;
using System.Windows.Forms;

using System.Drawing.Imaging;
using System.Drawing.Drawing2D;

using Win32;
//using SkinEngine;

using DrawingPseudo3D;

namespace zap
{
	public partial class SkinTrackbar : UserControl
	{
		[Category( "Action" ), Description( "Occurs when the slider is moved" )]
		public event EventHandler ValueChanged;


		#region Fields


		// Цвета линии прогресса.

		/// <summary>
		/// Светлый цвет левой или верхней стороны линии прогресса.
		/// </summary>
		private readonly Color ProgressLineLeftOrTopLightColor =
			Color.FromArgb( 95, 175, 180 );
		/// <summary>
		/// Тёмный цвет левой или верхней стороны линии прогресса.
		/// </summary>
		private readonly Color ProgressLineLeftOrTopDarkColor =
			Color.FromArgb( 55, 69, 74 );
		/// <summary>
		/// Светлый цвет середины линии прогресса.
		/// </summary>
		private readonly Color ProgressLineMiddleLightColor =
			Color.FromArgb( 21, 112, 151 );

		/// <summary>
		/// Тёмный цвет середины линии прогресса.
		/// </summary>
		private readonly Color ProgressLineMiddleDarkColor =
			Color.FromArgb( 28, 34, 36 );
		/// <summary>
		/// Светлый цвет правой или нижней стороны линии прогресса.
		/// </summary>
		private readonly Color ProgressLineRightOrBottomLightColor =
			Color.FromArgb( 98, 175, 208 );
		/// <summary>
		/// Тёмный цвет правой или нижней стороны линии прогресса.
		/// </summary>
		private readonly Color ProgressLineRightOrBottomDarkColor =
			Color.FromArgb( 87, 104, 111 );

		private const bool VERTICAL = false;
		private const bool HORIZONTAL = true;

		/// <summary>
		/// Минимальная ширины бегунка прокрутки.
		/// </summary>
		private const int THUMB_MINIMUM_WIDTH = 15;
		/// <summary>
		/// Минимальная высота бегунка прокрутки.
		/// </summary>
		private const int THUMB_MINIMUM_HEIGHT = 15;

		// Доля ширины полосы компонента цвета линии прогресса
		// от ширины меньшей стороны трека прорутки -
		// вертикальной - для горизонтально ориентированной
		// или горизонтальной - для вертикально ориентированной.
		private const float
			PROGRESS_BAR_COLOR_COMPONENT_LINE_WIDTH_TO_THIS_SHORT_SIDE_RATIO = 6f / 96f;
		// Ширина полосы компонента цвета линии прогресса.
		private int _ProgressBarColorComponentLineWidth = 1;

		private double _Value = 50;
		private double _Minimum = 0;
		private double _Maximum = 100;

		private bool _ThumbMoving = false;
		private static int _WasValue = 0;

		/// <summary>
		///.Цвет прозрачности бегунка прокрутки.
		/// </summary>
		private Color _ThumbTransparencyKey = Color.FromArgb( 255, 0, 255 );

		/// <summary>
		/// Картинка левой или верхней границы горизонтального трека прокрутки.
		/// </summary>
		private PictureBox _PictureBoxLeftOrTopBorder;
		/// <summary>
		/// Картинка правой или нижней границы горизонтального трека прокрутки.
		/// </summary>
		private PictureBox _PictureBoxRightOrBottomBorder;


		#endregion Fields


		public SkinTrackbar( )
		{
			InitializeComponent( );
		} // SkinTrackbar


		#region Methods


		/// <summary>
		/// Получение прямоугольника ( квадрата ), описывающего круг
		/// ( внешнего квадрата, вмещающего в себя круг )
		/// </summary>
		/// <param name="parCenterX">Абсцисса центра</param>
		/// <param name="parCenterY">Ордината центра</param>
		/// <param name="parRadius">Радиус</param>
		/// <returns>Внешний прямогольник круга</returns>
		private static RectangleF СircleExternalRectangleF
		(
			float parCenterX,
			float parCenterY,
			float parRadius
		)
		{
			// Замена нулевого размера единичным
			if ( parRadius == 0 )
				parRadius = 1;
			return new RectangleF
				( parCenterX - parRadius, parCenterY - parRadius,
					2          * parRadius, 2          * parRadius );
		} // ССircleExternalRectangleF

		/// <summary>
		/// Отрисовка окончания линии прогресса.
		/// </summary>
		/// <param name="parGraphics">Объект поверхности рисования GDI+.</param>
		/// <param name="parLeftOrTopColor">Цвет левой или верхней
		/// стороны линии прогресса.</param>
		/// <param name="parRightOrBottomColor">Цвет правой или нижней
		/// стороны линии прогресса.</param>
		/// <param name="parMiddleColor">Цвет середины линии прогресса.</param>
		/// <param name="parEndCentreX">Абсцисса центра скругления
		/// окончания линии прогресса.</param>
		/// <param name="parEndCentreY">Ордината центра скругления
		/// окончания линии прогресса.</param>
		/// <param name="parStartAngle">Начальный угол (в градусах),
		/// который измеряется по часовой стрелке, начиная от оси X
		/// и заканчивая начальной точкой дуги.</param>
		/// <param name="parSweepAngle">Угол поворота (в градусах),
		/// который измеряется по часовой стрелке, начиная от значения
		/// начального угла и заканчивая конечной точкой дуги.</param>
		private void DrawProgressLineEnd
		(
			Graphics parGraphics,
			Color parLeftOrTopColor,
			Color parRightOrBottomColor,
			Color parMiddleColor,
			float parEndCentreX,
			float parEndCentreY,
			int parStartAngle,
			int parSweepAngle
		)
		{
			// Установка высшего качества вывода объектов,
			// которые будут рисоваться "вручную".
			parGraphics.SmoothingMode = SmoothingMode.HighQuality;

			// Настройка пера левой или верхней стороны линии прогресса.
			Pen leftOrTopPen = new Pen( parLeftOrTopColor );
			// Стиль использования пунктирных линий - сплошная линия.
			leftOrTopPen.DashStyle = DashStyle.Solid;
			// Ширина пера.
			leftOrTopPen.Width = 2;

			// Настройка пера правой или нижней стороны линии прогресса.
			Pen rightOrBottomPen = new Pen( parRightOrBottomColor );
			// Стиль использования пунктирных линий - сплошная линия.
			rightOrBottomPen.DashStyle = DashStyle.Solid;
			// Ширина пера.
			rightOrBottomPen.Width = 2;

			// Цвет периферии середины линии прогресса -
			// средее арифметическое цветов левой или верхней
			// и правой или нижней сторон линии прогресса.
			Color peripheryMiddleColor = ( Color )
				( ( ( ( ColorIncrementation ) parLeftOrTopColor ) / 2 ) +
				( ( ( ColorIncrementation ) parRightOrBottomColor ) / 2 ) );

			// Настройка пера периферии середины линии прогресса.
			Pen peripheryMiddlePen = new Pen( peripheryMiddleColor );
			// Стиль использования пунктирных линий - сплошная линия.
			peripheryMiddlePen.DashStyle = DashStyle.Solid;
			// Ширина пера.
			peripheryMiddlePen.Width = 2;

			// Половина ширины полосы компонента цвета линии прогресса.
			int colorWidthHalf = ( int ) Math.Round
				( ( ( float ) this._ProgressBarColorComponentLineWidth ) / 2f );
			// Количество оттенков от периферии окончания линии прогресса до центра.
			int peripheryTonesNumber = this._ProgressBarColorComponentLineWidth - 1;

			// Приращение цвета левой или верхней стороны линии прогресса.
			ColorIncrementation leftOrTopColorIncrementation =
				ColorIncrementation.ColorsDifference
				( parMiddleColor, parLeftOrTopColor ) / peripheryTonesNumber;
			// Приращение цвета правой или нижней стороны линии прогресса.
			ColorIncrementation rightOrBottomColorIncrementation =
				ColorIncrementation.ColorsDifference
				( parMiddleColor, parRightOrBottomColor ) / peripheryTonesNumber;
			// Приращение цвета периферии середины линии прогресса.
			ColorIncrementation peripheryMiddleColorIncrementation =
				ColorIncrementation.ColorsDifference
				( parMiddleColor, peripheryMiddleColor ) / peripheryTonesNumber;

			// Радиус скругления окончания линии прогресса.
			int radius = this._ProgressBarColorComponentLineWidth +
				colorWidthHalf - 2;
			// Радиус середины скругления окончания линии прогресса.
			int middleRadius = colorWidthHalf - 1;

			// Угол поворота области комонента цвета линии прогресса (в градусах),
			// который измеряется по часовой стрелке, начиная от значения
			// начального угла и заканчивая конечной точкой дуги.
			int colorComponentSweepAngle = parSweepAngle / 3;
			// Начальный угол правой или нижней области линии прогресса.
			int rightOrBottomStartAngle = parStartAngle;
			// Начальный угол периферии средней области линии прогресса.
			int peripheryMiddleStartAngle = rightOrBottomStartAngle +
				colorComponentSweepAngle;
			// Начальный угол левой или верхней области линии прогресса.
			int leftOrTopStartAngle = peripheryMiddleStartAngle +
				colorComponentSweepAngle;

			// Прорисовка дуг области периферии окончания линии прогресса
			// от окружности с внешним радиусом до окружности середины.
			for ( int currentRadius = radius; currentRadius >= middleRadius;
				currentRadius-- )
			{
				// Прямоугольник текущей окружности.
				RectangleF currentCircleRectangleF =
					SkinTrackbar.СircleExternalRectangleF
					( parEndCentreX, parEndCentreY, currentRadius );

				// Изображение дуги правой или нижней части окончания линии прогресса.
				parGraphics.DrawArc( rightOrBottomPen, currentCircleRectangleF,
					rightOrBottomStartAngle, colorComponentSweepAngle );
				// Изображение дуги периферии средней части окончания линии прогресса.
				parGraphics.DrawArc( peripheryMiddlePen, currentCircleRectangleF,
					peripheryMiddleStartAngle, colorComponentSweepAngle );
				// Изображение дуги левой или верхней части окончания линии прогресса.
				parGraphics.DrawArc( leftOrTopPen, currentCircleRectangleF,
					leftOrTopStartAngle, colorComponentSweepAngle );

				// Цвет пера левой или верхней стороны линии прогресса.
				leftOrTopPen.Color = leftOrTopPen.Color +
					leftOrTopColorIncrementation;
				// Цвет пера правой или нижней стороны линии прогресса.
				rightOrBottomPen.Color = rightOrBottomPen.Color +
					rightOrBottomColorIncrementation;
				// Цвет пера периферии середины линии прогресса.
				peripheryMiddlePen.Color = peripheryMiddlePen.Color +
					peripheryMiddleColorIncrementation;
			} // for

			// Прямоугольник окружности середины скругления окончания линии прогресса.
			RectangleF middleCircleRectangleF = SkinTrackbar.СircleExternalRectangleF
				( parEndCentreX, parEndCentreY, middleRadius + 1 );
			// Изображение полукруга.середины скругления окончания линии прогресса.
			parGraphics.FillPie( new SolidBrush( parMiddleColor ),
				middleCircleRectangleF.X, middleCircleRectangleF.Y,
				middleCircleRectangleF.Width, middleCircleRectangleF.Height,
				parStartAngle, parSweepAngle );
		} // DrawProgressLineEnd

		/// <summary>
		/// Отрисовка окончания линии прогресса.
		/// </summary>
		/// <param name="parGraphics">Объект поверхности рисования GDI+.</param>
		/// <param name="parPaletteBrightness">Яркость палитры
		/// линии прогресса.</param>
		/// <param name="parControlClientRectangle">Прямоугольник
		/// клиентской области элемента управления.</param>
		/// <param name="parEndType">Тип окончания линии прогресса.</param>
		private void DrawProgressLineEnd
		(
			Graphics parGraphics,
			SkinTrackbarProgressLinePaletteBrightness parPaletteBrightness,
			Rectangle parControlClientRectangle,
			SkinTrackbarProgressLineEndType parEndType
		)
		{
			// Цвет левой или верхней стороны линии прогресса.
			Color leftOrTopColor;
			// Цвет правой или нижней стороны линии прогресса.
			Color rightOrBottomColor;
			// Цвет середины линии прогресса.
			Color middleColor;

			// Если яркость палитры линии прогресса светлая,
			// то устанавливаются светлые цвета, иначе - тёмные.
			if ( parPaletteBrightness ==
				SkinTrackbarProgressLinePaletteBrightness.LIGHT )
			{
				leftOrTopColor = this.ProgressLineLeftOrTopLightColor;
				rightOrBottomColor = this.ProgressLineRightOrBottomLightColor;
				middleColor = this.ProgressLineMiddleLightColor;
			} // if
			else
			{
				leftOrTopColor = this.ProgressLineLeftOrTopDarkColor;
				rightOrBottomColor = this.ProgressLineRightOrBottomDarkColor;
				middleColor = this.ProgressLineMiddleDarkColor;
			} // else

			// Абсцисса центра скругления окончания линии прогресса.
			float endCentreX;
			// Ордината центра скругления окончания линии прогресса.
			float endCentreY;
			// Начальный угол (в градусах), который измеряется по часовой стрелке,
			// начиная от оси X и заканчивая начальной точкой дуги.
			int startAngle;

			// Если окончание линии прогресса левое или правое.
			if ( ( parEndType == SkinTrackbarProgressLineEndType.LEFT ) ||
				( parEndType == SkinTrackbarProgressLineEndType.RIGHT ) )
			{
				endCentreY = parControlClientRectangle.Height / 2 - 0.2f +
					parControlClientRectangle.Y;
				startAngle = 90;

				// Если окончание линии прогресса левое.
				if ( parEndType == SkinTrackbarProgressLineEndType.LEFT )
					endCentreX = parControlClientRectangle.Width +
					parControlClientRectangle.X;
				// Если окончание линии прогресса правое.
				else
					endCentreX = -1 + parControlClientRectangle.X;
			} // if

			// Если окончание линии прогресса верхнее или нижнее.
			else
			{
				endCentreX = parControlClientRectangle.Width / 2 - 0.2f +
					parControlClientRectangle.X;
				startAngle = 0;

				// Если окончание линии прогресса верхнее.
				if ( parEndType == SkinTrackbarProgressLineEndType.TOP )
					endCentreY = parControlClientRectangle.Height +
					parControlClientRectangle.Y;
				// Если окончание линии прогресса нижнее.
				else
					endCentreY = -1 + parControlClientRectangle.Y;
			} // else

			// Угол поворота (в градусах), который измеряется по часовой стрелке,
			// начиная от значения начального угла
			// и заканчивая конечной точкой дуги.
			int sweepAngle;

			// Если окончание линии прогресса левое или нижнее.
			if ( ( parEndType == SkinTrackbarProgressLineEndType.LEFT ) ||
				( parEndType == SkinTrackbarProgressLineEndType.BOTTOM ) )
				sweepAngle = 180;
			// Если окончание линии прогресса правое или верхнее.
			else
				sweepAngle = -180;

			// Отрисовка окончания линии прогресса.
			this.DrawProgressLineEnd
			(
				parGraphics,
				leftOrTopColor,
				rightOrBottomColor,
				middleColor,
				endCentreX,
				endCentreY,
				startAngle,
				sweepAngle
			); // DrawProgressLineEnd
		} // DrawProgressLineEnd

		private void SendNotification( )
		{
			if ( ValueChanged != null )
			{
				ValueChanged( this, new EventArgs( ) );
			}
			else
			{
				Api.SendMessage( Api.GetForegroundWindow( ), Api.WM_COMMAND,
					( uint ) this.Handle, ( int ) this.Handle );
			}
		} // SendNotification

		/// <summary>
		/// Отрисовка.
		/// </summary>
		public void Draw( Graphics g )
		{
			Bitmap bmp;
			Rectangle srceRect;
			Rectangle destRect;

			if ( this.BackgroundImage != null )
			{
				if ( Orientation( ) == HORIZONTAL )
					bmp = new Bitmap( this.BackgroundImage, new Size
						( this.BackgroundImage.Width, this.Height ) );
				else
					bmp = new Bitmap( this.BackgroundImage, new Size
						( this.Width, this.BackgroundImage.Height ) );

				srceRect = new Rectangle( 0, 0, bmp.Width, bmp.Height );

				if ( Orientation( ) == HORIZONTAL )
					// Похоже, что 100 прибвляется справа, чтобы избежать появление полос
					// на границах картинок, поэтому для устранения полосы внизу,
					// прибавляем 1.
					destRect = new Rectangle( 0, 0, this.Width + 100, this.Height + 1 );
				else
					// Аналогично лоя вертикального трека:
					// 100 прибавляется снизу, а 1 - справа
					destRect = new Rectangle( 0, 0, this.Width + 1, this.Height + 100 );

				g.DrawImage( bmp, destRect, srceRect, GraphicsUnit.Pixel );
				bmp.Dispose( );
			}
			else
			{
				SolidBrush myBrush = new SolidBrush( this.BackColor );
				g.FillRectangle( myBrush, 0, 0, this.Width, this.Height );
				myBrush.Dispose( );
			}

			/*
			Pen LEFTorTOPblue = new Pen(Color.FromArgb(95, 140, 180));
			Pen LEFTorTOPdark = new Pen(Color.FromArgb(55, 60, 74));
			Pen MIDDLEblue = new Pen(Color.FromArgb(21, 56, 152));

			Pen MIDDLEdark = new Pen(Color.FromArgb(0, 0, 0));
			Pen RIGHTorBOTTOMblue = new Pen(Color.FromArgb(99, 130, 208));
			Pen RIGHTorBOTTOMdark = new Pen(Color.FromArgb(87, 94, 110));
			*/
			// Карандаши - остались от вертикальной полосы прокрутки,
			// которая в плеере не рассматривается.
			/*
			Pen LEFTorTOPblue = new Pen( Color.FromArgb( 95, 175, 180 ) );
			Pen LEFTorTOPdark = new Pen( Color.FromArgb( 55, 69, 74 ) );
			Pen MIDDLEblue = new Pen( Color.FromArgb( 21, 112, 151 ) );

			Pen MIDDLEdark = new Pen( Color.FromArgb( 12, 15, 16 ) );
			Pen RIGHTorBOTTOMblue = new Pen( Color.FromArgb( 98, 175, 208 ) );
			Pen RIGHTorBOTTOMdark = new Pen( Color.FromArgb( 87, 104, 111 ) );
			*/

			// Ширина полосы компонента цвета линии прогресса.
			int colorWidth = this._ProgressBarColorComponentLineWidth;
			// Половина ширины полосы компонента цвета линии прогресса.
			int colorWidthHalf = ( int ) Math.Round( ( ( float ) colorWidth ) / 2f );

			#region Pens
			// Почему-то сверху появляется линия тёмного цвета градиента
			// верхнего градиентно залитого прямогольника,
			// хотя всё вроде бы рисуется нормально.
			// Поэтому просто зарисуем эту линию другой линией -
			// линией светлого цвета градиента верхнего градиентно
			// залитого прямогольника - этот цвет бедет уместным.
			// Аналогичная проблема со вторым градиентым прямоугольником.
			Pen leftOrTopLightPen = new Pen( ProgressLineLeftOrTopLightColor );
			Pen leftOrTopDarkPen = new Pen( ProgressLineLeftOrTopDarkColor );
			Pen middleLightPen = new Pen( ProgressLineMiddleLightColor );
			Pen middleDarkPen = new Pen( ProgressLineMiddleDarkColor );
			#endregion Pens

			#region
			#region if ( Orientation( ) == HORIZONTAL )
			if ( Orientation( ) == HORIZONTAL )
			{
				int y = ClientRectangle.Height / 2;
				/*if ( y * 2 < ClientRectangle.Height )
					y -= 1*/;

				int fromThumbLeftToCentre = this._PictureBoxThumb.Left +
					this._PictureBoxThumb.Width / 2;
				int fromThumbLeftToCentreAndOne = fromThumbLeftToCentre + 1;
				int withoutFromThumbLeftToCentre = ClientRectangle.Width -
					fromThumbLeftToCentreAndOne;

				Size fromThumbLeftToCentreSize = new Size
					( fromThumbLeftToCentre, colorWidth );
				Size withoutFromThumbLeftToCentreSize = new Size
					( withoutFromThumbLeftToCentre, colorWidth );

				#region Points for Rectangles and Brushes
				Point point1 = new Point
				(
					0,
					y - 2 * colorWidth + colorWidthHalf
				);

				Point point2 = new Point
				(
					fromThumbLeftToCentreAndOne,
					y - 2 * colorWidth + colorWidthHalf
				);

				Point point3 = new Point
				(
					0,
					y - colorWidth + colorWidthHalf
				);

				Point point4 = new Point
				(
					fromThumbLeftToCentreAndOne,
					y - colorWidth + colorWidthHalf
				);

				Point point5 = new Point
				(
					0,
					y + colorWidthHalf
				);

				Point point6 = new Point
				(
					fromThumbLeftToCentreAndOne,
					y + colorWidthHalf
				);
				#endregion Points for Rectangles and Brushes

				#region Points of the Gradient Brushes Ends
				Point pointEnd1 = new Point
				(
					point1.X,
					point1.Y + colorWidth
				);

				Point pointEnd5 = new Point
				(
					point5.X,
					point5.Y + colorWidth
				);
				#endregion Points of the Gradient Brushes Ends

				#region Rectangles for Filling
				Rectangle rectangle1 = new Rectangle
				(
					point1,
					fromThumbLeftToCentreSize
				);

				Rectangle rectangle2 = new Rectangle
				(
					point2,
					withoutFromThumbLeftToCentreSize
				);

				Rectangle rectangle3 = new Rectangle
				(
					point3,
					fromThumbLeftToCentreSize
				);

				Rectangle rectangle4 = new Rectangle
				(
					point4,
					withoutFromThumbLeftToCentreSize
				);

				Rectangle rectangle5 = new Rectangle
				(
					point5,
					fromThumbLeftToCentreSize
				);

				Rectangle rectangle6 = new Rectangle
				(
					point6,
					withoutFromThumbLeftToCentreSize
				);
				#endregion Rectangles for Filling

				#region Brushes
				Brush topLightBrush = new LinearGradientBrush
				(
					point1,
					pointEnd1,
					ProgressLineLeftOrTopLightColor,
					ProgressLineMiddleLightColor
				);

				Brush topDarkBrush = new LinearGradientBrush
				(
					point1,
					pointEnd1,
					ProgressLineLeftOrTopDarkColor,
					ProgressLineMiddleDarkColor
				);

				Brush middleLightBrush = new SolidBrush( ProgressLineMiddleLightColor );
				Brush middleDarkBrush = new SolidBrush( ProgressLineMiddleDarkColor );

				Brush bottomLightBrush = new LinearGradientBrush
				(
					pointEnd5,
					point5,
					ProgressLineRightOrBottomLightColor,
					ProgressLineMiddleLightColor
				);

				Brush bottomDarkBrush = new LinearGradientBrush
				(
					pointEnd5,
					point5,
					ProgressLineRightOrBottomDarkColor,
					ProgressLineMiddleDarkColor
				);
				#endregion Brushes

				#region if ( Orient( ) == HORZ ) if ( Minimum > Maximum )
				if ( Minimum > Maximum )
				{
					g.FillRectangle( topDarkBrush, rectangle1 );
					g.FillRectangle( topLightBrush, rectangle2 );
					g.FillRectangle( middleDarkBrush, rectangle3 );
					g.FillRectangle( middleLightBrush, rectangle4 );
					g.FillRectangle( bottomDarkBrush, rectangle5 );
					g.FillRectangle( bottomLightBrush, rectangle6 );

					g.DrawLine( leftOrTopDarkPen, point1, point2 );
					g.DrawLine( leftOrTopLightPen, point2, new Point
						( ClientRectangle.Width, point2.Y ) );
					g.DrawLine( middleDarkPen, point5, point6 );
					g.DrawLine( middleLightPen, point6, new Point
						( ClientRectangle.Width, point6.Y ) );
				} // if (Orientation() == Horz) if (Minimum > Maximum)
				#endregion if ( Orient( ) == HORZ ) if ( Minimum > Maximum )

				#region if ( Orient( ) == HORZ ) if ( Minimum > Maximum ) else
				else
				{
					g.FillRectangle( topLightBrush, rectangle1 );
					g.FillRectangle( topDarkBrush, rectangle2 );
					g.FillRectangle( middleLightBrush, rectangle3 );
					g.FillRectangle( middleDarkBrush, rectangle4 );
					g.FillRectangle( bottomLightBrush, rectangle5 );
					g.FillRectangle( bottomDarkBrush, rectangle6 );

					g.DrawLine( leftOrTopLightPen, point1, point2 );
					g.DrawLine( leftOrTopDarkPen, point2, new Point
						( ClientRectangle.Width, point2.Y ) );
					g.DrawLine( middleLightPen, point5, point6 );
					g.DrawLine( middleDarkPen, point6, new Point
						( ClientRectangle.Width, point6.Y ) );
				} // if (Orientation() == Horz) if (Minimum > Maximum) else
				#endregion if ( Orient( ) == HORZ ) if ( Minimum > Maximum ) else

				// Освобождение ресурсов кистей.
				topLightBrush.Dispose( );
				topDarkBrush.Dispose( );
				middleLightBrush.Dispose( );
				middleDarkBrush.Dispose( );
				bottomLightBrush.Dispose( );
				bottomDarkBrush.Dispose( );
			} // if (Orientation() == Horz)
			#endregion if ( Orientation( ) == HORIZONTAL )

			#region if ( Orientation( ) == HORIZONTAL ) else
			else
			{
				int x = ClientRectangle.Width / 2;

				int fromThumbTopToCentre = this._PictureBoxThumb.Top +
					this._PictureBoxThumb.Height / 2;
				int fromThumbTopToCentreAndOne = fromThumbTopToCentre + 1;
				int withoutFromThumbTopToCentre = ClientRectangle.Height -
					fromThumbTopToCentreAndOne;

				Size fromThumbTopToCentreSize = new Size
					( colorWidth, fromThumbTopToCentre );
				Size withoutFromThumbTopToCentreSize = new Size
					( colorWidth, withoutFromThumbTopToCentre );

				#region Points for Rectangles and Brushes
				Point point1 = new Point
				(
					x - 2 * colorWidth + colorWidthHalf,
					0
				);

				Point point2 = new Point
				(
					x - 2 * colorWidth + colorWidthHalf,
					fromThumbTopToCentreAndOne
				);

				Point point3 = new Point
				(
					x - colorWidth + colorWidthHalf,
					0
				);

				Point point4 = new Point
				(
					x - colorWidth + colorWidthHalf,
					fromThumbTopToCentreAndOne
				);

				Point point5 = new Point
				(
					x + colorWidthHalf,
					0
				);

				Point point6 = new Point
				(
					x + colorWidthHalf,
					fromThumbTopToCentreAndOne
				);
				#endregion Points for Rectangles and Brushes

				#region Points of the Gradient Brushes Ends
				Point pointEnd1 = new Point
				(
					point1.X + colorWidth,
					point1.Y
				);

				Point pointEnd5 = new Point
				(
					point5.X + colorWidth,
					point5.Y
				);
				#endregion Points of the Gradient Brushes Ends

				#region Rectangles for Filling
				Rectangle rectangle1 = new Rectangle
				(
					point1,
					fromThumbTopToCentreSize
				);

				Rectangle rectangle2 = new Rectangle
				(
					point2,
					withoutFromThumbTopToCentreSize
				);

				Rectangle rectangle3 = new Rectangle
				(
					point3,
					fromThumbTopToCentreSize
				);

				Rectangle rectangle4 = new Rectangle
				(
					point4,
					withoutFromThumbTopToCentreSize
				);

				Rectangle rectangle5 = new Rectangle
				(
					point5,
					fromThumbTopToCentreSize
				);

				Rectangle rectangle6 = new Rectangle
				(
					point6,
					withoutFromThumbTopToCentreSize
				);
				#endregion Rectangles for Filling

				#region Brushes
				Brush leftLightBrush = new LinearGradientBrush
				(
					point1,
					pointEnd1,
					ProgressLineLeftOrTopLightColor,
					ProgressLineMiddleLightColor
				);

				Brush leftDarkBrush = new LinearGradientBrush
				(
					point1,
					pointEnd1,
					ProgressLineLeftOrTopDarkColor,
					ProgressLineMiddleDarkColor
				);

				Brush middleLightBrush = new SolidBrush( ProgressLineMiddleLightColor );
				Brush middleDarkBrush = new SolidBrush( ProgressLineMiddleDarkColor );

				Brush rightLightBrush = new LinearGradientBrush
				(
					pointEnd5,
					point5,
					ProgressLineRightOrBottomLightColor,
					ProgressLineMiddleLightColor
				);

				Brush rightDarkBrush = new LinearGradientBrush
				(
					pointEnd5,
					point5,
					ProgressLineRightOrBottomDarkColor,
					ProgressLineMiddleDarkColor
				);
				#endregion Brushes

				#region if ( Orient( ) == HORZ ) else if ( Minimum > Maximum )
				if ( Minimum > Maximum )
				{
					g.FillRectangle( leftDarkBrush, rectangle1 );
					g.FillRectangle( leftLightBrush, rectangle2 );
					g.FillRectangle( middleDarkBrush, rectangle3 );
					g.FillRectangle( middleLightBrush, rectangle4 );
					g.FillRectangle( rightDarkBrush, rectangle5 );
					g.FillRectangle( rightLightBrush, rectangle6 );

					g.DrawLine( leftOrTopDarkPen, point1, point2 );
					g.DrawLine( leftOrTopLightPen, point2, new Point
						( point2.X, ClientRectangle.Height ) );
					g.DrawLine( middleDarkPen, point5, point6 );
					g.DrawLine( middleLightPen, point6, new Point
						( point6.X, ClientRectangle.Height ) );
				} // if (Orientation() == Horz) else if (Minimum > Maximum)
				#endregion if ( Orient( ) == HORZ ) else if ( Minimum > Maximum )

				#region if ( Orient( ) == HORZ ) else if ( Minimum > Maximum ) else
				else
				{
					g.FillRectangle( leftLightBrush, rectangle1 );
					g.FillRectangle( leftDarkBrush, rectangle2 );
					g.FillRectangle( middleLightBrush, rectangle3 );
					g.FillRectangle( middleDarkBrush, rectangle4 );
					g.FillRectangle( rightLightBrush, rectangle5 );
					g.FillRectangle( rightDarkBrush, rectangle6 );

					g.DrawLine( leftOrTopLightPen, point1, point2 );
					g.DrawLine( leftOrTopDarkPen, point2, new Point
						( point2.X, ClientRectangle.Height ) );
					g.DrawLine( middleLightPen, point5, point6 );
					g.DrawLine( middleDarkPen, point6, new Point
						( point6.X, ClientRectangle.Height ) );
				} // if (Orientation() == Horz) else if (Minimum > Maximum) else
				#endregion if ( Orient( ) == HORZ ) else if ( Minimum > Maximum ) else

				// Освобождение ресурсов кистей.
				leftLightBrush.Dispose( );
				leftDarkBrush.Dispose( );
				middleLightBrush.Dispose( );
				middleDarkBrush.Dispose( );
				rightLightBrush.Dispose( );
				rightDarkBrush.Dispose( );
			} // if (Orientation() == Horz) else
			#endregion if ( Orientation( ) == HORIZONTAL ) else
			#endregion

			#region
			/*
			// Здесь просто линии, теперь же используем прямоугольники,
			// чтобы полоса была шире.
			if ( Orientation( ) == HORIZONTAL )
			{
				int y = ClientRectangle.Height / 2;
				if ( y * 2 < ClientRectangle.Height )
					y -= 1;

				if ( Minimum > Maximum )
				{
					g.DrawLine
					(
						LEFTorTOPdark,
						new Point
						(
							0,
							y - 1
						),
						new Point
						(
							_PictureBoxThumb.Left + _PictureBoxThumb.Width / 2,
							y - 1
						)
					);
					g.DrawLine
					(
						LEFTorTOPblue,
						new Point
						(
							_PictureBoxThumb.Left + 1 + _PictureBoxThumb.Width / 2,
							y - 1
						),
						new Point
						(
							ClientRectangle.Width,
							y - 1
						)
					);
					g.DrawLine
					(
						MIDDLEdark,
						new Point
						(
							0,
							y
						),
						new Point
						(
							_PictureBoxThumb.Left + _PictureBoxThumb.Width / 2,
							y
						)
					);
					g.DrawLine
					(
						MIDDLEblue,
						new Point
						(
							_PictureBoxThumb.Left + 1 + _PictureBoxThumb.Width / 2,
							y
						),
						new Point
						(
							ClientRectangle.Width,
							y
						)
					);
					g.DrawLine
					(
						RIGHTorBOTTOMdark,
						new Point
						(
							0,
							y + 1
						),
						new Point
						(
							_PictureBoxThumb.Left + _PictureBoxThumb.Width / 2,
							y + 1
						)
					);
					g.DrawLine
					(
						RIGHTorBOTTOMblue,
						new Point
						(
							_PictureBoxThumb.Left + 1 + _PictureBoxThumb.Width / 2,
							y + 1
						),
						new Point
						(
							ClientRectangle.Width,
							y + 1
						)
					);
				} // if (Orientation() == Horz) if (Minimum > Maximum)

				else
				{
					g.DrawLine
					(
						LEFTorTOPblue,
						new Point
						(
							0,
							y - 1
						),
						new Point
						(
							_PictureBoxThumb.Left + _PictureBoxThumb.Width / 2,
							y - 1
						)
					);
					g.DrawLine
					(
						LEFTorTOPdark,
						new Point
						(
							_PictureBoxThumb.Left + 1 + _PictureBoxThumb.Width / 2,
							y - 1
						),
						new Point
						(
							ClientRectangle.Width,
							y - 1
						)
					);
					g.DrawLine
					(
						MIDDLEblue,
						new Point
						(
							0,
							y
						),
						new Point
						(
							_PictureBoxThumb.Left + _PictureBoxThumb.Width / 2,
							y
						)
					);
					g.DrawLine
					(
						MIDDLEdark,
						new Point
						(
							_PictureBoxThumb.Left + 1 + _PictureBoxThumb.Width / 2,
							y
						),
						new Point
						(
							ClientRectangle.Width,
							y
						)
					);
					g.DrawLine
					(
						RIGHTorBOTTOMblue,
						new Point
						(
							0,
							y + 1
						),
						new Point
						(
							_PictureBoxThumb.Left + _PictureBoxThumb.Width / 2,
							y + 1
						)
					);
					g.DrawLine
					(
						RIGHTorBOTTOMdark,
						new Point
						(
							_PictureBoxThumb.Left + 1 + _PictureBoxThumb.Width / 2,
							y + 1
						),
						new Point
						(
							ClientRectangle.Width,
							y + 1
						)
					);
				} // if (Orientation() == Horz) if (Minimum > Maximum) else
			} // if (Orientation() == Horz)
			else
			{
				int x = ClientRectangle.Width / 2;

				if ( Minimum > Maximum )
				{
					g.DrawLine
					(
						LEFTorTOPdark,
						new Point
						(
							x - 1,
							0
						),
						new Point
						(
							x - 1,
							_PictureBoxThumb.Top + _PictureBoxThumb.Width / 2
						)
					);
					g.DrawLine
					(
						LEFTorTOPblue,
						new Point
						(
							x - 1,
							_PictureBoxThumb.Top + 1 + _PictureBoxThumb.Width / 2
						),
						new Point
						(
							x - 1,
							ClientRectangle.Height
						)
					);
					g.DrawLine
					(
						MIDDLEdark,
						new Point
						(
							x,
							0
						),
						new Point
						(
							x,
							_PictureBoxThumb.Top + _PictureBoxThumb.Width / 2
						)
					);
					g.DrawLine
					(
						MIDDLEblue,
						new Point
						(
							x,
							_PictureBoxThumb.Top + 1 + _PictureBoxThumb.Width / 2
						),
						new Point
						(
							x,
							ClientRectangle.Height
						)
					);
					g.DrawLine
					(
						RIGHTorBOTTOMdark,
						new Point
						(
							x + 1,
							0
						),
						new Point
						(
							x + 1,
							_PictureBoxThumb.Top + _PictureBoxThumb.Width / 2
						)
					);
					g.DrawLine
					(
						RIGHTorBOTTOMblue,
						new Point
						(
							x + 1,
							_PictureBoxThumb.Top + 1 + _PictureBoxThumb.Width / 2
						),
						new Point
						(
							x + 1,
							ClientRectangle.Height
						)
					);
				} // if (Orientation() == Horz) else if (Minimum > Maximum)
				else
				{
					g.DrawLine
					(
						LEFTorTOPblue,
						new Point
						(
							x - 1,
							0
						),
						new Point
						(
							x - 1,
							_PictureBoxThumb.Top + _PictureBoxThumb.Width / 2
						)
					);
					g.DrawLine
					(
						LEFTorTOPdark,
						new Point
						(
							x - 1,
							_PictureBoxThumb.Top + 1 + _PictureBoxThumb.Width / 2
						),
						new Point
						(
							x - 1,
							ClientRectangle.Height
						)
					);
					g.DrawLine
					(
						MIDDLEblue,
						new Point
						(
							x,
							0
						),
						new Point
						(
							x,
							_PictureBoxThumb.Top + _PictureBoxThumb.Width / 2
						)
					);
					g.DrawLine
					(
						MIDDLEdark,
						new Point
						(
							x,
							_PictureBoxThumb.Top + 1 + _PictureBoxThumb.Width / 2
						),
						new Point
						(
							x,
							ClientRectangle.Height
						)
					);
					g.DrawLine
					(
						RIGHTorBOTTOMblue,
						new Point
						(
							x + 1,
							0
						),
						new Point
						(
							x + 1,
							_PictureBoxThumb.Top + _PictureBoxThumb.Width / 2
						)
					);
					g.DrawLine
					(
						RIGHTorBOTTOMdark,
						new Point
						(
							x + 1,
							_PictureBoxThumb.Top + 1 + _PictureBoxThumb.Width / 2
						),
						new Point
						(
							x + 1,
							ClientRectangle.Height
						)
					);
				} // if (Orientation() == Horz) else if (Minimum > Maximum) else
			} // if (Orientation() == Horz) else
			*/
			#endregion

			// Освобождение ресурсов перьев.
			leftOrTopLightPen.Dispose( );
			leftOrTopDarkPen.Dispose( );
			middleLightPen.Dispose( );
			middleDarkPen.Dispose( );

			// Draw thumb tracker
			bmp = new Bitmap( this._PictureBoxThumb.BackgroundImage );
			bmp.MakeTransparent( this._ThumbTransparencyKey );
			bmp = new Bitmap( bmp, new Size
				( this._PictureBoxThumb.Width, this._PictureBoxThumb.Height ) );
			srceRect = new Rectangle( 0, 0, _PictureBoxThumb.Width,
				_PictureBoxThumb.Height );
			destRect = new Rectangle( _PictureBoxThumb.Left, _PictureBoxThumb.Top,
				_PictureBoxThumb.Width, _PictureBoxThumb.Height );
			g.DrawImage( bmp, destRect, srceRect, GraphicsUnit.Pixel );
			bmp.Dispose( );

			/*
			// Release pen resources
			LEFTorTOPblue.Dispose( );
			LEFTorTOPdark.Dispose( );
			MIDDLEblue.Dispose( );
			MIDDLEdark.Dispose( );
			RIGHTorBOTTOMblue.Dispose( );
			RIGHTorBOTTOMdark.Dispose( );
			*/
		} // Draw

		/// <summary>
		/// Отрисовка левого или верхнего окончания линии прогресса
		/// на картинке левой или верхней границы трека прокрутки.
		/// </summary>
		/// <param name="parGraphics">Объект поверхности рисования GDI+.</param>
		/// <param name="parControlClientRectangle">Прямоугольник
		/// клиентской области элемента управления.</param>
		public void DrawPictureBoxProgressLineLeftOrTopEnd
			( Graphics parGraphics, Rectangle parControlClientRectangle )
		{
			// Тип окончания линии прогресса.
			SkinTrackbarProgressLineEndType progressLineEndType;
			// Если ориентация горизонтальная, то граница левая,
			// иначе ориентация вертикальная и граница верхняя.
			if ( this.Orientation( ) == SkinTrackbar.HORIZONTAL )
				progressLineEndType = SkinTrackbarProgressLineEndType.LEFT;
			else
				progressLineEndType = SkinTrackbarProgressLineEndType.TOP;

			// Яркость палитры линии прогресса.
			SkinTrackbarProgressLinePaletteBrightness paletteBrightness;
			// Если минимальная граница слева или вверху, то граница светлая,
			// иначе тёмная.
			if ( Minimum < Maximum )
				paletteBrightness = SkinTrackbarProgressLinePaletteBrightness.LIGHT;
			else
				paletteBrightness = SkinTrackbarProgressLinePaletteBrightness.DARK;

			// Отрисовка окончания линии прогресса.
			this.DrawProgressLineEnd
			(
				parGraphics,
				paletteBrightness,
				parControlClientRectangle,
				progressLineEndType
			); // DrawProgressLineEnd
		} // DrawPictureBoxProgressLineLeftOrTopEnd

		/// <summary>
		/// Отрисовка правого или нижнего окончания линии прогресса
		/// на картинке правой или нижней границы трека прокрутки.
		/// </summary>
		/// <param name="parGraphics">Объект поверхности рисования GDI+.</param>
		/// <param name="parControlClientRectangle">Прямоугольник
		/// клиентской области элемента управления.</param>
		public void DrawPictureBoxProgressLineRightOrBottomEnd
			( Graphics parGraphics, Rectangle parControlClientRectangle )
		{
			// Тип окончания линии прогресса.
			SkinTrackbarProgressLineEndType progressLineEndType;
			// Если ориентация горизонтальная, то граница правая,
			// иначе ориентация вертикальная и граница нижняя.
			if ( this.Orientation( ) == SkinTrackbar.HORIZONTAL )
				progressLineEndType = SkinTrackbarProgressLineEndType.RIGHT;
			else
				progressLineEndType = SkinTrackbarProgressLineEndType.BOTTOM;

			// Яркость палитры линии прогресса.
			SkinTrackbarProgressLinePaletteBrightness paletteBrightness;
			// Если минимальная граница слева или вверху, то граница светлая,
			// иначе тёмная.
			if ( Minimum < Maximum )
				paletteBrightness = SkinTrackbarProgressLinePaletteBrightness.DARK;
			else
				paletteBrightness = SkinTrackbarProgressLinePaletteBrightness.LIGHT;

			// Отрисовка окончания линии прогресса.
			this.DrawProgressLineEnd
			(
				parGraphics,
				paletteBrightness,
				parControlClientRectangle,
				progressLineEndType
			); // DrawProgressLineEnd
		} // DrawPictureBoxProgressLineRightOrBottomEnd

		protected override void WndProc( ref Message m )
		{
			switch ( m.Msg )
			{
				case Api.WM_ERASEBKGND:
					// Create a memory bitmap to use as double buffer
					Bitmap offScreenBmp;
					offScreenBmp = new Bitmap( this.Width, this.Height );
					Graphics g = Graphics.FromImage( offScreenBmp );

					this.Draw( g );

					// Release graphics
					g.Dispose( );

					// Swap memory bitmap (End double buffer)
					g = Graphics.FromHdc( m.WParam );
					g.DrawImage( offScreenBmp, 0, 0 );
					g.Dispose( );
					offScreenBmp.Dispose( );
					break;

				default:
					base.WndProc( ref m );
					break;
			}
		} // WndProc

		private void SetThumbLocation( )
		{
			Point pos = PointToClient( Cursor.Position );

			if ( Orientation( ) == HORIZONTAL )
			{
				_PictureBoxThumb.Left = Math.Min( Math.Max( pos.X -
					_PictureBoxThumb.Width / 2, 0 ), _PictureBoxThumb.Parent.Width -
					_PictureBoxThumb.Width );
				/*
				_Thumb.Top = ((ClientRectangle.Height - _Thumb.Width ) / 2);
				*/
				_PictureBoxThumb.Top = ( ClientRectangle.Height -
					_PictureBoxThumb.Height ) / 2 + 1;
				int range = ClientRectangle.Width - _PictureBoxThumb.Width;
				double increment = ( _Maximum - _Minimum ) / range;
				_Value = ( increment * _PictureBoxThumb.Left ) + _Minimum;
			}
			else
			{
				_PictureBoxThumb.Left = ( ClientRectangle.Width -
					_PictureBoxThumb.Width ) / 2 + 1;
				_PictureBoxThumb.Top = Math.Min( Math.Max( pos.Y -
					_PictureBoxThumb.Height / 2, 0 ), _PictureBoxThumb.Parent.Height -
					_PictureBoxThumb.Height );

				int range = ClientRectangle.Height - _PictureBoxThumb.Height;
				double increment = ( _Maximum - _Minimum ) / range;
				_Value = ( increment * _PictureBoxThumb.Top ) + _Minimum;
			}
			Value = _Value;

			if ( _WasValue != ( int ) _Value )
			{
				this.Invalidate( );
				SendNotification( );
				_WasValue = ( int ) _Value;
				/*
				if (CheckOverThumb(pos.X, pos.Y))
				{
					_ToolTip.SetToolTip(this, ((int)_Value).ToString());
				}
				*/
			}
		} // SetThumbLocation

		// Retrieve the control orientation
		private bool Orientation( )
		{
			bool orientation = VERTICAL;
			if ( this.Width > this.Height )
				orientation = HORIZONTAL;
			return orientation;
		} // Orientation

		private void ShowThumbPos( )
		{
			if ( Orientation( ) == HORIZONTAL )
			{
				/*
				_Thumb.Top = (ClientRectangle.Height - _Thumb.Width) / 2;
				*/
				_PictureBoxThumb.Top = ( int ) Math.Round( ( ClientRectangle.Height -
					_PictureBoxThumb.Height ) / 2f ) - 1;
				int range = ClientRectangle.Width - _PictureBoxThumb.Width;
				double increment = ( _Maximum - _Minimum ) / range;
				if ( increment == 0 )
				{
					_PictureBoxThumb.Left = 0;
				}
				else
				{
					_PictureBoxThumb.Left = ( int ) ( ( _Value - _Minimum ) / increment );
				}
			}
			else
			{
				_PictureBoxThumb.Left = ( int ) Math.Round( ( ClientRectangle.Width -
					_PictureBoxThumb.Width ) / 2f ) - 1;
				int range = ClientRectangle.Height - _PictureBoxThumb.Height;
				double increment = ( _Maximum - _Minimum ) / range;
				if ( increment == 0 )
				{
					_PictureBoxThumb.Top = 0;
				}
				else
				{
					_PictureBoxThumb.Top = ( int ) ( ( _Value - _Minimum ) / increment );
				}
			}
			this.Invalidate( );
		} // ShowThumbPos


		#region Events Handlers


		private void OnLoad( object sender, EventArgs e )
		{
			if ( _Minimum == 0 && _Maximum == 0 )
			{
				// Set default value
				this._Value = 50;

				if ( Orientation( ) == HORIZONTAL )
				{
					this._Minimum = 0;
					this._Maximum = 100;
				}
				else
				{
					this._Minimum = 100;
					this._Maximum = 0;
				}
			} // if ( _Minimum == 0 && _Maximum == 0 )

			if ( Orientation( ) == HORIZONTAL )
				// Ширина полосы компонента цвета линии прогресса.
				this._ProgressBarColorComponentLineWidth = ( int ) Math.Ceiling
					( ( float ) this.Height * SkinTrackbar.
					PROGRESS_BAR_COLOR_COMPONENT_LINE_WIDTH_TO_THIS_SHORT_SIDE_RATIO );
			else
				// Ширина полосы компонента цвета линии прогресса.
				this._ProgressBarColorComponentLineWidth = ( int ) Math.Ceiling
					( ( float ) this.Width * SkinTrackbar.
					PROGRESS_BAR_COLOR_COMPONENT_LINE_WIDTH_TO_THIS_SHORT_SIDE_RATIO );

			// FORM_Tooltip colors
			//toolTip.BackColor = SK.TooltipBackColor;
			//toolTip.ForeColor = SK.TooltipForeColor;

			Point pos = PointToClient( Cursor.Position );

			if ( Orientation( ) == HORIZONTAL )
				this._PictureBoxThumb.Top = ( this.ClientRectangle.Height -
					this._PictureBoxThumb.Height ) / 2 - 1;
			else
				this._PictureBoxThumb.Left = ( this.ClientRectangle.Width -
					this._PictureBoxThumb.Width ) / 2 - 1;
		} // OnLoad

		private void OnThumbMouseDown( object sender, MouseEventArgs e )
		{
			_ThumbMoving = true;
		} // OnThumbMouseDown

		private bool CheckOverThumb( int x, int y )
		{
			Api.RECT r = new Api.RECT( );
			r.left = _PictureBoxThumb.Left;
			r.top = _PictureBoxThumb.Top;
			r.right = r.left + _PictureBoxThumb.Width;
			r.bottom = r.top + _PictureBoxThumb.Height;
			Api.POINT p = new Api.POINT( );
			p.x = x;
			p.y = y;
			return ( Api.PtInRect( ref r, p ) );
		} // CheckOverThumb

		private void OnThumbMouseMove( object sender, MouseEventArgs e )
		{
			if ( _ThumbMoving )
				SetThumbLocation( );
			/*
			//BUG Vista, the animation stops while the tooltip is being shown!
			//----------------------------------------------------------------
			if (CheckOverThumb(e.X, e.Y) == false)
			{
			//    toolTip.SetToolTip(this, ((int)value).ToString());
			//}
			//else
			//{
				_ToolTip.SetToolTip(this, "");
			}
			*/
		} // OnThumbMouseMove

		private void OnMouseDown( object sender, MouseEventArgs e )
		{
			_ThumbMoving = true;
			SetThumbLocation( );
		} // OnMouseDown

		private void OnThumbMouseUp( object sender, MouseEventArgs e )
		{
			_ThumbMoving = false;
		} // OnThumbMouseUp

		//private void toolTip_Popup(object sender, PopupEventArgs e)
		//{

		//}

		private void OnResize( object sender, EventArgs e )
		{
			// Чтобы позиция бегунка была актуальна при изменении размеров.
			this.ShowThumbPos( );
		} // OnResize

		/// <summary>
		/// Отрисовка левого или верхнего окончания линии прогресса
		/// на картинке левой или верхней границы трека прокрутки.
		/// </summary>
		/// <param name="parSender">Объект-источник.</param>
		/// <param name="parPaintEventArgs">Аргументы события.</param>
		private void OnPaintPictureBoxProgressLineLeftOrTopEnd
			( object parSender, PaintEventArgs parPaintEventArgs )
		{
			// Отрисовка левого или верхнего окончания линии прогресса
			// на картинке левой или верхней границы трека прокрутки.
			this.DrawPictureBoxProgressLineLeftOrTopEnd
				( parPaintEventArgs.Graphics,
				( ( Control ) parSender ).ClientRectangle );
		} // OnPaintPictureBoxProgressLineLeftOrTopEnd

		/// <summary>
		/// Отрисовка правого или нижнего окончания линии прогресса
		/// на картинке правой или нижней границы трека прокрутки.
		/// </summary>
		/// <param name="parSender">Объект-источник.</param>
		/// <param name="parPaintEventArgs">Аргументы события.</param>
		private void OnPaintPictureBoxProgressLineRightOrBottomEnd
			( object parSender, PaintEventArgs parPaintEventArgs )
		{
			// Отрисовка правого или нижнего окончания линии прогресса
			// на картинке правой или нижней границы трека прокрутки.
			this.DrawPictureBoxProgressLineRightOrBottomEnd
				( parPaintEventArgs.Graphics,
				( ( Control ) parSender ).ClientRectangle );
		} // OnPaintPictureBoxProgressLineRightOrBottomEnd


		#endregion Events Handlers


		#endregion Methods


		#region Properties

		/// <summary>
		/// Минимальное значение.
		/// </summary>
		[
			// Признак отображения в окне Properties
			Browsable( true ),
			// Имя категории, включающей свойство
			Category( "Values" ),
			// Небольшой фрагмент текста для отображения в нижней части
			// обозревателя свойств
			Description( "Минимальное значение" ),
			// Значение по умолчанию
			DefaultValue( 0 )
		]
		public double Minimum
		{
			get
			{
				return ( _Minimum );
			}
			set
			{
				/*double minimumBackup = _Minimum;*/
				_Minimum = value;
				ShowThumbPos( );

				if ( this._PictureBoxLeftOrTopBorder != null )
					this._PictureBoxLeftOrTopBorder.Invalidate( );
				if ( this._PictureBoxRightOrBottomBorder != null )
					this._PictureBoxRightOrBottomBorder.Invalidate( );
			}
		} // Minimum

		/// <summary>
		/// Максимальное значение.
		/// </summary>
		[
			// Признак отображения в окне Properties
			Browsable( true ),
			// Имя категории, включающей свойство
			Category( "Values" ),
			// Небольшой фрагмент текста для отображения в нижней части
			// обозревателя свойств
			Description( "Максимальное значение" ),
			// Значение по умолчанию
			DefaultValue( 100 )
		]
		public double Maximum
		{
			get
			{
				return ( _Maximum );
			}
			set
			{
				/*double maximumBackup = _Maximum;*/
				_Maximum = value;
				ShowThumbPos( );

				if ( this._PictureBoxLeftOrTopBorder != null )
					this._PictureBoxLeftOrTopBorder.Invalidate( );
				if ( this._PictureBoxRightOrBottomBorder != null )
					this._PictureBoxRightOrBottomBorder.Invalidate( );
			}
		} // Maximum

		/// <summary>
		/// Значение.
		/// </summary>
		[
			// Признак отображения в окне Properties
			Browsable( true ),
			// Имя категории, включающей свойство
			Category( "Values" ),
			// Небольшой фрагмент текста для отображения в нижней части
			// обозревателя свойств
			Description( "Значение" ),
			// Значение по умолчанию
			DefaultValue( 50 )
		]
		public double Value
		{
			get
			{
				return ( _Value );
			}
			set
			{
				/*double valueBackup = this._Value;*/
				if ( _Minimum > _Maximum )
				{
					this._Value = Math.Max( Math.Min( value, _Minimum ), _Maximum );
				}
				else
				{
					this._Value = Math.Max( Math.Min( value, _Maximum ), _Minimum );
				}
				ShowThumbPos( );
			}
		} // Value

		/// <summary>
		/// Ширина переключателя.
		/// </summary>
		[
			// Признак отображения в окне Properties
			Browsable( true ),
			// Имя категории, включающей свойство
			Category( "Thumb" ),
			// Небольшой фрагмент текста для отображения в нижней части
			// обозревателя свойств
			Description( "Ширина переключателя" ),
			// Значение по умолчанию
			DefaultValue( 15 )
		]
		public int ThumbWidth
		{
			get
			{
				return this._PictureBoxThumb.Width;
			} // get
			set
			{
				if ( value < SkinTrackbar.THUMB_MINIMUM_WIDTH )
					this._PictureBoxThumb.Width = SkinTrackbar.THUMB_MINIMUM_WIDTH;
				else
					if ( value > this.Width )
						this._PictureBoxThumb.Width = this.Width;
					else
						this._PictureBoxThumb.Width = value;

				this.ShowThumbPos( );
			} // set
		} // ThumbWidth

		/// <summary>
		/// Высота переключателя.
		/// </summary>
		[
			// Признак отображения в окне Properties
			Browsable( true ),
			// Имя категории, включающей свойство
			Category( "Thumb" ),
			// Небольшой фрагмент текста для отображения в нижней части
			// обозревателя свойств
			Description( "Высота переключателя" ),
			// Значение по умолчанию
			DefaultValue( 15 )
		]
		public int ThumbHeight
		{
			get
			{
				return this._PictureBoxThumb.Height;
			} // get
			set
			{
				if ( value < SkinTrackbar.THUMB_MINIMUM_HEIGHT )
					this._PictureBoxThumb.Height = SkinTrackbar.THUMB_MINIMUM_HEIGHT;
				else
					if ( value > this.Height )
						this._PictureBoxThumb.Height = this.Height;
					else
						this._PictureBoxThumb.Height = value;

				this.ShowThumbPos( );
			} // set
		} // ThumbHeight

		/// <summary>
		/// Цвет прозрачности переключателя.
		/// </summary>
		[
			// Признак отображения в окне Properties
			Browsable( true ),
			// Имя категории, включающей свойство
			Category( "Thumb" ),
			// Небольшой фрагмент текста для отображения в нижней части
			// обозревателя свойств
			Description( "Цвет прозрачности переключателя" ),
			// Значение по умолчанию
			DefaultValue( 0xE100E1 )
		]
		public Color ThumbTransparencyKey
		{
			get
			{
				return this._ThumbTransparencyKey;
			} // get
			set
			{
				this._ThumbTransparencyKey = value;
			} // set
		} // ThumbTransparencyKey

		/// <summary>
		/// Изображение переключателя.
		/// </summary>
		[
			// Признак отображения в окне Properties
			Browsable( true ),
			// Имя категории, включающей свойство
			Category( "Thumb" ),
			// Небольшой фрагмент текста для отображения в нижней части
			// обозревателя свойств
			Description( "Изображение переключателя" )
		]
		public Image ThumbBackgroundImage
		{
			get
			{
				return this._PictureBoxThumb.BackgroundImage;
			} // get
			set
			{
				this._PictureBoxThumb.BackgroundImage = value;
			} // set
		} // ThumbBackgroundImage

		/// <summary>
		/// Картинка левой или верхней границы трека прокрутки.
		/// </summary>
		[
			// Признак отображения в окне Properties
			Browsable( true ),
			// Имя категории, включающей свойство
			Category( "Borders" ),
			// Небольшой фрагмент текста для отображения в нижней части
			// обозревателя свойств
			Description( "Картинка левой или верхней границы трека прокрутки" )
		]
		public PictureBox PictureBoxLeftOrTopBorder
		{
			get
			{
				return this._PictureBoxLeftOrTopBorder;
			}
			set
			{
				if ( this._PictureBoxLeftOrTopBorder != null )
					try
					{
						this._PictureBoxLeftOrTopBorder.Paint -=
							this.OnPaintPictureBoxProgressLineLeftOrTopEnd;
						this._PictureBoxLeftOrTopBorder.Invalidate( );
					}
					catch
					{
					}

				this._PictureBoxLeftOrTopBorder = value;

				if ( this._PictureBoxLeftOrTopBorder != null )
					try
					{
						this._PictureBoxLeftOrTopBorder.Paint +=
							this.OnPaintPictureBoxProgressLineLeftOrTopEnd;
						this._PictureBoxLeftOrTopBorder.Invalidate( );
					}
					catch
					{
					}
			} // set
		} // PictureBoxLeftOrTopBorder

		/// <summary>
		/// Картинка правой или нижней границы трека прокрутки.
		/// </summary>
		[
			// Признак отображения в окне Properties
			Browsable( true ),
			// Имя категории, включающей свойство
			Category( "Borders" ),
			// Небольшой фрагмент текста для отображения в нижней части
			// обозревателя свойств
			Description( "Картинка правой или нижней границы трека прокрутки" )
		]
		public PictureBox PictureBoxRightOrBottomBorder
		{
			get
			{
				return this._PictureBoxRightOrBottomBorder;
			}
			set
			{
				if ( this._PictureBoxRightOrBottomBorder != null )
					try
					{
						this._PictureBoxRightOrBottomBorder.Paint -=
							this.OnPaintPictureBoxProgressLineRightOrBottomEnd;
						this._PictureBoxRightOrBottomBorder.Invalidate( );
					}
					catch
					{
					}

				this._PictureBoxRightOrBottomBorder = value;

				if ( this._PictureBoxRightOrBottomBorder != null )
					try
					{
						this._PictureBoxRightOrBottomBorder.Paint +=
							this.OnPaintPictureBoxProgressLineRightOrBottomEnd;
						this._PictureBoxRightOrBottomBorder.Invalidate( );
					}
					catch
					{
					}
			} // set
		} // PictureBoxRightOrBottomBorder


		#endregion Properties


	} // SkinTrackbar
} // zap