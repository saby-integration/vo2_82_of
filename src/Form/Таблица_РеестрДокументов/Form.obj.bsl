Процедура ТаблДокПриВыводеСтроки(Кэш, Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт
// Оформление строки таблицы документов	
	Если ДанныеСтроки.Статус <> -1 Тогда
		ОформлениеСтроки.Ячейки.Статус.ОтображатьКартинку = Истина;
		ОформлениеСтроки.Ячейки.Статус.ИндексКартинки = ДанныеСтроки.Статус;
	КонецЕсли;
	ОформлениеСтроки.Ячейки.Статус.ОтображатьТекст = Ложь;
	Если Элемент.Колонки.Найти("Документ1С")<>Неопределено Тогда
		Если ЗначениеЗаполнено(ДанныеСтроки.Документ1С) и НЕ ДанныеСтроки.Документ1С.Пустая() Тогда
			Если Элемент.Колонки.Найти("Проведен")<>Неопределено тогда
				ОформлениеСтроки.Ячейки.Проведен.ОтображатьКартинку = Истина;
				ОформлениеСтроки.Ячейки.Проведен.ИндексКартинки = ДанныеСтроки.Проведен;
			КонецЕсли;
			Попытка
				ДельтаСтроки = Число(ДанныеСтроки.Сумма) - Число(ДанныеСтроки.Документ1С.СуммаДокумента);
				ДельтаСтроки = ?(ДельтаСтроки<0,-ДельтаСтроки,ДельтаСтроки);
				Если ДельтаСтроки>Кэш.Парам.СопоставлениеПоСумме Тогда
					ОформлениеСтроки.Ячейки.Сумма.ЦветФона = Кэш.Цвет.ФонОшибки;	
				КонецЕсли;
			Исключение
			КонецПопытки;
		КонецЕсли;
	КонецЕсли;
	Если Элемент.Колонки.Найти("Документы1С")<>Неопределено Тогда
		Если ЗначениеЗаполнено(ДанныеСтроки.Документы1С) и ДанныеСтроки.Документы1С.Количество()>0 Тогда
			Если Элемент.Колонки.Найти("Проведен")<>Неопределено тогда
				ОформлениеСтроки.Ячейки.Проведен.ОтображатьКартинку = Истина;
				ОформлениеСтроки.Ячейки.Проведен.ИндексКартинки = ДанныеСтроки.Проведен;
			КонецЕсли;
			Попытка
				ДельтаСтроки = Число(ДанныеСтроки.Сумма) - Число(ДанныеСтроки.Документы1С[0].Значение.СуммаДокумента);
				ДельтаСтроки = ?(ДельтаСтроки<0,-ДельтаСтроки,ДельтаСтроки);
				Если ДельтаСтроки>Кэш.Парам.СопоставлениеПоСумме Тогда
					ОформлениеСтроки.Ячейки.Сумма.ЦветФона = Кэш.Цвет.ФонОшибки;	
				КонецЕсли;
			Исключение
			КонецПопытки;
		КонецЕсли;
	КонецЕсли;
	Если Элемент.Колонки.Найти("Проведен")<>Неопределено тогда
		ОформлениеСтроки.Ячейки.Проведен.ОтображатьТекст = Ложь;
	КонецЕсли;
	
	Если Элемент.Колонки.Найти("Расхождение")<>Неопределено Тогда
		ОформлениеСтроки.Ячейки.Расхождение.ОтображатьТекст = Ложь;
		ОформлениеСтроки.Ячейки.Расхождение.ОтображатьКартинку = Истина;
		Если ДанныеСтроки.Расхождение Тогда
			ОформлениеСтроки.Ячейки.Расхождение.ИндексКартинки = 0;
		КонецЕсли;
    КонецЕсли;

КонецПроцедуры