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
    var focusedEntry            : Search.Entry!
    
    var selected                : Int?
    
    var buttonForEdit           : UIBarButtonItem!
    var buttonForAdd            : UIBarButtonItem!
    
    static fileprivate let cellReuseIdentifier = "ViewForSearchEntry"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Search"
        
        self.buttonForAdd = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(ViewControllerForScreenManagerOfSearch.tapOnButtonAdd(_:)))
        
        self.buttonForEdit = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(ViewControllerForScreenManagerOfSearch.tapOnButtonEdit(_:)))
        self.buttonForEdit.possibleTitles = ["Edit","Done"]
        
        self.navigationItem.rightBarButtonItems = [
            self.buttonForEdit,
            self.buttonForAdd
        ]
        
        tableView.separatorStyle        = .singleLineEtched
        tableView.separatorColor        = Preferences.current.colorOfScreenSearchListSeparator.value ?? UIColor.red
        
        entries = Search.getAllEntries()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.entries = Search.getAllEntries()
        self.tableView.reloadData()
    }
    
    
    func update(from:Search.Entry, to:Search.Entry, refresh:Bool = true) {
        _ = Search.remove(entry: from)
        Search.add(entry: to)
        if refresh {
            self.entries = Search.getAllEntries()
            self.tableView.reloadData()
        }
    }
    
    func openSearch(with entry:Search.Entry) {
        if let search = self.storyboard?.instantiateViewController(withIdentifier: "ViewControllerForScreenSearch") as? ViewControllerForScreenSearch {
            self.focusedEntry = entry
            search.delegate = self
            self.show(search, sender: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let entry = entries[safe:indexPath.item] {
            self.selected = indexPath.item
            self.openSearch(with: entry)
        }
    }
    
    func tapOnButtonAdd(_ sender: UIBarButtonItem) {
        self.openSearch(with: Search.Entry(title:"Twitter"))
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

extension ViewControllerForScreenManagerOfSearch : ViewControllerForScreenSearchDelegate {
    
    func searchPhraseWasUpdated(to text: String) {
        if self.focusedEntry.title != text {
            let from = self.focusedEntry!
            let to = Search.Entry(title:text)
            self.update(from:from, to:to, refresh:false)
            self.focusedEntry = to
        }
    }
    
    var searchPhrase : String {
        return self.focusedEntry?.title ?? "?"
    }
    
}
