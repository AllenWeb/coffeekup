template = ->
  doctype 5
  html ->
    head ->
      meta charset: 'utf-8'
      title 'CoffeeKup'
      script src: 'jquery-1.6.2.min.js'
      script src: 'ace-0.1.6/src/ace.js'
      script src: 'ace-0.1.6/src/mode-coffee.js'
      script src: 'ace-0.1.6/src/mode-html.js'
      script src: 'ace-0.1.6/src/theme-twilight.js'
      script src: 'coffee-script.js'
      script src: 'coffeekup.js'
      script @js
      style @css
      script "var _gaq=[['_setAccount','UA-4475762-17'],['_trackPageview']];(function(d,t){
        var g=d.createElement(t),s=d.getElementsByTagName(t)[0];
        g.async=1;g.src='//www.google-analytics.com/ga.js';s.parentNode.insertBefore(g,s)
        })(document,'script')</script>"
    body ->
      div id: 'container', ->
        h1 id: 'logo', ->
          span class: 'delim', -> h('<')
          span class: 'cup', -> '☕'
          span class: 'delim', -> h('/>')
        h2 id: 'desc', ->
          text 'CoffeeKup is <strong>markup</strong> as <strong>CoffeeScript</strong>. '
          a id: 'info', href: 'http://github.com/mauricemach/coffeekup', -> 'More Info'

        section id: 'options', ->
          section ->
            label for: 'opts', -> 'Params: '
            input id: 'opts', type: 'text'
          section ->
            input id: 'format', type: 'checkbox', checked: yes
            label for: 'format', -> 'Format Output'

        p id: 'errors'
        div id: 'in', -> @sample
        div id: 'out'

      a href: 'http://github.com/mauricemach/coffeekup', ->
        img style: 'position: absolute; top: 0; right: 0; border: 0;', src: 'forkme_right_white_ffffff.png', alt: 'Fork me on GitHub'

@js = ->
  $ ->
    compile = ->
      try
        options = format: $('#format').is(':checked'), autoescape: yes
        eval 'opts = ' + $('#opts').val()
        out_session.setValue(CoffeeKup.render(editor_session.getValue(), opts, options))
        setTimeout (-> out.gotoLine 1), 100
        $('#errors').hide()
      catch err
        $('#errors').show().html err.message

    $('#opts').bind 'keyup', -> compile()
    $('#format').bind 'click', -> compile()

    $('#opts').val "{title: 'Foo', path: '/zig', user: {}, max: 12, locals: {shoutify: function(s){return s.toUpperCase() + \'!\';}}}"

    editor = ace.edit 'in'
    editor_session = editor.getSession()
    out = ace.edit 'out'
    out_session = out.getSession()

    CoffeeMode = require("ace/mode/coffee").Mode
    editor_session.setMode(new CoffeeMode())

    HtmlMode = require("ace/mode/html").Mode
    out_session.setMode(new HtmlMode())

    editor.setTheme("ace/theme/twilight")
    out.setTheme("ace/theme/twilight")
    editor_session.setTabSize 2
    editor_session.setUseSoftTabs on
    out.setReadOnly on
    
    $('.ace_gutter').css('background-color', '#2a211c').css('color', '#555')
    
    editor_session.on 'change', -> compile()
    
    compile()

@js = "(#{@js}).call(this);"

@css = """
  html, body {margin: 0; padding: 0}
  body {
    background: #473e39;
    color: #ccc; 
    font-family: Ubuntu, Lucida Grande, Gill Sans, Segoe UI, Lucida Sans Unicode, Tahoma, sans-serif;
  }
  #container {padding-top: 140px; width: 1120px; margin: auto; position: relative; text-align: right}
  a {color: #09f}
  a:hover {color: #0cf}
  #logo {
    position: absolute;
    top: 15px; right: 20px;
    margin: 0;
    font-weight: normal;
    font-family: Gill Sans, DejaVu Sans, Segoe UI, Calibri, Lucida Sans Unicode, sans-serif;
  }
  #logo .cup {color: #fff; font-size: 90px}
  #logo .delim {color: #666; font-size: 60px}
  #desc {
    position: absolute; top: 90px; left: 25px;
    color: #fff; font-size: 22px; margin: 0; margin-left: 0.5em; margin-right: 7.5em; display: inline; font-weight: normal;
  }
  #info {color: #999; font-size: 20px; margin-left: 10px}
  #info:hover {color: #ccc}
  #in, #out {
    position: absolute;
    text-align: left;
    width: 555px; height: 1000px;
    margin-bottom: 10px;
    font-size: 14px;
    -webkit-box-shadow: 0px 0px 20px #222;
    -moz-box-shadow: 0px 0px 20px #222;
    box-shadow: 0px 0px 20px #222;
  }
  #in {top: 200px; left: 0}
  #out {top: 200px; right: 0}
  #errors {
    display: none;
    position: absolute; right: 4px; top: 190px; z-index: 1;
    background: #f00;
    padding: 10px;
    color: #fff;
    -webkit-box-shadow: 0px 0px 30px #000000;
    -moz-box-shadow: 0px 0px 30px #000000;
    box-shadow: 0px 0px 30px #000000;
  }
  #options {clear: left; margin-bottom: 20px}
  #options section {display: inline; margin-right: 20px}
  #options input[type=text] {font-size: 14px; border: 1px solid #333; width: 840px; padding: 5px; background: #2a211c; color: #ccc;}
"""

@sample = """
  doctype 5
  html ->
    head ->
      meta charset: 'utf-8'
      title "\#{@title or 'Untitled'} | My awesome website"
      meta(name: 'description', content: @desc) if @desc?
      link rel: 'stylesheet', href: '/stylesheets/app.css'
      style '''
        body {font-family: sans-serif}
        header, nav, section, footer {display: block}
      '''
      script src: '/javascripts/jquery.js'
      coffeescript ->
        $ ->
          alert 'Alerts are so annoying...'
    body ->
      header ->
        h1 @title or 'Untitled'
        nav ->
          ul ->
            (li -> a href: '/', -> 'Home') unless @path is '/'
            li -> a href: '/chunky', -> 'Bacon!'
            switch @user.role
              when 'owner', 'admin'
                li -> a href: '/admin', -> 'Secret Stuff'
              when 'vip'
                li -> a href: '/vip', -> 'Exclusive Stuff'
              else
                li -> a href: '/commoners', -> 'Just Stuff'
      section ->
        h2 "Let's count to \#{@max}:"
        p i for i in [1..@max]
      footer ->
        p shoutify('bye')
"""

template()