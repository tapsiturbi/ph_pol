
var CKEDITOR_TOOLBAR = [
  { name: 'document', groups: [ 'mode', 'document', 'doctools' ], items: [ 'Source', '-', 'Preview'] },
  { name: 'clipboard', groups: [ 'clipboard', 'undo' ], items: ['PasteText', 'PasteFromWord'] },
  { name: 'basicstyles', groups: [ 'basicstyles', 'cleanup' ], items: [ 'Bold', 'Italic', 'Underline', 'Strike', '-', 'RemoveFormat' ] },
  { name: 'colors', items: [ 'TextColor', 'BGColor' ] },
];

function auto_ckedify() {
  $('textarea.ph_ckeditor').each(function() {
    CKEDITOR.replace(this.id, { toolbar: CKEDITOR_TOOLBAR });
  });
}

function cmt_show_and_ckedify(comment_id, focus) {
  $('#new_cmt_' + comment_id).show().find('textarea').addClass('ph_ckeditor');
  if (focus) {
    CKEDITOR.replace('txt_comment_' + comment_id, {
      toolbar: CKEDITOR_TOOLBAR,
      on: {
        'instanceReady': function(evt) {
          CKEDITOR.instances['txt_comment_' + comment_id].focus();
        }
      }
    });
  } else {
    CKEDITOR.replace('txt_comment_' + comment_id, { toolbar: CKEDITOR_TOOLBAR });
  }
}

$(document).ready(auto_ckedify);
$(document).on('page:load', auto_ckedify);

// Adds onkeyup event to textbox that executes a function after a certain number 
// of seconds
function bind_on_keyup(elem, func_to_call) {
  var typingTimer;                //timer identifier
  var doneTypingInterval = 1000;  //time in ms, 1 second for example

  //on keyup, start the countdown
  $(elem).keyup(function(){
      clearTimeout(typingTimer);
      if ($(elem).val) {
          typingTimer = setTimeout(function () {
            func_to_call(elem);
          }, doneTypingInterval);
      }
  });
}

// Converts all the inputs in the elem_str scope to Jquery UI buttons
function buttonify_checkbox(elem_str, onclick_func) {
  $(elem_str).each( function(i,el) {
    $(el).button({ icons: { primary: "" } }).change(function(evt) {
      $(evt.target).button("option", { icons: { primary: ($(evt.target).prop('checked') ? "ui-icon-check-sel" : "") } });

      if ( onclick_func )
        onclick_func();

      return false;
    });
  });
}

// Attaches onkeyup event which hides all checkboxes based on typed keywords.
// Note: expects the checkbox to have an 'alt' attribute, containing the text on the label
function filter_onkeypress(txt_str, checkbox_str) {
  $(txt_str).keypress(function(evt){
    if ( evt.which == 0 && evt.which != $.ui.keyCode.ENTER )
      return;

    clearTimeout($.data(this, 'timer'));

    var timer = setTimeout(function() {
      $(checkbox_str).each(function(i,el) { $(el).show().next('label').show(); });

      var value = $(evt.target).val();
      if (value) {
        $(checkbox_str).not(":checked").not("[alt*='" + value + "']").each(function(i,el) {
          $(el).hide().next('label').hide();
        });
      }

      $(evt.target).removeClass('loading');
    }, 500);
    $(this).data('timer', timer).addClass('loading');
  });
}

function _filter_onkeypress_helper(text_str, checkbox_str) {
  
}

// Checks/unchecks all checkboxes under selector_str
function checkall(checked, selector_str) {
  $(selector_str).each(function(){ $(this).prop('checked', checked); });
}

// Used on listing#locations. Populates municipals based on checked provinces
// @param url must be in this format:
//  '<%= CGI.unescape util_municipal_url("{id}") %>'
function ajax_populate_municipals(url) {
  $('#municipals div[id^=p_]').remove();

  var values = $('#provinces :checkbox:checked').map(function() { return this.value; });
  if ( values.length > 0 ) {
    var url = url.replace('{id}', values.get().join(","));
    $.post(url, function(data) {
      // Group municipals under each province
      var m = {};
      $.each( data, function(i, item) {
        if ( ! m[item.parent_id] ) {
          m[item.parent_id] = [];
        }

        m[item.parent_id].push( item );
      });

      // Now display each municipal under each province
      var mdiv = $('#municipals');
      $.each(m, function(k,v) {
        var pdiv = $(document.createElement('div')).prop('id', "p_mun_" + k).html("<h3>" + $('label[for=p_' + k + ']').text() + "</h3>");
        $.each(v,function(idx, item) {
          var cb = $(document.createElement('input'))
                      .prop('type','checkbox')
                      .prop('id', 'm_' + item.id)
                      .prop('name', 'mun[]')
                      .prop('value', item.id);
          var lbl = $(document.createElement('label'))
                      .prop('for', 'm_' + item.id)
                      .html(item.name);
          pdiv.append(cb);
          pdiv.append(lbl);
        });

        mdiv.append(pdiv);
      });

      buttonify_checkbox('#municipals input');
    });
  }
}

// Used on listing#locations. Populates municipals based on checked provinces
// @param url must be in this format:
//  '<%= CGI.unescape util_politicians_url %>'
function ajax_populate_politicians(url) {

  var values = $('#municipals :checkbox:checked').map(function() { return this.value; });
  if ( values.length > 0 ) {
    //alert(values);
    /*$.post(url, { "loc_ids": values }).done(function(data) {
      console.log(data);
      alert(data);
    });
    */

    $.ajax({
      type: "POST",
      url: url,
      data: {"loc_ids": values.get().join(",")},
      success: function(result) {
        $('#politicians').append("<ul></ul>");
        var ul = $('#politicians ul');
        $.each(result, function(k,v) {
          ul.append("<li>(" + v.title + ") " + v.first_name + " " + v.last_name + "</li>");
        });
      },
      error: function(result) {
        alert("Error!");
      }
    });
  }

}

