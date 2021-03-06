//
//  VariableMultipleSubscribeTests.swift
//  Bindable
//
//  Created by Tom Lokhorst on 2017-07-19.
//  Copyright © 2017 Q42. All rights reserved.
//

import XCTest
import Bindable

class VariableMultipleSubscribeTests: XCTestCase {

  func testChange() {
    let disposeBag = DisposeBag()
    let source = VariableSource(value: 1)
    let variable = source.variable

    XCTAssertEqual(variable.value, 1)

    let ex = self.expectation(description: "Expectation didn't finish")
    var callbacks = 0

    variable.subscribe { event in
      XCTAssertEqual(event.value, 2)

      callbacks += 1
      if callbacks == 2 {
        ex.fulfill()
      }
    }.disposed(by: disposeBag)

    variable.subscribe { event in
      XCTAssertEqual(event.value, 2)

      callbacks += 1
      if callbacks == 2 {
        ex.fulfill()
      }
    }.disposed(by: disposeBag)

    source.value += 1

    waitForExpectations(timeout: 0.1, handler: nil)
  }

  func testMapChange1() {
    let disposeBag = DisposeBag()
    let source = VariableSource(value: 1)
    let variable = source.variable.map { $0 + 1 }

    XCTAssertEqual(variable.value, 2)

    let ex = self.expectation(description: "Expectation didn't finish")
    var callbacks = 0

    variable.subscribe { event in
      XCTAssertEqual(event.value, 4)

      callbacks += 1
      if callbacks == 2 {
        ex.fulfill()
      }
    }.disposed(by: disposeBag)

    variable.subscribe { event in
      XCTAssertEqual(event.value, 4)

      callbacks += 1
      if callbacks == 2 {
        ex.fulfill()
      }
    }.disposed(by: disposeBag)

    source.value = 3

    waitForExpectations(timeout: 0.1, handler: nil)
  }

  func testMapChange2() {
    let disposeBag = DisposeBag()
    let source = VariableSource(value: 1)
    let variable1 = source.variable
    let variable2 = variable1.map { $0 + 1 }

    XCTAssertEqual(variable1.value, 1)
    XCTAssertEqual(variable2.value, 2)

    let ex = self.expectation(description: "Expectation didn't finish")
    var callbacks = 0

    variable1.subscribe { event in
      XCTAssertEqual(event.value, 3)
      XCTAssertEqual(variable2.value, 4)

      callbacks += 1
      if callbacks == 2 {
        ex.fulfill()
      }
    }.disposed(by: disposeBag)

    variable2.subscribe { event in
      XCTAssertEqual(event.value, 4)
      XCTAssertEqual(variable1.value, 3)

      callbacks += 1
      if callbacks == 2 {
        ex.fulfill()
      }
    }.disposed(by: disposeBag)

    source.value = 3

    waitForExpectations(timeout: 0.1, handler: nil)

  }

  func testMapMapChange1() {
    let source = VariableSource(value: 1)
    let variable = source.variable.map { $0 + 1 }.map { $0 * 10 }

    XCTAssertEqual(variable.value, 20)

    let ex = self.expectation(description: "Expectation didn't finish")
    var callbacks = 0

    variable.subscribe { event in
      XCTAssertEqual(event.value, 40)

      callbacks += 1
      if callbacks == 2 {
        ex.fulfill()
      }
    }.disposed(by: disposeBag)

    variable.subscribe { event in
      XCTAssertEqual(event.value, 40)

      callbacks += 1
      if callbacks == 2 {
        ex.fulfill()
      }
    }.disposed(by: disposeBag)

    source.value = 3

    waitForExpectations(timeout: 0.1, handler: nil)
  }

  func testMapMapChange2() {
    let disposeBag = DisposeBag()
    let source = VariableSource(value: 1)
    let variable1 = source.variable
    let variable2 = variable1.map { $0 + 1 }
    let variable3 = variable2.map { $0 * 10 }

    XCTAssertEqual(variable1.value, 1)
    XCTAssertEqual(variable2.value, 2)
    XCTAssertEqual(variable3.value, 20)

    let ex = self.expectation(description: "Expectation didn't finish")
    var callbacks = 0

    variable1.subscribe { event in
      XCTAssertEqual(event.value, 3)
      XCTAssertEqual(variable2.value, 4)
      XCTAssertEqual(variable3.value, 40)

      callbacks += 1
      if callbacks == 3 {
        ex.fulfill()
      }
    }.disposed(by: disposeBag)

    variable2.subscribe { event in
      XCTAssertEqual(event.value, 4)
      XCTAssertEqual(variable1.value, 3)
      XCTAssertEqual(variable3.value, 40)

      callbacks += 1
      if callbacks == 3 {
        ex.fulfill()
      }
    }.disposed(by: disposeBag)

    variable3.subscribe { event in
      XCTAssertEqual(event.value, 40)
      XCTAssertEqual(variable1.value, 3)
      XCTAssertEqual(variable2.value, 4)

      callbacks += 1
      if callbacks == 3 {
        ex.fulfill()
      }
    }.disposed(by: disposeBag)

    source.value = 3

    waitForExpectations(timeout: 0.1, handler: nil)
  }

  func testAndChange() {
    let disposeBag = DisposeBag()
    let leftSource = VariableSource(value: 1)
    let rightSource = VariableSource(value: true)
    let variableL = leftSource.variable
    let variableR = rightSource.variable
    let variable = variableL && variableR

    let ex = self.expectation(description: "Expectation didn't finish")
    var callbacks = 0

    variable.subscribe { event in
      callbacks += 1
      if callbacks == 4 {
        ex.fulfill()
      }
    }.disposed(by: disposeBag)
    variable.subscribe { event in
      callbacks += 1
      if callbacks == 4 {
        ex.fulfill()
      }
    }.disposed(by: disposeBag)

    leftSource.value = 3
    rightSource.value = false

    waitForExpectations(timeout: 0.1, handler: nil)
  }

  func testOrChange() {
    let disposeBag = DisposeBag()
    let leftSource = VariableSource(value: 1)
    let rightSource = VariableSource(value: -1)
    let variableL = leftSource.variable
    let variableR = rightSource.variable
    let variable = variableL || variableR

    let ex = self.expectation(description: "Expectation didn't finish")
    var callbacks = 0

    variable.subscribe { event in
      callbacks += 1
      if callbacks == 4 {
        ex.fulfill()
      }
    }.disposed(by: disposeBag)
    variable.subscribe { event in
      callbacks += 1
      if callbacks == 4 {
        ex.fulfill()
      }
    }.disposed(by: disposeBag)

    leftSource.value = 3
    rightSource.value = -2

    waitForExpectations(timeout: 0.1, handler: nil)
  }

}
