// SPDX-License-Identifier: MIT
pragma solidity >=0.8.20;

contract fixedArrayi {
    uint256[2] public arr = [1, 2];

    function getArray() public view returns (uint256[2] memory) {
        return arr;
    }

    function updatedArry(uint256 _indx, uint256 _value) external {
        arr[_indx] = _value;
    }

    // write a that will multiple the array
    function multiple(uint256 num) external returns (uint256[2] memory) {
        for (uint256 i = 0; i < arr.length; i++) {
            arr[i] = arr[i] * num;
        }
        return arr;
    }
}
