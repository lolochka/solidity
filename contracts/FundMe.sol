//SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;
import "./PriceConverter.sol";

contract FundMe {
    using PriceConverter for uint256;

    //to convert to usd without decimal
    //min amount of ETH is 10 / 1528
    uint256 public minUSD = 10 * 1e18;

    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;

    function fund() public payable{
        //1 eth in wei
        //value is comming in wei e18
        require (msg.value.getConversionRate() >= minUSD, "I need more money");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = msg.value;
    }
}