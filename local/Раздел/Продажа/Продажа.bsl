
&НаКлиенте
Процедура НастроитьКолонки(Кэш) Экспорт
	Если МестныйКэш = Неопределено Тогда
		МестныйКэш = Кэш;
	КонецЕсли;
	Кэш.ГлавноеОкно.СбисПолучитьЭлементФормы(Кэш.ГлавноеОкно, Кэш.ГлавноеОкно.СбисПолноеИмяКолонки("Таблица_РеестрДокументов",	"СтатусВГосСистеме")).Видимость = Кэш.Парам.СтатусыВГосСистеме;	
	Кэш.ГлавноеОкно.СбисПолучитьЭлементФормы(Кэш.ГлавноеОкно, Кэш.ГлавноеОкно.СбисПолноеИмяКолонки("Таблица_РеестрДокументов",	"Ответственный")).Видимость = Ложь;	 	
	Кэш.ГлавноеОкно.СбисПолучитьЭлементФормы(Кэш.ГлавноеОкно, Кэш.ГлавноеОкно.СбисПолноеИмяКолонки("Таблица_РеестрСобытий",	"Комментарий")).Видимость = Истина;
	Кэш.ГлавноеОкно.СбисПолучитьЭлементФормы(Кэш.ГлавноеОкно, Кэш.ГлавноеОкно.СбисПолноеИмяКолонки("Таблица_РеестрСобытий",	"Ответственный")).Видимость = Истина;
	Кэш.ГлавноеОкно.СбисПолучитьЭлементФормы(Кэш.ГлавноеОкно, Кэш.ГлавноеОкно.СбисПолноеИмяКолонки("Таблица_РеестрСобытий",	"Вложения")).Видимость = Истина;	
	
	МассивРеквизитов = Новый Массив;
	МассивРеквизитов.Добавить("Заказчик");
	МассивРеквизитов.Добавить("Перевозчик");
	
	Кэш.ГлавноеОкно.НастроитьКолонкиФормы(Новый Структура("ИмяТаблицы, СтруктураПолей", "Таблица_РеестрСобытий", Новый Структура("КолонкиУдалить", МассивРеквизитов)));
КонецПроцедуры

