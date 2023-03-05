//
//  ApiClient2Tests.swift
//  Testable API2Tests
//
//  Created by Ankit Saxena on 05/03/23.
//

import XCTest
@testable import Testable_API2

final class ApiClient2Tests: XCTestCase {
    
    var client: ApiClient2!
    var url: URL!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        let sessionConfig = URLSessionConfiguration.ephemeral
        sessionConfig.protocolClasses = [MockAPI2.self]
        let session = URLSession(configuration: sessionConfig)
        
        client = ApiClient2(session: session)
        
        url = URL(string: "http:testurl.com")!
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        MockAPI2.stubData = nil
        MockAPI2.stubError = nil
        client = nil
        url = nil
        super.tearDown()
    }
    
    func testPostSuccess() {
        //Given
        let reqData = CreateJobReQ(name: "AB", job: "ss")
        
        let res = CreateJobRes(name: "Ankit", job: "22", id: "2", createdAt: "33")
        let resData = try! JSONEncoder().encode(res)
        MockAPI2.stubData = resData
        
        let expectation = self.expectation(description: "Api Should Succeed")
        
        //When
        client.postAPI(url: url, requestData: reqData, responseDataType: CreateJobRes.self) { result in
            switch result {
            case .success(let success):
                print("Success")
                //Then
                XCTAssertEqual(success.name, "Ankit")
                expectation.fulfill()
                
            case .failure(let failure):
                print("Fail")
                XCTAssertNil(failure)
            }
        }
        
        self.waitForExpectations(timeout: 5)
        
    }
    
    func testPostFail() {
        //Given
        MockAPI2.stubError = ApiClient2Error.statusError(400)
        let expectation = self.expectation(description: "API Should Fail")
        
        //When
        client.postAPI(url: url, requestData: CreateJobReQ(name: "", job: ""), responseDataType: CreateJobRes.self) { result in
            switch result {
            case .success(let success):
                XCTAssertNil(success)
            case .failure(let failure):
                //Then
                print("failed error is \(failure.localizedDescription)")
                XCTAssertNotNil(failure)
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 5)
    }

}
