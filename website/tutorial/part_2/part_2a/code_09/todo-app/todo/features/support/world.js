const ejs = require('ejs')


function World() {

  // Fills in todo ids in the placeholders of the template
  this.fillIntodoIds = function(template, done) {
    var neededIds = []
    ejs.render(template, {'idOf': (todo) => neededIds.push(todo) })
    if (neededIds.length === 0) return done(template)
    this.exocom.sendMessage({ service: 'todo',
                              name: 'todo.read',
                              payload: {name: neededIds[0]} })
    this.exocom.waitUntilReceive( () => {
      const id = this.exocom.receivedMessages()[0].payload.id
      done(ejs.render(template, { 'idOf': (todo) => id }))
    })
  }


  this.removeIds = function(payload) {
    for (let key in payload) {
      const value = payload[key]
      if (key === 'id' || key === '_id') {
        delete payload[key]
      } else if (typeof value === 'object') {
        payload[key] = this.removeIds(value)
      } else if (typeof value === 'array') {
        const temp = []
        for (const child in value) {
          temp.push(this.removeIds(child))
        }
        payload[key] = temp
      }
    }
    return payload
  }

}


module.exports = function() {
  this.World = World
}
