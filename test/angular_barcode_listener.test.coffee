describe 'scanListener directive', ->
  {scope, el, triggerKeypressEvents, timeout} = {}

  beforeEach ->
    angular.mock.module('barcodeListener')
    inject ($compile, $rootScope, $timeout, $document) ->
      timeout = $timeout

      triggerKeypressEvents = (chars) ->
        e = angular.element.Event 'keypress'
        chars = chars.split ''
        for char in chars
          e.which = char.charCodeAt 0
          $document.trigger e

      scope = $rootScope.$new true
      scanListener = $compile '<div barcode-listener on-scan="handleScan" prefix="C%" scan-duration=20></div>'
      el = scanListener(scope)
      scope.handleScan = sinon.stub()
      scope.$digest()

  it 'calls onScan when barcode scanned', ->
    expect(scope.handleScan).to.not.have.been.called
    triggerKeypressEvents 'C%25'
    timeout.flush()
    expect(scope.handleScan).to.have.been.calledOnce

  it 'waits for the scanDuration before calling onScan (to allow for all of the input)', ->
    triggerKeypressEvents 'C%25'
    timeout.flush(15)
    expect(scope.handleScan).to.not.have.been.called
    timeout.flush(5)
    expect(scope.handleScan).to.have.been.calledOnce

  it 'passes the barcode string into onScan', ->
    triggerKeypressEvents 'C%25'
    timeout.flush()
    expect(scope.handleScan).to.have.been.calledWithExactly '25'

    triggerKeypressEvents 'C%1'
    timeout.flush()
    expect(scope.handleScan).to.have.been.calledWithExactly '1'

  it 'works for non numeral characters', ->
    triggerKeypressEvents 'C%20141028-01'
    timeout.flush()
    expect(scope.handleScan).to.have.been.calledWithExactly '20141028-01'

  it 'doesnt call onScan for different prefix', ->
    triggerKeypressEvents 'P%25'
    timeout.flush()
    expect(scope.handleScan).to.not.have.been.called

  it 'doesnt call onScan for normal typing', ->
    triggerKeypressEvents 'C'
    timeout.flush()
    expect(scope.handleScan).to.not.have.been.called

    triggerKeypressEvents '%21'
    timeout.flush()
    expect(scope.handleScan).to.not.have.been.called

  it 'works for other prefixes', inject ($compile, $rootScope) ->
    scope = $rootScope.$new true
    scanListener = $compile '<div barcode-listener on-scan="handleScan" prefix="CON%"></div>'
    el = scanListener(scope)
    scope.handleScan = sinon.stub()
    scope.$digest()

    expect(scope.handleScan).to.not.have.been.called
    triggerKeypressEvents 'CON%25'
    timeout.flush()
    expect(scope.handleScan).to.have.been.calledOnce

  it 'removes the document listener when element destroyed', ->
    el.remove()
    triggerKeypressEvents 'C%25'
    timeout.flush()
    expect(scope.handleScan).to.not.have.been.called
