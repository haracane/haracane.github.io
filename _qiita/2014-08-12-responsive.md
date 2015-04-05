Jekyll2.2.0でレスポンシブにしてスマホ対応してみた

※ この記事は[江の島エンジニアBlog](http://blog.enogineer.com/)の「[Jekyll2.2.0でレスポンシブにしてスマホ対応してみた](http://blog.enogineer.com/2014/08/12/responsive/)」の転載です。

Jekyllの初期設定だと小さい画面でも画像が大きいままで, スマホで読みにくかったのでレスポンシブ対応を行いました.



変更したのはCSSだけで

**css/main.css**

```css
@media screen and (max-width: 600px) {
  .post-content img { width: 480px; }
}

@media screen and (max-width: 480px) {
  .post-content img { width: 400px; }
}

@media screen and (max-width: 400px) {
  .post-content img { width: 340px; }
}

@media screen and (max-width: 340px) {
  .post-content img { width: 280px; }
}
```

というように画面幅に応じて画像の幅を設定してあげればレスポンシブになります.

設定例はこの[カルボナーラ](http://gsrecipe.com/2014/08/10/carbonara/)をどうぞ.
ブラウザの幅を変えるとそれにあわせて写真のサイズが変化します.
