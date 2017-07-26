//
//  GenericControllerOfList
//  productGroceries
//
//  Created by Andrzej Semeniuk on 3/25/16.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import UIKit

class GenericControllerOfList : UITableViewController
{
    var items:[String]                      = []
    
    var selected:String!                    = nil
    
    var handlerForCellForRowAtIndexPath     : ((_ controller:GenericControllerOfList,_ indexPath:IndexPath) -> UITableViewCell)! = nil
    
    var handlerForDidSelectRowAtIndexPath   : ((_ controller:GenericControllerOfList,_ indexPath:IndexPath) -> Void)! = nil
    
    var handlerForCommitEditingStyle        : ((_ controller:GenericControllerOfList,_ commitEditingStyle:UITableViewCellEditingStyle,_ indexPath:IndexPath) -> Bool)! = nil
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.dataSource        = self
        
        tableView.delegate          = self
        
        //        tableView.separatorStyle    = .None
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
    
    
    override func numberOfSections              (in: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView                     (_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return items.count
    }
    
    override func tableView                     (_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if handlerForCellForRowAtIndexPath != nil {
            return handlerForCellForRowAtIndexPath(self,indexPath)
        }
        
        let name = items[indexPath.row]
        
        let cell = UITableViewCell(style:.default,reuseIdentifier:nil)
        
        if let label = cell.textLabel {
            label.text = name
        }
        
        cell.selectionStyle = .default
        
        if selected != nil && selected == name {
            cell.accessoryType = .checkmark
        }
        
        return cell
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if handlerForDidSelectRowAtIndexPath != nil {
            handlerForDidSelectRowAtIndexPath(self,indexPath)
        }
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if handlerForCommitEditingStyle != nil {
            if handlerForCommitEditingStyle(self,editingStyle,indexPath) {
                switch editingStyle
                {
                case .none:
                    print("None")
                case .delete:
                    items.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath as IndexPath], with:.left)
                case .insert:
                    print("Add")
                }
                
            }
        }
    }
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        tableView.reloadData()
        
        super.viewWillAppear(animated)
    }
    
    
    
    
    
    
    
}
