require! {
  '../../../exosphere-shared' : {templates-path, run-process}
  'fs-extra' : fs
  'path'
  'tmplconv'
}



World = !->

  @create-empty-app = (app-name) ->
    @app-dir = path.join process.cwd!, 'tmp', app-name
    fs.empty-dir-sync @app-dir
    data =
      'app-name': app-name
      'app-description': 'Empty test application'
      'app-version': '1.0.0'
      'exocom-version': '0.22.1'
    src-path = path.join templates-path, 'create-app'
    tmplconv.render(src-path, @app-dir, {data})

  @run = (command) ->
    @process = run-process path.join(process.cwd!, 'bin', command), @app-dir


module.exports = World
