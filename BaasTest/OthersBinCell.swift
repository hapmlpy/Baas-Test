//
//  OthersBinCell.swift
//  BaasTest
//
//  Created by JIAN LI on 9/14/17.
//  Copyright © 2017 JIAN LI. All rights reserved.
//

import UIKit

protocol OtherBinDelegate {
  func leaveMeassageTapped(isTapped: Bool)
  func leaveAccuseTapped(isTapped: Bool)
}

class OthersBinCell: UITableViewCell {

  @IBOutlet weak var binIdLabel: UILabel!
  @IBOutlet weak var ownerLabel: UILabel!
  
  var delegate: OtherBinDelegate?
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

  @IBAction func leaveMeassge(_ sender: Any) {
    self.delegate?.leaveMeassageTapped(isTapped: true)
  }
  @IBAction func leaveAccuse(_ sender: Any) {
    self.delegate?.leaveAccuseTapped(isTapped: true)
  }
}
