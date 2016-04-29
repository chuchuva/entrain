$(function() {
  $(document).on('show.bs.tab', '#preview-tab', function (e) {
    $('#preview').html(marked($('#write textarea').val(),
      {gfm: true, breaks: true}));
  });
  $(document).on('shown.bs.tab', '#write-tab', function (e) {
    $('#write textarea').focus();
  });
});
