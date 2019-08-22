//
//  ContentCell.swift
//  HalfModalyFortee
//
//  Created by murakami Taichi on 2019/08/05.
//  Copyright © 2019 murakammm. All rights reserved.
//

import Foundation
import UIKit
import Nuke

class ContentCell: UITableViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var speakerIconImageView: UIImageView!
    @IBOutlet private weak var speakerNameLabel: UILabel!
    @IBOutlet private weak var nonSpeakerConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        speakerIconImageView.layer.cornerRadius =  16.0
        speakerIconImageView.clipsToBounds = true
    }
    
    func set(content: Content) {
        
        titleLabel.text = content.title
        if let speaker = content.speaker {
            if let url = speaker.avatarUrl {
                speakerIconImageView.isHidden = false
                Nuke.loadImage(with: url, into: speakerIconImageView)
            }
            speakerNameLabel.isHidden = false
            speakerNameLabel.text = speaker.name
            nonSpeakerConstraint.priority = .defaultLow
        } else {
            speakerNameLabel.isHidden = true
            speakerIconImageView.isHidden = true
            nonSpeakerConstraint.priority = .init(999)
        }
    }
}
