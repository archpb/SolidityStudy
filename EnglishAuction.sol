// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

interface IERC721 {
    function transferFrom(address _from, address _to, uint256 _tokenId) external;
}

contract EnglishAuction {
    // Event definitions
    event Start();
    event Bid(address indexed sender, uint amount);
    event Withdraw(address indexed bidder, uint amount);
    event End(address highestBidder, uint highestBid);

    // status var
    address payable  internal  seller;
    address internal  highestBidder;
    uint public immutable startingPrice;
    uint public highestPrice;   // in weis
    uint public startAt;  // in seconds
    uint public immutable duration;
    uint public endAt;

    IERC721 public immutable nft;
    uint immutable internal nftId;

    //auction status
    bool internal isStart;  // aution is wether started
    bool internal isClosed;   // aution is wether closed
    
    mapping (address => uint) bids; // address: bidder address, uint: total amount eth the bidder sent 

    constructor (
        uint _startPrice,
        uint _duration,
        address _nftAddr,
        uint _nftId)
    {
        require(_duration <= 1 days, "dration should <= 1 day");
        require(_nftAddr !=address(0), "nft address = 0");

        seller = payable (msg.sender);
        startingPrice = _startPrice;
        duration = _duration;

        nft = IERC721(_nftAddr);
        nftId = _nftId;

        isStart = false;
        isClosed = false;
    }


    function startAuction() external {  // owner call, start auction
        //check only seller, check auction status
        require(msg.sender == seller,"can't start, u a not autherized");
        require(!isStart && !isClosed, "auction has start or closed");

        // set start, end time
        // lock
        uint timeCurrent = block.timestamp;
        startAt = timeCurrent;
        endAt = timeCurrent + duration;

        //  change 
        isStart = true;
        // transfer nft to current contract
        nft.transferFrom(seller, address(this), nftId);
        // unlock

        emit Start();
    }

    function bid() external payable {
        // check bid start but not closed, check not seller, check time
        address sender = msg.sender;
        require(sender != seller, "sellber can't buy");
        require(sender != highestBidder, "you are already the highest bidder");
        require(sender != address(0), "bidder address = zero");
        require(isStart,"auction not start");
        require(!isClosed, "auction has closed");
        require(block.timestamp <= endAt,"auction has expired");


        // check price > current highest price
        uint bidPrice = msg.value;
        require(bidPrice > highestPrice && bidPrice >= startingPrice, "you bid < highest price");

        
        // receive eth and sum the total amount eth 
        // lock
        highestBidder = sender;
        highestPrice = bidPrice;
        bids[sender] += bidPrice;
        // unlock

        emit Bid(sender, bidPrice);

    }

    function withdraw() external payable  {
        // check already bid(balance >0)
        address payable sender = payable(msg.sender);
        require(bids[sender]!=0,"your eth = 0, can't withdraw");
        // require(isStart,"auction not ");

        // sender is the current highest bidder, can withdraw the rest eth
        uint refund;
        if(sender == highestBidder){
            refund = bids[sender] - highestPrice;
            // highest bidder can withdraw all the eth after 24 hours since auction is expired,TBD
        }else{
            refund = bids[sender];
        }

        //lock
        // transfer eth
        sender.transfer(refund);
        //update bids
        bids[sender] -= refund;
        // unlock

        emit Withdraw(sender, refund);
    }

    function endAuction() external payable {
        // check time expired, check owner, check is there anyone bidded
        address payable owner = payable (msg.sender);
        require(owner == seller, "Only seller can end auction");
        require(isStart,"auction not started");
        require(!isClosed, "auction is already closed.");
        require(block.timestamp > endAt,"time not expired,can't end");
        // require(highestBidder != address(0), "no one bids");
        if(highestBidder != address(0)){
            // transfer nft,transfer eth to seller,  
            nft.transferFrom(seller, highestBidder, nftId);
            seller.transfer(highestPrice);
            bids[highestBidder] -= highestPrice;
        }
        else{
            // no one bids, return nft
            nft.transferFrom(address(this), seller, nftId);
        }
        isStart = false;
        isClosed = true;

        // lock
        // transfer nft 
        // nft.transferFrom(seller, highestBidder, nftId);
        // isStart = false;
        // isClosed = true;
        // seller.transfer(highestPrice);
        // bids[highestBidder] -= highestPrice;
        // unlock

        emit End(highestBidder, highestPrice);
    }


}