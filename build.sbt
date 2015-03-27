name := """CatFactory"""

version := "1.0.0"

lazy val root = (project in file("."))
  .enablePlugins(PlayScala)

scalaVersion := "2.11.5"

excludeFilter in (Assets, LessKeys.less) := "_*.less"

includeFilter in (Assets, LessKeys.less) := "*.less"

libraryDependencies ++= Seq(
  cache,
  ws
)
