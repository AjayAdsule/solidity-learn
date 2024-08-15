// SPDX-License-Identifier: MIT
pragma solidity >=0.8.20;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "hardhat/console.sol";


//buyerCount = 5
//sellerCount = 1
//markedDemand ratio =
//buyerCount.mul(1e18).div(sellerCount) = 5*10^18 /1 = 5*10^18
//adjustedRatio = (5*10^18 + 1*10^18)/2 = (6 * 10^18)/2 = 3 * 10^18
// newTokenPrice = //(2 * 10^16 * 3 * 10^18) / 10^18 = (6 * 10^34)/10^18 = 6*10^16 wei = 0.06 ether

contract MyContract {
    uint256 public tokenPrice = 2e16 wei;
    using SafeMath for uint256;

    function tokenPriceCalulator(uint256 buyerCount, uint256 sellerCount)
        public
        returns (uint256)
    {
        // Calculate the market demand ratio with a smoothing factor to prevent drastic changes
        uint256 marketDemandRatio = buyerCount.mul(1e18).div(sellerCount);
        console.log("marketDemandRatio", marketDemandRatio);

        // Introduce a smoothing factor to avoid abrupt changes
        uint256 smoothingFactor = 1e18; // Can be adjusted based on the desired sensitivity
        uint256 adjustedRatio = marketDemandRatio.add(smoothingFactor).div(2);
        console.log("adjustedRatio", adjustedRatio);

        // Adjust the token price based on the adjusted market demand ratio
        uint256 newTokenPrice = tokenPrice.mul(adjustedRatio).div(1e18);
        console.log("newTokenPrice", newTokenPrice);

        // Set a minimum price to prevent it from dropping too low
        uint256 minimumPrice = 1e15; // 0.001 ether as minimum price
        if (newTokenPrice < minimumPrice) {
            newTokenPrice = minimumPrice;
        }

        tokenPrice = newTokenPrice;
        console.log("tokenPrice", tokenPrice);
        return tokenPrice;
    }
}
