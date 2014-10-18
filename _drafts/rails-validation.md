---
layout: post
title: rails-validation
date: 2014-10-17 10:37:10J
tags: 
keywords: 
description: 
---

{{ page.description }}

{% highlight ruby %}
    it { should ensure_length_of(:name).is_at_most(64) }
    it { should validate_presence_of(:name) }
    it { should_not allow_value(nil).for(:name) }
    it { should validate_numericality_of(:age).only_integer }
    it { should validate_numericality_of(:age).is_greater_than_or_equal_to(0) }
{% endhighlight %}
