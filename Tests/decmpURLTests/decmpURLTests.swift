import XCTest
@testable import decmpURL

final class decmpURLTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(decmpURL().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
