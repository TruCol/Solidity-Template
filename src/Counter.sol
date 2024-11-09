// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface ICounter {
  function setNumber(uint256 newNumber) external;

  function increment() external;
}

contract Counter is ICounter {
  uint256 public number;

  function setNumber(uint256 newNumber) public override {
    number = newNumber;
  }

  function increment() public override {
    ++number;
  }
}
