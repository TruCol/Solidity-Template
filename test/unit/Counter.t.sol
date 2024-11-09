// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { Test } from "lib/forge-std/src/Test.sol";
import { Counter } from "../../src/Counter.sol";

interface ICounterTest {
  function setUp() external;

  function testIncrement() external;

  function testFuzzSetNumber() external;
}

contract CounterTest is Test, ICounterTest {
  Counter public counter;

  function setUp() public override {
    counter = new Counter();
    counter.setNumber(0);
  }

  function testIncrement() public override {
    counter.increment();
    assertEq(counter.number(), 1);
  }

  function testFuzzSetNumber() public override {
    counter.setNumber(55);
    assertEq(counter.number(), 55);
  }
}
