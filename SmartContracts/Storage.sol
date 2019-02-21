pragma solidity ^0.4.0;

import "./CMCEnabled.sol";
import "./ERC/ERC20Detailed.sol";
import "./Tools/SafeMath.sol";
import "./Job.sol";
import "./Tools/Ownable.sol";

contract Storage is CMCEnabled, ERC20Detailed, Ownable {

    mapping (address => uint256) private _balances;
    mapping (address => mapping (address => uint256)) private _allowed;
    //Publisher to job
    mapping (address => address[]) private publisherJobs;
    //Job to publisher
    mapping (address => address) private jobToPublisher;

    string public tokenName = "Unitarium";
    string public tokenSymbol = "UNIT";

    uint8 public tokenDecimals = 18;
    uint256 public _totalSupply = 1000000 * (10 ** uint256(tokenDecimals));

    address[] public newJobs;

    //Set this once rewards is deployed.
    address private rewardsAddress = 0X92323;

    using SafeMath for uint256;

    function totalSupply() isCMCEnabled("Storage") external view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address owner) isCMCEnabled("Storage") external view returns (uint256) {
        return _balances[owner];
    }

    function allowance(address owner, address spender) isCMCEnabled("Storage") external view returns (uint256) {
        return _allowed[owner][spender];
    }

    function transfer(address to, uint256 value) isCMCEnabled("Storage") external returns (bool) {
        require(value <= _balances[msg.sender]);
        require(to != address(0));
    
        _balances[msg.sender] = _balances[msg.sender].sub(value);
        _balances[to] = _balances[to].add(value);
        
        Transfer(msg.sender, to, value);
        return true;
    }

    function approve(address spender, uint256 value) isCMCEnabled("Storage") external returns (bool) {
        require(spender != address(0));
    
        _allowed[msg.sender][spender] = value;
        Approval(msg.sender, spender, value);
        return true;
    }

    function transferFrom(address from, address to, uint256 value) isCMCEnabled("Storage") external returns (bool) {
        require(value <= _balances[from]);
        require(value <= _allowed[from][msg.sender]);
        require(to != address(0));
    
        _balances[from] = _balances[from].sub(value);
        _balances[to] = _balances[to].add(value);
        
        _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
        Transfer(from, to, value);
        return true;
    }

    function mint(address account, uint256 amount) isCMCEnabled("Storage") external view returns (bool) {
        require(amount != 0);
        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        Transfer(address(0), account, amount);
        return true;
    }

    function addJob(address _job) isCMCEnabled("Storage") external returns (bool) {
        newJobs.push(_job);
        publisherJobs[msg.sender].push(_job);
        jobToPublisher[_job] = msg.sender;
        return true;
    }

    function getJobsFromPublisher(address _publisher) isCMCEnabled("Storage") external view returns (address[]) {
        return publisherJobs[_publisher];
    }

    function getPublisherFromJob(address _job) isCMCEnabled("Storage") external view returns (address) {
        return jobToPublisher[_job];
    }

    function getRewardsAddress() isCMCEnabled("Storage") external view returns (address) {
        return rewardsAddress;
    }
}