//
//  UITableView+Extensions.swift
//  BatTransferList
//
//  Created by Siamak Rostami on 5/12/23.
//

import Foundation
import UIKit

extension UITableView {
    func setEmptyState(message: String? = nil, image: String, font: UIFont?, alignment: NSTextAlignment?, color: UIColor? = nil) {
        // main view
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        view.backgroundColor = .clear
        // image view
        let image = UIImage(named: image)?.withRenderingMode(.alwaysOriginal)
        let imageView = UIImageView(image: image)
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        // label view
        let messageLabel = UILabel()
        messageLabel.text = message ?? "Transfer List Is Empty"
        messageLabel.textColor = color ?? .systemGray
        messageLabel.textAlignment = alignment ?? .center
        messageLabel.font = font
        messageLabel.sizeToFit()
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        view.addSubview(imageView)
        view.addSubview(messageLabel)
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: -24))
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 0.3, constant: 0))
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 0.3, constant: 0))
        addConstraint(NSLayoutConstraint(item: messageLabel, attribute: .centerX, relatedBy: .equal, toItem: imageView, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: messageLabel, attribute: .top, relatedBy: .equal, toItem: imageView, attribute: .bottom, multiplier: 1, constant: 16))
        self.backgroundView = view
        self.separatorStyle = .none
    }

    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .none
    }
}
