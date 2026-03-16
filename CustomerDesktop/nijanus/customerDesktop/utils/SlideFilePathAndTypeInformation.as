// CustomerDesktop
// Author Kate Kotova
// NIJANUS Copyright © 2004-2010
// nijanus@ymail.com
// http://nijanus.narod2.ru
//---------------------------------------------------------------------------
// Пакет дополнительных полезных классов рабочего стола покупателя.
package nijanus.customerDesktop.utils
{
	// Список импортированных классов из других пакетов.
	import nijanus.utils.FilePathInformation;
	//-------------------------------------------------------------------------

	// Класс информации пути к файлу и типа слайда.
	public class SlideFilePathAndTypeInformation extends FilePathInformation
	{
		// Переменные экземпляра класса.

		// Тип.
		private var _Type: String = null;
		//-----------------------------------------------------------------------
		// Методы-конструкторы.

		// Метод-конструктор экземпляра информации
		// пути к файлу и типа слайда.
		// Параметры:
		// parType       - тип,
		// parPathString - текстовая строка пути к файлу.
		public function SlideFilePathAndTypeInformation
		(
			parType,
			parPathString: String
		): void
		{
			// Вызов метода-конструктора суперкласса FilePathInformation.
			super( parPathString );			
			// Тип.
			this._Type = parType;
		} // SlideFilePathAndTypeInformation
		//-----------------------------------------------------------------------
		// Get- и set-методы.

		// Get-метод получения типа.
		// Результат: тип.
		public function get Type( ): String
		{
			// Тип.
			return this._Type;
		} // Type

		// Set-метод установки типа.
		// Параметры:
		// parType - тип.
		public function set Type( parType: String ): void
		{
			// Тип.
			this._Type = parType;
		} // Type
	} // SlideFilePathAndTypeInformation
} // nijanus.customerDesktop.utils