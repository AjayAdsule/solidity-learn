// SPDX-License-Identifier: MIT
pragma solidity >=0.8.20;

contract Car {
    uint256 public wheels = 4;
    uint256 public topSpeed = 120;
    string public model = "A1";
}

contract SuperCar is Car {
    function setHightSpeed(uint256 _speed) external {
        topSpeed = _speed;
    }
}
