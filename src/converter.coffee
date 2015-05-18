fs = require 'fs'
through = require 'through'

showUsage = (err) ->
  console.error err.stack if err
  console.log "Usage: [encode|decode] inputFile outputFile"

DEBUG = 0
ENCODE = 'encode'
DECODE = 'decode'

action = process.argv[2]?.toLowerCase()
inputFilePath = process.argv[3]?.trim()
outputFilePath = process.argv[4]?.trim()

#DEBUG
console.log "action = ", action
console.log "inputFilePath = ", inputFilePath
console.log "outputFilePath = ", outputFilePath

if inputFilePath is outputFilePath
  throw new Error "Input and output file paths cannot be the same"

readStream =
  switch action
    when ENCODE
      fs.createReadStream inputFilePath, {
        encoding: 'base64'
      }
      .on 'error', showUsage

    when DECODE
      fs.createReadStream inputFilePath, { encoding: 'ascii' }
      .on 'error', showUsage
      .pipe through (data) ->
        if DEBUG
          console.log "2 decode: #{data.length} bytes"
          # console.log "2 read: #{data.toString 'utf8'}"

        # decode to base 64
        decodedStr = new Buffer data, 'base64'

        # if DEBUG
        #   console.log "2 read: base64str = #{decodedStr.toString 'utf8'}"

        @emit 'data', decodedStr
      .on 'error', showUsage

    else
      showUsage new Error "Unrecognised action (#{action}"

readStream.pipe fs.createWriteStream outputFilePath