
// функции для совместимости кода 
&НаКлиенте
Функция СбисПолучитьФорму(ИмяФормы, Параметры = Неопределено, Владелец = Неопределено )  
	
	Если ТипЗнч(ЭтаФорма) = Тип("УправляемаяФорма") Тогда
		Попытка
			ЭтотОбъект="";
		Исключение 
			//
		КонецПопытки;
		Возврат ПолучитьФорму("ВнешняяОбработка.СБИС.Форма."+ИмяФормы, Параметры, Владелец);
	КонецЕсли;
	Возврат ЭтотОбъект.ПолучитьФорму(ИмяФормы, Владелец, Параметры);  
	
КонецФункции

&НаКлиенте
Функция ОбновитьКонтент(Кэш) Экспорт  
	
	// функция обновляет контент для подразделов раздела Отправленные	
	МестныйКэш = Кэш;
	СтруктураДляОбновленияФормы = Кэш.Интеграция.сбисПолучитьСписокДокументов(Кэш);
	Кэш.ОбщиеФункции.ОбновитьПанельНавигации(Кэш);
	ГлавноеОкно = Кэш.ГлавноеОкно;
	Контент = МодульОбъектаКлиент().ПолучитьЭлементФормыОбработки(ГлавноеОкно, "Контент");
	Контент.ТекущаяСтраница = сбисПолучитьСтраницу(Контент, "РеестрДокументов");	
	Кэш.ТаблДок = МодульОбъектаКлиент().ПолучитьЭлементФормыОбработки(ГлавноеОкно, "Таблица_РеестрДокументов");
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
Функция ПараметраФильтраДляСобытий() Экспорт
	
	ДопПараметрыФильтра = Новый Структура("Тип", МодульОбъектаКлиент().ГлавноеОкно.Кэш.Текущий.ТипДок);
	Результат			= Новый Структура("ДопФильтры, Реестр", ДопПараметрыФильтра, "СписокДокументов");
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура НастроитьКолонки(Кэш) Экспорт 
	
	Кэш.ОбщиеФункции.НастроитьКолонки(Неопределено, Кэш); // alo СтатусГос  	
	МодульОбъектаКлиент().ПолучитьЭлементФормыОбработки(Кэш.ГлавноеОкно, "Таблица_РеестрДокументов.Склад").ТекстШапки = "Подразделение";
	МодульОбъектаКлиент().ПолучитьЭлементФормыОбработки(Кэш.ГлавноеОкно, "Таблица_РеестрДокументов.Склад").Ширина = МодульОбъектаКлиент().ПолучитьЭлементФормыОбработки(Кэш.ГлавноеОкно, "Таблица_РеестрДокументов").Ширина / 150;
	
КонецПроцедуры

&НаКлиенте
Процедура НавигацияУстановитьПанель(Кэш) Экспорт  
	
	// Процедура устанавливает панель навигации на 1ую страницу	
	ГлавноеОкно = Кэш.ГлавноеОкно;
	МодульОбъектаКлиент().ПолучитьЭлементФормыОбработки(ГлавноеОкно, "ПанельНавигации").Видимость = Истина;
	МодульОбъектаКлиент().ПолучитьЭлементФормыОбработки(ГлавноеОкно, "ЗаписейНаСтранице1С").Видимость = Ложь;
	МодульОбъектаКлиент().ПолучитьЭлементФормыОбработки(ГлавноеОкно, "ЗаписейНаСтранице").Видимость = Истина;

КонецПроцедуры  

&НаКлиенте
Процедура УстановитьВидимостьЭлементовВформеПросмотра(ФормаПросмотра, СоставПакета, КэшПарам) Экспорт
	ЕстьВходящиеВложения = Ложь;
	Если СоставПакета.Свойство("Вложение") Тогда
		Для Каждого Вложение Из СоставПакета.Вложение Цикл
			Если Вложение.Направление = "Входящий" Тогда
				ЕстьВходящиеВложения = Истина;
			КонецЕсли;                             
		КонецЦикла;
	КонецЕсли;
	Если		МестныйКэш = Неопределено
		И Не	ЭтаФорма.ВладелецФормы = Неопределено Тогда
		МестныйКэш = ЭтаФорма.ВладелецФормы.Кэш;
	КонецЕсли;  
	
	ТабличнаяЧасть = МодульОбъектаКлиент().ПолучитьЭлементФормыОбработки(ФормаПросмотра, "ТабличнаяЧасть"); 
	ТаблицаДокументов = МодульОбъектаКлиент().ПолучитьЭлементФормыОбработки(ФормаПросмотра, "ТаблицаДокументов");
	
	МодульОбъектаКлиент().ПолучитьЭлементФормыОбработки(ФормаПросмотра, "Загрузка").Видимость = Истина;
	МодульОбъектаКлиент().ПолучитьЭлементФормыОбработки(ТаблицаДокументов, "Статус").Видимость = Ложь;
	МодульОбъектаКлиент().ПолучитьЭлементФормыОбработки(ТабличнаяЧасть, "Идентификатор").Видимость = Ложь;

	МодульОбъектаКлиент().ПолучитьЭлементФормыОбработки(ФормаПросмотра, "ЗагрузитьОтвет").Видимость = Ложь;
	МодульОбъектаКлиент().ПолучитьЭлементФормыОбработки(ФормаПросмотра, "ГруппаАбонЯщик").Видимость = Ложь;
	
	ФормаПросмотра.ЗаголовокПакета = ФормаПросмотра.СоставПакета.Название + " ";
	МодульОбъектаКлиент().ПолучитьЭлементФормыОбработки(ФормаПросмотра, "ТулБар").ТекущаяСтраница = сбисПолучитьСтраницу(ФормаПросмотра.ЭлементыФормы.ТулБар,"Отправленные");
	МодульОбъектаКлиент().ПолучитьЭлементФормыОбработки(ФормаПросмотра, "ПакетКомментарий").Доступность = Ложь;
	МодульОбъектаКлиент().ПолучитьЭлементФормыОбработки(ФормаПросмотра, "Прохождение").Видимость = Истина;
	МодульОбъектаКлиент().ПолучитьЭлементФормыОбработки(ТаблицаДокументов, "Удалить").Видимость = Ложь;
	МодульОбъектаКлиент().ПолучитьЭлементФормыОбработки(ТаблицаДокументов, "Шифрование").Видимость = Ложь;
	МодульОбъектаКлиент().ПолучитьЭлементФормыОбработки(ТаблицаДокументов, "Отмечен").Видимость = Истина;   
	
КонецПроцедуры   

&НаКлиенте
Процедура ФильтрУстановитьВидимость(ФормаФильтра) Экспорт
	
	ВыбранныйЭлемент = МодульОбъектаКлиент().ПолучитьЭлементФормыОбработки(ФормаФильтра, "НадписьКонтрагентПодключен");
	Если Не ВыбранныйЭлемент = Неопределено Тогда
		ВыбранныйЭлемент.Видимость = Ложь;
	КонецЕсли;
	ВыбранныйЭлемент = МодульОбъектаКлиент().ПолучитьЭлементФормыОбработки(ФормаФильтра, "НадписьОтветственный");
	Если Не ВыбранныйЭлемент = Неопределено Тогда
		ВыбранныйЭлемент.Видимость = Ложь;
	КонецЕсли;
	ВыбранныйЭлемент = МодульОбъектаКлиент().ПолучитьЭлементФормыОбработки(ФормаФильтра, "НадписьТипыДокументов");
	Если Не ВыбранныйЭлемент = Неопределено Тогда
		ВыбранныйЭлемент.Видимость = Ложь;
	КонецЕсли;
	ВыбранныйЭлемент = МодульОбъектаКлиент().ПолучитьЭлементФормыОбработки(ФормаФильтра, "НадписьМаска");
	Если Не ВыбранныйЭлемент = Неопределено Тогда
		ВыбранныйЭлемент.Видимость = Истина;
	КонецЕсли;
	
	ВыбранныйЭлемент = МодульОбъектаКлиент().ПолучитьЭлементФормыОбработки(ФормаФильтра, "ФильтрКонтрагентПодключен");
	Если Не ВыбранныйЭлемент = Неопределено Тогда
		ВыбранныйЭлемент.Видимость = Ложь;
	КонецЕсли;
	ВыбранныйЭлемент = МодульОбъектаКлиент().ПолучитьЭлементФормыОбработки(ФормаФильтра, "ФильтрОтветственный");
	Если Не ВыбранныйЭлемент = Неопределено Тогда
		ВыбранныйЭлемент.Видимость = Ложь;
	КонецЕсли;
	ВыбранныйЭлемент = МодульОбъектаКлиент().ПолучитьЭлементФормыОбработки(ФормаФильтра, "ФильтрТипыДокументов");
	Если Не ВыбранныйЭлемент = Неопределено Тогда
		ВыбранныйЭлемент.Видимость = Ложь;
	КонецЕсли;
	ВыбранныйЭлемент = МодульОбъектаКлиент().ПолучитьЭлементФормыОбработки(ФормаФильтра, "ФильтрМаска");
	Если Не ВыбранныйЭлемент = Неопределено Тогда
		ВыбранныйЭлемент.Видимость = Истина;
	КонецЕсли;
	ВыбранныйЭлемент = МодульОбъектаКлиент().ПолучитьЭлементФормыОбработки(ФормаФильтра, "ФильтрКонтрагентСФилиалами");
	Если Не ВыбранныйЭлемент = Неопределено Тогда
		ВыбранныйЭлемент.Видимость = Истина;
	КонецЕсли;
	ВыбранныйЭлемент = МодульОбъектаКлиент().ПолучитьЭлементФормыОбработки(ФормаФильтра, "НадписьНоменклатураКонтрагента");
	Если Не ВыбранныйЭлемент = Неопределено Тогда
		ВыбранныйЭлемент.Видимость = Ложь;
	КонецЕсли;    
	ВыбранныйЭлемент = МодульОбъектаКлиент().ПолучитьЭлементФормыОбработки(ФормаФильтра, "НадписьНоменклатура1С");
	Если Не ВыбранныйЭлемент = Неопределено Тогда
		ВыбранныйЭлемент.Видимость = Ложь;
	КонецЕсли;   
	ВыбранныйЭлемент = МодульОбъектаКлиент().ПолучитьЭлементФормыОбработки(ФормаФильтра, "НадписьКодКонтрагента");
	Если Не ВыбранныйЭлемент = Неопределено Тогда
		ВыбранныйЭлемент.Видимость = Ложь;
	КонецЕсли;  
	ВыбранныйЭлемент = МодульОбъектаКлиент().ПолучитьЭлементФормыОбработки(ФормаФильтра, "НадписьGTIN");
	Если Не ВыбранныйЭлемент = Неопределено Тогда
		ВыбранныйЭлемент.Видимость = Ложь;
	КонецЕсли; 
	ВыбранныйЭлемент = МодульОбъектаКлиент().ПолучитьЭлементФормыОбработки(ФормаФильтра, "ФильтрНаименованиеНоменклатуры");
	Если Не ВыбранныйЭлемент = Неопределено Тогда
		ВыбранныйЭлемент.Видимость = Ложь;
	КонецЕсли;    
	ВыбранныйЭлемент = МодульОбъектаКлиент().ПолучитьЭлементФормыОбработки(ФормаФильтра, "ФильтрНоменклатура1С");
	Если Не ВыбранныйЭлемент = Неопределено Тогда
		ВыбранныйЭлемент.Видимость = Ложь;
	КонецЕсли;   
	ВыбранныйЭлемент = МодульОбъектаКлиент().ПолучитьЭлементФормыОбработки(ФормаФильтра, "ФильтрКодКонтрагента");
	Если Не ВыбранныйЭлемент = Неопределено Тогда
		ВыбранныйЭлемент.Видимость = Ложь;
	КонецЕсли;  
	ВыбранныйЭлемент = МодульОбъектаКлиент().ПолучитьЭлементФормыОбработки(ФормаФильтра, "ФильтрGTIN");
	Если Не ВыбранныйЭлемент = Неопределено Тогда
		ВыбранныйЭлемент.Видимость = Ложь;
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура СбисОформлениеДопПолейРеестра(Кэш) Экспорт
	
	ГлавноеОкно = Кэш.ГлавноеОкно;
	МодульОбъектаКлиент().ПолучитьЭлементФормыОбработки(ГлавноеОкно, "Таблица_РеестрДокументов.Срок").Видимость = Ложь; 
	МодульОбъектаКлиент().ПолучитьЭлементФормыОбработки(ГлавноеОкно, "Таблица_РеестрДокументов.Лицо2").Видимость = Ложь;
	
КонецПроцедуры   

