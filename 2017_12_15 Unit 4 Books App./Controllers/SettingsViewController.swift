//
//  SettingsViewController.swift
//  2017_12_15 Unit 4 Books App.
//
//  Created by C4Q on 12/15/17.
//  Copyright © 2017 Quark. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {
    @IBOutlet weak var settingsCategoryPicker: UIPickerView!
    var categories = [Category](){
        didSet{
            settingsCategoryPicker.setNeedsLayout()
            let categoryFromDefauls = DefaultCategory.returnValue(inputDefaults: defaults, and: DefaultSettingKeys.userOne.rawValue)
            if let safeCategoryFromDefaults = categoryFromDefauls{
                settingsCategoryPicker.selectRow(safeCategoryFromDefaults.categoryIndex, inComponent: 0, animated: true)
            }
        }
    }
    @IBAction func checkForUpdatesButton(_ sender: UIButton) {
        
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row].listName
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    func loadCategories(){
        CategoryAPIClient.manager.getCategories(for: "", completionHandler: {self.categories = $0}, errorHandler: {print($0)})
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let defaultSetting = DefaultCategory(categoryName: categories[row].listNameEncoded, categoryIndex: row, categoryList: categories)
        DefaultCategory.setCategoryDefault(inputDefault: defaultSetting)
    }
    func setCategoryFromDefaultsForPicker(input picker: UIPickerView){
        //the functions checks the user default and set the picker view dafault to the value of saved defaults
        guard !DefaultCategory.isEmpty(forDefaultSettingKeys: DefaultSettingKeys.userOne.rawValue) else {
            return
        }
        let savedDefaults = DefaultCategory.returnValue(inputDefaults: defaults, and: DefaultSettingKeys.userOne.rawValue)
        if let safeDefault = savedDefaults{
            picker.selectRow(safeDefault.categoryIndex, inComponent: 0, animated: false)
            print(safeDefault.categoryName)
        }else{
            print("error with decoding user defaults")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.settingsCategoryPicker.delegate = self
        self.settingsCategoryPicker.dataSource = self
        loadCategories()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
