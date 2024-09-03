// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Payment {
    address owner;

    constructor(address recipientAddress) {
        owner = recipientAddress;
    }

    uint256 public paymentNo = 1;
    mapping(address => uint256) userDepositAmount;
    mapping(uint256 => mapping(address => uint256)) userPaymentList;
    mapping(uint256 => uint256) listOfPayment;
    mapping(address => uint256) spendAmount;
    event DepositedToPaymentWallet(address userAddress, uint256 paymentAmount);

    function deposit() public payable {
        if (msg.value <= 0) revert("Amount should be greater than zero");
        userDepositAmount[msg.sender] += msg.value;
        emit DepositedToPaymentWallet(msg.sender, msg.value);
    }

    function listPayment(uint256 amount) public {
        uint256 userMaxSpendingPower = userDepositAmount[msg.sender] -
            spendAmount[msg.sender];
        if (amount > userMaxSpendingPower)
            revert("You have not sufficent wei for spending");
        userPaymentList[paymentNo][msg.sender] = amount;
        spendAmount[msg.sender] += amount;
        listOfPayment[paymentNo] = amount;
        paymentNo++;
    }

    function closeChannel() public {}

    function checkBalance() public view returns (uint256) {
        return userDepositAmount[msg.sender];
    }

    function getAllPayments() public view returns (uint256[] memory) {
        uint256[] memory allPayments = new uint256[](paymentNo);
        for (uint256 i = 1; i == paymentNo; i++) {
            allPayments[i] = listOfPayment[i];
        }
        return allPayments;
    }
}

contract Payment2 {
    address public recipient;

    struct User {
        uint256 depositAmount;
        uint256 spentAmount;
        mapping(uint256 => uint256) paymentList;
    }

    mapping(address => User) public users;
    mapping(uint256 => uint256) public paymentAmounts;

    uint256 public paymentCount = 1;

    event DepositedToPaymentWallet(
        address indexed userAddress,
        uint256 paymentAmount
    );
    event PaymentListed(
        address indexed userAddress,
        uint256 indexed paymentId,
        uint256 amount
    );

    constructor(address recipientAddress) {
        recipient = recipientAddress;
    }

    function deposit() public payable {
        require(msg.value > 0, "Amount should be greater than zero");
        users[msg.sender].depositAmount += msg.value;
        emit DepositedToPaymentWallet(msg.sender, msg.value);
    }

    function listPayment(uint256 amount) public {
        User storage user = users[msg.sender];
        uint256 userMaxSpendingPower = user.depositAmount - user.spentAmount;
        require(
            amount <= userMaxSpendingPower,
            "Insufficient wei for spending"
        );

        user.paymentList[paymentCount] = amount;
        user.spentAmount += amount;
        paymentAmounts[paymentCount] = amount;

        emit PaymentListed(msg.sender, paymentCount, amount);
        paymentCount++;
    }

    function closeChannel() public {
        // Implement logic for closing the channel, if applicable
    }

    function checkBalance() public view returns (uint256) {
        return users[msg.sender].depositAmount;
    }

    function getAllPayments() public view returns (uint256[] memory) {
        uint256[] memory allPayments = new uint256[](paymentCount);
        for (uint256 i = 1; i < paymentCount; i++) {
            allPayments[i] = paymentAmounts[i];
        }
        return allPayments;
    }
}
