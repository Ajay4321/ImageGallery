//
//  DetailView.swift
//  ImageGallery
//
//  Created by Ajay Awasthi on 29/09/24.
//

import UIKit

class DetailView: UIView {

    var imageLoader: ImageLoaderProtocol = ImageLoader.shared
    
    // UI Components
    private let imageView = UIImageView()
    private let albumIdLabel = UILabel()
    private let titleLabel = UILabel()
    private let placeholderImage = UIImage(named: "placeholderLargeImage.jpg")
    
    // Computed properties for testing
       var testImageView: UIImageView { return imageView }
       var testAlbumIdLabel: UILabel { return albumIdLabel }
       var testTitleLabel: UILabel { return titleLabel }
       var testPlaceHolderImage: UIImage { return placeholderImage ?? UIImage() }

    // Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupConstraints()
    }

    // MARK: - Setup UI

    private func setupUI() {
        setupImageView()
        setupAlbumIdLabel()
        setupTitleLabel()
        addSubviews()
    }

    private func setupImageView() {
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false  // Enable Auto Layout
        imageView.image = placeholderImage  // Placeholder until the image loads
    }

    private func setupAlbumIdLabel() {
        albumIdLabel.font = UIFont.boldSystemFont(ofSize: 18)
        albumIdLabel.textAlignment = .center
        albumIdLabel.textColor = .black
        albumIdLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupTitleLabel() {
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0  // Enable multiple lines
        titleLabel.textColor = .darkGray
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    private func addSubviews() {
        // Add views to the view hierarchy
        addSubview(imageView)
        addSubview(albumIdLabel)
        addSubview(titleLabel)
    }

    // MARK: - Setup Constraints

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // ImageView constraints
            imageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 0),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            imageView.heightAnchor.constraint(equalToConstant: 400),

            // AlbumIdLabel constraints
            albumIdLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            albumIdLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            albumIdLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            albumIdLabel.heightAnchor.constraint(equalToConstant: 30),

            // TitleLabel constraints
            titleLabel.topAnchor.constraint(equalTo: albumIdLabel.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }

    // MARK: - Update UI

    func updateView(with imageResponse: ImageResponse) {
        // Update albumId and title labels
        albumIdLabel.text = "Album Id: \(imageResponse.albumId)"
        titleLabel.text = "Title: \(imageResponse.title)"
        
        // Load the image asynchronously
        if let imageUrl = URL(string: imageResponse.url) {
            loadImage(from: imageUrl)
        } else {
            print("Invalid URL: \(imageResponse.url)")
            imageView.image = placeholderImage  // Display placeholder if URL is invalid
        }
    }

    private func loadImage(from url: URL) {
        imageView.image = placeholderImage  // Set placeholder while loading

        imageLoader.loadImage(from: url) { [weak self] loadedImage in
            DispatchQueue.main.async {
                self?.imageView.image = loadedImage ?? self?.placeholderImage
            }
        }
    }
}
