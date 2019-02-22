pragma solidity ^0.4.0;

import "./CMCEnabled.sol";
import "./ERC/ERC20Detailed.sol";
import "./Tools/SafeMath.sol";
import "./Job.sol";
import "./Tools/Ownable.sol";

/**
* @dev Storage gets called by controller to update & store data. Logic that directly affect state can also execute here.
**/
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

    /**
     * @dev Total number of tokens in existence
     */
    function totalSupply() isCMCEnabled("Storage") external view returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev Gets the balance of the specified address.
     * @param owner The address to query the balance of.
     * @return An uint256 representing the amount owned by the passed address.
     */
    function balanceOf(address owner) isCMCEnabled("Storage") external view returns (uint256) {
        return _balances[owner];
    }

   /**
     * @dev Function to check the amount of tokens that an owner allowed to a spender.
     * @param owner address The address which owns the funds.
     * @param spender address The address which will spend the funds.
     * @return A uint256 specifying the amount of tokens still available for the spender.
     */
    function allowance(address owner, address spender) isCMCEnabled("Storage") external view returns (uint256) {
        return _allowed[owner][spender];
    }

    /**
     * @dev Transfer token for a specified address
     * @param to The address to transfer to.
     * @param value The amount to be transferred.
     */
    function transfer(address to, uint256 value) isCMCEnabled("Storage") external returns (bool) {
        _transfer(msg.sender, to, value);
        return true;
    }

    /**
     * @dev Transfer token for a specified addresses
     * @param from The address to transfer from.
     * @param to The address to transfer to.
     * @param value The amount to be transferred.
     */
    function _transfer(address from, address to, uint256 value) internal {
        require(value <= _balances[from]);
        require(to != address(0));
    
        _balances[from] = _balances[from].sub(value);
        _balances[to] = _balances[to].add(value);
        
        Transfer(msg.sender, to, value);
    }

    /**
     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
     * Beware that changing an allowance with this method brings the risk that someone may use both the old
     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     * @param spender The address which will spend the funds.
     * @param value The amount of tokens to be spent.
     */
    function approve(address spender, uint256 value) isCMCEnabled("Storage") external returns (bool) {
        require(spender != address(0));
    
        _allowed[msg.sender][spender] = value;
        Approval(msg.sender, spender, value);
        return true;
    }

    /**
     * @dev Transfer tokens from one address to another.
     * Note that while this function emits an Approval event, this is not required as per the specification,
     * and other compliant implementations may not emit the event.
     * @param from address The address which you want to send tokens from
     * @param to address The address which you want to transfer to
     * @param value uint256 the amount of tokens to be transferred
     */
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

    /**
     * @dev Mint tokens for a specified address
     * @param account The address to mint to.
     * @param amount The amount to be minted.
     */
    function mint(address account, uint256 amount) isCMCEnabled("Storage") external view returns (bool) {
        require(amount != 0);
        _mint(account, amount);
        return true;
    }

    /**
     * @dev Internal function that mints an amount of the token and assigns it to
     * an account. This encapsulates the modification of balances such that the
     * proper events are emitted.
     * @param account The account that will receive the created tokens.
     * @param amount The amount that will be created.
     */
    function _mint(address account, uint256 amount) internal returns (bool) {
        require(amount != 0);
        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        Transfer(address(0), account, amount);
    }

    /**
     * @dev Adds job address to newJobs array and publisher mapping. Also assigns the sender as publisher of the job.
     * @param job The address of the job to be added.
     */
    function addJob(address job) isCMCEnabled("Storage") external returns (bool) {
        newJobs.push(job);
        publisherJobs[msg.sender].push(job);
        jobToPublisher[job] = msg.sender;
        return true;
    }

    /**
     * @dev Retrieves all jobs the publisher has published.
     * @param publisher The address where the publisher.
     */
    function getJobsFromPublisher(address publisher) isCMCEnabled("Storage") external view returns (address[]) {
        return publisherJobs[publisher];
    }

    /**
     * @dev Retrieves the publisher of a job by specifying the job contract address.
     * @param job The address where the job contract is deployed.
     */
    function getPublisherFromJob(address job) isCMCEnabled("Storage") external view returns (address) {
        return jobToPublisher[job];
    }

    /**
     * @dev Externally accessible reward address.
     */
    function getRewardsAddress() isCMCEnabled("Storage") external view returns (address) {
        return rewardsAddress;
    }
}