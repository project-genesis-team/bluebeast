
pragma solidity 0.5.0;

import "./CMCEnabled.sol";
import "./Storage.sol";


contract Controller is CMCEnabled {
    
    function setX(uint _x) external isCMCEnabled("UserEntry") {
        Storage(ContractProvider(CMC).contracts("Storage")).setX(_x);
    }

    function setBalance(address _address, uint256 _amount) external isCMCEnabled("UserEntry") {
        Storage(ContractProvider(CMC).contracts("Storage")).setBalance(_address, _amount);
    }

    function getBalance(address _address) external isCMCEnabled("UserEntry") {
        Storage(ContractProvider(CMC).contracts("Storage")).getBalance(_address);
    }
}