//
//  BinSurroundingTableViewController.swift
//  BaasTest
//
//  Created by JIAN LI on 9/14/17.
//  Copyright © 2017 JIAN LI. All rights reserved.
//

import UIKit
import WilddogCore
import WilddogSync
import WilddogAuth
import SCLAlertView

class BinSurroundingTableViewController: UITableViewController {

  var uid: String!
  var datas = NSMutableArray()
  
  var binOwnerName: String!
  var binOwnerId: String!
  var onBinId: String!
  
  var responder: SCLAlertView!
  var responderUpdate: SCLAlertViewResponder!
  var responderButton: UIButton!
  var responderTextField: UITextField!
  var isResponderFisrtTimeShow = true
  
  //message contents
  var message = ""
  var time = ""
  var isbadMes = false
  
  //accuse contents
  var photoURL = ""
  
  override func viewDidLoad() {
    super.viewDidLoad()
    uid = WDGAuth.auth()?.currentUser?.uid
    loadData()
    initResponder()
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }
  
  func loadData(){
    var userpath = [String]()
    //遍历users,获得路径
    let ref = WDGSync.sync().reference().child("users")
    ref.observeSingleEvent(of: .value, with: {
      snapshot in
      if let userDictionary = snapshot.value as? [String : AnyObject]{
        for (key, _) in userDictionary {
          userpath.append(key)
        }
        self.tableView.reloadData()
      }
      //只留下别人的数据路径
      if let myIDIndex = userpath.index(of: self.uid!){
        userpath.remove(at: myIDIndex)
        
        for userId in userpath{
          //获得每个用户的用户名
          let uidpath = ref.child("\(userId)")
          uidpath.observeSingleEvent(of: .value, with: {
            snap in
            //这层是字典 userid : [userassets]
            if let userassets = snap.value as? [String : AnyObject]{
              //这层是array: [bins : {binid}, "name": "..."]
              if let username = userassets["name"], let userid = userassets["uid"], let binfolders = userassets["bins"] as? [String : AnyObject] {
                for perfolder in binfolders{
                  if let foldercontents = perfolder.value as? [String : AnyObject]{
                    
                    if let binbin = foldercontents["binName"] as? String {
                      let data: Dictionary<String, String> = [
                        "ownername" : (username as? String)!,
                        "ownerid" : (userid as? String)!,
                        "binname" : binbin
                      ]
                      self.datas.add(data)
                    }else{
                      let data: Dictionary<String, String> = [
                        "ownername" : (username as? String)!,
                        "ownerid" : (userid as? String)!,
                        "binname" : "未命名"
                      ]
                      self.datas.add(data)
                    }
                  }
                }
              }
              self.tableView.reloadData()
            }
          })
          ref.removeAllObservers()
        }//end of getting bins data
      }else{
        print("can't find current uid")
      }//end looping users
    })//end get path
  }

  // MARK: - Table view data source
  override func numberOfSections(in tableView: UITableView) -> Int {
      return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return datas.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? OthersBinCell
    
    if let ub = datas[indexPath.row] as? [String: String]{
      if let ownername = ub["ownername"], let ownerid = ub["ownerid"], let binname = ub["binname"] {
        binOwnerName = ownername
        binOwnerId = ownerid
        onBinId = binname
        cell?.binIdLabel.text = binname
        cell?.ownerLabel.text = ownername
      }
      cell?.delegate = self
    }
    return cell!
  }

}

extension BinSurroundingTableViewController: OtherBinDelegate{
  
  func initResponder(){
    let appearance = SCLAlertView.SCLAppearance(
      kTitleFont: UIFont.preferredFont(forTextStyle: .caption2),
      kTextFont: UIFont.preferredFont(forTextStyle: .body),
      kButtonFont: UIFont.preferredFont(forTextStyle: .body),
      showCloseButton: false
    )
    responder = SCLAlertView(appearance: appearance)
    responderButton = responder.addButton("完成", action: {
      //
    })
    responderButton.isEnabled = false
  }
  
  func leaveMeassageTapped(isAccuse: Bool) {
    self.isbadMes = isAccuse
    let title = isAccuse ? "举报" : "留消息"
    let subtitle = isAccuse ? "这个垃圾箱有什么问题" : "给垃圾箱主人写点什么"

    if isResponderFisrtTimeShow == true{
      responderTextField = responder.addTextField("....")
      responderTextField.addTarget(self, action: #selector(inputMessage), for: .editingChanged)
    }else{
      responderTextField.addTarget(self, action: #selector(inputMessage), for: .editingChanged)
    }
    responderUpdate = responder.showEdit(title, subTitle: subtitle)
    isResponderFisrtTimeShow = false
    
  }
  func inputMessage(_ textField: UITextField){
    if textField.text?.characters.count == 1 {
      if textField.text?.characters.first == " " {
        textField.text = ""
        return
      }
    }
    message = textField.text!
    responderButton.isEnabled = true
    responderButton.addTarget(self, action: #selector(leaveMessage(_:)), for: .touchUpInside)
  }
  
  func leaveMessage(_ sender: UIButton){
    if let uid = WDGAuth.auth()?.currentUser!.uid{
      let mes: Dictionary<String, Any> = [
        "who" : uid,
        "toWho" : binOwnerName,
        "mContent" : message,
        "mTime" : "",
        "mId" : "",
        "mType": isbadMes ? "accuse" : "message",
        "onBinId" : onBinId
      ]
      
      if let binownerid = binOwnerId{
        let ref = WDGSync.sync().reference(withPath: "/users/\(binownerid)")
        ref.child("post").childByAutoId().setValue(mes, withCompletionBlock: {
          error, ref in
          if (error != nil) {
            self.responderUpdate.setSubTitle("生成数据失败: \(String(describing: error?.localizedDescription))")
          }else{
            self.responderTextField.text = ""
            self.responderTextField.removeTarget(nil, action: nil, for: UIControlEvents.allEvents)
            self.responderButton.removeTarget(nil, action: nil, for: UIControlEvents.allEvents)
            self.responderUpdate.close()
            let titlegood = "发送成功"
            let titlebad = "提交成功"
            let subtitlegood = "垃圾箱主人将会受到您的信息"
            let subtitlebad = "收到您的上报,如果属实，垃圾箱主人会受到惩罚，但如果恶意举报会遭报应的哦"
            let _ = SCLAlertView().showInfo(self.isbadMes ? titlebad : titlegood,
                                            subTitle: self.isbadMes ? subtitlebad : subtitlegood)
          }
        })
      }
    }
  }
}
