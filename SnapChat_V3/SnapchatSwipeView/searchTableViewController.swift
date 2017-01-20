//
//  searchTableViewController.swift
//  SnapChat-V3
//
//  Created by lavintyben on 16/10/10.
//  Copyright © 2016年 Brendan Lee. All rights reserved.
//

import UIKit

class searchTableViewController: UITableViewController {
    
    var searchResults: [String] = []
    var testData: [String] = ["Xiaolei Liu", "Huahua", "Hejia"]

    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
    }
    
// -----------------------------table View ------------------------------
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return searchResults.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let titleLabel = cell.viewWithTag(10) as! UILabel
        
        titleLabel.text = searchResults[indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

}

// -----------------------------Search bar ------------------------------
extension searchTableViewController: UISearchBarDelegate{
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String){
    
        // Send the searchText to the server whenever the text did change
        // ...
        
        // Change the result array
        self.searchResults = self.testData.filter({
            (searchResult:String) -> Bool in
            
            let stringMatch = searchResult.rangeOfString(searchText)
            return (stringMatch != nil)
        })
        
        //reload the table view
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        // Send the searchText to the server whenever the search button is clicked
        // ...
        
        searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
}
