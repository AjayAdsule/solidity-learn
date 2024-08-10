// SPDX-License-Identifier: MIT
pragma solidity >=0.8.20;

contract learningRequire {
    uint8 public num = 0;

    function updateTransaction(uint8 amt) public {
        num = 100;
        require(amt > 5, "Amount is below minimum transaction amount");
        num = amt;
    }

    function updateTransactionWithouError(uint8 a)
        public
        returns (string memory)
    {
        if (a > 5) {
            num = a;
            return "Transaction is fullfilled";
        } else {
            revert("Error is handled in else block");
        }
    }

    // modifier

    modifier firstModifier() {
        require(false == true, "the statement is false");
        _;
    }

    function usingModifier() public pure firstModifier returns (int256) {
        return 1;
    }
}

contract PracticeRequire {
    int256 public counter;
    int256 public counter1;

    function updateCounter(int256 amt) public {
        counter = amt;
    }

    function isValidCounter(int256 nums) public {
        counter1 = nums;
        require(nums > counter, "num is smaller than counter");
        counter = nums + 10;
    }
}

contract Reverts {
    int256 public counter;

    function updateCounter(int256 num) public {
        counter = 10;
        if (num > 5) {
            counter = num;
        } else {
            revert("error in if condition");
        }
    }
}

contract Asserts {
    int256 public counter;

    function updateCounter(int256 a) public {
        counter = a;
        assert(a >= 5);
    }
}
