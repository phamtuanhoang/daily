//
//  Post.swift
//  dailystuff
//
//  Created by hoangpham on 19/10/15.
//  Copyright © 2015 hoangpham. All rights reserved.
//

import Foundation
import Parse
import Bond
// 1
class Post : PFObject, PFSubclassing {
    
    // 2
    @NSManaged var imageFile: PFFile?
    @NSManaged var user: PFUser?
//    var image: UIImage?
    var image:Observable<UIImage?> = Observable(nil)
    var likes:Observable<[PFUser]?> = Observable(nil)
    
    var photoUploadTask: UIBackgroundTaskIdentifier?
    
    //MARK: PFSubclassing Protocol
    
    // 3
    static func parseClassName() -> String {
        return "Post"
    }
    
    // 4
    override init () {
        super.init()
    }
    
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            // inform Parse about this subclass
            self.registerSubclass()
        }
    }
    
    func uploadPost() {
        if let image = image.value{
            // 1
            photoUploadTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler { () -> Void in
                UIApplication.sharedApplication().endBackgroundTask(self.photoUploadTask!)
            }
            let imageData = UIImageJPEGRepresentation(image, 0.8)
            let imageFile = PFFile(data: imageData!)
            imageFile!.saveInBackgroundWithBlock(nil)
            user = PFUser.currentUser()
            user!.saveInBackground()
            
            self.imageFile = imageFile
            // 2
            imageFile!.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                // 3
                UIApplication.sharedApplication().endBackgroundTask(self.photoUploadTask!)
            }
        }
    }
    
    func downloadImage(){
        //if image not download, get it
        if(image.value == nil){
            //2
            imageFile?.getDataInBackgroundWithBlock({ (data: NSData?, error: NSError?) -> Void in
                if let data = data{
                    let image = UIImage(data: data, scale:1.0)
                    self.image.value = image
                }
            })
        }
    }
    
    //fetching like 
    func fetchLikes(){
        if(likes.value != nil){
            return
        }
        ParseHelper.likesForPost(self) { (var likes:[PFObject]?, error:NSError?) -> Void in
            likes = likes?.filter{like in like[ParseHelper.ParseLikeFromUser] != nil}
            
        }
    
    }
    
}