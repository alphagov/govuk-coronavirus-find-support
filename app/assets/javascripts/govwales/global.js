function GovWales() { }

// Scroll back to contents animation
GovWales.scrollTop = function (scrollTo) {
  var pagePos = $(scrollTo).offset();
  var posHeight = pagePos.top;
  $('body,html').animate({scrollTop: posHeight}, 400);
  $(scrollTo).focus();
}

// Back to top btn function
GovWales.backToTop = function () {
  var backToTopContainer = $('.footer__backtotop');
  var backToTopTrigger = $('.footer__backtotop a');
  backToTopTrigger.click(function (e) {
    var backToTopTarget = $(this).attr('href');
    GovWales.scrollTop(backToTopTarget);
    e.preventDefault();
  });

  // Remove back to top btn if not required
  $.fn.backToTopAutoHide = function () {
    var windowHeight = $(window).height();
    var footerHeight = $('footer').height();
    var bodyHeight = $('body').height() - footerHeight;
    if (bodyHeight <= windowHeight) {
      backToTopTrigger.remove();
    }
  };

  backToTopContainer.backToTopAutoHide();
}

// Init
GovWales.Init = function (scrollTo) {
  GovWales.backToTop();
}
