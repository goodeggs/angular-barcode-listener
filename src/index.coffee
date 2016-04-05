barcodeScanListener = require 'barcode-scan-listener'

###
Listen for scan with specified product prefix.
@param [Function] onScan - callback to call when scan is successful. Passes the scanned string.
@param [String] prefix - character prefix that appears before the scanned string (e.g. 'P%', 'C%')
###

module.exports = angular.module 'barcodeListener', []

.directive 'barcodeListener', ->
  restrict: 'EA'

  scope:
    onScan: '='
    prefix: '@'
    scanDuration: '@?'

  link: (scope, element, attrs) ->
    scanDuration = +scope.scanDuration or 50

    removeScanListener = barcodeScanListener.onScan({barcodePrefix: scope.prefix, scanDuration}, scope.onScan)

    element.on '$destroy', removeScanListener
