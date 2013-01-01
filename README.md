Alexa Peek
==========


Usage
-----
### Synchronous code block
```coffeescript
benchit.one ->
	...
# (will return elapsed time in milliseconds)
```

### Asynchronous code block
```coffeescript
benchit.one (done) ->
	...
	done() # call when finished
, (elapsed) ->
	console.log elapsed
```

### Multiple code blocks
```coffeescript
benchit.many
	synchronousCode: ->
		...

	asynchronousCode: (done) ->
		...
		done() # call when finished
, (name, elapsed) -> console.log "#{name} elapsed: #{elapsed}ms"

###
Output:
synchronousCode elapsed: 100ms
asynchronousCode elapsed: 200ms

(note: 2nd parameter is optional)
###
```