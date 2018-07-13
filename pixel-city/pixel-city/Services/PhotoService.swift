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
    
    // Variables
    var photoURLArray = [String]()
    var imageArray = [UIImage]()
    
    //https://farm1.staticflickr.com/919/29492469888_165130428f_k_d.jpg
    
    func getURLs(forAnnotation annotation: DroppablePin, handler: @escaping CompletionHandler) {
        photoURLArray.removeAll()
        
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
                
                handler(true)
            } else {
                debugPrint(response.result.error as Any)
                handler(false)
            }
        }
    }
    
    func retrieveImages(handler: @escaping CompletionHandler) {
        imageArray.removeAll()
        
        for url in photoURLArray {
            Alamofire.request(url).responseImage { (response) in
                
                if response.result.error == nil {
                    guard let image = response.result.value else { return }
                    self.imageArray.append(image)
                    
                    // Do number work with progress label
                    NotificationCenter.default.post(name: NOTIF_PHOTO_DOWNLOADED, object: nil)

                    if self.imageArray.count == self.photoURLArray.count {
                        handler(true)
                    }
                } else {
                    debugPrint(response.result.error as Any)
                    handler(false)
                }
            }
        }
    }
    
    func cancelAllSessions() {
        Alamofire.SessionManager.default.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in
            sessionDataTask.forEach({ $0.cancel() })
            downloadData.forEach({ $0.cancel() })
        }
    }
}
