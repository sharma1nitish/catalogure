$(function() {
  $('#new_product select').select2({
    placeholder: 'Select categories',
    width: '80%',
    formatResult: function(item) {
      debugger
    }
  });
});
