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
    submitBtn.val("Processing").prop('disabled',true);
    
    // Collect CC fields
    var ccNum = $('#card_number').val(),
        cvcNum = $('#card_code').val(),
        expMonth = $('#card_month'),
        expYear = $('#card_year');
    
    // Validate CC fields with stripe JS library
    var error = false;
    
    // Validate card number:
    if(!Stripe.card.validateCardNumber(ccNum)) {
      error = true;
      alert('The credit card number appears to be invalid.');
    }
    
    // Validate CVC number
    if(!Stripe.card.validateCVC(cvcNum)) {
      error = true;
      alert('The security code appears to be invalid.');
    }
    
    // Validate Expiration date
    if(!Stripe.card.validateExpiry(expMonth, expYear)) {
      error = true;
      alert('The expiration date appears to be invalid.');
    }
    
    if (error) {
      // If there are card errors, don't send to stripe and reenable button. 
      submitBtn.prop('disabled', false).val("Sign Up");
    } else { 
      // Send to stripe
      Stripe.createToken({
        number: ccNum,
        cvc: cvcNum,
        exp_month: expMonth,
        exp_year: expYear
      }, stripeResponseHandler);
    }
    return false;
  });
  // Receive card token from stripe
  function stripeResponseHandler(status, response) {
    // Get the token from the response. 
    var token = response.id;
    // Inject the card token into a hidden field. 
    theForm.append( $('<input type="hidden" name="user[stripe_card_token]">').val(token) );
    // Submit form to rails app
    theForm.get(0).submit();
  }
});