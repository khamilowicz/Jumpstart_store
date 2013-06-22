var PAYMILL_PUBLIC_KEY = '22916269435eef4b426e05604ce8cc89';

var slogan_format = function(phrase){
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


function update_big_image () {
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

  // parseInt(($(document).height()/slogans.length()))

  change_slogan();
});
}
var slogans = ["Best prices", "Always on time", "Kids friendly", "Red and green"];

function change_slogan(){
  slogan = slogans[0];
  for(var i=1; i<slogans.length; i++){
    if((window.pageYOffset) > (i*$(document).height()/slogans.length)){ 
      slogan = slogans[i];
    }
  }
  slogan_format(slogan);
}

$(function() {

  $(window).on('scroll', function() {
    $('.big_product_image .caption.title').remove();
    change_slogan();
  });

// Stuff to do as soon as the DOM is ready;
$("#payment-form").submit(function(event) {
  event.preventDefault();
    // Deactivate submit button to avoid further clicks
    $('.submit-button').attr("disabled", "disabled");

    paymill.createToken({
      number: $('#transaction_card-number').val(),  // required, ohne Leerzeichen und Bindestriche
      exp_month: $('#transaction_card-expiry-month').val(),   // required
      exp_year: $('#transaction_card-expiry-year').val(),     // required, vierstellig z.B. "2016"
      cvc: $('#transaction_card-cvc').val(),                  // required
      amount_int: $('#transaction_card-amount-int').val(),    // required, integer, z.B. "15" für 0,15 Euro 
      currency: $('#transaction_card-currency').val(),    // required, ISO 4217 z.B. "EUR" od. "GBP"
      cardholder: $('#transaction_card-holdername').val() // optional
    }, PaymillResponseHandler);                   // Info dazu weiter unten

    return false;
  });

function PaymillResponseHandler(error, result) {

   $('#transaction_card-number').val(' '); // required, ohne Leerzeichen und Bindestriche
    $('#transaction_card-expiry-month').val(' '); // required
    $('#transaction_card-expiry-year').val(' ');   // required, vierstellig z.B. "2016"
   $('#transaction_card-cvc').val(' ');          // required
   $('#transaction_card-amount-int').val(' ');  // required, integer, z.B. "15" für 0,15 Euro 
   $('#transaction_card-currency').val('');// required, ISO 4217 z.B. "EUR" od. "GBP"
   $('#transaction_card-holdername').val(' ');

   if (error) {
    // Shows the error above the form
    $(".payment-errors").text(error.apierror);
    $(".submit-button").removeAttr("disabled");
  } else {
   var form = $("#payment-form");
    // Output token
    var token = result.token;
    // Insert token into form in order to submit to server
    form.append(
      "<input type='hidden' name='paymillToken' value='"+token+"'/>"
      );
    form.get(0).submit();

  }
}

slogan_format("Best prices");
$(".product_thumbnail, .product .title a").on('mouseenter', update_big_image);

});