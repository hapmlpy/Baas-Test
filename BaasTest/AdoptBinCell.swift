//
//  AdoptBinCell.swift
//  BaasTest
//
//  Created by JIAN LI on 9/12/17.
//  Copyright © 2017 JIAN LI. All rights reserved.
//

import UIKit

protocol AdoptBinDelegate {
  func checkBinInformationTapped(isTapped: Bool)
}

class AdoptBinCell: UITableViewCell {
  
  var delegate: AdoptBinDelegate?

  @IBOutlet weak var binNameLabel: UILabel!
  override func awakeFromNib() {
      super.awakeFromNib()
      // Initialization code
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)

      // Configure the view for the selected state
  }
  
  @IBAction func checkBinInformation(_ sender: Any){
    self.delegate?.checkBinInformationTapped(isTapped: true)
  }

}
