---
---
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
