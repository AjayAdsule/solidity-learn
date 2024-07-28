// SPDX-License-Identifier: MIT
pragma solidity >=0.8.20;

interface IfirstInterface {
    // function getData() external view returns(uint);
    function greet() external pure returns (string memory);
}

contract Interface is IfirstInterface {
    function greet() external pure returns (string memory) {
        return "hello interfaces";
    }
}

contract secondInterface is IfirstInterface {
    function greet() external pure returns (string memory) {
        return "second interface";
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
}
