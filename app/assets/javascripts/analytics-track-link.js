/* eslint-env jquery */
/* global ga:readonly */

window.GOVUK = window.GOVUK || {}
window.GOVUK.Modules = window.GOVUK.Modules || {};

(function (global, GOVUK) {
  'use strict'

  var $ = global.jQuery

  GOVUK.Modules.TrackLink = function () {
    this.start = function (element) {
      track(element)
    }

    function track (element) {
      element.on('click', function (event) {
        var eventCategory = $(this).data('track-category')
        var eventAction = $(this).data('track-action')
        var eventLabel = $(this).data('track-label')

        if (typeof ga === 'function') {
          ga('send', {
            hitType: 'event',
            eventCategory: eventCategory,
            eventAction: eventAction,
            eventLabel: eventLabel
          })
        }
      })
    }
  }
})(window, window.GOVUK)
