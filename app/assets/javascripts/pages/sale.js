$(function() {
 
  $('.product .remove_product a').on( 'click', function() {
   $(this).closest('.product').slideUp();
 });
});