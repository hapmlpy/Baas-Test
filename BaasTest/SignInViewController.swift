//
//  ViewController.swift
//  BaasTest
//
//  Created by JIAN LI on 9/10/17.
//  Copyright © 2017 JIAN LI. All rights reserved.
//

import UIKit
import DroiCoreSDK
import WilddogCore
import WilddogAuth
import WilddogSync

class SignInViewController: UIViewController {

  @IBOutlet weak var userphoneTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(true)
    // check if user is already signed in
    if WDGAuth.auth()?.currentUser != nil{
      let userbehaviorVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "behaviorVC") as? userBehaviorViewController
      let appDelegate = UIApplication.shared.delegate as! AppDelegate
      appDelegate.window?.rootViewController = userbehaviorVC
    }
  }

  @IBAction func signInTapped(_ sender: Any) {
    /*
    //使用DroiBaas SDK
    let user = User()
    user.userId = userphoneTextField.text!
    user.password = passwordTextField.text!

    var error: DroiError? = nil
    DroiUser.loginByUserClass(inBackground: user.userId, password: user.password, userClass: User.self, callback: {
      ( user, error) in
      if error?.isOk == true && user != nil && user?.isAuthorized() == true {
        if let userbehaviorVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "behaviorVC") as? userBehaviorViewController{
          self.present(userbehaviorVC, animated: true, completion: nil)
        }else{
          print("fail to find behavior vc")
        }
      }else{
        let alert = UIAlertController(title: "Error", message: error?.message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
      }
    })
    
    */
    ////////////////////////////////////////////
    //使用Wild Dog SDK
    guard userphoneTextField.text != "", passwordTextField.text != "" else { return }
    
    let phonenumber = userphoneTextField.text
    let password = passwordTextField.text

    //用户登录
    WDGAuth.auth()?.signIn(withPhone: phonenumber!, password: password!, completion: {
      user, error in 
      if error != nil {
        let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
      }else{
        //进入
        if let userbehaviorVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "behaviorVC") as? userBehaviorViewController{
          self.present(userbehaviorVC, animated: true, completion: nil)
        }
      }
    })
  }
  

  @IBAction func logginOutTapped(_ sender: Any) {

    /*
    //使用Droibass SDK
    let user = DroiUser.getCurrent()
    let result = user?.logout()
    
    if result!.isOk == true{
      let alert = UIAlertController(title: "Success", message: "loggin out", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      self.present(alert, animated: true, completion: nil)
    }else{
      let alert = UIAlertController(title: "Error", message: result?.message, preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      self.present(alert, animated: true, completion: nil)
    }
    
    */
    ////////////////////////////////////////////
    
    // 使用Wild Dog SDK
    do {
      try WDGAuth.auth()?.signOut()
      let alert = UIAlertController(title: "Success", message: "loggin out", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      self.present(alert, animated: true, completion: nil)
    }catch{
      let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      self.present(alert, animated: true, completion: nil)
    }
 
  }
}

