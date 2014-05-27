(function($) {

	$.fn.scrollPagination = function(options) {
		
		var settings = { 
			nop     : 10, // Количество запрашиваемых из БД записей
			offset  : 0, // Начальное смещение в количестве запрашиваемых данных
			error   : 'Записей больше нет!', // оповещение при отсутствии данных в БД
			delay   : 500, // Задержка перед загрузкой данных
			scroll  : true // Если true то записи будут подгружаться при прокрутке странице, иначе только при нажатии на кнопку 
		};
		
		// Включение опции для плагина
		if(options) {
			$.extend(settings, options);
		}
		
		return this.each(function() {		
			
			$this = $(this);
			$settings = settings;
			var offset = $settings.offset;
			var busy = false; // переменная для обозначения происходящего процесса
			
			// Текст кнопки, на основе параметров
			if($settings.scroll == true) $initmessage = 'Show more';
			else $initmessage = 'Click';
			
			$this.append('<div class="content"></div><div class="loading-bar">'+$initmessage+'</div>');
			
			// Функция AJAX запроса
			function getData() {
                var url_params = getSearchParameters();
				
				// Формируется POST запрос к ajax.php
				$.post('/events', {
						
					action  : 'scrollpagination',
				    limit   : $settings.nop,
                    //data    : url_params, //"max=" + url_params.max + "&min=" + url_params.min,
                    max     : url_params.max,
                    min     : url_params.min,
				    offset  : offset,
					    
				}, function(data) {
						
					// Информируем пользователя
					$this.find('.loading-bar').html($initmessage);
					
					// Если возвращенные данные пусты то сообщаем об этом	
					if(data == "") { 
						$this.find('.loading-bar').html($settings.error);	
					}
					else {
						
						// Смещение увеличивается
					    offset = offset+$settings.nop; 
						    
						// Добавление полученных данных в DIV content
					   	// $this.find('.content').append(data);
                        var dataItems = data;
                        console.log(dataItems);
                        //$.tmpl('#template-record').appendTo('.content');
                        $('#template-record').tmpl(dataItems).appendTo('#push-content');
						
						// Процесс завершен	
						busy = false;
					}	
						
				});
					
			}	
			
			getData(); // Запуск функции загрузки данных в первый раз
			
			// Если прокрутка включена
			if($settings.scroll == true) {
				// .. и пользователь прокручивает страницу
				$(window).scroll(function() {
					
					// Проверяем пользователя, находится ли он в нижней части страницы
					if($(window).scrollTop() + $(window).height() > $this.height() && !busy) {
						
						// Идет процесс
						busy = true;
						
						// Сообщить пользователю что идет загрузка данных
						$this.find('.loading-bar').html('Loading data...');
						
						// Запустить функцию для выборки данных с установленной задержкой
						// Это полезно, если у вас есть контент в футере
						setTimeout(function() {
							
							getData();
							
						}, $settings.delay);
							
					}	
				});
			}
			
			// кроме того конент может быть загружен нажатием на кнопку
			$this.find('.loading-bar').click(function() {
			
				if(busy == false) {
					busy = true;
					getData();
				}
			
			});
			
		});
	}

})(jQuery);
