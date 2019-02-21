pragma solidity ^0.4.0;

import "./Unitarium.sol";
import "./Storage.sol";
import "./Tools/SafeMath.sol";

contract Job {

    address public unitariumAddress;
    address public rewardsAddress;
    address public publisher;
    address[] public workers;

    bool public applicable;

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

    function placeBid(uint _amount, string[] _allowedProtocols) external {
        require(applicable);
        bool protocolAllowed;

        for (uint i = 0; i < _allowedProtocols.length; i++) {
            if (keccak256(protocol) == keccak256(_allowedProtocols[i])) {
                protocolAllowed = true;
            }
        }
        
        if (protocolAllowed) {
            Bid memory bid = Bid(msg.sender, _amount);
            bids.push(bid);
            initialBid[msg.sender] = _amount;
            BidPushed(this, _amount);
        } else {
            InvalidProtocol(this, protocol, _allowedProtocols);
        }
    }

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
        publishHashToWinners(winners);
    }

    function publishHashToWinners(Bid[] _winners) public {
        for (uint j = 0; j < _winners.length; j++) {
            AnnounceWorker(_winners[j].bidder, _winners[j].amount, ipfsHash, protocol, this);
        }
    }

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

    function publishResult(bytes32 _result) public checkAuthorized() {
        Result memory res = Result(msg.sender, _result);
        results.push(res);
    }
            //TODO:Compare elements in result and find is the most common element is more than 51%.
            //assign all owners of elements that's majority to an array and send it to payout.
    function consensus() internal {
        if ((block.number >= workExpirationBlock && results.length >= minimumNodes) || 
        results.length >= maximumNodes-1) {

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
                payout(toPay);
            } else {
                NoConsensus(results);
                revert();
            }
        } else {
            revert();
        }
    }

    function payout(address[] _toReward) internal {
        require(unitariumAddress.call(bytes4(keccak256("allowance(address, address")), rewardsAddress, this));
        require(unitariumAddress.call(bytes4(keccak256("approve(address, address")), rewardsAddress, maximumStake));
        for (uint i = 0; i < _toReward.length; i++) {
            require(unitariumAddress.call(bytes4(keccak256("transferFrom(address, address, uint256")), _toReward[i], initialBid[_toReward[i]]));
        }
    }

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