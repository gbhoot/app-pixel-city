//
//  PhotoService.swift
//  pixel-city
//
//  Created by Gurpreet Bhoot on 7/13/18.
//  Copyright © 2018 Gurpal Bhoot. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

class PhotoService {
    
    static let instance = PhotoService()
    
    var photoURLArray = [String]()
    //https://farm1.staticflickr.com/919/29492469888_165130428f_k_d.jpg
    
    func getURLs(forAnnotation annotation: DroppablePin, completionHandler: @escaping CompletionHandler) {
        Alamofire.request(flickrURL(forAPIKey: API_KEY_FLICKR, withAnnotaion: annotation, andNumberOfPhotos: NUM_OF_PHOTOS)).responseJSON { (response) in
//            print(response)
            if response.result.error == nil {
                guard let json = response.result.value as? Dictionary<String, AnyObject> else { return }
                let photosDict = json["photos"] as! Dictionary<String, AnyObject>
                let photosDictArray = photosDict["photo"] as! [Dictionary<String, AnyObject>]
                for photo in photosDictArray {
                    let postURL = "\(URL_BASE)\(photo["farm"]!)\(URL_FLICKR)\(photo["server"]!)/\(photo["id"]!)_\(photo["secret"]!)\(URL_END)"
                    self.photoURLArray.append(postURL)
                }
                
                completionHandler(true)
            } else {
                debugPrint(response.result.error as Any)
                completionHandler(false)
            }
        }
    }
}
