//
//  PhotoModelTests.swift
//  PhotoGridTests
//
//  Created by Soemin Thein on 06/09/2024.
//

import XCTest
@testable import PhotoGrid

final class PhotoModelTests: XCTestCase {
    
    func testPhotoModelInitialization() throws {
        let photo = PhotoModel(
            id: "123",
            author: "John Doe",
            url: "https://example.com/photo.jpg",
            downloadURL: "https://example.com/download.jpg"
        )
        
        XCTAssertEqual(photo.id, "123")
        XCTAssertEqual(photo.author, "John Doe")
        XCTAssertEqual(photo.url, "https://example.com/photo.jpg")
        XCTAssertEqual(photo.downloadURL, "https://example.com/download.jpg")
    }
    
    func testResizedImageURLComputedProperty() throws {
        let photo = PhotoModel(
            id: "456",
            author: "Jane Smith",
            url: "https://example.com/photo.jpg",
            downloadURL: "https://example.com/download.jpg"
        )
        
        let expectedResizedURL = "https://picsum.photos/id/456/300/200"
        XCTAssertEqual(photo.resizedImageURL, expectedResizedURL)
    }
    
    func testPhotoModelCodingKeys() throws {
        let jsonString = """
        {
            "id": "789",
            "author": "Bob Wilson",
            "url": "https://example.com/photo.jpg",
            "download_url": "https://example.com/download.jpg"
        }
        """
        
        let jsonData = jsonString.data(using: .utf8)!
        let photo = try JSONDecoder().decode(PhotoModel.self, from: jsonData)
        
        XCTAssertEqual(photo.id, "789")
        XCTAssertEqual(photo.author, "Bob Wilson")
        XCTAssertEqual(photo.url, "https://example.com/photo.jpg")
        XCTAssertEqual(photo.downloadURL, "https://example.com/download.jpg")
    }
    
    func testPhotoModelEncoding() throws {
        let photo = PhotoModel(
            id: "999",
            author: "Alice Johnson",
            url: "https://example.com/photo.jpg",
            downloadURL: "https://example.com/download.jpg"
        )
        
        let encodedData = try JSONEncoder().encode(photo)
        let decodedPhoto = try JSONDecoder().decode(PhotoModel.self, from: encodedData)
        
        XCTAssertEqual(decodedPhoto.id, photo.id)
        XCTAssertEqual(decodedPhoto.author, photo.author)
        XCTAssertEqual(decodedPhoto.url, photo.url)
        XCTAssertEqual(decodedPhoto.downloadURL, photo.downloadURL)
    }
    
    func testPhotoModelWithSpecialCharacters() throws {
        let photo = PhotoModel(
            id: "123-456_789",
            author: "José María O'Connor-Smith",
            url: "https://example.com/photo with spaces.jpg",
            downloadURL: "https://example.com/download/photo%20with%20encoding.jpg"
        )
        
        XCTAssertEqual(photo.id, "123-456_789")
        XCTAssertEqual(photo.author, "José María O'Connor-Smith")
        XCTAssertEqual(photo.url, "https://example.com/photo with spaces.jpg")
        XCTAssertEqual(photo.downloadURL, "https://example.com/download/photo%20with%20encoding.jpg")
        
        let expectedResizedURL = "https://picsum.photos/id/123-456_789/300/200"
        XCTAssertEqual(photo.resizedImageURL, expectedResizedURL)
    }
    
    func testPhotoModelWithEmptyStrings() throws {
        let photo = PhotoModel(
            id: "",
            author: "",
            url: "",
            downloadURL: ""
        )
        
        XCTAssertEqual(photo.id, "")
        XCTAssertEqual(photo.author, "")
        XCTAssertEqual(photo.url, "")
        XCTAssertEqual(photo.downloadURL, "")
        
        let expectedResizedURL = "https://picsum.photos/id//300/200"
        XCTAssertEqual(photo.resizedImageURL, expectedResizedURL)
    }
    
    func testPhotoModelArrayCoding() throws {
        let photos = [
            PhotoModel(id: "1", author: "Author1", url: "url1", downloadURL: "download1"),
            PhotoModel(id: "2", author: "Author2", url: "url2", downloadURL: "download2")
        ]
        
        let encodedData = try JSONEncoder().encode(photos)
        let decodedPhotos = try JSONDecoder().decode([PhotoModel].self, from: encodedData)
        
        XCTAssertEqual(decodedPhotos.count, 2)
        XCTAssertEqual(decodedPhotos[0].id, "1")
        XCTAssertEqual(decodedPhotos[1].id, "2")
    }
} 