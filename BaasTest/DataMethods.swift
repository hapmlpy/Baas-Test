//
//  DataModelWDG.swift
//  BaasTest
//
//  Created by JIAN LI on 9/13/17.
//  Copyright © 2017 JIAN LI. All rights reserved.
//

import Foundation
import WilddogAuth
import WilddogCore
import WilddogSync

class DataMethods {
  
  func loadUnCheckBinData(for tableView: UITableView) ->[BinWdgData]{
    var uncheckBinDatas = [BinWdgData]()
    let ref = WDGSync.sync().reference(withPath: "users")
    ref.child("bins").observeSingleEvent(of: .value, with: {
      snapshot in
      if let binDictionary = snapshot.value as? [String: AnyObject]{
        for (childKey, binProperitis) in binDictionary {
          if binProperitis["dataType"] as! String == "unChecked"{
            let uncheckedbin = BinWdgData()
            uncheckedbin.uid = binProperitis["uid"] as? String
            uncheckedbin.latitude = binProperitis["latitude"] as? Double
            uncheckedbin.longitude = binProperitis["longitude"] as? Double
            uncheckedbin.dataType = binProperitis["dataType"] as? String
            uncheckedbin.binId = childKey
            uncheckBinDatas.append(uncheckedbin)
          }
        }
        tableView.reloadData()
      }
    })
    ref.removeAllObservers()
    return uncheckBinDatas
  }
  
  func loadBinData(for tableView: UITableView) ->[BinWdgData]{
    var binDatas = [BinWdgData]()
    let ref = WDGSync.sync().reference(withPath: "users")
    ref.child("bins").observeSingleEvent(of: .value, with: {
      snapshot in
      if let binDictionary = snapshot.value as? [String: AnyObject]{
        for (childKey, binProperitis) in binDictionary {
          if binProperitis["dataType"] as! String == "bin"{
            let bin = BinWdgData()
            bin.uid = binProperitis["uid"] as? String
            bin.latitude = binProperitis["latitude"] as? Double
            bin.longitude = binProperitis["longitude"] as? Double
            bin.dataType = binProperitis["dataType"] as? String
            bin.binId = childKey
            if binProperitis["binName"] as! String != ""{
              bin.binName = binProperitis["binName"] as! String
            }else{
              bin.binName = "还未起名"
            }
            binDatas.append(bin)
          }
        }
        tableView.reloadData()
      }
    })
    ref.removeAllObservers()
    return binDatas
  }
  
  func loadBaseData(for tableView: UITableView) ->[BaseWdgData]{
    var baseDatas = [BaseWdgData]()
    let ref = WDGSync.sync().reference(withPath: "users")
    ref.child("base").observeSingleEvent(of: .value, with: {
      snapshot in
      if let baseDictionary = snapshot.value as? [String: AnyObject]{
        for (childKey, baseProperitis) in baseDictionary{
          let base = BaseWdgData()
          base.uid = baseProperitis["uid"] as? String
          base.latitude = baseProperitis["latitude"] as? Double
          base.longitude = baseProperitis["longitude"] as? Double
          base.dataType = baseProperitis["dataType"] as? String
          base.baseId = childKey
          if baseProperitis["baseName"] as! String != ""{
            base.baseName = baseProperitis["baseName"] as! String
          }else{
            base.baseName = "还未起名"
          }
          baseDatas.append(base)
        }
        tableView.reloadData()
      }
    })
    ref.removeAllObservers()
    return baseDatas
  }
  
  func loadPostData(or tableView: UITableView) ->[PostWdgData]{
    var postDatas = [PostWdgData]()
    let ref = WDGSync.sync().reference(withPath: "posts")
    ref.observeSingleEvent(of: .value, with: {
      snapshot in
      if let postDictionary = snapshot.value as? [String: AnyObject]{
        for (childKey, postProperities) in postDictionary{
          let post = PostWdgData()
          post.postID = childKey
          post.postContent = postProperities["postContent"] as? String
          postDatas.append(post)
        }
        tableView.reloadData()
      }
    })
    ref.removeAllObservers()
    return postDatas
  }
  
}

