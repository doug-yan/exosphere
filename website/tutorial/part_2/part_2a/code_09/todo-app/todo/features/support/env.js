process.env.NODE_ENV = 'test'
const {MongoClient} = require('mongodb'),
      N = require('nitroglycerin')


var db = null
const getDb = (done) => {
  if (db) return done(db)
  MongoClient.connect("mongodb://localhost:27017/exosphere-todo-service-test", N( (mongoDb) => {
    db = mongoDb
    done(db)
  }))
}


module.exports = function() {

  this.setDefaultTimeout(1000)


  this.Before( function(_scenario, done) {
    getDb( (db) => {
      db.collection('todos').drop()
      done()
    })
  })


  this.After(function() {
    this.exocom && this.exocom.close()
    this.process && this.process.close()
  })


  this.registerHandler('AfterFeatures', (_event, done) => {
    getDb( (db) => {
      db.collection('todos').drop()
      db.close()
      done()
    })
  })

}
