// SPDX-License-Identifier: MIT
pragma solidity >=0.8.20;

/*
    Wallet project
    user has record about transaction  --> receive and sent
    user can see their current balance 
    user can sent ether to other account
    owner can be change but only owner transfer their ownership

*/
contract Wallet {
    struct Transaction {
        address sender;
        address receiver;
        uint256 amount;
        uint256 time;
        string transactionType;
    }
    address payable owner;
    Transaction[] public transactions;

    constructor() {
        owner = payable(msg.sender);
    }

    modifier ethIsGreaterThan1(uint256 _amount) {
        require(
            _amount >= 1000000000000000000,
            "amount should be greater than 1 eth"
        );
        _;
    }

    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "you are not authorized to perform this task"
        );
        _;
    }

    function getEthToContract() external payable {}

    // transaction should be greater than 1 eth and we take eth value as parameter
    function sentEther( address payable _to)
        external
        payable
        ethIsGreaterThan1(msg.value)
    {
        _to.transfer(msg.value);
        transactions.push(
            Transaction({
                sender: msg.sender,
                receiver: _to,
                amount: msg.value,
                time: block.timestamp,
                transactionType: "received"
            })
        );
    }

    function getUserAccountBalance() external view returns (uint256) {
        return address(msg.sender).balance;
    }

    function urgentWithdrawal() external payable onlyOwner {
        owner.transfer(address(this).balance);
    }

    function transferOwnerShip(address _newOwner) external onlyOwner {
        owner = payable(_newOwner);
    }

    function getContractBalance() external view onlyOwner returns (uint256) {
        return address(this).balance;
    }

    receive() external payable {
        transactions.push(
            Transaction({
                sender: msg.sender,
                receiver: address(this),
                amount: msg.value,
                time: block.timestamp,
                transactionType: "received"
            })
        );
    }

    fallback() external payable {
        transactions.push(
            Transaction({
                sender: msg.sender,
                receiver: address(this),
                amount: msg.value,
                time: block.timestamp,
                transactionType: "received"
            })
        );
    }
}
