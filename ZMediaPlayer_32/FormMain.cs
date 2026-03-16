//+--------------------------------------------------------------------------+
//|                                                                          |
//|                             zMoviePlayer                                 |
//|                         DirectX Movie Player                             |
//|                                                                          |
//|                             Version 1.04                                 |
//+--------------------------------------------------------------------------+
//|                                                                          |
//|                         Author Patrice TERRIER                           |
//|                           copyright (c) 2007                             |
//|                                                                          |
//|                        pterrier@zapsolution.com                          |
//|                                                                          |
//|                          www.zapsolution.com                             |
//|                                                                          |
//+--------------------------------------------------------------------------+
//|                  Project started on : 04-20-2007 (MM-DD-YYYY)            |
//|                        Last revised : 05-21-2007 (MM-DD-YYYY)            |
//+--------------------------------------------------------------------------+

//---------------------------------------------------------------------------
// CustomerDesktop
// Co-author Kate Kotova
// NIJANUS Copyright © 2004-2010
// nijanus@ymail.com
// http://nijanus.narod2.ru
//---------------------------------------------------------------------------

using System;
using System.Text;
using System.Windows.Forms;
using System.Drawing;
using System.Runtime.InteropServices;
using System.Threading;
using System.Xml;

using Win32;
using SkinEngine;

using Microsoft.DirectX.AudioVideoPlayback;

using Microsoft.Win32;
using System.IO;

namespace zap
{
	/// <summary>
	/// Главная форма.
	/// </summary>
	public partial class FormMain : Form
	{
		#region Fields


		IntPtr hFORM_Main = IntPtr.Zero;         // Default to Zero


		#region Constants and Readonly


		//const string RegistryKey = @"HKEY_LOCAL_MACHINE\SOFTWARE\zMoviePlayer";
		//const string RegistryPath = "DefaultPathName";
		//const string RegistryAudioVolume = "AudioVolume";
		//const string RegistryStringData = "StringData";

		/// <summary>
		/// Имя класса.
		/// </summary>
		private const string CLASS_NAME = "FormMain";

		/// <summary>
		/// Путь к файлу настроек.
		/// </summary>
		private readonly string _SettingsFilePath = "ZMediaPayerSettings.xml";
		/// <summary>
		/// Путь к файлу статуса показа главной формы:
		/// в этом файле указыванется, запущен ли в данный момент плеер или нет.
		/// </summary>
		private readonly string _MainFormShowingStatusFilePath =
			"ZMediaPayerShowingStatus.txt";

		/// <summary>
		/// Цвет прозрачности, используемый при появлении или исчезновения формы.
		/// </summary>
		public readonly Color TemporaryTransparencyKey = Color.FromArgb( 64, 0, 0 );

		/// <summary>
		/// Ширина бордюра по краю формы и командной панели.
		/// </summary>
		private const int BORDER_WIDTH = 10;
		/// <summary>
		/// Максимальное значение непрозрачности.
		/// </summary>
		public const double MAXIMUM_OPACITY = 1;
		/// <summary>
		/// Доля минимальной длины большей стороны трека прокрутки
		/// от ширины кнопки.
		/// </summary>
		private const float
			TRACKBAR_GREATER_SIDE_MINIMUM_LENGHT_TO_BUTTON_WIDTH_RATIO = 1.1f;
		/// <summary>
		/// Доля ширины вертикальной границы горизонтального трека прокрутки
		/// от ширины кнопки.
		/// </summary>
		private const float TRACKBAR_VERTICAL_BORDER_WIDTH_TO_BUTTON_WIDTH_RATIO =
			4f / 11f;
		/// <summary>
		/// Доля максимальной длины стороны картинки прелоадера
		/// от длины меньшей стороны панели экрана.
		/// </summary>
		private const float
			PRELOADER_SIDE_MAXIMUM_LENGHT_TO_SCREEN_SMALLER_SIDE_LENGHT_RATIO = 0.25f;

		/// <summary>
		/// Множитель позиции проигрывания медиа-файла
		/// для отображения на треке прокрутки.
		/// </summary>
		private const int TRACK_VALUE__MEDIA_POSITION__MULTIPLIER = 10;
		/// <summary>
		/// Минимальное значение звука.
		/// </summary>
		private const int MINIMUM_AUDIO_VOLUME = -10000;

		/// <summary>
		/// Количество секунд в минуте.
		/// </summary>
		private const int SECONDS_IN_MINUTE = 60;
		/// <summary>
		/// Количество минут в часу.
		/// </summary>
		private const int MINUTES_IN_HOUR   = 60;
		/// <summary>
		/// Количество секунд в часу.
		/// </summary>
		private const int SECONDS_IN_HOUR   = FormMain.MINUTES_IN_HOUR *
			FormMain.SECONDS_IN_MINUTE;

		/// <summary>
		/// Два нуля.
		/// </summary>
		private const string DOUBLE_ZERO = "00";
		/// <summary>
		/// Двоеточие.
		/// </summary>
		private const char COLON = ':';
		/// <summary>
		/// Обратный слеш.
		/// </summary>
		private const char BACKSLASH = '\\';
		/// <summary>
		/// Красная строка.
		/// </summary>
		private const char NEW_LINE = '\n';
		/// <summary>
		/// Нуль.
		/// </summary>
		private const string ZERO = "0";
		/// <summary>
		/// Единица.
		/// </summary>
		private const string ONE = "1";
		/// <summary>
		/// Точка.
		/// </summary>
		private const string POINT = ".";
		/// <summary>
		/// Запятая.
		/// </summary>
		private const string COMMA = ",";

		/// <summary>
		/// Сообщение о невозможности воспроизвадения файла.
		/// </summary>
		private const string UNABLE_TO_PLAY_MESSAGE = "Unable to play ";
		/// <summary>
		/// Сообщение о возникновении ошибки.
		/// </summary>
		private const string ERROR_IS_OCCURRED_MESSAGE =
			"The error is occurred: ";
		/// <summary>
		/// Сообщение о неизвестной строке-разделителе между целой
		/// и дробной частями десятичного числа, установленной в системе.
		/// </summary>
		private const string
			UNKNOWN_INTEGER_AND_DECIMAL_PARTS_SEPARATOR_MESSAGE =
			"There is unknown separator of integer and decimal parts in system";

		/// <summary>
		/// Размеры квадратных картинок прелоадеров.
		/// </summary>
		private readonly int[ ] _PreloadersImagesSizes = new int[ ]
		{
			32,
			64,
			128,
			192
		}; // _MoviesExtensions

		/// <summary>
		/// Расширения видео-файлов.
		/// </summary>
		private readonly string[ ] _MoviesExtensions = new string[ ]
		{
			".avi",
			".wmv",
			".mpeg",
			".mpg"
		}; // _MoviesExtensions

		/// <summary>
		/// Расширения аудио-файлов.
		/// </summary>
		private readonly string[ ] _AudiosExtensions = new string[ ]
		{
			".m1a",
			".m4a",
			".mid",
			".midi",
			".mp2",
			".mp3",
			".ogg",
			".wav",
			".wave",
			".wma"
		}; // _AudiosExtensions


		#endregion Constants and Readonly


		#region Variabes


		private bool _FullScreen = false;
		private bool _ScrollEnable = false;
		private bool _MuteMode = false;
		private bool _HDmovie = false;
		private bool _TimerMediaEnabled = false;
		private Video _Movie;
		private Audio _Audio;
		private Size _MovieDefaultSize;
		private string _MediaDurationString;
		private float _Aspect;
		private int _Hours;
		private int _Minutes;
		private int _Seconds;
		private int _MediaDurationValue;
		private int _MediaCurrentPosition = 0;
		private int _CommandPanelHeight;
		private int _InitialClientWidth;

		/// <summary>
		/// Системная десятичная точка - строка-разделитель между целой
		/// и дробной частями десятичного числа, принятая в системе.
		/// </summary>
		private string _SystemDecimalPoint = FormMain.POINT;
		/// <summary>
		/// URL-адрес медиа-файла для проигрывания.
		/// </summary>
		private string _MediaFileURL = string.Empty;
		/// <summary>
		/// Mедиа-тип, указывающий является ли файл аудио или видео.
		/// </summary>
		private string _MediaTypeName = string.Empty;

		/// <summary>
		/// Форма звука.
		/// </summary>
		private FormSound _FormSound;
		/// <summary>
		/// Ширина формы звука.
		/// </summary>
		private int _FormSoundWidth = 0;
		/// <summary>
		/// Прямоугольник уменьшенного изображения-копии формы.
		/// </summary>
		private Rectangle _FormImageSmallCopyRectangle;
		/// <summary>
		/// Признак наличия возможности закрытия формы.
		/// </summary>
		private bool _CanClose = false;

		/// <summary>
		/// Доля ширины трека прокрутки длительности от ширины командной панели.
		/// </summary>
		private float _DurationTrackbarWidthToCommandPanelWidthRatio = 1f;

		/// <summary>
		/// Интервал в миллисекундах таймера эффекта изменения видимости.
		/// </summary>
		private int VisibleChangingEffectTimerInterval = 1;
		/// <summary>
		/// Время в миллисекундах длительности эффекта изменения видимости -
		/// время, в течение которого осуществляется эффект появления
		/// или исчезновения формы.
		/// </summary>
		private int VisibleChangingEffectTime = 100;

		/// <summary>
		/// Приращение абсциссы эффекта изменения видимости формы.
		/// </summary>
		private int _VisibleChangingEffectXIncrementation = 0;
		/// <summary>
		/// Приращение ординаты эффекта изменения видимости формы.
		/// </summary>
		private int _VisibleChangingEffectYIncrementation = 0;
		/// <summary>
		/// Приращение ширины эффекта изменения видимости формы.
		/// </summary>
		private int _VisibleChangingEffectWidthIncrementation = 0;
		/// <summary>
		/// Приращение высоты эффекта изменения видимости формы.
		/// </summary>
		private int _VisibleChangingEffectHeightIncrementation = 0;
		/// <summary>
		/// Приращение непрозрачности эффекта изменения видимости формы.
		/// </summary>
		private double _VisibleChangingEffectOpacityIncrementation = 0;


		#endregion Variabes


		#endregion Fields


		/// <summary>
		/// Создание главной формы.
		/// </summary>
		/// <param name="parMediaFile">Имя меди-файла.</param>
		public FormMain( string parMediaFile )
		{
			// Создание нового экземпляра класса.
			Program.MainTracer.CreateClassNewInstance( FormMain.CLASS_NAME,
				parMediaFile );

			hFORM_Main = this.Handle;
			this.Visible = false;

			// Запись сведений о том, что в данный момент плеер работает.

			// Поток файла статуса показа главной формы.
			FileStream statusFileStream = new FileStream
				( this._MainFormShowingStatusFilePath, FileMode.Create,
				FileAccess.Write, FileShare.Read );
			// Писатель файлового потока статуса показа главной формы.
			StreamWriter statusFileStreamWriter =
				new StreamWriter( statusFileStream );
			// Запись статуса рабочего состояния плеера в файл.
			statusFileStreamWriter.Write( MainFormShowingStatus.OPEN );
			statusFileStreamWriter.Flush( );
			statusFileStreamWriter.Close( );

			InitializeComponent( );

			// Создание невидимой формы звука.
			this._FormSound = new FormSound( );
			this._FormSound.TrackbarSoundValueChanged +=
				new EventHandler( this.OnFormSoundTrackbar );

			// Загрузка параметров из xml-файла.
			this.LoadSettings( );

			this._SkinButtonPlay.Enabled = this._SkinButtonPause.Enabled =
				this._SkinButtonFullScreen.Enabled =
				this._SkinButtonSmallScreen.Enabled =
				/*this._SkinButtonStop.Enabled =*/ false;

			// Если медиа-тип - аудио.
			if ( this._MediaTypeName == MediaTypes.AUDIO )
				this._Aspect = 0;
			else
				this._Aspect = ( float ) this._PanelScreen.ClientSize.Width /
					( ( float ) this._PanelScreen.ClientSize.Height );
			Size movieArea = new Size( this.Width - this.ClientSize.Width,
				this.Height - this.ClientSize.Height );
			this._InitialClientWidth = this.ClientSize.Width;

			/*
			this.MinimumSize = new Size(this.Width, MovieArea.Height +
				Movie_Menu.Height + CommandPanel.Height + 1);
			CommandPanelHeight = CommandPanel.Height;
			*/
			/*
			this.MinimumSize = new Size(this.Width, MovieArea.Height +
				_MenuStrip.Height + _TableLayoutPanelCommand.Height + 1);
			*/

			this.MinimumSize = new Size( this.Width,
				movieArea.Height + this._TableLayoutPanelCommand.Height + 1 );
			this._CommandPanelHeight = this._TableLayoutPanelCommand.Height;

			/*
			FORM_Tooltip.SetToolTip(BTN_Play, "Play");
			FORM_Tooltip.SetToolTip(BTN_Pause, "Pause");
			FORM_Tooltip.SetToolTip(_SkinButtonStop, "Stop");
			FORM_Tooltip.SetToolTip(_SkinButtonMuteOn, "Mute");
			FORM_Tooltip.SetToolTip(_SkinButtonMuteOff, "Mute");
			FORM_Tooltip.SetToolTip(_TrackMovie, "Search");
			FORM_Tooltip.SetToolTip(_TrackSound, "Volume");
			FORM_Tooltip.SetToolTip(_SkinButtonFullScreen, "Full screen");
			*/

			// Drag & drop 
			DragAcceptFiles( );

			// Check registry for latest audio volume being used
			Double audiovolume = Convert.ToDouble( Registry.GetValue
				( Program.RegistryKey, Program.RegistryAudioVolume, -1 ) );
			if ( audiovolume > -1.0f )
				/*this._SkinTrackbarSound.Value = audiovolume;*/
				this._FormSound.TrackbarSoundValue = audiovolume;

			this._TimerMedia.Enabled = true;

			/*
			// Check if MediaFile matches a valid movie name, if YES then play it
			CheckMovieName(MediaFile.ToLower());
			*/

			// Перерисовка треков прокрутки,
			// чтобы не было странных полос на грницах.
			this.OnSkinTrackbarDurationMouseLeave( null, null );
			this.OnFormSoundTrackbar( null, null );

			// Назначение картинок скруглений для треков прокрутки.
			/*this._SkinTrackbarDuration.PictureBoxLeftOrTopBorder =
				this._PictureBoxTrackbarDurationLeftBorder;
			this._SkinTrackbarSound.PictureBoxLeftOrTopBorder =
				this._PictureBoxTrackbarSoundLeftBorder;
			this._SkinTrackbarDuration.PictureBoxRightOrBottomBorder =
				this._PictureBoxTrackbarDurationRightBorder;
			this._SkinTrackbarSound.PictureBoxRightOrBottomBorder =
				this._PictureBoxTrackbarSoundRightBorder;*/

			// Картинка, куда копируется изображение формы.
			this._PictureBoxFormImageCopy.Visible = false;
			this._PictureBoxFormImageCopy.Parent = this;
			// Картинка уменьшенного изображения формы.
			this._PictureBoxFormImageSmallCopy.Visible = false;
			// Цвет фона формы - временный цвет прозрачности.
			this.BackColor = this.TemporaryTransparencyKey;

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
		} // FormMain


		#region Methods


		/// <summary>
		/// Определение строки-разделителя между целой
		/// и дробной частями десятичного числа.
		/// </summary>
		/// <returns>Разделитель между целой и дробной частями
		/// десятичного числа.</returns>
		private string DefineIntegerAndDecimalPartsSeparator( )
		{
			// Вызов метода класса.
			Program.MainTracer.CallClassMethod( FormMain.CLASS_NAME,
				"DefineIntegerAndDecimalPartsSeparator" );

			// Строка примера дробного десятичного числа 0.1.
			string exampleFloatString;
			// Пример дробного десятичного числа 0.1.
			float exampleFloat;

			try
			{
				// Попытка перевода строки "0.1" в десятичное число 0.1.
				exampleFloatString = FormMain.ZERO + FormMain.POINT + FormMain.ONE;
				exampleFloat = Convert.ToSingle( exampleFloatString );
				// Если преобразование из строки в число прошло успешно,
				// то разделитель между целой и дробной частями
				// десятичного числа - точка.
				return FormMain.POINT;
			} // try

			catch
			{
				try
				{
					// Попытка перевода строки "0,1" в десятичное число 0.1.
					exampleFloatString = FormMain.ZERO + FormMain.COMMA + FormMain.ONE;
					exampleFloat = Convert.ToSingle( exampleFloatString );
					// Если преобразование из строки в число прошло успешно,
					// то разделитель между целой и дробной частями
					// десятичного числа - запятая.
					return FormMain.COMMA;
				} // try

				catch
				{
					// Послание сообщения об ошибке.
					Program.MainTracer.SendErrorMessage( FormMain.
						UNKNOWN_INTEGER_AND_DECIMAL_PARTS_SEPARATOR_MESSAGE );
					// Выводится сообщение о неизвестной строке-разделителе
					// между целой и дробной частями десятичного числа,
					// установленной в системе, и форма закрывается.
					MessageBox.Show( FormMain.
						UNKNOWN_INTEGER_AND_DECIMAL_PARTS_SEPARATOR_MESSAGE );
					this.Close( );
					return string.Empty;
				} // catch
			} // catch
		} // DefineIntegerAndDecimalPartsSeparator

		/// <summary>
		/// Получение строки десятичной дроби из текста XML-элемента.
		/// </summary>
		/// <param name="parXmlElement">XML-элемент.</param>
		/// <returns>Строка десятичной дроби.</returns>
		private string GetFloatStringFromXmlElement( XmlElement parXmlElement )
		{
			// Вызов метода класса.
			Program.MainTracer.CallClassMethod( FormMain.CLASS_NAME,
				"GetFloatStringFromXmlElement", parXmlElement.InnerText.Trim( ) );

			// Из XML-элемента извлекается внутреннее текстовое содержимое,
			// убираются символы табуляции по краям
			// и системная десятичная точка заменяется на десятичную точку,
			// принятую в C# - ".".
			return parXmlElement.InnerText.Trim( ).
				Replace( FormMain.POINT, this._SystemDecimalPoint );
		} // GetFloatStringFromXmlElement

		/// <summary>
		/// Загрузка параметров из xml-файла.
		/// </summary>
		private void LoadSettings( )
		{
			// Вызов метода класса.
			Program.MainTracer.CallClassMethod( FormMain.CLASS_NAME,
				"LoadSettings" );

			try
			{
				// Xml-документ устновок.
				XmlDocument settings = null;
				// Корень Xml-документа - его первый узел.
				XmlNode settingsRoot = null;

				// Xml-документ устновок.
				settings = new XmlDocument( );
				// Загрузка Xml-документа из файла.
				settings.Load( this._SettingsFilePath );
				// Корень Xml-документа - его первый узел.
				settingsRoot = settings.FirstChild;

				// Системная десятичная точка - строка-разделитель между целой
				// и дробной частями десятичного числа, принятая в системе.
				this._SystemDecimalPoint =
					this.DefineIntegerAndDecimalPartsSeparator( );

				// Размещение.
				this.Location = new Point
				(
					// Абсцисса.
					Convert.ToInt32( this.GetFloatStringFromXmlElement
						( settingsRoot[ "X" ] ) ),
					// Ордината.
					Convert.ToInt32( this.GetFloatStringFromXmlElement
						( settingsRoot[ "Y" ] ) )
				); // this.Location

				// Ширина.
				this.Width = Convert.ToInt32( this.GetFloatStringFromXmlElement
					( settingsRoot[ "Width" ] ) );
				// Высота.
				this.Height = Convert.ToInt32( this.GetFloatStringFromXmlElement
					( settingsRoot[ "Height" ] ) );

				// Доля ширины трека прокрутки длительности от ширины командной панели.
				this._DurationTrackbarWidthToCommandPanelWidthRatio =
					Convert.ToSingle( this.GetFloatStringFromXmlElement( settingsRoot
					[ "DurationTrackbarWidthToCommandPanelWidthRatio" ] ) );

				// Ширина кнопки плеера.
				int buttonWidth = ( int ) Math.Round( ( this.Width * ( 1 -
					this._DurationTrackbarWidthToCommandPanelWidthRatio ) -
					2 * FormMain.BORDER_WIDTH ) / ( 3 + 2 *
					FormMain.TRACKBAR_VERTICAL_BORDER_WIDTH_TO_BUTTON_WIDTH_RATIO ) );

				// Ширина трека прокрутки длительности.
				float trackbarDurationWidth = this.Width *
					this._DurationTrackbarWidthToCommandPanelWidthRatio;
				// Минимальная ширина трека прокрутки длительности
				// относительно ширины кнопки.
				float trackbarDurationMinimumWidth = buttonWidth *
					FormMain.TRACKBAR_GREATER_SIDE_MINIMUM_LENGHT_TO_BUTTON_WIDTH_RATIO;

				// Если ширина трека прокрутки оказалась меньше минимальной
				// относительно ширины кнопки, то ширина кнопки
				// и ширина трека прокрутки длительности пересчитываются,
				// ориентируясь на установку минимальной ширины
				// трека прокрутки длительности.
				if ( trackbarDurationWidth < trackbarDurationMinimumWidth )
				{
					// Ширина кнопки плеера.
					buttonWidth = ( int ) Math.Round( ( this.Width - 2 *
						FormMain.BORDER_WIDTH ) / ( 3 + 2 * FormMain.
						TRACKBAR_VERTICAL_BORDER_WIDTH_TO_BUTTON_WIDTH_RATIO + FormMain.
						TRACKBAR_GREATER_SIDE_MINIMUM_LENGHT_TO_BUTTON_WIDTH_RATIO ) );
					// Ширина трека прокрутки длительности.
					trackbarDurationWidth = buttonWidth * FormMain.
						TRACKBAR_GREATER_SIDE_MINIMUM_LENGHT_TO_BUTTON_WIDTH_RATIO;
				} // if

				// Доля ширины кнопки плеера от её высоты.
				float buttonWidthToHeightRatio = Convert.ToSingle
					( this.GetFloatStringFromXmlElement
					( settingsRoot[ "ButtonWidthToHeightRatio" ] ) );
				// Высота кнопки плеера.
				int buttonHeight = ( int ) Math.Round( buttonWidth /
					buttonWidthToHeightRatio );

				// Высота командной панели, занимающей нижнюю часть плеера
				// и содержащей все элементы управления - высота кнопки
				// и двух бордюров - верхнего и нижнего.
				this._TableLayoutPanelForm.RowStyles[ 1 ].Height =
					buttonHeight + 2 * FormMain.BORDER_WIDTH;
				// Высота трека прокрутки длительности и высота кнопок -
				// высота кнопки.
				this._TableLayoutPanelFillCommand.RowStyles[ 1 ].Height =
					buttonHeight;

				// URL-адрес медиа-файла для проигрывания..
				this._MediaFileURL = settingsRoot[ "MediaFileURL" ].
					InnerText.Trim( );
				// Mедиа-тип, указывающий является ли файл аудио или видео.
				this._MediaTypeName = settingsRoot[ "MediaTypeName" ].
					InnerText.Trim( );

				// Если медиа-тип - аудио, то командная панель занимает всю форму,
				// так что высота формы приравнивается к высоте командной панели,
				// а экран проигрывания прячется.
				if ( this._MediaTypeName == MediaTypes.AUDIO )
				{
					// Высота командной панели (целое число).
					int panelCommandHeight = ( int )
						this._TableLayoutPanelForm.RowStyles[ 1 ].Height;
					// Разность между первоначальной заданной высотой
					// и высотой командной панели.
					int heightDifference = this.Height - panelCommandHeight;
					// Новая высота формы - высота командной панели.
					this.Height = panelCommandHeight;
					// Ордината формы смещается, чтобы нижняя грань
					// осталась на своём месте.
					this.Location = new Point( this.Location.X,
						this.Location.Y + heightDifference );
					// Панель эрана проецирования видео не видна.
					this._TableLayoutPanelScreen.Visible = false;
				} // if

				// Высота бегунка трека длительности - высота трека длительности.
				this._SkinTrackbarDuration.ThumbHeight =
					this._SkinTrackbarDuration.ClientRectangle.Height;
				// Ширина бегунка трека длительности - ширина кнопки.
				this._SkinTrackbarDuration.ThumbWidth = buttonWidth;

				// Ширина ячейки кнопки звука - ширина кнопки.
				this._TableLayoutPanelFillCommand.ColumnStyles[ 0 ].Width =
					buttonWidth;
				// Ширина ячейки кнопок паузы и проигрывания - ширина кнопки.
				this._TableLayoutPanelFillCommand.ColumnStyles[ 4 ].Width =
					buttonWidth;
				// Ширина ячейки кнопок полноэкранного и нормального режимов -
				// ширина кнопки.
				if ( this._MediaTypeName == MediaTypes.AUDIO )
					this._TableLayoutPanelFillCommand.ColumnStyles[ 5 ].Width = 0;
				else
					this._TableLayoutPanelFillCommand.ColumnStyles[ 5 ].Width =
						buttonWidth;
				// Ширина ячейки кнопки выхода - ширина кнопки.
				this._TableLayoutPanelFillCommand.ColumnStyles[ 6 ].Width =
					buttonWidth;

				// Ширина вертикальной границы горизонтального трека прокрутки.
				float trackbarVerticalBorderWidth = buttonWidth *
					FormMain.TRACKBAR_VERTICAL_BORDER_WIDTH_TO_BUTTON_WIDTH_RATIO;
				// Ширина левой границы трека прокрутки длительности.
				this._TableLayoutPanelFillCommand.ColumnStyles[ 1 ].Width =
					trackbarVerticalBorderWidth;
				// Ширина правой границы трека прокрутки длительности.
				this._TableLayoutPanelFillCommand.ColumnStyles[ 3 ].Width =
					trackbarVerticalBorderWidth;

				// Интервал в миллисекундах таймера закрытия плеера - интервал
				// между наступлением паузы или остановки проигрывания меда-файла
				// и моментом закрытия плеера, который считается бездействующим.
				this._TimerFormClosing.Interval = Convert.ToInt32
					( this.GetFloatStringFromXmlElement
					( settingsRoot[ "PlayerClosingTimerDelay" ] ) );
				// Время в миллисекундах длительности эффекта изменения видимости -
				// время, в течение которого осуществляется эффект появления
				// или исчезновения формы.
				this.VisibleChangingEffectTime = Convert.ToInt32
					( this.GetFloatStringFromXmlElement
					( settingsRoot[ "VisibleChangingEffectTime" ] ) );
				// Интервал в миллисекундах таймера эффекта изменения видимости.
				this.VisibleChangingEffectTimerInterval = Convert.ToInt32
					( this.GetFloatStringFromXmlElement
					( settingsRoot[ "VisibleChangingEffectTimerDeley" ] ) );
				// Интервал в миллисекундах таймера эффекта показа формы.
				this._TimerFormShowingEffect.Interval =
					this.VisibleChangingEffectTimerInterval;
				// Интервал в миллисекундах таймера эффекта сокрытия формы.
				this._TimerFormHidingEffect.Interval =
					this.VisibleChangingEffectTimerInterval;

				// Форма звука.

				// Ширина формы звука - ширина кнопки плеера и правого бордюра формы.
				// Дополнительная переменная создаётся, потому что значение
				// по ходу выполнения программы почему-то теряется
				// и его надо восстнавливать.
				this._FormSoundWidth = buttonWidth + FormMain.BORDER_WIDTH;
				this._FormSound.Width = this._FormSoundWidth;

				float soundFormHeightToCommandPanelWidthRatio = Convert.ToSingle
					( this.GetFloatStringFromXmlElement( settingsRoot
					[ "SoundFormHeightToCommandPanelWidthRatio" ] ) );
				// Высота формы звука.
				float formSoundHeight = this.Width *
					soundFormHeightToCommandPanelWidthRatio;
				// Минимальная высота формы звука.
				this._FormSound.MinimumHeight = ( int ) Math.Round
					( 2 * FormMain.BORDER_WIDTH + buttonWidth * ( 2 * FormMain.
					TRACKBAR_VERTICAL_BORDER_WIDTH_TO_BUTTON_WIDTH_RATIO + FormMain.
					TRACKBAR_GREATER_SIDE_MINIMUM_LENGHT_TO_BUTTON_WIDTH_RATIO ) );
				// Высота формы звука - максимальная из минимальной и полученной.
				this._FormSound.Height = ( int ) Math.Max( formSoundHeight,
					this._FormSound.MinimumHeight );
				// Максимальная высота формы звука - полученная.
				this._FormSound.MaximumHeight = this._FormSound.Height;
				// Видимая высота формы звука - полученная.
				this._FormSound.VisibleHeight = this._FormSound.Height;

				// Ширина трека прокрутки звука - высота кнопки плеера,
				// так как трек прокрутки вертикальный, а не горизонтальный.
				this._FormSound.TrackbarSoundWidth = buttonHeight;
				// Высота горизонтальной границы вертикального трека прокрутки звука.
				this._FormSound.TrackbarSoundBorderHeight =
					trackbarVerticalBorderWidth;
				// Бегнок прокрутки звука на вертикальном треке рорутки звука
				// должен иметь размеры повёрнутой кнопки.
				// Ширина бегунка трека прокрутки звука - высота кнопки.
				this._FormSound.TrackbarSoundThumbWidth = buttonHeight;
				// Высота бегунка трека прокрутки звука - ширина кнопки.
				this._FormSound.TrackbarSoundThumbHeight = buttonWidth;

				// Кнопка, вызывающая форму звука - кнопка звука.
				this._FormSound.ButtonOpen = this._SkinButtonSound;
				// Интервал в миллисекундах таймера сокрытия формы звука -
				// интервал между моментом покидания кнопки звука
				// или формы звука курсором мыши и моментом сокрытия формы звука.
				this._FormSound.TimerFormHidingInterval = Convert.ToInt32
					( this.GetFloatStringFromXmlElement
					( settingsRoot[ "SoundFormHidingTimerDeley" ] ) );

				// Интервал в миллисекундах таймера эффекта
				// изменения видимости формы звука.
				this._FormSound.TimerFormVisibleChangingEffectInterval =
					this.VisibleChangingEffectTimerInterval;
				// Время в миллисекундах длительности эффекта
				// изменения видимости формы звука -
				// время, в течение которого осуществляется эффект
				// появления или исчезновения формы звука.
				this._FormSound.VisibleChangingEffectTime =
					this.VisibleChangingEffectTime;

				// Признак активности таймера эффекта изменения видимости формы звука
				// сначала ложен - для первого пробного показа эффекты не нужны,
				// а потом станет истинен для интерактивного показа.
				this._FormSound.TimerFormVisibleChangingEffectIsActive = false;
				// После пробного появления формы звука, она будет исчезать -
				// для исчезновения эффект не стоит возобновлять.
				this._FormSound.TimerFormVisibleChangingEffectShouldActivate = false;
				// Для пробного показа форма полностью прозрачна, что бы не мелькала.
				this._FormSound.Opacity = 0;
				// Для правильного последующего выравнивания формы звука
				// её почему-то надо сначала показать 1 раз.
				this._FormSound.Show( this );
				// После первого исчезновения формы звука в дальнейшем
				// она будет появляться и исезать с эфффектом.
				this._FormSound.TimerFormVisibleChangingEffectShouldActivate = true;
				this._FormSound.Hide( );
			} // try

			catch ( Exception e )
			{
				// Послание сообщения об ошибке.
				Program.MainTracer.SendErrorMessage( e.Message );
				// Выводится сообщение об ошибке и форма закрывается.
				MessageBox.Show( FormMain.ERROR_IS_OCCURRED_MESSAGE + e.Message );
				this.Close( );
			} // catch
		} // LoadSettings

		protected override void WndProc( ref Message m )
		{
			string MediaFile = string.Empty;
			switch ( m.Msg )
			{
				case Api.WM_DROPFILES: // Drag & drop
					uint hDrop = ( uint ) m.WParam;
					int FilesDropped = Api.DragQueryFile( hDrop, -1, null, 0 );
					if ( FilesDropped != 0 )
					{
						StringBuilder sFileName = new StringBuilder( Api.MAX_PATH );
						//for (int i = 0; i < FilesDropped; i++)
						//{
						//    Api.DragQueryFile(hDrop, i, sFileName, Api.MAX_PATH);
						//    MediaFile = sFileName.ToString().ToLower(); break;
						//}
						Api.DragQueryFile( hDrop, 0, sFileName, Api.MAX_PATH );
						MediaFile = sFileName.ToString( ).ToLower( );
					}
					Api.DragFinish( hDrop );
					// Check if MediaFile matches a valid movie name, if YES then play it
					CheckMovieNameAndPlay( MediaFile );
					break;

				case Api.WM_CLOSE:
					/*UpdateRegistryAudioVolume( _SkinTrackbarSound.Value );*/
					UpdateRegistryAudioVolume( this._FormSound.TrackbarSoundValue );
					break;

				case Api.WM_STRINGDATA:
					MediaFile = ( string ) Registry.GetValue( Program.RegistryKey,
						Program.RegistryStringData, string.Empty );
					// Check if MediaFile matches a valid movie name, if YES then play it
					CheckMovieNameAndPlay( MediaFile );
					break;
			}
			base.WndProc( ref m );
		} // WndProc

		/// <summary>
		/// Проверка правильности пути и запуск видео-файла.
		/// </summary>
		/// <param name="parMovieFile">Имя видео-файла.</param>
		private void CheckMovieNameAndPlay( string parMovieFile )
		{
			// Вызов метода класса.
			Program.MainTracer.CallClassMethod( FormMain.CLASS_NAME,
				"CheckMovieNameAndPlay", parMovieFile );

			if ( parMovieFile.Length != 0 )
				foreach ( string movieExtension in this._MoviesExtensions )
					if ( parMovieFile.EndsWith( movieExtension ) )
					{
						this.PlayMovie( parMovieFile );
						return;
					} // if
		} // CheckMovieNameAndPlay

		/// <summary>
		/// Проверка правильности пути и запуск аудио-файла.
		/// </summary>
		/// <param name="parAudioFile">Имя аудио-файла.</param>
		private void CheckAudioNameAndPlay( string parAudioFile )
		{
			// Вызов метода класса.
			Program.MainTracer.CallClassMethod( FormMain.CLASS_NAME,
				"CheckAudioNameAndPlay", parAudioFile );

			if ( parAudioFile.Length != 0 )
				foreach ( string audioExtension in this._AudiosExtensions )
					if ( parAudioFile.EndsWith( audioExtension ) )
					{
						this.PlayAudio( parAudioFile );
						return;
					} // if
		} // CheckAudioNameAndPlay

		private void DragAcceptFiles( )
		{
			// Вызов метода класса.
			Program.MainTracer.CallClassMethod( FormMain.CLASS_NAME,
				"DragAcceptFiles" );

			Api.DragAcceptFiles( hFORM_Main, true );
		} // DragAcceptFiles

		/// <summary>
		/// Получение строки отображения времени в часах, минутах и секундах
		/// в формате HH:MM:SS.
		/// </summary>
		/// <param name="parMediaPlaybackPosition">
		/// Позиция проигрывания медиа-файла.</param>
		/// <returns>Строка времени в формате HH:MM:SS.</returns>
		private string GetHoursMinutesSecondsString( int parMediaPlaybackPosition )
		{
			this._Hours = parMediaPlaybackPosition / FormMain.SECONDS_IN_HOUR;
			this._Minutes = ( parMediaPlaybackPosition - this._Hours *
				FormMain.SECONDS_IN_HOUR ) / FormMain.SECONDS_IN_MINUTE;
			this._Seconds = ( parMediaPlaybackPosition - this._Hours *
				FormMain.SECONDS_IN_HOUR - this._Minutes * FormMain.SECONDS_IN_MINUTE );

			string hh = ( FormMain.DOUBLE_ZERO + this._Hours.ToString( ) );
			hh = hh.Substring( hh.Length - 2, 2 );
			string mm = ( FormMain.DOUBLE_ZERO + this._Minutes.ToString( ) );
			mm = mm.Substring( mm.Length - 2, 2 );
			string ss = ( FormMain.DOUBLE_ZERO + this._Seconds.ToString( ) );
			ss = ss.Substring( ss.Length - 2, 2 );

			return hh + FormMain.COLON + mm + FormMain.COLON + ss;
		} // GetHoursMinutesSecondsString


		#region Getting Media Values


		/// <summary>
		/// Получение значения бегунка медиа-файла по текущей позиции медиа-файла.
		/// </summary>
		/// <returns>Значение бегунка медиа-файла.</returns>
		private double GetTrackbarMediaValueFromMediaurrentPosition( )
		{
			return FormMain.TRACK_VALUE__MEDIA_POSITION__MULTIPLIER *
				this._MediaCurrentPosition;
		} // GetTrackbarMediaValueFromMediaurrentPosition

		/// <summary>
		/// Получение текущей позиции медиа-файла из значения бегунка
		/// для длительности медиа-файла.
		/// </summary>
		/// <returns>Текущая позиция медиа-файла.</returns>
		private double GetMediaCurrentPositionFromTrackbarDurationValue( )
		{
			return ( double ) ( ( double ) this._SkinTrackbarDuration.Value /
				( double ) FormMain.TRACK_VALUE__MEDIA_POSITION__MULTIPLIER );
		} // GetMediaCurrentPositionFromTrackbarDurationValue

		/// <summary>
		/// Получение значения бегунка аудио по громкости звука.
		/// </summary>
		/// <returns>Громкость звука.</returns>
		private double GetTrackbarSoundValueFromAudioVolume( )
		{
			// Вызов метода класса.
			Program.MainTracer.CallClassMethod( FormMain.CLASS_NAME,
				"GetTrackbarSoundValueFromAudioVolume" );

			if ( this._Movie != null )
				return ( double ) ( ( ( double ) this._Movie.Audio.Volume ) /
					( ( double ) 50 ) + ( ( double ) 100 ) );
			else
				if ( this._Audio != null )
					return ( double ) ( ( ( double ) this._Audio.Volume ) /
					( ( double ) 50 ) + ( ( double ) 100 ) );
				else
				{
					Double audiovolume = Convert.ToDouble( Registry.GetValue
						( Program.RegistryKey, Program.RegistryAudioVolume, -1 ) );
					if ( audiovolume > -1.0f )
						return ( double ) audiovolume;
					else
						return 0;
				} // else
		} // GetTrackbarSoundValueFromAudioVolume

		/// <summary>
		/// Получение громкости звука из значения бегунка для звука.
		/// </summary>
		/// <returns>Громкость звука.</returns>
		private int GetAudioVolumeFromTrackbarSoundValue( )
		{
			//return Convert.ToInt32( ( 100 - this._SkinTrackbarSound.Value ) * -50 );
			return Convert.ToInt32( ( 100 -
				this._FormSound.TrackbarSoundValue ) * -50 );
		} // GetAudioVolumeFromTrackbarSoundValue


		#endregion Getting Media Values


		/// <summary>
		/// Показ прелоадера.
		/// </summary>
		private void ShowPreloader( )
		{
			// Картинка прелоадера пока не видна.
			this._PictureBoxPreloader.Visible = false;
			this._PictureBoxPreloader.Parent = this._PanelScreen;
			// Максимальная длина стороны картинки прелоадера.
			int imageSideMaximumLength = ( int ) Math.Round( Math.Min
				( this._PanelScreen.Width, this._PanelScreen.Height ) * FormMain.
				PRELOADER_SIDE_MAXIMUM_LENGHT_TO_SCREEN_SMALLER_SIDE_LENGHT_RATIO );

			// Размер изобржения - минимальный.
			int imageSize = this._PreloadersImagesSizes[ 0 ];
			// Последовательно просматриваются все размеры изображений по убыванию:
			// если максимальная длина стороны картинки прелоадера превышает
			// текущий размер, то он устанавливается.
			// Если все размеры, кроме минимального пройдены безуспешно,
			// то размер так и остаётся минимальным.
			for ( int imageSizeIndex = this._PreloadersImagesSizes.Length - 1;
					imageSizeIndex > 0; imageSizeIndex-- )
				if ( imageSideMaximumLength >= this._PreloadersImagesSizes
					[ imageSizeIndex ] )
				{
					imageSize = this._PreloadersImagesSizes[ imageSizeIndex ];
					break;
				} // if

			// Устновка размеров квадратного изображения.
			this._PictureBoxPreloader.Width = imageSize;
			this._PictureBoxPreloader.Height = imageSize;

			// По установленному размеру изображения выбирается картинка.
			switch ( imageSize )
			{
				// 64.
				case 64:
					this._PictureBoxPreloader.Image = Properties.Resources.Preloader64;
					break;

				// 128.
				case 128:
					this._PictureBoxPreloader.Image = Properties.Resources.Preloader128;
					break;

				// 192.
				case 192:
					this._PictureBoxPreloader.Image = Properties.Resources.Preloader192;
					break;

				// 32, минимальный размер, для прочих.
				default:
					this._PictureBoxPreloader.Image = Properties.Resources.Preloader32;
					break;
			} // switch

			// Прелоадер размещается в центре экрана показа.
			this._PictureBoxPreloader.Location = new Point
			(
				( this._PanelScreen.Width - imageSize ) / 2,
				( this._PanelScreen.Height - imageSize ) / 2
			); // new Point

			// Картинка прелоадера становится видимой.
			this._PictureBoxPreloader.Visible = true;
		} // ShowPreloader

		/// <summary>
		/// Проигрывание видео-файла.
		/// </summary>
		/// <param name="parMovieFile">Имя видео-файла.</param>
		private void PlayMovie( string parMovieFile )
		{
			// Вызов метода класса.
			Program.MainTracer.CallClassMethod( FormMain.CLASS_NAME, "PlayMovie",
				parMovieFile );

			if ( this._Movie != null )
				this.OnFormClosing( null, null ); // 04-29-2007

			//Movie_Timer.Enabled = false;
			this._TimerMediaEnabled = false;
			// Отключение таймера закрытия формы -
			// если пользователь ничего не делает, но медиа-файл проигрывается,
			// то считается, что пользователь слушает и/или смотрит его.
			this._TimerFormClosing.Enabled = false;

			this._SkinTrackbarDuration.Enabled = false;
			this._SkinTrackbarDuration.Value = 0;
			this._SkinButtonPlay.Enabled = this._SkinButtonPause.Enabled =
				this._SkinButtonFullScreen.Enabled =
				this._SkinButtonSmallScreen.Enabled =
				/*this._SkinButtonStop.Enabled =*/ false;

			string movieName = parMovieFile;
			int lastIndex = movieName.LastIndexOf( FormMain.BACKSLASH );
			movieName = movieName.Substring( lastIndex + 1,
				( movieName.Length - lastIndex - 1 ) );

			// Появление панели экрана и покрытие ей отведёного ей ространства.
			this._PanelScreen.Location = new Point( 0, 0 );
			this._PanelScreen.Width = this.Width - 2 * FormMain.BORDER_WIDTH;
			this._PanelScreen.Height = this.Height -
				this._TableLayoutPanelCommand.Height - FormMain.BORDER_WIDTH;
			this._PanelScreen.Visible = true;
			// Показ прелоадера.
			this.ShowPreloader( );

			try
			{
				this._Movie = new Video( parMovieFile );
			} // try
			catch( Exception e )
			{
				// Послание сообщения об ошибке.
				Program.MainTracer.SendErrorMessage( FormMain.UNABLE_TO_PLAY_MESSAGE +
					movieName + FormMain.NEW_LINE + FormMain.ERROR_IS_OCCURRED_MESSAGE +
					e.Message );
				// Выводится сообщение об ошибке и форма закрывается.
				MessageBox.Show( FormMain.UNABLE_TO_PLAY_MESSAGE + movieName +
					FormMain.NEW_LINE + FormMain.ERROR_IS_OCCURRED_MESSAGE +
					e.Message );
				this.Close( );
				return;
			} // catch

			//Size MovieMinimumIdealSize = Movie.MinimumIdealSize;

			this._MovieDefaultSize = this._Movie.DefaultSize;
			int useWidth = Math.Max( this._MovieDefaultSize.Width,
				this._InitialClientWidth );
			int useHeight = this._MovieDefaultSize.Height;
			this._Aspect = ( float ) ( ( float ) this._MovieDefaultSize.Width /
				( float ) this._MovieDefaultSize.Height );

			this._HDmovie = false;
			// Detect HD movie
			if ( useWidth >= 1200 )
			{
				useWidth = ( int ) ( useWidth * .5f );
				useHeight = ( int ) ( useHeight * .5f );
				this._HDmovie = true;
			} // if

			/*
			this.ClientSize = new Size(UseWidth, UseHeight + _MenuStrip.Height + _TableLayoutPanelCommand.Height);

			// Не будем изменять рабочую область, пусть будет такая,
			// какая задана, согласно файлу настроек.
			this.ClientSize = new Size( useWidth, useHeight +
				this._TableLayoutPanelCommand.Height );
			*/

			// Картинка прелоадера прячется.
			this._PictureBoxPreloader.Visible = false;

			this._Movie.Owner = this._PanelScreen;
			this._SkinTrackbarDuration.Enabled = true;
			this._SkinTrackbarDuration.Value = 0;
			this._MediaDurationValue = ( int ) this._Movie.Duration;
			this._SkinTrackbarDuration.Maximum =
				FormMain.TRACK_VALUE__MEDIA_POSITION__MULTIPLIER *
				this._MediaDurationValue;
			this._MediaDurationString =
				this.GetHoursMinutesSecondsString( this._MediaDurationValue );
			/*
			durationTime.Text = "/  " + movieDuration;
			*/

			if ( this._MuteMode )
				// 04-29-2007
				this._Movie.Audio.Volume = FormMain.MINIMUM_AUDIO_VOLUME;
			else
				this._Movie.Audio.Volume =
					this.GetAudioVolumeFromTrackbarSoundValue( );

			this.Text = movieName.ToLower( );

			this._SkinButtonPlay.Visible = false;
			this._SkinButtonPause.Visible = true;
			this._SkinButtonFullScreen.Visible = true;
			this._SkinButtonSmallScreen.Visible = false;
			this._SkinButtonPause.Enabled =
				/*this._SkinButtonStop.Enabled =*/
				this._SkinButtonFullScreen.Enabled = true;

			//if (HDmovie)
			this.OnResize( null, null );

			try
			{
				this._Movie.Play( );
			} // try
			catch( Exception e )
			{
				// Послание сообщения об ошибке.
				Program.MainTracer.SendErrorMessage( e.Message );
				// Выводится сообщение об ошибке и форма закрывается.
				MessageBox.Show( FormMain.ERROR_IS_OCCURRED_MESSAGE + e.Message );
				this.Close( );
				return;
			} // catch

			//Movie_Timer.Enabled = true;
			this._TimerMediaEnabled = true;
		} // PlayThisMovie

		/// <summary>
		/// Проигрывание аудио-файла.
		/// </summary>
		/// <param name="parAudioFile">Имя аудио-файла.</param>
		private void PlayAudio( string parAudioFile )
		{
			// Вызов метода класса.
			Program.MainTracer.CallClassMethod( FormMain.CLASS_NAME, "PlayAudio",
				parAudioFile );

			if ( this._Audio != null )
				this.OnFormClosing( null, null ); // 04-29-2007

			//Movie_Timer.Enabled = false;
			this._TimerMediaEnabled = false;
			// Отключение таймера закрытия формы -
			// если пользователь ничего не делает, но медиа-файл проигрывается,
			// то считается, что пользователь слушает и/или смотрит его.
			this._TimerFormClosing.Enabled = false;

			this._SkinTrackbarDuration.Enabled = false;
			this._SkinTrackbarDuration.Value = 0;
			this._SkinButtonPlay.Enabled = this._SkinButtonPause.Enabled =
				this._SkinButtonFullScreen.Enabled =
				this._SkinButtonSmallScreen.Enabled =
				/*this._SkinButtonStop.Enabled =*/ false;

			string audioName = parAudioFile;
			int lastIndex = audioName.LastIndexOf( FormMain.BACKSLASH );
			audioName = audioName.Substring( lastIndex + 1,
				( audioName.Length - lastIndex - 1 ) );

			try
			{
				this._Audio = new Audio( parAudioFile );
			} // try
			catch( Exception e )
			{
				// Послание сообщения об ошибке.
				Program.MainTracer.SendErrorMessage( FormMain.UNABLE_TO_PLAY_MESSAGE +
					audioName + FormMain.NEW_LINE + FormMain.ERROR_IS_OCCURRED_MESSAGE +
					e.Message );
				// Выводится сообщение об ошибке и форма закрывается.
				MessageBox.Show( FormMain.UNABLE_TO_PLAY_MESSAGE + audioName +
					FormMain.NEW_LINE + FormMain.ERROR_IS_OCCURRED_MESSAGE +
					e.Message );
				this.Close( );
				return;
			} // catch

			this._SkinTrackbarDuration.Enabled = true;
			this._SkinTrackbarDuration.Value = 0;
			this._MediaDurationValue = ( int ) this._Audio.Duration;
			this._SkinTrackbarDuration.Maximum =
				FormMain.TRACK_VALUE__MEDIA_POSITION__MULTIPLIER *
				this._MediaDurationValue;
			this._MediaDurationString =
				this.GetHoursMinutesSecondsString( this._MediaDurationValue );
			/*
			durationTime.Text = "/  " + movieDuration;
			*/

			if ( this._MuteMode )
				// 04-29-2007
				this._Audio.Volume = FormMain.MINIMUM_AUDIO_VOLUME;
			else
				this._Audio.Volume = this.GetAudioVolumeFromTrackbarSoundValue( );

			this.Text = audioName.ToLower( );

			this._SkinButtonPlay.Visible = false;
			this._SkinButtonPause.Visible = true;
			this._SkinButtonFullScreen.Visible = false;
			this._SkinButtonSmallScreen.Visible = false;
			this._SkinButtonPause.Enabled /*= this._SkinButtonStop.Enabled*/ =
				this._SkinButtonFullScreen.Enabled = true;

			this.OnResize( null, null );

			try
			{
				this._Audio.Play( );
			} // try
			catch( Exception e )
			{
				// Послание сообщения об ошибке.
				Program.MainTracer.SendErrorMessage( e.Message );
				// Выводится сообщение об ошибке и форма закрывается.
				MessageBox.Show( FormMain.ERROR_IS_OCCURRED_MESSAGE + e.Message );
				this.Close( );
				return;
			} // catch

			//Movie_Timer.Enabled = true;
			this._TimerMediaEnabled = true;
		} // PlayAudio

		private string CompletePath( string UsePath )
		{
			// Вызов метода класса.
			Program.MainTracer.CallClassMethod( FormMain.CLASS_NAME,
				"CompletePath", UsePath );

			return UsePath.TrimEnd( FormMain.BACKSLASH ) + FormMain.BACKSLASH;
		} // CompletePath

		private bool UpdateRegistryPath( string UsePath )
		{
			// Вызов метода класса.
			Program.MainTracer.CallClassMethod( FormMain.CLASS_NAME,
				"UpdateRegistryPath", UsePath );

			bool DoIt = false;
			// Save current folder name in registry
			Registry.SetValue( Program.RegistryKey, Program.RegistryPath, UsePath );
			// Check if registry has been correctly updated and setup DoIt accordingly
			if ( UsePath == ( string ) Registry.GetValue( Program.RegistryKey,
					Program.RegistryPath, string.Empty ) )
				DoIt = true;

			return DoIt;
		} // UpdateRegistryPath

		private void UpdateRegistryAudioVolume( Double UseAudioVolume )
		{
			// Вызов метода класса.
			Program.MainTracer.CallClassMethod( FormMain.CLASS_NAME,
				"UpdateRegistryAudioVolume", UseAudioVolume );

			// Save current audio volume in registry
			Registry.SetValue( Program.RegistryKey, Program.RegistryAudioVolume,
				Convert.ToInt32( UseAudioVolume ), RegistryValueKind.DWord );
		} // UpdateRegistryAudioVolume

		/// <summary>
		/// Проверка правильности пути и запуск медиа-файла.
		/// </summary>
		private void CheckMediaFileNameAndPlay( )
		{
			// Вызов метода класса.
			Program.MainTracer.CallClassMethod( FormMain.CLASS_NAME,
				"CheckMediaFileNameAndPlay" );

			// Если медиа-тип файла - видео.
			if ( this._MediaTypeName == MediaTypes.VIDEO )
				// Проверка правильности пути и запуск видео-файла.
				this.CheckMovieNameAndPlay( this._MediaFileURL );
			else
				// Если медиа-тип файла - аудио.
				if ( this._MediaTypeName == MediaTypes.AUDIO )
					// Проверка правильности пути и запуск аудио-файла.
					this.CheckAudioNameAndPlay( this._MediaFileURL );
				// Если медиа-тип файла не определён.
				else
					// Закрытие медиа-плеера.
					this.Close( );
		} // CheckMediaFileNameAndPlay

		/// <summary>
		/// Прямоугльная рабочая область элемента управления
		/// в координатах прямоугольной рабочей области формы.
		/// </summary>
		/// <param name="parControl">Элемент управления.</param>
		/// <returns>Прямоугльная рабочая область элемента управления
		/// в координатах прямоугольной рабочей области формы.</returns>
		private Rectangle ControlClientRectangleToThisClientRectangle
			( Control parControl )
		{
			return this.RectangleToClient
				( parControl.RectangleToScreen( parControl.ClientRectangle ) );
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
			/*// Фон формы.
			SolidBrush myBrush = new SolidBrush( this.BackColor );
			graphics.FillRectangle( myBrush, this.ClientRectangle );
			myBrush.Dispose( );*/

			#region Панели выравнивания
			// Если медиа-тип файла - видео.
			if ( this._MediaTypeName == MediaTypes.VIDEO )
			{
				myBrush = new SolidBrush( this._TableLayoutPanelScreen.BackColor );
				g.FillRectangle( myBrush,
					this.ControlClientRectangleToThisClientRectangle
					( this._TableLayoutPanelScreen ) );
				myBrush.Dispose( );
			} // if

			myBrush = new SolidBrush( this._TableLayoutPanelFillCommand.BackColor );
			g.FillRectangle( myBrush,
				this.ControlClientRectangleToThisClientRectangle
				( this._TableLayoutPanelFillCommand ) );
			myBrush.Dispose( );
			#endregion Панели выравнивания

			Bitmap bmp;
			Rectangle srceRect;
			Rectangle destRect;

			#region Бордюры по сторонам
			// Если медиа-тип файла - видео.
			if ( this._MediaTypeName == MediaTypes.VIDEO )
			{
				bmp = new Bitmap( this._PictureBoxUpScreenBorder.BackgroundImage );
				srceRect = new Rectangle( 0, 0, bmp.Width, bmp.Height );
				destRect = this.ControlClientRectangleToThisClientRectangle
					( this._PictureBoxUpScreenBorder );
				destRect.Width = FormMain.ControlSideForStretchBackgroundImageLayout
					( destRect.Width );
				g.DrawImage( bmp, destRect, srceRect, GraphicsUnit.Pixel );
				bmp.Dispose( );

				bmp = new Bitmap( this._PictureBoxLeftScreenBorder.BackgroundImage );
				srceRect = new Rectangle( 0, 0, bmp.Width, bmp.Height );
				destRect = this.ControlClientRectangleToThisClientRectangle
					( this._PictureBoxLeftScreenBorder );
				destRect.Height = FormMain.ControlSideForStretchBackgroundImageLayout
					( destRect.Height );
				g.DrawImage( bmp, destRect, srceRect, GraphicsUnit.Pixel );
				bmp.Dispose( );

				bmp = new Bitmap( this._PictureBoxRightScreenBorder.BackgroundImage );
				srceRect = new Rectangle( 0, 0, bmp.Width, bmp.Height );
				destRect = this.ControlClientRectangleToThisClientRectangle
					( this._PictureBoxRightScreenBorder );
				destRect.Height = FormMain.ControlSideForStretchBackgroundImageLayout
					( destRect.Height );
				g.DrawImage( bmp, destRect, srceRect, GraphicsUnit.Pixel );
				bmp.Dispose( );
			} // if

			bmp = new Bitmap( this._PictureBoxUpCommandBorder.BackgroundImage );
			srceRect = new Rectangle( 0, 0, bmp.Width, bmp.Height );
			destRect = this.ControlClientRectangleToThisClientRectangle
				( this._PictureBoxUpCommandBorder );
			destRect.Width = FormMain.ControlSideForStretchBackgroundImageLayout
				( destRect.Width );
			g.DrawImage( bmp, destRect, srceRect, GraphicsUnit.Pixel );
			bmp.Dispose( );

			bmp = new Bitmap( this._PictureBoxDownCommandBorder.BackgroundImage );
			srceRect = new Rectangle( 0, 0, bmp.Width, bmp.Height );
			destRect = this.ControlClientRectangleToThisClientRectangle
				( this._PictureBoxDownCommandBorder );
			destRect.Width = FormMain.ControlSideForStretchBackgroundImageLayout
				( destRect.Width );
			g.DrawImage( bmp, destRect, srceRect, GraphicsUnit.Pixel );
			bmp.Dispose( );

			bmp = new Bitmap( this._PictureBoxLeftCommandBorder.BackgroundImage );
			srceRect = new Rectangle( 0, 0, bmp.Width, bmp.Height );
			destRect = this.ControlClientRectangleToThisClientRectangle
				( this._PictureBoxLeftCommandBorder );
			destRect.Height = FormMain.ControlSideForStretchBackgroundImageLayout
				( destRect.Height );
			g.DrawImage( bmp, destRect, srceRect, GraphicsUnit.Pixel );
			bmp.Dispose( );

			bmp = new Bitmap( this._PictureBoxRightCommandBorder.BackgroundImage );
			srceRect = new Rectangle( 0, 0, bmp.Width, bmp.Height );
			destRect = this.ControlClientRectangleToThisClientRectangle
				( this._PictureBoxRightCommandBorder );
			destRect.Height = FormMain.ControlSideForStretchBackgroundImageLayout
				( destRect.Height );
			g.DrawImage( bmp, destRect, srceRect, GraphicsUnit.Pixel );
			bmp.Dispose( );
			#endregion Бордюры по сторонам

			#region Бордюры по углам
			// Если медиа-тип файла - видео.
			if ( this._MediaTypeName == MediaTypes.VIDEO )
			{
				bmp = new Bitmap( this._PictureBoxLeftUpScreenBorder.BackgroundImage );
				srceRect = new Rectangle( 0, 0, bmp.Width, bmp.Height );
				destRect = this.ControlClientRectangleToThisClientRectangle
					( this._PictureBoxLeftUpScreenBorder );
				g.DrawImage( bmp, destRect, srceRect, GraphicsUnit.Pixel );
				bmp.Dispose( );

				bmp = new Bitmap( this._PictureBoxRightUpScreenBorder.BackgroundImage );
				srceRect = new Rectangle( 0, 0, bmp.Width, bmp.Height );
				destRect = this.ControlClientRectangleToThisClientRectangle
					( this._PictureBoxRightUpScreenBorder );
				g.DrawImage( bmp, destRect, srceRect, GraphicsUnit.Pixel );
				bmp.Dispose( );
			} // if

			bmp = new Bitmap( this._PictureBoxLeftUpCommandBorder.BackgroundImage );
			srceRect = new Rectangle( 0, 0, bmp.Width, bmp.Height );
			destRect = this.ControlClientRectangleToThisClientRectangle
				( this._PictureBoxLeftUpCommandBorder );
			g.DrawImage( bmp, destRect, srceRect, GraphicsUnit.Pixel );
			bmp.Dispose( );

			bmp = new Bitmap( this._PictureBoxRightUpCommandBorder.BackgroundImage );
			srceRect = new Rectangle( 0, 0, bmp.Width, bmp.Height );
			destRect = this.ControlClientRectangleToThisClientRectangle
				( this._PictureBoxRightUpCommandBorder );
			g.DrawImage( bmp, destRect, srceRect, GraphicsUnit.Pixel );
			bmp.Dispose( );

			bmp = new Bitmap( this._PictureBoxLeftDownCommandBorder.BackgroundImage );
			srceRect = new Rectangle( 0, 0, bmp.Width, bmp.Height );
			destRect = this.ControlClientRectangleToThisClientRectangle
				( this._PictureBoxLeftDownCommandBorder );
			g.DrawImage( bmp, destRect, srceRect, GraphicsUnit.Pixel );
			bmp.Dispose( );

			bmp = new Bitmap( this._PictureBoxRightDownCommandBorder.BackgroundImage );
			srceRect = new Rectangle( 0, 0, bmp.Width, bmp.Height );
			destRect = this.ControlClientRectangleToThisClientRectangle
				( this._PictureBoxRightDownCommandBorder );
			g.DrawImage( bmp, destRect, srceRect, GraphicsUnit.Pixel );
			bmp.Dispose( );
			#endregion Бордюры по углам

			#region Окончания трека прокрутки
			bmp = new Bitmap( this._PictureBoxTrackbarDurationLeftBorder.
				BackgroundImage );
			srceRect = new Rectangle( 0, 0, bmp.Width, bmp.Height );
			destRect = this.ControlClientRectangleToThisClientRectangle
				( this._PictureBoxTrackbarDurationLeftBorder );
			g.DrawImage( bmp, destRect, srceRect, GraphicsUnit.Pixel );
			this._SkinTrackbarDuration.DrawPictureBoxProgressLineLeftOrTopEnd
				( g, destRect );
			bmp.Dispose( );

			bmp = new Bitmap( this._PictureBoxTrackbarDurationRightBorder.
				BackgroundImage );
			srceRect = new Rectangle( 0, 0, bmp.Width, bmp.Height );
			destRect = this.ControlClientRectangleToThisClientRectangle
				( this._PictureBoxTrackbarDurationRightBorder );
			g.DrawImage( bmp, destRect, srceRect, GraphicsUnit.Pixel );
			this._SkinTrackbarDuration.DrawPictureBoxProgressLineRightOrBottomEnd
				( g, destRect );
			bmp.Dispose( );
			#endregion Окончания трека прокрутки

			#region Трек прокрутки длительности
			bmp = new Bitmap( this._SkinTrackbarDuration.Width,
				this._SkinTrackbarDuration.Height );
			Graphics trackbarDurationGraphics = Graphics.FromImage( bmp );

			this._SkinTrackbarDuration.Draw( trackbarDurationGraphics );
			// Release graphics
			trackbarDurationGraphics.Dispose( );

			srceRect = new Rectangle( 0, 0, bmp.Width, bmp.Height );
			destRect = this.ControlClientRectangleToThisClientRectangle
				( this._SkinTrackbarDuration );
			g.DrawImage( bmp, destRect, srceRect, GraphicsUnit.Pixel );
			bmp.Dispose( );
			#endregion Трек прокрутки длительности

			#region Кнопки
			// Если медиа-тип файла - видео.
			if ( this._MediaTypeName == MediaTypes.VIDEO )
			{
				bmp = new Bitmap( this._SkinButtonSmallScreen.BackgroundImage );
				srceRect = new Rectangle( 0, 0, bmp.Width, bmp.Height );
				destRect = this.ControlClientRectangleToThisClientRectangle
					( this._SkinButtonSmallScreen );
				g.DrawImage( bmp, destRect, srceRect, GraphicsUnit.Pixel );
				bmp.Dispose( );
			} // if

			bmp = new Bitmap( this._SkinButtonSound.BackgroundImage );
			srceRect = new Rectangle( 0, 0, bmp.Width, bmp.Height );
			destRect = this.ControlClientRectangleToThisClientRectangle
				( this._SkinButtonSound );
			g.DrawImage( bmp, destRect, srceRect, GraphicsUnit.Pixel );
			bmp.Dispose( );

			bmp = new Bitmap( this._SkinButtonPause.BackgroundImage );
			srceRect = new Rectangle( 0, 0, bmp.Width, bmp.Height );
			destRect = this.ControlClientRectangleToThisClientRectangle
				( this._SkinButtonPause );
			g.DrawImage( bmp, destRect, srceRect, GraphicsUnit.Pixel );
			bmp.Dispose( );

			bmp = new Bitmap( this._SkinButtonExit.BackgroundImage );
			srceRect = new Rectangle( 0, 0, bmp.Width, bmp.Height );
			destRect = this.ControlClientRectangleToThisClientRectangle
				( this._SkinButtonExit );
			g.DrawImage( bmp, destRect, srceRect, GraphicsUnit.Pixel );
			bmp.Dispose( );
			#endregion Кнопки
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
			Bitmap offScreenBmp = new Bitmap( this.Width, this.Height );
			Graphics graphics = Graphics.FromImage( offScreenBmp );

			// Отрисовка всего изображённого на форме.
			this.Draw( graphics );

			// Окончание двойной буферизации.

			// Release graphics
			graphics.Dispose( );

			this._PictureBoxFormImageCopy.BackgroundImage = offScreenBmp;
			this._PictureBoxFormImageCopy.Refresh( );
			/*this._PictureBoxFormImageCopy.Visible = true;
			this._TableLayoutPanelForm.Visible = false;*/
		} // DrawFormImageCopy

		/// <summary>
		/// Отрисовка маленькой копии изображения формы.
		/// </summary>
		private void DrawFormImageSmallCopy( )
		{
			this._PictureBoxFormImageSmallCopy.Parent = this;
			this._PictureBoxFormImageSmallCopy.Location = new Point( 0, 0 );
			this._PictureBoxFormImageSmallCopy.Width = this.Width;
			this._PictureBoxFormImageSmallCopy.Height = this.Height;

			// Начало двойной буферизации.

			// Create a memory bitmap to use as double buffer
			Bitmap offScreenSmallBmp = new Bitmap
				( this._PictureBoxFormImageSmallCopy.Width,
				this._PictureBoxFormImageSmallCopy.Height );
			Graphics graphics = Graphics.FromImage( offScreenSmallBmp );

			/*// Фон формы.
			SolidBrush myBrush = new SolidBrush( this.BackColor );
			graphics.FillRectangle( myBrush, this.ClientRectangle );
			myBrush.Dispose( );*/

			// Копирование картинки формы с уменьшением.
			Bitmap bmp = new Bitmap( this._PictureBoxFormImageCopy.
				BackgroundImage );
			Rectangle srceRect = new Rectangle( 0, 0, bmp.Width, bmp.Height );
			Rectangle destRect = this._FormImageSmallCopyRectangle;
			graphics.DrawImage( bmp, destRect, srceRect, GraphicsUnit.Pixel );
			bmp.Dispose( );

			// Окончание двойной буферизации.

			// Release graphics
			graphics.Dispose( );

			this._PictureBoxFormImageSmallCopy.BackgroundImage = offScreenSmallBmp;
			this._PictureBoxFormImageSmallCopy.Refresh( );
			this._PictureBoxFormImageSmallCopy.Visible = true;
			this._TableLayoutPanelForm.Visible = false;
			this._PanelScreen.Visible = false;
		} // DrawFormImageSmallCopy

		/// <summary>
		/// Установка параметров эффекта изменения видимости формы.
		/// </summary>
		private void GetVisibleChangingEffectParameters( )
		{
			// Вызов метода класса.
			Program.MainTracer.CallClassMethod( FormMain.CLASS_NAME,
				"GetVisibleChangingEffectParameters" );

			// Количество интервалов запуска таймера эффекта изменения видимости.
			int timerFormVisibleChangingEffectIntervalsCount =
				this.VisibleChangingEffectTime /
				this.VisibleChangingEffectTimerInterval;

			// Приращение ширины эффекта изменения видимости формы.
			this._VisibleChangingEffectWidthIncrementation = ( int ) Math.Round
				( ( ( float) this.Width - 1 ) /
				timerFormVisibleChangingEffectIntervalsCount );
			// Приращение высоты эффекта изменения видимости формы.
			this._VisibleChangingEffectHeightIncrementation = ( int ) Math.Round
				( ( ( float) this.Height - 1 ) /
				timerFormVisibleChangingEffectIntervalsCount );
			// Приращение абсциссы эффекта изменения видимости формы.
			this._VisibleChangingEffectXIncrementation = ( int ) Math.Round
				( ( ( float) this._VisibleChangingEffectWidthIncrementation ) / 2 );
			// Приращение ординаты эффекта изменения видимости формы.
			this._VisibleChangingEffectYIncrementation = ( int ) Math.Round
				( ( ( float) this._VisibleChangingEffectHeightIncrementation ) / 2 );
			// Приращение непрозрачности эффекта изменения видимости формы.
			this._VisibleChangingEffectOpacityIncrementation =
				FormSound.MAXIMUM_OPACITY /
				timerFormVisibleChangingEffectIntervalsCount;
		} // GetVisibleChangingEffectParameters

		/// <summary>
		/// Показ формы.
		/// </summary>
		new public void ShowDialog( )
		{
			// Выбран метод ShowDialog, а не просто Show,
			// потому что при Show почему-то в конце мигает чёрный прямогольник
			// прежнего расположения панели видео-отображения,
			// и этот прямоугольник может оставлять следы на экране.
			// При ShowDialog этот досадный эффект ИНОГДА пропадает...

			// Вызов метода класса.
			Program.MainTracer.CallClassMethod( FormMain.CLASS_NAME, "ShowDialog" );

			// В любом случае таймер эффекта скорытия останавливается.
			this._TimerFormHidingEffect.Enabled = false;

			/*// Приращения меняют знаки.
			if ( this._VisibleChangingEffectXIncrementation > 0 )
				this._VisibleChangingEffectXIncrementation *= -1;
			if ( this._VisibleChangingEffectYIncrementation > 0 )
				this._VisibleChangingEffectYIncrementation *= -1;
			if ( this._VisibleChangingEffectWidthIncrementation < 0 )
				this._VisibleChangingEffectWidthIncrementation *= -1;
			if ( this._VisibleChangingEffectHeightIncrementation < 0 )
				this._VisibleChangingEffectHeightIncrementation *= -1;
			if ( this._VisibleChangingEffectOpacityIncrementation < 0 )
				this._VisibleChangingEffectOpacityIncrementation *= -1;*/

			// Если эффект появления ещё не происходит и он нужен,
			// то он начинается.
			if
			(
				( ! this._TimerFormShowingEffect.Enabled ) &&
				(
					( this._FormImageSmallCopyRectangle.Width < this.Width ) ||
					( this._FormImageSmallCopyRectangle.Height < this.Height )
				)
			)
			{
				this.GetVisibleChangingEffectParameters( );
				this._VisibleChangingEffectXIncrementation *= -1;
				this._VisibleChangingEffectYIncrementation *= -1;

				this.TransparencyKey = this.TemporaryTransparencyKey;
				this.Opacity = 0;

				// Картника маленькой копии формы размещается по центру
				// и имеет минимальные размеры.
				this._FormImageSmallCopyRectangle.X = this.Width / 2;
				this._FormImageSmallCopyRectangle.Y = this.Height / 2;
				this._FormImageSmallCopyRectangle.Width = 1;
				this._FormImageSmallCopyRectangle.Height = 1;

				// Отрисовка копии изображения формы.
				this.DrawFormImageCopy( );
				// Отрисовка маленькой копии изображения формы.
				this.DrawFormImageSmallCopy( );
				this._TimerFormShowingEffect.Enabled = true;
			} // if

			// Форма пока всё ещё видима.
			this.Visible = true;
		} // ShowDialog

		/// <summary>
		/// Сокрытие формы.
		/// </summary>
		new public void Hide( )
		{
			// Вызов метода класса.
			Program.MainTracer.CallClassMethod( FormMain.CLASS_NAME, "Hide" );

			// Если форма уже сокрыта, то её не надо скрывать.
			if ( ! this.Visible )
				return;

			// В любом случае таймер эффекта показа останавливается.
			this._TimerFormShowingEffect.Enabled = false;

			/*// Приращения меняют знаки.
			if ( this._VisibleChangingEffectXIncrementation < 0 )
				this._VisibleChangingEffectXIncrementation *= -1;
			if ( this._VisibleChangingEffectYIncrementation < 0 )
				this._VisibleChangingEffectYIncrementation *= -1;
			if ( this._VisibleChangingEffectWidthIncrementation > 0 )
				this._VisibleChangingEffectWidthIncrementation *= -1;
			if ( this._VisibleChangingEffectHeightIncrementation > 0 )
				this._VisibleChangingEffectHeightIncrementation *= -1;
			if ( this._VisibleChangingEffectOpacityIncrementation > 0 )
				this._VisibleChangingEffectOpacityIncrementation *= -1;*/

			// Если эффект исчезновения ещё не происходит и он нужен,
			// то он начинается.
			if
			(
				( ! this._TimerFormHidingEffect.Enabled ) &&
				(
					( this._FormImageSmallCopyRectangle.Width > 1 ) ||
					( this._FormImageSmallCopyRectangle.Height > 1 )
				)
			)
			{
				// Формы звука прячется, чтобы не зависала без дела.
				this._FormSound.Close( );

				this.GetVisibleChangingEffectParameters( );
				this._VisibleChangingEffectWidthIncrementation *= -1;
				this._VisibleChangingEffectHeightIncrementation *= -1;
				this._VisibleChangingEffectOpacityIncrementation *= -1;

				this.TransparencyKey = this.TemporaryTransparencyKey;
				this.Opacity = FormSound.MAXIMUM_OPACITY;

				// Картника маленькой копии формы занимает всю форму.
				this._FormImageSmallCopyRectangle.X = 0;
				this._FormImageSmallCopyRectangle.Y = 0;
				this._FormImageSmallCopyRectangle.Width = this.Width;
				this._FormImageSmallCopyRectangle.Height = this.Height;

				// Отрисовка копии изображения формы.
				this.DrawFormImageCopy( );
				// Отрисовка маленькой копии изображения формы.
				this.DrawFormImageSmallCopy( );
				this._TimerFormHidingEffect.Enabled = true;
			} // if
		} // Hide


		#region Events Handlers


		/// <summary>
		/// Изменение размеров формы.
		/// </summary>
		/// <param name="sender">Объект-источник события.</param>
		/// <param name="e">Аргументы события.</param>
		private void OnResize( object sender, EventArgs e )
		{
			// Вызов метода-обработчика события класса.
			Program.MainTracer.CallClassEventHandler( FormMain.CLASS_NAME,
				"OnResize", sender, e );

			/*
			int height = this.ClientSize.Height - _MenuStrip.Height -
				_TableLayoutPanelCommand.Height;
			*/
			int height = this.ClientSize.Height - this._TableLayoutPanelCommand.Height;
			int width = this.ClientSize.Width;
			float temp = ( float ) width / ( float ) height;

			if ( temp >= this._Aspect )
			{
				width = Convert.ToInt32( height * this._Aspect );
				this._PanelScreen.Size = new Size( width, height );
				/*
				_PanelScreen.Location = new Point((this.ClientSize.Width - width) / 2,
					_MenuStrip.Height);
				*/
				this._PanelScreen.Location = new Point
					( ( this.ClientSize.Width - width ) / 2, 0 );
			} // if
			else
			{
				height = Convert.ToInt32( width / this._Aspect );
				this._PanelScreen.Size = new Size( width, height );
				/*
				_PanelScreen.Location = new Point(0, (this.ClientSize.Height -
					_MenuStrip.Height - _TableLayoutPanelCommand.Height - height) / 2 +
					_MenuStrip.Height);
				*/
				this._PanelScreen.Location = new Point( 0, ( this.ClientSize.Height -
					this._TableLayoutPanelCommand.Height - height ) / 2 );
			} // else

			// Если проигрывание остановлено, а размеры формы изменяются,
			// то надо корректировать позицию проигрывания медиа-файла,
			// если она изменяется при перетаскивании бегунка прокрутки.
			if ( this._Movie != null )
				this._MediaCurrentPosition = ( int ) this._Movie.CurrentPosition;
			else
				if ( this._Audio != null )
					this._MediaCurrentPosition = ( int ) this._Audio.CurrentPosition;

			// Если это не написать, то при остановленном видео будет нарушено
			// масштабирование шкал и позиций бегунков полос прокруток.
			this._SkinTrackbarDuration.Value =
				this.GetTrackbarMediaValueFromMediaurrentPosition( );
			/*this._SkinTrackbarSound.Value =
				this.GetTrackbarSoundValueFromAudioVolume( );
			this._FormSound.TrackbarSoundValue =
				this.GetTrackbarSoundValueFromAudioVolume( );*/
		} // OnResize

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
			Program.MainTracer.CallClassEventHandler( FormMain.CLASS_NAME,
				"OnTimerFormShowingEffectTick", parSender, parEventArgs );

			// Инкремент параметров эффекта появления.
			double opacity = this.Opacity +
				this._VisibleChangingEffectOpacityIncrementation;
			int x = this._FormImageSmallCopyRectangle.X +
				this._VisibleChangingEffectXIncrementation;
			int y = this._FormImageSmallCopyRectangle.Y +
				this._VisibleChangingEffectYIncrementation;
			int width = this._FormImageSmallCopyRectangle.Width +
				this._VisibleChangingEffectWidthIncrementation;
			int height = this._FormImageSmallCopyRectangle.Height +
				this._VisibleChangingEffectHeightIncrementation;

			// Если хотя бы один из параметров эффекта появления
			// достиг предельного значения, то устанавливаются предельные значения
			// для всех параметров и эффект завершается.
			if
			(
				( opacity >= FormSound.MAXIMUM_OPACITY ) ||
				( x <= 0 ) ||
				( y <= 0 ) ||
				( width >= this.Width ) ||
				( height >= this.Height )
			)
			{
				this.Opacity = FormSound.MAXIMUM_OPACITY;
				this._FormImageSmallCopyRectangle.X = 0;
				this._FormImageSmallCopyRectangle.Y = 0;
				this._FormImageSmallCopyRectangle.Width = this.Width;
				this._FormImageSmallCopyRectangle.Height = this.Height;

				// Отрисовка маленькой копии изображения формы.
				this.DrawFormImageSmallCopy( );

				this._TableLayoutPanelForm.Visible = true;
				this._PanelScreen.Visible = true;
				this._PictureBoxFormImageSmallCopy.Visible = false;
				this.TransparencyKey = Color.Empty;
				this._TimerFormShowingEffect.Enabled = false;

				// Проверка правильности пути и запуск медиа-файла.
				this.CheckMediaFileNameAndPlay( );
			} // if
			else
			{
				this.Opacity = opacity;
				this._FormImageSmallCopyRectangle.X = x;
				this._FormImageSmallCopyRectangle.Y = y;
				this._FormImageSmallCopyRectangle.Width = width;
				this._FormImageSmallCopyRectangle.Height = height;

				// Отрисовка маленькой копии изображения формы.
				this.DrawFormImageSmallCopy( );
			} // else
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
			Program.MainTracer.CallClassEventHandler( FormMain.CLASS_NAME,
				"OnTimerFormHidingEffectTick", parSender, parEventArgs );

			// Инкремент параметров эффекта исчезновения.
			double opacity = this.Opacity +
				this._VisibleChangingEffectOpacityIncrementation;
			int x = this._FormImageSmallCopyRectangle.X +
				this._VisibleChangingEffectXIncrementation;
			int y = this._FormImageSmallCopyRectangle.Y +
				this._VisibleChangingEffectYIncrementation;
			int width = this._FormImageSmallCopyRectangle.Width +
				this._VisibleChangingEffectWidthIncrementation;
			int height = this._FormImageSmallCopyRectangle.Height +
				this._VisibleChangingEffectHeightIncrementation;

			// Координаты центра формы.
			int centreX = this.Width / 2;
			int centreY = this.Height / 2;

			// Если хотя бы один из параметров эффекта исчезновения
			// достиг предельного значения, то устанавливаются предельные значения
			// для всех параметров, эффект завершается
			// и форма наконец становится невидимой.
			if
			(
				( opacity <= 0 ) ||
				( x >= centreX ) ||
				( y >= centreY ) ||
				( width <= 1 ) ||
				( height <= 1 )
			)
			{
				this.Opacity = 0;
				this._FormImageSmallCopyRectangle.X = centreX;
				this._FormImageSmallCopyRectangle.Y = centreY;
				this._FormImageSmallCopyRectangle.Width = 1;
				this._FormImageSmallCopyRectangle.Height = 1;

				// Отрисовка маленькой копии изображения формы.
				this.DrawFormImageSmallCopy( );

				this._TableLayoutPanelForm.Visible = true;
				/*this._PanelScreen.Visible = true;*/
				this._PictureBoxFormImageSmallCopy.Visible = false;
				this.Visible = false;
				this.TransparencyKey = Color.Empty;
				this._TimerFormHidingEffect.Enabled = false;

				// Форму можно закрыть.
				this._CanClose = true;
				this.Close( );
			} // if
			else
			{
				this.Opacity = opacity;
				this._FormImageSmallCopyRectangle.X = x;
				this._FormImageSmallCopyRectangle.Y = y;
				this._FormImageSmallCopyRectangle.Width = width;
				this._FormImageSmallCopyRectangle.Height = height;

				// Отрисовка маленькой копии изображения формы.
				this.DrawFormImageSmallCopy( );
			} // else
		} // OnTimerFormHidingEffectTick

		/// <summary>
		/// Наступление момента времени истечения очередного интервала времени
		/// таймера проигрывания медиа-файла.
		/// </summary>
		/// <param name="sender">Объект-источник события.</param>
		/// <param name="e">Аргументы события.</param>
		private void OnTimerMediaTick( object sender, EventArgs e )
		{
			if ( this._TimerMediaEnabled )
			{
				if ( this._Movie != null )
					this._MediaCurrentPosition = ( int ) this._Movie.CurrentPosition;
				else
					if ( this._Audio != null )
						this._MediaCurrentPosition = ( int ) this._Audio.CurrentPosition;

				this._SkinTrackbarDuration.Value =
					this.GetTrackbarMediaValueFromMediaurrentPosition( );
				string currentTime =
					this.GetHoursMinutesSecondsString( this._MediaCurrentPosition );
				/*
				currentTime.Text = HH + ":" + MM + ":" + SS;
				if (currentTime.Text == movieDuration) BTN_Stop_Click(null, null);
				*/
				if ( currentTime == this._MediaDurationString )
				{
					this.OnSkinButtonStopClick( null, null );
					// Пусть при окончании проигрывания форма закрывается -
					// вдруг пользователь её не закрыл и ушёл.
					this.Close( );
				} // if
			} // if
			/*
			DateTime dt = DateTime.Now;
			HH = ("00" + dt.Hour.ToString());
			HH = HH.Substring(HH.Length - 2, 2);
			MM = ("00" + dt.Minute.ToString());
			MM = MM.Substring(MM.Length - 2, 2);
			SS = ("00" + dt.Second.ToString());
			SS = SS.Substring(SS.Length - 2, 2);
			ShowTime.Text = HH + ":" + MM + ":" + SS;
			*/
		} // OnTimerMediaTick

		/// <summary>
		/// Наступление момента времени истечения интервала времени
		/// таймера закрытия формы.
		/// </summary>
		/// <param name="sender">Объект-источник события.</param>
		/// <param name="e">Аргументы события.</param>
		private void OnTimerFormClosingTick( object sender, EventArgs e )
		{
			// Вызов метода-обработчика события класса.
			Program.MainTracer.CallClassEventHandler( FormMain.CLASS_NAME,
				"OnTimerFormClosingTick", sender, e );

			// Если таймер закрытия формы доступен, то проигрывание медиа-файла
			// остановлено до естественного завершения проигрывания.
			// Вдруг пользователь запустил проигрыватель, остановил
			// на каком-то моменте и ушёл - надо закрыть плеер
			// по истечении промежутка времени простоя плеера.
			this.Close( );
		} // OnTimerFormClosingTick

		private void OnShown( object sender, EventArgs e )
		{
			this.ShowDialog( );
		} // OnShown

		/// <summary>
		/// Закрытие формы.
		/// </summary>
		/// <param name="sender">Объект-источник события.</param>
		/// <param name="e">Аргументы события.</param>
		private void OnFormClosing( object sender, FormClosingEventArgs e )
		{
			// Вызов метода-обработчика события класса.
			Program.MainTracer.CallClassEventHandler( FormMain.CLASS_NAME,
				"OnFormClosing", sender, e );

			this.OnSkinButtonStopClick( null, null );

			if ( this._Movie != null )
			{
				// Видео не сразу останавливается и уничтожается, в то время,
				// как главная форма уже успевает уменьшиться и закрыться,
				// поэтому на экране может оставаться зависать
				// тёмный прямоугольник панели экрана.
				// Сразу спрятать область видео помогает её уменьшение
				// до минимальных размеров.
				this._Movie.Size = new Size( 1, 1 );
				this._Movie.Dispose( );
				// Free up the media.
				this._Movie = null;
			} // if

			if ( this._Audio != null )
			{
				this._Audio.Dispose( );
				// Free up the media.
				this._Audio = null;
			} // if

			// Запись сведений о том, что в данный момент плеер не работает.

			// Поток файла статуса показа главной формы.
			FileStream statusFileStream = new FileStream
				( this._MainFormShowingStatusFilePath, FileMode.Create,
				FileAccess.Write, FileShare.Read );
			// Писатель файлового потока статуса показа главной формы.
			StreamWriter statusFileStreamWriter = new StreamWriter( statusFileStream );
			// Запись статуса нерабочего состояния плеера в файл.
			statusFileStreamWriter.Write( MainFormShowingStatus.CLOSE );
			statusFileStreamWriter.Flush( );
			statusFileStreamWriter.Close( );

			// Если форму можно закрыть.
			if ( this._CanClose )
			{
				this._PanelScreen.BackColor = Color.Transparent;
				e.Cancel = false;
			} // if
			else
			{
				// Отмена закрытия формы.
				e.Cancel = true;
				// Форма скрывается c эффектом.
				this.Hide( );
			} // else
		} // OnFormClosing

		private void OnToolStripMenuItemOpenClick( object sender, EventArgs e )
		{
			string UsePath = string.Empty;
			UsePath = ( string ) Registry.GetValue( Program.RegistryKey,
				Program.RegistryPath, string.Empty );
			if ( ( UsePath != null ) && ( UsePath.Length != 0 ) )
			{
				DirectoryInfo dirinfo = new DirectoryInfo( UsePath );
				if ( !dirinfo.Exists )
					UsePath = string.Empty;
			}
			if ( ( UsePath != null ) && ( UsePath.Length == 0 ) )
				UsePath = Path.GetPathRoot( Directory.GetCurrentDirectory( ) );

			_OpenFileDialog.InitialDirectory = UsePath;
			if ( _OpenFileDialog.ShowDialog( ) == DialogResult.OK )
			{
				this.Refresh( ); // Redraw MAIN_Form
				UsePath = Path.GetDirectoryName( _OpenFileDialog.FileName );
				UpdateRegistryPath( UsePath );
				PlayMovie( _OpenFileDialog.FileName );
			}
		} // OnToolStripMenuItemOpenClick

		private void OnToolStripMenuItemAboutClick( object sender, EventArgs e )
		{
			string MyTitle = "zMoviePlayer 1.04";
			string MyMessage = "Managed DirectX 9 Movie Player.\nmpg, mpeg, wmv, avi " +
				"(DivX / XviD)\n\nAuthor Patrice Terrier\n" +
				"pterrier@zapsolution.com\nwww.zapsolution.com";
			MessageBox.Show( MyMessage, MyTitle, MessageBoxButtons.OK,
				MessageBoxIcon.Information );
		} // OnToolStripMenuItemAboutClick


		#region TableLayoutPanelCommand Controls Events Handlers


		#region SkinTrackbarDuration Events Handlers


		/// <summary>
		/// Нажатие указателем мыши на треке длительности медиа-файла.
		/// </summary>
		/// <param name="sender">Объект-источник события.</param>
		/// <param name="e">Аргументы события.</param>
		private void OnSkinTrackbarDurationMouseDown( object sender, MouseEventArgs e )
		{
			// Вызов метода-обработчика события класса.
			Program.MainTracer.CallClassEventHandler( FormMain.CLASS_NAME,
				"OnSkinTrackbarDurationMouseDown", sender, e );

			if ( ( this._Movie != null ) || ( this._Audio != null ) )
			{
				if ( this._Movie != null )
					this._Movie.Pause( );
				else
					if ( this._Audio != null )
						this._Audio.Pause( );

				this._ScrollEnable = true;
				this._SkinTrackbarDuration.Value = ( int )
					( ( float ) ( ( float ) e.X /
					( float ) this._SkinTrackbarDuration.Width ) *
					( float ) this._SkinTrackbarDuration.Maximum );
				this.OnSkinTrackbarDurationScroll( null, null );
			} // if
		} // OnSkinTrackbarDurationMouseDown

		/// <summary>
		/// Отпускание указателя мыши на треке длительности медиа-файла.
		/// </summary>
		/// <param name="sender">Объект-источник события.</param>
		/// <param name="e">Аргументы события.</param>
		private void OnSkinTrackbarDurationMouseUp( object sender, MouseEventArgs e )
		{
			// Вызов метода-обработчика события класса.
			Program.MainTracer.CallClassEventHandler( FormMain.CLASS_NAME,
				"OnSkinTrackbarDurationMouseUp", sender, e );

			if ( ( this._Movie != null ) || ( this._Audio != null ) )
			{
				this._ScrollEnable = false;

				if ( this._SkinButtonPlay.Visible == false )
				{
					if ( this._Movie != null )
						this._Movie.Play( );
					else
						if ( this._Audio != null )
							this._Audio.Play( );

					//Movie_Timer.Enabled = true;
					this._TimerMediaEnabled = true;
				} // if
			} // if
		} // OnSkinTrackbarDurationMouseUp

		/// <summary>
		/// Появление указателя мыши в области трека длительности медиа-файла.
		/// </summary>
		/// <param name="sender">Объект-источник события.</param>
		/// <param name="e">Аргументы события.</param>
		private void OnSkinTrackbarDurationMouseEnter( object sender, EventArgs e )
		{
			/*
			// При полноэкранном режиме командная панель "появляется",
			// если указатель мыши появляется в области трека длительности медиа-файла.
			if ( this._FullScreen )
				this._TableLayoutPanelCommand.Height = this._CommandPanelHeight;
			*/
		} // OnSkinTrackbarDurationMouseEnter

		/// <summary>
		/// Покидание курсором трека длительности медиа-файла.
		/// </summary>
		/// <param name="sender">Объект-источник события.</param>
		/// <param name="e">Аргументы события.</param>
		private void OnSkinTrackbarDurationMouseLeave( object sender, EventArgs e )
		{
			/*
			// При полноэкранном режиме командная панель "прячется",
			// если указатель мыши покидает трек длительности медиа-файла.
			if ( this._FullScreen )
				if ( Cursor.Position.Y < this.Location.Y +
						this._TableLayoutPanelCommand.Location.Y )
					this._TableLayoutPanelCommand.Height = 1;
			*/
		} // OnSkinTrackbarDurationMouseLeave

		/// <summary>
		/// Прокрутка бегунка длительности медиа-файла.
		/// </summary>
		/// <param name="sender">Объект-источник события.</param>
		/// <param name="e">Аргументы события.</param>
		private void OnSkinTrackbarDurationScroll( object sender, ScrollEventArgs e )
		{
			// Вызов метода-обработчика события класса.
			Program.MainTracer.CallClassEventHandler( FormMain.CLASS_NAME,
				"OnSkinTrackbarDurationScroll", sender, e );

			//if (HDmovie) return; // To avoid the DirectX infamous exception error
			if ( this._ScrollEnable == true )
			{
				if ( this._Movie != null )
					this._Movie.CurrentPosition =
						this.GetMediaCurrentPositionFromTrackbarDurationValue( );
				else
					if ( this._Audio != null )
						this._Audio.CurrentPosition =
							this.GetMediaCurrentPositionFromTrackbarDurationValue( );
			} // if
		} // OnSkinTrackbarDurationScroll

		/// <summary>
		/// Регулировка позиции проигрывания медиа-файла при перемещении
		/// бегунка прокрутки длительности медиа-файла.
		/// </summary>
		/// <param name="sender">Объект-источник события.</param>
		/// <param name="e">Аргументы события.</param>
		private void OnSkinTrackbarDurationValueChanged( object sender, EventArgs e )
		{
			//if (HDmovie) return; // To avoid the DirectX infamous exception error
			if ( this._ScrollEnable == true )
			{
				if ( this._Movie != null )
					this._Movie.CurrentPosition =
						this.GetMediaCurrentPositionFromTrackbarDurationValue( );
				else
					if ( this._Audio != null )
						this._Audio.CurrentPosition =
							this.GetMediaCurrentPositionFromTrackbarDurationValue( );
			} // if
		} // OnSkinTrackbarDurationValueChanged


		#endregion SkinTrackbarDuration Events Handlers


		/// <summary>
		/// Регулировка звука при перемещении бегунка прокрутки звука
		/// на форме звука.
		/// </summary>
		/// <param name="sender">Объект-источник события.</param>
		/// <param name="e">Аргументы события.</param>
		private void OnFormSoundTrackbar( object sender, EventArgs e )
		{
			// Если звук есть.
			if ( ! this._MuteMode )
			{
				if ( this._Movie != null )
					this._Movie.Audio.Volume = this.GetAudioVolumeFromTrackbarSoundValue( );
				else
					if ( this._Audio != null )
						this._Audio.Volume = this.GetAudioVolumeFromTrackbarSoundValue( );
			} // if
		} // OnFormSoundTrackbar

		/// <summary>
		/// Появление формы звука при наведении курсора на кнопку.
		/// </summary>
		/// <param name="sender">Объект-источник события.</param>
		/// <param name="e">Аргументы события.</param>
		private void OnSkinButtonSoundMouseEnter( object sender, EventArgs e )
		{
			// Вызов метода-обработчика события класса.
			Program.MainTracer.CallClassEventHandler( FormMain.CLASS_NAME,
				"OnSkinButtonSoundMouseEnter", sender, e );

			if ( ! this._FormSound.Visible )
			{
				// Восстановление ширины формы звука,
				// которая почему-то теряется по ходу выполнения программы.
				this._FormSound.Width = this._FormSoundWidth;
				// Абсцисса формы звука - абсцисса кнопки звука,
				// ордината формы звука - ордината панели команд
				// за вычетом высоты формы звука.
				this._FormSound.Location = new Point
					(
						( this._SkinButtonSound.PointToScreen( new Point( 0, 0 ) ) ).X -
							FormMain.BORDER_WIDTH,
						( this._TableLayoutPanelCommand.PointToScreen
							( new Point( 0, 0 ) ) ).Y - this._FormSound.MaximumHeight +
							FormSound.WHITE_BORDER_WIDTH
					); // new Point
				// Видимая высота формы звука минимальна.
				this._FormSound.VisibleHeight = this._FormSound.MinimumHeight;
			} // if
			// Показ формы звука.
			this._FormSound.Show( this );
			// Активация формы звука.
			this._FormSound.Activate( );
		} // OnSkinButtonSoundMouseEnter

		#region
		/*
		/// <summary>
		/// Включение звука при нажатии на кнопку.
		/// </summary>
		/// <param name="sender">Объект-источник события.</param>
		/// <param name="e">Аргументы события.</param>
		private void OnSkinButtonMuteOffClick( object sender, EventArgs e )
		{
			// Вызов метода-обработчика события класса.
			Program.MainTracer.CallClassEventHandler( FormMain.CLASS_NAME,
				"OnSkinButtonMuteOffClick", sender, e );

			this._SkinButtonMuteOff.Visible = false;
			this._SkinButtonMuteOn.Visible = true;
			this._MuteMode = false;

			if ( this._Movie != null )
				this._Movie.Audio.Volume = this.GetAudioVolumeFromTrackbarSoundValue( );
			else
				if ( this._Audio != null )
					this._Audio.Volume = this.GetAudioVolumeFromTrackbarSoundValue( );
		} // OnSkinButtonMuteOffClick

		/// <summary>
		/// Отключение звука при нажатии на кнопку.
		/// </summary>
		/// <param name="sender">Объект-источник события.</param>
		/// <param name="e">Аргументы события.</param>
		private void OnSkinButtonMuteOnClick( object sender, EventArgs e )
		{
			// Вызов метода-обработчика события класса.
			Program.MainTracer.CallClassEventHandler( FormMain.CLASS_NAME,
				"OnSkinButtonMuteOnClick", sender, e );

			this._SkinButtonMuteOn.Visible = false;
			this._SkinButtonMuteOff.Visible = true;
			this._MuteMode = true;

			if ( this._Movie != null )
				this._Movie.Audio.Volume = FormMain.MINIMUM_AUDIO_VOLUME;
			else
				if ( this._Audio != null )
					this._Audio.Volume = FormMain.MINIMUM_AUDIO_VOLUME;
		} // OnSkinButtonMuteOnClick
		*/
		#endregion

		/// <summary>
		/// Максимизация окна программы при нажатии на кнопку.
		/// </summary>
		/// <param name="sender">Объект-источник события.</param>
		/// <param name="e">Аргументы события.</param>
		private void OnSkinButtonFullScreenClick( object sender, EventArgs e )
		{
			// Вызов метода-обработчика события класса.
			Program.MainTracer.CallClassEventHandler( FormMain.CLASS_NAME,
				"OnSkinButtonFullScreenClick", sender, e );

			// Если видна форма звука, то она скрывается без эффекта,
			// чтобы не оставалась зависать в исходной позиции.
			if ( this._FormSound.Visible )
			{
				this._FormSound.TimerFormVisibleChangingEffectIsActive = false;
				this._FormSound.Hide( );
			} // if

			this._SkinButtonFullScreen.Enabled = false;
			this._SkinButtonSmallScreen.Enabled = true;
			this._SkinButtonFullScreen.Visible = false;
			this._SkinButtonSmallScreen.Visible = true;
			this._FullScreen = true;

			this.WindowState = FormWindowState.Maximized;
			/*
			this.FormBorderStyle = FormBorderStyle.None;
			_MenuStrip.Visible = false;
			_TableLayoutPanelCommand.Height = 1;
			*/
		} // OnSkinButtonFullScreenClick

		/// <summary>
		/// Нормализация окна программы при нажатии на кнопку.
		/// </summary>
		/// <param name="sender">Объект-источник события.</param>
		/// <param name="e">Аргументы события.</param>
		private void OnSkinButtonSmallScreenClick( object sender, EventArgs e )
		{
			// Вызов метода-обработчика события класса.
			Program.MainTracer.CallClassEventHandler( FormMain.CLASS_NAME,
				"OnSkinButtonSmallScreenClick", sender, e );

			// Если видна форма звука, то она скрывается без эффекта,
			// чтобы не оставалась зависать в исходной позиции.
			if ( this._FormSound.Visible )
			{
				this._FormSound.TimerFormVisibleChangingEffectIsActive = false;
				this._FormSound.Hide( );
			} // if

			this._SkinButtonSmallScreen.Enabled = false;
			this._SkinButtonFullScreen.Enabled = true;
			this._SkinButtonSmallScreen.Visible = false;
			this._SkinButtonFullScreen.Visible = true;
			this._FullScreen = false;

			this.WindowState = FormWindowState.Normal;
			/*
			this.FormBorderStyle = FormBorderStyle.Sizable;
			this.FormBorderStyle = FormBorderStyle.None;
			_MenuStrip.Visible = true;
			this._TableLayoutPanelCommand.Height = this._CommandPanelHeight;
			*/

			// Drag & drop 
			DragAcceptFiles( );
		} // OnSkinButtonSmallScreenClick

		/// <summary>
		/// Приостановка проигрывания медиа-файла по нажатию кнопки.
		/// </summary>
		/// <param name="sender">Объект-источник события.</param>
		/// <param name="e">Аргументы события.</param>
		private void OnSkinButtonPauseClick( object sender, EventArgs e )
		{
			// Вызов метода-обработчика события класса.
			Program.MainTracer.CallClassEventHandler( FormMain.CLASS_NAME,
				"OnSkinButtonPauseClick", sender, e );

			if ( ( this._Movie != null ) || ( this._Audio != null ) )
			{
				this._SkinButtonPause.Enabled = false;
				this._SkinButtonPlay.Enabled = /*this._SkinButtonStop.Enabled =*/ true;
				//Movie_Timer.Enabled = false;
				this._TimerMediaEnabled = false;

				if ( this._Movie != null )
					this._Movie.Pause( );
				else
					if ( this._Audio != null )
						this._Audio.Pause( );

				this._SkinButtonPause.Visible = false;
				this._SkinButtonPlay.Visible = true;

				// Запуск таймера закрытия формы -
				// вдруг пользователь поставил паузу и ушёл.
				this._TimerFormClosing.Enabled = true;
			} // if
		} // OnSkinButtonPauseClick

		/// <summary>
		/// Проигрывание медиа-файла по нажатию кнопки.
		/// </summary>
		/// <param name="sender">Объект-источник события.</param>
		/// <param name="e">Аргументы события.</param>
		private void OnSkinButtonPlayClick( object sender, EventArgs e )
		{
			// Вызов метода-обработчика события класса.
			Program.MainTracer.CallClassEventHandler( FormMain.CLASS_NAME,
				"OnSkinButtonPlayClick", sender, e );

			if ( ( this._Movie != null ) || ( this._Audio != null ) )
			{
				this._SkinButtonPlay.Enabled = false;
				/*this._SkinButtonStop.Enabled = */this._SkinButtonFullScreen.Enabled =
					this._SkinButtonPause.Enabled = true;

				if ( this._Movie != null )
					this._Movie.Play( );
				else
					if ( this._Audio != null )
						this._Audio.Play( );

				//Movie_Timer.Enabled = true;
				this._TimerMediaEnabled = true;

				this._SkinButtonPlay.Visible = false;
				this._SkinButtonPause.Visible = true;

				// Отключение таймера закрытия формы -
				// если пользователь ничего не делает, но медиа-файл проигрывается,
				// то считается, что пользователь слушает и/или смотрит его.
				this._TimerFormClosing.Enabled = false;
			} // if
		} // OnSkinButtonPlayClick

		/// <summary>
		/// Нажатие кномки остановки проигрывания.
		/// </summary>
		/// <param name="sender">Объект-источник события.</param>
		/// <param name="e">Аргументы события.</param>
		private void OnSkinButtonStopClick( object sender, EventArgs e )
		{
			// Вызов метода-обработчика события класса.
			Program.MainTracer.CallClassEventHandler( FormMain.CLASS_NAME,
				"OnSkinButtonStopClick", sender, e );

			///this._SkinButtonStop.Enabled = false;
			this._SkinButtonPlay.Enabled = true;
			//Movie_Timer.Enabled = false;
			this._TimerMediaEnabled = false;
			this._SkinTrackbarDuration.Value = 0;

			if ( this._Movie != null )
				this._Movie.Stop( );
			if ( this._Audio != null )
				this._Audio.Stop( );

			this._SkinButtonPlay.Visible = true;
			this._SkinButtonPause.Visible = false;

			// Чтобы бегунок переместился в начало.
			this._MediaCurrentPosition = 0;

			// Запуск таймера закрытия формы -
			// вдруг пользователь остановил проигрывание и ушёл.
			this._TimerFormClosing.Enabled = true;
		} // OnSkinButtonStopClick

		/// <summary>
		/// Закрытие формы по нажатию кнопки.
		/// </summary>
		/// <param name="sender">Объект-источник события.</param>
		/// <param name="e">Аргументы события.</param>
		private void OnSkinButtonExitClick( object sender, EventArgs e )
		{
			// Вызов метода-обработчика события класса.
			Program.MainTracer.CallClassEventHandler( FormMain.CLASS_NAME,
				"OnSkinButtonExitClick", sender, e );

			this.Close( );
		} // OnSkinButtonExitClick


		#endregion TableLayoutPanelCommand Controls Events Handlers


		#endregion Events Handlers


		#endregion Methods
	} // FormMain
} // zap