# requires
fs = require 'fs'
page = require('webpage').create()
system = require 'system'

if !system.args[1]
	console.warn 'Need to specify domain name'
	phantom.exit()

if !system.args[2]
	console.warn 'Need to specify output filename'
	phantom.exit()

page.open "http://#{system.args[1]}", (status) ->
	if status != 'success'
		console.log 'Unable to access network'
	else
		content = page.evaluate -> document.documentElement.outerHTML
		fs.write system.args[2], content, 'w'
	phantom.exit()

###
Sources
=======
http://stackoverflow.com/questions/9966826/save-and-render-a-webpage-with-phantomjs-and-node-js
http://stackoverflow.com/questions/817218/get-entire-document-html-as-string
###