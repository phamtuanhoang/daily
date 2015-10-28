//
//  ParseHelper.swift
//  daily
//
//  Created by tuanhoang pham on 27/10/15.
//  Copyright © 2015 tuanhoang pham. All rights reserved.
//


import Foundation
import Parse
class ParseHelper{
    //following relation
    static let ParseFollowClass = "Follow"
    static let ParseFollowFromUser = "fromUser"
    static let ParseFollowToUser = "toUser"
    
    //like relation
    static let ParseLikeClass = "Like"
    static let ParseLikeToPost = "toPost"
    static let ParseLikeFromUser = "fromUser"
    
    //post relation
    static let ParsePostUser = "user"
    static let ParsePostCreateAt = "createAt"
    
    // flagged content relation
    static let ParseFlaggedContentClass = "FlaggedContent"
    static let ParseFlaggedContentFromUser = "fromUser"
    static let ParseFlaggedContentToPost = "toPost"
    
    //user Relation
    static let ParseUserUserName = "username"
    
    
    // 2
    static func timelineRequestForCurrentUser(completionBlock: PFQueryArrayResultBlock) {
        let followingQuery = PFQuery(className: ParseFollowClass)
        followingQuery.whereKey(ParseLikeFromUser, equalTo:PFUser.currentUser()!)
        
        let postsFromFollowedUsers = Post.query()
        postsFromFollowedUsers!.whereKey(ParsePostUser, matchesKey: ParseFollowToUser, inQuery: followingQuery)
        
        let postsFromThisUser = Post.query()
        postsFromThisUser!.whereKey(ParsePostUser, equalTo: PFUser.currentUser()!)
        
        let query = PFQuery.orQueryWithSubqueries([postsFromFollowedUsers!, postsFromThisUser!])
        query.includeKey(ParsePostUser)
        query.orderByDescending(ParsePostCreateAt)
        
        // 3
        let query1 = Post.query()
        query1?.orderByAscending(ParsePostCreateAt)
        query1?.findObjectsInBackgroundWithBlock(completionBlock)
    }
    
    
    //save a like from user
    static func likePost(user: PFUser, post: Post){
        let likeObject = PFObject(className: ParseLikeClass)
        likeObject[ParseLikeFromUser] = user
        likeObject[ParseLikeToPost] = post
        
        likeObject.saveInBackground()
    }
    
    //delete a like from user
    static func unlikePost(user: PFUser, post: Post){
        let query = PFQuery(className: ParseLikeClass)
        query.whereKey(ParseLikeFromUser, equalTo: user)
        query.whereKey(ParseLikeToPost, equalTo:post)
        
        query.findObjectsInBackgroundWithBlock {
            (results:[PFObject]?, error:NSError?) -> Void in
            if let results = results{
                for likes in results{
                    likes.deleteInBackground()
                }
            }
        }
    }
    
    //get all likes for a post
    static func likesForPost(post:Post, completionBlock: PFQueryArrayResultBlock){
        let query = PFQuery(className: ParseLikeClass)
        query.whereKey(ParseLikeToPost, equalTo:post)
        query.includeKey(ParseLikeFromUser)
        query.findObjectsInBackgroundWithBlock(completionBlock)
    }
    
}
