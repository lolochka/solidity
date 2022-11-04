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
    address public owner;

    constructor() {
        //address who deployed this contract
        owner = msg.sender;
    }

    function fund() public payable{
        //1 eth in wei
        //value is comming in wei e18
        require (msg.value.getConversionRate() >= minUSD, "I need more money");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = msg.value;
    }

    //Decorator
    modifier onlyOwner {
        //Check the owner of the contract
        require(msg.sender == owner, "Sender is not owner. You are not allowed to do this");
        _; ///where to run fmodified function code
    }

    function withdraw() public onlyOwner{
        /* starting index, ending index, step count */
        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }

        //reset the array
        funders = new address[](0);

        // //transfer
        // payable(msg.sender).transfer(address(this).balance);

        // //send
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send failed");

        //call
        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");        
        require(callSuccess, "Call failed");
    }
}