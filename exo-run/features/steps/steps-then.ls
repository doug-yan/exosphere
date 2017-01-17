require! {
  'async'
  'chai' : {expect}
  'child_process'
  'jsdiff-console'
  'nitroglycerin' : N
  'prelude-ls' : {last}
  'request'
  'wait' : {wait}
}


module.exports = ->

  @Then /^ExoCom uses this routing:$/ timeout: 10_000, (table, done) ->
    expected-routes = {}
    for row in table.hashes!
      expected-routes[row.COMMAND] or= {}
      for receiver in row.RECEIVERS.split(', ')
        (expected-routes[row.COMMAND].receivers or= []).push name: receiver
    exocom-port = child_process.exec-sync('docker port exocom') |> (.to-string!) |> (.split ':') |> last |> (.trim!)
    wait 10, ~> # Wait to ensure services have time to be registered by ExoCom
      request "http://localhost:#{exocom-port}/config.json", N (response, body) ->
        expect(response.status-code).to.equal 200
        actual-routes = JSON.parse(body).routes
        for _, data of actual-routes
          for receiver in data.receivers
            delete receiver.port
            delete receiver.internal-namespace
        jsdiff-console actual-routes, expected-routes, done


  @Then /^it has printed "([^"]*)" in the terminal$/ (expected-text) ->
    expect(@process.full-output!).to.contain expected-text


  @Then /^I see:$/ (expected-text) ->
    expect(@process.full-output!).to.contain expected-text


  @Then /^it prints "([^"]*)" in the terminal$/ timeout: 60_000, (expected-text, done) ->
    @process.wait expected-text, done


  @Then /^the "([^"]*)" service restarts$/ (service, done) ->
    @process.wait "Restarting service '#{service}'", done


  @Then /^my machine is running ExoCom$/ timeout: 10_000, (done) ->
    @process.wait /exocom  ExoCom \d+\.\d+\.\d+ WebSocket listener online at port/, done


  @Then /^my machine is running the services:$/ timeout: 10_000, (table, done) ->
    async.each [row['NAME'] for row in table.hashes!],
               ((name, cb) ~> @process.wait "'#{name.to-lower-case!}' is running", cb),
               done


  @Then /^the "([^"]*)" service receives a "([^"]*)" message$/ (service, message, done) ->
    @process.wait "'#{service}' service received message '#{message}'", done
