//
//  SceneListViewController.swift
//  ARtest
//
//  Created by Rafał Rybakowski on 18/07/2017.
//  Copyright © 2017 Rafał Rybakowski. All rights reserved.
//

import Foundation
import UIKit

class SceneListViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    let dateformatter = DateFormatter()
    var selectedIndex = 0
    
    override func viewDidLoad() {
        
        self.dateformatter.dateStyle = .short
        self.dateformatter.timeStyle = .medium
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }
    
    func dataSource() -> [Scene] {
        return SceneManager.shared.scenes()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSavedPlanes" {
            guard let destinationViewController = segue.destination as? SceneViewController else {return}
            let scene = self.dataSource()[self.selectedIndex]
            destinationViewController.planes = scene.planes()
        }
    }
    
    //MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Saved on \(self.dateformatter.string(from:self.dataSource()[indexPath.row].date))"
        
        return cell
    }
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Calibration", message: "Please put your phone in the same starting position you used for the saved scene.", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "Done", style: .default) { (action) in
            self.selectedIndex = indexPath.row
            self.performSegue(withIdentifier: "showSavedPlanes", sender: nil)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
