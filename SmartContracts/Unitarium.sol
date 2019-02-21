pragma solidity ^0.4.0;

import "./Controller.sol";
import "./CMCEnabled.sol";
import "./Job.sol";

contract Unitarium is CMCEnabled {

    event JobPublished(
        address customer,
        uint256 maxstake,
        address job
    );

    function Unitarium() public payable {
        mint(msg.sender, msg.value*100);
    }

    function totalSupply() public view returns (uint) {
        Controller(ContractProvider(CMC).contracts("Controller")).totalSupply();
    }

    function balanceOf(address owner) public view returns (uint256) {
        Controller(ContractProvider(CMC).contracts("Controller")).balanceOf(owner);
    }

    function allowance(address owner, address spender) public view returns (uint256) {
        Controller(ContractProvider(CMC).contracts("Controller")).allowance(owner, spender);
    }

    function transfer(address to, uint256 value) public returns (bool) {
        Controller(ContractProvider(CMC).contracts("Controller")).transfer(to, value);
    }

    function approve(address spender, uint256 value) public returns (bool) {
        Controller(ContractProvider(CMC).contracts("Controller")).approve(spender, value);
    }

    function transferFrom(address from, address to, uint256 value) public returns (bool) {
        Controller(ContractProvider(CMC).contracts("Controller")).transferFrom(from, to, value);
    }

    function mint(address account, uint256 amount) public view returns (bool) {
        Controller(ContractProvider(CMC).contracts("Controller")).mint(account, amount);
    }

    //Send in unitarium address to job contract and call functionality from there.
    function addJob(string _ipfs, uint _min, uint _max, uint _stake, uint _bidexp, uint _workexp, string _proto) public returns (bool) {
        require(_max >= _min);
        require(_workexp >= _bidexp);
        if (transfer(getRewardsAddress(), _stake)) {
            Job job = new Job(_ipfs, _proto, _min, _max, _stake, _bidexp, _workexp, address(this), getRewardsAddress());
            
            JobPublished(msg.sender, _stake, job);
            Controller(ContractProvider(CMC).contracts("Controller")).addJob(address(job));
            return true;
        }
        return false;

        //Controller(ContractProvider(CMC).contracts("Controller")).addJob(_ipfs, _min, _max, _stake, _bidexp, _workexp, _proto);

    }

    
    function getJobsFromPublisher(address _publisher) public view returns (address[]) {
        Controller(ContractProvider(CMC).contracts("Controller")).getJobsFromPublisher(_publisher);
    }

    function getPublisherFromJob(address _job) public view returns (address) {
        Controller(ContractProvider(CMC).contracts("Controller")).getPublisherFromJob(_job);
    }

    function placeBid(address _job, uint256 _amount, string[] _allowedProtocols) public {
        require(balanceOf(msg.sender) >= _amount);
        require(_job.call(bytes4(keccak256("placeBid(uint256, string[])")), _amount, _allowedProtocols));
    }

    function getRewardsAddress() public view returns (address) {
        Controller(ContractProvider(CMC).contracts("Controller")).getRewardsAddress();
    }
}