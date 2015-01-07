# blog.enogineer.com

## タグページの設定

`_config/tag_categories.yml`を編集して

    $ update-jekyll-data

を実行すると

* _data/tag_codes.json
* _data/tag_names.json
* _data/tag_urls.json
* _data/tag_categories.json
* _data/category_navigations.json

を作成できます。

## 連載記事の作成

### 連載インデックスの作成

    categories: category-posts-index
    sub_category: series-name

### 連載記事の作成

    categories: series-name
