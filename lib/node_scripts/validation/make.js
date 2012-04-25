#!/usr/bin/env node
/**
Read in CorePWN 1000 intersection list and pass as stdin to child process to produce validation spreadsheet from two-sets WN relational linking data

Author: Mitchell Seaton
*/
var argv = require('optimist')
		.usage('Create validation spreadsheet.\nUsage: $0 -l [list]')
		.demand(['l'])
		.alias('l', 'list')
		.alias('f', 'from')
		.alias('t', 'to')
		.alias('o', 'output')
		.default('f', '../../import/pwn_data/DanNet/eq_core.new.tsv') // from WN
		.default('t', '../../import/pwn_data/SweWN/pwn_synsets_links.tsv') // to WN
    		.default('o', './output.csv')
		.argv;

// imports
var spawn = require('child_process').spawn, fs = require('fs'), csv = require('csv');

// variables
var script = "build-spreadsheet.js";

// spawn new child_process
var next = spawn('node', [script, '-f', argv.f, '-t', argv.t, '-o', argv.o]);
next.stdout.on('data', function (data) {
  console.log(' ' + data);
});
next.stderr.on('data', function (data) {
  console.log('child process => stderr: ' + data);
});

// close main process
next.on('exit', function(code) {
  if(code !== 0)
    console.log('child process => exited with code (' + code + ')');
})

// exit event
process.on('exit', function(code) {
    console.log('Exiting...');
})

// gather CorePWN list and send to child_process input
// default path: git-repo:lib/import/pwn_data/common_data/corepwn_intersect_join.1k_avn.tsv; 
var path = argv.l;
var pwnArr = new Array();

// CSV
//-----
// read from TSV file
csv()
.fromPath(path,
  {delimiter: '\t',
   columns: ['pwn_id', 'freq']
  })
.toStream(next.stdin, 
{columns: ['pwn_id'], end: false}) // pass CorePWN ids to child process stdin
.transform(function(data) {
  return data;
})
.on('data', function(data, index){
  pwnArr[index] = data;
  console.log(JSON.stringify(data));
})
.on('end', function(count) { 
})
.on('error', function(err) {
  console.log(err.message);
})

