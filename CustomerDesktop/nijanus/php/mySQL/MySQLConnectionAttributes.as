// CustomerDesktop
// Author Kate Kotova
// NIJANUS Copyright © 2004-2010
// nijanus@ymail.com
// http://nijanus.narod2.ru
//---------------------------------------------------------------------------
// Пакет классов, взаимодействующих с PHP и MySQL.
package nijanus.php.mySQL
{
	// Класс атрибутов соединения с базой данных MySQL.
	public class MySQLConnectionAttributes
	{
		// Список импортированных классов из других пакетов.
		import flash.net.URLVariables;
		//-----------------------------------------------------------------------		
		// Переменные экземпляра класса.

		// Имя хоста.
		private var _HostName:            String = null;
		// Имя пользователя.
		private var _UserName:            String = null;
		// Пароль пользователя.
		private var _UserPassword:        String = null;
		// Имя базы данных.
		private var _DatabaseName:        String = null;
		// Название набора символов,
		// используемого для интерпретации байтов в базе данных.
		private var _DatabaseСharSetName: String = null; 
		//-----------------------------------------------------------------------
		// Методы экземпляра класса.
		
		// Метод добавления URL-переменных.
		// Параметры:
		// parURLVariables - URL-переменные.
		public function AddURLVariables( parURLVariables: URLVariables ): void
		{
			// Имя хоста.
			parURLVariables.HostName     = this._HostName;
			// Имя пользователя.
			parURLVariables.UserName     = this._UserName;
			// Пароль пользователя.
			parURLVariables.UserPassword = this._UserPassword;
			// Имя базы данных.
			parURLVariables.DatabaseName = this._DatabaseName;
		} // AddURLVariables		
		//-----------------------------------------------------------------------
		// Методы-конструкторы.
		
		// Метод-конструктор экземпляра
		// атрибутов соединения с базой данных MySQL.
		// Параметры:
		// parHostName            - имя хоста,
		// parUserName            - имя пользователя,
		// parUserPassword        - пароль пользователя,
		// parDatabaseName        - имя базы данных,
		// parDatabaseСharSetName - название набора символов,
		//   используемого для интерпретации байтов в базе данных.
		public function MySQLConnectionAttributes
		(
			parHostName,
			parUserName,
			parUserPassword,
			parDatabaseName,
			parDatabaseСharSetName: String
		): void
		{
			// Имя хоста.
			this._HostName     = parHostName;
			// Имя пользователя.
			this._UserName     = parUserName;
			// Пароль пользователя.
			this._UserPassword = parUserPassword;
			// Имя базы данных.
			this._DatabaseName = parDatabaseName;
			// Название набора символов,
			// используемого для интерпретации байтов в базе данных.
			this._DatabaseСharSetName = parDatabaseСharSetName;	
		} // MySQLConnectionAttributes
		//-----------------------------------------------------------------------	
		// Get- и set-методы.

		// Get-метод получения имени хоста.
		// Результат: имя хоста.
		public function get HostName( ): String
		{
			// Имя хоста.
			return this._HostName;
		} // HostName
		
		// Get-метод получения имени пользователя.
		// Результат: имя пользователя.
		public function get UserName( ): String
		{
			// Имя пользователя.
			return this._UserName;
		} // UserName
		
		// Get-метод получения пароля пользователя.
		// Результат: пароль пользователя.
		public function get UserPassword( ): String
		{
			// Пароль пользователя.
			return this._UserPassword;
		} // UserPassword
		
		// Get-метод получения имени базы данных.
		// Результат: имя базы данных.
		public function get DatabaseName( ): String
		{
			// Имя базы данных.
			return this._DatabaseName;
		} // DatabaseName		
		
		// Get-метод получения называния набора символов,
		// используемого для интерпретации байтов в базе данных.
		// Результат: название набора символов,
		// используемого для интерпретации байтов в базе данных.
		public function get DatabaseСharSetName( ): String
		{
			// Название набора символов,
			// используемого для интерпретации байтов в базе данных.
			return this._DatabaseСharSetName;
		} // DatabaseСharSetName				
	} // MySQLConnectionAttributes
} // nijanus.php.mySQL