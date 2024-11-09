pragma solidity ^0.8.24;

import { ReentrancyGuard } from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import { Test } from "lib/forge-std/src/Test.sol";
import { Counter } from "./../../src/Counter.sol";

error XTooSmall(uint256 x, string variableName);
error XTooLarge(uint256 x, string variableName);

// Interface for CounterFuzzUnitTests contract
interface ICounterFuzzUnitTests {
  function testUnitIncrement() external;

  function testUnitSetNumber(uint256 x, uint256 y) external;
}

contract CounterFuzzUnitTests is Test, ICounterFuzzUnitTests, ReentrancyGuard {
  Counter public immutable COUNTER;

  bool public isIncrementTested;
  bool public isSetNumberTested;
  uint256 public numberOfTestRunsForIncrement;
  uint256 public numberOfTestRunsForSetNumber;

  constructor() {
    COUNTER = new Counter();
  }

  function testUnitIncrement() public override nonReentrant {
    isIncrementTested = true;
    ++numberOfTestRunsForIncrement;
    uint256 numberBeforeIncrement = COUNTER.number();
    if (numberBeforeIncrement < type(uint256).max) {
      COUNTER.increment();
      assertEq(COUNTER.number(), numberBeforeIncrement + 1);
    }
  }

  function testUnitSetNumber(uint256 x, uint256 y) public override nonReentrant {
    // Put a bound on the random variable.
    x = bound(x, 3, 600);
    y = bound(y, x, 800);

    // Assert the random variable x is bound successfully.
    if (x < 3) revert XTooSmall(x, "x");
    if (x > 600) revert XTooLarge(x, "x");

    // Assert the random y variable is bound successfully, relatively to random variable x.
    if (y < x) revert XTooSmall(y, "y");
    if (y > 800) revert XTooLarge(y, "y");

    isSetNumberTested = true;
    ++numberOfTestRunsForSetNumber;

    COUNTER.setNumber(x);
    assertEq(COUNTER.number(), x);
  }
}
