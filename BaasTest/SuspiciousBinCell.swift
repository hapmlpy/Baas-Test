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
import Hero

protocol SuspiciousDelegate {
  func denyRegister(isDenyed: Bool, rowIndex: Int)
  func adoptThisBin(isAdopted: Bool, rowIndex: Int, bin: BinWdgData)
}

class SuspiciousBinCell: UITableViewCell {

  @IBOutlet weak var binNameLabel: UILabel!
  
  // values passed from map vc
  var unCheckedBinID: String!
  var rowIndex: Int?
  var adoptedBin: BinWdgData?
  
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
    let updateType: [String: AnyObject] = ["dataType" : "bin" as AnyObject]
    
    let ref = WDGSync.sync().reference(withPath: "users")
    ref.child("bins").child(unCheckedBinID).updateChildValues(updateType, withCompletionBlock: {
      snapshot in
      let error = snapshot.0
      if error == nil {
        self.adoptedBin?.dataType = "bin"
        self.delegate?.adoptThisBin(isAdopted: true, rowIndex: self.rowIndex!, bin: self.adoptedBin!)
      }
      
    })
  }
  
  @IBAction func denyTapped(_ sender: Any){
    let ref = WDGSync.sync().reference(withPath: "users")
    ref.child("bins").child(unCheckedBinID).removeValue(completionBlock: {
      snapshot in
      let error = snapshot.0
      if error == nil{
        self.delegate?.denyRegister(isDenyed: true, rowIndex: self.rowIndex!)
      }
    })
    ref.removeAllObservers()
  }
  
  @IBAction func transitTapped(_ sender: Any){
    
  }

}
