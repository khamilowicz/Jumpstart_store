$(function() {
  $('.cart_btn').bind('ajax:beforeSend', function() {
    $(this).button("loading")
  });
  $('.cart_btn').bind('ajax:success', function() {
    onWidthChanges();
    $(this).button('reset');
  });

  $('.carousel').carousel();

  onWidthChanges();
  $(window).resize(onWidthChanges);
});

function onWidthChanges (){
 hidePicture(false); 
 if (window.innerWidth > 1200) {
  ProductGrid(3);
};
if (window.innerWidth < 1200 && window.innerWidth > 768) {
  ProductGrid(2);
};
if (window.innerWidth < 768) {
 hidePicture(true); 
};
};

function hidePicture (really) {
  if (really) {
    $('.big_product_container').css('display', 'none');
  }else{
    $('.big_product_container').css('display', 'block');
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