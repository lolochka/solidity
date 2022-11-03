//SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract FundMe {
    //to convert to usd without decimal
    //min amount of ETH is 10 / 1528
    uint256 public minUSD = 10 * 1e18;
    AggregatorV3Interface internal priceFeed;

    /**
     * Network: Goerli
     * Aggregator: ETH/USD
     * Address: 0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e
     */
    constructor() {
        priceFeed = AggregatorV3Interface(0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e);
    }

    function getPrice() public view returns(uint256) {
        //ABI
        (,int256 price,,,) = priceFeed.latestRoundData();
        //price 1 ETH = 152802385344 // 1 528.02385344 USD (1e8)
        return uint256(price * 1e10);    
    }

    function getConversionRate(uint256 ethAmount) public view returns(uint256) {
        uint256 ethPrice = getPrice();
        // 1528_e18
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;
    }

    function fund() public payable{
        //1 eth in wei
        //value is comming in wei e18
        require (getConversionRate(msg.value) >= minUSD, "I need more money"); 
    }
}