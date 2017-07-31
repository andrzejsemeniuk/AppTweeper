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
            
            /*
            [
                "SETTINGS",
                
                { (cell:UITableViewCell, indexPath:IndexPath) in
                    if let label = cell.detailTextLabel {
                        label.text = AppDelegate.instance.preferences.style.value
                    }
                    if let label = cell.textLabel {
                        label.text          = "Save"
                        cell.selectionStyle = .default
                        self.registerCellSelection(indexPath: indexPath) {
                            let alert = UIAlertController(title:"Save Settings", message:"Specify name for current settings.", preferredStyle:.alert)
                            
                            alert.addTextField() {
                                field in
                                // called to configure text field before displayed
                                field.text = AppDelegate.instance.preferences.style.value
                            }
                            
                            let actionSave = UIAlertAction(title:"Save", style:.default, handler: {
                                action in
                                
                                if let fields = alert.textFields, let text = fields[0].text {
                                    if 0 < text.length {
                                        AppDelegate.instance.preferences.style.value = text
                                        
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
            */
            
            [
                "HISTORY",
                
                createCellForUISwitch(AppDelegate.instance.preferences.enableHistory, title: "Enabled"),
                
                createCellForTapOnQuestion(title: "Clear", message:"Remove all entries from search history?", ok:"Yes", cancel:"No") {
                    AppDelegate.instance.storeForSearch.removeAll()
                    AppDelegate.instance.preferences.lastSearchText.reset()
                },
                
                createCellForUITextFieldAsInt(AppDelegate.instance.preferences.maximumHistory, title:"Limit") {
                    if AppDelegate.instance.preferences.maximumHistory.value < 0 {
                        AppDelegate.instance.preferences.maximumHistory.value = 0
                    }
                    if AppDelegate.instance.preferences.maximumHistory.value > 99 {
                        AppDelegate.instance.preferences.maximumHistory.value = 99
                    }
                },
                
                "Properties related to search history"
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
                
                createCellForUISwitch               (AppDelegate.instance.preferences.testBool, title:"test Bool"),
                
                
                ""
            ],
            */
            
            [
                "HOME MENU",
                
                createCellForUITextFieldAsDouble(AppDelegate.instance.preferences.durationOfMainMenuDisplay, title:"Duration") {
                    if AppDelegate.instance.preferences.durationOfMainMenuDisplay.value <= 0.0 {
                       AppDelegate.instance.preferences.durationOfMainMenuDisplay.value = 0.1
                    }
                    else if AppDelegate.instance.preferences.durationOfMainMenuDisplay.value > 9.0 {
                            AppDelegate.instance.preferences.durationOfMainMenuDisplay.value = 9.0
                    }
                },

                createCellForUITextFieldAsDouble(AppDelegate.instance.preferences.durationOfMainMenuDisplayInitially, title:"Initial Duration") {
                    if AppDelegate.instance.preferences.durationOfMainMenuDisplayInitially.value <= 0.0 {
                        AppDelegate.instance.preferences.durationOfMainMenuDisplayInitially.value = 0.1
                    }
                    else if AppDelegate.instance.preferences.durationOfMainMenuDisplayInitially.value > 9.0 {
                        AppDelegate.instance.preferences.durationOfMainMenuDisplayInitially.value = 9.0
                    }
                },
                
                "Properties related to home screen menu"
            ],
            
            [
                "HOME SIGNAL",
                
                createCellForUISlider(AppDelegate.instance.preferences.signalAlpha, title:"Opacity"),
                
                createCellForUITextFieldAsInt(AppDelegate.instance.preferences.signalCount, title:"Count", message:"Enter an integer between 1 and 24", minimum:1, maximum:24),
                
                createCellForUITextFieldAsDouble(AppDelegate.instance.preferences.signalDuration, title:"Duration", message:"Enter a value between 1 and 60", minimum:1, maximum:60),
                
                createCellForUISlider(AppDelegate.instance.preferences.signalRadius, title:"Radius"),
                
                createCellForUISlider(AppDelegate.instance.preferences.signalThickness, title:"Thickness", minimum:1, maximum:240),
                
                createCellForUIColor(AppDelegate.instance.preferences.signalColor, title:"Rim Color"),
                
                createCellForUIColor(AppDelegate.instance.preferences.signalBackgroundColor, title:"Fill Color"),
                
                createCellForUISlider(AppDelegate.instance.preferences.signalBackgroundAlpha, title:"Fill Opacity"),
                
                
                "Properties related to home screen signal wave"
            ],
            
            [
                "HOME TITLE",
                
                // TODO: ADD MESSAGE TO UITEXTFIELD ALERT
                // TODO: ADD VALIDATOR CLOSURE INSIDE A GENERICSETTING?
                
                createCellForUIColor(AppDelegate.instance.preferences.titleShadowColor, title:"Shadow Color"),
                
                createCellForUISlider(AppDelegate.instance.preferences.titleShadowAlpha, title:"Shadow Opacity"),
                
                createCellForUISlider(AppDelegate.instance.preferences.titleShadowRadius, title:"Shadow Radius", maximum:50.0),
                
                createCellForUISlider(AppDelegate.instance.preferences.titleShadowOffset, title:"Shadow Offset", maximum:9.0),
                
                "Properties related to home screen title"
            ],
            /*
            [
                "SELECTION",
                
                createCellForUIColor(AppDelegate.instance.preferences.colorOfTitleText,title:"Selection") {
                },
                
                createCellForUISlider(AppDelegate.instance.preferences.testCGFloat, title:"Opacity"),
                
                "Set selection properties for rows on all tabs"
            ],
            */
            [
                "APP",
                
                createCellForUIColor(AppDelegate.instance.preferences.colorOfBackground, title:"Background"),

                createCellForUIColor(AppDelegate.instance.preferences.colorOfBackgroundOfActivityIndicator, title:"Activity"),

//                createCellForUISwitch(AppDelegate.instance.preferences.audio, title:"Sounds"),
                
                
                "Set app properties"
            ],
            
        ]
    }
    
    
    
    
    override func tableView                     (_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = super.tableView(tableView, cellForRowAt:indexPath)
        
        cell.selectedBackgroundView = UIView.createWithBackgroundColor(
            AppDelegate.instance.preferences.colorOfSelection.value.withAlphaComponent(0.6)
        )
        
        return cell
    }
    
    
    
    override func viewWillAppear                (_ animated: Bool)
    {
        tableView.backgroundColor   = AppDelegate.instance.preferences.colorOfBackground.value.multiply(byRatio:1.6).higher(byRatio: 0.6)
        
        colorForHeaderText          = AppDelegate.instance.preferences.colorOfHeaderText.value
        colorForFooterText          = AppDelegate.instance.preferences.colorOfFooterText.value
        
        super.viewWillAppear(animated)
    }
    
    
    
}


// TODO: ADD HIERARCHICAL ENTRIES THAT OPEN A NEW VIEW CONTROLLER
// TODO: ADD ENABLED STATUS OF A PREFERENCES
// TODO: ADD STYLE SAVE/RESTORE
// TODO: ADD FLAG TO MANAGER TO SYNCHRONIZE ON EVERY CHANGE
// TODO: EXTRACT INTERFACE TO GENERICSETTING, ADD IMPLEMENTATION FOR USER-DEFAULTS AND CORE-DATA
