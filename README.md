# WordTies #
**WordTies**, is a browser application to view the conceptual network of a Wordnet and to browse its relational and multilingual links. 
This is a fork of Anders Johannsen's [AndreOrd](https://github.com/andersjo/andreord-public). AndreOrd project has been renamed and deployed as **[WordTies](http://wordties.cst.dk)** for the [METANORD](http://www.meta-nord.eu/) project.

See the description on the [CLARIN ERIC Portal - Showcases > Wordties](https://www.clarin.eu/showcase/wordties) page.

## New Features
- [D3.js](https://github.com/mbostock/d3) visualation/graphs (migrated from Protovis)
- Multilingual linking 
- Improved Alignment importing via Python script
- Alignment search by CorePWN or Multilingual alignments
- Danish and English (locale) translation
- Build/import scripts

## Requirements
**PostgreSQL**
	
  See [PostgreSQL Installation Guides](http://wiki.postgresql.org/wiki/Detailed_installation_guides)

**Rails (3.2.x)**

  See [Installing Rails](http://railsapps.github.com/installing-rails.html)

**Python**
  - Python 2.6 or 2.7 and [setuptools](http://pypi.python.org/pypi/setuptools)
  - NLTK
  [See Installing NLTK](http://nltk.org/install.html) and [Installing NLTK Data](http://nltk.org/data.html) (Only Wordnet package required)

**Node.js**

  See [Node.js Wiki - Installation](https://github.com/joyent/node/wiki/Installation)

## Installation
It is recommended to install on a standard Linux distribution.

**Setup PostgreSQL database**
  - Create user
  `createuser -U postgres -P -S andreord`
  - Create database
  `createdb -U postgres -O andreord andreord_db`
  - Import schema
  `psql -U andreord -d andreod_db < db/development.sql`

**Database & locale configuration**
  - Edit 'config/database.yml' and set `database` and `username`
  - Edit 'config/application.yml' and set desired locale 
  `config.i18n.default_locale = :en`

**Import Wordnet data**

Via Rails console in your working directory ($RAILS_APP)
`$ rails console`:
> d = Import::DanNetImporter 

> d.import 

**Import Alignments (Optional)**

For cmd-line usage help type: `python lib/import/princeton_links.py --help`
  - Import English CorePWN links (see example)
  `python lib/import/princeton_links.py -f pwn_data/DanNet/eq_core.tsv -n 1000 -v`
  - Import multilingual alignments (see example)
  `python lib/import/princeton_links.py -f pwn_data/FinWN/FinnDannValidation_final_import_ext_syn_2.tsv -s fiwn20 -t wordnet30 -l fi -u /wordties-fiwn -n 1000 -m 1 -v`
  
## Deployment

**Standalone**
- WEBrick Web Server
  - In your working directory ($RAILS_APP), running the app locally on your machine with `rails server` will start the app at: [localhost:3000](http://localhost:3000)
	
**Apache /w Phusion Passenger**
  - [Phusion Passenger User guide (Apache)](http://www.modrails.com/documentation/Users%20guide%20Apache.html) for details on installation/configuration.
  - [How to Deploy under a sub-URI](http://www.modrails.com/documentation/Users%20guide%20Apache.html#deploying_rails_to_sub_uri). Also see wiki[Installation#Deploying under sub-URI path]

## Demonstration
See the current live demonstration on [wordties.cst.dk](http://wordties.cst.dk).
