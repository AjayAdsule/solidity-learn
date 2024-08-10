// SPDX-License-Identifier: MIT
pragma solidity >=0.8.20;

contract Structs {
    struct voterDetails {
        string name;
        uint256 voterId;
        uint256 age;
    }

    mapping(uint256 => voterDetails) votersData;

    function createVoter(
        uint256 _indx,
        string memory _name,
        uint256 _voterId,
        uint256 _age
    ) public {
        votersData[_indx] = voterDetails(_name, _voterId, _age);
    }

    function getVoter(uint256 _indx) public view returns (voterDetails memory) {
        return votersData[_indx];
    }

 


}
