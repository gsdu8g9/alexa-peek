Alexa Peek
==========
After checking out <http://www.httparchive.org>, I was inspired to write some scraping code to perform an analysis of the top listed Alexa websites.  At the moment, I haven't thought of anything interesting to analyse yet.  It grabs the top 10 listed Alexa websites and prints out their META description using cheerio.

It would prove a useful starting point for anyone wanting to scrape webpages for any reason, hence I've put it up here.

As the web is so dynamic these days, I utilised phantomjs to get the rendered webpage, not the source webpage.

Requirements
------------
* Requires nodejs, CoffeeScript & phantomjs installed

Usage
-----
```bash
npm install
coffee alexa-peek.coffee
```
