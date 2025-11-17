#import "../template.typ": *
#import "../bxbibwrite.typ": *
#import "@preview/tenv:0.1.1": parse_dotenv
#show: use-bib-item-ref

#let env = parse_dotenv(read("../.env"))

#show: project.with(
  week: "第n回",
  subtitle: "サブタイトル",
  authors: (
    (name: env.STUDENT_NAME, email: "学籍番号：" + env.STUDENT_ID, affiliation: "所属：" + env.STUDENT_AFFILIATION),
  ),
  date: "yyyy 年 mm 月 dd 日",
)

== 節

hogehoge @reference

#bibliography-list(
  title: "参考文献", // 節見出しの文言
)[
#bib-item(<reference>)[参考文献の名前, https://reference.info.com/reference.html, yyyy 年 mm 月 dd 日閲覧]
]
