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

class userBehaviorViewController: UIViewController {
  let latitude = 64.333
  let longitude = 145.893
  
  override func viewDidLoad() {
    super.viewDidLoad()
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
    bindata.binType = "unChecked"
    
    let result = bindata.save()
    if result != nil{
      print("saving result is: \(String(describing: result?.message))!")
    }else{
      print("upload data sucessfully")
    }
 */

    //////////////////////////
    //...Wild Dog SDK
    //当前用户的数据
    if let uid = WDGAuth.auth()?.currentUser!.uid{
      let suspicousBin: Dictionary<String, Any> = [
        "uid" : uid,
        "latitude" : latitude,
        "longitude" : longitude,
        "binType" : "unChecked"
      ]
      let ref = WDGSync.sync().reference(withPath: "users")
      //ref.child("bins").setValue(suspicousBin, withCompletionBlock: {
      ref.child("bins").childByAutoId().setValue(suspicousBin, withCompletionBlock: {
        error, ref in
//        if (error != nil) {
//          let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
//          alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//          self.present(alert, animated: true, completion: nil)
//        }else{
//          let alert = UIAlertController(title: "Success", message: "save this suspicous bin sucessfully", preferredStyle: .alert)
//          alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//          self.present(alert, animated: true, completion: nil)
//        }
      })
    }
    
    let mapVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mapVC") as! MapViewController
    self.present(mapVC, animated: true, completion: nil)
  }
  
  @IBAction func adoptBinTapped(_ sender: Any) {
  }
  
  @IBAction func addBaseTapped(_ sender: Any) {
  }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
