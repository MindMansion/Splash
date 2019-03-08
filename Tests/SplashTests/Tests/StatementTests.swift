/**
 *  Splash
 *  Copyright (c) John Sundell 2018
 *  MIT license - see LICENSE.md
 */

import Foundation
import XCTest
import Splash

final class StatementTests: SyntaxHighlighterTestCase {
    func testImportStatement() {
        let components = highlighter.highlight("import UIKit")

        XCTAssertEqual(components, [
            .token("import", .keyword),
            .whitespace(" "),
            .plainText("UIKit")
        ])
    }

    func testImportStatementWithSubmodule() {
        let components = highlighter.highlight("import os.log")

        XCTAssertEqual(components, [
            .token("import", .keyword),
            .whitespace(" "),
            .plainText("os.log")
        ])
    }

    func testChainedIfElseStatements() {
        let components = highlighter.highlight("if condition { } else if call() { } else { \"string\" }")

        XCTAssertEqual(components, [
            .token("if", .keyword),
            .whitespace(" "),
            .plainText("condition"),
            .whitespace(" "),
            .plainText("{"),
            .whitespace(" "),
            .plainText("}"),
            .whitespace(" "),
            .token("else", .keyword),
            .whitespace(" "),
            .token("if", .keyword),
            .whitespace(" "),
            .token("call", .call),
            .plainText("()"),
            .whitespace(" "),
            .plainText("{"),
            .whitespace(" "),
            .plainText("}"),
            .whitespace(" "),
            .token("else", .keyword),
            .whitespace(" "),
            .plainText("{"),
            .whitespace(" "),
            .token("\"string\"", .string),
            .whitespace(" "),
            .plainText("}")
        ])
    }

    func testSwitchStatement() {
        let components = highlighter.highlight("""
        switch variable {
        case .one: break
        case .two: callA()
        default:
            callB()
        }
        """)

        XCTAssertEqual(components, [
            .token("switch", .keyword),
            .whitespace(" "),
            .plainText("variable"),
            .whitespace(" "),
            .plainText("{"),
            .whitespace("\n"),
            .token("case", .keyword),
            .whitespace(" "),
            .plainText("."),
            .token("one", .dotAccess),
            .plainText(":"),
            .whitespace(" "),
            .token("break", .keyword),
            .whitespace("\n"),
            .token("case", .keyword),
            .whitespace(" "),
            .plainText("."),
            .token("two", .dotAccess),
            .plainText(":"),
            .whitespace(" "),
            .token("callA", .call),
            .plainText("()"),
            .whitespace("\n"),
            .token("default", .keyword),
            .plainText(":"),
            .whitespace("\n    "),
            .token("callB", .call),
            .plainText("()"),
            .whitespace("\n"),
            .plainText("}")
        ])
    }

    func testSwitchStatementWithAssociatedValues() {
        let components = highlighter.highlight("""
        switch value {
        case .one(let a): break
        }
        """)

        XCTAssertEqual(components, [
            .token("switch", .keyword),
            .whitespace(" "),
            .plainText("value"),
            .whitespace(" "),
            .plainText("{"),
            .whitespace("\n"),
            .token("case", .keyword),
            .whitespace(" "),
            .plainText("."),
            .token("one", .dotAccess),
            .plainText("("),
            .token("let", .keyword),
            .whitespace(" "),
            .plainText("a):"),
            .whitespace(" "),
            .token("break", .keyword),
            .whitespace("\n"),
            .plainText("}")
        ])
    }
        
    func testSwitchStatementWithFallthrough() {
        let components = highlighter.highlight("""
        switch variable {
        case .one: fallthrough
        default:
            callB()
        }
        """)
        
        XCTAssertEqual(components, [
            .token("switch", .keyword),
            .whitespace(" "),
            .plainText("variable"),
            .whitespace(" "),
            .plainText("{"),
            .whitespace("\n"),
            .token("case", .keyword),
            .whitespace(" "),
            .plainText("."),
            .token("one", .dotAccess),
            .plainText(":"),
            .whitespace(" "),
            .token("fallthrough", .keyword),
            .whitespace("\n"),
            .token("default", .keyword),
            .plainText(":"),
            .whitespace("\n    "),
            .token("callB", .call),
            .plainText("()"),
            .whitespace("\n"),
            .plainText("}")
        ])
    }

    func testSwitchStatementWithTypePatternMatching() {
        let components = highlighter.highlight("""
        switch variable {
        case is MyType: break
        default: break
        }
        """)

        XCTAssertEqual(components, [
            .token("switch", .keyword),
            .whitespace(" "),
            .plainText("variable"),
            .whitespace(" "),
            .plainText("{"),
            .whitespace("\n"),
            .token("case", .keyword),
            .whitespace(" "),
            .token("is", .keyword),
            .whitespace(" "),
            .token("MyType", .type),
            .plainText(":"),
            .whitespace(" "),
            .token("break", .keyword),
            .whitespace("\n"),
            .token("default", .keyword),
            .plainText(":"),
            .whitespace(" "),
            .token("break", .keyword),
            .whitespace("\n"),
            .plainText("}")
        ])
    }

    func testForStatementWithStaticProperty() {
        let components = highlighter.highlight("for value in Enum.allCases { }")

        XCTAssertEqual(components, [
            .token("for", .keyword),
            .whitespace(" "),
            .plainText("value"),
            .whitespace(" "),
            .token("in", .keyword),
            .whitespace(" "),
            .token("Enum", .type),
            .plainText("."),
            .token("allCases", .property),
            .whitespace(" "),
            .plainText("{"),
            .whitespace(" "),
            .plainText("}")
        ])
    }
        
    func testForStatementWithContinue() {
        let components = highlighter.highlight("for value in Enum.allCases { continue }")
        
        XCTAssertEqual(components, [
            .token("for", .keyword),
            .whitespace(" "),
            .plainText("value"),
            .whitespace(" "),
            .token("in", .keyword),
            .whitespace(" "),
            .token("Enum", .type),
            .plainText("."),
            .token("allCases", .property),
            .whitespace(" "),
            .plainText("{"),
            .whitespace(" "),
            .token("continue",.keyword),
            .whitespace(" "),
            .plainText("}")
        ])
    }
    
    func testRepeatWhileStatement() {
        let components = highlighter.highlight("""
        var x = 5
        repeat {
            print(x)
            x = x - 1
        } while x > 1
        """)
        
        XCTAssertEqual(components, [
            .token("var", .keyword),
            .whitespace(" "),
            .plainText("x"),
            .whitespace(" "),
            .plainText("="),
            .whitespace(" "),
            .token("5", .number),
            .whitespace("\n"),
            .token("repeat", .keyword),
            .whitespace(" "),
            .plainText("{"),
            .whitespace("\n    "),
            .token("print", .call),
            .plainText("(x)"),
            .whitespace("\n    "),
            .plainText("x"),
            .whitespace(" "),
            .plainText("="),
            .whitespace(" "),
            .plainText("x"),
            .whitespace(" "),
            .plainText("-"),
            .whitespace(" "),
            .token("1", .number),
            .whitespace("\n"),
            .plainText("}"),
            .whitespace(" "),
            .token("while", .keyword),
            .whitespace(" "),
            .plainText("x"),
            .whitespace(" "),
            .plainText(">"),
            .whitespace(" "),
            .token("1", .number)
        ])
    }

    func testAllTestsRunOnLinux() {
        XCTAssertTrue(TestCaseVerifier.verifyLinuxTests((type(of: self)).allTests))
    }
}

extension StatementTests {
    static var allTests: [(String, TestClosure<StatementTests>)] {
        return [
            ("testImportStatement", testImportStatement),
            ("testImportStatementWithSubmodule", testImportStatementWithSubmodule),
            ("testChainedIfElseStatements", testChainedIfElseStatements),
            ("testSwitchStatement", testSwitchStatement),
            ("testSwitchStatementWithAssociatedValues", testSwitchStatementWithAssociatedValues),
            ("testSwitchStatementWithFallthrough", testSwitchStatementWithFallthrough),
            ("testSwitchStatementWithTypePatternMatching", testSwitchStatementWithTypePatternMatching),
            ("testForStatementWithStaticProperty", testForStatementWithStaticProperty),
            ("testForStatementWithContinue", testForStatementWithContinue),
            ("testRepeatWhileStatement", testRepeatWhileStatement)
        ]
    }
}
