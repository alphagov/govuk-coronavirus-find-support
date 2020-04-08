function EscapeLink ($module) {
  this.$module = $module
}

EscapeLink.prototype.init = function () {
  var $module = this.$module
  if (!$module) {
    return
  }
  $module.addEventListener('click', this.handleClick.bind(this))
}

/**
* Click event handler
*
* @param {MouseEvent} event - Click event
*/
EscapeLink.prototype.handleClick = function (event) {
  event.preventDefault()
  window.history.go(-window.history.length + 1)
}
