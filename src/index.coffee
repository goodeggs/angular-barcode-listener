###
Listen for scan with specified product prefix.
@param [Function] onScan - callback to call when scan is successful. Passes the scanned string.
@param [String] prefix - character prefix that appears before the scanned string (e.g. 'P%', 'C%')
###

module.exports = angular.module 'barcodeListener', []

.directive 'barcodeListener', ($rootScope, $timeout, $document) ->
  restrict: 'EA'

  scope:
    onScan: '='
    prefix: '@'

  link: (scope, element, attrs) ->
    codeBuffer = scannedPrefix = ''
    scanning = no

    keypressHandler = ($event) ->
      char = String.fromCharCode($event.which)

      charIndex = scope.prefix.indexOf char
      expectedPrefix = scope.prefix.slice(0, charIndex)

      if not scanning
        scanning = yes
        finishScan = ->
          if codeBuffer
            scope.onScan codeBuffer
          scannedPrefix = codeBuffer = ''
          scanning = no
        $timeout finishScan, 50

      if scannedPrefix is scope.prefix and /[^\s]/.test char
        codeBuffer += char
      else if scannedPrefix is expectedPrefix and char is scope.prefix.charAt(charIndex)
        scannedPrefix += char

    $document.on 'keypress', keypressHandler

    element.on '$destroy', ->
      $document.off 'keypress', keypressHandler
