---
layout: post
title: HerokuでRailsからElasticsearchを使ってみた
date: 2014-10-13 09:22:12J
tags: Heroku Elasticsearch Rails Ruby
keywords: Heroku Elasticsearch Rails Ruby
description: 
---

{{ page.description }}

https://addons.heroku.com/searchbox

    $ heroku addons:add searchbox

    $ heroku config | grep SEARCHBOX_URL
    SEARCHBOX_URL  => http://paas:8ed0986ecaabcb7c20b4b2bdd6251f2d@.....searchly.com

    $ heroku config | grep SEARCHBOX_SSL_URL
    SEARCHBOX_SSL_URL  => https://paas:8ed0986ecaabcb7c20b4b2bdd6251f2d@.....searchly.com
