//
//  PostTableViewCell.swift
//  daily
//
//  Created by tuanhoang pham on 27/10/15.
//  Copyright © 2015 tuanhoang pham. All rights reserved.
//

import Foundation
import UIKit
import Bond

class PostTableViewCell: UITableViewCell {
    @IBOutlet weak var postImageview: UIImageView!
    
    @IBOutlet weak var likesIconImageView: UIImageView!
    
    @IBOutlet weak var likesLabel: UILabel!
    
    @IBOutlet weak var moreButton: UIButton!
    
    
    @IBOutlet weak var likesButton: UIButton!
    
    var post: Post?{
        didSet{
            if let post = post{
                post.image.bindTo(postImageview.bnd_image)
            }
        }
    }
    
    //handle action buttons
    @IBAction func moreButtonTapped(sender: AnyObject){
        
    }
    
    @IBAction func likeButtonPressed(sender: AnyObject){
    
    }
    
    
}