//
//  CafeListTableViewController.swift
//  CafeApp
//
//  Created by Machir on 2022/8/17.
//

import UIKit

class CafeListTableViewController: UITableViewController, UISearchBarDelegate {
    
    var cafe = [Cafe]()
    let urlStr = "https://cafenomad.tw/api/v1.2/cafes"
    var filteredItems: [Cafe] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MenuController.shared.fetchData(urlStr: urlStr) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let cafe):
                    print("成功---")
                    self.cafe = cafe
                    self.filteredItems = self.cafe
                    self.tableView.reloadData()
                case .failure(let error):
                    print("失敗---\(error)")
                }
            }
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return filteredItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(CafeListTableViewCell.self)", for: indexPath) as! CafeListTableViewCell

        let item = filteredItems[indexPath.row]
        cell.cafeNameLabel.text = item.name
        
        return cell
    }
    
    func search(_ searchTerm: String) {
        if searchTerm.isEmpty {
            filteredItems = cafe
        } else {
            filteredItems = cafe.filter({
                $0.name.contains(searchTerm)
            })
        }
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchTerm = searchBar.text ?? ""
        self.search(searchTerm)
        searchBar.resignFirstResponder()
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
        let controller = segue.destination as? CafeDetailTableViewController
        let cell = sender as! UITableViewCell
        if let row = tableView.indexPath(for: cell)?.row {
            controller?.cafeData = filteredItems[row]
            print(filteredItems[row].name)
        }
        
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
