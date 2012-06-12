#!/usr/bin/env node
/**
Read in a CorePWN list from stdin and output a spreadsheet (CSV) file from two-sets WN relational linking data for validation.

Author: Mitchell Seaton
*/

// imports
var pg = require('pg'), fs = require('fs'), csv = require('csv'), hash = require('hashish'), util = require("util"), utile = require('utile');

var argv = require('optimist')
		.usage('Create validation spreadsheet.\nUsage: $0')
		.demand(['f', 't'])
		.alias('f', 'from')
		.alias('t', 'to')
		.alias('o', 'output')
		.alias('u', 'user')
    		.default('o', './output.csv')
		.default('v', 'andreord')		
		.default('w', 'false')
		.default('u', 'andreord')
		.argv;

// variables
var FROM_REL_PATH = argv.f,
    TO_REL_PATH = argv.t,
    OUTPUT_FILEPATH = argv.o,
    resultArray = new Array(),
    translations = new Array(),
    columns = ['pwn', 'wn_id', 'relation', 'score', 'gloss'],
    csv_delimiter = '\t',
    factor_from = argv._[0], factor_to = argv._[1], // DanNet syn_set id factor hard-corded here: 1000,
    pwnList = null;

// Postgres connection
var dbHost = "localhost",
dbPort = "5432",
dbUser = argv.u,
dbNameFrom = argv.v,
dbNameTo = argv.w; // --no-w as arg to make "false"

// Postgres clients
var clientTo = null,
clientFrom = null,
clientToStatus = true,
clientFromStatus = true;

// receive STDIN data
process.stdin.resume(); // listen for stdin data
process.stdin.on('data', function(chunk) {
	process.stdout.write('Received CorePWN data: ');
	pwnList = new String(chunk).split('\n'); // read stdin data and split into list
	
	if(clientTo == null && dbNameTo!="false") {
	  clientTo = clientConnection(dbNameTo);
	  clientTo.connect();
	  clientToStatus = false;
	  clientTo.on('drain', function () { clientTo.end.bind(onDrain(clientTo)) });
	}

	if(clientFrom == null && dbNameFrom!="false") {
	  clientFrom = clientConnection(dbNameFrom); 
	  clientFrom.connect();
	  clientFromStatus = false;
	  clientFrom.on('drain', function() { clientFrom.end.bind(onDrain(clientFrom)) }); // event that writes data output to file
	}

	// start import
	runFromWNCSV();
});
process.on('SIGTERM',function(){
        process.exit(1);
});

// FUNCTIONS
//-----------
// create a PG Client connection
var clientConnection = function(dbName) {
  connectionString = "pg://" + dbUser + "@" + dbHost + ":" + dbPort + "/" + dbName; // andreord@localhost:5432/andreord
    return new pg.Client(connectionString);
}

// Drain event handler
var onDrain = function(client) {
	console.log('drain called: ' + client);	
	if(clientFrom == client) clientFromStatus = true;
	if(clientTo == client) clientToStatus = true;
	if(clientFromStatus && clientToStatus) writeFiles();
	return client;
}

// PARSE WORDNET DATA
//--------------
// Receive from-target WN relations data: from_tr
var runFromWNCSV = function() {
	csv()
	.fromPath(FROM_REL_PATH,
	  {delimiter: csv_delimiter, 
	   columns: columns
	   })
	.transform(function(data) {
	  return data;
	})
	.on('data', function(data, index){
	  var idx = pwnList.indexOf(data['pwn']);
	  if(idx != -1)  {
		if(translations[idx] == null) {
		  translations[idx] = makeLayout(data);
		} else {
		  console.log('Repeat link found: ' + data['wn_id']);
		  var h = translations[idx];
		  if(h instanceof Array) {
		    translations[idx][h.length-1] = makeLayout(data);
		  } else { 
		    translations[idx] = new Array();
		    translations[idx][0] = h;
		    translations[idx][1] = makeLayout(data);
		  }
		}
	  }
	})
	.on('end', function(count){
	  runToWNCSV();
	})
	.on('error', function(err) {
	  process.stderr.write(err.message);
	})
}

// Receive to-target WN relations data: to_tr
var runToWNCSV = function() {
	csv()
	.fromPath(TO_REL_PATH,
	  {delimiter: csv_delimiter, 
	   columns: columns
	   })
	.transform(function(data) {
	  return data;
	})
	.on('data', function(data, index){
	  var idx = pwnList.indexOf(data['pwn']);
	  if(idx != -1 && translations[idx] != null) {
		if(translations[idx] instanceof Array) { 
		    // iterate over level-2 
		    utile.each(translations[idx], function(val, key, obj) { 
			if(val instanceof Array) {
			    // level-3
			    val[val.length-1] = val[0].clone;
			    updateHash(val[val.length-1], data);
			}
			else if(val.has('wn_id_from') && !val.has('wn_id_to')) {
			    // multiple from_ to to_
			    updateHash(val, data)
			} else {
			    // multiple from_ to multiple to_
			    var h = val;
		      	    obj[key] = new Array();
		      	    obj[key][0] = h;
		      	    obj[key][1] = h.clone;
		      	    updateHash(obj[key][1], data);
			}
		    });
		}
		else if(translations[idx].has('wn_id_from') && !translations[idx].has('wn_id_to'))
		    {  updateHash(translations[idx], data);  }
		else {
		  console.log('Repeat link found: ' + data['wn_id']);
		  var h = translations[idx];
		  translations[idx] = new Array();
		  translations[idx][0] = h;
		  translations[idx][1] = h.clone;
		  updateHash(translations[idx][1], data);
		}
	  }
	})
	.on('end', function(count){
	  console.log('translations len: ' + translations.length);

	  for(var i=0; i<translations.length; i++)
	    queryTraverse(translations[i]);
	})
	.on('error', function(err) {
	  process.stderr.write(err.message);
	})
}

// General layout of spreadsheet record
// @param data	  parsed from FROM source
// @return hash
var makeLayout = function(data) { 
	return hash({pwn_id: data['pwn'], wn_id_from : data['wn_id'], label_from: "", relation_from : data['relation'], gloss_from : ""})
}

// Postgres Query of AndreOrd DB for Gloss and Label syn_set data for WN(s)
var queryAndreOrd = function(syn_set_id, hash, client, isTarget) {
	if(client != null) {	
		var query_synsets = 'SELECT label, gloss FROM syn_sets ss where ss.id = $1';

		// PSQL query synsets
		//-----------------
		client.query(query_synsets, [syn_set_id], function(err, result) {
		  if(err) console.log(err);
		  else {
		    var label = "", gloss = "";

		    for(var i=0; i<result.rows.length; i++) {
		      if(gloss != result.rows[i].gloss && gloss != "") 
			console.log('gloss changed: ' + result.rows[i].gloss);
		      if(i==0) {
			gloss = result.rows[i].gloss;
		   	label = result.rows[i].label;
		      }

		    }
		    // Update with target (_from/_to) syn_set label and gloss data
		    if(hash != null)
			if(!isTarget)
		      	  hash.update({label_from: label, gloss_from: gloss});
			else {
			  hash.update({label_to: label, gloss_to: gloss});
			  process.nextTick(function(){ retrieveEngGloss(client, hash); });
			}		
		  }	
		});
	} else if(isTarget && clientFrom != null)
		process.nextTick(function(){ retrieveEngGloss(clientFrom, hash); });
}

var retrieveEngGloss = function(client, hash) {
 	var query_alignments = 'SELECT definition FROM alignments a WHERE a.key = $1';

	// PSQL query Alignments
   	//----------------------- 
	var pwn = hash.valuesAt('pwn_id');	
	client.query(query_alignments, [pwn], function(err, result) {
		if(err) console.log(err);
		else {
		  var definition = "";
		  for(var i=0; i<result.rows.length; i++)
		    definition = result.rows[i].definition;

		  console.log('CorePWN definition(' + pwn + '): ' + definition);

		  if(hash != null)
		    hash.update({en_gloss: definition});	// append English PWN gloss
		}
	})
}

// Update with target (_to) relation and syn_set label
var updateHash = function (hash, data) {
	if(hash instanceof Array) {
	  utile.each(hash, function(val, key, obj) {
	    updateHash(val, data);
	  });
	  return;
	} else {
	  if(data['relation'] == null) data['relation'] = "eq_synonym";
	  hash.update({wn_id_to: data['wn_id'], relation_to: data['relation']});
	  if(data['gloss'] != null) hash.update({gloss_to: data['gloss']});
	  else hash.update({gloss_to: ""});
	}
}

// PG client connections and translation tree traversal
var queryTraverse = function(translation) {
	if(translation instanceof Array) { 
	  utile.each(translation, function(val, key, obj) {
	    queryTraverse(val)
	  });
	} else {
	  translation.forEach(function (x, key) {
	    if(key.indexOf('wn_id_from') > -1) {
	      process.nextTick(function() { queryAndreOrd(x*factor_from, translation, clientFrom, false) });
	    }
	    if(key.indexOf('wn_id_to') > -1)
	      process.nextTick(function() { queryAndreOrd(x*factor_to, translation, clientTo, true); });
    	  });
	}
}


// OUTPUT DATA
//--------------

// Write out the results following PSQL queries
var writeFiles = function() {
	  for(var i=0; i<translations.length; i++)
	    addToResult(translations[i]);
	  writeCSV();
}

// Make a flat-list from the tree for CSV lib to parse
var addToResult = function(result) {
	if(result instanceof Array) 
	   utile.each(result, function(val, key, obj) { 
		process.nextTick(function() { 
			addToResult(val); 
			}); 
		});
	else resultArray.push(result.values);
	console.log('merged: ' + util.inspect(result.values, false)); 
}

// Write list output to file
var writeCSV = function() {
	// CSV
	//-----
	var validatecsv = csv()
	.from(resultArray)
	.toPath(OUTPUT_FILEPATH, 
	  {lineBreaks: 'unix', 
	   quote: '"'}) 
	.transform(function(data) {
	  return data;
	})
	.on('data', function(data, index) {
	  console.log('loading data at index: ' + index);
	  console.log('reading data: ' + util.inspect(data));
	})
	.on('end', function(count){
	  console.log("written " + count + " rows to " + OUTPUT_FILEPATH);
	  process.nextTick(function () {
	    process.exit(0);
	  });
	})
	.on('error', function(err) {
	  process.stderr.write(err.message);
	})
}

// END FUNCTIONS
//---------------
