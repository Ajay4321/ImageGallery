//
//  ViewController.swift
//  ImageGallery
//
//  Created by Ajay Awasthi on 29/09/24.
//

import UIKit

class HomeViewController: UIViewController {
    
    let itemsPerRow: CGFloat = 3
    let sectionInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    
    private var viewModel: HomeViewModel!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    @IBOutlet weak var imageCollection: UICollectionView!
    @IBOutlet weak var errorLable: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadData()
    }
    
    func setupViewDidLoad(){
        viewModel = HomeViewModel()
        activityIndicatorView.startAnimating()
        self.errorLable.isHidden = true
        self.imageCollection.isHidden = true
        let customCollectionViewCellNib = UINib(nibName: "ImageCollectionCell", bundle: nil)
        imageCollection.register(customCollectionViewCellNib, forCellWithReuseIdentifier: "ImageCollectionCell")
    }
    
    func loadData() {
        guard !viewModel.isLoading else { return }  // Prevent multiple requests
        viewModel.isLoading = true  // Set flag to indicate loading is in progress
        
        // Run the data loading task in a background queue
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            
            self.viewModel.loadData { result in
                DispatchQueue.main.async {  // Ensure UI updates happen on the main thread
                    self.viewModel.isLoading = false  // Reset loading flag after data is fetched
                    
                    switch result {
                    case .success:
                        self.handleLoadDataSuccess()
                        
                    case let .failure(error):
                        self.handleLoadDataError(error)
                    }
                }
            }
        }
    }
    
    private func handleLoadDataError(_ error: Error) {
        setupErrorUI()
        imageCollection.isHidden = true
        errorLable.isHidden = false
        errorLable.text = error.localizedDescription
    }

    private func handleLoadDataSuccess() {
        setupErrorUI()
        imageCollection.isHidden = false
        imageCollection.reloadData()
    }

    
    func setupErrorUI(){
        activityIndicatorView.stopAnimating()
        activityIndicatorView.hidesWhenStopped = true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        // Check if we are close to the bottom of the content and ensure no other data load is in progress
        if offsetY > contentHeight - height - 100 && !viewModel.isLoading && viewModel.hasMoreData {
            loadData()
        }
    }
    
}

extension HomeViewController : UICollectionViewDataSource{
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getImageCount()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imageCollection.dequeueReusableCell(withReuseIdentifier: "ImageCollectionCell", for: indexPath) as! ImageCollectionCell
        
        // Check if the indexPath is within bounds of the image array
        guard indexPath.item >= 0 && indexPath.item < viewModel.getImageCount() else {
            print("Index out of bounds: \(indexPath.item)")
            return cell  // Return the cell without updating it
        }

        // Get the image data safely
        let imageResult = viewModel.getImage(at: indexPath.item)
            // Check if the URL string is valid
            if let imageUrl = URL(string: imageResult.thumbnailUrl) {
                cell.loadImage(from: imageUrl)
            } else {
                print("Invalid URL: \(imageResult.thumbnailUrl)")
            }
        
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = DetailViewController()
            detailVC.images = viewModel.getImages()  // Pass the images
            detailVC.currentIndex = indexPath.item  // Pass the tapped image index
            navigationController?.pushViewController(detailVC, animated: true)
    }
}


extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}


