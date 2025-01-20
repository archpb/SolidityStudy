// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// import "./ERC721.sol";

interface IERC721 {
    function transferFrom(address _from, address _to, uint256 _tokenId) external;
}
contract DutchAuction{
    uint private constant DURATION = 7 days;   // DURATION =604800 seconds, block.timestamp is also in seconds.

    uint public immutable startsAt;         // in seconds
    uint public immutable expiresAt;
    uint public immutable startingPrice;    // in weis
    uint public immutable discountRate;     // discont eth(in weis) per second

    IERC721 public  nft;
    uint public immutable nftId;
    address public immutable seller;
    address public currentBuyer;
    bool public isSold;

    event DealDone(address buyer, uint price, uint nftId);
    event testMoney(uint startingPrice, uint discountRate, uint duration);
    event debugInfo(uint msgValue, uint refund);

    receive() external payable { }

    constructor (uint _startingPrice, uint _discountRate, address _nft, uint _nftId) payable {
        // check starting price
        emit testMoney(_startingPrice, _discountRate, DURATION);
        require(_startingPrice >= _discountRate * DURATION, "starting price <= total discount");

        uint timeNow = block.timestamp;

        seller = payable(msg.sender);
        startsAt = timeNow;
        expiresAt = timeNow + DURATION;
        discountRate = _discountRate;
        // discountRate = 1 wei;
        startingPrice = _startingPrice;

        nft = IERC721(_nft);   // _nft address should be the IERC721 contract address, 
        // nft = new ERC721(_nft, _nftId);   // TBD
        nftId = _nftId;
        isSold = false;
    }

    function getCurrentPrice() public  view returns(uint){
        uint elapsedTime = block.timestamp - startsAt;
        return startingPrice - discountRate * elapsedTime;
    }
    function buy() external  payable {
        // check time not expired, not sold, check money
        require(block.timestamp <= expiresAt, "auction has expired");
        require(!isSold, "nft has been sold");

        uint buyerMoney = msg.value;
        uint curPrice = getCurrentPrice();
        require(buyerMoney >= curPrice, "not enough ETH to buy");
        currentBuyer = msg.sender;

        
        nft.transferFrom(seller, msg.sender, nftId);  // don't the transction result
                                                        // seller: 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
                                                        // msg.sender: 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
                                                        // nftId: 11
                                                        // nft contract address: 0x2A5E38628B8530f0cF11A2ca652054e6A1Ec36aB
        uint refund = buyerMoney - curPrice;
        if(refund > 0){
            payable(msg.sender).transfer(refund);  //  direct send rest eth to sender 
        }
        isSold = true;
        emit debugInfo(msg.value, refund);
        emit DealDone(msg.sender, curPrice, nftId);





    }


}