// SPDX-License-Identifier: MIT
pragma solidity >=0.8.20;

contract learnModifier {
    int32 public accountBalance = 100;

    modifier isValidWithdrawal(int32 _withdrawalAmt) {
        require(
            accountBalance > _withdrawalAmt,
            "account balance is not sufficent to withdraw amount"
        );
        _;
    }

    function withdraw(int32 _withdrawAmt)
        public
        isValidWithdrawal(_withdrawAmt)
        returns (string memory)
    {
        accountBalance -= _withdrawAmt;
        return "amount is successfully withdraw";
    }
}

contract PreRequiste {
    int256 public ethBalance = 10;

    modifier ethBalanceChecker() {
        if (ethBalance > 5) {
            _;
        } else {
            revert("Eth balance is not sufficient");
        }
    }

    function f1() public ethBalanceChecker returns (string memory) {
        ethBalance -= 1;
        return "success";
    }
}
