/* eslint-env jasmine, jquery */

var $ = window.jQuery

describe('Form tracker', function () {
  var GOVUK = window.GOVUK || {}
  var $form

  beforeEach(function () {
    spyOn(window, 'ga')

    $form = $(
      '<div>' +
        '<form data-module="track-from" data-question-key="need-help-with" onsubmit="event.preventDefault()">' +
          '<input type="radio" name="afford_rent_mortgage_bills" id="option_yes" value="Yes">' +
          '<label for="option_yes">Yes</label>' +
          '<input type="radio" name="afford_rent_mortgage_bills" id="option_no" value="No">' +
          '<label for="option_no">No</label>' +
          '<input type="checkbox" name="need_help_with[]" id="option_paying_bills" value="Paying bills">' +
          '<label for="option_paying_bills">Paying bills</label>' +
          '<button type="submit">Continue</button>' +
        '</form>' +
      '</div>'
    )

    var tracker = new GOVUK.Modules.TrackForm()
    tracker.start($form)
  })

  it('sends chosen options to Google Analytics when submitting the form', function () {
    $form.find('input[value="Yes"]').trigger('click')
    $form.find('input[value="No"]').trigger('click')
    $form.find('input[value="Paying bills"]').trigger('click')
    $form.find('form').trigger('submit')

    expect(window.ga).toHaveBeenCalledWith(
      'send', { hitType: 'event', eventCategory: 'question_answer', eventAction: 'No', eventLabel: 'need-help-with' }
    )
    expect(window.ga).toHaveBeenCalledWith(
      'send', { hitType: 'event', eventCategory: 'question_answer', eventAction: 'Paying bills', eventLabel: 'need-help-with' }
    )
  })
})
