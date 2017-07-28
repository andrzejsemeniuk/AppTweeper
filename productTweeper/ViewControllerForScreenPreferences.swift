//
//  ViewControllerForScreenPreferences.swift
//  productTweeper
//
//  Created by andrzej semeniuk on 7/4/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import UIKit
import ASToolkit

class ViewControllerForScreenPreferences : GenericControllerOfSettings {
    
    override func viewDidLoad()
    {
        tableView.separatorStyle = .none
        
        super.manager = AppDelegate.instance.preferences
        
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
    override func createRows() -> [[Any]]
    {
        return [
            [
                "SETTINGS",
                
                { (cell:UITableViewCell, indexPath:IndexPath) in
                    if let label = cell.detailTextLabel {
                        label.text = AppDelegate.instance.preferences.name.value
                    }
                    if let label = cell.textLabel {
                        label.text          = "Save"
                        cell.selectionStyle = .default
                        self.registerCellSelection(indexPath: indexPath) {
                            let alert = UIAlertController(title:"Save Settings", message:"Specify name for current settings.", preferredStyle:.alert)
                            
                            alert.addTextField() {
                                field in
                                // called to configure text field before displayed
                                field.text = AppDelegate.instance.preferences.name.value
                            }
                            
                            let actionSave = UIAlertAction(title:"Save", style:.default, handler: {
                                action in
                                
                                if let fields = alert.textFields, let text = fields[0].text {
                                    if 0 < text.length {
                                        AppDelegate.instance.preferences.name.value = text
                                        
                                        print(UserDefaults.standard.dictionaryRepresentation())
                                        
                                        self.tableView.reloadRows(at: [
                                            indexPath,
                                            IndexPath(row:indexPath.row+1,section:indexPath.section) as IndexPath
                                            ],
                                                                  with: .left)
                                    }
                                }
                            })
                            
                            let actionCancel = UIAlertAction(title:"Cancel", style:.cancel, handler: {
                                action in
                            })
                            
                            alert.addAction(actionSave)
                            alert.addAction(actionCancel)
                            
                            UIApplication.rootViewController.present(alert, animated:true, completion: {
                                print("completed showing add alert")
                            })
                        }
                    }
                },
                
                { (cell:UITableViewCell, indexPath:IndexPath) in
                    if let label = cell.textLabel {
                        label.text          = "Load"
                        if AppDelegate.instance.preferences.styles.value.isEmpty {
                            cell.selectionStyle = .none
                            cell.accessoryType  = .none
                        }
                        else {
                            cell.selectionStyle = .default
                            cell.accessoryType  = .disclosureIndicator
                        }
                        self.registerCellSelection(indexPath: indexPath) {
                            let list = AppDelegate.instance.preferences.styles.value
                            
                            print("settings list =\(list)")
                            
                            if 0 < list.count {
                                let controller = GenericControllerOfList()
/*
                                controller.items = AppDelegate.instance.preferences.settingsList().sorted()
                                controller.handlerForDidSelectRowAtIndexPath = { controller, indexPath in
                                    let selected = controller.items[indexPath.row]
                                    _ = AppDelegate.instance.preferences.settingsUse(selected)
                                    UIApplication.rootViewController.view.backgroundColor = AppDelegate.instance.preferences.settingsGetBackgroundColor()
                                    //                                    AppDelegate.controllerOfPages.view.backgroundColor  = AppDelegate.instance.preferences.settingsGetBackgroundColor()
                                    controller.navigationController!.popViewController(animated: true)
                                }
                                controller.handlerForCommitEditingStyle = { controller, commitEditingStyle, indexPath in
                                    if commitEditingStyle == .delete {
                                        let selected = controller.items[indexPath.row]
                                        _ = AppDelegate.instance.preferences.settingsRemove(selected)
                                        return true
                                    }
                                    return false
                                }
                                */
                                self.navigationController?.pushViewController(controller, animated:true)
                            }
                        }
                    }
                },
                
                "Save current settings, or load previously saved settings"
            ],
            /*
            [
                "TEST",
                
                createCellForUIFontName             (AppDelegate.instance.preferences.testFontName, title:"test font name"),
                
                createCellForUIFont                 (AppDelegate.instance.preferences.testFont, title:"test font"),
                
                createCellForUIColor                (AppDelegate.instance.preferences.testColor, title:"test color"),

                createCellForUITextFieldAsString    (AppDelegate.instance.preferences.testString, count:12, title:"test String"),
                
                createCellForUITextFieldAsDouble    (AppDelegate.instance.preferences.testDouble, title:"test Double"),
                
                createCellForUITextFieldAsCGFloat   (AppDelegate.instance.preferences.testCGFloat, title:"test CGFloat"),
                
                createCellForUITextFieldAsInt       (AppDelegate.instance.preferences.testInt, title:"test Int"),
                
                createCellForBool                   (AppDelegate.instance.preferences.testBool, title:"test Bool"),
                
                
                ""
            ],
            */
            [
                "MAIN MENU",
                
                createCellForUITextFieldAsDouble(AppDelegate.instance.preferences.durationOfMainMenuDisplay, title:"Duration") { value in
                },

                createCellForUITextFieldAsDouble(AppDelegate.instance.preferences.durationOfMainMenuDisplayInitially, title:"Initial Duration") { value in 
                },
                
                createCellForUISlider(AppDelegate.instance.preferences.testCGFloat, title:"Opacity"),
                
                "Set selection properties for rows on all tabs"
            ],
            
            [
                "SELECTION",
                
                createCellForUIColor(AppDelegate.instance.preferences.colorOfTitleText,title:"Selection") {
                },
                
                createCellForUISlider(AppDelegate.instance.preferences.testCGFloat, title:"Opacity"),
                
                "Set selection properties for rows on all tabs"
            ],
            
            [
                "APP",
                
                createCellForUIColor(AppDelegate.instance.preferences.colorOfBackground,name:"Background",title:"Background") {
                    UIApplication.rootViewController.view.backgroundColor   = AppDelegate.instance.preferences.colorOfBackground.value
                    self.view.backgroundColor                               = AppDelegate.instance.preferences.colorOfBackground.value
                },
                
                createCellForBool(AppDelegate.instance.preferences.audio, title:"Audio"),
                
                
                "Set app properties"
            ],
            
            
        ]
    }
    
    
    
    
    override func tableView                     (_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = super.tableView(tableView, cellForRowAt:indexPath)
        
        cell.selectedBackgroundView = UIView.createWithBackgroundColor(AppDelegate.instance.preferences.colorOfSelection.value)
        
        return cell
    }
    
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        tableView.backgroundColor   = AppDelegate.instance.preferences.colorOfBackground.value
        
        colorForHeaderText          = AppDelegate.instance.preferences.colorOfHeaderText.value
        colorForFooterText          = AppDelegate.instance.preferences.colorOfFooterText.value
        
        super.viewWillAppear(animated)
    }
    
    
    
}
