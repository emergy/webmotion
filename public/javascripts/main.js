$(document).ready(function() {
    var current_url = window.location.pathname;

    $('.menu-item').each(function( index ) {
        if ($(this).attr('href') == current_url) {
            //$(this).addClass('active');
            $(this).attr("class", "active");
        }
    });

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
});

function getSearchParameters() {
    var prmstr = window.location.search.substr(1);
    return prmstr != null && prmstr != "" ? transformToAssocArray(prmstr) : {};
}

function transformToAssocArray(prmstr) {
    var params = {};
    var prmarr = prmstr.split("&");
    for (var i = 0; i < prmarr.length; i++) {
        var tmparr = prmarr[i].split("=");
        params[tmparr[0]] = tmparr[1];
    }
    return params;
}

var params = getSearchParameters();
