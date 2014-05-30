$('#events').scrollPagination({
   nop     : 5,         // Количество запрашиваемых из БД записей
   offset  : 0,         // Начальное смещение в количестве запрашиваемых данных
   error   : 'Записей больше нет!', // оповещение при отсутствии данных в БД
   delay   : 500,       // Задержка перед загрузкой данных
   scroll  : true       // Если true то записи будут подгружаться при прокрутке странице
                        // иначе только при нажатии на кнопку
});

var start_date;
var end_date;

if (params.min && params.max) {
    var min = moment(params.min).format('MMMM D, YYYY');
    var max = moment(params.max).format('MMMM D, YYYY');

    start_date = moment(params.max);
    end_date = moment(params.min);

    $('#date-range span').html(min + ' - ' + max);
} else {
    start_date = moment('2000-01-01');
    end_date = moment();
}


$('#date-range').daterangepicker(
    {
      ranges: {
         'All': [moment('2000-01-01'), moment()],
         'Today': [moment(), moment()],
         'Yesterday': [moment().subtract('days', 1), moment().subtract('days', 1)],
         'Last 7 Days': [moment().subtract('days', 6), moment()],
         'Last 30 Days': [moment().subtract('days', 29), moment()],
         'This Month': [moment().startOf('month'), moment().endOf('month')],
         'Last Month': [moment().subtract('month', 1).startOf('month'), moment().subtract('month', 1).endOf('month')]
      },
      //timePicker: true,
      format: 'MMMM D, YYYY',
      startDate: start_date,
      endDate: end_date
    },
    function(start, end) {
        location.search = '?max=' + end.toISOString() + '&min=' + start.toISOString();
        /*
        $('#date-range span').html(start.format('MMMM D, YYYY') + ' - ' + end.format('MMMM D, YYYY'));
        window.history.pushState('', '', '/events?max=' + end.toISOString() + '&min=' + start.toISOString());
        $('#push-content').html('');
        setScroll();
        */
    }
);
