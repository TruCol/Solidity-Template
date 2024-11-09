// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import { StdInvariant } from "lib/forge-std/src/StdInvariant.sol";
import { Test } from "lib/forge-std/src/Test.sol";
import { CounterFuzzUnitTests } from "./CounterFuzzUnitTests.sol";

interface ICounterFuzzTestManager {
  function setUp() external;

  function invariantTest() external;

  // solhint-disable-next-line foundry-test-functions
  function afterInvariant() external;
}

contract CounterFuzzTestManager is StdInvariant, Test, ICounterFuzzTestManager {
  CounterFuzzUnitTests public counterFuzzUnitTests;

  function setUp() public override {
    // Initialise the contract with the unit tests.
    counterFuzzUnitTests = new CounterFuzzUnitTests();

    // Specify what the Fuzz/invariant fuzz target contract is.
    targetContract(address(counterFuzzUnitTests));
  }

  /**
  This function ensures the target contract is being fuzzed. You do not need to include the specific unit/fuzz test
   functions, the invariant contract will find those automatically and call its test functions randomly.*/
  /// forge-config: default.invariant.runs = 44
  /// forge-config: default.invariant.depth = 660
  /// forge-config: default.invariant.fail-on-revert = true
  // solhint-disable-next-line no-empty-blocks
  function invariantTest() public override {
    // counterFuzzUnitTests.testUnitIncrement(); // Not necessary.
    // counterFuzzUnitTests.setNumber(66); // Not necessary.
  }

  /**This function is ran after each RUN of the Invariant Fuzzing campaign. So even if you have 3 runs with a depth of
  128, you can assert the total count afterInvariant will be 128.*/
  // solhint-disable-next-line foundry-test-functions
  function afterInvariant() public view override {
    assertEq(
      counterFuzzUnitTests.numberOfTestRunsForIncrement() + counterFuzzUnitTests.numberOfTestRunsForSetNumber(),
      660
    );

    assertEq(counterFuzzUnitTests.isIncrementTested(), true);
    assertEq(counterFuzzUnitTests.isSetNumberTested(), true);

    assertGe(counterFuzzUnitTests.numberOfTestRunsForIncrement(), 100); // 100/660 is probable enough for 50/50.
    assertGe(counterFuzzUnitTests.numberOfTestRunsForSetNumber(), 100); // 100/660 is probable enough for 50/50.
    assertEq(
      counterFuzzUnitTests.numberOfTestRunsForIncrement() + counterFuzzUnitTests.numberOfTestRunsForSetNumber(),
      660
    );
  }
}
