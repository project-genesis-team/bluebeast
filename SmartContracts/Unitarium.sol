pragma solidity ^0.4.0;

import "./Controller.sol";
import "./CMCEnabled.sol";
import "./Job.sol";

/**
* @dev Unitarium handles all logic except for storage allocation which is assigned to Storage through the Controller.
**/
contract Unitarium is CMCEnabled {

    event JobPublished(
        address customer,
        uint256 maxstake,
        address job
    );
   /**
     * @dev Unitarium mints 100 UNITs for every 1 ETH that's sent to it..
     */
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

   /**
     * @dev Called by customers requesting a job. Parameter data is packaged into a job struct then assigned to Storage.
     * @param ipfs Hash-address of the files stored on IPFS.
     * @param min Minimum amount of users they want to form a consensus. Lower numbers equal lower credibility.
     * @param max Maximum amount of users they want to form a consensus. Higher numbers equal higher costs.
     * @param stake Stake in UNITs that the publisher is willing to pay for the job.
     * @param bidexp Expiration block for when the bidding should been finalized.
     * @param workexp Expiration block for when the consensus should been reached.
     * @param proto The protocol to which the job belongs. Marked 'none' is unspecified.
     * @return a boolean stating whether the job was successfully added.
     */
    function addJob(string ipfs, uint min, uint max, uint stake, uint bidexp, uint workexp, string proto) public returns (bool) {
        require(max >= min);
        require(workexp >= bidexp);
        if (transfer(getRewardsAddress(), stake)) {
            Job job = new Job(ipfs, proto, min, max, stake, bidexp, workexp, address(this), getRewardsAddress());
            
            JobPublished(msg.sender, stake, job);
            Controller(ContractProvider(CMC).contracts("Controller")).addJob(address(job));
            return true;
        }
        return false;
    }

    
    function getJobsFromPublisher(address _publisher) public view returns (address[]) {
        Controller(ContractProvider(CMC).contracts("Controller")).getJobsFromPublisher(_publisher);
    }

    function getPublisherFromJob(address _job) public view returns (address) {
        Controller(ContractProvider(CMC).contracts("Controller")).getPublisherFromJob(_job);
    }

   /**
     * @dev Places a bids on a job contract address if protocol is allowed and balance is enough.
     * @param job Contract address of the job.
     * @param amount Bidded amount of UNITs.
     * @param allowedProtocols An array of all protocols the worker allow to process.
     **/
    function placeBid(address job, uint256 amount, string[] allowedProtocols) public {
        require(balanceOf(msg.sender) >= amount);
        require(job.call(bytes4(keccak256("placeBid(uint256, string[])")), amount, allowedProtocols));
    }

    function getRewardsAddress() public view returns (address) {
        Controller(ContractProvider(CMC).contracts("Controller")).getRewardsAddress();
    }
}