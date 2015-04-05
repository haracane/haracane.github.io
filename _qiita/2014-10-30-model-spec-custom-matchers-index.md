Rails4のActiveRecord向けRSpecカスタムマッチャ5選

※ この記事は[江の島エンジニアBlog](http://blog.enogineer.com/)の「[Rails4のActiveRecord向けRSpecカスタムマッチャ5選](http://blog.enogineer.com/2014/10/30/model-spec-custom-matchers-index/)」の転載です。

Rails4でRSpecカスタムマッチャを追加してモデルのテストを行います。ここで紹介するカスタムマッチャではNOT NULL制約、UNIQUE制約、外部キー制約といったDB制約のテストや、FactoryGirlで正しくモデルを作れることなどをテストします。
