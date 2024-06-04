//= require jquery

//= require rails-ujs
//= require turbolinks
//= require_tree .

$(document).on('turbolinks:load', function() {
  $('.comment-form input[type="submit"]').prop("disabled", true);
});

$(document).on('ajax:success', '.comment-form', function() {
  $(this).trigger("reset");
  $(this).closest("[data-target]").find("[data-target='comments']").load(location.href + " [data-target='comments']>*", "");
});

$(document).on('turbolinks:load', function() {
  $('.comment-form input[type="submit"]').prop("disabled", false);
});

