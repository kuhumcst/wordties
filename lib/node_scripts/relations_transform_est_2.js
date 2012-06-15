#!/usr/bin/env node
var fs = require('fs'), csv = require('csv');

var labels = new Array();

// Load synsets/lemmas
csv()
.fromPath('../import/pwn_data/EstWN/EstWN/Variants.csv',
  {delimiter: '@', escape: '\\',
   columns: true
   })
.transform(function(data) {
  return data;
})
.on('data', function(data, index){
  var gloss = "";
  if(data.gloss != null && data.gloss != "None") gloss = "(" + data.literal + ") " + data.gloss + "; ";
  if(labels[data.synset_number] == null)
    labels[data.synset_number] = [new String(data.literal + "_" + data.sense), new String(gloss)];
  else 
    labels[data.synset_number] = [labels[data.synset_number][0] + " " + data.literal + "_" + data.sense, labels[data.synset_number][1] + gloss];

  console.log('synset label (' + data.synset_number + '): ' + labels[data.synset_number] + " gloss: " + gloss);
})
.on('end', function(count){
  loadRelations();
})
.on('error', function(err) {
  console.log(err.message);
});

// Load Relations and transform synset ID to label
var loadRelations = function() {
	csv()
	.fromPath('../import/pwn_data/EstWN/core_est.tsv',
	  {delimiter: '\t', 
	   columns: ['pwn', 'synset_no', 'relation', 'score', 'gloss'] 
	   })
	.toPath('./core_est.new.csv')
	.transform(function(data) {
	  console.log('finding label: ' + data.synset_no);
	  var label = findLabel(data.synset_no);
	  data.synset_no = label[0];
	  data.gloss = label[1];
	  
	  return data;
	})
	.on('data', function(data, index){
	})
	.on('end', function(count){
	})
	.on('error', function(err) {
	  console.log(err.message);
	});
}

// Return synset label
var findLabel = function(synset) { 
  return labels[synset];
}
