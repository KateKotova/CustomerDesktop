<?php
	// Скрипт, добавляющий данные продажи разновидности диска
	// в корзину покупок.

	// Получение группы GET-переменных, которые создаются при анализе
	// строки запроса, которая хранится в переменной $QUERY_STRING
	// и представляет собой информацию, следующую за символом "?"
	// в запрошенном URL. РНР разбивает строку запроса по символам &
	// на отдельные элементы, а затем ищет в каждом из этих элементов знак "=".
	// Если знак "=" найден, то создается переменная с именем из символов,
	// стоящих слева от знака равенства.

	// Имя хоста.
	$parHostName             = $_GET[ 'HostName' ];
	// Имя пользователя.
	$parUserName             = $_GET[ 'UserName' ];
	// Пароль пользователя.
	$parUserPassword         = $_GET[ 'UserPassword' ];
	// Имя базы данных.
	$parDatabaseName         = $_GET[ 'DatabaseName' ];

	// Имя таблицы корзины покупок.
	$parShoppingCartTableName     = $_GET[ 'ShoppingCartTableName' ];
	// Имя столбца идентивикаторов в таблице корзины покупок.
	$parShoppingCartIDsColumnName = $_GET[ 'ShoppingCartIDsColumnName' ];

	// Имя столбца идентивикаторов номенклатур в таблице корзины покупок.
	$parShoppingCartNomenclaturesIDsColumnName =
		$_GET[ 'ShoppingCartNomenclaturesIDsColumnName' ];
	// Значение идентивикатора номенклатуры.
	$parNomenclatureIDValue = $_GET[ 'NomenclatureIDValue' ];

	// Имя столбца идентивикаторов разновидностей дисков
	// в таблице корзины покупок.
	$parShoppingCartDisksVarietiesIDsColumnName =
		$_GET[ 'ShoppingCartDisksVarietiesIDsColumnName' ];
	// Значение идентивикатора разновидности диска.
	$parDiskVarietyIDValue = $_GET[ 'DiskVarietyIDValue' ];

	// Имя столбца цен в таблице корзины покупок.
	$parShoppingCartCostsColumnName = $_GET[ 'ShoppingCartCostsColumnName' ];
	// Значение цены.
	$parCostValue                   = $_GET[ 'CostValue' ];

	// Имя столбца номеров ячеек в таблице корзины покупок.
	$parShoppingCartCellsNumbersColumnName =
		$_GET[ 'ShoppingCartCellsNumbersColumnName' ];
	// Значение номера ячейки.
	$parCellNumberValue                    = $_GET[ 'CellNumberValue' ];

	// Функция "die( message )" выводит сообщение message
	//   и завершенает текущий сценарий.
	// Оператор "or" аналогичен "||", но имеет очень низкий приоритет,
	//   даже ниже, чем у "=".
	// Тег HTML "<p>Текст</p>" определяет текстовый параграф.
	// Если оператор "@" указан перед именем функции, то в случае возникновения
	//   ошибки при её выполнении блокируется вывод предупреждения в браузер.
	// Оператор "." применяется для конкатенации строк.
	// "\n" - символ перевода на новую строку.
	// "\t" - символ табуляции - отступ.
	// " \" " - "слеш, кавычка" - символ кавычки.

	// Устанавка сетевого соединения с базой данных MySQL,
	// расположенной на хосте с задданным именем,
	// с указанием заданного имени пользователя и заданного пароля
	// пользователя, при этом возвращается идентификатор открытого соединения.
	$mySQLConnectionID = @mysql_connect
			( $parHostName, $parUserName, $parUserPassword )
		// Если сетевое соединение с базой данных MySQL не было установлено,
		// то вывододится сообщение о том, что не возможно подключиться к хосту,
		// сообщение об ошибке и текущий сценарий завершается.
		or die( "<P>Unable to connect to the host $parHostName: " .
			mysql_error( ) . "</P>" );

	// Выбор базы данных MySQL с заданным названием для использования
	// в дальнейших операциях с установленным сетевым соединением.
	@mysql_select_db( $parDatabaseName, $mySQLConnectionID )
		// Если база данных MySQL не была выбрана,
		// то вывододится сообщение о том, что не возможно выбрать базу данных,
		// сообщение об ошибке и текущий сценарий завершается.
		or die( "<P>Unable to select the database $parDatabaseName: " .
			mysql_error( ) . "</P>" );

	// Создание таблицы корзины покупок, если она ещё не существует.

	// Строка запроса к базе данных MySQL с заданным названием.
	$mySQLQueryString =
		"CREATE TABLE IF NOT EXISTS {$parShoppingCartTableName} " .
		"( " .
			"{$parShoppingCartIDsColumnName} BIGINT UNSIGNED ZEROFILL NOT NULL " .
				"PRIMARY KEY, " .
			"{$parShoppingCartNomenclaturesIDsColumnName} BINARY( 16 ) NULL, " .
			"{$parShoppingCartDisksVarietiesIDsColumnName} BINARY( 16 ) NULL, " .
			"{$parShoppingCartCostsColumnName} DECIMAL( 15, 2 ) NULL, " .
			"{$parShoppingCartCellsNumbersColumnName} BINARY( 16 ) NULL " .
		")";

	// Отправка запроса, представленного указанной строкой,
	// к базе данных MySQL с заданным названием,
	// при этом возвращается идентификатор выполненного запроса.
	$mySQLQueryID = @mysql_query( $mySQLQueryString, $mySQLConnectionID )
		// Если запрос к базе данных mySQL не выполнился,
		// то вывододится сообщение о том, что не возможно
		// удачно выполнить запрос к базе данных,
		// сообщение об ошибке и текущий сценарий завершается.
		or die( "<P>Could not successfully run the query $mySQLQueryString " .
			"from the database $parDatabaseName: " . mysql_error( ) . "</P>" );

/*
	// Если количество записей, найденных в результате выполнения запроса
	// к базе данных MySQL с заданным названием, нулевое.
	if ( mysql_num_rows( $mySQLQueryID ) == 0 )
	{
		// Вывод сообщения о том, что количество записей,
		// выбранных запросом к базе данных mySQL, нулевое.
		echo( "<P>The number of rows selected by the query $mySQLQueryString " .
			"is zero</P>" );
		// Завершение текущего сценария.
		exit( );
	} // if
*/

	// Поиск идентификатора для добавляемой записи:
	// идентификатор должен быть больше максимального на 1,
	// а если таблица пуста, то есть в ней нет ни одной записи,
	// то идентификатор равен 1.

	// Строка запроса к базе данных MySQL с заданным названием.
	$mySQLQueryString =
		"SELECT ( MAX( {$parShoppingCartIDsColumnName} ) + 1 ) " .
			"AS {$parShoppingCartIDsColumnName} " .
		"FROM {$parShoppingCartTableName}";

	// Отправка запроса, представленного указанной строкой,
	// к базе данных MySQL с заданным названием,
	// при этом возвращается идентификатор выполненного запроса.
	$mySQLQueryID = @mysql_query( $mySQLQueryString, $mySQLConnectionID )
		// Если запрос к базе данных mySQL не выполнился,
		// то вывододится сообщение о том, что не возможно
		// удачно выполнить запрос к базе данных,
		// сообщение об ошибке и текущий сценарий завершается.
		or die( "<P>Could not successfully run the query $mySQLQueryString " .
			"from the database $parDatabaseName: " . mysql_error( ) . "</P>" );

/*
	// Если количество записей, найденных в результате выполнения запроса
	// к базе данных MySQL с заданным названием, нулевое.
	if ( mysql_num_rows( $mySQLQueryID ) == 0 )
	{
		// Вывод сообщения о том, что количество записей,
		// выбранных запросом к базе данных mySQL, нулевое.
		echo( "<P>The number of rows selected by the query $mySQLQueryString " .
			"is zero</P>" );
		// Завершение текущего сценария.
		exit( );
	} // if
*/

	// Значение пустой ячейки.
	$cellNullValue       = "";
	// Значение идентивикатора корзины покупок.
	$shoppingCartIDValue = 1;

	// Записи, полученные в результате выполненного запроса, просматриваются
	// последовательно, и до тех пор пока они не просмотрены все,
	// текущая запись помещается в ассоциативный массив, элементами которого
	// являются значения ячеек просматриваемой записи-строки.
	while ( $mySQLQueryFetch = mysql_fetch_assoc( $mySQLQueryID ) )
	{
		// Если полученное значение идентивикатора корзины покупок не пусто.
		if ( $mySQLQueryFetch[ $parShoppingCartIDsColumnName ] !=
				$cellNullValue )
			// Значение идентификатора корзины покупок - полученное.
			$shoppingCartIDValue =
				$mySQLQueryFetch[ $parShoppingCartIDsColumnName ];
	} // while

	// Добавление записи в таблицу корзины покупок.

	// Строка NULL-значения.
	$nullValueString = "NULL";
	// Кавычка.
	$quote           = "'";

	// Функция получения строки значения ячейки таблицы базы данных
	// из заданной строки значения.
	// Параметры:
	// $parValueString - строка значения.
	// Результат: строка значения ячейки таблицы базы данных.
	function GetCellValueString( $parValueString )
	{
		// Значение пустой ячейки.
		global $cellNullValue;
		// Строка NULL-значения.
		global $nullValueString;
		// Кавычка.
		global $quote;

		// Если строка значения пуста.
		if ( $parValueString == $cellNullValue )
			// Строка значения заменяется строкой NULL-значения.
			$parValueString = $nullValueString;
		// Если строка значения не пуста.
		else
			// Строка значения заключается в кавычки.
			$parValueString = $quote . $parValueString . $quote;

		// Строка начения ячейки таблицы базы данных.
		return $parValueString;
	} // GetCellValueString

	// Строки значений, добавляемых в таблицу корзины покупок,
	// преобразуется в строки значений, подходящие для записи
	// в ячейки таблицы базы данных.

	// Значение идентивикатора номенклатуры.
	$parNomenclatureIDValue = GetCellValueString( $parNomenclatureIDValue );
	// Значение идентивикатора разновидности диска.
	$parDiskVarietyIDValue  = GetCellValueString( $parDiskVarietyIDValue );
	// Значение цены.
	$parCostValue           = GetCellValueString( $parCostValue );
	// Значение номера ячейки.
	$parCellNumberValue     = GetCellValueString( $parCellNumberValue );

	// Строка запроса к базе данных MySQL с заданным названием.
	$mySQLQueryString =
		"INSERT INTO {$parShoppingCartTableName} " .
		"( " .
			"{$parShoppingCartIDsColumnName}, " .
			"{$parShoppingCartNomenclaturesIDsColumnName}, " .
			"{$parShoppingCartDisksVarietiesIDsColumnName}, " .
			"{$parShoppingCartCostsColumnName}, " .
			"{$parShoppingCartCellsNumbersColumnName} " .
		") " .
		"VALUES " .
		"( " .
			"{$shoppingCartIDValue}, " .
			"UNHEX( {$parNomenclatureIDValue} ), " .
			"UNHEX( {$parDiskVarietyIDValue} ), " .
			"{$parCostValue}, " .
			"UNHEX( {$parCellNumberValue} ) " .
		")";

	// Отправка запроса, представленного указанной строкой,
	// к базе данных MySQL с заданным названием,
	// при этом возвращается идентификатор выполненного запроса.
	$mySQLQueryID = @mysql_query( $mySQLQueryString, $mySQLConnectionID )
		// Если запрос к базе данных mySQL не выполнился,
		// то вывододится сообщение о том, что не возможно
		// удачно выполнить запрос к базе данных,
		// сообщение об ошибке и текущий сценарий завершается.
		or die( "<P>Could not successfully run the query $mySQLQueryString " .
			"from the database $parDatabaseName: " . mysql_error( ) . "</P>" );

/*
	// Если количество записей, найденных в результате выполнения запроса
	// к базе данных MySQL с заданным названием, нулевое.
	if ( mysql_num_rows( $mySQLQueryID ) == 0 )
	{
		// Вывод сообщения о том, что количество записей,
		// выбранных запросом к базе данных mySQL, нулевое.
		echo( "<P>The number of rows selected by the query $mySQLQueryString " .
			"is zero</P>" );
		// Завершение текущего сценария.
		exit( );
	} // if
*/

	// Закрытие ранее установленного сетевого соединения с базой данных.
	mysql_close( $mySQLConnectionID );

	// Вывод XML-дерева.
	echo( "<Result>OK</Result>" );
?>