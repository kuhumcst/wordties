#!/usr/bin/env node
var fs = require('fs'), csv = require('csv');

csv()
.fromPath('../../import/pwn_data/FinWN/corewn-fiwn-sensekeymap-sortfreq.tsv',
  {delimiter: '\t', 
   columns: ['pwn', 'pwn_synset_id_1', 'pwn_synset_id_2', 'fi_synset_id_1', 'sense_id', 'rel', 'freq_1', 'freq_2']
   })
.toPath('../../import/pwn_data/corewn-fiwn-sensekeymap-sortfreqsum.new.tsv', 
  {delimiter: '\t', 
   columns: ['pwn', 'fi_synset_id_1', 'rel', 'score', 'freq_2']
   })
.transform(function(data) {
  data.relation = (data.rel == "eq_has_synonym") ? "eq_synonym" : data.rel;
  data.score = 100;
  return data;
})
.on('data', function(data, index){
  if(index == 0) console.log('#' + index + ':: ' + JSON.stringify(data));
})
.on('end', function(count){
  console.log('transformed lines: ' + count);
})
.on('error', function(err) {
  console.log(err.message);
});
