//---------------------------------------------------------------------------
// CustomerDesktop
// Author Kate Kotova
// NIJANUS Copyright © 2004-2010
// nijanus@ymail.com
// http://nijanus.narod2.ru
//---------------------------------------------------------------------------

using System;
using System.Collections.Generic;
using System.Text;
using System.IO;

namespace zap
{
	/// <summary>
	/// Трассировщик.
	/// </summary>
	public class Tracer
	{
		#region Fields


		#region Constants


		/// <summary>
		/// Точка.
		/// </summary>
		public const string POINT = ".";
		/// <summary>
		/// Запятая.
		/// </summary>
		public const string COMMA = ", ";
		/// <summary>
		/// Открывающая кругая скобка.
		/// </summary>
		public const string OPENING_PARENTHESIS = "( ";
		/// <summary>
		/// Закрывающая кругая скобка.
		/// </summary>
		public const string CLOSING_PARENTHESIS = " )";
		/// <summary>
		/// Равенство.
		/// </summary>
		public const string EQUALITY = " = ";
		/// <summary>
		/// Строка null-значения.
		/// </summary>
		public const string NULL_STRING = "null";

		/// <summary>
		/// Сообщение о создании нового экземпляра класса.
		/// </summary>
		public const string NEW_CLASS_INSTANCE_CREATION_MESSAGE =
			"Create a new instance of the class ";
		// Сообщение о вызове метода класса.
		public const string CALL_CLASS_METHOD_MESSAGE =
			"Call the class method ";
		// Сообщение о вызове метода-обработчика события класса.
		public const string CALL_CLASS_EVENT_HANDLER_MESSAGE =
			"Call the class event handler ";
		// Сообщение о получении свойства класса.
		public const string GET_CLASS_PROPERTIE_MESSAGE =
			"Get the class propertie ";
		// Сообщение об установке свойства класса.
		public const string SET_CLASS_PROPERTIE_MESSAGE =
			"Set the class propertie ";
		// Сообщение о возникновении ошибки.
		public const string SEND_ERROR_MESSAGE =
			"The error is occurred: ";

		/// <summary>
		/// Путь к лог-файлу по умолчанию.
		/// </summary>
		public const string DEFAULT_LOG_FILE_PATH = "Log.txt";
		/// <summary>
		/// Строка окончания лог-файла.
		/// </summary>
		public const string LOG_FILE_END = "END";


		#endregion Constants


		#region Variabes


		/// <summary>
		/// Путь к лог-файлу: в этом файле ведётся протокол выполняемых действий.
		/// </summary>
		private string _LogFilePath = "Log.txt";
		/// <summary>
		/// Писатель файлового потока лога.
		/// </summary>
		private StreamWriter _LogFileStreamWriter = null;


		#endregion Variabes


		#endregion Fields


		/// <summary>
		/// Метод-конструктор экземпляра трассировщика.
		/// </summary>
		/// <param name="parLogFilePath">Путь к лог-файлу.</param>
		public Tracer( string parLogFilePath )
		{
			// Путь к лог-файлу.
			if ( ( parLogFilePath == null ) || ( parLogFilePath == string.Empty ) )
				this._LogFilePath = Tracer.DEFAULT_LOG_FILE_PATH;
			else
				this._LogFilePath = parLogFilePath;

			// Поток лог-файла.
			FileStream logFileStream = new FileStream( this.LogFilePath,
				FileMode.Create, FileAccess.Write, FileShare.Read );
			// Писатель файлового потока лога.
			this._LogFileStreamWriter = new StreamWriter( logFileStream );
			// Запись текущего времени.
			this._LogFileStreamWriter.WriteLine( DateTime.Now.ToString( ) );
			// Добавление красной строки в трассу.
			this._LogFileStreamWriter.WriteLine( );
			// Запись данных из буфера в лог-файл.
			this._LogFileStreamWriter.Flush( );
		} // Tracer

		/// <summary>
		/// Освобождение ресурсов экземпляра трассировщика.
		/// </summary>
		public void Dispose( )
		{
			// Запись текущего времени.
			this._LogFileStreamWriter.WriteLine( DateTime.Now.ToString( ) );
			// Добавление красной строки окончания лог-файла в трассу.
			this._LogFileStreamWriter.WriteLine( Tracer.LOG_FILE_END );
			// Запись данных из буфера в лог-файл.
			this._LogFileStreamWriter.Flush( );
			// Закрытие файлового потока лога.
			this._LogFileStreamWriter.Close( );
			// Освобождение ресурсов потока лога.
			this._LogFileStreamWriter.Dispose( );
		} // Tracer


		#region Methods


		/// <summary>
		/// Метод получения строкового представления объекта.
		/// </summary>
		/// <param name="parObject">Объект.</param>
		/// <returns>Строковое представлние значения объекта.</returns>
		private static string GetObjectValueString( object parObject )
		{
			// Если объект не определён, то возвращается строка null-значения,
			// иначе - значение объекта, приведённое к строке.
			if ( parObject == null )
				return Tracer.NULL_STRING;
			else
				return parObject.ToString( );
		} // GetObjectValueString

		/// <summary>
		/// Вызов функции.
		/// </summary>
		/// <param name="parFunctionName">Имя функции</param>
		/// <param name="parFunctionParameters">Массив параметров функции</param>
		private void CallFunction( string parFunctionName,
			object[ ] parFunctionParameters )
		{
			// Добавление назания функции и открывающей круглой скобки в трассу.
			this._LogFileStreamWriter.Write( parFunctionName +
				Tracer.OPENING_PARENTHESIS );
			
			// Если список параметров функции не пуст.
			if
			(
				( parFunctionParameters        != null ) &&
				( parFunctionParameters.Length != 0 )
			)
			{
				// Максимальный индекс параметра функции.
				int functionParameterMaximumIndex = parFunctionParameters.Length - 1;
				
				// Просмотр всех параметров функции, кроме последнего.
				for ( int functionParameterIndex = 0; functionParameterIndex <
						functionParameterMaximumIndex; functionParameterIndex++ )
					// Добавление текущего параметра функции и запятой в трассу.
					this._LogFileStreamWriter.Write( Tracer.GetObjectValueString
						( parFunctionParameters[ functionParameterIndex ] ) +
						Tracer.COMMA );

				// Добавление последнего параметра функции в трассу.
				this._LogFileStreamWriter.Write( Tracer.GetObjectValueString
					( parFunctionParameters[ functionParameterMaximumIndex ] ) );
			} // if
			
			// Добавление закрывающей круглой скобки в трассу.
			this._LogFileStreamWriter.WriteLine( Tracer.CLOSING_PARENTHESIS );
			// Добавление красной строки в трассу.
			this._LogFileStreamWriter.WriteLine( );
			// Запись данных из буфера в лог-файл.
			this._LogFileStreamWriter.Flush( );
		} // CallFunction

		/// <summary>
		/// Создание нового экземпляра класса.
		/// </summary>
		/// <param name="parClassName">Имя класса.</param>
		/// <param name="parConstructorParameters">Массив параметров конструктора.</param>
		public void CreateClassNewInstance( string parClassName,
			params object[ ] parConstructorParameters )
		{
			// Добавление красной строки в трассу.
			this._LogFileStreamWriter.WriteLine( );
			// Добавление сообщения о создании нового экземпляра класса в трассу.
			this._LogFileStreamWriter.Write( Tracer.NEW_CLASS_INSTANCE_CREATION_MESSAGE );
			// Запись данных из буфера в лог-файл.
			this._LogFileStreamWriter.Flush( );
			// Вызов функции-коструктора класса.
			this.CallFunction( parClassName, parConstructorParameters );
		} // CreateClassNewInstance

		/// <summary>
		/// Вызов метода класса.
		/// </summary>
		/// <param name="parClassName">Имя класса.</param>
		/// <param name="parMethodName">Имя метода.</param>
		/// <param name="parMethodParameters">Массив параметров метода.</param>
		public void CallClassMethod( string parClassName, string parMethodName,
			params object[ ] parMethodParameters )
		{
			// Добавление сообщения о вызове метода класса в трассу.
			this._LogFileStreamWriter.Write( Tracer.CALL_CLASS_METHOD_MESSAGE );
			// Запись данных из буфера в лог-файл.
			this._LogFileStreamWriter.Flush( );
			// Полное имя метода класса:
			// имя класса, точка, имя метода.
			string classMethodName = parClassName + Tracer.POINT + parMethodName;
			// Вызов функции-метода класса.
			this.CallFunction( classMethodName, parMethodParameters );
		} // CallClassMethod

		/// <summary>
		/// Вызов метода-обработчика события класса.
		/// </summary>
		/// <param name="parClassName">Имя класса.</param>
		/// <param name="parEventHandlerName">
		/// Имя метода-обработчика события</param>
		/// <param name="parEventHandlerParameters">Массив параметров
		/// метода-обработчика события.</param>
		public void CallClassEventHandler( string parClassName,
			string parEventHandlerName, params object[ ] parEventHandlerParameters )
		{
			// Добавление сообщения о вызове метода-обработчика события класса
			// в трассу.
			this._LogFileStreamWriter.Write
				( Tracer.CALL_CLASS_EVENT_HANDLER_MESSAGE );
			// Запись данных из буфера в лог-файл.
			this._LogFileStreamWriter.Flush( );
			// Полное имя метода-обработчика события класса:
			// имя класса, точка, имя метода-обработчика события.
			string classEventListenerName = parClassName + Tracer.POINT +
				parEventHandlerName;
			// Вызов функции-метода класса.
			this.CallFunction( classEventListenerName, parEventHandlerParameters );
		} // CallClassEventHandler

		/// <summary>
		/// Получение свойства класса.
		/// </summary>
		/// <param name="parClassName">Имя класса.</param>
		/// <param name="parPropertieName">Имя свойства.</param>
		/// <param name="parPropertieValue">Значение свойства.</param>
		public void GetClassPropertie( string parClassName,
			string parPropertieName, object parPropertieValue )
		{
			// Добавление сообщения о получении свойства класса в трассу.
			this._LogFileStreamWriter.Write( Tracer.GET_CLASS_PROPERTIE_MESSAGE );
			// Полное имя свойства класса:
			// имя класса, точка, имя свойства.
			string classPropertieName = parClassName + Tracer.POINT +
				parPropertieName;
			// Добавление полного имени свойства, знака равенства
			// и значения свойства в трассу.
			this._LogFileStreamWriter.WriteLine( classPropertieName +
				Tracer.EQUALITY + parPropertieValue.ToString( ) );
			// Добавление красной строки в трассу.
			this._LogFileStreamWriter.WriteLine( );
			// Запись данных из буфера в лог-файл.
			this._LogFileStreamWriter.Flush( );
		} // GetClassPropertie

		/// <summary>
		/// Установка свойства класса.
		/// </summary>
		/// <param name="parClassName">Имя класса.</param>
		/// <param name="parPropertieName">Имя свойства.</param>
		/// <param name="parPropertieValue">Значение свойства.</param>
		public void SetClassPropertie( string parClassName,
			string parPropertieName, object parPropertieValue )
		{
			// Добавление сообщения об установке свойства класса в трассу.
			this._LogFileStreamWriter.Write( Tracer.SET_CLASS_PROPERTIE_MESSAGE );
			// Полное имя свойства класса:
			// имя класса, точка, имя свойства.
			string classPropertieName = parClassName + Tracer.POINT +
				parPropertieName;
			// Добавление полного имени свойства, знака равенства
			// и значения свойства в трассу.
			this._LogFileStreamWriter.WriteLine( classPropertieName +
				Tracer.EQUALITY + parPropertieValue.ToString( ) );
			// Добавление красной строки в трассу.
			this._LogFileStreamWriter.WriteLine( );
			// Запись данных из буфера в лог-файл.
			this._LogFileStreamWriter.Flush( );
		} // SetClassPropertie

		/// <summary>
		/// Послание сообщения об ошибке.
		/// </summary>
		/// <param name="parErrorMessage">Сообщение об ошбике.</param>
		public void SendErrorMessage( string parErrorMessage )
		{
			// Добавление сообщения о возникновении ошибки,
			// сообщения об ошбике и двойной красной строки в трассу.
			this._LogFileStreamWriter.WriteLine( Tracer.SEND_ERROR_MESSAGE +
				parErrorMessage );
			// Добавление красной строки в трассу.
			this._LogFileStreamWriter.WriteLine( );
			// Запись данных из буфера в лог-файл.
			this._LogFileStreamWriter.Flush( );
		} // SendErrorMessage

		/// <summary>
		/// Послание сообщения.
		/// </summary>
		/// <param name="parMessage">Сообщение.</param>
		public void SendMessage( string paMessage )
		{
			// Добавление сообщения и двойной красной строки в трассу.
			this._LogFileStreamWriter.WriteLine( paMessage );
			// Добавление красной строки в трассу.
			this._LogFileStreamWriter.WriteLine( );
			// Запись данных из буфера в лог-файл.
			this._LogFileStreamWriter.Flush( );
		} // SendMessage


		#endregion Methods


		/// <summary>
		/// Путь к лог-файлу: в этом файле ведётся протокол выполняемых действий.
		/// </summary>
		public string LogFilePath
		{
			get
			{
				return this._LogFilePath;
			} // get
		} // LogFilePath
	} // Tracer
} // zap