// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";

contract TokenMarketPlace is Ownable {
    struct BuyerAndSeller {
        uint256 buyer;
        uint256 seller;
        uint256 price;
    }
    using SafeERC20 for IERC20;
    using SafeMath for uint256;

    uint256 public tokenPrice = 2e16 wei; // 0.02 ether per GLD token
    uint256 public sellerCount = 1;
    uint256 public buyerCount = 1;
    BuyerAndSeller public buyersAndSellers = BuyerAndSeller(1, 1, 2e16 wei);
    IERC20 public gldToken;

    constructor(address _gldToken) Ownable(msg.sender) {
        gldToken = IERC20(_gldToken);
    }

    event TokenPriceUpdated(uint256 newPrice);
    event TokenBought(address indexed buyer, uint256 amount, uint256 totalCost);
    event TokenSold(
        address indexed seller,
        uint256 amount,
        uint256 totalEarned
    );
    event TokensWithdrawn(address indexed owner, uint256 amount);
    event EtherWithdrawn(address indexed owner, uint256 amount);
    event CalculateTokenPrice(uint256 priceToPay);

    // Updated logic for token price calculation with safeguards
    function adjustTokenPriceBasedOnDemand() public {
        uint256 marketDemandRatio = buyerCount.mul(1e18).div(sellerCount);
        uint256 smoothingFactor = 1e18;
        uint256 adjustedRatio = marketDemandRatio.add(smoothingFactor).div(2);
        uint256 newTokenPrice = tokenPrice.mul(adjustedRatio).div(1e18);
        uint256 minimumPrice = 2e16;
        if (newTokenPrice < minimumPrice) {
            tokenPrice = minimumPrice;
        }
        tokenPrice = newTokenPrice;
        emit TokenPriceUpdated(newTokenPrice);
    }

    function calculateTokenPrice(uint256 _amountOfToken)
        public
        returns (uint256)
    {
        if (_amountOfToken <= 0) revert();
        adjustTokenPriceBasedOnDemand();
        uint256 _amountToPay = _amountOfToken.mul(tokenPrice).div(1e18);
        emit CalculateTokenPrice(_amountToPay);
        return _amountToPay;
    }

    // Buy tokens from the marketplace
    /*
            we are purchasing token from this contract account
            we have the balance to purchase this token
            then amount should tranfer to this account
            after transferring we need to send token on buyer account
        */
    function buyGLDToken(uint256 _amountOfToken) public payable {
        if (_amountOfToken <= 0) revert();
        uint256 price = calculateTokenPrice(_amountOfToken);
        require(msg.value >= price, "insufficent funds");
        gldToken.safeTransfer(msg.sender, _amountOfToken);
        emit TokenBought(msg.sender, _amountOfToken, price);
        buyerCount++;
    }

    // Sell tokens back to the marketplace
    /*
        we need check user has token in their account
        calculate the token value
        then get token to contract address
        transfer value to seller
        */
    function sellGLDToken(uint256 amountOfToken) public {
        if (amountOfToken <= 0) revert();
        require(
            gldToken.balanceOf(msg.sender) >= amountOfToken,
            "insufficent token in accout"
        );
        uint256 pricePayToUser = calculateTokenPrice(amountOfToken);
        gldToken.safeTransferFrom(msg.sender, address(this), amountOfToken);
        (bool success, ) = payable(msg.sender).call{value: pricePayToUser}("");
        if (!success) revert();
        sellerCount++;
        emit TokenSold(msg.sender, amountOfToken, pricePayToUser);
    }

    // Owner can withdraw excess tokens from the contract
    /*
     need check contract has sufficent token that owner demand     
    */
    function withdrawTokens(uint256 amount) public onlyOwner {
        if (amount <= 0) revert();
        require(
            gldToken.balanceOf(address(this)) >= amount,
            "Insufficent token in contract address"
        );
        gldToken.safeTransfer(msg.sender, amount);
        emit TokensWithdrawn(msg.sender, amount);
    }

    // Owner can withdraw accumulated Ether from the contract
    function withdrawEther(uint256 amount) public onlyOwner {
        if (address(this).balance >= amount) revert();
        (bool success, ) = payable(msg.sender).call{value: amount}("");
        if (!success) revert();
        emit EtherWithdrawn(msg.sender, amount);
    }
}
