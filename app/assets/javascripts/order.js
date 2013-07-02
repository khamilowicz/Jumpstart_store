var slogans = ["Best prices", "Always on time", "Kids friendly", "Red and green"];

function slogan_format(phrase){
  var part_title;
  var intitle = phrase.split(' ').slice(0,3);
  $.each(intitle, function(index, word) {
    part_title = $('<div />', {
      text: word,
      id: 't' + index,
      class: 'caption title'});
    $('.big_product_image').append(part_title);
  });
  return 0;
};

function update_big_image(){
 var title = $(this).data('title');
 var image_url = $(this).data('photo');

 $('.big_product_image .image').css(
   {'background-image': 'url("' + image_url + '")',
   'background-position': '20% 0%',
   'background-repeat': 'no-repeat'}
   );

 $('.big_product_image .caption').remove();

 slogan_format(title);

 $(".product_thumbnail, .product .title a").on('mouseleave', 
  function(){
    $('.big_product_image .caption.title').remove();
    $('.big_product_image .image').css("background","white");
    change_slogan();
  });
};

function change_slogan(){
  var chunk = $(document).height()/slogans.length;
  $('.big_product_image .caption.title').remove();
  var slogan = slogans[0];
  for(var i=1; i<slogans.length; i++){
    if((window.pageYOffset) > (i*chunk)){ 
      slogan = slogans[i];
    }
  }
  slogan_format(slogan);
}

$(document).ready(function() {

  slogan_format("Best prices");
  $(window).scroll(change_slogan);
  $(".product_thumbnail, .product .title a").on('mouseenter', update_big_image);

});