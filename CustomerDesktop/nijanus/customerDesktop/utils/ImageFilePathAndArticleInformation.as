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

	// Класс информации пути к файлу и артикула изображения.
	public class ImageFilePathAndArticleInformation extends FilePathInformation
	{
		// Переменные экземпляра класса.

		// Артикул.
		private var _Article: String = null;
		//-----------------------------------------------------------------------
		// Методы-конструкторы.

		// Метод-конструктор экземпляра информации
		// пути к файлу и кода изображения.
		// Параметры:
		// parArticle    - артикул,
		// parPathString - текстовая строка пути к файлу.
		public function ImageFilePathAndArticleInformation
		(
			parArticle,
			parPathString: String
		): void
		{
			// Вызов метода-конструктора суперкласса FilePathInformation.
			super( parPathString );			
			// Артикул.
			this._Article = parArticle;
		} // ImageFilePathAndArticleInformation
		//-----------------------------------------------------------------------
		// Get- и set-методы.

		// Get-метод получения артикула.
		// Результат: артикул.
		public function get Article( ): String
		{
			// Артикул.
			return this._Article;
		} // Article

		// Set-метод установки артикула.
		// Параметры:
		// parArticle - артикул.
		public function set Article( parArticle: String ): void
		{
			// Артикул.
			this._Article = parArticle;
		} // Article
	} // ImageFilePathAndArticleInformation
} // nijanus.customerDesktop.utils