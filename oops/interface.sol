// SPDX-License-Identifier: MIT
pragma solidity >=0.8.20;

interface IfirstInterface {
    // function getData() external view returns(uint);
    function greet() external pure returns (string memory);

    function addEth() external payable;

    function getContractBalance() external view returns (uint256);
}

contract Interface is IfirstInterface {
    function greet() external pure returns (string memory) {
        return "hello interfaces";
    }

    function addEth() external payable {}

    function getContractBalance() external view returns (uint256) {
        return address(this).balance;
    }
}

contract secondInterface is IfirstInterface {
    function greet() external pure returns (string memory) {
        return "second interface";
    }

    function addEth() external payable {}

    function getContractBalance() external view returns (uint256) {
        return address(this).balance;
    }
}

contract CallerContract {
    function getInterfaceCaller(address _caller)
        external
        pure
        returns (string memory)
    {
        return IfirstInterface(_caller).greet();
    }

    function getAddressBalance(address _caller)
        external
        view
        returns (uint256)
    {
        return IfirstInterface(_caller).getContractBalance();
    }
}
