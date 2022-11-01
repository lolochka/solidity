//SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

import "./Storage.sol";

//inheritance
contract ExtraStorage is Storage {
    function store(uint256 _favoriteNumber) public override {
        favoriteNumber = _favoriteNumber;
    }

    //virtual -> override
    function storeIncremented(uint256 _favoriteNumber, uint256 _increment) public {
        uint256 n = _favoriteNumber * _increment;
        store(n);
    }
}