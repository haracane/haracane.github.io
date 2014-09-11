---
---
$ ->
  $('body').each ->
    $.widget( "custom.collegeAutocomplete", $.ui.autocomplete, {
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

    $('#suggest').collegeAutocomplete
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
