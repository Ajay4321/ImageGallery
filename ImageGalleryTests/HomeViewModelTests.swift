//
//  ViewModelTests.swift
//  ImageGallery
//
//  Created by Ajay Awasthi on 30/09/24.
//

import XCTest

import XCTest
@testable import ImageGallery

class HomeViewModelTests: XCTestCase {
    
    var viewModel: HomeViewModel!
    var mockImageService: MockImageService!
    
    override func setUp() {
        super.setUp()
        mockImageService = MockImageService()
        viewModel = HomeViewModel(imageService: mockImageService)  // Injecting the mock service
    }
    
    override func tearDown() {
        viewModel = nil
        mockImageService = nil
        super.tearDown()
    }
    
    func testLoadDataSuccess() {
        // Arrange: Simulate success with a list of images
        let expectedImages = [ImageResponse(id: 1, title: "image description", url: "https://google.com", thumbnailUrl: "Image 1", albumId: 1)]
        mockImageService.imagesToReturn = expectedImages
        
        let expectation = self.expectation(description: "loadData should succeed")
        
        // Act: Call loadData
        viewModel.loadData { result in
            switch result {
            case .success(let images):
                // Assert: Verify the expected outcome
                XCTAssertEqual(images, expectedImages, "Images should match expected")
                XCTAssertEqual(self.viewModel.getImages().count, expectedImages.count, "Image list should be updated")
                XCTAssertFalse(self.viewModel.isLoading, "Loading flag should be reset")
            case .failure:
                XCTFail("Expected success but got failure")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testLoadDataFailure() {
        // Arrange: Simulate failure with an error
        let expectedError = NSError(domain: "TestErrorDomain", code: 1, userInfo: nil)
        mockImageService.errorToThrow = expectedError
        let expectation = self.expectation(description: "loadData should fail")
        
        // Act: Call loadData
        viewModel.loadData { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                // Assert: Verify the error is passed correctly
                XCTAssertEqual(error.localizedDescription, expectedError.localizedDescription)
                XCTAssertFalse(self.viewModel.isLoading, "Loading flag should be reset")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
}
