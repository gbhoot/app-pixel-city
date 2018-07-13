//
//  Constants.swift
//  pixel-city
//
//  Created by Gurpreet Bhoot on 7/12/18.
//  Copyright © 2018 Gurpal Bhoot. All rights reserved.
//

import Foundation

typealias CompletionHandler = (_ Success: Bool) -> ()

// Numbers
let NUM_OF_PHOTOS                   =   40

// Keys
let API_KEY_FLICKR                  =   "91c1224c2159cabf6e686209ac6dc3e9"

// URLs
//https://farm1.staticflickr.com/919/29492469888_165130428f_k_d.jpg
let URL_BASE                        =   "https://farm"
let URL_FLICKR                      =   ".staticflickr.com/"
let URL_END                         =   "_h_d.jpg"

// Identifiers
let ID_DROP_PIN                     =   "droppablePin"
let ID_PHOTO_CELL                   =   "photoCell"

// Notification Constants
let NOTIF_PHOTO_DOWNLOADED          =   Notification.Name("photoDownloaded")

// Font Names
let AVENIR_FONT                     =   "Avenir"

// Sizes
let PULL_UP_VIEW_LBL_WIDTH          =   250.0
let PULL_UP_VIEW_LBL_HEIGHT         =   40.0

// Functions
func flickrURL(forAPIKey key: String, withAnnotaion annotation: DroppablePin, andNumberOfPhotos number: Int) -> String {
    return "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(key)&lat=\(annotation.coordinate.latitude)&lon=\(annotation.coordinate.longitude)&radius=1&radius_units=mi&per_page=\(number)&format=json&nojsoncallback=1"
//    return url
}
