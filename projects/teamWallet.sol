// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

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
        uint256 amount;
        address senderAddress;
        uint256 approvalCount;
        uint256 rejectionCount;
        string status;
    }

    mapping(uint256 => Transaction) public transactions;

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

    modifier isValidWinnerAddress() {
        bool isValidWinner = false;
        for (uint256 i = 0; i < members.wallerAddress.length; i++) {
            if (msg.sender == members.wallerAddress[i]) {
                isValidWinner = true;
            }
        }
        require(
            isValidWinner,
            "you are not authorize for executing this function"
        );
        _;
    }

    //For spending amount from the wallet
    /*
            Requirement
            1 check the msg.sender is present in wallerAddress list
            2 the amount is not greater than the remaining credit
            3 one approval will be record as from behalf of msg.sender
            4 amount should be greate than 0
        */
    function spend(uint256 amount) public isValidWinnerAddress {
        require(amount > 0, "amount should be greater than 0");
        require(
            amount <= members.credits,
            "amount should not be greater than the remaining credit"
        );

        transactions[transactionId++] = Transaction({
            amount: amount,
            senderAddress: msg.sender,
            approvalCount: 1,
            rejectionCount: 0,
            status: "pending"
        });
    }

    /* 
    formula ---> totalmember * percentage/100
    step for approve function
    1 --> increase the approval count of member by 1
    2 --> check by formula if it's 70%  update to approve otherwise status will pending
 */
    // For approving a transaction request
    function approve(uint256 n) public isValidWinnerAddress {
        transactions[n].approvalCount += 1;
        uint256 requiredApprovals = (members.wallerAddress.length * 70 + 99) /
            100;
        if (transactions[n].approvalCount >= requiredApprovals) {
            transactions[n].status = "approved";
        } else {
            transactions[n].status = "pending";
        }
    }

    //For rejecting a transaction request
    function reject(uint256 n) public {
        transactions[n].rejectionCount += 1;
        // Calculate the 30% threshold for rejection
        uint256 requiredRejections = (members.wallerAddress.length * 30 + 99) /
            100;
        if (transactions[n].rejectionCount >= requiredRejections) {
            transactions[n].status = "reject";
        } else {
            transactions[n].status = "pending";
        }
    }

    //For checking remaing credits in the wallet
    function credits() public view returns (uint256) {
        return members.credits;
    }

    //For checking nth transaction status
    function viewTransaction(uint256 n)
        public
        view
        returns (uint256 amount, string memory status)
    {
        return (transactions[n].amount, transactions[n].status);
    }
}

@params https://dapp-world.com/problem/team-wallet-easy/problem