//
//  Testable_API2Tests.swift
//  Testable API2Tests
//
//  Created by Ankit Saxena on 04/03/23.
//

import XCTest
@testable import Testable_API2

final class Testable_API2Tests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testPOSTAPI() {

        //Given
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: config)

        let res = CreateJobRes(name: "AbCD", job: "iOS", id: "1", createdAt: "Now")
        let resData = try! JSONEncoder().encode(res)
        MockURLProtocol.stubResponseData = resData

        let apiClient = APIClient(session: urlSession)



        let req = CreateJobReQ(name: "1", job: "io")
        print("success")

        let expectation = self.expectation(description: "Test API Success")

        //When
        apiClient.post(url: URL(string: "https:testurl.com")!, request: req, responseType: CreateJobRes.self) { result in

            switch result {
            case .success(let success):
                //Then
                print("Success data is \(success)")
                XCTAssertEqual(success.name, "AbCD")
                expectation.fulfill()
            case .failure(let failure):
                print("Failure \(failure)")
                XCTAssertNil(failure)
            }
        }

        self.waitForExpectations(timeout: 5)
    }

}
