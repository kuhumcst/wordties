html xmlns: 'http://www.w3.org/1999/xhtml', ->
  head ->
    meta charset: 'utf-8'
    title 'WordTies'
    link href: 'assets/application.css', media: 'screen', rel: 'stylesheet', type: 'text/css'
  body ->
    div '#scene', ->
      div '#header', ->
        div '#logo', ->
          a href: '/', 'WordTies'
        br style: 'height:150px; clear:both'
      div '#main', ->
        h2 'WordTies: A Nordic/Baltic Multi-lingual Wordnet Initiative'
        p ->
          b 'WordTies'
          text ' describes a multilingual wordnet initiative embarked in the '
          a href: 'http://www.meta-nord.eu/', target: '_blank', 'META-NORD'
          text '/'
          a href: 'http://meta-net.eu', target: '_blank', 'META-NET'
          text ' projects and concerned with the validation and pilot linking between Nordic and Baltic wordnets.'
        h3 'Wordnets in Nordic/Baltic countries'
        p ->
          text 'The builders of these wordnets have applied very different compilation strategies: The Danish, Icelandic and Swedish wordnets are being developed via monolingual dictionaries and corpora and subsequently linked to Princeton WordNet. In contrast, the Finnish and Norwegian wordnets are applying the expand method by translating from '
          a href: 'http://wordnet.princeton.edu/', target: '_blank', 'Princeton WordNet'
          text ' and the Danish wordnet, DanNet, respectively. The Estonian wordnet was built as part of the EuroWordNet project and by translating the base concepts from English as a first basis for monolingual extension.'
        p ->
          a href: 'http://www.clarin.eu/', target: '_blank', ->
            img '.logo.clarin-eric', src: 'assets/clarinericlogo.png', width: '254', height: '67'
          br()
          text 'WordTies has been included as a '
          a href:'http://www.clarin.eu', target: '_blank', 'CLARIN ERIC'
          text ' showcase.'
        h3 'Aim of multilingual wordnets'
        p ->
          text 'The aim of the multilingual action is to test the perspective of a multilingual linking of the Nordic and Baltic wordnets and via this (pilot) linking to perform a tentative comparison and validation of the wordnets along the measures of taxonomical structure, coverage, granularity and completeness. WordTies currently includes '
          a href: 'http://wordnet.dk/dannet/lang', target: '_blank', 'Danish'
          text ', '
          a href: 'http://www.ling.helsinki.fi/en/lt/research/finnwordnet/', target: '_blank', 'Finnish'
          text ', '
          a href: 'http://spraakbanken.gu.se/eng/resource/swesaurus', target: '_blank', 'Swedish'
          text ' and '
          a href: 'http://www.cl.ut.ee/ressursid/teksaurus/', 'Estonian'
          text ' wordnets which have been linked to '
          a href: 'http://wordnetcode.princeton.edu/standoff-files/core-wordnet.txt', target: '_blank', 'Princeton Core WordNet'
          text ', thereby providing a common, linked coverage of all in all 5,000 core synsets. In the current web interface, 20% of these have been manually validated and are made visible through multilingual links.'
        div '.sources.highlight', ->
          h3 ->
            text 'Select an available Nordic/Baltic'
            i ' source '
            text 'wordnet to browse below:'          
          ul ->
            li ->
              a href: '/wordties-dannet/', 'DanNet'
              text ' (Danish Wordnet)'
            li ->
              a href: '/wordties-fiwn', 'FinnWordNet'
              text ' (Finnish Wordnet)'
            li ->
              a href: '/wordties-estwn/', 'TEKsaurus'
              text ' (Estonian Wordnet)'
            li 'Swesaurus* (Swedish Wordnet)'
          i '*Alignments or relational links via Princeton WordNet are presented in the other available sources above'
        p '.logos', ->
          a href: 'http://www.meta-nord.eu/', target: '_blank', ->
            img '.logo.metanord', src: 'assets/metanord_logo.small.jpg', width: '254', height: '45'
          a href: 'http://metanet.eu', target: '_blank', ->
            img '.logo.metanet', src: 'assets/metanet_logo.small.jpg', width: '216', height: '45'
        p '.footnote', 'This work has been performed within the META-NORD project which has received funding from the European Commission through the ICT PSP Programme, grant agreement no 270899.'      
        div '.footer-links', ->
          a href: 'contacts.html', 'Contacts'
          text '&nbsp;|&nbsp;'
          a href: 'publications.html', 'Publications'
      div '#footer', ->
        a href: '/', 'WordTies'
        text '&nbsp;is developed by&nbsp;'
        a href: 'mailto:anders@johannsen.com', 'Anders Johannsen'
        text '&nbsp;and&nbsp;'
        a href: 'mailto:seaton@hum.ku.dk', 'Mitchell Seaton'
        text '&nbsp;|&nbsp;'
        a href: 'https://github.com/meaton/andreord-public/tree/metanord_validate', target: '_blank', ->
          text 'GitHub'
          br()
