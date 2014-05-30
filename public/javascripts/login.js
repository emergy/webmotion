var current_url = window.location.pathname;

$('#buttonLogin').click(function() {
    $('#buttonLogin').attr("disabled", "disabled");

    var login = $('#inputLogin').val();
    var password = hex_md5($('#inputPassword').val());

    $.ajax({
        type: "POST",
        url: "/login",
        data: "login=" + login + "&password=" + password,
        success: function(msg) {
            $('#buttonLogin').removeAttr("disabled");
            console.log(msg);

            if (msg == '0') {
                $('#login-error').show();
            } else {
                $('#login-error').hide();
                window.location.replace('/');
            }
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {
            console.log("XMLHttpRequest: " + XMLHttpRequest);
            console.log("textStatus: " + textStatus);
            console.log("errorThrown: " + errorThrown);
        }
    });
});

$(".form-control").keypress(function(e) {
    if (e.which == 13) {
        $('#buttonLogin').click();
    }
});
