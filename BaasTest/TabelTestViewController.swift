//
//  TabelTestViewController.swift
//  BaasTest
//
//  Created by JIAN LI on 9/17/17.
//  Copyright © 2017 JIAN LI. All rights reserved.
//

import UIKit

class TabelTestViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  @IBOutlet weak var broadTable: UITableView!
  override func viewDidLoad() {
      super.viewDidLoad()

      // Do any additional setup after loading the view.
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "boardCell", for: indexPath) as? BinInforCell
    
    return cell!
  }

}
