$(function() {
  $('.cart_btn').bind('ajax:beforeSend', function() {
    $(this).button("loading")
  });
  $('.cart_btn').bind('ajax:success', function() {
    $(this).button('reset');
  });

  $('.carousel').carousel();

  widthChanges();
  $(window).resize(widthChanges);
});

function widthChanges (){
  if (window.innerWidth > 1200) {
    ProductGrid(3);
    console.log('hi');
  };
  if (window.innerWidth < 1200 && window.innerWidth > 768) {
    ProductGrid(2);
  };
};

var ProductGrid = function(amount_in_row){
  if (amount_in_row == 2) {
    $('.product.short').removeClass('span4');
    $('.product.short').addClass('span6');
  };
  if (amount_in_row == 3) {
    $('.product.short').removeClass('span6');
    $('.product.short').addClass('span4');
  };
};