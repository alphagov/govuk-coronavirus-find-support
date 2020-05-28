/* global describe it expect beforeEach jasmine spyOn */

describe('Enhanced ecommerce', function () {
  'use strict'
  var GOVUK = window.GOVUK

  var snippet = function () {
    var text = document.createTextNode('Example text')
    var text2 = document.createTextNode('Example text too')
    var text3 = document.createTextNode('Example text without a link')

    var a = document.createElement('a')
    a.href = 'https://example.com'
    a.className = 'govuk-link'

    var a2 = document.createElement('a')
    a2.href = 'https://example.com/?two'
    a2.className = 'govuk-link'

    var li = document.createElement('li')
    var li2 = document.createElement('li')
    var li3 = document.createElement('li')

    var ul = document.createElement('ul')

    var subsection = document.createElement('div')
    subsection.setAttribute('data-ec-list-subsection', 'ecommerce-subsection-name')

    var section = document.createElement('section')
    section.setAttribute('data-track-ec-list', 'ecommerce-list-name')

    var wrapper = document.createElement('div')

    a.appendChild(text)
    a2.appendChild(text2)
    li.appendChild(a)
    li2.appendChild(a2)
    li3.appendChild(text3)
    ul.appendChild(li)
    ul.appendChild(li2)
    ul.appendChild(li3)
    subsection.appendChild(ul)
    section.appendChild(subsection)
    wrapper.appendChild(section)

    return wrapper
  }

  describe('with consent', function () {
    beforeEach( function () {
      GOVUK.setConsentCookie({
        'essential': true,
        'settings': false,
        'usage': true,
        'campaigns': false,
      })

      GOVUK.analyticsInit()

      spyOn(window, 'ga')
    })

    it('has the cookies are set correctly', function () {
      expect(GOVUK.getConsentCookie()).toEqual({
        usage: true,
        essential: true,
        campaigns: false,
        settings: false,
      })
    })

    it('sets the correct data attributes on the list', function () {
      var $clonedSnippet = snippet()
      var beforeLink = $clonedSnippet.querySelectorAll('a')

      expect(beforeLink[0].getAttribute('data-track-ec-position')).toBeNull()
      expect(beforeLink[1].getAttribute('data-track-ec-position') ).toBeNull()

      GOVUK.enhancedEcommerceTracking($clonedSnippet)

      var afterLink = $clonedSnippet.querySelectorAll('a')

      expect(afterLink[0].getAttribute('data-track-ec-position')).toEqual('1')
      expect(afterLink[1].getAttribute('data-track-ec-position')).toEqual('2')
    })

    it('calls `ga()` to add an ecommerce impression', function () {
      var $clonedSnippet = snippet()
      GOVUK.enhancedEcommerceTracking($clonedSnippet)

      expect(ga).toHaveBeenCalled()

      expect(ga).toHaveBeenCalledWith(
        'ec:addImpression',
        { name: 'https://example.com/', list: 'ecommerce-list-name', position: 1, dimension2: 'ecommerce-subsection-name' }
      )

      expect(ga).toHaveBeenCalledWith(
        'ec:addImpression',
        { name: 'https://example.com/?two', list: 'ecommerce-list-name', position: 2, dimension2: 'ecommerce-subsection-name' }
      )

      expect(ga).toHaveBeenCalledWith(
        'ec:addImpression',
        { name: 'No link', list: 'ecommerce-list-name', position: 3, dimension2: 'ecommerce-subsection-name' }
      )
    })

    it('calls `ga()` when clicked', function () {
      var $clonedSnippet = snippet()
      GOVUK.enhancedEcommerceTracking($clonedSnippet)

      $clonedSnippet.querySelector('a').addEventListener('click', function (event) {
        event.preventDefault()
      })

      $clonedSnippet.querySelector('a').click()

      expect(ga).toHaveBeenCalled()

      expect(ga).toHaveBeenCalledWith(
        'set',
        'dimension2',
        'ecommerce-subsection-name'
      )

      expect(ga).toHaveBeenCalledWith(
        'ec:addProduct',
        {
          name: 'https://example.com/', position: '1' }
      )

      expect(ga).toHaveBeenCalledWith(
        'ec:setAction',
        'click',
        {
          list: 'ecommerce-list-name'
        }
      )

      expect(ga).toHaveBeenCalledWith(
        'send', {
          hitType: 'event',
          eventCategory: 'UX',
          eventAction: 'click',
          eventLabel: 'Results'
        }
      )
    })
  })

  describe('without consent', function () {
    beforeAll(function () {
      if (typeof window.ga === 'undefined') {
        window.ga = function () { }
      }
    })

    beforeEach(function () {
      GOVUK.setConsentCookie({
        'essential': true,
        'settings': false,
        'usage': false,
        'campaigns': false,
      })

      spyOn(window, 'ga')
    })

    it('has the cookies are set correctly', function () {
      expect(GOVUK.getConsentCookie()).toEqual({
        usage: false,
        essential: true,
        campaigns: false,
        settings: false,
      })
    })

    it("doesn't set the correct data attributes on the list", function () {
      var $clonedSnippet = snippet()
      var beforeLink = $clonedSnippet.querySelector('a')

      expect(beforeLink.getAttribute('data-track-ec-position')).toBeNull()

      GOVUK.enhancedEcommerceTracking($clonedSnippet)

      var afterLink = $clonedSnippet.querySelector('a')

      expect(beforeLink.getAttribute('data-track-ec-position')).toBeNull()
    })

    it("doesn't call `ga()` to add an ecommerce impression", function () {
      var $clonedSnippet = snippet()
      GOVUK.enhancedEcommerceTracking($clonedSnippet)

      expect(ga).not.toHaveBeenCalled()
    })

    it("doesn't call `ga()` when clicked", function () {
      var $clonedSnippet = snippet()
      GOVUK.enhancedEcommerceTracking($clonedSnippet)

      $clonedSnippet.querySelector('a').addEventListener('click', function (event) {
        event.preventDefault()
      })

      $clonedSnippet.querySelector('a').click()
      expect(ga).not.toHaveBeenCalled()
    })
  })
})
