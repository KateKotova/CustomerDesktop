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
	// Класс типа упорядочения имён изображений.
	public class ImagesNamesOrderingType
	{
		// Статические константы.
		
		// Неизвестный.
		public static const UNKNOWN: String = "UNKNOWN";
		
		// Дата.
		public static const DATE:    String = "DATE";		
		// Наименование.
		public static const NAME:    String = "NAME";
		
		// Значения.
		public static const VALUES:  Array  =
		[
			// 0 - Неизвестный.
			ImagesNamesOrderingType.UNKNOWN,
			
			// 1 - Дата.
			ImagesNamesOrderingType.DATE,
			// 2 - Наименование.
			ImagesNamesOrderingType.NAME
		]; // VALUES
		
		// Минимальный индекс известного значения.
		public static const KNOWN_VALUE_MINIMUM_INDEX =
			ImagesNamesOrderingType.VALUES.indexOf
			( ImagesNamesOrderingType.DATE, 0 );
		// Максимальный индекс известного значения.
		public static const KNOWN_VALUE_MAXIMUM_INDEX =
			ImagesNamesOrderingType.VALUES.indexOf
			( ImagesNamesOrderingType.NAME, 0 );			
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
			if ( ImagesNamesOrderingType.VALUES.indexOf( parValue, 0 ) < 0 )
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
					ImagesNamesOrderingType.KNOWN_VALUE_MINIMUM_INDEX ) ||
				( parValueIndex >
					ImagesNamesOrderingType.KNOWN_VALUE_MAXIMUM_INDEX )
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
			return ImagesNamesOrderingType.VALUES.indexOf( parValue, 0 );
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
					ImagesNamesOrderingType.KNOWN_VALUE_MINIMUM_INDEX ) ||
				( parValueIndex >
					ImagesNamesOrderingType.KNOWN_VALUE_MAXIMUM_INDEX )
			)
				// Значение неизвестное.
				return ImagesNamesOrderingType.UNKNOWN;
			// Если индекс находится в пределах индексов известных значений.
			else
				// Значение по индексу из массива.
				return ImagesNamesOrderingType.VALUES[ parValueIndex ];
		} // ValueOfIndex		
		
		// Метод получения значения,
		// устанавливающегося в пределах множества допустимых, из строки.
		// Параметры:
		// parValue - значение.		
		// Результат: значение в пределах множества допустимых.
		public static function GetValueFromString( parValue: String ): String
		{
			// Если значение не существует в пределах множества допустимых.
			if ( ImagesNamesOrderingType.VALUES.indexOf( parValue, 0 ) < 0 )
				// Значение неизвестное.
				return ImagesNamesOrderingType.UNKNOWN;
			// Если значение существует в пределах множества допустимых.
			else
				// Значение существующее.
				return parValue;
		} // GetValueFromString
	} // ImagesNamesOrderingType
} // nijanus.customerDesktop.phpAndMySQL.imagesNamesSelector