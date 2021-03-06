parseArgs = require 'minimist'
UebersichtServer = require './src/app.coffee'
cors_proxy = require 'cors-anywhere'

handleError = (err) ->
  console.log(err.message || err)
  throw err

try
  args = parseArgs process.argv.slice(2)
  widgetPath = args.d ? args.dir  ? './widgets'
  port = args.p ? args.port ? 41416
  settingsPath = args.s ? args.settings ? './settings'
  options =
    loginShell: args['login-shell']

  server = UebersichtServer(Number(port), widgetPath, settingsPath, options, ->
    console.log 'server started on port', port
  )
  server.on 'close', handleError
  server.on 'error', handleError

  cors_host = '127.0.0.1' # bind to loopback only
  cors_port = port + 1
  cors_proxy.createServer(
    originWhitelist: ['http://127.0.0.1:' + port]
    requireHeader: ['origin']
    removeHeaders: ['cookie']
  ).listen(cors_port, cors_host, ->
    console.log 'CORS Anywhere on port', cors_port
  )

catch e
  handleError e

