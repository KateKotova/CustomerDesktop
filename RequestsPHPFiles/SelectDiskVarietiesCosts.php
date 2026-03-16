<?php
	// Скрипт, возвращающий цены разновидностей дисков.

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

	// Имя таблицы розничных товаров.
	$parRetailGoodsTableName        = $_GET[ 'RetailGoodsTableName' ];
	// Имя столбца идентивикаторов номенклатур в таблице розничных товаров.
	$parRetailGoodsNomenclaturesIDsColumnName =
		$_GET[ 'RetailGoodsNomenclaturesIDsColumnName' ];
	// Имя столбца количеств в таблице розничных товаров.
	$parRetailGoodsCountsColumnName = $_GET[ 'RetailGoodsCountsColumnName' ];
	// Имя столбца цен в таблице розничных товаров.
	$parRetailGoodsCostsColumnName  = $_GET[ 'RetailGoodsCostsColumnName' ];

	// Имя столбца в таблице розничных товаров, упорядочивающего цены.
	$parRetailGoodsCostsOrderingColumnName    =
		$_GET[ 'RetailGoodsCostsOrderingColumnName' ];
	// Направление упорядочения цен в таблице розничных товаров:
	// 1 - упорядочение по возрастанию упорядочивающего столбца,
	// 0 - упорядочение по убыванию упорядочивающего столбца.
	$parRetailGoodsCostsOrderingAscendantSign =
		$_GET[ 'RetailGoodsCostsOrderingAscendantSign' ];

	// Имя таблицы номенклатур.
	$parNomenclaturesTableName          = $_GET[ 'NomenclaturesTableName' ];
	// Имя столбца идентивикаторов в таблице номенклатур.
	$parNomenclaturesIDsColumnName      = $_GET[ 'NomenclaturesIDsColumnName' ];
	// Имя столбца артикулов в таблице номенклатур.
	$parNomenclaturesArticlesColumnName =
		$_GET[ 'NomenclaturesArticlesColumnName' ];
	// Значение артикула изображения.
	$parImageArticleValue               = $_GET[ 'ImageArticleValue' ];

	// Имя таблицы ссылок разновидностей дисков.
	$parDisksVarietiesReferencesTableName                                  =
		$_GET[ 'DisksVarietiesReferencesTableName' ];
	// Имя столбца идентивикаторов номенклатур
	// в таблице ссылок разновидностей дисков.
	$parDisksVarietiesReferencesNomenclaturesIDsColumnName                 =
		$_GET[ 'DisksVarietiesReferencesNomenclaturesIDsColumnName' ];
	// Имя столбца идентивикаторов характеристик разновидностей дисков
	// в таблице ссылок разновидностей дисков.
	$parDisksVarietiesReferencesDisksVarietiesCharacteristicsIDsColumnName =
		$_GET
		[ 'DisksVarietiesReferencesDisksVarietiesCharacteristicsIDsColumnName' ];
	// Имя столбца в таблице ссылок разновидностей дисков,
	// упорядочивающего характеристики разновидностей дисков.
	$parDisksVarietiesReferencesCharacteristicsOrderingColumnName          =
		$_GET[ 'DisksVarietiesReferencesCharacteristicsOrderingColumnName' ];

	// Имя таблицы характеристик разновидностей дисков.
	$parDisksVarietiesCharacteristicsTableName     =
		$_GET[ 'DisksVarietiesCharacteristicsTableName' ];
	// Имя столбца идентификаторов
	// в таблице характеристик разновидностей дисков.
	$parDisksVarietiesCharacteristicsIDsColumnName =
		$_GET[ 'DisksVarietiesCharacteristicsIDsColumnName' ];

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

	// Строка запроса к базе данных MySQL с заданным названием.
	$mySQLQueryString =
		"SELECT " .
			"MAX( {$parRetailGoodsTableName}.{$parRetailGoodsCostsColumnName} ) " .
			"AS {$parRetailGoodsCostsColumnName} " .
		"FROM {$parRetailGoodsTableName} " .
			"INNER JOIN {$parDisksVarietiesReferencesTableName} " .
			"ON " .
					"{$parRetailGoodsTableName}." .
						"{$parRetailGoodsNomenclaturesIDsColumnName} = " .
					"{$parDisksVarietiesReferencesTableName}." .
						"{$parDisksVarietiesReferencesNomenclaturesIDsColumnName} " .
					"AND " .
					"{$parRetailGoodsTableName}." .
						"{$parRetailGoodsCostsOrderingColumnName} = " .
					"{$parDisksVarietiesReferencesTableName}." .
"{$parDisksVarietiesReferencesCharacteristicsOrderingColumnName} " .
				"INNER JOIN {$parDisksVarietiesCharacteristicsTableName} " .
				"ON " .
					"{$parDisksVarietiesReferencesTableName}." .
"{$parDisksVarietiesReferencesDisksVarietiesCharacteristicsIDsColumnName} " .
					"= " .
					"{$parDisksVarietiesCharacteristicsTableName}." .
						"{$parDisksVarietiesCharacteristicsIDsColumnName} " .
		"WHERE " .
			"{$parRetailGoodsTableName}." .
				"{$parRetailGoodsNomenclaturesIDsColumnName} = " .
			"( " .
				"SELECT {$parNomenclaturesIDsColumnName} " .
				"FROM {$parNomenclaturesTableName} " .
				"WHERE " .
					"{$parNomenclaturesArticlesColumnName} = {$parImageArticleValue} " .
				"LIMIT 1 " .
			") AND " .
			"{$parRetailGoodsTableName}." .
				"{$parRetailGoodsCountsColumnName} > 0 " .
		"GROUP BY " .
			"{$parRetailGoodsTableName}.{$parRetailGoodsCostsOrderingColumnName} " .
		"ORDER BY " .
			"{$parRetailGoodsTableName}.{$parRetailGoodsCostsOrderingColumnName} ";

	// Если направление упорядочения цен в таблице розничных товаров истинно,
	// то цены упорядочиваются по возрастанию упорядочивающего столбца,
	// иначе - по убыванию.
	if ( $parRetailGoodsCostsOrderingAscendantSign )
		$mySQLQueryString .= "ASC";
	else
		$mySQLQueryString .= "DESC";

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
	// Строка нулевой стоимоти.
	$zeroCost      = "0.00";
	// Индекс стоимости.
	$costIndex     = 0;

	// XML-дерево.
	// Корневой элемент XML-дерева - таблица розничных товаров -
	// открывающий тег.
	$xmlTree = "<{$parRetailGoodsTableName}>\n";
	// Элемент XML-дерева - строка - открывающий тег.
	$xmlTree .= "\t<Row>\n";

	// Записи, полученные в результате выполненного запроса, просматриваются
	// последовательно, и до тех пор пока они не просмотрены все,
	// текущая запись помещается в ассоциативный массив, элементами которого
	// являются значения ячеек просматриваемой записи-строки.
	while ( $mySQLQueryFetch = mysql_fetch_assoc( $mySQLQueryID ) )
	{
		// Если текущая ячейка столбца цен в таблице розничных товаров пуста.
		if ( $mySQLQueryFetch[ $parRetailGoodsCostsColumnName ] ==
				$cellNullValue )
			// Текущая стоимость считается нулевой.
			$cost = $zeroCost;
		// Если текущая ячейка столбца цен в таблице розничных товаров не пуста.
		else
			// Текущая стоимость - значение текущей ячейки столбца цен
			// в таблице розничных товаров.
			$cost = $mySQLQueryFetch[ $parRetailGoodsCostsColumnName ];

		// Заголовок стоимости:
		// имя столбца цен в таблице розничных товаров и индекс стоимости.
		$costCaption = $parRetailGoodsCostsColumnName . ( ( string ) $costIndex );

		// Элемент XML-дерева - столбец цен в таблице розничных товаров.
		$xmlTree .=
			"\t\t<{$costCaption}>" .
			$cost                  .
			"</{$costCaption}>\n";

		// Инекремент индекса стоимости.
		$costIndex++;
	} // while

	// Элемент XML-дерева - строка - закрывающий тег.
	$xmlTree .= "\t</Row>\n";
	// Корневой элемент XML-дерева - таблица розничных товаров -
	// закрывающий тег.
	$xmlTree .= "</{$parRetailGoodsTableName}>";

	// Закрытие ранее установленного сетевого соединения с базой данных.
	mysql_close( $mySQLConnectionID );

	// Вывод XML-дерева.
	echo( $xmlTree );
?>