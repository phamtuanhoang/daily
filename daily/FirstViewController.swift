//
//  FirstViewController.swift
//  daily
//
//  Created by tuanhoang pham on 27/10/15.
//  Copyright © 2015 tuanhoang pham. All rights reserved.
//

import UIKit
import Parse
class FirstViewController: UIViewController {
    
    @IBOutlet weak var mainTableView: UITableView!
    
    var photoTakingHelper: PhotoHelper?
    var posts: [Post] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.        
        self.tabBarController?.delegate = self
        
        ParseHelper.timelineRequestForCurrentUser { (result:[PFObject]?, error:NSError?) -> Void in
            self.posts = result as? [Post] ?? []
//            for post in self.posts{
//                do{
//                    let data = try post.imageFile?.getData()
//                    post.image = UIImage(data: data!,scale:1.0)
//                    print("Download")
//
//                }catch _{
//                    print(error)
//                }
//                
//            }
            self.mainTableView!.reloadData()

        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    //handle take photo
    func takePhoto(){
        //instantiate photo taking class, provide callback
        photoTakingHelper = PhotoHelper(viewController: self.tabBarController!, callback: { (image: UIImage?) in
            print("TakeOhoto")

            let post = Post()
            post.image.value = image!
            post.uploadPost()
        })
    }


}





//extension tab bar delage


extension FirstViewController: UITabBarControllerDelegate{
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        if (viewController is SecondViewController) {
            takePhoto()
            return false
        } else {
            return true
        }
    }
}


extension FirstViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 1
        return posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // 2
        let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as! PostTableViewCell
        
//                cell.textLabel!.text = "Post"
//        cell.postImageview.image = posts[indexPath.row].image
        let post = posts[indexPath.row]
        post.downloadImage()
        cell.post = post
        
        return cell
    }
    
}
