require! {
  'chai' : {expect}
  'dim-console'
  'exocom-mock' : ExoComMock
  'exoservice' : ExoService
  'jsdiff-console'
  'livescript'
  'lowercase-keys'
  'nitroglycerin' : N
  'port-reservation'
  'record-http' : HttpRecorder
  'request'
  'wait' : {wait-until}
}


module.exports = ->

  @Given /^an ExoCom server$/, (done) ->
    port-reservation.get-port N (@exocom-port) ~>
      @exocom = new ExoComMock
        ..listen @exocom-port, done


  @Given /^an instance of this service$/, (done) ->
    port-reservation.get-port N (@service-port) ~>
      @exocom.register-service name: '_____serviceName_____', port: @service-port
      @process = new ExoService service-name: '_____serviceName_____', exocom-port: @exocom.port, exorelay-port: @service-port
        ..listen!
        ..on 'online', -> done!


  @Given /^the service contains the _____serviceName_____s:$/, (table, done) ->
    _____serviceName_____s = [lowercase-keys(record) for record in table.hashes!]
    @exocom
      ..send-message service: '_____serviceName_____', name: '_____serviceName_____.create-many', payload: _____serviceName_____s
      ..wait-until-receive done



  @When /^sending the message "([^"]*)"$/, (message) ->
    @exocom.send-message service: '_____serviceName_____', name: message


  @When /^sending the message "([^"]*)" with the payload:$/, (message, payload, done) ->
    @fill-in-_____serviceName_____-ids payload, (filled-payload) ~>
      if filled-payload[0] is '['   # payload is an array
        eval livescript.compile "payload-json = #{filled-payload}", bare: true, header: no
      else                          # payload is a hash
        eval livescript.compile "payload-json = {\n#{filled-payload}\n}", bare: true, header: no
      @exocom.send-message service: '_____serviceName_____', name: message, payload: payload-json
      done!



  @Then /^the service contains no _____serviceName_____s$/, (done) ->
    @exocom
      ..send-message service: '_____serviceName_____', name: '_____serviceName_____.list'
      ..wait-until-receive ~>
        expect(@exocom.received-messages![0].payload.count).to.equal 0
        done!


  @Then /^the service now contains the _____serviceName_____s:$/, (table, done) ->
    @exocom
      ..send-message service: '_____serviceName_____', name: '_____serviceName_____.list'
      ..wait-until-receive ~>
        actual-_____serviceName_____s = @remove-ids @exocom.received-messages![0].payload._____serviceName_____s
        expected-_____serviceName_____s = [lowercase-keys(_____serviceName_____) for _____serviceName_____ in table.hashes!]
        jsdiff-console actual-_____serviceName_____s, expected-_____serviceName_____s, done


  @Then /^the service replies with "([^"]*)" and the payload:$/, (message, payload, done) ->
    eval livescript.compile "expected-payload = {\n#{payload}\n}", bare: yes, header: no
    @exocom.wait-until-receive ~>
      actual-payload = @exocom.received-messages![0].payload
      jsdiff-console @remove-ids(actual-payload), @remove-ids(expected-payload), done
