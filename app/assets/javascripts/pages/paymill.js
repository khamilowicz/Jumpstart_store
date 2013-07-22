var PAYMILL_PUBLIC_KEY = '22916269435eef4b426e05604ce8cc89';

$(document).ready(function() {
  
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
