// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree .
//= require bootstrap


field = "";
function set_field(f)
{
    field = f;
}
function set_value(id, name) {
    $('#lab'+(parseInt(field)+1)).text("File Selected: "+name);
    $('#inputs_'+(parseInt(field)+1).to_s).val(id);
}
function set_display(e, div) {
    if (e.checked)
    {
        document.getElementById(div).style.display = 'block';
        document.getElementById('textButton').style.display = 'none';
    }
    else{
        document.getElementById(div).style.display = 'none';
        document.getElementById('textButton').style.display = 'block';
    }

}
