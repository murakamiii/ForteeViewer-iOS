//
//  ContentViewController.swift
//  HalfModalyFortee
//
//  Created by murakami Taichi on 2019/08/20.
//  Copyright © 2019 murakammm. All rights reserved.
//

import Foundation
import UIKit
import FloatingPanel

class ContentDetailViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    @IBOutlet private weak var trackLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    private var content: Content!
    
    func setContent(content: Content) {
        self.content = content
    }

    func setupUI() {
        trackLabel.text = content.track.name
        titleLabel.text = content.title
        descriptionLabel.text = content.abstract
    }
}

extension UIViewController {
    static func loadFromNib() -> Self {
        func instantiateFromNib<T: UIViewController>() -> T {
            return T.init(nibName: String(describing: T.self), bundle: nil)
        }
        
        return instantiateFromNib()
    }
}
