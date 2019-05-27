$(function() {
	$('#payment-form').find('form').submit(function(event) {
		let $form = $(this);

		$form.find('button').prop('disabled', true);
		Stripe.createToken($form, stripeResponseHandler);
		return false; 
	});
});

let stripeResponseHandler = function(status, response) {
  var $form = $('#payment-form').find('form');

  if (response.error) { // Problem!
    $form.find('.payment-errors').text(response.error.message);
    $form.find('button').prop('disabled', false); 
    console.log('fail');// Re-enable submission
  } else { // Token was created!
    var token = response.id;
    console.log(token);

    // Insert the token into the form so it gets submitted to the server:
    $form.append($('<input type="hidden" name="stripeToken" />').val(token));
    $form.get(0).submit();
  }
}