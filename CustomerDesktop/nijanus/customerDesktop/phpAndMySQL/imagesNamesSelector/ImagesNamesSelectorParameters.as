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
	// Класс параметров выборщика имён изображений.
	public class ImagesNamesSelectorParameters
	{	
		// Переменные экземпляра класса.
		
		// Тип фильрации.
		protected var _FilteringType: String = ImagesNamesFilteringType.UNKNOWN;
		// Значение фильтра.
		protected var _FilterValue:         Object  = null;
		// Тип упорядочения.
		protected var _OrderingType:  String = ImagesNamesOrderingType.UNKNOWN;	
		// Признак упорядочения по возрастанию.
		protected var _OrderingIsAscendant: Boolean = true;
		//-----------------------------------------------------------------------
		// Методы-конструкторы.

		// Метод-конструктор экземпляра параметров выборщика имён изображений.
		// Параметры:
		// parFilteringType       - тип фильрации,
		// parFilterValue         - значение фильтра,		
		// parOrderingType        - тип упорядочения,
		// parOrderingIsAscendant - признак упорядочения по возрастанию.
		public function ImagesNamesSelectorParameters
		(
			parFilteringType:       String,
			parFilterValue:         Object,
			parOrderingType:        String,
			parOrderingIsAscendant: Boolean = true
		): void
		{
			// Тип фильрации.
			this._FilteringType       =
				ImagesNamesFilteringType.GetValueFromString( parFilteringType );
			// Значение фильтра.
			this._FilterValue         = parFilterValue;
			// Тип упорядочения.
			this._OrderingType        =
				ImagesNamesOrderingType.GetValueFromString( parOrderingType );	
			// Признак упорядочения по возрастанию.
			this._OrderingIsAscendant = parOrderingIsAscendant;
		} // ImagesNamesSelectorParameters
		//-----------------------------------------------------------------------
		// Get- и set-методы.
		
		// Get-метод получения типа фильрации.
		// Результат: тип фильрации.
		public function get FilteringType( ): String
		{
			// Тип фильрации.
			return this._FilteringType;
		} // FilteringType

		// Set-метод установки типа фильрации.
		// Параметры:
		// parFilteringType - тип фильрации.
		public function set FilteringType( parFilteringType: String ): void
		{
			// Тип фильрации.
			this._FilteringType =
				ImagesNamesFilteringType.GetValueFromString( parFilteringType );
		} // FilteringType		
		
		// Get-метод получения значения фильтра.
		// Результат: значение фильтра.
		public function get FilterValue( ): Object
		{
			// Значение фильтра.
			return this._FilterValue;
		} // FilterValue

		// Set-метод установки значения фильтра.
		// Параметры:
		// parFilterValue - значение фильтра.
		public function set FilterValue( parFilterValue: Object ): void
		{
			// Значение фильтра.
			this._FilterValue = parFilterValue;
		} // FilterValue		
		
		// Get-метод получения типа упорядочения.
		// Результат: тип упорядочения.
		public function get OrderingType( ): String
		{
			// Тип упорядочения.
			return this._OrderingType;
		} // OrderingType

		// Set-метод установки типа упорядочения.
		// Параметры:
		// parOrderingType - тип упорядочения.
		public function set OrderingType( parOrderingType: String ): void
		{
			// Тип упорядочения.
			this._OrderingType =
				ImagesNamesOrderingType.GetValueFromString( parOrderingType );	
		} // OrderingType		
		
		// Get-метод получения признака упорядочения по возрастанию.
		// Результат: признак упорядочения по возрастанию.
		public function get OrderingIsAscendant( ): Boolean
		{
			// Признак упорядочения по возрастанию.
			return this._OrderingIsAscendant;
		} // OrderingIsAscendant

		// Set-метод установки признака упорядочения по возрастанию.
		// Параметры:
		// parOrderingIsAscendant - признак упорядочения по возрастанию.
		public function set OrderingIsAscendant
			( parOrderingIsAscendant: Boolean ): void
		{
			// Признак упорядочения по возрастанию.
			this._OrderingIsAscendant = parOrderingIsAscendant;
		} // OrderingIsAscendant				
	} // ImagesNamesOrderingParameters
} // nijanus.customerDesktop.phpAndMySQL.imagesNamesSelector
