# Scoreboard App

## Background

* This app is needed for Forney ISD Highschool sports web broadcasting.
* The scope of the app will cover needs for Football, Basketball, and Baseball.
* Multiple schools across the school district will be using the app.
* There will need to be an oraganization structure with users that belong to
  such.
* The broadcast team uses OBS to record and stream the broadcast.
* The scoreboard is imported into OBS as a web view to be seen on the broadcast.
  feed during the game, like any typical sporting event broadcast on TV.
* The app will be a CRUD app for the most part with the exception of the public
  facing scoreboard that will be modeled after something like you would see on
  Fox Sports.

## Specifications

* The app should be a Web app built with the Ruby on Rails Framework.
* The app should use `ActionCable` for live updates to the scoreboard since the
  refresh function of the webpage is only used by OBS to initialize the
  scoreboard web view.
* The app should use a Postgresql database since it will be hosted on Heroku.
* The app should be containerized using Docker so that the development
  environment will be as close to production as possible.
* The app should have an authentication system like Devise.  I recommend using
  devise.

## Requirements

* An admin will create new `Organization` accounts and invite `User` accounts by
  email address to sign up under specific organizations.
* An admin has access to all data and organizations.
* An admin may deactivate an organization or `User` at any time.
* Users should not be able to read or write data that doesn't belong to
  their organization.
* Once a user is signed up under an organization they may invite other users to
  sign up under their organization.
* A user can change his password.
* An admin may create a new `Season` so that games may belong to the season.
* A user can create a `Game` under the current season.
* A game should have a `Scoreboard` that relates to the type of sport.
* A user can start a game and update the scoreboard for that game.
* A game should have a `sport` field with one of three possible options,
  Football, Basketball or Baseball.
* The socreboard will maintain all the details of the game as it pertains to the
  scoreboard display.
* A game should have a home `Team` and a visitor `Team`.


## ActiveRecord Objects and Relationships

`Organization`
has_many :users
has_many :teams
has_many :games
name:string

`User`
belongs_to :organization
email:string
first_name:string
last_name:string

`Game`
belongs_to :organization
game_type:string (:football, :basketball, :baseball)
has_one :home_team
has_one :visitor_team
has_one scoreboard :polymorphic
start_time:datetime

`Team`
belongs_to :game
belongs_to :organization
has_one_attached :logo_img
name:string
short_name:string
mascot:string
bg_color:string
font_color:string


There should be a scoreboard interface (group of attributes and methods) that
all scoreboards will have.  There also needs to be different types of
scoreboards for each of the three different sports.  So from the `Game` class
perspective there should be a standard set of methods that it will expect every
scoreboard to have.  Each scoreboard model class will have a different set of
attributes that apply to the specific sport.

`Scoreboard`
belongs_to :game
home_score:integer
home_score_bg_color:string
home_score_font_color:string
visitor_score:integer
visitor_score_bg_color:string
visitor_score_font_color:string


`FootballScoreboard` < `Scoreboard`
possession:string, default: :none (:none, :home, :visitor)
down:integer
ball_on:integer
to_go:integer
quarter:integer
quarter_status:string, default: :pregame (:pregame, :regulation, :overtime)
home_tol:integer (max: 3)
home_1st_qtr_score:integer
home_2nd_qtr_score:integer
home_3rd_qtr_score:integer
home_4th_qtr_score:integer
visitor_tol:integer (max: 3)
visitor_1st_qtr_score:integer
visitor_2nd_qtr_score:integer
visitor_3rd_qtr_score:integer
visitor_4th_qtr_score:integer



`BaseballScoreboard` < `Scoreboard`
inning:integer
inning:status, default: :pregame (:pregame, :top, :bottom, :final)
strikes:integer, default: 0
balls:integer, default: 0
outs:integer, default: 0
runner_on_first:boolean
runner_on_second:boolean
runner_on_third:boolean
show_base_runners:boolean
home_in1_score:integer, default: 0
home_in2_score:integer, default: 0
home_in3_score:integer, default: 0
home_in4_score:integer, default: 0
home_in5_score:integer, default: 0
home_in6_score:integer, default: 0
home_in7_score:integer, default: 0
home_in8_score:integer, default: 0
home_in9_score:integer, default: 0
home_exi_score:integer, default: 0
visitor_in1_score:integer, default: 0
visitor_in2_score:integer, default: 0
visitor_in3_score:integer, default: 0
visitor_in4_score:integer, default: 0
visitor_in5_score:integer, default: 0
visitor_in6_score:integer, default: 0
visitor_in7_score:integer, default: 0
visitor_in8_score:integer, default: 0
visitor_in9_score:integer, default: 0
visitor_exi_score:integer, default: 0


`BasketballScoreboard` < `Scoreboard`
periods:integer
period_status:string
possession:string, default: :none (:none, :home, :visitor)
home_tol:integer (max: 5)
visitor_tol:integer (max: 5)


## Contollers

`TeamsController`
- list teams
- create team
- edit team
- delete a team
- show a team

`GamesController`
- list games
- create game
- edit game
- delete game
- show a game
