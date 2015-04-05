ページ遷移時JavaScriptイベント3種類の動作確認コードを作ってみた

※ この記事は[江の島エンジニアBlog](http://blog.enogineer.com/)の「[ページ遷移時JavaScriptイベント3種類の動作確認コードを作ってみた](http://blog.enogineer.com/2015/01/29/js-transition-events/)」の転載です。

ページ遷移した時に発生するJavaScriptイベントがload, pageShow, popStateといくつかあってブラウザによって挙動が違ったりするので動作確認用のコードを作りました。Railsのturbolinks機能を使う時など、結構確認することがありそうなので公開しておきます。

例えばページロード時にSafari(7.1)だとpopStateイベントが発生して、Chrome(40.0.2214.91)やFirefox(35.0.1)だと発生しなかったりします。

{% raw %}
<a name="self"></a>
<a name="push"></a>
<a name="replace"></a>
{% endraw %}

## ページ遷移イベントの動作を確認する

今回のコードではJavaScriptコンソールと画面にload, pageShow, popStateの各イベントの発生を通知します。

pushStateやreplaceStateもボタンから実行できるので色々試してみてください。

[自己リンク]({{ page.url }})と[ページ内リンク](#self)も用意しておきます。

{% raw %}
<script src="/js/jquery.min.js"></script>
<script src="/js/transition.js"></script>

<input type="button" class="push-state-button" value="pushState"/>
<input type="button" class="replace-state-button" value="replaceState"/>
<pre><code class="event-output"></code></pre>
{% endraw %}

## ページ遷移イベント動作確認コードのCoffeeScript

ちなみにイベントハンドラの設定コードはこんな感じです。

```coffee
$ ->
  outputSelector = '.event-output'

  notify = (text) ->
    message = "[#{new Date().toLocaleString()}] #{text}"
    $(outputSelector).append("#{message}\n")
    console.log(message)

  $(window).on 'load', (event) ->
    notify(
      "loadイベントが発生しました。\n" +
      "  location.href = #{location.href}"
    )

  $(window).on 'pageshow', (event) ->
    notify(
      "pageshowイベントが発生しました。\n" +
      "  location.href = #{location.href}"
    )

  $(window).on 'popstate', (event) ->
    notify(
      "popstateイベントが発生しました。\n" +
      "  location.href = #{location.href}\n" +
      "  event.originalEvent.state = #{event.originalEvent.state}"
    )

  $(document).on 'click', '.push-state-button', ->
    state = "push:#{new Date().toLocaleString()}"
    notify("history.pushState('#{state}', null, '#push')")
    history.pushState("#{state}", null, '#push')

  $(document).on 'click', '.replace-state-button', ->
    state = "replace:#{new Date().toLocaleString()}"
    notify("history.replaceState('#{state}', null, '#replace')")
    history.replaceState("#{state}", null, '#replace')

  notify('load, pageShow, popStateイベントハンドラをbindしました。')
```

## まとめ

以上、JavaScriptのページ遷移イベント確認コードの紹介でした。

こういうことは調べるより実際に動かしてみた方が早かったりするので、よろしければご利用ください。
