Original App Design Project
===

# Gazelle: Travel Log

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
Gazelle allows users to plan, share, and log their journey as they travel locally, nationally, or worldwide. Users can create a shared trip with their friends and family, where they can upload and update their itinerary before and during their journey. Each trip will have a travel log feature where travelers can share photos, videos, and text posts. 

### App Evaluation
- **Category:** Travel
- **Mobile:** This app is aimed at mobile iOS users.
- **Story:** Allows users to log and share their trips with friends and family. 
- **Market:** This app is useful for any user who like to plan and track their trips, as well as those who like to share their travel experiences.
- **Habit:** Users can use Gazelle as many times they want to plan trips, view plans and log experiences, and revisit past trips.
- **Scope:** Gazelle will act as a central hub for users to store relevant travel information about their trip including but not limited to flight data, hotel bookings, transportation, points of interest, excursions, and photos and posts. 

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* Users can log in
* Users can sign up
* Users can enter itinerary info
* Users can view their itinerary
* Users can edit their itinerary
* Users can post travel photos to the community feed
* Users can post text blobs to the community feed
* Users can view a map with points of interest

**Optional Nice-to-have Stories**

* Users can like photos
* Users can comment on photos and text blobs
* Users can edit their community posts
* Users can delete their community posts
* Users can receive notifications about what's next in their itinerary
* Users can invite friends to edit itinerary 
* Users can add points of interest from the map to their itinerary
* Users can search the map based on zip code or other geolocation data

### 2. Screen Archetypes

* **Login:** Returning users can gain access to the app with a valid username and password.
   * Users can enter a valid username
   * Users can enter a valid password
   * Users are redirected to the Sign-Up screen (if necessary)
* **Sign-Up:** First time users can create an account that give them access to app features.
   * Users can create a valid username
   * Users can create a valid password
   * Users can enter their email
   * Users are immediately directed to the itinerary page after sign-up
* **Itinerary:** Users can log and view travel information such as flights, hotel bookings, transportation, and excursions.
   * Users can add, edit, and delete flight information
   * Users can add, edit, and delete hotel information
   * Users can add, edit, and delete transportation information
   * Users can add, edit, and delete existing information  
   * *Stretch Goal*: Users can invite friends to add, edit, and delete itinerary data
   * *Stretch Goal*: Users can receive notifications about what's next in their itinerary
* **Explore:** Users can view a map to see points of interest at their travel destination. 
   * Users can move around the map
   * Users can see pins with points of interest on the map
   * Users can review points of interest in a list view
   * *Stretch Goal*: Users can add points of interest to their itinerary
   * *Stretch Goal*: Users can search the map based on zip code or other geolocation data
* **Community:** Users can share and view images, videos, and posts about other user experiences.
   * Users can access their photo library
   * Users can post photos to a community feed
   * Users can post text blobs to a community feed
   * *Stretch Goal*: Users can like photos
   * *Stretch Goal*: Users can comment on photos
   * *Stretch Goal*: Users can edit their community posts
   * *Stretch Goal*: Users can delete their community posts

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Itinerary
* Explore
* Community

**Flow Navigation** (Screen to Screen)

* Login
   * Sign up (if NO account exists)
   * Itinerary tab (if account exists)
* Map
   * Map View
   * List View
* Community
   * Feed view
   * Post view
   * Photopicker if adding an image or video

## Wireframes

<img src="https://github.com/almontez/CodePathiOS-SP23-Project/blob/main/Read%20Me%20Media/wireframe.png" width=600>
