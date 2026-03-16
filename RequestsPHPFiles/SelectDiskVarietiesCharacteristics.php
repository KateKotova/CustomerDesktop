<?php
	// Скрипт, возвращающий характеристики разновидностей дисков.

	// Получение группы GET-переменных, которые создаются при анализе
	// строки запроса, которая хранится в переменной $QUERY_STRING
	// и представляет собой информацию, следующую за символом "?"
	// в запрошенном URL. РНР разбивает строку запроса по символам &
	// на отдельные элементы, а затем ищет в каждом из этих элементов знак "=".
	// Если знак "=" найден, то создается переменная с именем из символов,
	// стоящих слева от знака равенства.

	// Имя хоста.
	$parHostName              = $_GET[ 'HostName' ];
	// Имя пользователя.
	$parUserName              = $_GET[ 'UserName' ];
	// Пароль пользователя.
	$parUserPassword          = $_GET[ 'UserPassword' ];
	// Имя базы данных.
	$parDatabaseName          = $_GET[ 'DatabaseName' ];
	// Строка-разделитель элементов массивов.
	$parArraysSeparatorString = $_GET[ 'ArraysSeparatorString' ];

	// Имя таблицы розничных товаров.
	$parRetailGoodsTableName        = $_GET[ 'RetailGoodsTN' ];
	// Имя столбца идентивикаторов номенклатур в таблице розничных товаров.
	$parRetailGoodsNomenclaturesIDsColumnName  =
		$_GET[ 'RetailGoodsNomenclaturesIDsCN' ];
	// Имя столбца идентивикаторов разновидностей дисков
	// в таблице розничных товаров.
	$parRetailGoodsDisksVarietiesIDsColumnName =
		$_GET[ 'RetailGoodsDisksVarietiesIDsCN' ];
	// Имя столбца количеств в таблице розничных товаров.
	$parRetailGoodsCountsColumnName = $_GET[ 'RetailGoodsCountsCN' ];

	// Имя таблицы номенклатур.
	$parNomenclaturesTableName          = $_GET[ 'NomenclaturesTN' ];
	// Имя столбца идентивикаторов в таблице номенклатур.
	$parNomenclaturesIDsColumnName      = $_GET[ 'NomenclaturesIDsCN' ];
	// Имя столбца артикулов в таблице номенклатур.
	$parNomenclaturesArticlesColumnName = $_GET[ 'NomenclaturesArticlesCN' ];
	// Значение артикула изображения.
	$parImageArticleValue               = $_GET[ 'ImageArticleValue' ]; 

	// Имя таблицы групп товаров.
	$parGoodsGroupsTableName       = $_GET[ 'GoodsGroupsTN' ]; 
	// Имя столбца кодов в таблице групп товаров.
	$parGoodsGroupsCodesColumnName = $_GET[ 'GoodsGroupsCodesCN' ];
	// Значение кода группы диска.
	$parDiskGroupCodeValue         = $_GET[ 'DiskGroupCodeValue' ];
	// Имя столбца наименований в таблице групп товаров.
	$parGoodsGroupsNamesColumnName = $_GET[ 'GoodsGroupsNamesCN' ];

	// Имя таблицы ссылок разновидностей дисков.
	$parDisksVarietiesReferencesTableName                                  =
		$_GET[ 'DisksVarietiesReferencesTN' ];
	// Имя столбца идентивикаторов номенклатур
	// в таблице ссылок разновидностей дисков.
	$parDisksVarietiesReferencesNomenclaturesIDsColumnName                 =
		$_GET[ 'DisksVarietiesReferencesNomenclaturesIDsCN' ];
	// Имя столбца идентивикаторов характеристик разновидностей дисков
	// в таблице ссылок разновидностей дисков.
	$parDisksVarietiesReferencesDisksVarietiesCharacteristicsIDsColumnName =
		$_GET[ 'DisksVarietiesReferencesDisksVarietiesCharacteristicsIDsCN' ];
	// Имя столбца идентивикаторов разновидностей дисков
	// в таблице ссылок разновидностей дисков.
	$parDisksVarietiesReferencesDisksVarietiesIDsColumnName                =
		$_GET[ 'DisksVarietiesReferencesDisksVarietiesIDsCN' ];

	// Имя столбца в таблице ссылок разновидностей дисков,
	// упорядочивающего характеристики разновидностей дисков.
	$parDisksVarietiesReferencesCharacteristicsOrderingColumnName    =
		$_GET[ 'DisksVarietiesReferencesCharacteristicsOrderingCN' ];
	// Направление упорядочения характеристик разновидностей дисков
	// в таблице ссылок разновидностей дисков:
	// 1 - упорядочение по возрастанию упорядочивающего столбца,
	// 0 - упорядочение по убыванию упорядочивающего столбца.
	$parDisksVarietiesReferencesCharacteristicsOrderingAscendantSign =
		$_GET[ 'DisksVarietiesReferencesCharacteristicsOrderingAS' ];

	// Имя таблицы названий характеристик дисков.
	$parDisksCharacteristicsNamesTableName               =
		$_GET[ 'DisksCharacteristicsNamesTN' ];
	// Имя столбца наименований групп
	// в таблице названий характеристик дисков.
	$parDisksCharacteristicsNamesGroupsNamesColumnName   =
		$_GET[ 'DisksCharacteristicsNamesGroupsNamesCN' ];
	// Строка массива имён столбцов названий
	// в таблице названий характеристик дисков.
	$parDisksCharacteristicsNamesNamesColumnsNamesString =
		$_GET[ 'DisksCharacteristicsNamesNamesCsNsString' ];

	// Имя таблицы характеристик разновидностей дисков.
	$parDisksVarietiesCharacteristicsTableName                         =
		$_GET[ 'DisksVarietiesCharacteristicsTN' ];
	// Имя столбца идентификаторов
	// в таблице характеристик разновидностей дисков.
	$parDisksVarietiesCharacteristicsIDsColumnName                     =
		$_GET[ 'DisksVarietiesCharacteristicsIDsCN' ];
	// Строка массива имён столбцов характеристик
	// в таблице характеристик разновидностей дисков.
	$parDisksVarietiesCharacteristicsCharacteristicsColumnsNamesString =
		$_GET[ 'DisksVarietiesCharacteristicsCharacteristicsCsNsString' ];

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

	// Длина строки-разделителя элементов массивов.
	$arraysSeparatorStringLength = strlen( $parArraysSeparatorString );

	// Функция получения массива из строки.
	// Параметры:
	// $parArrayString - строка массива.
	// Результат: массив.
	function GetArrayFromString( $parArrayString )
	{
		// Строка-разделитель элементов массивов.
		global $parArraysSeparatorString;
		// Длина строки-разделителя элементов массивов.
		global $arraysSeparatorStringLength;

		// Массив представлен строкой, в которой записаны элементы,
		// отделённые друг от друга строкой-разделителем.

		// Индекс элемента массива.
		$arrayElementIndex = 0;

		// Поиск подстроки строки-разделителя элементов массивов в строке массива.
		while
		(
			// Позиция первого вхождения подстроки строки-разделителя
			// элементов массивов в строку массива.
			$arraysSeparatorStringFirstPosition =
				strpos( $parArrayString, $parArraysSeparatorString )
		)
		{
			// Запись текущего элемента, извлекаемого из строки массива, в массив:
			// подстрока от начала строки массива до позиции первого вхождения в неё
			// подстроки строки-разделителя элементов массивов.
			$array[ $arrayElementIndex ] =
				substr( $parArrayString, 0, $arraysSeparatorStringFirstPosition );

			// Новая строка массива - строка массива
			// без подстроки текущего элемента массива.

			// Новая начальная позиция строки массива.
			$arrayStringNewStartPosition =
				$arraysSeparatorStringFirstPosition +
				$arraysSeparatorStringLength;
			// Новая длина строки массива.
			$arrayStringNewLength        =
				strlen( $parArrayString )           -
				$arrayStringNewStartPosition;
			// Новая строка массива.
			$parArrayString              =
				substr
				(
					$parArrayString,
					$arrayStringNewStartPosition,
					$arrayStringNewLength
				); // substr

			// Инекремент индекса элемента массива.
			$arrayElementIndex++;
		} // while

		// Последний элемент массива - последний элемент,
		// извлекаемый из строки массива, - вся оставшаяся часть строки массива.
		$array[ $arrayElementIndex ] = $parArrayString;

		// Массив.
		return $array;
	} // GetArrayFromString

	// Массив имён столбцов названий в таблице названий характеристик дисков,
	// полученный из строки, в которой записаны элементы,
	// отделённые друг от друга строкой-разделителем.
	$disksCharacteristicsNamesNamesColumnsNames = GetArrayFromString
		( $parDisksCharacteristicsNamesNamesColumnsNamesString );
	// Массив имён столбцов характеристик
	// в таблице характеристик разновидностей дисков
	// полученный из строки, в которой записаны элементы,
	// отделённые друг от друга строкой-разделителем.
	$disksVarietiesCharacteristicsCharacteristicsColumnsNames =
		GetArrayFromString
		( $parDisksVarietiesCharacteristicsCharacteristicsColumnsNamesString );

	// Количество имён столбцов названий
	// в таблице названий характеристик дисков -
	// количество элементов массива имён столбцов названий
	// в таблице названий характеристик дисков.
	$disksCharacteristicsNamesNamesColumnsNamesCount               =
		count( $disksCharacteristicsNamesNamesColumnsNames );
	// Количество имён столбцов характеристик
	// в таблице характеристик разновидностей дисков -
	// количество элементов массива имён столбцов характеристик
	// в таблице характеристик разновидностей дисков.
	$disksVarietiesCharacteristicsCharacteristicsColumnsNamesCount =
		count( $disksVarietiesCharacteristicsCharacteristicsColumnsNames );

	// Если количество имён столбцов названий
	// в таблице названий характеристик дисков меньше,
	// чем количество имён столбцов характеристик
	// в таблице характеристик разновидностей дисков.
	if ( $disksCharacteristicsNamesNamesColumnsNamesCount <
			$disksVarietiesCharacteristicsCharacteristicsColumnsNamesCount )
		// Количество характеристик диска - количество имён столбцов названий
		// в таблице названий характеристик дисков.
		$diskCharacteristicsCount =
			$disksCharacteristicsNamesNamesColumnsNamesCount;
	else
		// Количество характеристик диска - количество имён столбцов
		// характеристик в таблице характеристик разновидностей дисков.
		$diskCharacteristicsCount =
			$disksVarietiesCharacteristicsCharacteristicsColumnsNamesCount;

	// Пробел.
	$space = " ";
	// Запятая.
	$comma = ",";
	// Основа заголовка характеристики диска.
	$diskCharacteristicCaptionBase = "C";

	// Функция добавления результата выполненного запроса
	// в массив названий характеристик и характеристик разновидностей диска.
	function AddMySQLQueryResultToArray( )
	{
		// Идентификатор выполненного запроса.
		global $mySQLQueryID;
		// Количество характеристик диска.
		global $diskCharacteristicsCount;
		// Массив названий характеристик и характеристик разновидностей диска.
		global $array;
		// Индекс текущего столбца массива.
		global $arrayCurrentColumnIndex;
		// Основа заголовка характеристики диска.
		global $diskCharacteristicCaptionBase;

		// Записи, полученные в результате выполненного запроса, просматриваются
		// последовательно, и до тех пор, пока они не просмотрены все,
		// элементы текущей записи-строки
		// помещаются в текущий столбец двумерного массива.
		while ( $mySQLQueryFetch = mysql_fetch_assoc( $mySQLQueryID ) )
		{
			// Последовательный просмотр всех характеристик диска.
			for
			(
				$diskCharacteristicIndex = 0;
				$diskCharacteristicIndex < $diskCharacteristicsCount;
				$diskCharacteristicIndex++
			)
				// Запись текущего названия характеристики
				// или текущей характеристики в массив
				// по индексу текущего столбца массива
				// и индексу текущей строки массива -
				// индексу текущей характиристики диска.
				$array[ $arrayCurrentColumnIndex ][ $diskCharacteristicIndex ] =
					$mySQLQueryFetch
					[
						$diskCharacteristicCaptionBase .
						( ( string ) $diskCharacteristicIndex )
					];

			// Инекремент индекса текущего столбца массива.
			$arrayCurrentColumnIndex++;
		} // while
	} // AddMySQLQueryResultToArray

	// Строка запроса к базе данных MySQL с заданным названием.
	// Начало предложения SELECT.
	$mySQLQueryString = "SELECT ";

	// Последовательный просмотр всех характеристик диска.
	for
	(
		$diskCharacteristicIndex = 0;
		$diskCharacteristicIndex < $diskCharacteristicsCount;
		$diskCharacteristicIndex++
	)
	{
		// Столбец названий из таблицы названий характеристик дисков
		// с именем, извлекаемым из массива по текущему индексу характеристики.
		$disksCharacteristicsNamesNamesColumnName =
			$disksCharacteristicsNamesNamesColumnsNames
			[ $diskCharacteristicIndex ];
		// Строка запроса к базе данных MySQL с заданным названием.
		// Продолжение предложения SELECT:
		// выбор столбца названий из таблицы названий характеристик дисков
		// с именем, извлекаемым из массива по текущему индексу характеристики,
		// столбец переименовывается, как основа заголовка характеристики диска
		// с текущим индексом характеристики.
		$mySQLQueryString .=
			"{$disksCharacteristicsNamesNamesColumnName} AS " .
			"{$diskCharacteristicCaptionBase}"                .
			"{$diskCharacteristicIndex}";

		// Если столбец названий из таблицы названий характеристик дисков
		// не последний в числе характеристик.
		if ( $diskCharacteristicIndex < $diskCharacteristicsCount - 1 )
			// Ставится запятая в ожидании записи следующего выбираемого столбца.
			$mySQLQueryString .= $comma;
		// Записывается пробел для отделения текущей фразы от следующей.
		$mySQLQueryString .= $space;
	} // for

	// Строка запроса к базе данных MySQL с заданным названием.
	// Запись других предложений после SELECT.
	$mySQLQueryString .=
		"FROM {$parDisksCharacteristicsNamesTableName} " .
		"WHERE {$parDisksCharacteristicsNamesGroupsNamesColumnName} = " .
		"( " .
			"SELECT {$parGoodsGroupsNamesColumnName} " .
			"FROM {$parGoodsGroupsTableName} " .
			"WHERE {$parGoodsGroupsCodesColumnName} = {$parDiskGroupCodeValue} " .
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

	// Индекс текущего столбца массива.
	$arrayCurrentColumnIndex = 0;
	// Добавление результата выполненного запроса
	// в массив названий характеристик и характеристик разновидностей диска.
	AddMySQLQueryResultToArray( );

	// Строка запроса к базе данных MySQL с заданным названием.
	// Начало предложения SELECT.
	$mySQLQueryString = "SELECT ";

	// Последовательный просмотр всех характеристик диска.
	for
	(
		$diskCharacteristicIndex = 0;
		$diskCharacteristicIndex < $diskCharacteristicsCount;
		$diskCharacteristicIndex++
	)
	{
		// Столбец характеристик из таблицы характеристик разновидностей дисков
		// с именем, извлекаемым из массива по текущему индексу характеристики.
		$disksVarietiesCharacteristicsCharacteristicsColumnName =
			$disksVarietiesCharacteristicsCharacteristicsColumnsNames
			[ $diskCharacteristicIndex ];
		// Строка запроса к базе данных MySQL с заданным названием.
		// Продолжение предложения SELECT:
		// выбор столбца характеристик
		// из таблицы характеристик разновидностей дисков с именем,
		// извлекаемым из массива по текущему индексу характеристики,
		// столбец переименовывается, как основа заголовка характеристики диска
		// с текущим индексом характеристики.
		$mySQLQueryString .=
			"{$parDisksVarietiesCharacteristicsTableName}."                 .
			"{$disksVarietiesCharacteristicsCharacteristicsColumnName} AS " .
			"{$diskCharacteristicCaptionBase}"                              .
			"{$diskCharacteristicIndex}";

		// Если столбец характеристик из таблицы характеристик
		// разновидностей дисков не последний в числе характеристик.
		if ( $diskCharacteristicIndex < $diskCharacteristicsCount - 1 )
			// Ставится запятая в ожидании записи следующего выбираемого столбца.
			$mySQLQueryString .= $comma;
		// Записывается пробел для отделения текущей фразы от следующей.
		$mySQLQueryString .= $space;
	} // for

	// Строка запроса к базе данных MySQL с заданным названием.
	// Запись других предложений после SELECT.
	$mySQLQueryString .=
		"FROM {$parRetailGoodsTableName} " .
			"INNER JOIN {$parNomenclaturesTableName} " .
			"ON " .
					"{$parRetailGoodsTableName}." .
						"{$parRetailGoodsNomenclaturesIDsColumnName} = " .
					"{$parNomenclaturesTableName}.{$parNomenclaturesIDsColumnName} " .

				"INNER JOIN {$parDisksVarietiesReferencesTableName} " .
				"ON " .
						"{$parRetailGoodsTableName}." .
							"{$parRetailGoodsNomenclaturesIDsColumnName}  = " .
						"{$parDisksVarietiesReferencesTableName}." .
				"{$parDisksVarietiesReferencesNomenclaturesIDsColumnName} AND " .

						"{$parNomenclaturesTableName}." .
							"{$parNomenclaturesIDsColumnName}             = " .
						"{$parDisksVarietiesReferencesTableName}." .
				"{$parDisksVarietiesReferencesNomenclaturesIDsColumnName} AND " .

						"{$parRetailGoodsTableName}." .
							"{$parRetailGoodsDisksVarietiesIDsColumnName} = " .
						"{$parDisksVarietiesReferencesTableName}." .
							"{$parDisksVarietiesReferencesDisksVarietiesIDsColumnName} " .

					"INNER JOIN {$parDisksVarietiesCharacteristicsTableName} " .
					"ON " .
						"{$parDisksVarietiesReferencesTableName}." .
"{$parDisksVarietiesReferencesDisksVarietiesCharacteristicsIDsColumnName} " .
						"= " .
						"{$parDisksVarietiesCharacteristicsTableName}." .
							"{$parDisksVarietiesCharacteristicsIDsColumnName} " .

		"WHERE " .
			"{$parNomenclaturesTableName}." .
				"{$parNomenclaturesArticlesColumnName} = " .
					"{$parImageArticleValue} AND " .
			"{$parRetailGoodsTableName}." .
				"{$parRetailGoodsCountsColumnName}     > 0 " .
		"GROUP BY " .
			"{$parDisksVarietiesReferencesTableName}." .
				"{$parDisksVarietiesReferencesCharacteristicsOrderingColumnName} " .
		"ORDER BY " .
			"{$parDisksVarietiesReferencesTableName}." .
				"{$parDisksVarietiesReferencesCharacteristicsOrderingColumnName} ";

	// Если направление упорядочения характеристик разновидностей дисков
	// в таблице ссылок разновидностей дисков истинно,
	// то характеристики упорядочиваются по возрастанию
	// упорядочивающего столбца, иначе - по убыванию.
	if ( $parDisksVarietiesReferencesCharacteristicsOrderingAscendantSign )
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

	// Добавление результата выполненного запроса
	// в массив названий характеристик и характеристик разновидностей диска.
	AddMySQLQueryResultToArray( );

	// Количество столбцов масива - последний индекс текущего столбца массива,
	// полученный в результате инкремента в конце последнего цикла.
	$arrayColumnsCount      = $arrayCurrentColumnIndex;
	// Значение пустой ячейки.
	$cellNullValue          = "";
	// Основа заголовка разновидности диска.
	$diskVarietyCaptionBase = "DiskVariety";

	// XML-дерево.
	// Корневой элемент XML-дерева -
	// характеристики разновидностей дисков - открывающий тег.
	$xmlTree = "<DisksVarietiesCharacteristics>\n";

	// Последовательный просмотр всех строк массива - всех характеристик диска.
	for
	(
		$diskCharacteristicIndex = 0;
		$diskCharacteristicIndex < $diskCharacteristicsCount;
		$diskCharacteristicIndex++
	)
	{
		// Признак существования (непустоты, наличия действительных значений)
		// текущей характеристики диска хотя бы для неоторых его разновидностей.
		$someDisksVarietiesHaveCurrentDiskCharacteristic = 0;
		// Индекс разновидности диска - индекс столбца массива,
		// индексация начинается с единицы,
		// а в нулевом столбце массива хранятся названия характеристик диска.
		$diskVarietyIndex                                = 1;

		// Последовательный просмотр всех ячеек массива в текущей строке
		// для текущей характеристики диска,
		// соответствующих разновидностям диска,
		// пока не просморены все ячейки или пока не найдена непустая ячейка.
		while
		(
			(   $diskVarietyIndex < $arrayColumnsCount           ) &&
			( ! $someDisksVarietiesHaveCurrentDiskCharacteristic )
		)
		{
			// Если для текущей разновидности диска характеристика не пуста.
			if ( $array[ $diskVarietyIndex ][ $diskCharacteristicIndex ] !=
					$cellNullValue )
				// Хотя бы для одной разновидности диска - текущей -
				// текущая характеристика диска определена.
				$someDisksVarietiesHaveCurrentDiskCharacteristic = 1;

			// Инекремент индекса разновидности диска.
			$diskVarietyIndex++;
		} // while

		// Если для текущей характеристики диска
		// нет ни одного действительного значения,
		// соответствующего разновидности диска.
		if ( ! $someDisksVarietiesHaveCurrentDiskCharacteristic )
			// Текущая строка - характеристика диска - не добавляется в XML-дерево
			// и управление передаётся следующей итерации.
			continue;

		// Элемент XML-дерева - строка - открывающий тег.
		$xmlTree .= "\t<Row>\n";

		// Последовательный просмотр всех столбцов массива -
		// столбца названий характеристик
		// и всех столбцов значений характеристик разновидностей диска.
		for
		(
			$arrayCurrentColumnIndex = 0;
			$arrayCurrentColumnIndex < $arrayColumnsCount;
			$arrayCurrentColumnIndex++
		)
		{
			// Заголовок разновидности диска:
			// основа заголовка разновидности диска и индекс столбца массива.
			$diskVarietyCaption = $diskVarietyCaptionBase .
				( ( string ) $arrayCurrentColumnIndex );

			// Элемент XML-дерева - разновидность диска.
			$xmlTree .=
				"\t\t<{$diskVarietyCaption}>" .
				$array[ $arrayCurrentColumnIndex ][ $diskCharacteristicIndex ] .
				"</{$diskVarietyCaption}>\n";
		} // for

		// Элемент XML-дерева - строка - закрывающий тег.
		$xmlTree .= "\t</Row>\n";
	} // for

	// Корневой элемент XML-дерева -
	// характеристики разновидностей дисков - закрывающий тег.
	$xmlTree .= "</DisksVarietiesCharacteristics>";

	// Закрытие ранее установленного сетевого соединения с базой данных.
	mysql_close( $mySQLConnectionID );

	// Вывод XML-дерева.
	echo( $xmlTree );
?>