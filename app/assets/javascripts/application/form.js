$(function() {
  var $form = $('form');
  var $subCategories = $('.sidebar .sub-category');
  var $filters = $('.sidebar input:checkbox');

  $filters.on('change', function() {
    submitFilters($('input#query').val(), getSelectedCategoryIds)
  });

  $form.on('submit', function (event) {
    event.preventDefault();

    submitFilters($('input#query').val(), getSelectedCategoryIds)
  });

  function getSelectedCategoryIds() {
    var selectedCategoryIds = [];

    $subCategories.each(function() {
      var categoryIds = $(this).find('input:checkbox:checked').map(function() { return this.value; }).toArray();

      selectedCategoryIds.push(categoryIds);
    });

    return selectedCategoryIds;
  }

  function submitFilters(query, categoryIds) {
    return $.ajax({
      type: 'GET',
      url: '/products/filter',
      data: {
        query: query,
        category_ids: categoryIds
      }
    }).done(function(data) {debugger
      jQuery.Deferred().done.apply(this, arguments);
    }).fail(function (data) {
      jQuery.Deferred().fail.apply(this, arguments);
    });
  }
});
