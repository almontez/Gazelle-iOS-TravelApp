# Gazelle: Travel Log 

## Table of Contents
1. [Overview](#Overview)
2. [Demo](#Demo)
3. [Product Specs](#Product-Specs)
4. [Schema](#Schema)

## Overview
### Description
Gazelle allows users to plan and log their journeys as they travel locally, nationally, and worldwide. Users can create a trip, add events to their itinerary, and search for locations in the in-app map.

### App Evaluation
- **Category:** Travel
- **Mobile:** This app is aimed at mobile iOS users.
- **Story:** Allows users to log and track their trips. 
- **Market:** This app is useful for any user who like to plan and track their trips.
- **Habit:** Users can use Gazelle as many times they want to plan trips, view plans, log experiences, and revisit past trips.
- **Scope:** Gazelle will act as a central hub for users to store relevant travel information about their trip including but not limited to flight data, hotel bookings, transportation, points of interest, and excursions.
- **Tools & Technolgies:** Swift, iOS, UIKit, MapKit, Back4App

## Demo

<img src='https://github.com/almontez/CodePathiOS-SP23-Project/blob/main/Read%20Me%20Media/GazelleDemo.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with Apple Simulator 

## Product Specs

### 1. User Stories

**Implemented Stories**

* Users can log in, sign up, and log out
* Users can view, create, edit, and delete scheduled trips
* Users can view, create, edit, and delete itinerary events
* Users can view a map
* Users can search the map based on zip code or other geolocation data
* Users can add points of interest from the map to their itinerary
* Users can navigate to a location's website from Itinerary Event Details and Explore Location Details
* Users can be redirected to Apple Maps from Itinerary Event Details and Explore Location Details

### 2. Screen Archetypes

* **Login:** Returning users can gain access to the app with a valid username and password.
* **Sign-Up:** First time users can create an account that give them access to app features.
* **Trips:** Users can view, edit, and delete their scheduled trips. 
* **Create Trip Form:** Users can log a new scheduled trip.
* **Edit Trip Form:** Users can edit their scheduled trip.
* **Itinerary:** Users can view, edit, and delete travel information such as flights, hotel bookings, transportation, and excursions.
* **Create Itinerary Event Form:** Users can add itinerary events to a scheduled trip.
* **Edit Itinerary Event Form:** Users can edit their itinerary event.
* **Itinerary Details:** Users can view additional details regarding their itinerary event.
* **Explore:** Users can view a map to see points of interest at their travel destination. 
* **Location Details:** Users can view details regarding a clickable point of interest.
* **Map Search Table:** Users can search for locations and points of interest using a search bar and see matching results. 

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Itinerary
* Explore

**Flow Navigation** (Screen to Screen)

* Login
   * Sign up (if NO account exists)
   * Trips tab (if account exists)
* Trips
   * Create Trip Form
   * Edit Trip Form
   * Itinerary TableView
      * Add Itinerary Event Form
      * Edit Itinerary Event Form
      * Itinerary Event Details Controller
* Explore
   * Map View
   * Search Results Table
   * Point of Interest Detail Controller
      * Add Itinerary Event Form
      * Open in Maps
      * Website (if available)

## Schema
<img src="https://github.com/almontez/CodePathiOS-SP23-Project/blob/main/Read%20Me%20Media/Gazelle%20Database%20diagram.png" height=500>

## License

    Copyright 2023 Angela Montez & Dylan Canipe

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
