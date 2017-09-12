//
//  MapViewController.swift
//  BaasTest
//
//  Created by JIAN LI on 9/11/17.
//  Copyright © 2017 JIAN LI. All rights reserved.
//

import UIKit
import WilddogAuth
import WilddogCore
import WilddogSync

class MapViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
  
  var binInformation = NSMutableArray()
  
  let sectionTitle = [
    "unRegisterBin",
    "Bin",
    "Base"
  ]
  
  var assets = NSMutableArray()
  
  var ucCheckedBins = [BinWdgData]()
  
  @IBOutlet weak var mapList: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    mapList.delegate = self
    mapList.dataSource = self
    
    loadUnregisterBinData()
    assets = [ucCheckedBins]
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
  func loadUnregisterBinData(){
    let ref = WDGSync.sync().reference(withPath: "users")
    ref.child("bins").observeSingleEvent(of: .value, with: {
      snapshot in
      if let binDictionary = snapshot.value as? [String: AnyObject]{
        for (childKey, binProperitis) in binDictionary {
          if binProperitis["binType"] as! String == "unChecked"{
            let uncheckedbin = BinWdgData()
            uncheckedbin.uid = binProperitis["uid"] as? String
            uncheckedbin.latitude = binProperitis["latitude"] as? Double
            uncheckedbin.longitude = binProperitis["longitude"] as? Double
            uncheckedbin.binType = binProperitis["binType"] as? String
            uncheckedbin.binId = childKey
            self.ucCheckedBins.append(uncheckedbin)
          }
        }
        self.mapList.reloadData()
      }
    })
    ref.removeAllObservers()
  }
  
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return sectionTitle.count
  }
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return sectionTitle[section]
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    var count = Int()
    let section = sectionTitle[section]
    if section == "unRegisterBin"{
      count = ucCheckedBins.count
    }
//    if section == "bin"{
//    }
//    if section == "base"{
//    }
    return count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var cell = UITableViewCell()
        let section = sectionTitle[indexPath.section]
        if section == "unRegisterBin"{
          let cella = tableView.dequeueReusableCell(withIdentifier: "uncheckedBin", for: indexPath) as! SuspiciousBinCell
          let binPorperties = self.ucCheckedBins[indexPath.row]
          cella.delegate = self
          cella.rowIndex = indexPath.row
          cella.binNameLabel.text = binPorperties.binType
          cella.unCheckedBinID = binPorperties.binId
          cell = cella
    
        }
        //    if section == "bin" {
        //      let cella = tableView.dequeueReusableCell(withIdentifier: "adoptedBin", for: indexPath) as! AdoptBinCell
        //      cell = cella
        //    }
        //    if section == "base" {
        //      let cella = tableView.dequeueReusableCell(withIdentifier: "base", for: indexPath) as! baseCell
        //      cell = cella
        //    }
    return cell
  }
}

extension MapViewController: SuspiciousDelegate{
  func denyRegister(isDenyed: Bool, rowIndex: Int){
    if isDenyed == true{
      ucCheckedBins.remove(at: rowIndex)
      DispatchQueue.main.async{
        self.mapList.reloadData()
      }
    }else{
      print("no message")
    }
  }
}
