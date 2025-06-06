
//Add a lisinter for login form that listenens for a successful ajax request
$(document).on('ajax:success', '.login-form', function(e) {
  const data = e.detail[1]; //Get response

  if (data.signed_in) { //If response sign_in is set to true then means that user subbmitted correct data
    location.reload();
  } else {
    //Otherwise means that either was an error or user submit wrong info, so show an error
    $('#loginModalErrors').html('<div class="alert alert-warning">' + data.error + '</div>');
  }
});

