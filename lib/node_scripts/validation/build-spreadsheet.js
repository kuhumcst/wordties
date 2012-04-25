#!/usr/bin/env node
/**
Read in CorePWN 1000 intersection list and pass as stdin to produce validation spreadsheet (CSV) file from two-sets WN relational linking data

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
    		.default('o', './output.csv')
		.argv;

// variables
var FROM_REL_PATH = argv.f;
    TO_REL_PATH = argv.t;
    OUTPUT_FILEPATH = argv.o;
    resultArray = new Array(),
    translations = new Array(),
    pwnList = null;

// Postgres connection
var connectionString = "pg://andreord@localhost:5432/andreord",
    client = new pg.Client(connectionString);

// receive STDIN data
process.stdin.resume(); // listen for stdin data
process.stdin.on('data', function(chunk) {
	process.stdout.write('Received CorePWN data: ');
	client.connect();
	client.on('drain', writeFiles); // event that writes data output to file

	pwnList = new String(chunk).split('\n'); // read stdin data and split into list
	runFromWNCSV();
});
process.on('SIGTERM',function(){
        process.exit(1);
});

// FUNCTIONS
//-----------
// Postgres Query for Gloss and Lemma data
var queryDanNet = function(syn_set_id, hash) {
	var query_join = 'SELECT label, gloss, lemma FROM syn_sets ss, word_senses ws, words w WHERE ss.id = ws.syn_set_id and ws.word_id = w.id and ss.id = $1',
	    query_alignments = 'SELECT definition FROM alignments a WHERE a.syn_set_id = $1 and a.key = $2';

	// PSQL query join
	//-----------------
	client.query(query_join, [syn_set_id], function(err, result) {
	  if(err) { console.log(err); }
	  else {
	    var lemmas = "", gloss = "";
	    for(var i=0; i<result.rows.length; i++) {
	      lemmas += result.rows[i].lemma;
	      if(gloss != result.rows[i].gloss && gloss != "") { console.log('gloss changed: ' + result.rows[i].gloss); }
	      if(i==0) {
		 gloss = result.rows[i].gloss;
	      	 label = result.rows[i].label;
	      }
	      if(i<result.rows.length-1) lemmas += "; ";
	    }
	    
	    // Update with target (_from) syn_set label and gloss
	    if(hash != null)
	      hash.update({label_from: label, gloss: gloss, lemmas: lemmas}); 
	  }		
	})

	// PSQL query Alignments
	//-----------------------
	client.query(query_alignments, [syn_set_id, hash.valuesAt('pwn_id')], function(err, result) {
	   if(err) { console.log(err); }
	   else {
		var definition = "";
		for(var i=0; i<result.rows.length; i++) {
		  definition = result.rows[i].definition;
		}

	    	console.log('CorePWN definition(' + syn_set_id + '): ' + definition + ' pwn: ' + hash.valuesAt('pwn_id'));
		
		if(hash != null)
	      	  hash.update({en_gloss: definition});	// append English PWN gloss
	   }
	})
}

// Write out the results following PSQL queries
var writeFiles = function(callback) {
	  for(var i=0; i<translations.length; i++)
	    addToResult(translations[i]);
	  writeCSV();
}

// Make a flat-list from the tree for CSV lib to parse
var addToResult = function(result) {
	if(result instanceof Array) utile.each(result, function(val, key, obj) { addToResult(val); });
	else resultArray.push(result.values);
	console.log('merged: ' + util.inspect(result.values, true)); 
}

// Write list output to file
var writeCSV = function() {
	// CSV
	//-----
	var validatecsv = csv()
	.from(resultArray)
	.toPath(OUTPUT_FILEPATH, {lineBreaks: 'unix', quote: '"'}) 
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

// WORDNET DATA
//--------------
// Receive from-target WN relations data: from_tr
var runFromWNCSV = function() {
	csv()
	.fromPath(FROM_REL_PATH,
	  {delimiter: '\t', 
	   columns: ['pwn', 'wn_id', 'relation', 'score']
	   })
	.transform(function(data) {
	  return data;
	})
	.on('data', function(data, index){
	  var idx = pwnList.indexOf(data['pwn']);
	  if(idx != -1)  {
		if(translations[idx] == null) {
		  translations[idx] = hash({pwn_id: data['pwn'], wn_id_from : data['wn_id'], label_from: "", relation_from : data['relation'], label_to : "", relation_to : ""});
		} else {
		  console.log('Repeat link found: ' + data['wn_id']);
		  var h = translations[idx];
		  if(h instanceof Array) {
		    translations[idx][h.length-1] = hash({pwn_id: data['pwn'], wn_id_from : data['wn_id'], label_from: "", relation_from : data['relation'], label_to : "", relation_to : ""});
		  } else { 
		    translations[idx] = new Array();
		    translations[idx][0] = h;
		    translations[idx][1] = hash({pwn_id: data['pwn'], wn_id_from : data['wn_id'], label_from: "", relation_from : data['relation'], label_to : "", relation_to : ""});
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

// Update with target (_to) relation and syn_set label
var updateHash = function (hash, data) {
	if(hash instanceof Array) {
	  utile.each(hash, function(val, key, obj) {
	    updateHash(val, data);
	  });
	  return;
	} else {
	  if(data['relation'] == null) data['relation'] = "eq_synonym";
	  hash.update({label_to: data['wn_id'], relation_to: data['relation']});
	}
}

// Tree traversal
var queryTraverse = function(translation) {
	if(translation instanceof Array) { 
	  utile.each(translation, function(val, key, obj) {
	    queryTraverse(val)
	  });
	} else {
	  translation.forEach(function (x, key) {
	    //console.log(key + ' => ' + x);
	    if(key == 'wn_id_from') { 
	      queryDanNet(x*1000, translation);
	    }
    	  });
	}
}

// Receive to-target WN relations data: to_tr
var runToWNCSV = function() {
	csv()
	.fromPath(TO_REL_PATH,
	  {delimiter: '\t', 
	   columns: ['pwn', 'wn_id']
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
			else if(val.has('label_from') && val.valuesAt('label_to')[0] != "") {
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
		else if(translations[idx].has('label_from') && translations[idx].valuesAt('label_to')[0] != "") {  updateHash(translations[idx], data);  }
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
	  for(var i=0; i<translations.length; i++) queryTraverse(translations[i]);
	})
	.on('error', function(err) {
	  process.stderr.write(err.message);
	})
}

// END FUNCTIONS
//---------------
