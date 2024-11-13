// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


//https://dapp-world.com/problem/team-wallet-easy/problem
contract TeamWallet {
    address owner;

    constructor() {
        owner = msg.sender;
    }

    struct Member {
        uint256 credits;
        address[] wallerAddress;
    }

    struct Transaction {
        uint256 txnNumber;
        uint256 amount;
        address senderAddress;
        uint256 approvalCount;
        uint256 rejectionCount;
        string status;
    }
    Transaction[] public transactins;
    uint256 transactionId = 0;
    Member public members;

    modifier isOwner() {
        require(msg.sender == owner, "Only Owner can perform this action");
        _;
    }

    modifier isSetWalletExecute() {
        require(members.wallerAddress.length == 0, "wallet has already setup");
        _;
    }

    //For setting up the wallet
    function setWallet(address[] memory member, uint256 credtis)
        public
        isOwner
        isSetWalletExecute
    {
        members.credits = credtis;
        members.wallerAddress = member;
    }

    //For spending amount from the wallet
    /*
            Requirement
            1 check the msg.sender is present in wallerAddress list
            2 the amount is not greater than the remaining credit
            3 one approval will be record as from behalf of msg.sender
            4 amount should be greate than 0
        */
    function spend(uint256 amount) public {
        require(amount > 0, "amount should be greater than 0");
        require(
            amount <= members.credits,
            "amount should not be greater than the remaining credit"
        );
        bool isValidWinnerAddress = false;
        for (uint256 i = 0; i < members.wallerAddress.length; i++) {
            if (msg.sender == members.wallerAddress[i]) {
                isValidWinnerAddress = true;
            }
        }
        Transaction({
            txnNumber: transactionId++,
            amount: amount,
            senderAddress: msg.sender,
            approvalCount: 1,
            rejectionCount: 0,
            status: "pending"
        });
    }

    //For approving a transaction request
    function approve(uint256 n) public {}

    //For rejecting a transaction request
    function reject(uint256 n) public {}

    //For checking remaing credits in the wallet
    function credits() public returns (uint256) {}

    //For checking nth transaction status
    function viewTransaction(uint256 n)
        public
        view
        returns (uint256 amount, string memory status)
    {}
}
