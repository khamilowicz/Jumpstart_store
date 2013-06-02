$(function() {
  $('.cart_btn').bind('ajax:beforeSend', function() {
    $(this).button("loading")
  });
  $('.cart_btn').bind('ajax:success', function() {
    $(this).button('reset');
  });
});