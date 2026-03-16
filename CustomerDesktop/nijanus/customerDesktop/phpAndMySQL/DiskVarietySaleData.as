// CustomerDesktop
// Author Kate Kotova
// NIJANUS Copyright © 2004-2010
// nijanus@ymail.com
// http://nijanus.narod2.ru
//---------------------------------------------------------------------------
// Пакет классов рабочего стола покупателя, взаимодействующих с PHP и MySQL.
package nijanus.customerDesktop.phpAndMySQL
{
	// Класс данных продажи разновидности диска.
	public class DiskVarietySaleData
	{
		// Переменные экземпляра класса.
		
		// Идентивикатор номенклатуры.
		public var NomenclatureID: String = null;
		// Идентивикатор разновидности диска.
		public var DiskVarietyID:  String = null;	
		// Цена.
		public var Cost:           String = null;	
		// Номер ячейки.
		public var CellNumber:     String = null;
		//-----------------------------------------------------------------------
		// Методы-конструкторы.

		// Метод-конструктор экземпляра данных продажи разновидности диска.
		// Параметры:
		// parNomenclatureID - идентивикатор номенклатуры,
		// parDiskVarietyID  - идентивикатор разновидности диска,
		// parCost           - цена,
		// parCellNumber     - номер ячейки.
		public function DiskVarietySaleData
		(
			parNomenclatureID,
			parDiskVarietyID,
			parCost,
			parCellNumber: String
		): void
		{
			// Идентивикатор номенклатуры.
			this.NomenclatureID = parNomenclatureID;
			// Идентивикатор разновидности диска.
			this.DiskVarietyID  = parDiskVarietyID;
			// Цена.
			this.Cost           = parCost;
			// Номер ячейки.
			this.CellNumber     = parCellNumber;
		} // DiskVarietySaleData
	} // DiskVarietySaleData
} // nijanus.customerDesktop.phpAndMySQL