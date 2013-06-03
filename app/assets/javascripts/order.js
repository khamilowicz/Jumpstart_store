$(function() {// Stuff to do as soon as the DOM is ready;
  var slogan_format = function(phrase){
    var part_title;
    var intitle = phrase.split(' ').slice(0,5);
    $.each(intitle, function(index, word) {
      part_title = $('<div />', {
        text: word,
        id: 't' + index,
        class: 'caption title'});
      $('.big_product_image').append(part_title);
    });
    return 0;
  };

   slogan_format("Best prices");

  $(".product_thumbnail, .product .title a").on('mouseenter', function(){
    var title = $(this).data('title');
    var image_url = $(this).data('photo');

    $('.big_product_image .image').css({
      'background-image': 'url("' + image_url + '")',
      'background-position': '20% 0%',
      'background-repeat': 'no-repeat'
    });

    $('.big_product_image .caption').remove();

    slogan_format(title);

    $(".product_thumbnail, .product .title a").on('mouseleave', function(){
      $('.big_product_image .caption.title').remove();
      $('.big_product_image .image').css("background","white");
     slogan_format("Best prices");
    });
  });
});