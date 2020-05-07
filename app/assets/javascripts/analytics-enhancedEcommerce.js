var enhancedEcommerceTracking = function (d) {
  var consentCookie = window.GOVUK.getConsentCookie()

  // Travels up the DOM from `el` to the first ancestor with `selector`. Returns
  // that element.
  var ancestor = function (el, selector) {
    // travel two up the tree to search one up the tree
    var present = el.parentElement.querySelectorAll(selector)

    if (present.length < 1) {
      return ancestor(el.parentElement, selector)
    }

    return present[0]
  }

  // Start analytics only if we have user consent
  if (consentCookie && consentCookie["usage"] === true) {
    var lists = d.querySelectorAll('[data-track-ec-list]')

    if (lists.length === 0) {
      return
    }

    for (var idx = 0; idx < lists.length; idx++) {
      var list = lists[idx];
      var listName = list.getAttribute('data-track-ec-list')
      var positions = list.querySelectorAll('li')

      for (var i = 0; i < positions.length; i++) {
        var listItem = positions[i]
        var links = listItem.querySelectorAll('a')
        var positionNumber = i + 1 // Position number needs to start from 1.

        if (links.length >= 1) {
          for (var j = 0; j < links.length; j++) {
            var link = links[j]
            var href = link.href

            // Save the position to the item in the DOM
            link.setAttribute('data-track-ec-position', positionNumber)

            // Send the impression to GA
            ga('ec:addImpression', {
              name: href,
              list: listName,
              position: positionNumber
            })

            // Add a listener so that an event will be fired if the link(s) in
            // the results are clicked.
            link.addEventListener('click', function (event) {
              var $a = event.target
              var position = $a.getAttribute('data-track-ec-position')
              var href = $a.href
              var list = ancestor($a, '[data-track-ec-list]').getAttribute('data-track-ec-list')
              var subsection = ancestor($a, '[data-ec-list-subsection]').getAttribute('data-ec-list-subsection')

              ga('set', 'dimension2', subsection)

              ga('ec:addProduct', {
                name: href,
                position: position
              })

              ga('ec:setAction', 'click', {
                list: list
              })

              ga('send', {
                hitType: 'event',
                eventCategory: 'UX',
                eventAction: 'click',
                eventLabel: 'Results'
              })
            })
          }
        }
      }
    }
  }
}

window.GOVUK.enhancedEcommerceTracking = enhancedEcommerceTracking
