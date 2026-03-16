// CustomerDesktop
// Author Kate Kotova
// NIJANUS Copyright © 2004-2010
// nijanus@ymail.com
// http://nijanus.narod2.ru
//---------------------------------------------------------------------------
// Пакет классов рабочего стола покупателя, взаимодействующих с PHP и MySQL
// для выбора имён изображений.
package nijanus.customerDesktop.phpAndMySQL.imagesNamesSelector
{
	// Класс типа экрана выбора.
	public class ChoiceScreenType
	{
		// Статические константы.
		
		// Неизвестный.
		public static const UNKNOWN:     String = "UNKNOWN";
		// Значение по умолчанию.
		public static const DEFAULT:     String = "DEFAULT";
		
		// Новые DVD.
		public static const NEW_DVD:     String = "NEW_DVD";
		// Первые хиты.
		public static const FIRST_HITS:  String = "FIRST_HITS";
		// Вторые хиты.
		public static const SECOND_HITS: String = "SECOND_HITS";
		// Первые DVD.
		public static const FIRST_DVD:   String = "FIRST_DVD";
		// Вторые DVD.
		public static const SECOND_DVD:  String = "SECOND_DVD";		
		// Blu-ray.
		public static const BLU_RAY:     String = "BLU_RAY";
		// Игры.
		public static const GAMES:       String = "GAMES";
		// Игры для ПК.
		public static const PC_GAMES:    String = "PC_GAMES";
		// Музыка DVD.
		public static const DVD_MUSIC:   String = "DVD_MUSIC";
		// Музыка CD.
		public static const CD_MUSIC:    String = "CD_MUSIC";
		
		// Значения.
		public static const VALUES:      Array  =
		[
			// 0  - Неизвестный.
			ChoiceScreenType.UNKNOWN,
			// 1  - Значение по умолчанию.
			ChoiceScreenType.DEFAULT,
			
			// 2  - Новые DVD.
			ChoiceScreenType.NEW_DVD,
			// 3  - Первые хиты.
			ChoiceScreenType.FIRST_HITS,
			// 4  - Вторые хиты.
			ChoiceScreenType.SECOND_HITS,
			// 5  - Первые DVD.
			ChoiceScreenType.FIRST_DVD,
			// 6  - Вторые DVD.
			ChoiceScreenType.SECOND_DVD,
			// 7  - Blu-ray.
			ChoiceScreenType.BLU_RAY,
			// 8  - Игры.
			ChoiceScreenType.GAMES,
			// 9  - Игры для ПК.
			ChoiceScreenType.PC_GAMES,
			// 10 - Музыка DVD.
			ChoiceScreenType.DVD_MUSIC,
			// 11 - Музыка CD.
			ChoiceScreenType.CD_MUSIC
		]; // VALUES
		
		// Минимальный индекс известного значения.
		public static const KNOWN_VALUE_MINIMUM_INDEX =
			ChoiceScreenType.VALUES.indexOf( ChoiceScreenType.DEFAULT,  0 );
		// Максимальный индекс известного значения.
		public static const KNOWN_VALUE_MAXIMUM_INDEX =
			ChoiceScreenType.VALUES.indexOf( ChoiceScreenType.CD_MUSIC, 0 );
		//-----------------------------------------------------------------------
		// Статические методы.
		
		// Метод, определяющий, существует ли значение
		// в пределах множества допустимых.
		// Параметры:
		// parValue - значение.		
		// Результат: признак существования значения
		// в пределах множества допустимых.
		public static function ValueIsExist( parValue: String ): Boolean
		{
			// Если значение не существует в пределах множества допустимых.
			if ( ChoiceScreenType.VALUES.indexOf( parValue, 0 ) < 0 )
				// Признак ложен.
				return false;
			// Если значение существует в пределах множества допустимых.
			else
				// Признак истинен.
				return true;
		} // ValueIsExist
		
		// Метод, определяющий, находится ли индекс значения в массиве
		// в пределах множества индексов известных значений.
		// Параметры:
		// parValueIndex - индекс значения.		
		// Результат: признак локализации индекса значения в массиве
		// в пределах множества индексов известных значений.
		public static function IndexIsOfKnownValue( parValueIndex: int ): Boolean
		{
			// Если индекс находится вне пределов индексов известных значений.
			if
			(
				( parValueIndex < ChoiceScreenType.KNOWN_VALUE_MINIMUM_INDEX ) ||
				( parValueIndex > ChoiceScreenType.KNOWN_VALUE_MAXIMUM_INDEX )
			)
				// Признак ложен.
				return false;
			// Если индекс находится в пределах индексов известных значений.
			else
				// Признак истинен.
				return true;
		} // IndexIsOfKnownValue
		
		// Метод получения индекса значения из массива.
		// Индексация элементов в массиве начинается с нуля.
		// Если значение вне пределов множества допустимых, то возвращается (-1). 
		// Параметры:
		// parValue - значение.		
		// Результат: индекс значения в массиве, позиция которого
		// начинается с нуля и равна (-1) в случае безрезультатного поиска.
		public static function IndexOfValue( parValue: String ): int
		{
			// Индекс значения в массиве, поиск которого начинается
			// с самого первого - нулевого - элемента.
			return ChoiceScreenType.VALUES.indexOf( parValue, 0 );
		} // IndexOfValue		
		
		// Метод получения значения по индексу из массива.
		// Индексация элементов в массиве начинается с нуля.
		// Если индекс находится вне пределов индексов известных значений,
		// значение считается неизвестным.
		// Параметры:
		// parValueIndex - индекс значения.		
		// Результат: значение по индексу из массива,
		// которое является неизвестным в случае выхода индекса
		// за пределы множества индексов известных значений.		
		public static function ValueOfIndex( parValueIndex: int ): String
		{
			// Если индекс находится вне пределов индексов известных значений.
			if
			(
				( parValueIndex < ChoiceScreenType.KNOWN_VALUE_MINIMUM_INDEX ) ||
				( parValueIndex > ChoiceScreenType.KNOWN_VALUE_MAXIMUM_INDEX )
			)
				// Значение неизвестное.
				return ChoiceScreenType.UNKNOWN;
			// Если индекс находится в пределах индексов известных значений.
			else
				// Значение по индексу из массива.
				return ChoiceScreenType.VALUES[ parValueIndex ];
		} // ValueOfIndex		
		
		// Метод получения значения,
		// устанавливающегося в пределах множества допустимых, из строки.
		// Параметры:
		// parValue - значение.		
		// Результат: значение в пределах множества допустимых.
		public static function GetValueFromString( parValue: String ): String
		{
			// Если значение не существует в пределах множества допустимых.
			if ( ChoiceScreenType.VALUES.indexOf( parValue, 0 ) < 0 )
				// Значение неизвестное.
				return ChoiceScreenType.UNKNOWN;
			// Если значение существует в пределах множества допустимых.
			else
				// Значение существующее.
				return parValue;
		} // GetValueFromString
	} // ChoiceScreenType
} // nijanus.customerDesktop.phpAndMySQL.imagesNamesSelector