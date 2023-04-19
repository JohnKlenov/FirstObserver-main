//
//  MallsViewCell.swift
//  FirstObserver
//
//  Created by Evgenyi on 8.02.23.
//

import UIKit
import FirebaseStorage
import FirebaseStorageUI

class MallsViewCell: UICollectionViewCell {
    
    static var reuseID: String = "MallsViewCell"
    var storage: Storage!
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    let nameMall: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = R.Colors.labelWhite
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        addSubview(nameMall)
        setupConstraints()
        storage = Storage.storage()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        imageView.sd_cancelCurrentImageLoad()
//        imageView.image = nil
        if let layers = imageView.layer.sublayers {
            for layerGradient in layers {
                layerGradient.removeFromSuperlayer()
            }
        }
    }
    
    func configureCell(model:ItemCell, currentFrame: CGSize) {
        
        if let firstRef = model.malls?.refImage {
            let urlRef = storage.reference(forURL: firstRef)
            self.imageView.sd_setImage(with: urlRef, placeholderImage: UIImage(named: "DefaultImage"))
        } else {
            imageView.image = UIImage(named: "DefaultImage")
        }
        nameMall.text = model.malls?.brand
//        imageView.image = UIImage(named: model.malls?.refImage ?? "")
        addGradientOverlay(correntFrame: currentFrame)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([imageView.topAnchor.constraint(equalTo: topAnchor),
                                     imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
                                     imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
                                     imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
                                    
                                     nameMall.topAnchor.constraint(equalTo: topAnchor, constant: 20),
                                     nameMall.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)
                                    ])
    }
    
    private func addGradientOverlay(correntFrame: CGSize) {
        let gradientLayer = CAGradientLayer()

        gradientLayer.frame.size = correntFrame
        let overlayColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        gradientLayer.colors = [overlayColor.cgColor, overlayColor.cgColor]
        self.imageView.layer.addSublayer(gradientLayer)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
