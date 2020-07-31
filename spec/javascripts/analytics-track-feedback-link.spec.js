/* eslint-env jasmine, jquery */

var $ = window.jQuery

describe('Feedback link tracker', function () {
  var GOVUK = window.GOVUK || {}
  var $feedbackLink

  beforeEach(function () {
    spyOn(window, 'ga')

    $feedbackLink = $('<a data-module="track-link" data-track-category="OnSite Feedback" data-track-action="Open form" data-track-label="Give feedback on this service" href="https://www.gov.uk/done/find-coronavirus-support" onclick="event.preventDefault()">Give feedback on this service</a>')

    var tracker = new GOVUK.Modules.TrackLink()
    tracker.start($feedbackLink)
  })

  it('sends data to Google Analytics when feedback link is clicked', function () {
    $feedbackLink.trigger('click')

    expect(window.ga).toHaveBeenCalledWith(
      'send', { hitType: 'event', eventCategory: 'OnSite Feedback', eventAction: 'Open form', eventLabel: 'Give feedback on this service' }
    )
  })
})
