//
//  FirstViewController.swift
//  Week1.1
//
//  Created by iosdev on 9/2/17.
//  Copyright © 2017 iosdev. All rights reserved.
//

import UIKit
import RealmSwift

//var temp: [String] = []
var ayam: UILabel!

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var labelToDo: UILabel!
    @IBOutlet weak var tableView: UITableView!
    //var temp: [Todoes] = []
    var temp = List<Todoes>()
    var realm: Realm!
      
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        ayam = labelToDo
        loadDataRealm()
    }
    
    func loadDataRealm(){
        self.realm = try! Realm()
        let lists = realm.objects(Todoes.self)
        if self.temp.realm == nil, lists.count > 0{
            for list in lists{
                self.temp.append(list)
            }
        }
    }
    
    func prepareTable(){
        if temp.count < 1{
            labelToDo.isHidden = false
            tableView.isHidden = true
        }else{
            labelToDo.isHidden = true
            tableView.isHidden = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.delegate = self
        tableView.dataSource = self
        
        let secondNavController = tabBarController?.viewControllers?[1] as! UINavigationController
        let secondViewController = secondNavController.topViewController as? SecondViewController
        secondViewController?.delegate = self
        
        self.tableView.reloadData()
        
        prepareTable()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return temp.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! nicoViewCell
        let reuseableCell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! nicoViewCell
//        let name = temp[indexPath.row].todo
        let todosRealm = temp[indexPath.row]
        
//        cell.textLabel?.text = name
//        cell.dateLabel.text = temp[indexPath.row].dateandtime
        reuseableCell.textLabel?.text = todosRealm.todo
        reuseableCell.dateLabel.text = todosRealm.dateandtime
        
        return reuseableCell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete"){(action, indexPath) in
            
            try! self.realm.write {
                let list = self.temp[indexPath.row]
                self.realm.delete(list)
            }
            self.temp.remove(at: indexPath.row)
            tableView.reloadData()
            self.prepareTable()
        }
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "segue", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var indexPath = sender as! IndexPath
        if segue.identifier == "segue"{
            let vc: RunViewController = segue.destination as! RunViewController
            vc.ayam = temp[indexPath.row].todo
            vc.banteng = temp[indexPath.row].dateandtime
        }
    }
    
    func updateData(todoe: Todoes){
        //temp.append(todoe)
        let realm = try! Realm()
        
        try! realm.write {
            temp.insert(todoe, at: temp.count)
            realm.add(todoe)
        }
        tableView.reloadData()
    }
}

extension FirstViewController: SecondVCDelegate{
    func SecondViewControllerDidFinish(_ SecondVC: SecondViewController, didUpdateTodoes todoes: Todoes) {
        updateData(todoe: todoes)
    }
}

