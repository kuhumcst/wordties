#!/usr/bin/env node
var fs = require('fs'), csv_node = require('csv'), util = require('util'), hash = require('hashish');

var path = '../../import/pwn_data/EstWN/EstWN/',
	delimiter = '@', escape = '\\', ext = '.csv',
	input_files = ["Variants", "Synsets", "Relations"],
	output_files = ["synsets", "words", "wordsenses", "relations"],
	tVariantsFinished = false, 
	tSynsetsFinished = false, 
	tRelationsFinished = false,
	target_dir = '../../import/pwn_data/EstWN/EstWNAndreOrd';

var tVariants = new Array(), tSynsets = new Array(), tRelations = new Array(), synsets = new Array(), senses = new Array(), sensesObj = new Object(null);

var convertPOStoString = function(pos) {
	switch(pos) {
	  case 'v':  return 'Verb';
	  case 'n':  return 'Noun';
	  case 'a': return 'Adjective';
	  default: return 'undefined';
	}
}

// Read a CSV file
var csvCall = function(filename) {
	var csv = csv_node()
	.fromPath(path+filename,
	  {delimiter: delimiter, escape: escape,
	   columns: true
	   });
	
	return csv;
}
// Transform fns
var transformVariants = function(csv, store) {
	
	//Load synsets/lemmas
	csv.transform(function(data) {
		  return data;
	})
	.on('data', function(data, index){
	  //console.log('data: ' + data.literal + ' i: ' + index);
	  var gloss = "";
	  var label = data.literal + "_" + data.sense;
	  
	  // read literals make Words array, ref synset, sense ids
	  sensesObj[label] = {synset_id: data.synset_number}; // mapping for targeting relations
	  senses.push({"word_id": data.synset_number + (data.literal_id + "-" + data.sense), "sense": data.sense, "synset_id": data.synset_number, "literal": data.literal });
	  	  
	  if(data.gloss == "None" || data.gloss == null) gloss = null;
	  else gloss = "(" + data.literal + ") " + data.gloss;
	  
	  if(!Array.isArray(store[data.synset_number])) {
	    store[data.synset_number] = [label, gloss];
	  } else {
	    if(gloss != null) {
		gloss = (store[data.synset_number][1] != null) ? store[data.synset_number][1] + "; " + gloss : gloss;
		if(store[data.synset_number][1] != null && data.synset_number == 4801) 
			console.log(data.synset_number +  ":" + data.gloss + ":" + gloss)
	    } else { 
		gloss = store[data.synset_number][1]; 
	    }
		
	    store[data.synset_number] = [store[data.synset_number][0] + "; " + label, gloss];
	  }
	  
	  synsets[data.synset_number] = {"id": data.synset_number, "label": "{"+store[data.synset_number][0]+"}", "gloss": store[data.synset_number][1]};
	})
	.on('end', function(count){
	  console.log("FINISHED VARIENTS LOAD: " + count + " senses:" + senses.length);
	  tVariantsFinished = true;
	})
	.on('error', function(err) {
	  console.log(err.message);
	});
}
var transformSynsets = function(csv, store) {
	csv.transform(function(data) {
		  return data;
	})
	.on('data', function(data, index){
		store[data.number] = data.pos;
	})
	.on('end', function(count){
		console.log("FINISHED SYNSETS LOAD: " + count);
		tSynsetsFinished = true;
	})
	.on('error', function(err) {
	  console.log(err.message);
	});
}
var transformRelations = function(csv, store) { 
	csv.transform(function(data) {
		  return data;
	})
	.on('data', function(data, index){
		store[data.relation_id] = data;
	})
	.on('end', function(count) {
		console.log("FINISHED RELATIONS LOAD: " + count);
		tRelationsFinished = true;
	})
	.on('error', function(err) {
	  console.log(err.message);
	});
}
var writeSynsets = function(mySynsets) {
	console.log("Writing to synsets file..." + mySynsets.length);
	csv_node().from(mySynsets).toPath(target_dir + '/' + output_files[0] + ext, { delimiter:delimiter, lineBreaks: '@\r\n', columns: ['id', 'label', 'gloss', 'feature']})
		.transform(function(data) {
			if(data.gloss == null || data.gloss == "") data.gloss = "None";
			data.feature = "Underspecified";
			return data;
		})
		.on('data', function(data, i) { 
			//console.log('index#' + i + " synset#" + data.label); 
		})
		.on('error',function(error) {
		    console.log(error.message);
		});
}
var writeSenses = function(mySenses) {
	console.log("Writing to synsets file..." + mySenses.length);
	csv_node().from(mySenses).toPath(target_dir + '/' + output_files[2] + ext, {delimiter:delimiter, lineBreaks: '@\r\n', columns: ['ddo_id', 'word_id', 'synset_id', 'register']})
		.transform(function(data, index) {
			data.register = "";
			data.ddo_id = index;
			return data;
		})
		.on('data', function(data, i) { 
			//console.log('word_senses id#' + i + " word_id#" + data.word_id); 
		})
		.on('error',function(error) {
		    console.log(error.message);
		});
}

var writeWords = function(mySynsets, mySenses) {
	console.log("Writing to words file..." + mySenses.length);
	
	csv_node().from(mySenses).toPath(target_dir + '/' + output_files[1] + ext, {delimiter:delimiter, lineBreaks: '@\r\n', columns: ['word_id', 'literal', 'pos']})
		.transform(function(data) {
			data.pos = convertPOStoString(mySynsets[data.synset_id]);
			return data;
		})
		.on('data', function(data, i) { 
			//console.log('words id#' + data.word_id + " literal#" + data.literal); 
		})
		.on('error',function(error) {
		    console.log(error.message);
		});
}

var writeRelations = function(myRelations) {
	console.log("Writing to relations file..." + myRelations.length);
	
	csv_node().from(myRelations).toPath(target_dir + '/' + output_files[3] + ext, { delimiter:delimiter, lineBreaks: '@\r\n', columns: ['synset_number', 'name', 'name_2', 'target_number', 'taxonomic', 'comment'] })
		.transform(function(data) {
			var target = sensesObj[data.target_literal + "_" + data.target_sense];
			data.target_number = (target != null) ? target.synset_id : null;
			data.name_2 = data.name;
			data.taxonomic = "";
			data.comment = "";
			return data;
		})
		.on('data', function(data, i) { 
			//console.log('relations from#' + data.synset_number + " to#" + data.target_number + " relname#" + data.name); 
		})
		.on('error',function(error) {
		    console.log(error.message);
		});
}

var writeNewFiles = function() {
	// state check
	if(!tVariantsFinished || !tSynsetsFinished || !tRelationsFinished) process.nextTick(writeNewFiles);
	else { 
		console.log("Writing to new format...");
		// write out new files
		writeSynsets(synsets);
		writeWords(tSynsets, senses);
		writeSenses(senses);
		writeRelations(tRelations);
	}
}

// main
for(var i in input_files) {
	var file = input_files[i];
	console.log("Reading CSV files..." + file + ext);
	var csv = csvCall(file + ext);
	var f = input_files;
	switch(file) {
		case f[0]: transformVariants(csv, tVariants); break;
		case f[1]: transformSynsets(csv, tSynsets); break; 
		case f[2]: transformRelations(csv, tRelations); break;
		default:
	}
}

process.nextTick(writeNewFiles);
