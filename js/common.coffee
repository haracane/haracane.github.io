---
---
$ ->
  $('body').each ->
    $(document.links).filter( ->
      return @hostname != window.location.hostname
    ).attr('target', '_blank')

    $('section.post-summary').click ->
      location.href = $(@).data('url')
