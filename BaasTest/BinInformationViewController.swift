//
//  BinInformationViewController.swift
//  BaasTest
//
//  Created by JIAN LI on 9/11/17.
//  Copyright © 2017 JIAN LI. All rights reserved.
//

import UIKit
import WilddogAuth
import WilddogCore
import WilddogSync
import Hero

class BinInformationViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
  @IBOutlet weak var postTableView: UITableView!
  
  var posts = [PostWdgData]()
  //定位路径
  var userid: String!
  var binid: String?
  var postid: String!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    postTableView.delegate = self
    postTableView.dataSource = self
    loadPostData()
    
    //动态适应cell的高
    postTableView.estimatedRowHeight = postTableView.rowHeight
    postTableView.rowHeight = UITableViewAutomaticDimension
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  func loadPostData(){
    if let uid = userid, let binuid = binid{
      let ref = WDGSync.sync().reference(withPath: "/users/\(uid)/bins/\(binuid)")
      ref.child("post").observeSingleEvent(of: .value, with: {
        snapshot in
        if let postDictionary = snapshot.value as? [String: AnyObject]{
          for (postKey, postProperities) in postDictionary{
            let post = PostWdgData()
            post.postId = postKey
            post.postContent = (postProperities["postContent"] as? String)!
            post.authorName = (postProperities["authorName"] as? String)!
            post.time = (postProperities["time"] as? Int)!
            post.postType = (postProperities["postType"] as? String)!
            self.posts.append(post)
            
            print("post.postContent \(post.postContent)")
          }
          self.postTableView.reloadData()
        }
      })
      ref.removeAllObservers()
    }
  }
  
  // MARK: - TableView Delegate
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return posts.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var cell = UITableViewCell()
    if let cella = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? BinInforCell {
      let post = posts[indexPath.row]
      cella.postContentLabel.text = post.postContent
      cella.posterNameLabel.text = post.authorName
      cella.postType.text = post.postType
      cella.posterProfile.image = UIImage(named: "userPlaceHolderImage")
      cella.PostImage.image = nil
      let showTime = postTime(fromthistime: post.time)
      cella.postTimeLabel.text = showTime
      cell = cella
    }
    return cell
  }
  
  func postTime(fromthistime: Int) -> String {
    let timenow = Int(Date().timeIntervalSinceReferenceDate)
    let duration: Int = Int(timenow - fromthistime)
    
    var showTime = ""
    let mins = duration/60
    if mins >= 60{
      let hours: Int = duration/3600
      if hours >= 24 {
        let days: Int = hours/24
        if days >= 7{
          let weeks = days/7
          if weeks >= 4 {
            let months = weeks/4
            if months >= 12{
              let years = months/12
              if years >= 100 {
                showTime = "很久以前"
              }else{
                showTime = "\(years)年"
              }
            }else{
              showTime = "\(months)月"
            }
          }else{
            showTime = "\(weeks)星期"
          }
        }else{
          showTime = "\(days)天"
        }
      }else{
        showTime = "\(hours)小时"
      }
    }else{
      showTime = "\(mins)分钟"
    }
    if mins < 1 {
      showTime = "\(duration)秒"
    }
    return showTime
  }
}
