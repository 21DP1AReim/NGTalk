//= require jquery
//= require rails-ujs
//= require_tree .

//When document is loaded call setupReplyButtons function and initializeCommentForms function, to bind all listeners
$(document).ready(function() {
  setupReplyButtons();
  initCommentForms();
});

// Reload comments after submitting a comment or reply
$(document).on('ajax:success', '.comment-form', function () {
  //Resets comment form
  $(this).trigger("reset");
  //Reload the commentsection to show newly created comments/replies
  $('#comments').load(location.href + ' #comments > *', () => {
    //Rebind form listeners, because adding a new comment/reply
    setupReplyButtons();
    initCommentForms();
  });
});

// Enable/disable submit button based on textarea content
function initCommentForms() {
  //For every comment-form class
  $('.comment-form').each(function() {
    //Get the form element
    let form = $(this);
    //Get the textarea field in the form
    let textarea = form.find('textarea');
    //Get the submit button for the form
    let submitButton = form.find('input[type="submit"]');
    //Trims the text area value and checks if its length is more than 0
    let hasContent = $.trim(textarea.val()).length > 0;
    //If length is more than 0(true) then should enable the submit button so pass the oposite value
    submitButton.prop('disabled', !hasContent);
    //Remove any input listeners and then add an input listener that disables the submit button if input length is less than or equal to 1
    textarea.off('input').on('input', (e)=>{
      let hasContent = $.trim(textarea.val()).length > 0;
      submitButton.prop('disabled', !hasContent);
    });
  });
}

// Attach AJAX reply behavior to reply buttons
function setupReplyButtons() {
  //Remove click listener for handleReplyClick, so that a single button doesn't have repeat listeners and 
  // add a listener for click to call handleReplyClick
  $('.reply-button').off('click', handleReplyClick).on('click', handleReplyClick);

}
//Gets called when user clicks on reply button, event is click
function handleReplyClick(e) {
  //Prevent click/stop click event so could handle with ajax, since reply button is an <a> tag with a href
  e.preventDefault();
  //Get the button that was clicked 
  let button = e.currentTarget;
  //Start a GET request with these headers, which calls the reply function in comments controller, as defined by the routes
  fetch(button.href, {
    headers: {
      //Set the type of expexted result from the request
      'Accept': 'text/javascript',
      //Make sure CSRF token is sent with request so Rails isn't mad
      'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
    }
  });
}

