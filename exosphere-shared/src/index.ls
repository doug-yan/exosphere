require! {
  './logger' : Logger
  './docker-helper' : DockerHelper
  './call-args'
  './compile-service-routes'
  './normalize-path'
  './observable-docker-runner' : ObservableDockerRunner
  './kill-child-processes'
  'path'
}


module.exports = {
  call-args
  compile-service-routes
  Logger
  DockerHelper
  ObservableDockerRunner
  example-apps-path: path.join(__dirname, '..' 'example-apps')
  normalize-path
  kill-child-processes
  templates-path: path.join(__dirname, '..' 'templates')
}
