---
layout: post
date: 2023-06-20 10:00:00J
title: Repositoryパターンの全件取得処理を型と関数で実装してみた
tags: TypeScript フック Repositoryパターン
description: これまでオブジェクト指向でRepositoryパターンの実装をしてたんですが、今回はRepositoryパターンの全件取得処理を型と関数で実装してみました。
---
[TypeScript](/tags/typescript/) / [フック](/tags/hook/) / [Repositoryパターン](/tags/repository-pattern/)

これまでTypeScriptでRepositoryパターンを実装する時にオブジェクト指向で実装してたんですが、型と関数でも実装してみました。

まずは手始めに全件取得処理を型と関数で実装してみます。

## Repositoryの共通部分をフックで実装する

まずはRepositoryの共通部分を実装してみます。

Repositoryを型と関数で実装する場合、個別のテーブルやスキーマ情報をフックできる関数を作ると扱いやすいです。

レコードを全件取得するRepositoryの実装例はこんな感じになります。

```typescript
const useFindAllRepository = <RECORD, MODEL>(
  table: PrismaClient,
  schema: {
    toModel: (record: RECORD): MODEL
  }
) => ({
  findAll: (): Promise<MODEL | null> => {
    // フックしたtableを使ってレコードを全件取得する
    const records: RECORD[] = await table.findMany()

    // フックしたスキーマを使ってモデルに変換する
    return records.map(schema.toModel)
  }
} as const)
```

useRepository 関数はテーブルとスキーマ(load関数だけですが)を受け取って、findAll関数を持つオブジェクトを返しています。

## UserRepositoryをフックで実装する

次はUserRepositoryです。

さっそく先ほどのuseFindAllRepositoryを使って実装してみます。

```typescript
type User = {
  id: number
  email: string
}

const useUserRepository = () => {
  const { findAll } = useFindAllRepository<Users, User>(
    prisma.users,
    {
      load: (record: Users): User =>
        ({ id: record.id, email: record.email }),
    }
  )

  return { findAll } as const
}

type UserRepository = ReturnType<typeof useUserRepository>
```

このように、useFindAllRepositoryにUserのテーブルとスキーマを渡してあげるとUserの配列を返すfindAll関数が取得できるので、その関数をそのまま使えばUserRepositoryを実装できます。

### RetutnTypeを使ったUserRepository型の定義

UserRepository型の定義にはReturnTypeを使っています。

```typescript
type UserRepository = ReturnType<typeof useUserRepository>
```

ReturnTypeは戻り値の型を返すUtility Typeです。

ここではUserRepositoryの型が、useUserRepository関数の戻り値の型である

```typescript
{
  findAll: () => Promise<User[]>
}
```

となります。

ReturnTypeについて詳しく知りたい方は[公式ドキュメント](https://www.typescriptlang.org/docs/handbook/utility-types.html#returntypetype)もご覧ください。

## まとめ

やってみたらRepositoryパターンは意外と簡単に型と関数で実装できました。

今回は引数を受け取らないfindAll関数のみの実装でしたが、次はIDなどの引数を受け取るパターンも実装してみようと思います。
