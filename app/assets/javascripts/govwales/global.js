function GovWales() { }

// Scroll back to contents animation
GovWales.scrollTop = function (scrollTo, offSet) {
  var pagePos = $(scrollTo).offset();
  var posHeight = pagePos.top - offSet;
  $('body,html').animate({scrollTop: posHeight}, 1000);
  $(scrollTo).focus();
}

// Back to top btn function
GovWales.backToTop = function () {
  var backToTopContainer = $('.footer__backtotop');
  var backToTopTrigger = $('.footer__backtotop a');
  backToTopTrigger.click(function (e) {
    var backToTopTarget = $(this).attr('href');
    GovWales.scrollTop(backToTopTarget, 0);
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

// Contents anchor links
GovWales.contentsAnchor = function () {
  var anchorLink = $('.navigation__contents a');
  anchorLink.click(function (e) {
    var anchorTarget = $(this).attr('href');
    GovWales.scrollTop(anchorTarget, 30);
    e.preventDefault();
  });
}

// Init
GovWales.Init = function (scrollTo) {
  GovWales.backToTop();
  GovWales.contentsAnchor();
}
