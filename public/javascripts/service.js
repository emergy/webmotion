$('#start-button').click(function() {
    $('#start-button').attr("disabled", "disabled");
    $.ajax('/on', {
        success: function(msg) {
            update_status();
        }
    });
});

$('#stop-button').click(function() {
    $('#stop-button').attr("disabled", "disabled");
    $.ajax('/off', {
        success: function(msg) {
            update_status();
        }
    });
});

function update_status() {
    $.ajax('/status', {
        success: function(msg) {
            console.log(msg);
            if (msg == '1') {
                $('#stop-button').removeAttr("disabled");
                $('#start-button').attr("disabled", "disabled");
            } else {
                $('#start-button').removeAttr("disabled");
                $('#stop-button').attr("disabled", "disabled");
            }
        }
    });
}

update_status();
