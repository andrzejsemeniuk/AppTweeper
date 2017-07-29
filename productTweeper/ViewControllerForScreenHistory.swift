//
//  ViewControllerForScreenHistory.swift
//  productTweeper
//
//  Created by andrzej semeniuk on 7/4/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import UIKit
import ASToolkit

class ViewControllerForScreenHistory : UITableViewController {
    
    var entries                 : [StoreForSearch.Entry] = []
    
    var buttonForEdit           : UIBarButtonItem!
    
    static fileprivate let cellReuseIdentifier = "ViewForSearchEntry"
    
    var searchController        : ViewControllerForScreenSearch?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "History"
        
        self.buttonForEdit = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(ViewControllerForScreenHistory.tapOnButtonEdit(_:)))
        self.buttonForEdit.possibleTitles = ["Edit","Done"]
        
        self.navigationItem.rightBarButtonItems = [
            self.buttonForEdit
        ]
        
        tableView.separatorStyle        = .singleLineEtched
        tableView.separatorColor        = AppDelegate.instance.preferences.colorOfScreenSearchListSeparator.value
        
        entries = AppDelegate.instance.storeForSearch.getAllEntries()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.entries = AppDelegate.instance.storeForSearch.getAllEntries()
        self.tableView.reloadData()
    }
    
    
    func popBackToSearch(withText text:String) {
        self.searchController?.lastSearchText = text
        self.navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let entry = entries[safe:indexPath.item] {
            self.popBackToSearch(withText: entry.title)
        }
    }
    
    func tapOnButtonEdit(_ sender: UIBarButtonItem) {
        if tableView.isEditing {
            tableView.setEditing(false, animated: true)
            self.buttonForEdit.title = "Edit"
            self.buttonForEdit.style = .plain
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.75) {
                self.tableView.reloadData()
            }
        }
        else {
            tableView.setEditing(true, animated: true)
            self.buttonForEdit.title = "Done"
            self.buttonForEdit.style = .done
        }
    }


    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            if 1 == AppDelegate.instance.storeForSearch.remove(entry:entries[indexPath.item]) {
                entries = AppDelegate.instance.storeForSearch.getAllEntries()
                tableView.deleteRows(at: [indexPath], with: .left)
            }
            else {
                entries = AppDelegate.instance.storeForSearch.getAllEntries()
            }
        case .insert:
            self.entries.insert(StoreForSearch.Entry(title:"??"), at: indexPath.item)
        case .none:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let item = indexPath.item
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        
        if let entry = entries[safe:item] {
            
            cell.textLabel?.attributedText = entry.title | UIColor(white:170.0/255.0)
            
            let created = entry.created.components(separatedBy: ".")[safe:0] ?? entry.created
            
            cell.detailTextLabel?.attributedText = created | UIColor(white:210.0/255.0)
        }
        
        cell.backgroundColor = item.isOdd ? UIColor(white:0.97) : UIColor.white
        
//        cell.indentationLevel = item
        
        cell.selectionStyle = UITableViewCellSelectionStyle.default
        
        cell.accessoryType = .none
        
        return cell
    }
}

