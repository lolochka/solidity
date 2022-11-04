//SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;
import "./PriceConverter.sol";

error NotOwner();

contract FundMe {
    using PriceConverter for uint256;

    //to convert to usd without decimal
    //min amount of ETH is 10 / 1528
    //constant variable is not allocate place in memory
    uint256 public constant MINIMUM_USD = 10 * 1e18;
    //21.415 gas - constant
    //23,515 gas - non-constant

    address public immutable i_owner;

    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;

    constructor() {
        //address who deployed this contract
        i_owner = msg.sender;
    }

    function fund() public payable{
        //1 eth in wei
        //value is comming in wei e18
        require (msg.value.getConversionRate() >= MINIMUM_USD, "I need more money");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }

    //Decorator
    modifier onlyOwner {
        //Check the owner of the contract
        //require(msg.sender == i_owner, "Sender is not owner. You are not allowed to do this");
        
        /*we can also use error instance to show user indtead allocate
        memrory with string*/
        if(msg.sender == i_owner) { revert NotOwner(); }
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

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }
}