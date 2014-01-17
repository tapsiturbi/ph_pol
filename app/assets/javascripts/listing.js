
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

