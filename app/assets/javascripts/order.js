$(function() {// Stuff to do as soon as the DOM is ready;
  $(".product_thumbnail").on('mouseenter', function(){
    var title = $(this).attr('id');
    $('.big_product_image').css("background","green").text(title);
  });
  $(".product_thumbnail").on('mouseleave', function(){
    $('.big_product_image').css("background","red").text("Hi");
  });
});