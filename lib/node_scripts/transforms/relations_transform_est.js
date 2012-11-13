#!/usr/bin/env node
var fs = require('fs'), csv = require('csv');

csv()
.fromPath('../../import/pwn_data/EstWN/core_est.csv',
  {delimiter: ' ', 
   columns: ['pwn', 'synset_no', 'relation', 'score'] 
   })
.toPath('../../import/pwn_data/common_data/core_est.tsv', 
  {delimiter: '\t', 
   columns: ['pwn', 'synset_no', 'relation', 'score', 'freq']
   })
.transform(function(data) {
  // no frequency data
  data.score = Math.floor(data.score)
  data.freq = -1;
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
