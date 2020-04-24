//= require jquery
//= require govuk/all.js
//= require govuk_publishing_components/components/cookie-banner
//= require govuk_publishing_components/lib/cookie-functions
//= require analytics
//= require analytics-trackClick
//= require cookies
window.CookieSettings.start()
window.GOVUK.analytics.start()
window.GOVUK.analytics.trackClicks()
window.GOVUKFrontend.initAll()
