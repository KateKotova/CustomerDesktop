<?php
	// Скрипт, возвращающий URL-адреса слайдов определённого типа диска.

	// Получение группы GET-переменных, которые создаются при анализе
	// строки запроса, которая хранится в переменной $QUERY_STRING
	// и представляет собой информацию, следующую за символом "?"
	// в запрошенном URL. РНР разбивает строку запроса по символам &
	// на отдельные элементы, а затем ищет в каждом из этих элементов знак "=".
	// Если знак "=" найден, то создается переменная с именем из символов,
	// стоящих слева от знака равенства.

	// URL-адрес компьютера-хранилища.
	$parWarehouseURL                 = $_GET[ 'WarehouseURL' ];
	// Путь к директорию, хранящему документы на компьютере-хранилище.
	$parWarehouseDocumentRoot        = $_GET[ 'WarehouseDocumentRoot' ];
	// Путь к директорию, харанящему файлы слайдов диска.
	$parDiskSlidesFilesDirectoryPath = $_GET[ 'DiskSlidesFilesDirectoryPath' ];

	// Значение артикула диска.
	$parDiskArticleValue       = $_GET[ 'DiskArticleValue' ]; 
	// Аффикс имени файла слайда диска.
	$parDiskSlideFileNameAffix = $_GET[ 'DiskSlideFileNameAffix' ];
	// Расширение файла слайда диска.
	$parDiskSlideFileExtension = $_GET[ 'DiskSlideFileExtension' ];

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

	// Очистка кеша состояния файлов.
	clearstatcache( );

	// Косая черта.
	$slash     = "/";
	// Обратная косая черта.
	$backslash = "\\";

	// Функция получения строки, завершающейся косой чертой.
	// Параметры:
	// $parString - строка.
	// Результат: строка, заканчивающаяся косой чертой.
	function GetTerminatingBySlashString( $parString )
	{
		// Косая черта.
		global $slash;
		// Обратная косая черта.
		global $backslash;

		// Последний символ строки.
		$stringLastSymbol = $parString[ strlen( $parString ) - 1 ];
		// Строка-результат.
		$resultString     = $parString;

		// Если последний символ строки не является косой чертой
		// или обратной косой чертой.
		if
		(
			( $stringLastSymbol != $slash     ) &&
			( $stringLastSymbol != $backslash )
		)
			// Строка-результат: добавление косой черты.
			$resultString .= $slash;

		// Возврат строки-результата.
		return $resultString;
	} // GetTerminatingBySlashString

	// Путь к директорию, хранящему документы на компьютере-хранилище,
	// завершающийся косой чертой.
	$warehouseDocumentRoot = GetTerminatingBySlashString
		( $parWarehouseDocumentRoot );
	// Полный путь к директорию, харанящему файлы слайдов диска.
	$diskSlidesFilesDirectoryFullPath =
		$warehouseDocumentRoot . $parDiskSlidesFilesDirectoryPath;

	// Если полный путь к директорию, хранящему файлы слайдов диска,
	// не существует.
	if( ! file_exists( $diskSlidesFilesDirectoryFullPath ) )
		// Вывододится сообщение о том, что полный путь к директорию,
		// хранящему файлы слайдов диска, не существует,
		// и текущий сценарий завершается.
		die( "The directory $diskSlidesFilesDirectoryFullPath doesn't exist" );

	// Если директорий, хранящий файлы слайдов диска, не является каталогом.
	if ( ! is_dir( $diskSlidesFilesDirectoryFullPath ) )
		// Вывододится сообщение о том, что директорий,
		// хранящий файлы слайдов диска, не является каталогом,
		// и текущий сценарий завершается.
		die( "The file $diskSlidesFilesDirectoryFullPath isn't a directory" );

	// Полный путь к директорию, харанящему файлы слайдов диска,
	// завершающийся косой чертой.
	$diskSlidesFilesDirectoryFullPath = GetTerminatingBySlashString
		( $diskSlidesFilesDirectoryFullPath );
	// URL-адрес директория, хранящего файлы слайдов диска.
	$diskSlidesFilesDirectoryURL      =
		$parWarehouseURL .$parDiskSlidesFilesDirectoryPath;
	// URL-адрес директория, хранящего файлы слайдов диска,
	// завершающийся косой чертой.
	$diskSlidesFilesDirectoryURL      = GetTerminatingBySlashString
		( $diskSlidesFilesDirectoryURL );

	// XML-дерево.
	// Корневой элемент XML-дерева - файлы слайдов диска - открывающий тег.
	$xmlTree = "<DiskSlidesFiles>\n";
	// Заголовок файла слайда диска.
	$diskSlideFileCaption = "DiskSlideFile";

	// Признак необходимости продолжения поиска файлов слайдов диска.
	$mustContinueSearch = true;
	// Индекс текущего файла слайда диска.
	$diskSlideFileIndex = 1;
	// Точка.
	$point              = ".";

	// Пока следует продолжать поиск файлов слайдов диска, поиск продолжается.
	while ( $mustContinueSearch )
	{
		// Имя текущего файла слайда диска.
		$diskSlideFileName =
			// Значение артикула диска.
			$parDiskArticleValue       .
			// Аффикс имени файла слайда диска.
			$parDiskSlideFileNameAffix .
			// Индекс текущего файла слайда диска.
			$diskSlideFileIndex        .
			// Точка.
			$point                     .
			// Расширение файла слайда диска.
			$parDiskSlideFileExtension;

		// Полный путь к текущему файлу слайда диска.
		$diskSlideFileFullPath =
			// Полный путь к директорию, харанящему файлы слайдов диска.
			$diskSlidesFilesDirectoryFullPath .
			// Имя текущего файла слайда диска.
			$diskSlideFileName;

		// Если текущий файл слайда диска, не существует.
		if( ! file_exists( $diskSlideFileFullPath ) )
			// Поиск файлов слайдов диска следует прекратить.
			$mustContinueSearch = false;
		else
		{
			// URL-адрес текущего файла слайда диска.
			$diskSlideFileURL =
				// URL-адрес директория, хранящего файлы слайдов диска.
				$diskSlidesFilesDirectoryURL .
				// Имя текущего файла слайда диска.
				$diskSlideFileName;

			// Элемент XML-дерева - строка - открывающий тег.
			$xmlTree .= "\t<Row>\n";
			// Элемент XML-дерева - файл слайда диска.
			$xmlTree .=
				"\t\t<{$diskSlideFileCaption}>" .
				$diskSlideFileURL .
				"</{$diskSlideFileCaption}>\n";
			// Элемент XML-дерева - строка - закрывающий тег.
			$xmlTree .= "\t</Row>\n";

			// Инкремент индекса текущего файла слайда диска.
			$diskSlideFileIndex++;
		} // else
	} // while

	// Корневой элемент XML-дерева - файлы слайдов диска - закрывающий тег.
	$xmlTree .= "</DiskSlidesFiles>";

	// Очистка кеша состояния файлов.
	clearstatcache( );

	// Вывод XML-дерева.
	echo( $xmlTree );
?>