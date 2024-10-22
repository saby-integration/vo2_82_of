
#Область include_local_ПолучитьМодульОбъекта
#КонецОбласти

// функции для совместимости кода 
&НаКлиенте
Функция сбисПолучитьФорму(ИмяФормы)
	Если ТипЗнч(ЭтаФорма) = Тип("УправляемаяФорма") Тогда
		Попытка
			ЭтотОбъект="";
		Исключение
		КонецПопытки;
		Возврат ПолучитьФорму("ВнешняяОбработка.СБИС.Форма."+ИмяФормы);
	КонецЕсли;
	Возврат ЭтотОбъект.ПолучитьФорму(ИмяФормы);
КонецФункции
&НаКлиенте
Функция сбисЭлементФормы(Форма,ИмяЭлемента)
	Если ТипЗнч(ЭтаФорма) = Тип("УправляемаяФорма") Тогда
		Возврат Форма.Элементы.Найти(ИмяЭлемента);
	КонецЕсли;
	Возврат Форма.ЭлементыФормы.Найти(ИмяЭлемента);
КонецФункции
&НаКлиенте
Функция сбисПолучитьСтраницу(Элемент, ИмяСтраницы)
	Если ТипЗнч(ЭтаФорма) = Тип("УправляемаяФорма") Тогда
		Возврат Элемент.ПодчиненныеЭлементы[ИмяСтраницы];
	КонецЕсли;
	Возврат Элемент.Страницы[ИмяСтраницы];
КонецФункции
//------------------------------------------------------
&НаКлиенте
Функция ОбновитьКонтент(Кэш) Экспорт
	Если Не ЗначениеЗаполнено(Кэш) Тогда
		Возврат Ложь;
	ИначеЕсли Не (	Кэш.Парам.СпособОбмена	= 3
				Или	Кэш.Парам.СпособОбмена	= 4
				Или	Кэш.Парам.СпособОбмена	= 5
				Или	Кэш.Парам.СпособОбмена	= 6
				Или	Кэш.Парам.СпособОбмена	= 7) Тогда//Для обычных форм, нет управления видимостью аккордеона для отдельной кнопки. Просто сообщить о том, что нельзя использовать раздел.
		Сообщить("Раздел Задач доступен только для способа обмена через API/extSDK.", СтатусСообщения.Внимание);
		Возврат Ложь;
	КонецЕсли;
	//Добавить колонки в таблицу
	СтруктураТаблицыСобытий	= ПолучитьСтруктуруТаблицыСобытий(Кэш);
	Кэш.ГлавноеОкно.НастроитьКолонкиФормы(СтруктураТаблицыСобытий);
	
	Возврат Кэш.ГлавноеОкно.ПерейтиВРаздел("АккордеонМои88");	
КонецФункции

// Функция делает подготовку к переходу	
&НаКлиенте
Функция ОбновитьКонтент_ПередВызовом(СтруктураРаздела, Кэш) Экспорт
	
	Если ЗначениеЗаполнено(Кэш.Парам.ФильтрыПоРазделам["Задачи"]) Тогда
		Кэш.ГлавноеОкно.сбисВосстановитьФильтр(Кэш, Кэш.Парам.ФильтрыПоРазделам["Задачи"]);
	Иначе
		ФильтрОчистить(Кэш);
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура НаСменуРаздела(Кэш) Экспорт
	
	// Процедура обновляет панель массовых операций, панель фильтра, контекстное меню при смене раздела	
	СоответствиеФильтра	= ПолучитьСоответствиеЗначенийФильтра();
	
	СписокСостояний = Новый СписокЗначений();

	Для	Каждого	ЭлементСоответствия	Из	СоответствиеФильтра	Цикл
		СписокСостояний.Добавить(ЭлементСоответствия.Значение, ЭлементСоответствия.Значение);
	КонецЦикла;
	
	ГлавноеОкно = Кэш.ГлавноеОкно;
	ГлавноеОкно.СписокСостояний = СписокСостояний;
	//ГлавноеОкно.ФильтрСостояние = СписокСостояний.НайтиПоИдентификатору(0).Значение;
	ГлавноеОкно.ФильтрОбновитьПанель();
	ПанельМассовыхОпераций = сбисЭлементФормы(ГлавноеОкно,"ПанельМассовыхОпераций");
	ПанельМассовыхОпераций.ТекущаяСтраница = ГлавноеОкно.сбисПолучитьСтраницу(ПанельМассовыхОпераций,"Задачи");
	
	//ГлавноеОкно.сбисУстановитьКонтекстноеМеню("Таблица_РеестрДокументов", "КонтекстноеМенюПолученные");
	ГлавноеОкно.сбисУстановитьКонтекстноеМеню("Таблица_РеестрСобытий", "КонтекстноеМенюЗадачиРеестрСобытий");
	//ПанельМассовыхОпераций = сбисЭлементФормы(ГлавноеОкно,"ПанельМассовыхОпераций");
	//ПанельМассовыхОпераций.ТекущаяСтраница = сбисПолучитьСтраницу(ПанельМассовыхОпераций,"Полученные");
	//сбисЭлементФормы(ГлавноеОкно,"ПанельМассовыхОпераций").Видимость = Ложь;//aa.uferov раздел задач	
	сбисЭлементФормы(ГлавноеОкно,"ПанельТулбар").Видимость = Истина;	
	сбисЭлементФормы(ГлавноеОкно,"ПанельФильтра").Видимость = Истина;
	сбисЭлементФормы(ГлавноеОкно,"ПоказатьПанельФильтра").Видимость = Истина;
КонецПроцедуры
&НаКлиенте
Процедура НастроитьКолонки(Кэш) Экспорт
	//СтатусВГосСистеме
	ПутьРеквизит = "Таблица_РеестрСобытий." + ?(Кэш.ПараметрыСистемы.Клиент.УправляемоеПриложение, "Таблица_РеестрСобытий", "");
	Кэш.ГлавноеОкно.СбисПолучитьЭлементФормы(Кэш.ГлавноеОкно, ПутьРеквизит + "СтатусВГосСистеме").Видимость = Ложь;	 	
	Кэш.ГлавноеОкно.СбисПолучитьЭлементФормы(Кэш.ГлавноеОкно, Кэш.ГлавноеОкно.СбисПолноеИмяКолонки("Таблица_РеестрСобытий",	"Комментарий")).Видимость = Истина;
	Кэш.ГлавноеОкно.СбисПолучитьЭлементФормы(Кэш.ГлавноеОкно, Кэш.ГлавноеОкно.СбисПолноеИмяКолонки("Таблица_РеестрСобытий",	"Ответственный")).Видимость = Истина;
	Кэш.ГлавноеОкно.СбисПолучитьЭлементФормы(Кэш.ГлавноеОкно, Кэш.ГлавноеОкно.СбисПолноеИмяКолонки("Таблица_РеестрСобытий",	"Вложения")).Видимость = Истина;	
	
	МассивРеквизитов = Новый Массив;
	МассивРеквизитов.Добавить("Заказчик");
	МассивРеквизитов.Добавить("Перевозчик");
	
	Кэш.ГлавноеОкно.НастроитьКолонкиФормы(Новый Структура("ИмяТаблицы, СтруктураПолей", "Таблица_РеестрСобытий", Новый Структура("КолонкиУдалить", МассивРеквизитов)));
КонецПроцедуры
&НаКлиенте
Процедура НавигацияУстановитьПанель(Кэш) Экспорт
	// Процедура устанавливает панель навигации на 1ую страницу	
	ГлавноеОкно = сбисПолучитьФорму("ФормаГлавноеОкно");
	сбисЭлементФормы(ГлавноеОкно,"ПанельНавигации").Видимость=Истина;
	сбисЭлементФормы(ГлавноеОкно,"ЗаписейНаСтранице1С").Видимость=Ложь;
	сбисЭлементФормы(ГлавноеОкно,"ЗаписейНаСтранице").Видимость=Истина;	
КонецПроцедуры	
&НаКлиенте
Функция ПодготовитьСтруктуруДокумента(СтрокаСпискаДокументов, Кэш) Экспорт
	// функция формирует структуру данных по пакету электронных документов, необходимую для его предварительного просмотра и загрузки в 1С	
	Возврат Кэш.ОбщиеФункции.ПодготовитьСтруктуруДокументаСбис(СтрокаСпискаДокументов, Кэш);
КонецФункции
&НаКлиенте
Процедура ФильтрОчистить(Кэш) Экспорт
	// Процедура устанавливает значения фильтра по-умолчанию для текущего раздела	
	ГлавноеОкно = Кэш.ГлавноеОкно;
	
	ОписаниеТиповФильтра = МодульОбъектаКлиент().ПолучитьЗначениеПараметраТекущегоСеанса("ТипыПолейФильтра");
	Если Не ТипЗнч(ОписаниеТиповФильтра) = Тип("Структура") Тогда
		ОписаниеТиповФильтра = Новый Структура;
	КонецЕсли;
	
	Если ТипЗнч(ЭтаФорма) = Тип("УправляемаяФорма") Тогда
		ГлавноеОкно.ФильтрПериод = "За весь период";
	Иначе
		ГлавноеОкно.ФильтрПериод = "0";
	КонецЕсли;
	Если ОписаниеТиповФильтра.Свойство("ФильтрОрганизация") Тогда
		ГлавноеОкно.ФильтрОрганизация = ОписаниеТиповФильтра.ФильтрОрганизация.ПривестиЗначение();
	Иначе	
		ГлавноеОкно.ФильтрОрганизация = "";
	КонецЕсли;
	Если ОписаниеТиповФильтра.Свойство("ФильтрКонтрагент") Тогда
		ГлавноеОкно.ФильтрКонтрагент = ОписаниеТиповФильтра.ФильтрКонтрагент.ПривестиЗначение();
	Иначе	
		ГлавноеОкно.ФильтрКонтрагент = "";
	КонецЕсли;
	Если ОписаниеТиповФильтра.Свойство("ФильтрОтветственный") Тогда
		ГлавноеОкно.ФильтрОтветственный = ОписаниеТиповФильтра.ФильтрОтветственный.ПривестиЗначение();
	Иначе	
		ГлавноеОкно.ФильтрОтветственный = "";
	КонецЕсли;
	ГлавноеОкно.ФильтрДатаНач = "";
	ГлавноеОкно.ФильтрДатаКнц = "";
	ГлавноеОкно.ФильтрСостояние = ГлавноеОкно.СписокСостояний.НайтиПоИдентификатору(0).Значение;
	ГлавноеОкно.ФильтрКонтрагентПодключен = "";
	ГлавноеОкно.ФильтрКонтрагентСФилиалами = Ложь;
	ГлавноеОкно.ФильтрСтраница = 1;
	ГлавноеОкно.ФильтрМаска = "";
	
	//++ Бухов А. Фильтр по умолчанию 	
	Если Кэш.Ини.Конфигурация.Свойство("ФильтрПоУмолчанию") И  Кэш.Ини.Конфигурация.ФильтрПоУмолчанию.Свойство(Кэш.Текущий.ТипДок) Тогда 
		Попытка
			Ини = Кэш.ОбщиеФункции.ПолучитьДанныеДокумента1С(Кэш.Ини.Конфигурация.ФильтрПоУмолчанию[Кэш.Текущий.ТипДок],Неопределено,Кэш.КэшЗначенийИни, Кэш.Парам);  // alo Меркурий
			Для Каждого Элем Из Ини Цикл 
				Если нрег(Лев(Элем.Ключ, 6)) = "фильтр" Тогда
					ГлавноеОкно[Элем.Ключ] = Элем.Значение;
				КонецЕсли;
			КонецЦикла;
		Исключение
		КонецПопытки;
	КонецЕсли;
	//-- Бухов А. Фильтр по умолчанию
КонецПроцедуры
&НаКлиенте
Функция ПолучитьСоответствиеЗначенийФильтра() Экспорт
	
	СоответствиеФильтра	= Новый	СписокЗначений;
	СоответствиеФильтра.Добавить("Все документы",						-1);
	СоответствиеФильтра.Добавить("Документ редактируется",				0);
	//СоответствиеФильтра.Добавить("Есть документ",						1);
	СоответствиеФильтра.Добавить("Отправлено приглашение",				2);
	СоответствиеФильтра.Добавить("Отправлен",							3);
	СоответствиеФильтра.Добавить("Доставлен",							4);
	//СоответствиеФильтра.Добавить("Сохранен",							5);
	СоответствиеФильтра.Добавить("Проблемы при доставке",				6);
	СоответствиеФильтра.Добавить("Выполнение завершено успешно",		7);
	//СоответствиеФильтра.Добавить("Нарушение сроков",					8);
	СоответствиеФильтра.Добавить("Выполнение завершено с проблемами",	9);
	СоответствиеФильтра.Добавить("В Обработке",							10);
	//СоответствиеФильтра.Добавить("Сложное состояние",					11);
	//СоответствиеФильтра.Добавить("Отправлен на проверку",				14);
	//СоответствиеФильтра.Добавить("Импортирован",						15);
	//СоответствиеФильтра.Добавить("Требуется корректировка",				18);
	//СоответствиеФильтра.Добавить("Отозван мной",						19);
	СоответствиеФильтра.Добавить("Удален контрагентом",					20);
	//СоответствиеФильтра.Добавить("Удален",								21);
	//СоответствиеФильтра.Добавить("Аннулирован по соглашению",			22);
	//СоответствиеФильтра.Добавить("ВИ Ошибка отправки",					12);
	//СоответствиеФильтра.Добавить("ВИ Загружен на сервер",				13);
	//СоответствиеФильтра.Добавить("ВИ Отправлена команда утвердить",		16);
	//СоответствиеФильтра.Добавить("ВИ Отправлена команда отклонить",		17);
	//СоответствиеФильтра.Добавить("ВИ Отправлена команда удалить",		30);
	
	Возврат	СоответствиеФильтра;
	
КонецФункции
&НаКлиенте
Функция ПолучитьСтруктуруТаблицыСобытий(Кэш) Экспорт//При переходе в раздел задач, установить таблицу событий
	
	КолонкиИзменить	= Новый	Массив;
	Если  ТипЗнч(Кэш.ГлавноеОкно) = Тип("УправляемаяФорма") Тогда
		ДобавитьКИмениКолонки = "Таблица_РеестрСобытий";
		ПараметрИзменить = "Заголовок";
		ПутьККолонкам	= "Элементы.Таблица_РеестрСобытий.ПодчиненныеЭлементы";
	Иначе
		ДобавитьКИмениКолонки = "";
		ПараметрИзменить = "ТекстШапки";
		ПутьККолонкам	= "ЭлементыФормы.Таблица_РеестрСобытий.Колонки";
	КонецЕсли;
	КолонкиИзменить.Добавить(Новый Структура("ПолноеИмяКолонки, ИмяКолонки, ПараметрыИзменить", ДобавитьКИмениКолонки + "Контрагент", "Контрагент", Новый Структура(ПараметрИзменить, "Отправитель")));
	КолонкиИзменить.Добавить(Новый Структура("ПолноеИмяКолонки, ИмяКолонки, ПараметрыИзменить", ДобавитьКИмениКолонки + "НашаОрганизация", "НашаОрганизация", Новый Структура(ПараметрИзменить, "Автор")));
	
	СтруктураОбновления	= Новый	Структура();
	СтруктураОбновления.Вставить("ИмяТаблицы",		"Таблица_РеестрСобытий");
	СтруктураОбновления.Вставить("СтруктураПолей",	Новый	Структура("КолонкиИзменить", КолонкиИзменить));
	СтруктураОбновления.Вставить("ПутьККолонкам",	ПутьККолонкам);
	
	Возврат	СтруктураОбновления;

КонецФункции
