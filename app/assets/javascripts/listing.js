//= require jquery
//= require ckeditor/ckeditor

CKEDITOR.on( 'dialogDefinition', function( ev ) {
  // Take the dialog name and its definition from the event data.
  var dialogName = ev.data.name;
  var dialogDefinition = ev.data.definition;

  if ( dialogName == 'image' )
  {
    dialogDefinition.removeContents( 'advanced' );
    dialogDefinition.removeContents( 'Link' );
  }
});

$(document).ready(function() {
  $('textarea.ckeditor').each(function() {
    CKEDITOR.replace(this.id, { extraPlugins: 'divarea' })
  });
});

function cmt_show_and_ckedify(comment_id, focus) {
  $('#new_cmt_' + comment_id).show().find('textarea').addClass('ckeditor');
  if (focus) {
    CKEDITOR.replace('txt_comment_' + comment_id, {
      extraPlugins: 'divarea',
      on: {
        'instanceReady': function(evt) {
          CKEDITOR.instances['txt_comment_' + comment_id].focus();
        }
      }
    });
  } else {
    CKEDITOR.replace('txt_comment_' + comment_id, { extraPlugins: 'divarea' });
  }
}

