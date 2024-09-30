//
//  DetailViewUITest.swift
//  ImageGalleryTests
//
//  Created by Ajay Awasthi on 30/09/24.
//

import XCTest

import XCTest
@testable import ImageGallery

class DetailViewTests: XCTestCase {
    
    var detailView: DetailView!
    var sampleImageResponse: ImageResponse!
    var mockImageLoader: MockImageLoader!

    override func setUp() {
        super.setUp()
        detailView = DetailView(frame: CGRect(x: 0, y: 0, width: 375, height: 667))
        
        mockImageLoader = MockImageLoader()
        detailView.imageLoader = mockImageLoader
        
        // Sample image response
        sampleImageResponse = ImageResponse(id: 12, title: "Sample Title", url: "http://example.com/sample.jpg", thumbnailUrl: "https://google.com", albumId: 123)
    }

    override func tearDown() {
        detailView = nil
        sampleImageResponse = nil
        super.tearDown()
    }

    // Test that UI components are initialized properly
    func testUIComponentsInitialization() {
        XCTAssertNotNil(detailView, "DetailView should be initialized")
        XCTAssertNotNil(detailView.testImageView, "ImageView should be initialized")
        XCTAssertNotNil(detailView.testAlbumIdLabel, "Album ID label should be initialized")
        XCTAssertNotNil(detailView.testTitleLabel, "Title label should be initialized")
    }

    // Test that the placeholder image is set initially
    func testInitialImageIsPlaceholder() {
        XCTAssertEqual(detailView.testImageView.image, UIImage(named: "placeholderLargeImage.jpg"), "Initial image should be the placeholder image")
    }

    // Test that the labels are empty before updating the view
    func testLabelsAreEmptyInitially() {
        XCTAssertEqual(detailView.testAlbumIdLabel.text, nil, "Album ID label should be empty initially")
        XCTAssertEqual(detailView.testTitleLabel.text, nil, "Title label should be empty initially")
    }

    // Test updating the view with image response
    func testUpdateView() {
        // Act: Update the view with the sample image response
        detailView.updateView(with: sampleImageResponse)

        // Assert: Check that the labels are updated correctly
        XCTAssertEqual(detailView.testAlbumIdLabel.text, "Album Id: 123", "Album ID label should be updated correctly")
        XCTAssertEqual(detailView.testTitleLabel.text, "Title: Sample Title", "Title label should be updated correctly")
    }

    // Test loading image from a valid URL (you may want to mock ImageLoader in a real test)
    func testLoadImageFromValidURL() {
        let expectation = self.expectation(description: "Image should load placeholder for invalid URL")
            
            let invalidImageResponse = ImageResponse(id: 12, title: "Image 1", url: "Test Title", thumbnailUrl: "invalid_url", albumId: 1)
            
            // Assuming that the mock image loader handles invalid URLs by not calling the completion
            mockImageLoader.loadImageHandler = { _, completion in
                completion(nil) // Simulate loading failure
            }

            // Act: Update view with the sample image response
            detailView.updateView(with: invalidImageResponse)

            // Assert: Wait for the asynchronous operation to complete
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                // Check that the image view has the placeholder image
                XCTAssertEqual(self.detailView.testImageView.image, self.detailView.testPlaceHolderImage, "Image view should display placeholder image for invalid URL")
                expectation.fulfill()
            }

            waitForExpectations(timeout: 1.0, handler: nil)
    }
    

    // Test layout constraints (You can add additional layout tests if necessary)
    func testConstraints() {
        XCTAssertEqual(detailView.testImageView.translatesAutoresizingMaskIntoConstraints, false, "Image view should use Auto Layout")
        XCTAssertEqual(detailView.testAlbumIdLabel.translatesAutoresizingMaskIntoConstraints, false, "Album ID label should use Auto Layout")
        XCTAssertEqual(detailView.testTitleLabel.translatesAutoresizingMaskIntoConstraints, false, "Title label should use Auto Layout")
    }
}
