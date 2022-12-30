//
//  CityCafeListTableViewController.swift
//  CafeApp
//
//  Created by Machir on 2022/11/26.
//

import UIKit

class CityCafeListTableViewController: UITableViewController {
    
    var cityCafeListData: City!
    var cafe = [Cafe]()
    var searching = false
    var searchedCafe = [Cafe]()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var myActivity: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        myActivity.startAnimating()
        MenuController.shared.fetchData(urlStr: self.cityCafeListData.api) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let cafe):
                    self.cafe = cafe
                    self.tableView.reloadData()
                    self.myActivity.stopAnimating()
                    self.myActivity.hidesWhenStopped = true
                case .failure(let error):
                    print(error)
                }
            }
        }
        self.navigationItem.title = cityCafeListData.name
        searchBar.delegate = self
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if searching {
            return searchedCafe.count
        } else {
            return cafe.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(CityCafeListTableViewCell.self)", for: indexPath) as! CityCafeListTableViewCell
        if searching {
            let item = searchedCafe[indexPath.row]
            cell.cafeNameLabel.text = item.name
            cell.cafeAddressLabel.text = item.address
        } else {
            let item = cafe[indexPath.row]
            cell.cafeNameLabel.text = item.name
            cell.cafeAddressLabel.text = item.address
        }
        return cell
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let controller = segue.destination as? CafeDetailTableViewController
        let cell = sender as! UITableViewCell
        if let row = tableView.indexPath(for: cell)?.row {
            if searching {
                controller?.cafeData = searchedCafe[row]
            } else {
                controller?.cafeData = cafe[row]
            }
        }
    }
    

}

extension CityCafeListTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedCafe = cafe.filter({ $0.name.lowercased().prefix(searchText.count) == searchText.lowercased()
        })
        searching = true
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tableView.reloadData()
    }
}
