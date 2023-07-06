---
author: haracane
layout: post
date: 2023-07-06 12:00:00J
title: ReactでFragment Colocationする時にFragmentデータの型をどうするか
tags:
- GraphQL
- TypeScript
- 型
description: Fragment ColocationでFragmentデータを使う際に、Fragmentのデータを型変換をする必要があったので対応しました。なお、React
  + Apollo Client + graphql-codegenの場合の話です。
image: /assets/images/posts/2023-07-06-fragment-colocation-typing-ogp.png
---
<!-- tag_links -->
[GraphQL](/tags/graphql/) / [TypeScript](/tags/typescript/) / [型](/tags/type/)

<!-- content -->
## ReactでFragment Colocation

Fragment Colocationというのは「GraphQLスキーマを、コンポーネントと同じファイルで定義しましょう」という考え方です。

React + Apollo Client + GraphQL Code Generator(v3) の場合、例えばこんな感じになります。

```typescript
// UserPage.tsx

const FIND_USER_QUERY = gql`
  query FindUser {
    user {
      id
      name
      books {
        ...BookFieldsForBookList
      }
    }
  }
`

export const UserPage: FC = () => {
  const { data } = useQuery(FIND_USER_QUERY)

  if (!data) return null

  const { user } = data

  return (
    <>
      <div>{user.name}の本</div>
      <BookList books={user.books.map(BookListGraph.useBookFragment)} />
    </>
  )
}
```

```typescript
// BookList.tsx

const BOOK_FIELDS_FRAGMENT = gql`
  fragment BookFieldsForBookList on Book {
    id
    name
    author {
      id
      name
    }
  }
`

export type BookForBookList = {
  id: string
  name: string
  author: {
    name: string
  }
}

const useBookFragment = (
  book: FragmentType<typeof BOOK_FIELDS_FRAGMENT>,
): BookForBookList => useFragment(BOOK_FIELDS_FRAGMENT, book),

export const BookListGraph = {
  useBookFragment
} as const

export const BookList: FC<{ books: BookForBookList[] }> = ({ books }) => {
  return (
    <ul>
      {books.map((book, i) => (
        <li key={`book-${i}`}>
          {book.name}({book.author.name})
        </li>
      ))}
    </ul>
  )
}
```

このように、BookListで必要なfieldをBookList.tsxのGraphQL Fragmentで定義することで、BookListで扱うfieldをBookList.tsx内で管理できるようになります。

## graphql-codegenが生成するFragmentの型

graphql-codegenを使うとGraphQLのQueryやFragmentの戻り値の型を自動生成してくれます。

今回の例だと以下のようにFindUserQueryとBookFieldsForBookListFragmentという型定義が作られます。

```typescript
export type FindUserQuery = {
  __typename?: 'Query'
  user: {
    __typename?: 'User'
    name: string
    books: Array<
      { __typename?: 'Book' } & {
        ' $fragmentRefs'?: {
          BookFieldsForBookListFragment: BookFieldsForBookListFragment
        }
      }
    >
  }
}
```

```typescript
export type BookFieldsForBookListFragment = {
  __typename?: 'Book'
  id: string
  name: string
  author: { __typename?: 'Author'; name: string }
} & { ' $fragmentName'?: 'BookFieldsForBookListFragment' }
```

GraphQL Code Generatorには<a href="https://the-guild.dev/graphql/codegen/plugins/presets/preset-client#fragment-masking" target="_blank">Fragment Masking</a>という仕組みがあり、見ての通り`FindUserQuery`の`user.books`からは直接`Book`データは取得できません。

`Book`の中身を取得するには型変換する必要があり、その処理をしているのがこちらの`useBookFragment`関数になります。

```typescript
const useBookFragment = (
  book: FragmentType<typeof BOOK_FIELDS_FRAGMENT>,
): BookForBookList => useFragment(BOOK_FIELDS_FRAGMENT, book),
```

ここでは`useFragment`を使って`BookFieldsForBookListFragment`に型変換しています。

`useFragment`はgraphql-codegenが自動生成する関数で、Fragmentの型変換をしてくれます。

### Apollo ClientのuseFragment

Apollo Clientにも同じ名前の`useFragment`というフック関数があるのですが、こちらはgraphql-codegenとは異なり<a href="https://www.apollographql.com/docs/react/api/react/hooks-experimental/#usefragment" target="_blank">Fragmentキャッシュからデータを取得するための関数</a>になっています。
<br/>
(<a href="https://twitter.com/_teppeita" target="_blank">@teppeita</a>さん、ありがとうございます！)

<a href="https://the-guild.dev/graphql/codegen/plugins/presets/preset-client#the-usefragment-helper" target="_blank">graphql-codegenの設定でuseFragmentの関数名を変更することもできる</a>ので、Apollo ClientのuseFragmentと併用する場合などは、関数名を変更しておいた方が良さそうです。

### Fragment Maskingをしたくない場合

Fragment MaskingをするとFragment Colocationで定義したFragmentを他のコンポーネントに使わせないということがやりやすくなるのですが、逆に他のコンポーネントでそのデータを使いたいというケースもあるかと思います。

そのような場合は<a href="https://the-guild.dev/graphql/codegen/plugins/presets/preset-client#how-to-disable-fragment-masking" target="_blank">Fragment Maskingを無効化することもできます。</a>

このあたりはどういう方針でFragment Colocationをするかによって決めるのが良さそうです。

<!--
## useFragmentについて

今回はFragmentデータの型変換に`useFragment`を使いましたが、`useFragment`にはApollo Client Cacheからデータを取得するという機能があります。

キャッシュの話は今回の記事とは直接関係ないのですが、

- Fragmentデータの型変換をするには`useFragment`を使う必要がある
- `useFragment`を使う場合はキャッシュについても理解しておく必要がある

ので、`useFragment`のキャッシュの流れについても簡単に説明しておきます。

## useFragmentでのキャッシュデータの取得

例えば今回の例で

1. ユーザーページで今回のように`Book`データを取得
2. 他のページで`Book`データを取得して`Book`のキャッシュを更新
3. ユーザーページに戻ってきて`useFragment`を使って`Book`データを取得

という流れでページを表示した場合の場合で説明します。

この場合、3で`useFragment`を使って`Book`データを取得すると1で取得したデータではなく2でキャッシュされた`Book`データが返ります。

この記事ではApollo Client Cacheの流れについてはこれくらいの説明にとどめますが、詳しく知りたい方は<a href="https://www.apollographql.com/docs/react/caching/overview/" target="_blank">Apollo Client Cacheの公式ドキュメント</a>をご覧ください。

-->

## おまけ: Utility Typeを使った型定義

今回BooKList.tsxで`BookFieldForBookList`型を

```typescript
{
  id: string
  name: string
  author: {
    name: string
  }
}
```

と定義しましたが、<a href="https://www.typescriptlang.org/docs/handbook/utility-types.html" target="_blank">Utility Type</a>の<a href="https://www.typescriptlang.org/docs/handbook/utility-types.html#picktype-keys" targeT="_blank">Pick</a>を使って

```typescript
Pick<BookFieldsForBookListFragment, "id" | "name" | "author">
```

と定義してもOKです。

`BookFieldsForBookListFragment`が

```typescript
export type BookFieldsForBookListFragment = {
  __typename?: 'Book'
  id: string
  name: string
  author: { __typename?: 'Author'; name: string }
} & { ' $fragmentName'?: 'BookFieldsForBookListFragment' }
```

となっているので、この型から`Pick`で`id`と`name`と`author`を抜き出すと`BookForBookList`と同じ型になります。

なお、GraphQL QueryやFragmentにUnionが含まれていたりすると<a href="https://www.typescriptlang.org/docs/handbook/utility-types.html#excludeuniontype-excludedmembers" target="_blank">Exclude</a>や<a href="https://www.typescriptlang.org/docs/handbook/utility-types.html#extracttype-union" target="_blank">Extract</a>など、他のUtility Typeが役に立つこともあります。

そういった場合に備えて、Utility Typeは一通り<a href="https://www.typescriptlang.org/docs/handbook/utility-types.html" target="_blank">公式ドキュメント</a>を見ておくと良いかと思います。

## まとめ

React + Apollo + graphql-codegenでFragment Collocationをする場合は`useFragment`を使いましょう。
