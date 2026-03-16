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
	// Класс типа фильтрации имён изображений.
	public class ImagesNamesFilteringType
	{
		// Статические константы.
		
		// Неизвестный.
		public static const UNKNOWN:     String = "UNKNOWN";
		
		// Витрина.
		public static const SHOP_WINDOW: String = "SHOP_WINDOW";		
		// Новинка.
		public static const NOVELTY:     String = "NOVELTY";		
		// Страна.
		public static const COUNTRY:     String = "COUNTRY";		
		// Группа.
		public static const GROUP:       String = "GROUP";		
		// Категория.
		public static const CATEGORY:    String = "CATEGORY";
		
		// Значения.
		public static const VALUES:      Array  =
		[
			// 0 - Неизвестный.
			ImagesNamesFilteringType.UNKNOWN,
			
			// 1 - Витрина.
			ImagesNamesFilteringType.SHOP_WINDOW,
			// 2 - Новинка.
			ImagesNamesFilteringType.NOVELTY,
			// 3 - Страна.
			ImagesNamesFilteringType.COUNTRY,
			// 4 - Группа.
			ImagesNamesFilteringType.GROUP,
			// 5 - Категория.
			ImagesNamesFilteringType.CATEGORY
		]; // VALUES
		
		// Минимальный индекс известного значения.
		public static const KNOWN_VALUE_MINIMUM_INDEX =
			ImagesNamesFilteringType.VALUES.indexOf
			( ImagesNamesFilteringType.SHOP_WINDOW, 0 );
		// Максимальный индекс известного значения.
		public static const KNOWN_VALUE_MAXIMUM_INDEX =
			ImagesNamesFilteringType.VALUES.indexOf
			( ImagesNamesFilteringType.CATEGORY,    0 );			
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
			if ( ImagesNamesFilteringType.VALUES.indexOf( parValue, 0 ) < 0 )
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
				( parValueIndex <
					ImagesNamesFilteringType.KNOWN_VALUE_MINIMUM_INDEX ) ||
				( parValueIndex >
					ImagesNamesFilteringType.KNOWN_VALUE_MAXIMUM_INDEX )
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
			return ImagesNamesFilteringType.VALUES.indexOf( parValue, 0 );
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
				( parValueIndex <
					ImagesNamesFilteringType.KNOWN_VALUE_MINIMUM_INDEX ) ||
				( parValueIndex >
					ImagesNamesFilteringType.KNOWN_VALUE_MAXIMUM_INDEX )
			)
				// Значение неизвестное.
				return ImagesNamesFilteringType.UNKNOWN;
			// Если индекс находится в пределах индексов известных значений.
			else
				// Значение по индексу из массива.
				return ImagesNamesFilteringType.VALUES[ parValueIndex ];
		} // ValueOfIndex		
		
		// Метод получения значения,
		// устанавливающегося в пределах множества допустимых, из строки.
		// Параметры:
		// parValue - значение.		
		// Результат: значение в пределах множества допустимых.
		public static function GetValueFromString( parValue: String ): String
		{
			// Если значение не существует в пределах множества допустимых.
			if ( ImagesNamesFilteringType.VALUES.indexOf( parValue, 0 ) < 0 )
				// Значение неизвестное.
				return ImagesNamesFilteringType.UNKNOWN;
			// Если значение существует в пределах множества допустимых.
			else
				// Значение существующее.
				return parValue;
		} // GetValueFromString
	} // ImagesNamesFilteringType
} // nijanus.customerDesktop.phpAndMySQL.imagesNamesSelector