// SPDX-License-Identifier: MIT
pragma solidity >=0.8.20;

contract dynamicArr{
    uint[] public  arr;

    function getArr() external view  returns (uint[] memory){
        return arr;
    }

    function updateArr( uint _val)external {
        arr.push(_val);
    }
}