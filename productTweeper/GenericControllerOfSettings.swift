//
//  GenericControllerOfSettings.swift
//  productGroceries
//
//  Created by Andrzej Semeniuk on 3/25/16.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import UIKit
import ASToolkit

protocol GenericManagerOfSettings : class {
    func synchronize()
}

class GenericControllerOfSettings : UITableViewController
{
    struct Row {
        let cell                    : ((UITableViewCell, IndexPath)->Void)
    }
    
    struct Group {
        let title                   : String
        let footer                  : String
        let rows                    : [Row]
    }
    
    var rows                        : [[Any]] = []
    
    static var lastOffsetY          : [String:CGPoint] = [:]
    
    weak var manager                : GenericManagerOfSettings?
    
    
    override func numberOfSections              (in: UITableView) -> Int
    {
        return rows.count
    }
    
    override func tableView                     (_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return section < rows.count ? rows[section].count-2 : 0
    }
    
    override func tableView                     (_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        if 0 < rows.count {
            if let text = rows[section].first as? String {
                return 0 < text.length ? text : nil
            }
        }
        return nil
    }
    
    override func tableView                     (_ tableView: UITableView, titleForFooterInSection section: Int) -> String?
    {
        if 0 < rows.count {
            if let text = rows[section].last as? String {
                return 0 < text.length ? text : nil
            }
        }
        return nil
    }
    
    override func tableView                     (_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int
    {
        if 0 < indexPath.row {
            //            return 1
        }
        return 0
    }
    
    override func tableView                     (_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell(style:.value1,reuseIdentifier:nil)
        
        cell.selectionStyle = .none
        
        if let HSBA = cell.backgroundColor?.HSBA {
            if 1 <= HSBA.alpha {
                cell.backgroundColor = cell.backgroundColor!.withAlphaComponent(0.50)
            }
        }
        else {
            cell.backgroundColor = UIColor(white:1,alpha:0.7)
        }
        
        if 0 < rows.count {
            if let f = rows[indexPath.section][indexPath.row+1] as? FunctionOnCell {
                f(cell,indexPath)
            }
        }
        
        return cell
    }
    
    
    
    
    var colorForHeaderText:UIColor?
    var colorForFooterText:UIColor?
    
    
    
    override func tableView                     (_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        if let view = view as? UITableViewHeaderFooterView {
            if let color = colorForHeaderText {
                view.textLabel?.textColor = color
            }
        }
        
    }
    

    override func tableView                     (_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        
        if let view = view as? UITableViewHeaderFooterView {
            if let color = colorForFooterText {
                view.textLabel?.textColor = color
            }
        }
        
    }
    

    
    
    
    typealias Action = () -> ()
    
    var actions:[IndexPath : Action] = [:]
    
    func addAction(indexPath:IndexPath, action:@escaping Action) {
        actions[indexPath] = action
    }
    
    func registerCellSelection(indexPath:IndexPath, action:@escaping Action) {
        addAction(indexPath: indexPath,action:action)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if let action = actions[indexPath]
        {
            action()
        }
    }
    
    
    
    
    
    
    typealias Update = Action
    
    var updates:[Update] = []
    
    func addUpdate(update:@escaping Update) {
        updates.append(update)
    }
    
    
    
    
    
    
    
    typealias FunctionUpdateOnUISwitch = (UISwitch) -> ()
    
    var registeredUISwitches:[UISwitch:FunctionUpdateOnUISwitch] = [:]
    
    func registerUISwitch(on:Bool, animated:Bool = true, update:@escaping FunctionUpdateOnUISwitch) -> UISwitch {
        let view = UISwitch()
        view.setOn(on, animated:animated)
        registeredUISwitches[view] = update
        view.addTarget(self,action:#selector(GenericControllerOfSettings.handleUISwitch(control:)),for:.valueChanged)
        return view
    }
    
    func handleUISwitch(control:UISwitch?) {
        if let myswitch = control, let update = registeredUISwitches[myswitch] {
            update(myswitch)
        }
    }
    
    func createCellForBool(_ setting:GenericSetting<Bool>, title:String, setup:((UITableViewCell,IndexPath)->())? = nil, action:((Bool)->())? = nil ) -> FunctionOnCell {
        
        return { (cell:UITableViewCell, indexPath:IndexPath) in
            if let label = cell.textLabel {
                cell.selectionStyle = .default
                label.text          = title
                setup?(cell,indexPath)
                cell.accessoryView  = self.registerUISwitch(on: setting.value, update: { (myswitch:UISwitch) in
                    setting.query = myswitch.isOn
                    action?(setting.value)
                })
            }
        }
        
    }
    
    
    
    
    typealias FunctionUpdateOnUISlider = (UISlider) -> ()
    
    var registeredUISliders:[UISlider:FunctionUpdateOnUISlider] = [:]
    
    func registerUISlider(value:Float, minimum:Float = 0, maximum:Float = 1, continuous:Bool = false, animated:Bool = true, update:@escaping FunctionUpdateOnUISlider) -> UISlider {
        let view = UISlider()
        view.minimumValue   = minimum
        view.maximumValue   = maximum
        view.isContinuous   = continuous
        view.value          = value
        registeredUISliders[view] = update
        view.addTarget(self,action:#selector(GenericControllerOfSettings.handleUISlider(control:)),for:.valueChanged)
        return view
    }
    
    func handleUISlider(control:UISlider?) {
        if let myslider = control, let update = registeredUISliders[myslider] {
            update(myslider)
        }
    }
    
    func createCellForUISlider(_ setting:GenericSetting<Float>, title:String, setup:((UITableViewCell,IndexPath,UISlider)->())? = nil, action:((Float)->())? = nil ) -> FunctionOnCell {
        return { (cell:UITableViewCell, indexPath:IndexPath) in
            if let label = cell.textLabel {
                label.text          = title
                cell.accessoryType  = .none
                cell.selectionStyle = .default
                let view = self.registerUISlider(value: setting.value, update: { (myslider:UISlider) in
                    setting.query = myslider.value
                    action?(setting.value)
                })
                cell.accessoryView  = view
                setup?(cell,indexPath,view)
            }
        }
    }

    func createCellForUISlider(_ setting:GenericSetting<CGFloat>, title:String, setup:((UITableViewCell,IndexPath,UISlider)->())? = nil, action:((CGFloat)->())? = nil ) -> FunctionOnCell {
        return { (cell:UITableViewCell, indexPath:IndexPath) in
            if let label = cell.textLabel {
                label.text          = title
                cell.accessoryType  = .none
                cell.selectionStyle = .default
                let view = self.registerUISlider(value: Float(setting.value), update: { (myslider:UISlider) in
                    setting.query = CGFloat(myslider.value)
                    action?(setting.value)
                })
                cell.accessoryView  = view
                setup?(cell,indexPath,view)
            }
        }
    }

    
    
    
    
    
    typealias FunctionUpdateOnUITextField = (UITextField) -> ()
    
    var registeredUITextFields:[UITextField:FunctionUpdateOnUITextField] = [:]
    
    func registerUITextField(count:Int, value:String, animated:Bool = true, update:@escaping FunctionUpdateOnUITextField) -> UITextField {
        let view = UITextField()
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 1
        view.text = value
        view.textAlignment = .right
        view.frame.size.width = (String.init(repeating:"m", count:count) as NSString).size(attributes: [
            NSFontAttributeName : view.font ?? UIFont.defaultFont
            ]).width + 2
        registeredUITextFields[view] = update
//        view.addTarget(self,action:#selector(GenericControllerOfSettings.handleUITextField(control:)),for:[.allTouchEvents, .valueChanged])
        return view
    }
    
    func handleUITextField(control:UITextField?) {
        if let control = control, let update = registeredUITextFields[control] {
            update(control)
        }
    }
    
    func createAlertForUITextField(_ field:UITextField, title:String, message:String, setter:@escaping (String)->Bool) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField { textfield in
            textfield.text = field.text
        }
        let ok = UIAlertAction.init(title: "Ok", style: UIAlertActionStyle.default) { action in
            if let text = alert.textFields?[safe:0]?.text, setter(text) {
                field.text = text
            }
            alert.dismiss(animated: true) {
            }
        }
        alert.addAction(ok)
        let cancel = UIAlertAction.init(title: "Cancel", style: UIAlertActionStyle.cancel) { action in
            alert.dismiss(animated: true) {
            }
        }
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
    
    func createCellForUITextFieldAsString(_ setting:GenericSetting<String>, count:Int = 8, title:String, setup:((UITableViewCell,IndexPath,UITextField)->())? = nil, action:((String)->())? = nil ) -> FunctionOnCell {
        return { (cell:UITableViewCell, indexPath:IndexPath) in
            if let label = cell.textLabel {
                cell.selectionStyle = .default
                label.text          = title
                let field = self.registerUITextField(count:count, value: setting.value, update: { (field:UITextField) in
                    setting.query = field.text ?? ""
                    action?(setting.value)
                })
                cell.accessoryView = field
                setup?(cell,indexPath,field)
                
                self.addAction(indexPath: indexPath) {
                    self.createAlertForUITextField(field, title:title, message:"Enter text") { text in
                        setting.query = text
                        return true
                    }
                }
                
            }
        }
    }

    func createCellForUITextFieldAsDouble(_ setting:GenericSetting<Double>, count:Int = 8, title:String, setup:((UITableViewCell,IndexPath,UITextField)->())? = nil, action:((Double)->())? = nil ) -> FunctionOnCell {
        return { (cell:UITableViewCell, indexPath:IndexPath) in
            if let label = cell.textLabel {
                cell.selectionStyle = .default
                label.text          = title
                let field = self.registerUITextField(count:count, value: String(setting.value), update: { (field:UITextField) in
                    setting.query = Double(field.text ?? "0") ?? 0
                    action?(setting.value)
                })
                cell.accessoryView = field
                setup?(cell,indexPath,field)
                
                self.addAction(indexPath: indexPath) {
                    self.createAlertForUITextField(field, title:title, message:"Enter a number") { text in
                        if let number = Double(text) {
                            setting.query = number
                            return true
                        }
                        return false
                    }
                }

            }
        }
    }
    
    func createCellForUITextFieldAsCGFloat(_ setting:GenericSetting<CGFloat>, count:Int = 8, title:String, setup:((UITableViewCell,IndexPath,UITextField)->())? = nil, action:((CGFloat)->())? = nil ) -> FunctionOnCell {
        return { (cell:UITableViewCell, indexPath:IndexPath) in
            if let label = cell.textLabel {
                cell.selectionStyle = .default
                label.text          = title
                let field = self.registerUITextField(count:count, value: String(describing: setting.value), update: { (field:UITextField) in
                    setting.query = CGFloat(field.text ?? "0") ?? 0
                    action?(setting.value)
                })
                cell.accessoryView = field
                setup?(cell,indexPath,field)
                
                self.addAction(indexPath: indexPath) {
                    self.createAlertForUITextField(field, title:title, message:"Enter a number") { text in
                        if let number = CGFloat(text) {
                            setting.query = number
                            return true
                        }
                        return false
                    }
                }
                
            }
        }
    }
    
    func createCellForUITextFieldAsFloat(_ setting:GenericSetting<Float>, count:Int = 8, title:String, setup:((UITableViewCell,IndexPath,UITextField)->())? = nil, action:((Float)->())? = nil ) -> FunctionOnCell {
        return { (cell:UITableViewCell, indexPath:IndexPath) in
            if let label = cell.textLabel {
                cell.selectionStyle = .default
                label.text          = title
                let field = self.registerUITextField(count:count, value: String(describing: setting.value), update: { (field:UITextField) in
                    setting.query = Float(field.text ?? "0") ?? 0
                    action?(setting.value)
                })
                cell.accessoryView = field
                setup?(cell,indexPath,field)
                
                self.addAction(indexPath: indexPath) {
                    self.createAlertForUITextField(field, title:title, message:"Enter a number") { text in
                        if let number = Float(text) {
                            setting.query = number
                            return true
                        }
                        return false
                    }
                }
                
            }
        }
    }
    
    func createCellForUITextFieldAsInt(_ setting:GenericSetting<Int>, count:Int = 8, title:String, setup:((UITableViewCell,IndexPath,UITextField)->())? = nil, action:((Int)->())? = nil ) -> FunctionOnCell {
        return { (cell:UITableViewCell, indexPath:IndexPath) in
            if let label = cell.textLabel {
                cell.selectionStyle = .default
                label.text          = title
                let field = self.registerUITextField(count:count, value: String(describing: setting.value), update: { (field:UITextField) in
                    setting.query = Int(field.text ?? "0") ?? 0
                    action?(setting.value)
                })
                cell.accessoryView = field
                setup?(cell,indexPath,field)
                
                self.addAction(indexPath: indexPath) {
                    self.createAlertForUITextField(field, title:title, message:"Enter an integer") { text in
                        if let number = Int(text) {
                            setting.query = number
                            return true
                        }
                        return false
                    }
                }
                
            }
        }
    }
    







    typealias FunctionOnCell = (_ cell:UITableViewCell, _ indexPath:IndexPath) -> ()
    
    
    
    
    
    func createCellForUIFontName(_ font0:String, name:String = "Font", title:String, setup:((UITableViewCell,IndexPath)->())? = nil, action:((String)->())? = nil) -> FunctionOnCell
    {
        return
            { (cell:UITableViewCell, indexPath:IndexPath) in
                if let label = cell.textLabel {
                    
                    label.text          = name
                    if let detail = cell.detailTextLabel {
                        detail.text = font0
                    }
                    cell.selectionStyle = .default
                    cell.accessoryType  = .disclosureIndicator
                    
                    setup?(cell,indexPath)
                    
                    self.addAction(indexPath: indexPath) {
                        
                        let fonts       = GenericControllerOfPickerOfFont()
                        fonts.title     = title+" Font"
                        fonts.selected  = font0
                        fonts.update    = {
                            action?(fonts.selected)
                        }
                        
                        self.navigationController?.pushViewController(fonts, animated:true)
                    }
                }
        }
    }

    func createCellForUIFontName(_ font0:GenericSetting<String>, name:String = "Font", title:String, setup:((UITableViewCell,IndexPath)->())? = nil, action:(()->())? = nil) -> FunctionOnCell {
        return createCellForUIFontName(font0.value, name:name, title:title, setup:setup, action: { name in
            font0.query = name
            action?()
        })
    }

    func createCellForUIFont(_ font0:GenericSetting<UIFont>, name:String = "Font", title:String, setup:((UITableViewCell,IndexPath)->())? = nil, action:(()->())? = nil) -> FunctionOnCell {
        return createCellForUIFontName(font0.value.fontName, name:name, title:title, setup:setup, action: { name in
            font0.query = UIFont(name:name, size:font0.value.pointSize)
            action?()
        })
    }
    
    
    
    
    
    
    
    
    func createCellForUIColor(_ color0:UIColor, name:String = "Color", title:String, setup:((UITableViewCell,IndexPath)->())? = nil, action:((UIColor)->())? = nil) -> FunctionOnCell
    {
        return
            { (cell:UITableViewCell, indexPath:IndexPath) in
                if let label = cell.textLabel {
                    
                    label.text          = name
                    if let detail = cell.detailTextLabel {
                        detail.text     = "  "
                        
                        let view = UIView()
                        
                        view.frame              = CGRect(x:-16,y:-2,width:24,height:24)
                        view.backgroundColor    = color0
                        
                        detail.addSubview(view)
                    }
                    cell.selectionStyle = .default
                    cell.accessoryType  = .disclosureIndicator
                    
                    setup?(cell,indexPath)
                    
                    self.addAction(indexPath: indexPath) {
                        
                        let colors      = GenericControllerOfPickerOfColor()
                        colors.title    = title + " Color"
                        colors.selected = color0
                        colors.update   = {
                            action?(colors.selected)
                        }
                        
                        self.navigationController?.pushViewController(colors, animated:true)
                    }
                }
        }
    }
    
    func createCellForUIColor(_ setting:GenericSetting<UIColor>, name:String = "Color", title:String, setup:((UITableViewCell,IndexPath)->())? = nil, action:(()->())? = nil) -> FunctionOnCell {
        return createCellForUIColor(setting.value, name:name, title:title, setup:setup, action:{ color in
            setting.query = color
            action?()
        })
    }

    
    
    
    
    
    
    func reload()
    {
        tableView.reloadData()
    }
    
    
    func createRows() -> [[Any]]
    {
        return [[Any]]()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        registeredUISliders.removeAll()
        registeredUISwitches.removeAll()
        
        updates.removeAll()
        
        actions.removeAll()
        
        rows = createRows()
        
        reload()
        
        if let title = super.title {
            if let point = GenericControllerOfSettings.lastOffsetY[title] {
                tableView.setContentOffset(point,animated:true)
            }
        }
        
        super.viewWillAppear(animated)
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool)
    {
        if let title = super.title {
            GenericControllerOfSettings.lastOffsetY[title] = tableView.contentOffset
        }
        
        registeredUISliders.removeAll()
        registeredUISwitches.removeAll()
        
        for update in updates {
            update()
        }
        
        updates.removeAll()
        
        rows.removeAll()
        
        actions.removeAll()
        
        manager?.synchronize()
        
        super.viewWillDisappear(animated)
    }
    
    
    
    
    
    
    
}






