/* global $, Stripe */

// Document ready
$(document).on('turbolinks:load', function(){
  
  // Name the forms as variables for convenience
  var theForm = $('#pro_form');
  var submitBtn = $('#form-submit-btn');
  
  // Set stripe public key
  Stripe.setPublishableKey( $('meta["name=stripe-key"]').attr('content'));
  
  // When user clicks form submit button, prevent default behavior
  submitBtn.click(function(event){
    event.preventDefault(); 
    
    // Collect CC fields
    var ccNum = $('#card_number').val(),
        cvcNum = $('#card_code').val(),
        expMonth = $('#card_month'),
        expYear = $('#card_year');
    
    // Send to stripe
    Stripe.createToken({
      number: ccNum,
      cvc: cvcNum,
      exp_month: expMonth,
      exp_year: expYear
    }, stripeResponseHandler);
    
  });
  
  // Collect CC fields, send to stripe
  
  
  // Receive card token from stripe
  
  
  // Inject token as hidden field into form
  
  
  // Submit form to rails app


});