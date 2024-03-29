---
author: haracane
layout: post
title: jQueryのオートコンプリート機能を使ってサジェスト検索窓を作る
date: 2014-09-11 22:03:03J
tags:
- JavaScript
- jQuery
- CoffeeScript
keywords: JavaScript,jQuery,CoffeeScript
description: jQueryのオートコンプリート機能がいい感じだったので今回はそのご紹介をします。
---
<!-- tag_links -->
[JavaScript](/tags/javascript/) / [jQuery](/tags/jquery/) / [CoffeeScript](/tags/coffeescript/)

<!-- content -->
例えば/data/suggest/words.jsonがサジェスト候補を返すAPIだったとすると、CoffeeScriptで以下のように書けばOKです。

{% highlight coffee %}
$ ->
  $('body').each ->
    $.widget( "custom.sampleAutocomplete", $.ui.autocomplete, {
      _renderItem: (ul, item) ->
        li = $("<li>").addClass("list").text(item.value)
        if item.ruby
          li.append($("<span>", class: "f11").text("（#{item.ruby}）"))
        li.appendTo(ul)
      _renderMenu: (ul, items) ->
        $.each( items, (index, item) =>
          @_renderItemData( ul, item )
        )
        $(ul).addClass("suggest")
    })

    $('#suggest').sampleAutocomplete
      source: (request, response) ->
        $.ajax
          url: '/data/suggest/words.json',
          data: { term: request.term },
          success: (data)->
            response( data.map (item) ->
              return { value: item.value, url: item.url }
            )
      appendTo: '.search-box',
      select: (event, ui) ->
        $(".search-input").val(ui.item.value)
        window.open(ui.item.url, "_self")
{% endhighlight %}

簡単に説明すると、jQueryのwidget factoryを使ってsampleAutocompleteを作成して、text input要素からsampleAutocompleteを実行してオートコンプリート機能を追加するようになっています。

オートコンプリートの動作は

* ユーザがテキストを入力するとAPIにアクセスする
* APIから取得したデータを`_renderMenu`と`_renderItem`でサジェスト候補を表示する
* ユーザが候補を選択したら`select`でURLにジャンプする

というようになります。

このスクリプトを使うためのHTMLは例えば

{% highlight html %}
<script src="//code.jquery.com/jquery-1.10.2.js"></script>
<script src="//code.jquery.com/ui/1.11.1/jquery-ui.js"></script>
<script src="/js/suggest.js"></script>
<div class=".search-box">
  <input id="suggest">
</div>
{% endhighlight %}

のようになります。

### 関連リンク

* [jQuery UI Autocompleteの例](http://jqueryui.com/autocomplete/)
* [jQuery UI Autocompleteのドキュメント](http://api.jqueryui.com/autocomplete/)
