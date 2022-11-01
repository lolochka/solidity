// SPDX-License-Identifier: MIT 
pragma solidity 0.8.8; //Version of solidity to use

//EVM, Ethereum virtual machine
//EVM compatible networks: Avalanche, Fantom, Polygon

contract Storage {
    uint256 favoriteNumber; //default is 0

    struct People {
        uint256 favoriteNumber;
        string name;
    }

    mapping(string => uint256) public nameToFavoriteNumber;

    People[] public people;

    function store(uint256 _favoriteNumber) public virtual {
        favoriteNumber = _favoriteNumber;
    }

    function retrieve() public view returns(uint256) {
        return favoriteNumber;
    }

    function addPerson(string memory _name, uint256 _favoriteNumber) public{
        people.push(People(_favoriteNumber,_name));//you can add parameters in brakets on in the order in what them shown
        nameToFavoriteNumber[_name] = _favoriteNumber;
    }
}