// CustomerDesktop
// Author Kate Kotova
// NIJANUS Copyright © 2004-2010
// nijanus@ymail.com
// http://nijanus.narod2.ru
//---------------------------------------------------------------------------
// Пакет дополнительных полезных классов.
package nijanus.utils
{
	// Класс информации пути к файлу.
	public class FilePathInformation
	{
		// Переменные экземпляра класса.

		// Текстовая строка пути к файлу.
		private var _PathString: String = null;
		//-----------------------------------------------------------------------
		// Методы-конструкторы.

		// Метод-конструктор экземпляра информации пути к файлу.
		// Параметры:
		// parPathString - текстовая строка пути к файлу.
		public function FilePathInformation( parPathString: String ): void
		{
			// Текстовая строка пути к файлу.
			this._PathString = parPathString;
		} // FilePathInformation
		//-----------------------------------------------------------------------
		// Get- и set-методы.

		// Get-метод получения текстовой строки пути к файлу.
		// Результат: текстовая строка пути к файлу.
		public function get PathString( ): String
		{
			// Текстовая строка пути к файлу.
			return this._PathString;
		} // PathString

		// Set-метод установки текстовой строки пути к файлу.
		// Параметры:
		// parPathString - текстовая строка пути к файлу.
		public function set PathString( parPathString: String ): void
		{
			// Текстовая строка пути к файлу.
			this._PathString = parPathString;
		} // PathString
	} // FilePathInformation
} // nijanus.utils