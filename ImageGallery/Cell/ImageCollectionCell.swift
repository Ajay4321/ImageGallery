//
//  ImageCollectionCell.swift
//  ImageGallery
//
//  Created by Ajay Awasthi on 29/09/24.
//

import UIKit

class ImageCollectionCell: UICollectionViewCell{
    
    @IBOutlet weak var imgView: UIImageView!
    let placeholderImage = UIImage(named: "placeholderImage.jpg")
    
    override func awakeFromNib(){
        super.awakeFromNib()
        
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.layer.cornerRadius = 4
        imgView.layer.borderWidth = 1
        imgView.layer.borderColor = UIColor.black.cgColor
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imgView.image = placeholderImage
    }
    
    func configure(with image: UIImage) {
         imgView.image = image
     }
    
    func loadImage(from url: URL) {
        imgView.image = placeholderImage  // Set placeholder while loading

        ImageLoader.shared.loadImage(from: url) { [weak self] loadedImage in
            DispatchQueue.main.async {
                self?.imgView.image = loadedImage ?? self?.placeholderImage
            }
        }
    }
    
}
