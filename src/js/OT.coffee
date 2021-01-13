# TB Object:
#   Methods:
#     TB.checkSystemRequirements() :number
#     TB.initPublisher( apiKey:String [, replaceElementId:String] [, properties:Object] ):Publisher
#     TB.initSession( apiKey, sessionId ):Session
#     TB.log( message )
#     TB.off( type:String, listener:Function )
#     TB.on( type:String, listener:Function )
#  Methods that doesn't do anything:
#     TB.setLogLevel(logLevel:String)
#     TB.upgradeSystemRequirements()

window.cordovaOT =
  checkSystemRequirements: ->
    return 1
  initPublisher: (one, two, callback) ->
    return new TBPublisher( one, two, callback )
  initSession: (apiKey, sessionId ) ->
    if( not sessionId? ) then @showError( "cordovaOT.initSession takes 2 parameters, your API Key and Session ID" )
    return new TBSession(apiKey, sessionId)
  log: (message) ->
    pdebug "TB LOG", message
  getDevices: -> [
    { deviceId: "FAKEDEVICEID779BA001D1B7A638EB320103F0EF", kind: "audioinput", label: "iPad Micro", groupId: "" },
    { deviceId: "FAKEDEVICEID08BADAB2A7D7EB3FEDB0BA373C06", kind: "videoinput", label: "Front Camera", groupId: "" },
    { deviceId: "FAKEDEVICEID82EF36372A93FBCFB2CEB8900CEB", kind: "videoinput", label: "Back Camera", groupId: "" },
  ]
  getUserMedia: -> Promise.resolve({
    getVideoTracks: -> [{ name: 'Fake video track', stop: -> true }],
    getAudioTracks: -> [{ name: 'Fake audio track', stop: -> true }],
    getTracks: -> [
      { name: 'Fake audio track', stop: -> true },
      { name: 'Fake video track', stop: -> true },
    ],
  }) # accept the devices permissions
  off: (event, handler) ->
    #todo
  on: (event, handler) ->
    if(event=="exception") # TB object only dispatches one type of event
      console.log("JS: TB Exception Handler added")
      Cordova.exec(handler, TBError, OTPlugin, "exceptionHandler", [] )
  setLogLevel: (a) ->
    console.log("Log Level Set")
  upgradeSystemRequirements: ->
    return {}
  updateViews: ->
    TBUpdateObjects()

  # helpers
  getHelper: ->
    if(typeof(jasmine)=="undefined" || !jasmine || !jasmine['getEnv'])
      window.jasmine = {
        getEnv: ->
          return
      }
    this.OTHelper = this.OTHelper || OTHelpers.noConflict()
    return this.OTHelper

  # deprecating
  showError: (a) ->
    alert(a)
  addEventListener: (event, handler) ->
    @on( event, handler )
  removeEventListener: (type, handler ) ->
    @off( type, handler )

window.cordovaTB = cordovaOT
window.addEventListener "orientationchange", (->
  setTimeout (->
    cordovaOT.updateViews()
    return
  ), 1000
  return
), false
