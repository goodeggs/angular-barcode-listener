barcodeScanListener = require 'barcode-scan-listener'

require '..'

describe 'scanListener directive', ->
  {scope, el, removeScanListener} = {}

  beforeEach 'stub barcodeScanListener.onScan', ->
    removeScanListener = sinon.stub()
    sinon.stub(barcodeScanListener, 'onScan').returns removeScanListener

  afterEach 'restore barcodeScanListener.onScan', ->
    barcodeScanListener.onScan.restore()

  beforeEach ->
    angular.mock.module('barcodeListener')
    inject ($compile, $rootScope) ->
      scope = $rootScope.$new true
      scope.handleScan = ->
      scanListener = $compile '<div barcode-listener on-scan="handleScan" prefix="C%" length="5" scan-duration=20></div>'
      el = scanListener(scope)
      scope.$digest()

  it 'calls onScan when barcode scanned', ->
    expect(barcodeScanListener.onScan).to.have.been.calledOnce
    expect(barcodeScanListener.onScan).to.have.been.calledWith {barcodePrefix: 'C%', barcodeLength: 5, scanDuration: 20}, scope.handleScan

  it 'removes the document listener when element destroyed', ->
    el.remove()
    expect(removeScanListener).to.have.been.calledOnce
