//
//  DetailaViewController.swift
//  ImageGallery
//
//  Created by Ajay Awasthi on 29/09/24.
//

import UIKit

class DetailViewController: UIViewController {

    // UI Components
    let detailView = DetailView()
    
    var images: [ImageResponse] = []  // Array of images
    var currentIndex: Int = 0  // The currently displayed image index

    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.view.backgroundColor = .white
        
        // Add the DetailView to the view controller's view
        setupDetailView()
        
        // Setup swipe gestures
        setupSwipeGestures()
        
        // Initial data update
        updateUI()
    }
    
    private func setupDetailView() {
        detailView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(detailView)
        
        // Set up constraints for the detailView
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: view.topAnchor),
            detailView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            detailView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    
    // Update the UI based on the current index
    func updateUI() {
        let image = images[currentIndex]
       detailView.updateView(with: image)
    }
    
    // Set up swipe gestures
    func setupSwipeGestures() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
    }
    
    // Handle swipe gestures
    @objc func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .left {
            if currentIndex < images.count - 1 {
                currentIndex += 1
                updateUI()
            }
        } else if gesture.direction == .right {
            if currentIndex > 0 {
                currentIndex -= 1
                updateUI()
            }
        }
    }
}
