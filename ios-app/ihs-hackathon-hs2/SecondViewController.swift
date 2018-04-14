//
//  SecondViewController.swift
//  ihs-hackathon-hs2
//
//  Created by Kuba Domaszewicz on 14.04.2018.
//  Copyright © 2018 hs2. All rights reserved.
//

import UIKit
import Foundation
import Nuke

class FriendCell: UITableViewCell {
    
    static let identifier: String = "FriendCell"
    
    @IBOutlet var avatar: UIImageView!
    @IBOutlet var value: UILabel!
    @IBOutlet var fullname: UILabel!
    
    override func layoutSubviews() {
        
        avatar.layer.cornerRadius = avatar.frame.height / 2
        avatar.clipsToBounds = true
    }
}

extension UIColor {
    
    convenience init(rgbColorCodeRed red: Int, green: Int, blue: Int, alpha: CGFloat) {
        
        let redPart: CGFloat = CGFloat(red) / 255
        let greenPart: CGFloat = CGFloat(green) / 255
        let bluePart: CGFloat = CGFloat(blue) / 255
        
        self.init(red: redPart, green: greenPart, blue: bluePart, alpha: alpha)
        
    }
}

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView?

    var friends: [Friend] = []
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 64
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
//        super.viewDidAppear(animated)
        Friend.getFriendsHallOfFame(startDate: Date(), endDate: Date(), category: "") { (friends) in

            self.friends = friends
            
            self.tableView?.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell: FriendCell = tableView.dequeueReusableCell(withIdentifier: FriendCell.identifier) as? FriendCell {
            
            cell.fullname.text = friends[indexPath.row].fullname
            cell.value.text = "\(friends[indexPath.row].value) steps"
            cell.avatar.image = nil
            if let url = URL(string: friends[indexPath.row].avatarURL) {
                Nuke.loadImage(with: url, into: cell.avatar!)
            }
            
            if (indexPath.row % 2 == 0) {
                cell.backgroundColor = UIColor.white
            } else {
                cell.backgroundColor = UIColor(red: 252.0/255.0, green: 252.0/255.0, blue: 255.0/255.0, alpha: 255.0/255.0)
            }
            
            return cell
        }
        
        return UITableViewCell()
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if let tableView = tableView {
      
            let nib = UINib(nibName: "FriendCell", bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: FriendCell.identifier)
        }
    }
}

