// = require govuk/all.js
// = require components/escape-link.js

window.GOVUKFrontend.initAll()

var $escapeLink = document.querySelector('[data-module="app-escape-link"]')
new EscapeLink($escapeLink).init()
