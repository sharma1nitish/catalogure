$(function() {
  $('#active_admin_content select').select2({
    placeholder: 'Select categories',
    width: '80%',
    formatResult: function(item) {
      debugger
    }
  });
});
