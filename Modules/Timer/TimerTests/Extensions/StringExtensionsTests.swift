import Foundation
import XCTest
import Timer

class StringExtensionsTests: XCTestCase {
    
    func testTransformsTimeEntriesIntoACorrectTree() {
        let testData = [
            QueryTestData("012345", ["@"], 0, nil, "012345"),
            QueryTestData("01234 @7", ["@"], 0, nil, "01234 @7"),
            QueryTestData("01234 @7", ["@"], 6, nil, "01234 @7"),
            QueryTestData("01234 @7", ["@"], 7, "@", "7"),
            QueryTestData("01234 @7", ["@"], 8, "@", "7"),
            QueryTestData("01234 @78901234", ["@"], 11, "@", "78901234"),
            QueryTestData("01234 @7", ["@"], 9, "@", "7"),
            QueryTestData("01234@#7890", ["@", "#"], 6, nil, "01234@#7890"),
            QueryTestData("01234@#7890", ["@", "#"], 11, nil, "01234@#7890"),
            QueryTestData("01234 @23 #7890", ["@", "#"], 9, "@", "23 #7890"),
            QueryTestData("01234 @23 #7890", ["@", "#"], 12, "#", "7890"),
            QueryTestData("01234 @#7890", ["@", "#"], 9, "@", "#7890")
        ]
        
        for queryTest in testData {
            let tokens = queryTest.tokens
            let cursorPosition = queryTest.cursorPosition

            let (token, query) = queryTest.query.findTokenAndQueryMatchesForAutocomplete(tokens, cursorPosition)
            
            XCTAssertEqual(token, queryTest.expectedToken)
            XCTAssertEqual(query, queryTest.expectedQuery)
        }
    }
    
    private struct QueryTestData {
        public let query: String
        public let tokens: [Character]
        public let cursorPosition: Int
        public let expectedToken: Character?
        public let expectedQuery: String
        
        init(
         _ query: String,
         _ tokens: [Character],
         _ cursorPosition: Int,
         _ expectedToken: Character?,
         _ expectedQuery: String) {
            self.query = query
            self.tokens = tokens
            self.cursorPosition = cursorPosition
            self.expectedToken = expectedToken
            self.expectedQuery = expectedQuery
        }
    }
}
