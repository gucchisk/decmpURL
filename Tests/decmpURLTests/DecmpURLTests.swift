import XCTest
@testable import decmpURL

final class DecmpURLTests: XCTestCase {
    func testSuccessDecompress() {
        let urlList: [(URL, URL)] = [
            (URL(string: "https://amzn.to/2Z9XmxK")!, URL(string: "https://www.amazon.co.jp/gp/product/B07WLJJX8V/ref=as_li_tl?ie=UTF8&camp=247&creative=1211&creativeASIN=B07WLJJX8V&linkCode=as2&tag=gucchi0b-22&linkId=7782f713438104a29cf65d04c14710b4")!),
            (URL(string: "https://amzn.to/2Z9Znu7")!, URL(string: "https://www.amazon.co.jp/gp/product/B07W7TP2FK/ref=as_li_tl?ie=UTF8&camp=247&creative=1211&creativeASIN=B07W7TP2FK&linkCode=as2&tag=gucchi0b-22&linkId=f5d730362aa59ecf3641e0ee894ac444")!)
        ]
        var exps: [XCTestExpectation] = []
        urlList.forEach { (src, expect) in
            let exp = expectation(description: expect.host!)
            exps.append(exp)
            let dec = DecmpURL(url: src)
            dec.decompress { result in
                XCTAssertEqual(try! result.get(), expect)
                exp.fulfill()
            }
        }
        wait(for: exps, timeout: 10)
    }
    
    func testNoShortUrl() {
        let urlList: [URL] = [
            URL(string: "https://www.yahoo.co.jp/")!,
            URL(string: "https://www.google.co.jp/")!
        ]
        var exps: [XCTestExpectation] = []
        urlList.forEach { url in
            let exp = expectation(description: url.host!)
            exps.append(exp)
            let dec = DecmpURL(url: url)
            dec.decompress { result in
                XCTAssertEqual(try! result.get(), url)
                exp.fulfill()
            }
        }
        wait(for: exps, timeout: 10)
    }
    
    func testNoExistUrl() {
        let urlList: [URL] = [
            URL(string: "https://yaho.jp/")!,
            URL(string: "https://googl.co.jp/")!
        ]
        var exps: [XCTestExpectation] = []
        urlList.forEach { url in
            let exp = expectation(description: url.host!)
            exps.append(exp)
            let dec = DecmpURL(url: url)
            dec.decompress { result in
                switch result {
                case .success(_):
                    XCTAssert(true)
                case .failure(DecmpError.noHost(let errurl)):
                    XCTAssertEqual(errurl, url)
                case .failure(_):
                    XCTAssert(true)
                }
                exp.fulfill()
            }
        }
        wait(for: exps, timeout: 10)
    }

    static var allTests = [
        ("testSuccessDecompress", testSuccessDecompress),
        ("testNoShortUrl", testNoShortUrl),
        ("testNoExistUrl", testNoExistUrl)
    ]
}
