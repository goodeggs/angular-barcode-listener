barcodeScanListener = require 'barcode-scan-listener'

###
Listen for scan with specified product prefix.
@param [Function] onScan - callback to call when scan is successful. Passes the scanned string.
@param [String] prefix - character prefix that appears before the scanned string (e.g. 'P%', 'C%')
@param [RegExp] scanOptions.barcodeValueTest - RegExp defining valid scan value (not including prefix).
@param [Boolean] [scanOptions.finishScanOnMatch] - if true, test scan value (not including prefix)
  match with barcodeValueTest on each character. If matched, immediately
  call the scanHandler with the value. This will generally make scans faster.
###

module.exports = angular.module 'barcodeListener', []

.directive 'barcodeListener', ->
  restrict: 'EA'

  scope:
    onScan: '='
    prefix: '@'
    valueTest: '@'
    finishScanOnMatch: '@'
    scanDuration: '@?'

  link: (scope, element, attrs) ->
    scanDuration = +scope.scanDuration or 50

    removeScanListener = barcodeScanListener.onScan {
      barcodePrefix: scope.prefix
      barcodeValueTest: if scope.valueTest then new RegExp(scope.valueTest) else undefined
      finishScanOnMatch: if scope.finishScanOnMatch then scope.finishScanOnMatch == 'true' else undefined
      scanDuration
    }, scope.onScan

    element.on '$destroy', removeScanListener
