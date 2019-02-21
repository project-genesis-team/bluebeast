pragma solidity ^0.4.0;

import "./IERC20.sol";

contract ERC20Detailed is IERC20 {

    string private  _name;
    string private _symbol;

    uint8 private _decimals;

    function ERC20Detailed(string name, string symbol, uint8 decimals) public {
        _name = name;
        _symbol = symbol;
        _decimals = decimals;
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns(string memory) {
        return _symbol;
    }

    function decimals() public view returns(uint8) {
        return _decimals;
    }
}