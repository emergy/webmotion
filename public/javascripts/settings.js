$.ajax('/get-user-list', {
    success: function(user_list) {
        $('#profile-page-tmpl').tmpl(user_list).appendTo('#settings-page');
    }
});
