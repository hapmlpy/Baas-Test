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
    "UnRegisterBin",
    "Bin",
    "Base"
  ]
  
  var assets = NSMutableArray()
  
  var ucCheckedBins = [BinWdgData]()
  var bins = [BinWdgData]()
  var bases = [BaseWdgData]()
  var notes = [BinWdgData]()
  
  @IBOutlet weak var mapList: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    mapList.delegate = self
    mapList.dataSource = self
    loadData()
    assets = [ucCheckedBins, bins, bases]
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  func loadData(){
    if let uid = WDGAuth.auth()?.currentUser!.uid{
      let ref = WDGSync.sync().reference(withPath: "/users/\(uid)")
      
      ref.child("bins").observeSingleEvent(of: .value, with: {
        snapshot in
        if let binDictionary = snapshot.value as? [String: AnyObject]{
          for (childKey, binProperitis) in binDictionary {
            if binProperitis["dataType"] as! String == "unChecked"{
              let uncheckedbin = BinWdgData()
              uncheckedbin.uid = binProperitis["uid"] as? String
              uncheckedbin.latitude = binProperitis["latitude"] as? Double
              uncheckedbin.longitude = binProperitis["longitude"] as? Double
              uncheckedbin.dataType = binProperitis["dataType"] as? String
              uncheckedbin.binId = childKey
              self.ucCheckedBins.append(uncheckedbin)
            }
            if binProperitis["dataType"] as! String == "bin"{
              let bin = BinWdgData()
              bin.uid = binProperitis["uid"] as? String
              bin.latitude = binProperitis["latitude"] as? Double
              bin.longitude = binProperitis["longitude"] as? Double
              bin.dataType = binProperitis["dataType"] as? String
              bin.binId = childKey
              if binProperitis["binName"] as! String != ""{
                bin.binName = binProperitis["binName"] as! String
              }else{
                bin.binName = "还未起名"
              }
              self.bins.append(bin)
            }
          }
          self.mapList.reloadData()
        }
      })
      
      ref.child("base").observeSingleEvent(of: .value, with: {
        snapshot in
        if let baseDictionary = snapshot.value as? [String: AnyObject]{
          for (childKey, baseProperitis) in baseDictionary{
            let base = BaseWdgData()
            base.uid = baseProperitis["uid"] as? String
            base.latitude = baseProperitis["latitude"] as? Double
            base.longitude = baseProperitis["longitude"] as? Double
            base.dataType = baseProperitis["dataType"] as? String
            base.baseId = childKey
            if baseProperitis["baseName"] as! String != ""{
              base.baseName = baseProperitis["baseName"] as! String
            }else{
              base.baseName = "还未起名"
            }
            self.bases.append(base)
          }
          self.mapList.reloadData()
        }
      })
      ref.removeAllObservers()
    }// confirm current user id
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
    if section == "UnRegisterBin"{
      count = ucCheckedBins.count
      print("UnRegisterBin count: \(count)")
    }
    if section == "Bin"{
      count = bins.count
      print("bin count: \(count)")
    }
    if section == "Base"{
      count = bases.count
    }
    return count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var cell = UITableViewCell()
    let section = sectionTitle[indexPath.section]
    if section == "UnRegisterBin"{
      let cella = tableView.dequeueReusableCell(withIdentifier: "uncheckedBin", for: indexPath) as! SuspiciousBinCell
      let binPorperties = self.ucCheckedBins[indexPath.row]
      cella.delegate = self
      cella.adoptedBin = binPorperties
      cella.rowIndex = indexPath.row
      
      cella.binNameLabel.text = binPorperties.dataType
      cella.unCheckedBinID = binPorperties.binId
      cell = cella

    }
    if section == "Bin" {
      let cella = tableView.dequeueReusableCell(withIdentifier: "adoptedBin", for: indexPath) as! AdoptBinCell
      let binPorperties = self.bins[indexPath.row]
      cella.delegate = self
      cella.binNameLabel.text = binPorperties.binName
      cell = cella
    }
    if section == "Base" {
      let cella = tableView.dequeueReusableCell(withIdentifier: "base", for: indexPath) as! baseCell
      let basePorperties = self.bases[indexPath.row]
      cella.baseNameLabel.text = basePorperties.baseName
      cell = cella
    }
    return cell
  }
}

extension MapViewController: SuspiciousDelegate,AdoptBinDelegate,BaseDelegate{
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
  
  func adoptThisBin(isAdopted: Bool, rowIndex: Int, bin: BinWdgData){
    if isAdopted == true{
      ucCheckedBins.remove(at:rowIndex)
      bins.append(bin)
      DispatchQueue.main.async{
        self.mapList.reloadData()
      }
    }
  }
  
  func checkBinInformationTapped(isTapped: Bool) {
    if isTapped == true {
      print("go to information vc")
      let binInforVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "binInfroVC") as? BinInformationViewController
      self.present(binInforVC!, animated: true, completion: nil)
    }
  }
  
  func checkBaseInformationTapped(isTapped: Bool) {
    //
  }
}

