//
//  AddUserViewController.swift
//  GLSubModule
//
//  Created by Kathy on 2021/8/18.
//

import UIKit

class GLTextField: UITextField {
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: .init(top: 0, left: 8, bottom: 0, right: 8))
    }
}

extension Selector{
    static let birthSEL: Selector = #selector(AddUserViewController.birthClick)
    static let sexSEL: Selector = #selector(AddUserViewController.sexClick)
    static let deptSEL: Selector = #selector(AddUserViewController.deptClick)
}

class AddUserViewController: UIViewController {

    typealias UserCompletion = ()->()
    
    var user:User?
    
    var completion: UserCompletion?
    
    
    var nameField:GLTextField!
    var birthDate:Date? {
        didSet {
            if let m = birthDate {
                let dateF = DateFormatter()
                dateF.dateFormat = "yyyy-MM-dd"
                self.birthControl.text = dateF.string(from: m)
            }else{
                self.birthControl.text = nil
            }
        }
    }
    var birthControl: GLBottomLineLabel!
    
    var sexIndex:Int16 = 0 {
        didSet {
            if sexIndex == 1 {
                self.sexControl.text = "男"
            }else if sexIndex == 2 {
                self.sexControl.text = "女"
            }else {
                self.sexControl.text = nil
            }
        }
    }
    var sexControl: GLBottomLineLabel!
    
    var dept:Dept? {
        didSet {
            if let m = dept {
                self.deptControl.text = m.name
            }else{
                self.deptControl.text = nil
            }
        }
    }
    var deptControl: GLBottomLineLabel!
    
    var phoneField:GLTextField!
    var addressField:GLTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        loadTopData()
        if let _ = user {
            navigationItem.title = "编辑"
            self.sexIndex = user?.sex ?? 0
            self.birthDate = user?.birthday
            self.nameField.text = user?.name
            self.phoneField.text = user?.phone
            self.addressField.text = user?.address
            self.dept = user?.dept
        }else{
            navigationItem.title = "添加"
        }
        self.edgesForExtendedLayout = [.top]
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(rightClick))
    }
    
    @objc func rightClick() {
        guard let name = nameField.text else { return }
        let m = name.trimmingCharacters(in: .whitespacesAndNewlines)
        if m.count == 0 {
            print("请填写姓名")
            return
        }
        if let user = user {
            user.name = nameField.text
            user.address = addressField.text
            user.phone = phoneField.text
            user.sex = self.sexIndex
            user.birthday = self.birthDate
            user.dept = self.dept
            GLCoreDataManager.shared.saveContext()
            if let m = completion {
                m()
            }
        }else{
            GLCoreDataManager.shared.addData(with: "User") { data in
                if let user = data as? User {
                    user.id = UUID()
                    user.name = nameField.text
                    user.address = addressField.text
                    user.phone = phoneField.text
                    user.sex = self.sexIndex
                    user.birthday = self.birthDate
                    user.dept = self.dept
                }
            }
            if let m = completion {
                m()
            }
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(100)) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func loadTopData() {
        loadNameData()
        loadBirthData()
        loadSexData()
        loadPhoneData()
        loadAddressData()
        loadDeptData()
    }
    
    func loadNameData() {
        let label = UILabel(frame: CGRect(x: 16, y: 96, width: 80, height: 32))
        label.text = "姓名"
        label.textColor = .black
        label.font = .systemFont(ofSize: 18, weight: .regular)
        view.addSubview(label)
        
        let textField = GLTextField(frame: CGRect(x: 100, y: 96, width: view.bounds.width - 116, height: 32))
        textField.placeholder = "请写入姓名"
        view.addSubview(textField)
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.cornerRadius = 4
        nameField = textField
    }

    func loadBirthData() {
        let label = UILabel(frame: CGRect(x: 16, y: 136, width: 80, height: 32))
        label.text = "生日"
        label.textColor = .black
        label.font = .systemFont(ofSize: 18, weight: .regular)
        view.addSubview(label)
        
        let textField = GLBottomLineLabel(frame: CGRect(x: 100, y: 136, width: view.bounds.width - 116, height: 32))
        textField.placeholder = "请选择生日日期"
        textField.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        view.addSubview(textField)
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.cornerRadius = 4
        textField.addTarget(self, action: .birthSEL, for: .touchUpInside)
        birthControl = textField
    }
    
    func loadSexData() {
        let label = UILabel(frame: CGRect(x: 16, y: 176, width: 80, height: 32))
        label.text = "性别"
        label.textColor = .black
        label.font = .systemFont(ofSize: 18, weight: .regular)
        view.addSubview(label)
        
        let textField = GLBottomLineLabel(frame: CGRect(x: 100, y: 176, width: view.bounds.width - 116, height: 32))
        textField.placeholder = "请选择性别"
        textField.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        view.addSubview(textField)
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.cornerRadius = 4
        textField.addTarget(self, action: .sexSEL, for: .touchUpInside)
        sexControl = textField
    }
    
    func loadPhoneData() {
        let label = UILabel(frame: CGRect(x: 16, y: 216, width: 80, height: 32))
        label.text = "电话"
        label.textColor = .black
        label.font = .systemFont(ofSize: 18, weight: .regular)
        view.addSubview(label)
        
        let textField = GLTextField(frame: CGRect(x: 100, y: 216, width: view.bounds.width - 116, height: 32))
        textField.placeholder = "请写入电话号码"
        view.addSubview(textField)
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.cornerRadius = 4
        phoneField = textField
    }
    
    func loadAddressData() {
        let label = UILabel(frame: CGRect(x: 16, y: 256, width: 80, height: 32))
        label.text = "地址"
        label.textColor = .black
        label.font = .systemFont(ofSize: 18, weight: .regular)
        view.addSubview(label)
        
        let textField = GLTextField(frame: CGRect(x: 100, y: 256, width: view.bounds.width - 116, height: 32))
        textField.placeholder = "请写入详细地址"
        view.addSubview(textField)
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.cornerRadius = 4
        addressField = textField
    }
    
    func loadDeptData() {
        let label = UILabel(frame: CGRect(x: 16, y: 296, width: 80, height: 32))
        label.text = "部门"
        label.textColor = .black
        label.font = .systemFont(ofSize: 18, weight: .regular)
        view.addSubview(label)
        
        let textField = GLBottomLineLabel(frame: CGRect(x: 100, y: 296, width: view.bounds.width - 116, height: 32))
        textField.placeholder = "请选择部门"
        textField.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        view.addSubview(textField)
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.cornerRadius = 4
        textField.addTarget(self, action: .deptSEL, for: .touchUpInside)
        deptControl = textField
    }
    
    @objc func birthClick() {
        self.view.endEditing(true)
        let p = GLKeyPickerBottomView(type: GLKeyPickerBottomViewShowDate) as GLKeyPickerBottomView
        p.frame = self.view.bounds
        p.delegate = self
        p.pickerData = [GLKeyPickerBottomViewDateKey:NSData()]
        self.view.addSubview(p)
        p.show(withAnimation: true)
    }
    
    @objc func sexClick() {
        self.view.endEditing(true)
        let p = GLKeyPickerBottomView(type: GLKeyPickerBottomViewShowOther) as GLKeyPickerBottomView
        p.frame = self.view.bounds
        p.pickerData = [GLKeyPickerBottomViewListKey:[1]]
        p.dataSource = self
        p.delegate = self
        self.view.addSubview(p)
        p.show(withAnimation: true)
    }
    
    @objc func deptClick() {
        let vc = DeptListViewController()
        vc.dept = self.dept
        vc.completion = { dept in
            self.dept = dept
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


extension AddUserViewController: GLKeyPickerBottomViewDataSource, GLKeyPickerBottomViewDelegate {
    func pickerBottomView(_ bottomView: GLKeyPickerBottomView!, withUserInfo userInfo: Any!) {
        guard let data = userInfo as? Dictionary<String,Any> else { return }
        
        if let date = data[GLKeyPickerBottomViewDateKey] as? Date {
            self.birthDate = date
        }
        if let array = data[GLKeyPickerBottomViewListKey] as? [Int] {
            self.sexIndex = Int16(array.first ?? 0)
        }
    }
    
    func pickerView(_ pickerView: GLKeyPickerBottomView!, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func pickerView(_ pickerView: GLKeyPickerBottomView!, titleForRowAt indexPath: IndexPath!) -> String! {
        ["未知","男","女"][indexPath.row]
    }
}
