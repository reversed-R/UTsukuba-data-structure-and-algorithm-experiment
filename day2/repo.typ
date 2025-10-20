#import "../template.typ": *
#import "../bxbibwrite.typ": *
#import "@preview/tenv:0.1.1": parse_dotenv
#import "@preview/codelst:2.0.2": sourcecode
#import "@preview/showybox:2.0.4": showybox
#show: use-bib-item-ref

#let env = parse_dotenv(read("../.env"))

#show: project.with(
  week: "課題2",
  subtitle: "連結リスト，スタック，キュー",
  authors: (
    (name: env.STUDENT_NAME, email: "学籍番号：" + env.STUDENT_ID, affiliation: "所属：" + env.STUDENT_AFFILIATION),
  ),
  date: "2025 年 10 月 20 日",
)

== 基本課題

=== 2-1

``の実装は以下のとおり。

#sourcecode[```c
```]

実行結果は以下のとおり。

#sourcecode[```sh
```]


== 発展課題

=== 2-3



#bibliography-list(
  title: "参考文献", // 節見出しの文言
)[
#bib-item(<euclid-calc-order>)["東北大学情報科学研究科 塩浦昭義『アルゴリズムとデータ構造』", http://www.shioura-lab.iee.e.titech.ac.jp/shioura/teaching/ad10/ad10-01.pdf, 2025 年 10 月 15 日閲覧]
]
