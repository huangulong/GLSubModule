//
//  GLBottomLineLabel.swift
//  GLLibSwift
//
//  Created by admin on 2021/1/7.
//  Copyright © 2021 历山大亚. All rights reserved.
//

import UIKit


extension UIView{
    func gl_addConstraint(_ insets: UIEdgeInsets) {
        assert(superview != nil, "addConstraint 添加约束时无父视图")
        translatesAutoresizingMaskIntoConstraints = false
        if let m = self.superview {//其实没有父视图的是已经奔溃了，所以superView一定有值
            topAnchor.constraint(equalTo: m.topAnchor, constant: insets.top).isActive = true
            leftAnchor.constraint(equalTo: m.leftAnchor, constant: insets.left).isActive = true
            bottomAnchor.constraint(equalTo: m.bottomAnchor, constant: -insets.bottom).isActive = true
            rightAnchor.constraint(equalTo: m.rightAnchor, constant: -insets.right).isActive = true
        }
    }
}

class GLBottomLineLabel: UIControl {

    var contentInset:UIEdgeInsets{
        didSet{
            self.contentView.gl_addConstraint(self.contentInset)
        }
    }
    
    
    private lazy var contentView: UIView = {
        let v = UIView()
        v.isUserInteractionEnabled = false
        self.addSubview(v)
        return v
    }()
    
    lazy var label: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 14)
        self.contentView.addSubview(l)
        return l
    }()
    
    override init(frame: CGRect) {
        self.contentInset = UIEdgeInsets.zero
        super.init(frame: frame)
        self.isUserInteractionEnabled = false
        self.label.gl_addConstraint(UIEdgeInsets.zero)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
        self.isUserInteractionEnabled = true
        super.addTarget(target, action: action, for: controlEvents)
    }
    
    var hasText:Bool = false
    var placeholder:String?{
        didSet{
            guard hasText else {
                self.label.text = self.placeholder
                self.label.textColor = self.placeholderColor
                return
            }
        }
    }
    var placeholderColor:UIColor? = #colorLiteral(red: 0.4588235294, green: 0.4588235294, blue: 0.4588235294, alpha: 1){
        didSet {
            guard hasText else {
                self.label.textColor = self.placeholderColor
                return
            }
        }
    }
    var textColor:UIColor? = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
    var text: String? {
        get {
            return self.label.text
        }
        set {
            if newValue?.isEmpty ?? true {
                hasText = false
                self.label.text = self.placeholder
                self.label.textColor = self.placeholderColor
            }else{
                hasText = true
                self.label.text = newValue
                self.label.textColor = self.textColor
            }
        }
    }
}
