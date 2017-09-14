//
//  AdoptBinViewController.swift
//  BaasTest
//
//  Created by JIAN LI on 9/11/17.
//  Copyright © 2017 JIAN LI. All rights reserved.
//

import UIKit
import DroiCoreSDK
import WilddogAuth
import WilddogCore
import WilddogSync
import SCLAlertView

enum DataType {
  case Bin, UnCheckedBin, Base, Note, Post
}

class userBehaviorViewController: UIViewController {
  
  var responder: SCLAlertView!
  var responderUpdate: SCLAlertViewResponder!
  var responderButton: UIButton!
  var name: String!
  var ref: WDGSyncReference!

  
  override func viewDidLoad() {
    super.viewDidLoad()
    initResponder()
      // Do any additional setup after loading the view.
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }
  
  @IBAction func recognizeBin(_ sender: Any) {
    /*
    //Droibaas SDK
    let bindata = BinsDroiData()
    bindata.user = DroiUser.getCurrent().userId
    bindata.latitude = 86.99823
    bindata.longitude = 134.972123
    bindata.dataType = "unChecked"
    
    let result = bindata.save()
    if result != nil{
      print("saving result is: \(String(describing: result?.message))!")
    }else{
      print("upload data sucessfully")
    }
 */
    //////////////////////////
    //...Wild Dog SDK
    showResponder(dataType: .UnCheckedBin)
  }
  
  @IBAction func adoptBinTapped(_ sender: Any) {
    showResponder(dataType: .Bin)
  }
  
  @IBAction func addBaseTapped(_ sender: Any) {
    showResponder(dataType: .Base)
  }

  func initResponder(){
    let appearance = SCLAlertView.SCLAppearance(
      kTitleFont: UIFont.preferredFont(forTextStyle: .caption2),
      kTextFont: UIFont.preferredFont(forTextStyle: .body),
      kButtonFont: UIFont.preferredFont(forTextStyle: .body),
      showCloseButton: false
    )
    responder = SCLAlertView(appearance: appearance)
    responderButton = responder.addButton("生成", action: {
      //
    })
    responderButton.isEnabled = false
  }
  
  func showResponder(dataType: DataType){
    switch dataType {
    case .Bin:
      let title = "生成垃圾箱"
      let subtitle = "点击按钮生成已认领垃圾箱"
      let tf = responder.addTextField("给垃圾箱起个名字")
      tf.addTarget(self, action: #selector(inputBinName), for: .editingChanged)
      responderUpdate = responder.showEdit(title, subTitle: subtitle)
    case .UnCheckedBin:
      let title = "生成垃圾箱"
      let subtitle = "点击按钮生成待认领垃圾箱"
      responderButton.isEnabled = true
      responderButton.addTarget(self, action: #selector(createUncheckedBin(_:)), for: .touchUpInside)
      responderUpdate = responder.showEdit(title, subTitle: subtitle)
    case .Base:
      let title = "生成基地"
      let subtitle = "点击按钮生成基地数据"
      let tf = responder.addTextField("给基地起个名字")
      tf.addTarget(self, action: #selector(inputBaseName), for: .editingChanged)
      responderUpdate = responder.showEdit(title, subTitle: subtitle)
    case .Note:
      let title = "生成笔记"
      let subtitle = "点击按钮生成笔记数据"
      responder.addButton("生成", target:self, selector: #selector(createBin(_:)))
      responderUpdate = responder.showEdit(title, subTitle: subtitle)
    default: break
    }
    
  }
  func inputBinName(_ textField: UITextField){
    if textField.text?.characters.count == 1 {
      if textField.text?.characters.first == " " {
        textField.text = ""
        return
      }
    }
    name = textField.text
    responderButton.isEnabled = true
    responderButton.addTarget(self, action: #selector(createBin(_:)), for: .touchUpInside)
  }
  
  func inputBaseName(_ textField: UITextField){
    if textField.text?.characters.count == 1 {
      if textField.text?.characters.first == " " {
        textField.text = ""
        return
      }
    }
    name = textField.text
    responderButton.isEnabled = true
    responderButton.addTarget(self, action: #selector(createBase(_:)), for: .touchUpInside)
  }
  
  
  func createBin(_ sender: UIButton){
    let latitude = Double(arc4random_uniform(89)) + drand48()
    let longitude = Double(arc4random_uniform(189)) + drand48()
    
    if let uid = WDGAuth.auth()?.currentUser!.uid{
      let bin: Dictionary<String, Any> = [
        "uid" : uid,
        "latitude" : latitude,
        "longitude" : longitude,
        "dataType" : "bin",
        "binName" : name
      ]
      let ref = WDGSync.sync().reference(withPath: "/users/\(uid)")
      ref.child("bins").childByAutoId().setValue(bin, withCompletionBlock: {
        error, ref in
        if (error != nil) {
          self.responderUpdate.setSubTitle("生成数据失败: \(String(describing: error?.localizedDescription))")
          //self.responderUpdate.close()
        }else{
          self.responderUpdate.close()
          let mapVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mapVC") as! MapViewController
          self.present(mapVC, animated: true, completion: nil)
        }
      })
    }
  }
  
  func createUncheckedBin(_ sender: UIButton){
    let latitude = Double(arc4random_uniform(89)) + drand48()
    let longitude = Double(arc4random_uniform(189)) + drand48()
    
    if let uid = WDGAuth.auth()?.currentUser!.uid{
      let suspicousBin: Dictionary<String, Any> = [
        "uid" : uid,
        "latitude" : latitude,
        "longitude" : longitude,
        "dataType" : "unChecked"
      ]
      let ref = WDGSync.sync().reference(withPath: "/users/\(uid)")
      ref.child("bins").childByAutoId().setValue(suspicousBin, withCompletionBlock: {
        error, ref in
          if (error != nil) {
            self.responderUpdate.setSubTitle("生成数据失败: \(String(describing: error?.localizedDescription))")
            self.responderUpdate.close()
          }else{
            self.responderUpdate.close()
            let mapVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mapVC") as! MapViewController
            self.present(mapVC, animated: true, completion: nil)
          }
      })
    }
  }
  
  func createBase(_ sender: UIButton){
    let latitude = Double(arc4random_uniform(89)) + drand48()
    let longitude = Double(arc4random_uniform(189)) + drand48()
    
    if let uid = WDGAuth.auth()?.currentUser!.uid{
      let base: Dictionary<String, Any> = [
        "uid" : uid,
        "latitude" : latitude,
        "longitude" : longitude,
        "dataType" : "base",
        "baseName" : name
      ]
      let ref = WDGSync.sync().reference(withPath: "/users/\(uid)")
      ref.child("base").childByAutoId().setValue(base, withCompletionBlock: {
        error, ref in
        if (error != nil) {
          self.responderUpdate.setSubTitle("生成数据失败: \(String(describing: error?.localizedDescription))")
          //self.responderUpdate.close()
        }else{
          self.responderUpdate.close()
          let mapVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mapVC") as! MapViewController
          self.present(mapVC, animated: true, completion: nil)
        }
      })
    }
  }

  @IBAction func logginOutTapped(_ sender: Any) {
    
    do {
      try WDGAuth.auth()?.signOut()
      let signInVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "singInVC") as? SignInViewController
      let appDelegate = UIApplication.shared.delegate as! AppDelegate
      appDelegate.window?.rootViewController = signInVC
      self.present(signInVC!, animated: true, completion: nil)
    }catch{
      let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      self.present(alert, animated: true, completion: nil)
    }
  }
  
  @IBAction func closeBinSurrounding(_ segue: UIStoryboardSegue){
    
  }
}
