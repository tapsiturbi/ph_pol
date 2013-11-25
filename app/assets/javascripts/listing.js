
var CKEDITOR_TOOLBAR = [
  { name: 'document', groups: [ 'mode', 'document', 'doctools' ], items: [ 'Source', '-', 'Preview'] },
  { name: 'clipboard', groups: [ 'clipboard', 'undo' ], items: ['PasteText', 'PasteFromWord', '-', 'Undo', 'Redo' ] },
  { name: 'editing', groups: [ 'find', 'selection', 'spellchecker' ], items: [ 'Find', 'Replace', '-', 'SelectAll'] },
  { name: 'basicstyles', groups: [ 'basicstyles', 'cleanup' ], items: [ 'Bold', 'Italic', 'Underline', 'Strike', '-', 'RemoveFormat' ] },
  { name: 'paragraph', groups: [ 'list', 'indent', 'blocks', 'align', 'bidi' ], items: [ 'NumberedList', 'BulletedList', '-', 'Outdent', 'Indent', '-', 'Blockquote', '-', 'JustifyLeft', 'JustifyCenter', 'JustifyRight', 'JustifyBlock'] },
  { name: 'links', items: [ 'Link', 'Unlink'] },
  '/',
  { name: 'styles', items: [ 'Font', 'FontSize' ] },
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
