pragma solidity 0.5.0;

import "./ERC/ERC20Detailed.sol";
import "./Tools/Ownable.sol";


contract Unitarium is ERC20Detailed, Ownable {

    string public constant TOKEN_NAME = "Unitarium";
    string public constant TOKEN_SYMBOL = "UNIT";
    uint8 public constant TOKEN_DECIMALS = 18;

    uint256 public constant TOTAL_SUPPLY = 1000000 * (10 ** uint256(tokenDecimals));

    using SafeMath for uint256;

    mapping (address => uint256) private _balances;
    mapping (address => mapping (address => uint256)) private _allowed;

    uint256 private _totalSupply;

    constructor() public payable
    ERC20Detailed(TOKEN_NAME, TOKEN_SYMBOL, TOKEN_DECIMALS);
    Ownable() {
    _mint(owner(), TOTAL_SUPPLY);
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address owner) public view returns (uint256) {
        return _balances[owner];
    }


    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowed[owner][spender];
    }

    function transfer(address to, uint256 value) public returns (bool) {
        require(value <= _balances[msg.sender]);
        require(to != address(0));
    
        _balances[msg.sender] = _balances[msg.sender].sub(value);
        _balances[to] = _balances[to].add(value);
        
        emit Transfer(msg.sender, to, value);
        return true;
    }

    function approve(address spender, uint256 value) public returns (bool) {
        require(spender != address(0));
    
        _allowed[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function transferFrom(address from, address to, uint256 value) public returns (bool) {
    require(value <= _balances[from]);
    require(value <= _allowed[from][msg.sender]);
    require(to != address(0));
    
      _balances[from] = _balances[from].sub(value);
      _balances[to] = _balances[to].add(value);
        
      _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
      emit Transfer(from, to, value);
      return true;
    }

    function _mint(address account, uint256 amount) internal {
        require(amount != 0);
        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }
}

/*

contract Jobhandler {

    mapping(address=>User)Users;
    
struct Job {
    string ipfshash;
    uint minNodes;
    uint maxNodes;
    uint maxStake;
    string publisher;
    string protocol;
}

struct User {
    Job[] jobs;
    uint balance;
    
}

Users users;
function AddJob() public {
    HiddenAuction();
}
    
function HiddenAuction() internal {
        
}
    
function NewContract() internal {
        
}
    
}
*/

















