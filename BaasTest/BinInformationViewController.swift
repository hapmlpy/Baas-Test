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
  @IBOutlet weak var brandView: UIView!
  
  @IBOutlet weak var barView: UIView!
  @IBOutlet weak var postTableView: UITableView!
  
  var posts = [PostWdgData]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    postTableView.delegate = self
    postTableView.dataSource = self
    
    loadData()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  func loadData(){
    let ref = WDGSync.sync().reference(withPath: "posts")
    ref.observeSingleEvent(of: .value, with: {
      snapshot in
      if let postDictionary = snapshot.value as? [String: AnyObject]{
        for (childKey, postProperities) in postDictionary{
          let post = PostWdgData()
          post.postID = childKey
          post.postContent = postProperities["postContent"] as? String
          self.posts.append(post)
        }
        self.postTableView.reloadData()
      }
    })
    ref.removeAllObservers()
  }
  
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    
    return cell
  }
  

}
