name := """CatFactory"""

version := "1.0.0"

lazy val root = (project in file("."))
  .enablePlugins(PlayScala)

scalaVersion := "2.11.5"

libraryDependencies ++= Seq(
  cache,
  ws
)
