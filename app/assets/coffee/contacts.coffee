html xmlns: 'http://www.w3.org/1999/xhtml', ->
  head ->
    meta charset: 'utf-8'
    title 'WordTies - Contacts'
    link href: 'css/application.css', media: 'screen', rel: 'stylesheet', type: 'text/css'
  body ->
    div '#scene', ->
      div '#header', ->
        div '#logo', ->
          a href: '/', 'WordTies'
        br style: 'height:150px; clear:both'
      div '#main.contacts', ->
        h3 ->
          text 'Contacts'
        div '.breadcrumbs', ->
          a href: '/', '< Home'
        p ->
          text 'Coordinator of the multilingual initiative on wordnets in '
          a href:'http://www.meta-nord.eu/', target:'_blank', 'METANORD'
          text ':'
          ul ->
            li -> a href: 'mailto:bspedersen@hum.ku.dk', -> 'Bolette Sandford Pedersen'
        p ->
          text 'Finnish wordnet:'
          ul ->
            li -> a href: 'mailto:krister.linden@helsinki.fi', -> 'Krister Lindén'
            li -> a href: 'mailto:Jyrki.Niemi@helsinki.fi', -> 'Jyrki Niemi'
        p ->
          text 'Danish wordnet:'
          ul ->
            li -> a href: 'mailto:bspedersen@hum.ku.dk', -> 'Bolette Sandford Pedersen'
            li -> a href: 'mailto:nhs@dsl.dk', -> 'Nicolai H. Sørensen'
        p ->
          text 'Estonian wordnet:'
          ul ->
            li -> a href: 'mailto:heili.orav@ut.ee', -> 'Heili Orav'
            li -> a href: 'mailto:neeme.kahusk@ut.ee', -> 'Neeme Kahusk'
        p ->
          text 'Swedish wordnet:'
          ul ->
            li -> a href: 'mailto:lars.borin@svenska.gu.se', -> 'Lars Borin'
            li -> a href: 'mailto:markus.forsberg@svenska.gu.se', -> 'Markus Forsberg'
            li -> a href: 'mailto:kaarlo.voionmaa@svenska.gu.se', -> 'Kaarlo Voionmaa'
        p ->
          text 'Norwegian wordnet:'
          ul ->
            li -> a href: 'mailto:larsnyga@gmail.com', -> 'Lars Nygaard'
      div '#footer', ->
        a href: 'http://wordties.cst.dk', 'WordTies'
        text '&nbsp;is developed by&nbsp;'
        a href: 'mailto:anders@johannsen.com', 'Anders Johannsen'
        text '&nbsp;and&nbsp;'
        a href: 'mailto:seaton@hum.ku.dk', 'Mitchell Seaton'
        text '&nbsp;|&nbsp;'
        a href: 'https://github.com/meaton/andreord-public/tree/metanord_validate', target: '_blank', ->
          text 'GitHub'
          br()
