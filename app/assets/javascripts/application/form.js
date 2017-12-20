$(function() {
  var $form = $('form');
  var $subCategories = $('.sidebar .sub-category');
  var $filters = $('.sidebar input:checkbox');
  var $productsContainer = $('.products-container');

  $filters.on('change', function() {
    submitFilters($('input#query').val(), getSelectedSubSubCategoryIds());
  });

  $form.on('submit', function (event) {
    event.preventDefault();

    submitFilters($('input#query').val(), getSelectedSubSubCategoryIds());
  });

  function getSelectedSubSubCategoryIds() {
    var selectedCategoryIds = [];

    $subCategories.each(function() {
      var subSubCategoryIds = $(this).find('input:checkbox:checked').map(function() { return this.value; }).toArray();

      if (subSubCategoryIds.length) selectedCategoryIds.push(subSubCategoryIds);
    });

    return selectedCategoryIds;
  }

  function submitFilters(query, subSubCategoryIds) {
    return $.ajax({
      type: 'GET',
      url: '/products/filter',
      data: {
        query: query,
        sub_sub_category_ids: subSubCategoryIds,
        category_id: getCategoryId()
      }
    }).done(function(data) {
      refreshProducts(data.products);

      jQuery.Deferred().done.apply(this, arguments);
    }).fail(function (data) {
      jQuery.Deferred().fail.apply(this, arguments);
    });
  }

  function getCategoryId() {
    var params = window.location.search.substring(1);

    if (!params) return null;

    return params.split('&').filter(function(str) {
      return str.startsWith('category_id');
    })[0].split('=').pop();
  }

  function createProductContainer(data) {
    var $productContainer = $('.hidden .product-container').clone();

    $productContainer.find('h4').html(data.name);
    $productContainer.find('.description').html(data.description);
    $productContainer.find('.price-container .value').html(data.price_in_sgd);

    return $productContainer;
  }

  function refreshProducts(data) {
    $productsContainer.empty();

    $.each(data, function(index, productData) {
      $productsContainer.append(createProductContainer(productData));
    });
  }
});
