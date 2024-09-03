// SPDX-License-Identifier: MIT
pragma solidity >=0.8.20;

contract LearningWallet {
    address owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "you are not authorized");
        _;
    }

    function transferToContract() external payable {}

    function getContractBalance() external view returns (uint256) {
        return address(this).balance;
    }

    function transferEth(address payable _receiver, uint256 _amount)
        external
        onlyOwner
    {
        require(
            address(owner).balance >= _amount,
            "insufficent balance in your contract"
        );
        _receiver.transfer(_amount);
    }
 
 
    //this function will take input as balance and transfer to waller
    function transferViaMsgValue(address payable _to) external payable {
        require(owner.balance >= msg.value, "you have insufficent ether");
        _to.transfer(msg.value);
    }

    function receiveFromUser() external payable {
        require(msg.sender.balance >= 0, "value is greter than 0");
        payable(owner).transfer(msg.value);
    }

    function getOwnerBalance() external view returns (uint256) {
        return owner.balance;
    }
}
