#!/usr/bin/env node
var fs = require('fs'), csv = require('csv');

csv()
.fromPath('../import/pwn_data/DanNet/eq_core.csv',
  {delimiter: '@', 
   columns: ['wn_id', 'rel1', 'rel2', 'pwn', 'taxo', 'comment']
   })
.toPath('../import/pwn_data/eq_core.new.tsv', 
  {delimiter: '\t', 
   columns: ['pwn', 'wn_id', 'relation', 'score', 'freq']
   })
.transform(function(data) {
  data.relation = (data.rel2 == "eq_has_synonym") ? "eq_synonym" : data.rel2;
  data.score = 100;
  data.freq = -1;
  return data;
})
.on('data', function(data, index){
  console.log('#' + index + ':: ' + JSON.stringify(data));
})
.on('end', function(count){
  console.log('lines: ' + count);
})
.on('error', function(err) {
  console.log(err.message);
});
