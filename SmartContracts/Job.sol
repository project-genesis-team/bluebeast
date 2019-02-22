pragma solidity ^0.4.0;

import "./Unitarium.sol";
import "./Storage.sol";
import "./Tools/SafeMath.sol";

/**
* @dev Job is a unique contract that instantiate with specialized parameters depending on the publisher.
* @dev TODO: Somewhere a nested array is used which solidity don't allow, find a workaround to it.
**/
contract Job {

    address public unitariumAddress;
    address public rewardsAddress;
    address public publisher;
    address[] public workers;

    bool public applicable;
    bool public consensus;

    string public ipfsHash;
    string public protocol;

    uint public minimumNodes;
    uint public maximumNodes;
    uint public maximumStake;
    uint public biddingExpirationBlock;
    uint public workExpirationBlock;
    uint public acceptedBidSum;

    Bid[] public bids;
    Bid[] private winners;
    Result[] private results;

    mapping(address => uint) public initialBid;
    mapping(address => uint) public straightBid;

    mapping(bytes32 => uint256) public consensusResults;

    address[] public toPay;

    using SafeMath for uint256;

    struct Bid {
        address bidder;
        uint amount;
    }

    struct Result {
        address worker;
        bytes32 result;
    }

    event AnnounceWorker(
        address worker,
        uint256 bid,
        string ipfs,
        string proto,
        address job
    );

    event BidPushed(
        address bidder,
        uint256 amount
    );

    event InvalidProtocol(
        address job,
        string proto,
        string[] allowed  
    );

    event NoConsensus(
        Result[] allresults
    );

    function Job(string _hash, string _proto, uint _minNodes, uint _maxNodes, uint _maxStake, uint _bidExp, uint _workExp, address _unitarium, address _rewards) public {
        publisher = msg.sender;
        workers = [0];
        applicable = true;
        consensus = false;
        ipfsHash = _hash;
        protocol = _proto;
        minimumNodes = _minNodes;
        maximumNodes = _maxNodes;
        maximumStake = _maxStake;
        biddingExpirationBlock = _bidExp;
        workExpirationBlock = _workExp;
        acceptedBidSum = 0;
        unitariumAddress = _unitarium;
        rewardsAddress = _rewards;
    }

    /**
     * @dev Called from unitarium and check if protocol is allowed for the worker, if so pushes bid.
     * @param amount of UNITs bid for the job.
     * @param allowedProtocols array of allowed protocols.
     **/
    function placeBid(uint amount, string[] allowedProtocols) external {
        require(applicable);
        bool protocolAllowed;

        for (uint i = 0; i < allowedProtocols.length; i++) {
            if (keccak256(protocol) == keccak256(allowedProtocols[i])) {
                protocolAllowed = true;
            }
        }
        
        if (protocolAllowed) {
            Bid memory bid = Bid(msg.sender, amount);
            bids.push(bid);
            initialBid[msg.sender] = amount;
            BidPushed(this, amount);
        } else {
            InvalidProtocol(this, protocol, allowedProtocols);
        }
    }

    /**
     * @dev Check for highest bids 
     * @dev TODO: Make this function callable each block to run automatically.
     **/
    function announceWinners() public {
        require(msg.sender == publisher);
        require(block.number >= biddingExpirationBlock);
        require(block.number <= workExpirationBlock);
        require(bids.length >= minimumNodes);
        
        applicable = false;
        Bid[] memory sortedBids = sortBidArray(bids);

        for (uint i = 0; i <= sortedBids.length; i++) {
            require(maximumStake >= acceptedBidSum);
            acceptedBidSum += sortedBids[i].amount;
            winners.push(sortedBids[i]);
        }
        _publishHashToWinners(winners);
    }

    /**
     * @dev Announces IPFS-hash and other info to winning bids. 
     * @param winners an array of winning bids.
     * @dev TODO: Maybe make this callable by workers instead in order to keep ipfsHash hidden?
     **/
    function _publishHashToWinners(Bid[] _winners) internal {
        for (uint j = 0; j < _winners.length; j++) {
            AnnounceWorker(_winners[j].bidder, winners[j].amount, ipfsHash, protocol, this);
        }
    }

    /**
     * @dev Loop through winning bids and check if msg.sender is among them.
     **/
    function isAuthorized() public returns (bool) {
        for (uint i = 0; i < winners.length; i++) {
            if (msg.sender == winners[i].bidder) {
                return true;
            }
        }
        return false;
    }

    modifier checkAuthorized() {
        require(isAuthorized());
        _;
    }

    /**
     * @dev Check that the publisher is Authorized and uploads result if consensus hasen't been reached.
     * @param result The computed IPFS result.
     **/
    function publishResult(bytes32 _result) public checkAuthorized() {
        require(!consensus);
        Result memory res = Result(msg.sender, _result);
        results.push(res);
        _checkConsensus();
    }
    
    /**
     * @dev Checks if conditions for consensus apply and if so check if the most common result is 51% or more. If so, runs payout.
     **/
    function _checkConsensus() internal {
        if ((block.number >= workExpirationBlock && results.length >= minimumNodes) || 
        results.length >= maximumNodes-1) {

            consensus = true;

            bytes32 highestResult;

            for (uint i = 1; i < results.length; i++) {
                consensusResults[results[i].result] += 1;
                if (consensusResults[results[i].result] > consensusResults[highestResult]) {
                    highestResult = results[i].result;
                }
            }

            //If 51%
            if (consensusResults[highestResult] > results.length.div(2)) {
                for (uint j = 0; j < results.length; j++) {
                    if (keccak256(results[j].result) == keccak256(highestResult)) {
                        toPay.push(results[j].worker);
                    }
                }
                _payout(toPay);
            } else {
                NoConsensus(results);
            }
        }
    }

   /**
     * @dev Approves rewardContract to pay out rewards then execute the payouts through Unitarium.
     * @param toReward Array of addresses to payout rewards to.
     **/
    function _payout(address[] toReward) internal {
        require(unitariumAddress.call(bytes4(keccak256("allowance(address, address")), rewardsAddress, this));
        require(unitariumAddress.call(bytes4(keccak256("approve(address, address")), rewardsAddress, maximumStake));
        for (uint i = 0; i < toReward.length; i++) {
            require(unitariumAddress.call(bytes4(keccak256("transferFrom(address, address, uint256")), toReward[i], initialBid[toReward[i]]));
        }
    }

   /**
     * @dev Sort an array of bids from highest to lowest.
     * @param arr Array of Bids
     **/
    function sortBidArray(Bid[] memory arr) private pure returns (Bid[]) {
        uint256 len = arr.length;
        for (uint i = 0; i < len; i++) {
            for (uint j = i+1; j < len; j++) {
                if (arr[i].amount > arr[j].amount) {
                    Bid memory temp = arr[i];
                    arr[i] = arr[j];
                    arr[j] = temp;
                }
            }
        }
        return arr;
    }
}