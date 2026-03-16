// CustomerDesktop
// Author Kate Kotova
// NIJANUS Copyright © 2004-2010
// nijanus@ymail.com
// http://nijanus.narod2.ru
//---------------------------------------------------------------------------
// Пакет классов рабочего стола покупателя, взаимодействующих с PHP и MySQL.
package nijanus.customerDesktop.phpAndMySQL
{
	// Класс категории диска.
	public class DiskCategory
	{
		// Статические константы.
		
		// Неизвестный.
		public static const UNKNOWN:             String = "UNKNOWN";
		
		// Приключения.
		public static const ADVENTURES:          String = "ADVENTURES";	
		// Драма.
		public static const DRAMA:               String = "DRAMA";
		// Мультфильмы.
		public static const ANIMATION:           String = "ANIMATION";	
		// Прочее.
		public static const MISCELLANEOUS:       String = "MISCELLANEOUS";
		// Советские.
		public static const SOVIET:              String = "SOVIET";
		// Познавательные.
		public static const STUDY:               String = "STUDY";
		
		// Blu-ray-новинки.
		public static const BLU_RAY_NOVELTIES:   String = "BLU_RAY_NOVELTIES";
		// Blu-ray-зарубежные.
		public static const BLU_RAY_OVERSEAS:    String = "BLU_RAY_OVERSEAS";			
		// Blu-ray-отечественные.
		public static const BLU_RAY_DOMESTIC:    String = "BLU_RAY_DOMESTIC";
		
		// PS3.
		public static const PS3:                 String = "PS3";	
		// Xbox360.
		public static const XBOX360:             String = "XBOX360";	
		// Nintendo.
		public static const NINTENDO:            String = "NINTENDO";	
		
		// Новинки игр для ПК.
		public static const PC_GAMES_NOVELTIES:  String = "PC_GAMES_NOVELTIES";
		// Зарубежные игры для ПК.
		public static const PC_GAMES_OVERSEAS:   String = "PC_GAMES_OVERSEAS";			
		// Отечественные игры для ПК.
		public static const PC_GAMES_DOMESTIC:   String = "PC_GAMES_DOMESTIC";
		
		// Новинки DVD-музыки.
		public static const DVD_MUSIC_NOVELTIES: String = "DVD_MUSIC_NOVELTIES";
		// Зарубежная DVD-музыка.
		public static const DVD_MUSIC_OVERSEAS:  String = "DVD_MUSIC_OVERSEAS";			
		// Отечественная DVD-музыка.
		public static const DVD_MUSIC_DOMESTIC:  String = "DVD_MUSIC_DOMESTIC";	
		
		// Новинки CD-музыки.
		public static const CD_MUSIC_NOVELTIES:  String = "CD_MUSIC_NOVELTIES";
		// Зарубежная CD-музыка.
		public static const CD_MUSIC_OVERSEAS:   String = "CD_MUSIC_OVERSEAS";			
		// Отечественная CD-музыка.
		public static const CD_MUSIC_DOMESTIC:   String = "CD_MUSIC_DOMESTIC";		
		
		// Значения.
		public static const VALUES:           Array  =
		[
			// 0 - Неизвестный.
			DiskCategory.UNKNOWN,
			
			//  0 - Неизвестный.
			DiskCategory.UNKNOWN,
			
			//  1 - Приключения.
			DiskCategory.ADVENTURES,
			//  2 - Драма.
			DiskCategory.DRAMA,
			//  3 - Мультфильмы.
			DiskCategory.ANIMATION,
			//  4 - Прочее.
			DiskCategory.MISCELLANEOUS,
			//  5 - Советские.
			DiskCategory.SOVIET,
			//  6 - Познавательные.
			DiskCategory.STUDY,
			
			//  7 - Blu-ray-новинки.
			DiskCategory.BLU_RAY_NOVELTIES,
			//  8 - Blu-ray-зарубежные.
			DiskCategory.BLU_RAY_OVERSEAS,		
			//  9 - Blu-ray-отечественные.
			DiskCategory.BLU_RAY_DOMESTIC,
			
			// 10 - PS3.
			DiskCategory.PS3,
			// 11 - Xbox360.
			DiskCategory.XBOX360,
			// 12 - Nintendo.
			DiskCategory.NINTENDO,
			
			// 13 - Новинки игр для ПК.
			DiskCategory.PC_GAMES_NOVELTIES,
			// 14 - Зарубежные игры для ПК.
			DiskCategory.PC_GAMES_OVERSEAS,
			// 15 - Отечественные игры для ПК.
			DiskCategory.PC_GAMES_DOMESTIC,
			
			// 16 - Новинки DVD-музыки.
			DiskCategory.DVD_MUSIC_NOVELTIES,
			// 17 - Зарубежная DVD-музыка.
			DiskCategory.DVD_MUSIC_OVERSEAS,
			// 18 - Отечественная DVD-музыка.
			DiskCategory.DVD_MUSIC_DOMESTIC,
			
			// 19 - Новинки CD-музыки.
			DiskCategory.CD_MUSIC_NOVELTIES,
			// 20 - Зарубежная CD-музыка.
			DiskCategory.CD_MUSIC_OVERSEAS,
			// 21 - Отечественная CD-музыка.
			DiskCategory.CD_MUSIC_DOMESTIC
		]; // VALUES
		
		// Минимальный индекс известного значения.
		public static const KNOWN_VALUE_MINIMUM_INDEX =
			DiskCategory.VALUES.indexOf( DiskCategory.ADVENTURES,        0 );
		// Максимальный индекс известного значения.
		public static const KNOWN_VALUE_MAXIMUM_INDEX =
			DiskCategory.VALUES.indexOf( DiskCategory.CD_MUSIC_DOMESTIC, 0 );			
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
			if ( DiskCategory.VALUES.indexOf( parValue, 0 ) < 0 )
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
				( parValueIndex < DiskCategory.KNOWN_VALUE_MINIMUM_INDEX ) ||
				( parValueIndex > DiskCategory.KNOWN_VALUE_MAXIMUM_INDEX )
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
			return DiskCategory.VALUES.indexOf( parValue, 0 );
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
				( parValueIndex < DiskCategory.KNOWN_VALUE_MINIMUM_INDEX ) ||
				( parValueIndex > DiskCategory.KNOWN_VALUE_MAXIMUM_INDEX )
			)
				// Значение неизвестное.
				return DiskCategory.UNKNOWN;
			// Если индекс находится в пределах индексов известных значений.
			else
				// Значение по индексу из массива.
				return DiskCategory.VALUES[ parValueIndex ];
		} // ValueOfIndex		
		
		// Метод получения значения,
		// устанавливающегося в пределах множества допустимых, из строки.
		// Параметры:
		// parValue - значение.		
		// Результат: значение в пределах множества допустимых.
		public static function GetValueFromString( parValue: String ): String
		{
			// Если значение не существует в пределах множества допустимых.
			if ( DiskCategory.VALUES.indexOf( parValue, 0 ) < 0 )
				// Значение неизвестное.
				return DiskCategory.UNKNOWN;
			// Если значение существует в пределах множества допустимых.
			else
				// Значение существующее.
				return parValue;
		} // GetValueFromString
	} // DiskCategory
} // nijanus.customerDesktop.phpAndMySQL