//
//  ViewControllerForScreenManagerOfSearch.swift
//  productTweeper
//
//  Created by andrzej semeniuk on 7/4/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import UIKit
import ASToolkit

class ViewControllerForScreenManagerOfSearch : UITableViewController {
    
    var entries                 : [Search.Entry] = []
    
    var selected                : Int?
    
    var buttonForEdit           : UIBarButtonItem!
    var buttonForAdd            : UIBarButtonItem!
    
    static fileprivate let cellReuseIdentifier = "ViewForSearchEntry"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.buttonForAdd = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(ViewControllerForScreenManagerOfSearch.tapOnButtonAdd(_:)))
        
        self.buttonForEdit = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(ViewControllerForScreenManagerOfSearch.tapOnButtonEdit(_:)))
        self.buttonForEdit.possibleTitles = ["Edit","Done"]
        self.buttonForEdit.title = "Edit"
        
        self.navigationItem.rightBarButtonItems = [
            self.buttonForAdd,
            self.buttonForEdit
        ]
        
        self.title = "Search"
        
        tableView.separatorStyle        = .singleLineEtched
        tableView.separatorColor        = Preferences.current.colorOfScreenSearchListSeparator
        
        entries = Search.getAllEntries()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tapOnButtonAdd(_ sender: UIBarButtonItem) {
        let newEntry = Search.Entry(title:"NEW")
        Search.add(entry:newEntry)
        entries = Search.getAllEntries()
        tableView.reloadData()
        
        if let search = self.storyboard?.instantiateViewController(withIdentifier: "ViewControllerForScreenSearch") as? ViewControllerForScreenSearch {
            self.show(search, sender: sender)
            
            search.search.text = newEntry.title
            search.handleRefresh()
        }
    }
    
    func tapOnButtonEdit(_ sender: UIBarButtonItem) {
        if tableView.isEditing {
            tableView.setEditing(false, animated: true)
            self.buttonForEdit.title = "Edit"
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.75) {
                self.tableView.reloadData()
            }
        }
        else {
            tableView.setEditing(true, animated: true)
            self.buttonForEdit.title = "Done"
        }
    }

}

extension ViewControllerForScreenManagerOfSearch {
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            if 1 == Search.remove(entry:entries[indexPath.item]) {
                entries = Search.getAllEntries()
                tableView.deleteRows(at: [indexPath], with: .left)
            }
            else {
                entries = Search.getAllEntries()
            }
        case .insert:
            self.entries.insert(Search.Entry(title:"??"), at: indexPath.item)
        case .none:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let entry = entries[safe:indexPath.item] {
            self.selected = indexPath.item
            if let search = self.storyboard?.instantiateViewController(withIdentifier: "ViewControllerForScreenSearch") as? ViewControllerForScreenSearch {
                self.show(search, sender: nil)
                search.search.text = entry.title
                search.handleRefresh()
            }
        }
    }
}

extension ViewControllerForScreenManagerOfSearch {
    
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
        
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
}
