//SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;
//import "./Storage.sol" as Storage;

import "./Storage.sol";

contract StorageFactory {
    Storage[] public simpleStorageArray;

    function createSimpleStorage() public {
        simpleStorageArray.push(new Storage());
    }

    //storage factory store
    function sfStore(uint256 _storageIndex, uint256 _storageNumber) public {
        //Address
        //ABI - Application Binary Interface
        Storage st = simpleStorageArray[_storageIndex];
        st.store(_storageNumber);
    }

    function sfGet(uint256 _storageIndex) public view returns(uint256) {
        Storage st = simpleStorageArray[_storageIndex];
        return st.retrieve();
    }
}
