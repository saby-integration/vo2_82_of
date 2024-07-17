Перем Кэш;

#Область include_local_ПолучитьМодульОбъекта
#КонецОбласти

Функция сбисЭлементФормы(Форма,ИмяЭлемента)
	Если ТипЗнч(ЭтаФорма) = Тип("УправляемаяФорма") Тогда
		Возврат Форма.Элементы.Найти(ИмяЭлемента);
	КонецЕсли;
	Возврат Форма.ЭлементыФормы.Найти(ИмяЭлемента);
КонецФункции

Функция ОбновитьКонтент(ЛокальныйКэш) Экспорт
	//СтруктураДляОбновленияФормы = Кэш.ОбщиеФункции.сбисОбновитьРеестрДокументов1С(Ини, Кэш);
	Кэш = ЛокальныйКэш;
	ИмяРаздела = "Справочники";	
	ИмяРеестра = "НоменклатураКонтрагентов";
	
	Кэш.Текущий.ТипДок = ИмяРеестра;
	ГлавноеОкно				= Кэш.ГлавноеОкно;
	Контент					= ГлавноеОкно.сбисЭлементФормы(ГлавноеОкно, "Контент");
	Кэш.ТаблДок				= ГлавноеОкно.сбисЭлементФормы(ГлавноеОкно, "Таблица_РеестрСправочников");
	Контент.ТекущаяСтраница	= ГлавноеОкно.сбисПолучитьСтраницу(Контент, "РеестрСправочников");	
		
	СтраницыПанели = Кэш.ОбщиеФункции.СбисПолучитьЭлементФормы(Кэш,, ИмяРаздела + "_Подразделы");
	СтраницаОперацийРеестра = Кэш.ОбщиеФункции.СбисПолучитьЭлементФормы(Кэш, СтраницыПанели, ИмяРеестра);
	
	Если Не СтраницаОперацийРеестра = Неопределено Тогда
		СтраницыПанели.ТекущаяСтраница = СтраницаОперацийРеестра;
	КонецЕсли;
		
	НаСменуРаздела(Кэш);//Вызываем руками, чтобы изменилась панель операций.
	Если Не ЗначениеЗаполнено(ГлавноеОкно.КонтрагентНоменклатуры) Тогда
		Если Кэш.Ини.Конфигурация.Свойство("Контрагент") Тогда
			ИмяСправочника = СокрЛП(Сред(Кэш.Ини.Конфигурация.Контрагент.Значение, Найти(Кэш.Ини.Конфигурация.Контрагент.Значение, ".")+1));
			ТипСправочника = "СправочникСсылка."+ИмяСправочника;
		Иначе
			ТипСправочника = "СправочникСсылка.Контрагенты";
		КонецЕсли;
		ОписаниеТипа = Новый ОписаниеТипов(ТипСправочника);
		ГлавноеОкно.сбисЭлементФормы(ГлавноеОкно,"КонтрагентНоменклатуры").ОграничениеТипа = ОписаниеТипа;
		ГлавноеОкно.КонтрагентНоменклатуры = ОписаниеТипа.ПривестиЗначение();
	КонецЕсли;

КонецФункции

Функция ОбновитьКонтентПодговитьРаздел(ПараметрыОбновления, ДопПараметры) Экспорт

	Кэш = ДопПараметры.Кэш;
	
	НаСменуРаздела(Кэш);
	НастроитьКолонки(Кэш);
	НавигацияУстановитьПанель(Кэш);
	сбисЭлементФормы(Кэш.ГлавноеОкно,"ПанельФильтра").Видимость = Истина;
	сбисЭлементФормы(Кэш.ГлавноеОкно,"ПоказатьПанельФильтра").Видимость = Истина;

	Возврат Истина;

КонецФункции

Процедура НастроитьКолонки(Кэш) Экспорт      
	МассивРеквизитов = Новый Массив;
	МассивРеквизитов.Добавить("ЕдиницаИзмерения");
	МассивРеквизитов.Добавить("Характеристика");

	Кэш.ГлавноеОкно.НастроитьКолонкиФормы(Новый Структура("ИмяТаблицы, ИмяТаблицыФормы, СтруктураПолей", "Таблица_РеестрСправочников", "Таблица_НоменклатураКонтрагентов", Новый Структура("КолонкиДобавить", МассивРеквизитов)));
КонецПроцедуры

Процедура НавигацияУстановитьПанель(ЛокальныйКэш=Неопределено) Экспорт
	ГлавноеОкно = ЛокальныйКэш.ГлавноеОкно;
	ГлавноеОкно.сбисЭлементФормы(ГлавноеОкно, "ПанельНавигации").Видимость		= Истина;
	ГлавноеОкно.сбисЭлементФормы(ГлавноеОкно, "ЗаписейНаСтранице1С").Видимость	= Истина;
	ГлавноеОкно.сбисЭлементФормы(ГлавноеОкно, "ЗаписейНаСтранице").Видимость	= Ложь;
	ГлавноеОкно.сбисЭлементФормы(ГлавноеОкно, "ОбновитьСтатусы").Видимость	= Ложь;
КонецПроцедуры

Процедура НаСменуРаздела(ЛокальныйКэш) Экспорт
	Кэш = ЛокальныйКэш;
	ГлавноеОкно = Кэш.ГлавноеОкно;
	
	ПанельМассовыхОпераций = Кэш.ГлавноеОкно.сбисЭлементФормы(Кэш.ГлавноеОкно, "ПанельМассовыхОпераций");
	Попытка
		ПанельМассовыхОпераций.ТекущаяСтраница = Кэш.ГлавноеОкно.сбисПолучитьСтраницу(ПанельМассовыхОпераций,"Справочники" + Кэш.Текущий.ТипДок);
		Кэш.ГлавноеОкно.сбисЭлементФормы(Кэш.ГлавноеОкно,"ПанельТулбар").Видимость = Истина;
	Исключение
		ПанельМассовыхОпераций.ТекущаяСтраница = Кэш.ГлавноеОкно.сбисПолучитьСтраницу(ПанельМассовыхОпераций,"Справочники");
		Кэш.ГлавноеОкно.сбисЭлементФормы(Кэш.ГлавноеОкно,"ПанельТулбар").Видимость = Истина;
	КонецПопытки;	
	
	КнопкаИмя = "СправочникиОтправить";
	ГлавноеОкно.сбисОчиститьПанельКнопок(Новый Структура("Имя, УправляемоеПриложение", КнопкаИмя, Кэш.ПараметрыСистемы.Клиент.УправляемоеПриложение), Ложь);
		
КонецПроцедуры

// Процедура устанавливает значения фильтра по-умолчанию для текущего раздела	
Процедура ФильтрОчистить(Кэш) Экспорт
	ГлавноеОкно = Кэш.ГлавноеОкно;
	ОписанияТипов	= МодульОбъектаКлиент().ПолучитьЗначениеПараметраТекущегоСеанса("ТипыПолейФильтра");
	Если ОписанияТипов.Свойство("ФильтрНоменклатура1С") Тогда
		ГлавноеОкно.ФильтрНоменклатура1С = ОписанияТипов.ФильтрНоменклатура1С.ПривестиЗначение();
	Иначе	
		ГлавноеОкно.ФильтрНоменклатура1С = "";
	КонецЕсли;
	ГлавноеОкно.ФильтрНаименованиеНоменклатуры = "";
	ГлавноеОкно.ФильтрКодКонтрагента = "";
	ГлавноеОкно.ФильтрGTIN = "";
КонецПроцедуры

Процедура ФильтрУстановитьВидимость(ФормаФильтра) Экспорт
	ВыбранныйЭлемент = сбисЭлементФормы(ФормаФильтра,"НадписьКонтрагентПодключен");
	Если Не ВыбранныйЭлемент = Неопределено Тогда
		ВыбранныйЭлемент.Видимость = Ложь;
	КонецЕсли;
	ВыбранныйЭлемент = сбисЭлементФормы(ФормаФильтра,"НадписьОтветственный");
	Если Не ВыбранныйЭлемент = Неопределено Тогда
		ВыбранныйЭлемент.Видимость = Ложь;
	КонецЕсли;
	ВыбранныйЭлемент = сбисЭлементФормы(ФормаФильтра,"НадписьТипыДокументов");
	Если Не ВыбранныйЭлемент = Неопределено Тогда
		ВыбранныйЭлемент.Видимость = Ложь;
	КонецЕсли;
	ВыбранныйЭлемент = сбисЭлементФормы(ФормаФильтра,"НадписьМаска");
	Если Не ВыбранныйЭлемент = Неопределено Тогда
		ВыбранныйЭлемент.Видимость = Ложь;
	КонецЕсли;
	
	ВыбранныйЭлемент = сбисЭлементФормы(ФормаФильтра,"ФильтрКонтрагентПодключен");
	Если Не ВыбранныйЭлемент = Неопределено Тогда
		ВыбранныйЭлемент.Видимость = Ложь;
	КонецЕсли;
	ВыбранныйЭлемент = сбисЭлементФормы(ФормаФильтра,"ФильтрОтветственный");
	Если Не ВыбранныйЭлемент = Неопределено Тогда
		ВыбранныйЭлемент.Видимость = Ложь;
	КонецЕсли;
	ВыбранныйЭлемент = сбисЭлементФормы(ФормаФильтра,"ФильтрТипыДокументов");
	Если Не ВыбранныйЭлемент = Неопределено Тогда
		ВыбранныйЭлемент.Видимость = Ложь;
	КонецЕсли;
	ВыбранныйЭлемент = сбисЭлементФормы(ФормаФильтра,"ФильтрМаска");
	Если Не ВыбранныйЭлемент = Неопределено Тогда
		ВыбранныйЭлемент.Видимость = Ложь;
	КонецЕсли;
	
	ВыбранныйЭлемент = сбисЭлементФормы(ФормаФильтра,"НадписьКонтрагент");
	Если Не ВыбранныйЭлемент = Неопределено Тогда
		ВыбранныйЭлемент.Видимость = Ложь;
	КонецЕсли;
	ВыбранныйЭлемент = сбисЭлементФормы(ФормаФильтра,"НадписьОрганизация");
	Если Не ВыбранныйЭлемент = Неопределено Тогда
		ВыбранныйЭлемент.Видимость = Ложь;
	КонецЕсли;
	ВыбранныйЭлемент = сбисЭлементФормы(ФормаФильтра,"ФильтрКонтрагент");
	Если Не ВыбранныйЭлемент = Неопределено Тогда
		ВыбранныйЭлемент.Видимость = Ложь;
	КонецЕсли;
	ВыбранныйЭлемент = сбисЭлементФормы(ФормаФильтра,"ФильтрОрганизация");
	Если Не ВыбранныйЭлемент = Неопределено Тогда
		ВыбранныйЭлемент.Видимость = Ложь;
	КонецЕсли;
	ВыбранныйЭлемент = сбисЭлементФормы(ФормаФильтра,"ФильтрКонтрагентСФилиалами");
	Если Не ВыбранныйЭлемент = Неопределено Тогда
		ВыбранныйЭлемент.Видимость = Ложь;
	КонецЕсли;    
	ВыбранныйЭлемент = сбисЭлементФормы(ФормаФильтра,"ФильтрСостояние");
	Если Не ВыбранныйЭлемент = Неопределено Тогда
		ВыбранныйЭлемент.Видимость = Ложь;
	КонецЕсли;   
	ВыбранныйЭлемент = сбисЭлементФормы(ФормаФильтра,"ФильтрПериод");
	Если Не ВыбранныйЭлемент = Неопределено Тогда
		ВыбранныйЭлемент.Видимость = Ложь;
	КонецЕсли;  
	ВыбранныйЭлемент = сбисЭлементФормы(ФормаФильтра,"НадписьФильтрПериод");
	Если Не ВыбранныйЭлемент = Неопределено Тогда
		ВыбранныйЭлемент.Видимость = Ложь;
	КонецЕсли; 
	ВыбранныйЭлемент = сбисЭлементФормы(ФормаФильтра,"НадписьНоменклатураКонтрагента");
	Если Не ВыбранныйЭлемент = Неопределено Тогда
		ВыбранныйЭлемент.Видимость = Истина;
	КонецЕсли;    
	ВыбранныйЭлемент = сбисЭлементФормы(ФормаФильтра,"НадписьНоменклатура1С");
	Если Не ВыбранныйЭлемент = Неопределено Тогда
		ВыбранныйЭлемент.Видимость = Истина;
	КонецЕсли;   
	ВыбранныйЭлемент = сбисЭлементФормы(ФормаФильтра,"НадписьКодКонтрагента");
	Если Не ВыбранныйЭлемент = Неопределено Тогда
		ВыбранныйЭлемент.Видимость = Истина;
	КонецЕсли;  
	ВыбранныйЭлемент = сбисЭлементФормы(ФормаФильтра,"НадписьGTIN");
	Если Не ВыбранныйЭлемент = Неопределено Тогда
		ВыбранныйЭлемент.Видимость = Истина;
	КонецЕсли; 
	ВыбранныйЭлемент = сбисЭлементФормы(ФормаФильтра,"ФильтрНаименованиеНоменклатуры");
	Если Не ВыбранныйЭлемент = Неопределено Тогда
		ВыбранныйЭлемент.Видимость = Истина;
	КонецЕсли;    
	ВыбранныйЭлемент = сбисЭлементФормы(ФормаФильтра,"ФильтрНоменклатура1С");
	Если Не ВыбранныйЭлемент = Неопределено Тогда
		ВыбранныйЭлемент.Видимость = Истина;
	КонецЕсли;   
	ВыбранныйЭлемент = сбисЭлементФормы(ФормаФильтра,"ФильтрКодКонтрагента");
	Если Не ВыбранныйЭлемент = Неопределено Тогда
		ВыбранныйЭлемент.Видимость = Истина;
	КонецЕсли;  
	ВыбранныйЭлемент = сбисЭлементФормы(ФормаФильтра,"ФильтрGTIN");
	Если Не ВыбранныйЭлемент = Неопределено Тогда
		ВыбранныйЭлемент.Видимость = Истина;
	КонецЕсли; 
КонецПроцедуры
