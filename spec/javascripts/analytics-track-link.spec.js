/* eslint-env jasmine, jquery */

var $ = window.jQuery

describe('Link tracker', function () {
  var GOVUK = window.GOVUK || {}
  var $backLink

  beforeEach(function () {
    spyOn(window, 'ga')

    $backLink = $('<a data-module="track-link" data-track-category="question_back" data-track-action="back need-help-with" data-track-label="need-help-with" href="/nation" onclick="event.preventDefault()">Back</a>')

    var tracker = new GOVUK.Modules.TrackLink()
    tracker.start($backLink)
  })

  it('sends data to Google Analytics when back link is clicked', function () {
    $backLink.trigger('click')

    expect(window.ga).toHaveBeenCalledWith(
      'send', { hitType: 'event', eventCategory: 'question_back', eventAction: 'back need-help-with', eventLabel: 'need-help-with' }
    )
  })
})
