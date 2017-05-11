﻿#Область ОсновнаяЧастьМодуля
&НаСервере
Процедура Расш_ДублиМарок_ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ИспользоватьПодключаемоеОборудование = ЗначениеНастроекВызовСервера.ИспользоватьПодключаемоеОборудование();

КонецПроцедуры

&НаКлиенте
Процедура Расш_ДублиМарок_ВнешнееСобытие(Источник, Событие, Данные)
	
	Если ВводДоступен() Тогда
		ПодключаемоеОборудованиеРТКлиент.ВнешнееСобытиеОборудования(ЭтотОбъект, Источник, Событие, Данные);
	КонецЕсли;
	
	ПроверкаДубля=Расш_ПроверкаДубляМарки(Данные,ЭтотОбъект.ВладелецФормы.Объект.Ссылка,ЭтотОбъект.ВладелецФормы.Объект.ВидОперации);
	Марки = ПрочитатьФайл();
	Марка = АнализМарок(Марки,Данные);
	
	Если Марка <> Неопределено Тогда
		Если ПроверкаДубля<>"" Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтрШаблон(НСтр("ru = 'Марка уже использовалась в документах %1'"), ПроверкаДубля));
			УстановитьВыполнениеОбработчиковСобытия(ЛОЖЬ);
			Возврат;
		КонецЕсли;
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СтрШаблон(НСтр("ru = 'Данная марка %1 не является Акцизной Маркой принадлежащей нашей компании! Обратитесь к системному Администратору'"), Марка));
		УстановитьВыполнениеОбработчиковСобытия(ЛОЖЬ);
		Возврат;
	КонецЕсли;	
КонецПроцедуры
#КонецОбласти

#Область ПроверкаДублейМарок
&НаСервере
Функция Расш_ПроверкаДубляМарки(ШК,Ссылка,ВидОперации)	
	Если ВидОперации = Перечисления.ВидыОперацийЧекККМ.Возврат Тогда
		Возврат "";
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЧекККМАкцизныеМарки.КодАкцизнойМарки,
		|	СУММА(1) КАК колво,
		|	ЧекККМАкцизныеМарки.Ссылка.Номер КАК Номер,
		|	ЧекККМАкцизныеМарки.Ссылка.Дата КАК Дата,
		|	""Продажа"" КАК ВидОперации
		|ИЗ
		|	Документ.ЧекККМ.АкцизныеМарки КАК ЧекККМАкцизныеМарки
		|ГДЕ
		|	ЧекККМАкцизныеМарки.Ссылка.Проведен
		|	И ЧекККМАкцизныеМарки.КодАкцизнойМарки = &КодМарки
		|	И ЧекККМАкцизныеМарки.Ссылка.ВидОперации = &Продажа
		|	И ЧекККМАкцизныеМарки.Ссылка <> &Ссылка
		|
		|СГРУППИРОВАТЬ ПО
		|	ЧекККМАкцизныеМарки.КодАкцизнойМарки,
		|	ЧекККМАкцизныеМарки.Ссылка.Номер,
		|	ЧекККМАкцизныеМарки.Ссылка.Дата
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ЧекККМАкцизныеМарки.КодАкцизнойМарки,
		|	СУММА(-1),
		|	ЧекККМАкцизныеМарки.Ссылка.Номер,
		|	ЧекККМАкцизныеМарки.Ссылка.Дата,
		|	""Возврат""
		|ИЗ
		|	Документ.ЧекККМ.АкцизныеМарки КАК ЧекККМАкцизныеМарки
		|ГДЕ
		|	ЧекККМАкцизныеМарки.Ссылка.Проведен
		|	И ЧекККМАкцизныеМарки.КодАкцизнойМарки = &КодМарки
		|	И ЧекККМАкцизныеМарки.Ссылка.ВидОперации = &Возврат
		|	И ЧекККМАкцизныеМарки.Ссылка <> &Ссылка
		|
		|СГРУППИРОВАТЬ ПО
		|	ЧекККМАкцизныеМарки.КодАкцизнойМарки,
		|	ЧекККМАкцизныеМарки.Ссылка.Номер,
		|	ЧекККМАкцизныеМарки.Ссылка.Дата
		|ИТОГИ ПО
		|	ОБЩИЕ";
	
	Запрос.УстановитьПараметр("Возврат", Перечисления.ВидыОперацийЧекККМ.Возврат);
	Запрос.УстановитьПараметр("Продажа", Перечисления.ВидыОперацийЧекККМ.Продажа);
	Запрос.УстановитьПараметр("КодМарки", ШК);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Стр="";
	Первая=ИСТИНА;
	Дубли=ЛОЖЬ;
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Если Первая Тогда
			Если ВыборкаДетальныеЗаписи.Колво > 0 Тогда
		    	Дубли=Истина;
			КонецЕсли;
			Первая=Ложь;
		Иначе
			Если Дубли Тогда
				Стр=Стр+ВыборкаДетальныеЗаписи.ВидОперации+" "+ВыборкаДетальныеЗаписи.Номер+" "+ВыборкаДетальныеЗаписи.Дата+Символы.ПС;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	

	Возврат Стр;
	
КонецФункции
#КонецОбласти

#Область ПроверкаНашаЛиМарка
&НаКлиенте
Функция ПрочитатьФайл()
	ФайлНаДиске = Новый Файл("D:\marks.txt");
	
	Если ФайлНаДиске.Существует() Тогда
		Файл = Новый ЧтениеТекста("D:\marks.txt");
		ДанныеЗагрузки = Новый Массив;
		стр = 0;
		Строка = Файл.ПрочитатьСтроку();
		
		Пока Строка <> Неопределено Цикл
			ДанныеЗагрузки.Добавить(Строка);
			Строка = Файл.ПрочитатьСтроку();     		
		КонецЦикла;
		
		Файл.Закрыть();
	Иначе
		Сообщить("Файл марок не найден");
	КонецЕсли;
	
	Возврат ДанныеЗагрузки;
КонецФункции

&НаСервере
Функция АнализМарок(ДанныеЗагрузки, Данные)
	i = ДанныеЗагрузки.Найти(Данные);
	
	Если i <> Неопределено Тогда
	    Сообщить("Значение найдено " + ДанныеЗагрузки[i]);
		Возврат ДанныеЗагрузки[i];
	КонецЕсли;
	
КонецФункции

#КонецОбласти
