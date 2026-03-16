//---------------------------------------------------------------------------
// CustomerDesktop
// Author Kate Kotova
// Creating Tools For Drawing In Pseudo 3D Space
// Created in 2009
// NIJANUS Copyright © 2004-2010
// nijanus@ymail.com
// http://nijanus.narod2.ru
//---------------------------------------------------------------------------

using System;
using System.Collections.Generic;
using System.Drawing;
using System.Text;

namespace DrawingPseudo3D
{
	/// <summary>
	/// Приращение цвета
	/// </summary>
	public class ColorIncrementation
	{
		#region Поля
		/// <summary>
		/// Количество приращений компонент цвета
		/// </summary>
		protected const int COLOR_COMPONENTS_INCREMENTATIONS_NUMBER = 3;

		/// <summary>
		/// Приращение красной компоненты цвета
		/// </summary>
		protected int m_Red;
		/// <summary>
		/// Приращение зелёной компоненты цвета
		/// </summary>
		protected int m_Green;
		/// <summary>
		/// Приращение синей компоненты цвета
		/// </summary>
		protected int m_Blue;
		#endregion Поля

		#region Методы
		/// <summary>
		/// Корректный индекс приращения компоненты цвета
		/// </summary>
		/// <param name="parColorComponentIncrementationIndex">
		/// Индекс приращения компоненты цвета</param>
		/// <returns>Индекс приращения компоненты цвета
		/// в допустимых пределах</returns>
		protected virtual int CorrectColorComponentIncrementationIndex
			( int parColorComponentIncrementationIndex )
		{
			// Если индекс компоненты цвета меньше минимального,
			// то он на него заменяется, если больше максимального,
			// то заменяется на него
			parColorComponentIncrementationIndex = Math.Max
				( parColorComponentIncrementationIndex, 0 );
			parColorComponentIncrementationIndex = Math.Min
				( parColorComponentIncrementationIndex,
				ColorIncrementation.COLOR_COMPONENTS_INCREMENTATIONS_NUMBER - 1 );

			// Возврат скорректированного инедкса приращения компоненты цвета
			return parColorComponentIncrementationIndex;
		} // CorrectColorComponentIncrementationIndex

		#region Операции приведения типов
		/// <summary>
		/// Явное преобразование типа Color в тип ColorIncrementation
		/// </summary>
		/// <param name="parColor">Цвет</param>
		/// <returns>Приращение цвета</returns>
		public static explicit operator ColorIncrementation( Color parColor )
		{
			return new ColorIncrementation( parColor.R, parColor.G, parColor.B );
		} // ColorIncrementation

		/// <summary>
		/// Явное преобразование типа ColorIncrementation в тип Color
		/// </summary>
		/// <param name="parColorIncrementation">Приращение цвета</param>
		/// <returns>Цвет</returns>
		public static explicit operator Color
			( ColorIncrementation parColorIncrementation )
		{
			// Получение компонент цвета из их приращений
			for ( int locColorComponentIndex = 0; locColorComponentIndex <
				ColorIncrementation.COLOR_COMPONENTS_INCREMENTATIONS_NUMBER;
				locColorComponentIndex++ )
			{
				// Если компонента цвета меньше минимальной, то она на неё заменяется,
				// если больше максимальной, то заменяется на неё
				parColorIncrementation[ locColorComponentIndex ] = Math.Max
					( parColorIncrementation[ locColorComponentIndex ], byte.MinValue );
				parColorIncrementation[ locColorComponentIndex ] = Math.Min
					( parColorIncrementation[ locColorComponentIndex ], byte.MaxValue );
			} // for

			// Составление цвета из полученных приращений компонент
			return Color.FromArgb( parColorIncrementation.m_Red,
				parColorIncrementation.m_Green, parColorIncrementation.m_Blue );
		} // ColorIncrementation
		#endregion Операции приведения типов

		#region Арифметические операции приращений цветов
		/// <summary>
		/// Сумма приращений цветов
		/// </summary>
		/// <param name="parFirstColorIncrementation">
		/// Первое приращение цвета</param>
		/// <param name="parSecondColorIncrementation">
		/// Второе приращение цвета</param>
		/// <returns>Приращение цвета</returns>
		public static ColorIncrementation operator +
		(
			ColorIncrementation parFirstColorIncrementation,
			ColorIncrementation parSecondColorIncrementation
		)
		{
			// Сумма приращений цвета, проинициализированная нулевыми значениями
			ColorIncrementation locColorIncrementationsSum =
				new ColorIncrementation( );

			// Сложение приращений компонент цвета
			for ( int locColorComponentIncrementationIndex = 0;
					locColorComponentIncrementationIndex <
					ColorIncrementation.COLOR_COMPONENTS_INCREMENTATIONS_NUMBER;
					locColorComponentIncrementationIndex++ )
				locColorIncrementationsSum[ locColorComponentIncrementationIndex ] =
					parFirstColorIncrementation
					[ locColorComponentIncrementationIndex ] +
					parSecondColorIncrementation
					[ locColorComponentIncrementationIndex ];

			// Возврат полученной суммы
			return locColorIncrementationsSum;
		} // +

		/// <summary>
		/// Сумма цвета и приращения цвета
		/// </summary>
		/// <param name="parFirstColor">Первый цвет</param>
		/// <param name="parSecondColorIncrementation">
		/// Второе приращение цвета</param>
		/// <returns>Цвет</returns>
		public static Color operator +
		(
			Color               parFirstColor,
			ColorIncrementation parSecondColorIncrementation
		)
		{
			// Преобразование первого цвета к приращению цвета,
			// сложение приращений, преобразование суммы в цвет
			// и возврат полученного цвета с прежней альфа-компонентой
			return ColorIncrementation.SetColorAlpha( ( Color )
				( ( ColorIncrementation ) parFirstColor +
				parSecondColorIncrementation ), parFirstColor.A);
		} // +

		/// <summary>
		/// Произведение приращения цвета и целого числа
		/// </summary>
		/// <param name="parIcand">Множимое приращение цвета</param>
		/// <param name="parMultiplier">Целочисленный множитель</param>
		/// <returns>Приращение цвета</returns>
		public static ColorIncrementation operator *
		(
			ColorIncrementation parIcand,
			int                 parMultiplier
		)
		{
			// Произведение приращения цвета и целого числа
			ColorIncrementation locProduct = new ColorIncrementation( );
			// Умоножение приращений компонент цвета на заданный множитель
			for ( int locColorComponentIncrementationIndex = 0;
					locColorComponentIncrementationIndex <
					ColorIncrementation.COLOR_COMPONENTS_INCREMENTATIONS_NUMBER;
					locColorComponentIncrementationIndex++ )
				locProduct[ locColorComponentIncrementationIndex ] =
					parIcand[ locColorComponentIncrementationIndex ] * parMultiplier;

			// Возврат полученного произведения
			return locProduct;
		} // *

		/// <summary>
		/// Частное приращения цвета и целого числа
		/// </summary>
		/// <param name="parDividend">Делимое приращение цвета</param>
		/// <param name="parDivisor">Целочисленный делитель</param>
		/// <returns>Приращение цвета</returns>
		public static ColorIncrementation operator /
		(
			ColorIncrementation parDividend,
			int                 parDivisor
		)
		{
			// Частное приращения цвета и целого числа
			ColorIncrementation locQuotient = new ColorIncrementation( );
			// Деление приращений компонент цвета на заданный делитель
			for ( int locColorComponentIncrementationIndex = 0;
					locColorComponentIncrementationIndex <
					ColorIncrementation.COLOR_COMPONENTS_INCREMENTATIONS_NUMBER;
					locColorComponentIncrementationIndex++ )
				locQuotient[ locColorComponentIncrementationIndex ] =
					parDividend[ locColorComponentIncrementationIndex ] / parDivisor;

			// Возврат полученного частного
			return locQuotient;
		} // /
		#endregion Арифметические операции приращений цветов

		#region Методы обработки цветов
		/// <summary>
		/// Разность цветов
		/// </summary>
		/// <param name="parMinuendColor">Уменьшаемый цвет</param>
		/// <param name="parSubtrahendColor">Вычитаемый цвет</param>
		/// <returns>Приращение вычитаемого цвета до уменьшаемого</returns>
		public static ColorIncrementation ColorsDifference
		(
			Color parMinuendColor,
			Color parSubtrahendColor
		)
		{
			return new ColorIncrementation
				( ( int ) parMinuendColor.R - ( int ) parSubtrahendColor.R,
					( int ) parMinuendColor.G - ( int ) parSubtrahendColor.G,
					( int ) parMinuendColor.B - ( int ) parSubtrahendColor.B );
		} // ColorsDifference

		/// <summary>
		/// Установка альфа-компоненты прозрачности цвета
		/// </summary>
		/// <param name="parColor">Цвет</param>
		/// <param name="parAlpha">Альфа-компонента прозрачности</param>
		/// <returns>Цвет с новой альфа-компонентой</returns>
		public static Color SetColorAlpha
		(
			Color parColor,
			int   parAlpha
		)
		{
			// Если альфа-компонента цвета меньше минимальной,
			// то она на неё заменяется, если больше максимальной,
			// то заменяется на неё
			parAlpha = Math.Max( parAlpha, byte.MinValue );
			parAlpha = Math.Min( parAlpha, byte.MaxValue );

			// Возврат прежнего цвета с новой альфа-компонентой
			return Color.FromArgb( parAlpha, parColor.R, parColor.G, parColor.B );
		} // SetColorAlpha

		/// <summary>
		/// Умножение действительного коэффициента на цвет
		/// </summary>
		/// <param name="parCoefficient">Действительный коэффициент</param>
		/// <param name="parColor">Цвет</param>
		/// <returns>Цвет</returns>
		public static Color FloatAndColorMultiplying
		(
			float parCoefficient,
			Color parColor
		)
		{
			// Приращение цвета, равное заданному цвету
			ColorIncrementation locColorIncrementation =
				( ColorIncrementation ) parColor;

			// Умножение действительного коэффициента на цвет
			for ( int locColorComponentIndex = 0; locColorComponentIndex <
					ColorIncrementation.COLOR_COMPONENTS_INCREMENTATIONS_NUMBER;
					locColorComponentIndex++ )
				// Умножение действительного коэффициента на компоненту цвета
				locColorIncrementation[ locColorComponentIndex ] = ( int )
					( parCoefficient *
					( float ) locColorIncrementation[ locColorComponentIndex ] );

			// Составление цвета из полученных компонент
			// с изначальной альфа-компонентой
			return ColorIncrementation.SetColorAlpha
				( ( Color ) locColorIncrementation, parColor.A );
		} // FloatAndColorMultiplying
		#endregion Методы обработки цветов
		#endregion Методы

		#region Конструкторы
		/// <summary>
		/// Создание нулевого приращения цвета
		/// </summary>
		public ColorIncrementation( )
		{
			this.m_Red   = 0;
			this.m_Green = 0;
			this.m_Blue  = 0;
		} // ColorIncrementation

		/// <summary>
		/// Создание приращения цвета
		/// </summary>
		/// <param name="parRed">Приращение красной компоненты цвета</param>
		/// <param name="parGreen">Приращение зелёной компоненты цвета</param>
		/// <param name="parBlue">Приращение синей компоненты цвета</param>
		public ColorIncrementation
		(
			int parRed,
			int parGreen,
			int parBlue
		)
		{
			this.m_Red   = parRed;
			this.m_Green = parGreen;
			this.m_Blue  = parBlue;
		} // ColorIncrementation
		#endregion Конструкторы

		#region Свойства
		/// <summary>
		/// Приращение красной компоненты цвета
		/// </summary>
		public virtual int Red
		{
			get
			{
				return this.m_Red;
			} // get
			set
			{
				this.m_Red = value;
			} // set
		} // Red

		/// <summary>
		/// Приращение зелёной компоненты цвета
		/// </summary>
		public virtual int Green
		{
			get
			{
				return this.m_Green;
			} // get
			set
			{
				this.m_Green = value;
			} // set
		} // Green

		/// <summary>
		/// Приращение синей компоненты цвета
		/// </summary>
		public virtual int Blue
		{
			get
			{
				return this.m_Blue;
			} // get
			set
			{
				this.m_Blue = value;
			} // set
		} // Blue

		/// <summary>
		/// Индексатор - приращение компоненты цвета по индексу
		/// </summary>
		/// <param name="parColorComponentIncrementationIndex">
		/// Индекс приращения компоненты цвета</param>
		/// <returns>Приращение компоненты цвета</returns>
		public virtual int this[ int parColorComponentIncrementationIndex ]
		{
			get
			{
				// Корректный индекс приращения компоненты цвета
				parColorComponentIncrementationIndex =
					this.CorrectColorComponentIncrementationIndex
					( parColorComponentIncrementationIndex );

				switch ( parColorComponentIncrementationIndex )
				{
					// Приращение красной компоненты цвета
					case 0 :
						return this.m_Red;

					// Приращение зелёной компоненты цвета
					case 1 :
						return this.m_Green;

					// Приращение синей компоненты цвета
					case 2 :
						return this.m_Blue;

					// Прочие непредусмотренные значения индекса
					default :
						return 0;
				} // switch
			} // get

			set
			{
				// Корректный индекс приращения компоненты цвета
				parColorComponentIncrementationIndex =
					this.CorrectColorComponentIncrementationIndex
					( parColorComponentIncrementationIndex );

				switch ( parColorComponentIncrementationIndex )
				{
					// Приращение красной компоненты цвета
					case 0 :
						this.m_Red   = value;
						break;

					// Приращение зелёной компоненты цвета
					case 1 :
						this.m_Green = value;
						break;

					// Приращение синей компоненты цвета
					case 2 :
						this.m_Blue  = value;
						break;

					// Прочие непредусмотренные значения индекса
					default :
						break;
				} // switch
			} // set
		} // Item
		#endregion Свойства
	} // ColorIncrementation
} // DrawingPseudo3D