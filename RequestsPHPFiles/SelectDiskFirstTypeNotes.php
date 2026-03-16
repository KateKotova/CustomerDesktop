<?php
	// Скрипт, возвращающий примечания первого типа диска.

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

	// Имя таблицы номенклатур.
	$parNomenclaturesTableName          = $_GET[ 'NomenclaturesTableName' ];
	// Имя столбца идентивикаторов в таблице номенклатур.
	$parNomenclaturesIDsColumnName      = $_GET[ 'NomenclaturesIDsColumnName' ];
	// Имя столбца артикулов в таблице номенклатур.
	$parNomenclaturesArticlesColumnName       =
		$_GET[ 'NomenclaturesArticlesColumnName' ];
	// Значение артикула изображения.
	$parImageArticleValue               = $_GET[ 'ImageArticleValue' ];
	// Имя столбца названий стран в таблице номенклатур.
	$parNomenclaturesCountriesNamesColumnName =
		$_GET[ 'NomenclaturesCountriesNamesColumnName' ];
	// Имя столбца дат релизов в таблице номенклатур.
	$parNomenclaturesReleasesDatesColumnName  =
		$_GET[ 'NomenclaturesReleasesDatesColumnName' ];

	// Имя таблицы категорий товаров и номенклатур.
	$parGoodsCategoriesAndNomenclaturesTableName                    =
		$_GET[ 'GoodsCategoriesAndNomenclaturesTableName' ];
	// Имя столбца идентивикаторов номенклатур
	// в таблице категорий товаров и номенклатур.
	$parGoodsCategoriesAndNomenclaturesNomenclaturesIDsColumnName   =
		$_GET[ 'GoodsCategoriesAndNomenclaturesNomenclaturesIDsColumnName' ];
	// Имя столбца идентивикаторов категорий товаров
	// в таблице категорий товаров и номенклатур.
	$parGoodsCategoriesAndNomenclaturesGoodsCategoriesIDsColumnName =
		$_GET[ 'GoodsCategoriesAndNomenclaturesGoodsCategoriesIDsColumnName' ];

	// Имя таблицы категорий товаров.
	$parGoodsCategoriesTableName     = $_GET[ 'GoodsCategoriesTableName' ];
	// Имя столбца идентивикаторов в таблице категорий товаров.
	$parGoodsCategoriesIDsColumnName = $_GET[ 'GoodsCategoriesIDsColumnName' ];
	// Имя столбца наименований в таблице категорий товаров.
	$parGoodsCategoriesNamesColumnName =
		$_GET[ 'GoodsCategoriesNamesColumnName' ];

	// Имя таблицы ссылок свойств.
	$parPropertiesReferencesTableName                     =
		$_GET[ 'PropertiesReferencesTableName' ];
	// Имя столбца идентивикаторов номенклатур в таблице ссылок свойств.
	$parPropertiesReferencesNomenclaturesIDsColumnName    =
		$_GET[ 'PropertiesReferencesNomenclaturesIDsColumnName' ];
	// Имя столбца идентивикаторов значений свойств
	// в таблице ссылок свойств.
	$parPropertiesReferencesPropertiesValuesIDsColumnName =
		$_GET[ 'PropertiesReferencesPropertiesValuesIDsColumnName' ];

	// Имя таблицы значений свойств.
	$parPropertiesValuesTableName       = $_GET[ 'PropertiesValuesTableName' ];
	// Имя столбца идентивикаторов в таблице значений свойств.
	$parPropertiesValuesIDsColumnName   =
		$_GET[ 'PropertiesValuesIDsColumnName' ];
	// Имя столбца наименований в таблице значений свойств.
	$parPropertiesValuesNamesColumnName =
		$_GET[ 'PropertiesValuesNamesColumnName' ];

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

	// Выбор наименования категории диска - первого примечания.

	// Строка запроса к базе данных MySQL с заданным названием.
	$mySQLQueryString =
		"SELECT {$parGoodsCategoriesNamesColumnName} " .
		"FROM {$parGoodsCategoriesTableName} " .
		"WHERE {$parGoodsCategoriesIDsColumnName} = " .
		"( " .
			"SELECT " .
				"{$parGoodsCategoriesAndNomenclaturesGoodsCategoriesIDsColumnName} " .
			"FROM {$parGoodsCategoriesAndNomenclaturesTableName} " .
			"WHERE " .
				"{$parGoodsCategoriesAndNomenclaturesNomenclaturesIDsColumnName} = " .
					"( " .
						"SELECT {$parNomenclaturesIDsColumnName} " .
						"FROM {$parNomenclaturesTableName} " .
						"WHERE " .
							"{$parNomenclaturesArticlesColumnName} = " .
								"{$parImageArticleValue} " .
						"LIMIT 1 " .
					") " .
					"LIMIT 1 " .
		") " .
		"LIMIT 1";

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
	$cellNullValue = "";
	// Индекс примечания.
	$noteIndex     = 0;

	// Записи, полученные в результате выполненного запроса, просматриваются
	// последовательно, и до тех пор пока они не просмотрены все,
	// текущая запись помещается в ассоциативный массив, элементами которого
	// являются значения ячеек просматриваемой записи-строки.
	while ( $mySQLQueryFetch = mysql_fetch_assoc( $mySQLQueryID ) )
	{
		// Если текущая ячейка столбца наименований в таблице категорий товаров
		// не пуста.
		if ( $mySQLQueryFetch[ $parGoodsCategoriesNamesColumnName ] !=
			$cellNullValue )
		{
			// Значение текущей ячейки столбца наименований
			// в таблице категорий товаров добавляется как очередное примечание.
			$notes[ $noteIndex ] =
				$mySQLQueryFetch[ $parGoodsCategoriesNamesColumnName ];
			// Инкремент индекса примечания.
			$noteIndex++;
		} // if
	} // while

	// Выбор названия страны диска - второго примечания.

	// Строка запроса к базе данных MySQL с заданным названием.
	$mySQLQueryString =
		"SELECT {$parNomenclaturesCountriesNamesColumnName} " .
		"FROM {$parNomenclaturesTableName} " .
		"WHERE {$parNomenclaturesArticlesColumnName} = {$parImageArticleValue} " .
		"LIMIT 1";

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

	// Записи, полученные в результате выполненного запроса, просматриваются
	// последовательно, и до тех пор пока они не просмотрены все,
	// текущая запись помещается в ассоциативный массив, элементами которого
	// являются значения ячеек просматриваемой записи-строки.
	while ( $mySQLQueryFetch = mysql_fetch_assoc( $mySQLQueryID ) )
	{
		// Если текущая ячейка столбца названий стран в таблице номенклатур
		// не пуста.
		if ( $mySQLQueryFetch[ $parNomenclaturesCountriesNamesColumnName ] !=
			$cellNullValue )
		{
			// Значение текущей ячейки столбца названий стран в таблице номенклатур
			// добавляется как очередное примечание.
			$notes[ $noteIndex ] =
				$mySQLQueryFetch[ $parNomenclaturesCountriesNamesColumnName ];
			// Инкремент индекса примечания.
			$noteIndex++;
		} // if
	} // while

	// Выбор даты релиза диска - третьего примечания.

	// Строка запроса к базе данных MySQL с заданным названием.
	$mySQLQueryString =
		"SELECT {$parNomenclaturesReleasesDatesColumnName} " .
		"FROM {$parNomenclaturesTableName} " .
		"WHERE {$parNomenclaturesArticlesColumnName} = {$parImageArticleValue} " .
		"LIMIT 1";

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

	// Записи, полученные в результате выполненного запроса, просматриваются
	// последовательно, и до тех пор пока они не просмотрены все,
	// текущая запись помещается в ассоциативный массив, элементами которого
	// являются значения ячеек просматриваемой записи-строки.
	while ( $mySQLQueryFetch = mysql_fetch_assoc( $mySQLQueryID ) )
	{
		// Если текущая ячейка столбца дат релизов в таблице номенклатур не пуста.
		if ( $mySQLQueryFetch[ $parNomenclaturesReleasesDatesColumnName ] !=
			$cellNullValue )
		{
			// Значение текущей ячейки столбца дат релизов в таблице номенклатур
			// добавляется как очередное примечание.
			$notes[ $noteIndex ] =
				$mySQLQueryFetch[ $parNomenclaturesReleasesDatesColumnName ];
			// Инкремент индекса примечания.
			$noteIndex++;
		} // if
	} // while

	// Выбор наименований значений свойств диска -
	// четвёртого, пятого и шестого примечания.

	// Строка запроса к базе данных MySQL с заданным названием.
	$mySQLQueryString =
		"SELECT DISTINCT " .
			"{$parPropertiesValuesTableName}." .
				"{$parPropertiesValuesNamesColumnName} " .
		"FROM {$parPropertiesReferencesTableName} " .
			"INNER JOIN {$parPropertiesValuesTableName} " .
			"ON " .
				"{$parPropertiesReferencesTableName}." .
					"{$parPropertiesReferencesPropertiesValuesIDsColumnName} = " .
				"{$parPropertiesValuesTableName}." .
					"{$parPropertiesValuesIDsColumnName} " .
		"WHERE " .
			"{$parPropertiesReferencesTableName}." .
				"{$parPropertiesReferencesNomenclaturesIDsColumnName} = " .
			"( " .
				"SELECT {$parNomenclaturesIDsColumnName} " .
				"FROM {$parNomenclaturesTableName} " .
				"WHERE " .
					"{$parNomenclaturesArticlesColumnName} = {$parImageArticleValue} " .
				"LIMIT 1 " .
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

	// Записи, полученные в результате выполненного запроса, просматриваются
	// последовательно, и до тех пор пока они не просмотрены все,
	// текущая запись помещается в ассоциативный массив, элементами которого
	// являются значения ячеек просматриваемой записи-строки.
	while ( $mySQLQueryFetch = mysql_fetch_assoc( $mySQLQueryID ) )
	{
		// Если текущая ячейка столбца наименований в таблице значений свойств
		// не пуста.
		if ( $mySQLQueryFetch[ $parPropertiesValuesNamesColumnName ] !=
			$cellNullValue )
		{
			// Значение текущей ячейки столбца наименований
			// в таблице значений свойств добавляется как очередное примечание.
			$notes[ $noteIndex ] =
				$mySQLQueryFetch[ $parPropertiesValuesNamesColumnName ];
			// Инкремент индекса примечания.
			$noteIndex++;
		} // if
	} // while

	// Количество полученных примечаний.
	$notesCount      = count( $notes );
	// Основа заголовка примечания.
	$noteCaptionBase = "Note";

	// XML-дерево.
	// Корневой элемент XML-дерева - примечания - открывающий тег.
	$xmlTree = "<Notes>\n";
	// Элемент XML-дерева - строка - открывающий тег.
	$xmlTree .= "\t<Row>\n";

	// Последовательный просмотр всех примечаний.
	for ( $noteIndex = 0; $noteIndex < $notesCount; $noteIndex++ )
	{
		// Заголовок примечания:
		// основа заголовка примечания и индекс столбца массива.
		$noteCaption = $noteCaptionBase . ( ( string ) $noteIndex );

		// Элемент XML-дерева - примечание.
		$xmlTree .=
			"\t\t<{$noteCaption}>" .
			$notes[ $noteIndex ] .
			"</{$noteCaption}>\n";
	} // for

	// Элемент XML-дерева - строка - закрывающий тег.
	$xmlTree .= "\t</Row>\n";
	// Корневой элемент XML-дерева - примечания - закрывающий тег.
	$xmlTree .= "</Notes>";

	// Закрытие ранее установленного сетевого соединения с базой данных.
	mysql_close( $mySQLConnectionID );

	// Вывод XML-дерева.
	echo( $xmlTree );
?>