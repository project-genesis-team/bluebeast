
pragma solidity 0.5.0;

import "./CMCEnabled.sol";


contract Storage is CMCEnabled {

    mapping (address => uint256) private _balances;
    mapping (address => mapping (address => uint256)) private _allowed;

    uint256 private _totalSupply;

    function getBalance(address _address) external isCMCEnabled("Storage") returns (uint256) {
        return _balances[_address];
    }

    function setBalance(address _address, uint256 _amount) external isCMCEnabled("Storage") {
        _balances[_address] = _amount;
    }

    uint public x;

    function setX(uint _x) external isCMCEnabled("Storage") {
        x = _x;
    }
}