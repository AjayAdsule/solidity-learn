// SPDX-License-Identifier: MIT
pragma solidity >=0.8.20;

abstract contract BluePrint {
    string public str;

    constructor() {
        str = "Hello solidity";
    }

    function getStr() external virtual returns (string memory);
}

contract Dum is BluePrint {
    constructor() {
        str = "hello world";
    }

    function getStr() external override returns (string memory) {
        return str = "Hello abstraction";
    }
}
