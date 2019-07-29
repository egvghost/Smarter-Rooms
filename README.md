# Smarter Rooms

This tool will let you manage rooms' reservations easily, leveraging the data generated by IoT APIs.

Users can make reservations even from the Home view or the Rooms views, and list/cancel all owned scheduled/expired reservations. For each room they will also be able to validate its status (occupied/unoccupied) in real time.

Administrators will have additional functionalities, such as create/edit/delete Buildings, Rooms and Accessories, Users and reservations. They will also have a detailed Rooms' dashboard to check their status in real time, plus an Occupancy section, to validate reservations not being used or rooms used without reservation. The Charts section will provide statistics for the last week/month on specific topics, for trends analysis to allow a better understanding and planning of IBM's infrastructure use.

To start using Smarter Rooms, run these commands in order:
* Add all gems dependencies:
'bundle install'
* Database creation/initialization:
'rails db:create'
'rails db:migrate'
'rails db:seed'

This initial setup creates a default administrator:
name: "Administrator"
email: "admin@admin.com"
password: "Passw0rd"


Technical requirements:
* Ruby version:
ruby '2.4.1'
* Gems dependencies:
rails v5.2.3
sqlite3
puma v3.11
sass-rails v5.0
uglifier v1.3.0
coffee-rails v4.2
turbolinks v5
jbuilder v2.5
bcrypt v3.1.7
faraday v0.15.4
bootstrap v4.3.1
jquery-rails
font-awesome-sass v5.8.1
kaminari
chartkick

