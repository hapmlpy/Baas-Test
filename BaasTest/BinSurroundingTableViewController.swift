//
//  BinSurroundingTableViewController.swift
//  BaasTest
//
//  Created by JIAN LI on 9/14/17.
//  Copyright © 2017 JIAN LI. All rights reserved.
//

import UIKit
import WilddogCore
import WilddogSync
import WilddogAuth

class BinSurroundingTableViewController: UITableViewController {

  var uid: String!
  var datas = NSMutableArray()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    uid = WDGAuth.auth()?.currentUser?.uid
    loadData()
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }
  
  func loadData(){
    var userpath = [String]()
    //遍历users,获得路径
    let ref = WDGSync.sync().reference().child("users")
    ref.observeSingleEvent(of: .value, with: {
      snapshot in
      if let userDictionary = snapshot.value as? [String : AnyObject]{
        for (key, _) in userDictionary {
          userpath.append(key)
          print("get a user form data: \(key)")
        }
        self.tableView.reloadData()
      }
      //只留下别人的数据路径
      if let myIDIndex = userpath.index(of: self.uid!){
        userpath.remove(at: myIDIndex)
        
        for userId in userpath{
          //获得每个用户的用户名
          let uidpath = ref.child("\(userId)")
          uidpath.observeSingleEvent(of: .value, with: {
            snap in
            //这层是字典 userid : [userassets]
            if let userassets = snap.value as? [String : AnyObject]{
              //这层是array: [bins : {binid}, "name": "..."]
              if let username = userassets["name"], let binfolders = userassets["bins"] as? [String : AnyObject] {
                for perfolder in binfolders{
                  if let foldercontents = perfolder.value as? [String : AnyObject]{
                    let ub: [String : String] = [(username as? String)! : foldercontents["binName"]! as! String]
                    self.datas.add(ub)
                  }
                }
              }
              self.tableView.reloadData()
            }
          })
          ref.removeAllObservers()
        }//end of getting bins data
      }else{
        print("can't find current uid")
      }//end looping users
    })//end get path
  }

  // MARK: - Table view data source
  override func numberOfSections(in tableView: UITableView) -> Int {
      return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    print(datas.count)
    return datas.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? OthersBinCell
    let ub = datas[indexPath.row] as! [String: AnyObject]
    cell?.binIdLabel.text = ub.keys.first
    cell?.ownerLabel.text = ub.values.first as? String
    return cell!
  }


  /*
  // Override to support conditional editing of the table view.
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
      // Return false if you do not want the specified item to be editable.
      return true
  }
  */

  /*
  // Override to support editing the table view.
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete {
          // Delete the row from the data source
          tableView.deleteRows(at: [indexPath], with: .fade)
      } else if editingStyle == .insert {
          // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
      }    
  }
  */

  /*
  // Override to support rearranging the table view.
  override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

  }
  */

  /*
  // Override to support conditional rearranging of the table view.
  override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
      // Return false if you do not want the item to be re-orderable.
      return true
  }
  */

  /*
  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      // Get the new view controller using segue.destinationViewController.
      // Pass the selected object to the new view controller.
  }
  */

}
