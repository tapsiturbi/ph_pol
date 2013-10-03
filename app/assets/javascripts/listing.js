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
