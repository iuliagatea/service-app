// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require colorpicker
//= require_tree
//= require seems_rateable
//= require_directory ./rateable
//= require bootstrap-datepicker
//= require Chart.bundle
//= require chartkick
//= require cocoon

$(document).ready(function () {
  options = {
      trigger_event: "click",
      color: {
          r: 0,
          g: 0,
          b: 0
      },
      onChange: function(colorHSB) {
          // do stuff with color
          // console.log(colorHSB.toRGB());
          // console.log(colorHSB.toHex());
          if(colorHSB.toHex()!="000000")
          {
            $("#status_color").val('#'+colorHSB.toHex());
          }
      }
  }
  new ColorPicker($("#status_color"), options);
});
$(document).ready(function() { 
  $(".member").hide();
  $(".customer_name").hide();
  $("#user_email").bind("change",function() { 
      if ($(this).val() != undefined) { 
          $.ajax({ 
              url : "/get_name", 
              data: {'email': $(this).val()}, 
              dataType: "json", 
              type: "GET", 
              success : function(data) { 
                  $(".member").hide();
                  $(".customer_name").show();
                  $('#customer_name').text(data["first_name"] + " " + data["last_name"]);
                  $("#member_first_name").prop('required',false);
                  $("#member_last_name").prop('required',false);
                  // console.log(data);
              },
              error : function() {
                $(".member").show();
                $(".customer_name").hide();
                $('#customer_name').text("");
                $("#member_first_name").prop('required',true);
                $("#member_last_name").prop('required',true);
              }
          }) 
      } 
  })
})
