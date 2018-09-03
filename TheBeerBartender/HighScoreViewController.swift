//
//  HighScoreViewController.swift
//  TheBeerBartender
//
//  Created by Israel on 15/05/2018.
//  Copyright © 2018 Israel. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class HighScoreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var nick: String = "NICK"
    var userList = [" No Internet Conection!","",""]
    var listScoore = [0,0,0]
    
    var ref: DatabaseReference!
    var handle: DatabaseHandle?
    var handleUserScore: DatabaseHandle?
    let userEmail = Auth.auth().currentUser?.email
    let userID = Auth.auth().currentUser?.uid
    
    @IBOutlet weak var userNameLablel: UILabel!
    @IBOutlet weak var scooreLabel: UILabel!
    @IBOutlet weak var tableScoore: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if listScoore.count <= 10{
            return listScoore.count
        }else {return 10}
    }
    //////
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableScoore.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = String(indexPath.row + 1)  + ") " + userList[indexPath.row]
        cell?.detailTextLabel?.text = "\(listScoore[indexPath.row])"
        return cell!
    }
    //////
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableScoore.delegate = self
        tableScoore.dataSource = self
        
        ref = Database.database().reference()
        
        //get the username

        ref.child("username").observeSingleEvent(of: .value){ (snapshot) in
            let myDict :[String : Any] = snapshot.value as! [String : Any]

            for (key, value) in myDict{
                if (self.userID! == (key)){
                    self.nick = value as! String
                    self.userNameLablel.text = self.nick
                    //get  the highscore
                    self.ref.child("highscore").observe(.value) { (snapshot) in
                        let userHiScoore = snapshot.childSnapshot(forPath: self.nick).value as? Int ?? 0
                        self.scooreLabel.text = String(userHiScoore)
                        if (newScore > userHiScoore ){
                            //alert: "New hiscore"
                            if (userHiScoore != 0){
            let alert = UIAlertController(title: "congratulations!", message: "You've got a new hiscore!!!", preferredStyle: .alert)
                                
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default , handler: { _ in
                                }))
                                self.present(alert, animated: true, completion: nil)
                            }
                            // setValue "newHiScore"
                    self.ref.child("highscore").child(self.nick).setValue(newScore)
                        }
                        newScore = 0
                        
                        let myDict :[String : Int] = snapshot.value as! [String : Int]
                        
                        var arr = [Int]()
                        var arr2 = [String]()
                        
                        let sortDict = myDict.sorted(by: { $0.value > $1.value })
                        for (key, value) in sortDict{
                            arr.append(value)
                            arr2.append(key)
                            self.listScoore = arr
                            self.userList = arr2
                            self.tableScoore.reloadData()
                        }
                    }
                }}}}
    
    //logout:
    @IBAction func logout(_ sender: Any) {
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            dismiss(animated: true, completion: nil)
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    //Play
    @IBAction func play(_ sender: Any) {
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let gameViewController: GameViewController = storyboard.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
        self.present(gameViewController, animated: true, completion: nil)
    }
}


