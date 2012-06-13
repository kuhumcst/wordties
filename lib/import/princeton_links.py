# Imports
from nltk.corpus.reader.wordnet import WordNetError
from nltk.corpus import wordnet
from sqlalchemy import create_engine, Table, Column, Integer, String, MetaData, ForeignKey
from sqlalchemy.orm.session import sessionmaker
from sqlalchemy.schema import Sequence
from optparse import OptionParser

# Options Parser (note: deprecated since 2.7)
parser = OptionParser()
parser.add_option("-f", "--file", dest="filename", help="file to parse", metavar="FILE")
parser.add_option("-s", "--source", dest="source", help="defined alignment source", metavar="SOURCE", default="wordnet30")
parser.add_option("-t", "--through", dest="through", help="defined through translation", metavar="SOURCE", default=None)
parser.add_option("-n", "--factor", dest="factor", help="syn_set factor for database", metavar="FACTOR", default=1)
parser.add_option("-m", "--factor2", dest="parent_factor", help="parent syn_set factor for database", metavar="FACTOR", default=1)
parser.add_option("-v", "--verbose", action="store_true", dest="verbose")

# FILENAME
# options.filename sample 
# /home/seaton/git/andreord-public/lib/import/pwn_data/FinWN/corewn-fiwn-sensemap-pwnssids.tsv

# SOURCES 
# options.source samples
# wordnet30
# dannet21

# FACTOR
# options.factor sample
# DanNet 1000

(options, args) = parser.parse_args()

if options.source == options.through:
	parser.error("Source cannot be the same as Through Source")

# Database session
engine = create_engine('postgresql://andreord:andreord@localhost/andreord', echo=False)
Session = sessionmaker(bind=engine)
metadata = MetaData(bind=engine)

# Alignments Table
alignments = Table('alignments', metadata,
                   Column('id', Integer, Sequence('alignments_id_seq'), primary_key=True),
                   Column('source', String),
                   Column('lemma', String),
                   Column('definition', String),
                   Column('synonyms', String),
                   Column('key', String),
                   Column('relation_type_name', String),
                   Column('syn_set_id', ForeignKey('syn_sets.id')),
		   Column('through_source', String),
		   Column('ext_syn_set_id', Integer)
)
session = Session()

# Open file
f=open(options.filename)

for line in f.readlines():
    record = line.split("\t")
    relation = record[2] if options.source == "wordnet30" else record[4]

    if relation in ('eq_synonym', 'eq_has_hyponym', 'eq_has_hyperonym', 'eq_near_synonym'): 
        if options.source == "wordnet30":
		target, source, parent_source = record[0], record[1], -1 
	else: 
		target, source, parent_source = record[0], record[1], record[2]
        
	if target.startswith("EN"):
            pass
        else:
            try:
		# load data from NLTK Wordnet package
		if options.source == "wordnet30":             
			lemma = wordnet.lemma_from_key(target)
                	synset = lemma.synset
			definition, lemmas, lemma_name = synset.definition, "; ".join(synset.lemma_names), lemma.name
		# load data from source file
		else:
			lemmas, definition, lemma_name = record[3], record[5], record[3].split(";")[0].strip()
		
		print "input factor: ", options.parent_factor
		if parent_source>-1:
			ext_syn_set_id = int(parent_source)*int(options.parent_factor)
		else: 
			ext_syn_set_id = None

		if options.verbose: 
			print "Inserting alignment for CorePWN key (" + target + ") with {relation} " + relation, " {parent_source} ", parent_source, " {ext id} ", ext_syn_set_id            
		# insert statement   
 
		ins = alignments.insert().values(source=options.source,
                                           lemma=lemma_name,
                                           definition=definition,
                                           synonyms=lemmas,
                                           key=target,
                                           relation_type_name=relation,
					   syn_set_id=int(source)*int(options.factor), 
					   through_source=options.through,
					   ext_syn_set_id=ext_syn_set_id
					   )
                engine.execute(ins)
            except WordNetError as e:
                print e

