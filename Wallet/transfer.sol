// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TypesOfTranfer {
    // transfer function

    function transferEth(address payable _add, uint256 _value) external {
        _add.transfer(_value);
    }

    function transferViaCall(address payable _add) external payable {
        (bool success, ) = _add.call{value: msg.value}("");
        if (!success) revert();
    }

    function transferViaOwner(address payable _add) external payable {
        _add.transfer(msg.value);
    }


    function getEth() external payable {}
}
