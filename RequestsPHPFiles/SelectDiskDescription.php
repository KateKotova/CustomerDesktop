<?php
	// Скрипт, возвращающий описание диска.

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
	$parNomenclaturesTableName = $_GET[ 'NomenclaturesTableName' ];
	// Имя столбца артикулов в таблице номенклатур.
	$parNomenclaturesArticlesColumnName     =
		$_GET[ 'NomenclaturesArticlesColumnName' ];
	// Значение артикула изображения.
	$parImageArticleValue      = $_GET[ 'ImageArticleValue' ];
	// Имя столбца описаний в таблице номенклатур.
	$parNomenclaturesDescriptionsColumnName =
		$_GET[ 'NomenclaturesDescriptionsColumnName' ];

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
		"SELECT {$parNomenclaturesDescriptionsColumnName} " .
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

	// XML-дерево.
	// Корневой элемент XML-дерева - таблица номенклатур - открывающий тег.
	$xmlTree = "<{$parNomenclaturesTableName}>\n";

	// Записи, полученные в результате выполненного запроса, просматриваются
	// последовательно, и до тех пор пока они не просмотрены все,
	// текущая запись помещается в ассоциативный массив, элементами которого
	// являются значения ячеек просматриваемой записи-строки.
	while ( $mySQLQueryFetch = mysql_fetch_assoc( $mySQLQueryID ) )
	{
		// Элемент XML-дерева - строка - открывающий тег.
		$xmlTree .= "\t<Row>\n";
		// Элемент XML-дерева - столбец описаний в таблице номенклатур.
		$xmlTree .=
			"\t\t<{$parNomenclaturesDescriptionsColumnName}>" .
			$mySQLQueryFetch[ $parNomenclaturesDescriptionsColumnName ] .
			"</{$parNomenclaturesDescriptionsColumnName}>\n";
		// Элемент XML-дерева - строка - закрывающий тег.
		$xmlTree .= "\t</Row>\n";
	} // while

	// Корневой элемент XML-дерева - таблица номенклатур - закрывающий тег.
	$xmlTree .= "</{$parNomenclaturesTableName}>";

	// Закрытие ранее установленного сетевого соединения с базой данных.
	mysql_close( $mySQLConnectionID );

	// Вывод XML-дерева.
	echo( $xmlTree );
?>