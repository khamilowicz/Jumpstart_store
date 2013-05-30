$(function() {// Stuff to do as soon as the DOM is ready;

  var catchphrase = $('<div/>', {
    text: "Best prices",
    class: 'catchphrase'
  });

  $(".product_thumbnail").on('mouseenter', function(){
    var title = $(this).attr('id');
    var title_array = title.split(" ")
    var image = $(this).find('img').attr('src');

    $('.big_product_image .image').css({
      'background-image': 'url("' + image + '")',
      'background-position': '20% 0%',
      'background-repeat': 'no-repeat'
    });
    $('.big_product_image .catchphrase').remove();

    $(title_array).slice(0,5).each( function(index, word) {
      var part_title = $('<div />', {
        text: word,
        id: 't' + index,
        class: 'caption title'
      });
      $('.big_product_image').append(part_title);
    });
  });

  $(".product_thumbnail").on('mouseleave', function(){

    $('.big_product_image .caption.title').remove();
    $('.big_product_image .image').css("background","white");
    $('.big_product_image').append(catchphrase);
  });
});