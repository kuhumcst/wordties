html xmlns: 'http://www.w3.org/1999/xhtml', ->
  head ->
    meta charset: 'utf-8'
    title 'WordTies'
    link href: 'css/application.css', media: 'screen', rel: 'stylesheet', type: 'text/css'
  body ->
    div '#scene', ->
      div '#header', ->
        div '#logo', ->
          a href: '/', 'WordTies'
        br style: 'height:150px; clear:both'
      div '#main.contacts', ->
        h3 ->
          text 'Publications'
        div '.breadcrumbs', ->
          a href: '/', '< Home'
        ul '.pub-item', ->
          li -> 
            text 'Pedersen, B.S., L. Borin, M. Forsberg, K. Lindén, H. Orav, E. Rögnvalssson (2012) '
            span 'Linking and Validating Nordic and Baltic Wordnets- A Multilingual Action in META-NORD.'
            br()
            text 'In: Proceedings of 6th International Global Wordnet Conference pp.254-260. Matsue, Japan.'
      div '#footer', ->
        a href: '/', 'WordTies'
        text '&nbsp;is developed by&nbsp;'
        a href: 'mailto:anders@johannsen.com', 'Anders Johannsen'
        text '&nbsp;and&nbsp;'
        a href: 'mailto:seaton@hum.ku.dk', 'Mitchell Seaton'
        text '&nbsp;|&nbsp;'
        a href: 'https://github.com/kuhumcst/wordties/tree/metanord_validate', target: '_blank', ->
          text 'GitHub'
          br()
