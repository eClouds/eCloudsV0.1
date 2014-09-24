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
    $('#inputs_'+(parseInt(field))).val(id);
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

function set_display_conditional(input_id_pre,conditionalJson){
    var $currentValue = $("#input-"+input_id_pre).val();
    var $conditionalsArray = conditionalJson;
    console.log($currentValue);

    for(i=0; i<$conditionalsArray.length; i++){
        var $input_id_post = $conditionalsArray[i].input_id_post;
        var $value_to_compare =   $conditionalsArray[i].value;
        if($currentValue == $value_to_compare){
            $('#'+$input_id_post).show();
            $('#'+$input_id_post).css("width:100");
        }else{
            $('#'+$input_id_post).hide();
        }
    }


}
