Original App Design Project
===

# Gazelle: Traval Itinerary 

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Schema](#Schema)

## Overview
### Description
Gazelle allows users to plan and log their journys as they travel locally, nationally, and worldwide. Users can create a trip, add events to their itinerary and search for locations in the in-app map.

### App Evaluation
- **Category:** Travel
- **Mobile:** This app is aimed at mobile iOS users.
- **Story:** Allows users to log and track their trips. 
- **Market:** This app is useful for any user who like to plan and track their trips.
- **Habit:** Users can use Gazelle as many times they want to plan trips, view plans, log experiences, and revisit past trips.
- **Scope:** Gazelle will act as a central hub for users to store relevant travel information about their trip including but not limited to flight data, hotel bookings, transportation, points of interest, and excursions.

## Product Spec

### 1. User Stories (Required and Optional)

**Implemented Stories**

* Users can log in
* Users can sign up
* Users can create scheduled trips
* Users can view scheduled trips
* Users can delete scheduled trips
* Users can enter itinerary events
* Users can view itinerary events
* Users can view a map
* Users can search the map based on zip code or other geolocation data

**Future User Stories**

* Users can log-out
* Users can edit their scheduled trips
* Users can delete their scheduled trips
* Users can edit their itinerary events
* Users can delete their itinerary events
* Users can add points of interest from the map to their itinerary

**Optional Nice-to-have Stories**

* Users can receive notifications about what's next in their itinerary
* Users can invite friends to edit itinerary 

### 2. Screen Archetypes

* **Login:** Returning users can gain access to the app with a valid username and password.
* **Sign-Up:** First time users can create an account that give them access to app features.
* **Trips:** Users can view, edit, and delete their scheduled trips. 
* **Create Trip Form:** Users can log a new scheduled trip.
* **Edit Trip Form:** Users can edit their scheduled trip.
* **Itinerary:** Users can view, edit, and delete travel information such as flights, hotel bookings, transportation, and excursions.
* **Itinerary Event Form:** Users can add itinerary events to a scheduled trip.
* **Edit Itinerary Event Form:** Users can edit their itinerary event.
* **Explore:** Users can view a map to see points of interest at their travel destination. 

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Itinerary
* Explore

**Flow Navigation** (Screen to Screen)

* Login
   * Sign up (if NO account exists)
   * Trips tab (if account exists)
* Trips
   * Create Trips Form
   * Itinerary TableView
      * Add Itinerary Event Form
* Explore
   * Map View
   * List View

## Schema
