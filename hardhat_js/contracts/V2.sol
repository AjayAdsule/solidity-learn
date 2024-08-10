// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 < 0.9.0;

contract BoxV2 {
    uint256 public value;

    function setValue(uint256 _value) public {
        value = _value * 2;
    }

}
