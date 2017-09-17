//
//  BinInforCell.swift
//  BaasTest
//
//  Created by JIAN LI on 9/15/17.
//  Copyright © 2017 JIAN LI. All rights reserved.
//

import UIKit

class BinInforCell: UITableViewCell {

  @IBOutlet weak var posterNameLabel: UILabel!
  @IBOutlet weak var postTimeLabel: UILabel!
  @IBOutlet weak var postContentLabel: UILabel!
  @IBOutlet weak var postType: UILabel!
  @IBOutlet weak var posterProfile: UIImageView!
  @IBOutlet weak var PostImage: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    print("cell initial")
    
    //posterProfile
    
    //dynamic change cell size according to image height
    if PostImage.image == nil{
      defalutImageHeightConstraint = imageHeightConstraint.constant
      imageHeightConstraint.constant = 0
      print("constrain changed")
      layoutIfNeeded()
    }
  }
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  

  @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
  var defalutImageHeightConstraint: CGFloat!
  
  override func prepareForReuse() {
    super.prepareForReuse()
    print("prepareforreuse")
    
    if defalutImageHeightConstraint != nil && imageHeightConstraint != nil{
      imageHeightConstraint.constant = defalutImageHeightConstraint
    }
  }
  
  
  @IBAction func likeBtnTapped(_ sender: UIButton){
    
  }
  @IBAction func replyTapped(_ sender: UIButton){
    
  }
  
  

}
