$( function() {
  $('.flash').hide().slideDown('fast', function() {
    setTimeout(function() {
      $('.flash').slideUp('fast');
    }, 10000);
  });
});
