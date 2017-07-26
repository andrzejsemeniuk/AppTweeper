//
//  GenericControllerOfFonts
//  productGroceries
//
//  Created by Andrzej Semeniuk on 3/25/16.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import UIKit

class GenericControllerOfPickerOfFont : UITableViewController
{
    var names:[String]  = []
    
    var selected:String = ""
    
    
    
    override func viewDidLoad()
    {
        tableView.dataSource        = self
        
        tableView.delegate          = self
        
        tableView.separatorStyle    = .none

        
        names = []
        
        for family in UIFont.familyNames {
//            names.append(family)
            for font in UIFont.fontNames(forFamilyName: family) {
                print("family \(family), font \(font)")
                names.append(font)
            }
        }
        
        print("font names:\(names)")
        
        reload()
        
        
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
        // TODO clear data and reload table
    }
    
    
    
    
    
    override func numberOfSections      (in: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView             (_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return names.count
    }
    
    override func tableView             (_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let name = names[indexPath.row]
        
        let cell = UITableViewCell(style:.default,reuseIdentifier:nil)
        
        if let label = cell.textLabel {
            label.text          = name
            //            label.textColor = UIColor.grayColor()
            label.font          = UIFont(name:name,size:UIFont.labelFontSize)
            label.textAlignment = .left
        }
        
        cell.selectionStyle = .default
        cell.accessoryType  = name == selected ? .checkmark : .none
        
        return cell
    }
    
    
    
    
    func reload()
    {
        names = names.sorted()
        
        tableView.reloadData()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        reload()
        
        if let row = names.index(of: selected) {
            let path = IndexPath(row:row,section:0)
            tableView.scrollToRow(at: path as IndexPath,at:.middle,animated:true)
        }
        
        super.viewWillAppear(animated)
    }
    
    
    
    var update: (() -> ()) = {}
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        selected = names[indexPath.row]
        
        reload()
        
        update()
    }
    
}
