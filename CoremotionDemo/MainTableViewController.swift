//
//  MainTableViewController.swift
//  CoreAnimation
//
//  Created by Vega on 2016/10/30.
//  Copyright © 2016年 Jia Wei. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Core Motion"
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = ["Gravity Behavior", "Views Gravity Motion Manager", "Attached Gravity Motion Manager", "Drifting View", "Collision Behavior", "Single View Gravity Motion Manager", "Starbucks  Cup"][indexPath.row]
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            let vc = BoxViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = BoxesViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc = ChainBoxesViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case 3:
            let vc = DriftingViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case 4:
            let vc = CollisionViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case 5:
            let vc = MotionViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case 6:
            let vc = StarbucksViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            return
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 33
    }    
    
}
