var hidealltodos = function(){
    $("#todo ul").each(function(){
        $(this).hide();
    });
};

var changebox = function(boxname){
    var boxid = $('#' + boxname);

    hidealltodos(); /* Hide all todos. */
    boxid.show(); /* then show it */

    $.getJSON('/by_focustype/' + boxname, function(data){
        boxid.html(data);
    });
};

var check_or_redirect = function(){
    var myFile = document.location.toString();

    myFile.search(/#(.+)/);

    if(RegExp.$1){
        var box = RegExp.$1;

        if(['inbox', 'today', 'next', 'someday', 'projects',
            'logbook', 'trash'].indexOf(box) > 0){
                changebox(box);
                return;
        }
    }
    window.location.replace("#inbox");
    changebox('inbox');
};

$(document).ready(function () {
    $("#sidebar a").each(function(){
        $(this).bind('click', function(){
            this.id.search(/expand_(.+)$/);
            changebox(RegExp.$1);
        });
    });

    check_or_redirect();
});
