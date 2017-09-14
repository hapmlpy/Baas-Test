//
//  RegisterViewController.swift
//  BaasTest
//
//  Created by JIAN LI on 9/11/17.
//  Copyright © 2017 JIAN LI. All rights reserved.
//

import UIKit
import DroiCoreSDK
import WilddogAuth
import WilddogSync
import WilddogCore

class RegisterViewController: UIViewController {

  @IBOutlet weak var usernameTextField: UITextField!
  @IBOutlet weak var userphoneTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!

  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }
    
  @IBAction func createAccountTapped(_ sender: Any) {
    /*
    //使用DoridBass SDK
    let user = User()
    user.userId = userphoneTextField.text!
    user.password = passwordTextField.text!
    
    let result = user.signUp()
    if result!.isOk == true{
      let alert = UIAlertController(title: "Success", message: "Account Created", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      self.present(alert, animated: true, completion: nil)
    }else{
      let alert = UIAlertController(title: "Error", message: result?.message, preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      self.present(alert, animated: true, completion: nil)
    }
    //储存用户数据
    let userData: DroiObject = DroiObject.create(withClassName: "User")
    userData.putKey("name", andValue: user.userId)
    userData.putKey("password", andValue: user.password)
    userData.save(inBackground: {
      error in
      print(error)
    })
    */

    //使用Wild Dog SDK
    guard userphoneTextField.text != "", passwordTextField.text != "", usernameTextField.text != "" else { return }
    
    let phonenumber = userphoneTextField.text
    let password = passwordTextField.text
    
    //用户管理建立新用户
    WDGAuth.auth()?.createUser(withPhone: phonenumber!, password: password!, completion: {
      user, error in
      if (error != nil) {
        //建立用户失败
        let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
      }else{
        let alert = UIAlertController(title: "Success", message: "You sign up successfuly", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        if let user = user {
          let newUser: Dictionary<String, Any> = [
            "uid": user.uid,
            "name": self.usernameTextField.text!,
            "phone": user.phone!,
            "photoURL": "\(user.photoURL!)"
          ]
          
          let ref = WDGSync.sync().reference()
          ref.child("users").child(user.uid).setValue(newUser, withCompletionBlock: {
            error, ref in
            if let error2 = error {
              print("用户数据储存失败：\(error2.localizedDescription))")
            }else{
              let alert = UIAlertController(title: "Success", message: "user data is saved successfuly", preferredStyle: .alert)
              alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
              self.present(alert, animated: true, completion: nil)
            }
          })
        }
      }
    })
    
  }
}
