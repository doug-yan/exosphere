require! {
  'path'
  'fs'
  'js-yaml' : yaml
}

module.exports = (app-config, base-path) ->
  service-routes = []
  for protection-type of app-config.services
    for service-type, service-data of app-config.services["#{protection-type}"]
      service-config = yaml.safe-load fs.read-file-sync(path.join(base-path ? process.cwd!, service-data.location, 'service.yml'), 'utf8')
      service-routes.push do
        {
          service-type: service-type
          receives: service-config.messages.receives
          sends: service-config.messages.sends
          namespace: service-data.namespace
        }
  service-routes