//
//  MapListCellTableViewCell.swift
//  BaasTest
//
//  Created by JIAN LI on 9/12/17.
//  Copyright © 2017 JIAN LI. All rights reserved.
//

import UIKit

class MapListCell: UITableViewCell {
  
  @IBOutlet weak var binNameLable: UILabel!
  @IBOutlet weak var checkBtn: UIButton!
  
  override func awakeFromNib() {
      super.awakeFromNib()
      // Initialization code
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)

      // Configure the view for the selected state
  }

}
