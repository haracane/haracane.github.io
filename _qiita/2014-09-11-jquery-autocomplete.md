jQueryのオートコンプリート機能を使ってサジェスト検索窓を作る

※ この記事は[江の島エンジニアBlog](http://blog.enogineer.com/)の「[jQueryのオートコンプリート機能を使ってサジェスト検索窓を作る](http://blog.enogineer.com/2014/09/11/jquery-autocomplete/)」の転載です。

jQueryのオートコンプリート機能がいい感じだったので今回はそのご紹介をします。



例えば/data/suggest/words.jsonがサジェスト候補を返すAPIだったとすると、CoffeeScriptで以下のように書けばOKです。

```coffee
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
```

簡単に説明すると、jQueryのwidget factoryを使ってsampleAutocompleteを作成して、text input要素からsampleAutocompleteを実行してオートコンプリート機能を追加するようになっています。

オートコンプリートの動作は

* ユーザがテキストを入力するとAPIにアクセスする
* APIから取得したデータを`_renderMenu`と`_renderItem`でサジェスト候補を表示する
* ユーザが候補を選択したら`select`でURLにジャンプする

というようになります。

このスクリプトを使うためのHTMLは例えば

```html
<script src="//code.jquery.com/jquery-1.10.2.js"></script>
<script src="//code.jquery.com/ui/1.11.1/jquery-ui.js"></script>
<script src="/js/suggest.js"></script>
<div class=".search-box">
  <input id="suggest">
</div>
```

のようになります。

### 関連リンク

* [jQuery UI Autocompleteの例](http://jqueryui.com/autocomplete/)
* [jQuery UI Autocompleteのドキュメント](http://api.jqueryui.com/autocomplete/)
