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
// функция обновляет контент для раздела Отправленные	
	СтруктураДляОбновленияФормы = Кэш.Интеграция.ПолучитьСписокСобытий(Кэш, "Ответы контрагента");
	Кэш.ОбщиеФункции.ОбновитьПанельНавигации(Кэш);
	ГлавноеОкно = Кэш.ГлавноеОкно;
	Контент = сбисЭлементФормы(ГлавноеОкно, "Контент");
	Контент.ТекущаяСтраница = сбисПолучитьСтраницу(Контент, "РеестрСобытий");	
	Кэш.ТаблДок = сбисЭлементФормы(ГлавноеОкно,"Таблица_РеестрСобытий");
	Кэш.ГлавноеОкно.СписокДопОперацийРеестра.Очистить();
	Возврат СтруктураДляОбновленияФормы;
КонецФункции

// Функция делает подготовку к переходу	
&НаКлиенте
Функция ОбновитьКонтент_ПередВызовом(СтруктураРаздела, Кэш) Экспорт
	
	фрм = Кэш.ГлавноеОкно.СбисПолучитьФорму("Раздел_Отправленные_Отправленные");
	фрм.ОбновитьКонтент_ПередВызовом(СтруктураРаздела, Кэш);
	
КонецФункции

&НаКлиенте
Процедура НаСменуРаздела(Кэш) Экспорт
// Процедура обновляет панель массовых операций, панель фильтра, контекстное меню при смене раздела		
	фрм = Кэш.ГлавноеОкно.сбисНайтиФормуФункции("НаСменуРаздела","Раздел_Отправленные_Отправленные","", Кэш);
	фрм.НаСменуРаздела(Кэш);
КонецПроцедуры
&НаКлиенте
Процедура НастроитьКолонки(Кэш) Экспорт 	 	
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
// функция формирует структуру данных по пакету электронных документов, необходимую для его предварительного просмотра		
	Возврат Кэш.ОбщиеФункции.ПодготовитьСтруктуруДокументаСбис(СтрокаСпискаДокументов, Кэш);	
КонецФункции
&НаКлиенте
Процедура ФильтрОчистить(Кэш) Экспорт
// Процедура устанавливает значения фильтра по-умолчанию для текущего раздела	
	фрм = Кэш.ГлавноеОкно.сбисНайтиФормуФункции("ФильтрОчистить","Раздел_Отправленные_Отправленные","", Кэш);
	фрм.ФильтрОчистить(Кэш);
КонецПроцедуры