// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { Script } from "lib/forge-std/src/Script.sol";
import { Counter } from "../src/Counter.sol";

interface ICounterScript {
  function run() external;
}

contract CounterScript is Script, ICounterScript {
  Counter public counter;

  function run() public override {
    vm.startBroadcast();

    counter = new Counter();

    vm.stopBroadcast();
  }
}
