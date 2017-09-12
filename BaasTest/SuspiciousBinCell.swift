//
//  suspiciousBinCell.swift
//  BaasTest
//
//  Created by JIAN LI on 9/12/17.
//  Copyright © 2017 JIAN LI. All rights reserved.
//

import UIKit
import WilddogAuth
import WilddogCore
import WilddogSync

protocol SuspiciousDelegate {
  func denyRegister(isDenyed: Bool, rowIndex: Int)
}

class SuspiciousBinCell: UITableViewCell {

  @IBOutlet weak var binNameLabel: UILabel!
  
  var unCheckedBinID: String!
  var rowIndex: Int?
  var delegate: SuspiciousDelegate?
  
  override func awakeFromNib() {
      super.awakeFromNib()
      // Initialization code
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)

      // Configure the view for the selected state
  }
  
  @IBAction func registerTapped(_ sender: Any){
  
  }
  
  @IBAction func denyTapped(_ sender: Any){
    print("deny tapped inside")
    let ref = WDGSync.sync().reference(withPath: "users")
    //let keyToBin = ref.child("bins").childByAutoId().key
    
    ref.child("bins").child(unCheckedBinID).removeValue(completionBlock: {
      snapshot in
      print("remove \(snapshot)")
      let error = snapshot.0
      if error == nil{
        self.delegate?.denyRegister(isDenyed: true, rowIndex: self.rowIndex!)
      }
    })

    
    ref.child("bins").observeSingleEvent(of: .value, with: {
      snap in
      if let currentData = snap.value as? [String: AnyObject]{
        let countingThis = currentData.values
        print("current data count is \(countingThis.count)")
      }
    })
    
    ref.removeAllObservers()
  }
  
  @IBAction func transitTapped(_ sender: Any){
    
  }

}
