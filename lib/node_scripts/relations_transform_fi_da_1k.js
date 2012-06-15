#!/usr/bin/env node
var fs = require('fs'), csv = require('csv');

csv()
.fromPath('../import/pwn_data/common_data/1k_final/FinnDannValidation_final_v2.csv',
  {delimiter: ',', 
   columns: ['pwn_key', 'syn_set_id_1', 'label_1', 'rel_1', 'gloss_1', 'syn_set_id_2', 'rel_2', 'label_2', 'gloss_2', 'pwn_gloss']
   })
.toPath('../import/pwn_data/common_data/1k_final/FinnDannValidation_final_import_parentsyn.tsv', 
  {delimiter: '\t', 
   columns: ['pwn_key', 'syn_set_id_1', 'syn_set_id_2', 'label_2', 'rel_2', 'gloss_2']
   })
.transform(function(data) {
   data['label_2'] = data['label_2'].replace(/[,{}_0-9]+/g, '');
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
