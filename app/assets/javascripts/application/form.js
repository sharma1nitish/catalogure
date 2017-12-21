$(function() {
  var $form = $('form');
  var $query = $('input#query');
  var $subCategories = $('.sidebar .sub-category');
  var $filters = $('.sidebar input:checkbox');
  var $productsContainer = $('.products-container');
  var $paginator = $('#paginator');

  renderPaginator();

  $filters.on('change', function() {
    submitFilters($query.val(), getSelectedSubSubCategoryIds());
  });

  $form.on('submit', function (event) {
    event.preventDefault();

    submitFilters($query.val(), getSelectedSubSubCategoryIds());
  });

  function getSelectedSubSubCategoryIds() {
    var selectedCategoryIds = [];

    $subCategories.each(function() {
      var subSubCategoryIds = $(this).find('input:checkbox:checked').map(function() { return this.value; }).toArray();

      if (subSubCategoryIds.length) selectedCategoryIds.push(subSubCategoryIds);
    });

    return selectedCategoryIds;
  }

  function submitFilters(query, subSubCategoryIds, page) {
    return $.ajax({
      type: 'GET',
      url: '/products/filter',
      data: {
        query: query,
        sub_sub_category_ids: subSubCategoryIds,
        category_id: getCategoryId(),
        page: page
      }
    }).done(function(data) {
      refreshProducts(data);

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
    var $productContainer = $('.product-container-clone .product-container').clone();

    $productContainer.find('h4').html(data.name);
    $productContainer.find('.description').html(data.description);
    $productContainer.find('.price-container .value').html(data.price_in_sgd);

    return $productContainer;
  }

  function refreshProducts(data) {
    $productsContainer.empty();

    $paginator.attr('data-total-pages', data.total_pages);

    $.each(data.products, function(index, productData) {
      $productsContainer.append(createProductContainer(productData));
    });

    renderPaginator(data.current_page, data.total_pages);
  }

  function renderPaginator(currentPage, pagesCount) {debugger
    var totalPages = pagesCount || Number($paginator.attr('data-total-pages'));

    $paginator.twbsPagination('destroy')

    if (!totalPages || totalPages <= 1) return;

    $paginator.twbsPagination({
        totalPages: totalPages,
        visiblePages: totalPages / 5,
        startPage: Number(currentPage) || 1,
        initiateStartPageClick: false,
        onPageClick: function (event, page) {
          submitFilters($query.val(), getSelectedSubSubCategoryIds(), page);
        }
    });
  }
});
