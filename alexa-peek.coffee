# requires
cheerio = require 'cheerio'
cp = require 'child_process'
csv = require 'csv'
fs = require 'fs'
path = require 'path'
promqueen = require 'promqueen'
request = require 'request'
unzip = require 'unzip'

# constants
maxTopSites = 10

# fixed constants
downloadUrl = 'http://s3.amazonaws.com/alexa-static/top-1m.csv.zip'
zipFileName = 'top-1m.csv.zip'
csvFileName = 'top-1m.csv'

# functions
many = promqueen.many
promoteCallback = promqueen.promoteCallback
promoteErrCallback = promqueen.promoteErrCallback
promoteEvent = promqueen.promoteEvent

exists = promoteCallback fs.exists
mkdirIgnoreErr = promoteCallback fs.mkdir
readFile = promoteErrCallback fs.readFile

padNumber = (number, width) ->
	string = number.toString()
	zerosRequired = width - string.length
	if zerosRequired > 0
		return new Array(zerosRequired + 1).join('0') + string
	else
		return string

# main
mkdirPromise = mkdirIgnoreErr 'results'

downloadAndUnzipPromise = exists(zipFileName).then (exists) ->
	if not exists
		console.log "Downloading #{zipFileName}..."
		downloadAlexaStream = fs.createWriteStream zipFileName
		request(downloadUrl).pipe(downloadAlexaStream)
		return promoteEvent(downloadAlexaStream, 'close', 'error')
	else
		return true

.then (alreadyExists) ->
	console.log 'Downloaded.' if not alreadyExists
	return exists csvFileName

.then (exists) ->
	if not exists 
		console.log "Unzipping #{zipFileName}..."
		unzipStream = fs.createReadStream zipFileName
		unzipStream.pipe unzip.Extract
			path: '.'
		return promoteEvent(unzipStream, 'close', 'error')
	else
		return true

.then (alreadyUnzipped) ->
	console.log 'Unzipped.' if not alreadyUnzipped

many([
	mkdirPromise
	downloadAndUnzipPromise
]).then ->
	width = maxTopSites.toString().length
	csv()
	.from.stream(fs.createReadStream(csvFileName))
	.on 'record', (data, index) ->
		if data[0] <= maxTopSites
			htmlFileName = "results/#{data[1]}.html"
			url = "http://#{data[1]}"

			exists(htmlFileName).then (exists) ->
				if not exists
					console.log "Getting URL #{url}..."
					p = cp.spawn 'phantomjs', [ 'phantom-render-page.coffee', url, htmlFileName ]
					return promoteEvent p, 'exit'
			.then (alreadyExists) ->
				return readFile htmlFileName
			.then (err, data) ->
				$ = cheerio.load data
				console.log url
				console.log Array(url.length + 1).join '='

				metaDescription = $('meta[name="description"]')

				if metaDescription.length == 0
					console.log 'No META description'
				else
					console.log "Description #{metaDescription.attr('content')}"

				console.log ''
			.fail (err) ->
				console.warn "ERROR: #{err}"

		else
			this.end()