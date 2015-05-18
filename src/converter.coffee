fs = require 'fs'
through = require 'through'

showUsage = (err) ->
  if err
    console.error err.stack + '\n'
  
  console.log "Usage: [encode|decode] inputFile outputFile"
  err

DEBUG = 0
ENCODE = 'encode'
DECODE = 'decode'

action = process.argv[2]?.toLowerCase()
inputFilePath = process.argv[3]?.trim()
outputFilePath = process.argv[4]?.trim()
hasError = null

#DEBUG
console.log "action = ", action
console.log "inputFilePath = ", inputFilePath
console.log "outputFilePath = ", outputFilePath

if not inputFilePath
  hasError = new Error "Input file path cannot be empty."
else if not outputFilePath
  hasError = new Error "Output file path cannot be empty."
else if inputFilePath is outputFilePath
  hasError = new Error "Input and output file paths cannot be the same"

try
  inputFileStats = fs.statSync inputFilePath 
catch err
  console.error "Input file cannot be found."
  hasError = err

if not inputFileStats.isFile()
  hasError = new Error "Input file path must refer to a file."

if not hasError
  readStream =
    switch action
      when ENCODE
        fs.createReadStream inputFilePath, {
          encoding: 'base64'
        }
        .on 'error', (err) ->
          if err.code is 'ENOENT'
            console.error "Input file not found."
          else
            console.error "Unable to read input file."
          throw err

      when DECODE
        fs.createReadStream inputFilePath, { encoding: 'ascii' }
        .on 'error', (err) ->
          console.error "Unable to access output file."
          throw err

        .pipe through (data) ->
          if DEBUG
            console.log "2 decode: #{data.length} bytes"
            # console.log "2 read: #{data.toString 'utf8'}"

          # decode to base 64
          decodedStr = new Buffer data, 'base64'

          # if DEBUG
          #   console.log "2 read: base64str = #{decodedStr.toString 'utf8'}"

          @emit 'data', decodedStr
        .on 'error', (err) ->
          console.error "Decoding error."
          throw err

      else
        hasError = new Error "Unrecognised action. Current value is \"#{action}\"."

  if readStream
    return readStream.pipe fs.createWriteStream outputFilePath
      .on 'error', (err) ->
        console.error "Unable to write into output file."
        throw err

showUsage hasError
process.exit 1