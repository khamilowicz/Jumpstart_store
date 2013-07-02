$(function() {
  $('.user .order_text').on('click', function() {
    $('.user .orders').slideToggle();
  });

  $('.user .cart_text').on('click', function() {
    $('.user .cart').slideToggle();
  });
});