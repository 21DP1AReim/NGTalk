import { Spinner } from 'spin.js';
import "webpacker"
import "./comments"


$(document).on('ajax:success', '.login-form', function(e) {
  if (e.detail[1].signed_in) {
    location.reload();
  } else {
    jQuery('<div />', {class: 'alert alert-warning', text: e.detail[1].error}).prependTo('#loginModalForm');
  }
});

$(document).on('ajax:error', '.login-form', function(event) {
    const response = event.detail[0].responseJSON

    if (response.errors) {
        const errors = Object.entries(response.errors)
        errors.forEach(function(error) {
          jQuery('<div />', {class: 'alert alert-warning', text: error[1][0]}).prependTo('#loginModalForm');
        })
    } else {
      jQuery('<div />', {class: 'alert alert-warning', text: response.error}).prependTo('#loginModalForm');
    }
});