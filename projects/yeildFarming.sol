// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract YieldFarming is ERC20 {
    address public owner;

    constructor(uint256 _initialSupply) ERC20("INDCOIN", "INDC") {
        _mint(msg.sender, _initialSupply);
        owner = msg.sender;
    }

    struct Pool {
        uint256 maxAmount;
        uint256 yieldPercent;
        uint256 minDeposit;
        uint256 rewardTime;
        bool isExists;
    }

    struct Deposit {
        uint256 totalDeposit;
        uint256 depositeTime;
        uint256 reward;
        address userAddress;
    }

    uint256 public poolNum = 0;
    mapping(uint256 => Pool) public poolList;
    mapping(address => Deposit) public userDeposit;
    mapping(uint256 => mapping(address => Deposit)) public depositRecords;
    modifier isOwner() {
        require(msg.sender == owner, "You are not authorized to create pool");
        _;
    }

    modifier isPoolExist(uint256 _poolId) {
        require(poolList[_poolId].isExists, "Please provide valid pool id");
        _;
    }

    function addPool(
        uint256 maxAmount,
        uint256 yieldPercent,
        uint256 minDeposit,
        uint256 rewardTime
    ) public isOwner {
        poolList[poolNum] = Pool({
            maxAmount: maxAmount,
            yieldPercent: yieldPercent,
            minDeposit: minDeposit,
            rewardTime: rewardTime,
            isExists: true
        });
        poolNum++;
    }

    function depositWei(uint256 poolId) public payable isPoolExist(poolId) {
        // check the amount is not smaller than pool minDeposit and user can invest only one time

        if (depositRecords[poolId][msg.sender].userAddress == msg.sender) {
            revert("Already deposit in this pool");
        }

        if (msg.value < poolList[poolId].minDeposit) {
            revert("minimum value required");
        }
        depositRecords[poolId][msg.sender] = Deposit({
            totalDeposit: msg.value,
            depositeTime: block.timestamp,
            reward: 0,
            userAddress: msg.sender
        });
    }

    function withdrawWei(uint256 poolId, uint256 amount) public {
        //if user claim all money the reward will 0 check user has valid amount to withdraw the fund
        uint256 investedAmount = depositRecords[poolId][msg.sender]
            .totalDeposit;
        if (investedAmount > amount) {
            revert("You have insufficent fund to withdraw");
        }
        if (investedAmount == amount) {
            depositRecords[poolId][msg.sender].reward = 0;
        }
        payable(msg.sender).transfer(amount);
    }

    function calculateClaimReward(uint256 _poolId)
        internal
        view
        returns (uint256 reward)
    {
        Deposit memory getUserDeposit = depositRecords[_poolId][msg.sender];
        Pool memory poolDetails = poolList[_poolId];
        uint256 heildTime = getUserDeposit.depositeTime - block.timestamp;

        uint256 numberOfPeriods = heildTime / poolDetails.rewardTime;
        uint256 totalYeild = numberOfPeriods * poolDetails.yieldPercent;

        return totalYeild * getUserDeposit.totalDeposit;
    }

    function claimRewards(uint256 poolId) public {
        uint256 reward = calculateClaimReward(poolId);
        if (reward == 0) {
            revert("reward is 0 ");
        }
        depositRecords[poolId][msg.sender].reward = reward;
        transfer(msg.sender, reward);
    }

    function checkPoolDetails(uint256 poolId)
        public
        view
        returns (
            uint256,
            uint256,
            uint256,
            uint256
        )
    {
        Pool memory pool = poolList[poolId];
        return (
            pool.maxAmount,
            pool.yieldPercent,
            pool.minDeposit,
            pool.rewardTime
        );
    }

    function checkUserDeposits(address user)
        public
        view
        returns (uint256, uint256)
    {}

    function checkUserDepositInPool(uint256 poolId)
        public
        view
        returns (address[] memory, uint256[] memory)
    {}

    function checkClaimableRewards(uint256 poolId)
        public
        view
        returns (uint256)
    {}

    function checkRemainingCapacity(uint256 poolId)
        public
        view
        returns (uint256)
    {}

    function checkWhaleWallets() public view returns (address[] memory) {}
}
