package controllers

import play.api._
import play.api.mvc._

object CatFactory extends Controller {

  /** Index
    *
    * Route: /
    */
  def index = Action {
    Ok(views.html.index())
  }
}
