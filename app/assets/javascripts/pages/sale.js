$(function() {
 
  $('.product .remove a').on( 'click', function() {

   $(this).closest('.product').slideUp();
  });
});