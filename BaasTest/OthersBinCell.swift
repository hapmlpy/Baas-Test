//
//  OthersBinCell.swift
//  BaasTest
//
//  Created by JIAN LI on 9/14/17.
//  Copyright © 2017 JIAN LI. All rights reserved.
//

import UIKit

protocol OtherBinDelegate {
  func leaveMeassageTapped(isAccuse: Bool, onBin: String)
}

class OthersBinCell: UITableViewCell {

  @IBOutlet weak var binIdLabel: UILabel!
  @IBOutlet weak var ownerLabel: UILabel!
  
  var binId: String!
  
  var delegate: OtherBinDelegate?
  
    override func awakeFromNib() {
        super.awakeFromNib()
        print("recive binid from surrounding vc: \(binId)")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

  @IBAction func leaveMeassge(_ sender: Any) {
    self.delegate?.leaveMeassageTapped(isAccuse: false, onBin: binId)
  }
  @IBAction func leaveAccuse(_ sender: Any) {
    print("return binId to surrounding vc: \(binId) ")
    self.delegate?.leaveMeassageTapped(isAccuse: true, onBin: binId)
  }
}
