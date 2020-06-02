import XCTest
@testable import decmpURL

final class DecmpURLTests: XCTestCase {
    func testSuccessDecompress() {
        let urlList: [(URL, URL)] = [
            (URL(string: "https://amzn.to/2XrxegU")!, URL(string: "https://www.amazon.co.jp/gp/product/B0826KJC28/ref=as_li_tl?ie=UTF8&camp=247&creative=1211&creativeASIN=B0826KJC28&linkCode=as2&tag=gucchi0b-22&linkId=6ede7ba4e280ade29283c1b14eb67151")!),
            (URL(string: "https://is.gd/dLwfPX")!, URL(string: "https://www.yahoo.co.jp/")!),
            (URL(string: "https://ux.nu/el0IU")!, URL(string: "https://www.yahoo.co.jp/")!),
            (URL(string: "http://ow.ly/ogel50zQibM")!, URL(string: "https://www.yahoo.co.jp:443/")!),
            (URL(string: "https://bit.ly/3elQGkK")!, URL(string: "https://www.yahoo.co.jp/")!),
            (URL(string: "https://htn.to/3Q8FBXCpdp")!, URL(string: "https://anond.hatelabo.jp/20200521200214")!)
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
