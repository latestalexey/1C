﻿#Область ПроверкаНашаЛиМарка

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
		Сообщить("Файл не найден");
	КонецЕсли;
	Возврат ДанныеЗагрузки;
	
	//сообщить("Ищем " + Данные + " в массиве");
	//Ответ = АнализМарок(ДанныеЗагрузки, Данные);
	//Сообщить("Нашли " + Ответ);
	//Возврат Ответ;
	
КонецФункции

&НаСервере
Функция АнализМарок(ДанныеЗагрузки, Данные)
	i = ДанныеЗагрузки.Найти(Данные);
	Если i <> Неопределено Тогда
	    Сообщить("Значение найдено " + ДанныеЗагрузки[i]);
		Возврат ДанныеЗагрузки[i];
	КонецЕсли;
КонецФункции


&НаКлиенте
Процедура Команда1(Команда)
	Данные = "!root";
	Марки = ПрочитатьФайл();
	Марка = АнализМарок(Марки,Данные);
	
	Если Марка <> Неопределено Тогда
		Сообщить("Все ок " + Марка);
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СтрШаблон(НСтр("ru = 'Данная марка %1 не является Акцизной Маркой принадлежащей нашей компании! Обратитесь к системному Администратору'"), Марка));
		Возврат;
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Область Debug

//Строка = Файл.ПрочитатьСтроку();

//Если Строка <> Неопределено Тогда
//     мСтрокФайла.Добавить(Строка);
//КонецЕсли;

////циклом выбираем значения строк из файла
//Пока Строка <> Неопределено Цикл
//	//в цикле повторяем читать файл
//     Строка = Файл.ПрочитатьСтроку();
//     Если Строка <> Неопределено Тогда
//          мСтрокФайла.Добавить(Строка);
//     КонецЕсли;
//КонецЦикла; 
////Закрываем файл 
//&НаКлиенте
//Процедура ПоискМарокВМассиве(Массив)
//ДанныеДляАнализа = Массив;
//КонецПроцедуры



//&НаКлиенте
//Процедура ПрочитатьФайл()
//	ФайлНаДиске = Новый Файл("D:\marks.txt");
//	Если ФайлНаДиске.Существует() Тогда
//		Файл = Новый ЧтениеТекста("D:\marks.txt");
//		//ДанныеЗагрузки = Новый Структура;
//		ДанныеЗагрузки = Новый Массив;
//		стр = 0;
//		Строка = Файл.ПрочитатьСтроку();
//		Пока Строка <> Неопределено Цикл
//			ДанныеЗагрузки.Добавить(Строка);
//			//стр = стр + 1;
//			//ДанныеЗагрузки.Вставить("НомерСтроки",стр);
//			//ДанныеЗагрузки.Вставить("КодМарки",Строка);
//			//	ЗагрузитьСтрокуФайла(ДанныеЗагрузки);
//			Строка = Файл.ПрочитатьСтроку();     		
//		КонецЦикла;
//		Файл.Закрыть();
//	Иначе
//		Сообщить("Файл не найден");
//	КонецЕсли;
//	ЗагрузитьСтрокуФайла(ДанныеЗагрузки);
//КонецПроцедуры

//&НаСервере
//Процедура ЗагрузитьСтрокуФайла(ДанныеЗагрузки)
//	тест =ДанныеЗагрузки;
//КонецПроцедуры

//&НаКлиенте
//Процедура Команда1(Команда)
//	ПрочитатьФайл();
//КонецПроцедуры



#КонецОбласти

