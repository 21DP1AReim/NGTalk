import { Spinner } from 'spin.js';
import "webpacker"
import "./comments"

$.ajaxSetup({
  headers: {
    'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
  }
});


$(document).on('ajax:success', '.login-form', function(e) {
  const data = e.detail[1];

  if (data.signed_in) {
    location.reload();
  } else {
    $('#loginModalErrors').html('<div class="alert alert-warning">' + data.error + '</div>');
  }
});

