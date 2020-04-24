var trackClicks = function () {
  var extend = function (originalObject) {
    extendedObject = originalObject || {}

    for (var i = 1; i < arguments.length; i++) {
      if (!arguments[i]) {
        continue
      }

      for (var key in arguments[i]) {
        if (arguments[i].hasOwnProperty(key))
          extendedObject[key] = arguments[i][key]
      }
    }

    return extendedObject
  }

  var linksToBeTracked = document.querySelectorAll('[data-track-category][data-track-action]')

  for (var i = 0; i < linksToBeTracked.length; i++) {
    linksToBeTracked[i].addEventListener('click', function (event) {
      event.preventDefault();
      var link = event.target
      var options = { transport: 'beacon' }

      var category = link.getAttribute('data-track-category')
      var action = link.getAttribute('data-track-action')
      var label = link.getAttribute('data-track-label')
      var value = link.getAttribute('data-track-value')
      var dimension = link.getAttribute('data-track-dimension')
      var dimensionIndex = link.getAttribute('data-track-dimension-index')
      var extraOptions = link.getAttribute('data-track-options');

      if (label) {
        options.label = label
      }

      if (value) {
        options.value = value
      }

      if (dimension && dimensionIndex) {
        options['dimension' + dimensionIndex] = dimension
      }

      if (extraOptions) {
        extend(options, JSON.parse(extraOptions))
      }

      var consentCookie = window.GOVUK.getConsentCookie()

      if (consentCookie && consentCookie["usage"]) {
        try {
          ga('send', 'event', category, action, options)
        }
        catch (err) { console.error(err) }
      }
    })
  }
}

window.GOVUK.analytics = window.GOVUK.analytics || {}
window.GOVUK.analytics.trackClicks = trackClicks
