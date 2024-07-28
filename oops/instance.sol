// SPDX-License-Identifier: MIT
pragma solidity >=0.8.20;

contract Book {
    uint256 height;
    uint256 width;

    function setDimensions(uint256 _height, uint256 _width) external {
        height = _height;
        width = _width;
    }

    function getDimensions() external view returns (uint256, uint256) {
        return (height, width);
    }
}

contract Book1 {
    Book obj = new Book();

    function getBookInstance() external view returns (Book) {
        return obj;
    }

    function setCurDimension(uint256 _height, uint256 _width) external {
        obj.setDimensions(_height, _width);
    }

    function getCurDimension() external view returns (uint256, uint256) {
        return obj.getDimensions();
    }
}
