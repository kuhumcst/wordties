# Imports
from nltk.corpus.reader.wordnet import WordNetError
from nltk.corpus import wordnet
from sqlalchemy import create_engine, Table, Column, BigInteger, Integer, String, Text, DateTime, MetaData, ForeignKey
from sqlalchemy.orm.session import sessionmaker
from sqlalchemy.schema import UniqueConstraint
from sqlalchemy.schema import Sequence
from sqlalchemy.exc import IntegrityError
from optparse import OptionParser
import datetime
import uuid

# Options Parser (note: deprecated since 2.7)
parser = OptionParser()
parser.add_option("-f", "--file", dest="filename", help="file to parse", metavar="FILE")
parser.add_option("-s", "--source", dest="source", help="defined alignment source", metavar="SOURCE", default="wordnet30")
parser.add_option("-t", "--through", dest="through", help="defined through translation", metavar="SOURCE", default=None)
parser.add_option("-n", "--factor", dest="factor", help="syn_set factor for database", metavar="FACTOR", default=1)
parser.add_option("-m", "--factor2", dest="parent_factor", help="parent syn_set factor for database", metavar="FACTOR", default=1)
parser.add_option("-l", "--lang", dest="lang", help="define locale", metavar="LANG", default="en")
parser.add_option("-u", "--uri", dest="uri", help="define instance uri location", metavar="URI", default="")
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

# Variables
delimiter = "\t"
PWN_id = "wordnet30"

# Database session
engine = create_engine('postgresql://andreord@localhost/andreord-ord', echo=False)
Session = sessionmaker(bind=engine)
metadata = MetaData(bind=engine)

# Alignments Table

syn_sets = Table('syn_sets', metadata,
		Column('id', BigInteger, primary_key=True),
		Column('label', Text, nullable=False),
		Column('gloss', Text),
		Column('usage', Text),
		Column('hyponym_count', Integer)
)

instances = Table('instances', metadata,
		Column('id', Integer, Sequence('instances_id_seq'), primary_key=True),
		Column('uri', String(255)),
		Column('last_uptime', DateTime, onupdate=datetime.datetime.now())
)

sources = Table('sources', metadata,
		Column('id', String(255), primary_key=True, unique=True),
		Column('instance_id', Integer, ForeignKey('instances.id')),
		Column('lang', String(2), default="en")
)

alignments = Table('alignments', metadata,
                   Column('id', Integer, Sequence('alignments_id_seq'), primary_key=True),
                   Column('source_id', String(255), ForeignKey('sources.id'), nullable=False),
                   Column('lemma', Text, nullable=False),
                   Column('definition', Text, nullable=False),
                   Column('synonyms', Text, nullable=False),
                   Column('key', Text, nullable=False),
                   Column('relation_type_name', Text, nullable=False),
                   Column('syn_set_id', BigInteger, ForeignKey('syn_sets.id'), nullable=False),
		   Column('through_source_id', Text, ForeignKey('sources.id')),
		   Column('ext_syn_set_id', Integer),
		   UniqueConstraint('source_id', 'key', 'syn_set_id', 'ext_syn_set_id', 'relation_type_name', name='alignments_uniq')
)

metadata.create_all(engine) # Create Alignments, Instances, Sources tables if doesn't exist
session = Session()

# Add Source and Instance records
nextId = engine.execute(Sequence('instances_id_seq'))
if options.source == PWN_id:
	engine.execute(instances.insert().values(id=nextId))
	engine.execute(sources.insert().values(id=options.source, instance_id=nextId, lang=options.lang))
else:
	engine.execute(instances.insert().values(id=nextId, uri=options.uri, last_uptime=datetime.datetime.now()))
	engine.execute(sources.insert().values(id=options.source, instance_id=nextId, lang=options.lang))

# Open file
f=open(options.filename)

for line in f.readlines():
    record = line.split(delimiter)
    relation = record[2] if options.source == PWN_id else record[4]

    if relation in ('eq_synonym', 'eq_has_hyponym', 'eq_has_hyperonym', 'eq_near_synonym'): 
        if options.source == PWN_id:
		target, source, parent_source = record[0], record[1], -1 
	else: 
		target, source, parent_source = record[0], record[1], record[2]
        
	if target.startswith("EN"):
            pass
        else:
            try:
		# load data from NLTK Wordnet package
		if options.source == PWN_id:             
			lemma = wordnet.lemma_from_key(target)
                	synset = lemma.synset
			definition, lemmas, lemma_name = synset.definition, "; ".join(synset.lemma_names), lemma.name
		# load data from source file
		else:
			lemmas, definition, lemma_name = record[3], record[5], record[3].split(";")[0].strip()
		
		#print "input factor: ", options.parent_factor
		if parent_source>-1:
			ext_syn_set_id = int(parent_source)*int(options.parent_factor)
		else: 
			ext_syn_set_id = None

		if options.verbose: 
			print "Inserting alignment for CorePWN key (" + target + ") with {relation} " + relation, " {parent_source} ", parent_source, " {ext id} ", ext_syn_set_id            
		# insert statement   
 
		ins = alignments.insert().values(source_id=options.source,
                                           lemma=lemma_name,
                                           definition=definition,
                                           synonyms=lemmas,
                                           key=target,
                                           relation_type_name=relation,
					   syn_set_id=int(source)*int(options.factor), 
					   through_source_id=options.through,
					   ext_syn_set_id=ext_syn_set_id
					   )
                engine.execute(ins)
	    except IntegrityError as ie:
		print ie
            except WordNetError as e:
                print e

