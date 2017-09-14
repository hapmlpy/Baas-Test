//
//  baseCell.swift
//  BaasTest
//
//  Created by JIAN LI on 9/12/17.
//  Copyright © 2017 JIAN LI. All rights reserved.
//

import UIKit

protocol BaseDelegate {
  func checkBaseInformationTapped(isTapped: Bool)
}

class baseCell: UITableViewCell {

  var delegate: BaseDelegate?
  @IBOutlet weak var baseNameLabel: UILabel!
  override func awakeFromNib() {
      super.awakeFromNib()
      // Initialization code
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)

      // Configure the view for the selected state
  }

  @IBAction func checkBaseInformation(_ sender: Any) {
    self.delegate?.checkBaseInformationTapped(isTapped: true)
  }
}
