require! {
  'cucumber': {defineSupportCode}
  './world': World
  '../../../exosphere-shared' : {DockerHelper, kill-child-processes}
  'cucumber': {defineSupportCode}
  './world': World
}


defineSupportCode ({After, set-default-timeout, set-world-constructor}) ->

  set-default-timeout 2000

  set-world-constructor World

  After (scenario, done) ->
    kill-child-processes ->
      DockerHelper.remove-containers done
