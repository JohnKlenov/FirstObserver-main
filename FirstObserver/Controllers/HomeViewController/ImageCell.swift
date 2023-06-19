//
//  ImageCell.swift
//  FirstObserver
//
//  Created by Evgenyi on 8.02.23.
//

import UIKit
import FirebaseStorage
import FirebaseStorageUI

class ImageCell: UICollectionViewCell {
    
    static var reuseID: String = "ImageCell"
    var storage: Storage!
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.tintColor = R.Colors.label
        return image
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = R.Colors.secondarySystemBackground
        addSubview(imageView)
        setupConstraints()
        storage = Storage.storage()
        layer.cornerRadius = 10
        clipsToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.sd_cancelCurrentImageLoad()
        //        imageView.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    func setupConstraints() {
        // only image
        NSLayoutConstraint.activate([imageView.topAnchor.constraint(equalTo: topAnchor, constant: 4), imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4), imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4), imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4)])
    }
    
    func configureCell(model: ItemCell) {
        
        if let urlString = model.brands?.refImage {
            let urlRef = storage.reference(forURL: urlString)
            let placeholderImage = UIImage(named: "DefaultImage")
            
            imageView.sd_setImage(with: urlRef, placeholderImage: placeholderImage) { (image, error, cacheType, url) in
                guard let image = image else {
                    // Обработка ошибок
                    return
                }
                
                // Настройка цвета изображения в зависимости от текущей темы
                if #available(iOS 13.0, *) {
                    let tintableImage = image.withRenderingMode(.alwaysTemplate)
                    self.imageView.image = tintableImage
                } else {
                    self.imageView.image = image
                }
            }
            
        }else {
            imageView.image = UIImage(named: "DefaultImage")
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}





//let options = SDWebImageOptions()
//options.placeholderImage = placeholderImage
//options.completedBlock = { (image, error, cacheType, url) in
//    guard let image = image else {
//        // Обработка ошибок
//        return
//    }
//
//    // Настройка цвета изображения в зависимости от текущей темы
//    if #available(iOS 13, *) {
//        // Создание изображения с цветом UIColor.label
//        let labelColorImage = image.withTintColor(.label)
//        self.imageView.image = labelColorImage
//    } else {
//        // В iOS до версии 13 просто отображаем исходное изображение
//        self.imageView.image = image
//    }
//}
//
//imageView.sd_setImage(with: urlRef, placeholderImage: placeholderImage, options: options)



// png in original no active color
//                if let firstRef = model.brands?.refImage {
//                    let urlRef = storage.reference(forURL: firstRef)
//
//                    self.imageView.sd_setImage(with: urlRef, placeholderImage: UIImage(named: "DefaultImage"))
//                } else {
//                    imageView.image = UIImage(named: "DefaultImage")
//                }
//        labelName.text = model.brands?.brand

//class MyViewController: UIViewController {
//
//    var imageView: UIImageView!
//    var storageRef = Storage.storage().reference()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
//        imageView.contentMode = .scaleAspectFit
//        view.addSubview(imageView)
//        imageView.center = view.center
//
//        let imageRef = storageRef.child("images/exampleImage.png")
//        let placeholderImage = UIImage(named: "DefaultImage")
//
//        let options = SDWebImageOptions()
//        options.placeholderImage = placeholderImage
//        options.transition = .fade
//        options.completedBlock = { (image, error, cacheType, url) in
//            guard let image = image else {
//                // Обработка ошибок
//                return
//            }
//            // Настройка цвета изображения в зависимости от текущей темы
//            if #available(iOS 13, *) {
//                // Создание изображения с цветом UIColor.label
//                let labelColorImage = image.withTintColor(.label)
//                self.imageView.image = labelColorImage
//            } else {
//                // В iOS до версии 13 просто отображаем исходное изображение
//                self.imageView.image = image
//            }
//        }
//
//        imageView.sd_setImage(with: imageRef, placeholderImage: placeholderImage, options: options)
//    }
//}
//class MyViewController: UIViewController {
//
//    var imageView: UIImageView!
//    var storageRef = Storage.storage().reference()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
//        imageView.contentMode = .scaleAspectFit
//        view.addSubview(imageView)
//        imageView.center = view.center
//
//        let imageRef = storageRef.child("images/exampleImage.png")
//        let placeholderImage = UIImage(named: "DefaultImage")
//
//        let options = ImageLoaderOptions(placeholder: placeholderImage, transition: .fade(0.2))
//
//        imageView.sd_setImage(with: imageRef, placeholderImage: placeholderImage, options: options) { (image, error, cacheType, url) in
//            guard let image = image else {
//                // Обработка ошибок
//                return
//            }
//            // Настройка цвета изображения в зависимости от текущей темы
//            if #available(iOS 13.0, *) {
//                // Создание изображения с цветом UIColor.label
//                let labelColorImage = image.withTintColor(.label)
//                self.imageView.image = labelColorImage
//            } else {
//                // В iOS до версии 13 просто отображаем исходное изображение
//                self.imageView.image = image
//            }
//        }
//    }
//}



// label + image
//    let labelName: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.textAlignment = .center
//        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
//        label.textColor = .black
//        label.textColor = R.Colors.secondaryLabel
////        label.backgroundColor = .blue
//        label.backgroundColor = .clear
//        return label
//    }()
    // only label
//    let labelName: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.textAlignment = .center
//        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
//        label.numberOfLines = 1
//        label.textColor = R.Colors.label
//        label.backgroundColor = R.Colors.secondarySystemBackground
//        label.layer.cornerRadius = 10
//        label.clipsToBounds = true
//        return label
//    }()



// label + image
//            let topImageViewCnstr = imageView.topAnchor.constraint(equalTo: topAnchor, constant: 0)
//            topImageViewCnstr.priority = UILayoutPriority(999)
//            topImageViewCnstr.isActive = true
//
//            let trailingImageViewCnstr = imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0)
//            trailingImageViewCnstr.isActive = true
//
//            let leadingImageViewCnstr = imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0)
//            leadingImageViewCnstr.isActive = true
//
//        let heightImageViewCnstr = imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 0.8)
//            heightImageViewCnstr.isActive = true
//
//            let topStackCnstr = labelName.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 0)
//            topStackCnstr.isActive = true
//
//            let trailingStackCnstr = labelName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0)
//            trailingStackCnstr.isActive = true
//
//            let leadingStackCnstr = labelName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0)
//            leadingStackCnstr.isActive = true
//
//            let bottomStackCnstr = labelName.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
//            bottomStackCnstr.priority = UILayoutPriority(999)
//            bottomStackCnstr.isActive = true
//
// omly label
//        NSLayoutConstraint.activate([labelName.topAnchor.constraint(equalTo: topAnchor), labelName.trailingAnchor.constraint(equalTo: trailingAnchor), labelName.leadingAnchor.constraint(equalTo: leadingAnchor), labelName.bottomAnchor.constraint(equalTo: bottomAnchor)])


///                labelName.text = model.brands?.brand
        
//                if let urlString = model.brands?.refImage {
//                    let urlRef = storage.reference(forURL: urlString)
//                    let placeholderImage = UIImage(named: "DefaultImage")
//                    imageView.sd_imageTransition = .fade
//                    imageView.sd_setImage(with: urlRef, placeholderImage: placeholderImage) { (image, error, cacheType, url) in
//                        guard let image = image else {
//                            // Обработка ошибок
//                            return
//                        }
//
//                        // Настройка цвета изображения в зависимости от текущей темы
//                        if #available(iOS 13.0, *) {
//                            let tintColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
//                                return traitCollection.userInterfaceStyle == .dark ? R.Colors.label : R.Colors.label
//                            }
//                            self.imageView.image = image.sd_tintedImage(with: tintColor)
//                        } else {
//                            self.imageView.image = image
//                        }
//                    }
//
//                }
        
//        if let urlString = model.brands?.refImage {
//            let urlRef = storage.reference(forURL: urlString)
//            let placeholderImage = UIImage(named: "DefaultImage")
////            let options = ImageLoaderOptions(placeholder: placeholderImage, transition: .fade(0.2))
//
//            let options = SDWebImageOptions()
//            options.sd_imageTransition = .fade
//
//            imageView.sd_setImage(with: urlRef, placeholderImage: placeholderImage, options: options) { (image, error, cacheType, url) in
//                guard let image = image else {
//                    // Обработка ошибок
//                    return
//                }
//                // Настройка цвета изображения в зависимости от текущей темы
//                if #available(iOS 13.0, *) {
//                    let tintColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
//                        return traitCollection.userInterfaceStyle == .dark ? .white : .black
//                    }
//                    self.imageView.image = image.sd_tintedImage(with: tintColor)
//                } else {
//                    self.imageView.image = image
//                }
//            }
//        }
