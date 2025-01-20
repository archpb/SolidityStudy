// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract MultiSigWallet{
    // events 
    event Deposit(address indexed sender, uint amout);
    event SubmitTx(address to, uint amount, bytes data, uint indexed Txidx);
    event ApproveTx(address indexed approver, uint indexed txIdx);
    event RevokeTx(address indexed revoker, uint indexed txIdx);
    event ExecuteTx(address indexed executer, uint indexed txIdx);

    // data
    address[] public owners;    // owners' addresses, 
    mapping (address => bool) public isOwner;   //  bool 1: existed, 0:not exsited, save gas, not needs to find&check
    uint public required;
    // enum TxStatus{
    //     none,
    //     pending,
    //     approving,
    //     approved,
    //     completed
    // }
    struct MyTransaction{
        address to;
        uint amount;
        bytes txdata;
        bool completed;
    }
    MyTransaction[] public myTransactions;
    mapping (uint => mapping(address => bool)) approvesList;

    constructor (address[] memory _owners, uint _required){
        uint ownersNum = _owners.length;
        require(ownersNum > 0, "At lease one owner should be initialized");
        require(_required > 0, "require approved number should > 0");
        require(_required <= ownersNum, "requires should be no more than the owners" );

        for(uint i=0; i<ownersNum;++i){
            address tmpOwner = _owners[i];
            require(tmpOwner != address(0),"address 0 not valid");
            require(!isOwner[tmpOwner], "owner duplicated");

            owners.push(tmpOwner);
            isOwner[tmpOwner] = true;
        }
        // check duplicated owner address， TBD

        required = _required;
    }

    receive() external payable { 
        emit Deposit(msg.sender, msg.value);
    }

    modifier OnlyOwner(){
        require(_isOwner(msg.sender), "Only owner allowed.");
        _;
    }
    modifier txExisted(uint _idx){
        require(_isTxExisted(_idx), "The tx index out of range");
        _;
    }
    modifier txNotApproved(uint _idx){
        require(approvesList[_idx][msg.sender] == false, "You have already approved this transction.");
        _;
    }
    modifier txNotExecuted(uint _idx){
        require(myTransactions[_idx].completed == false, "This tx has completed");
        _;
    }



    function _isOwner(address _addr) internal view returns(bool) {
        return isOwner[_addr];
    }
    function _isTxExisted(uint _idx) internal view returns(bool){
        return _idx < myTransactions.length;
    }
    function _isApproved(uint _idx) internal view returns(bool){
        uint ownerNum = owners.length;
        uint approvedNum = 0;
        for (uint i = 0; i < ownerNum; ++i){
            if (approvesList[_idx][owners[i]] == true){
                approvedNum++;
            }
        }
        return approvedNum >= required;
    }

    /* external functions */
    function submit(address _to, uint _amount, bytes calldata _data) external OnlyOwner() returns(bool){
        MyTransaction memory tempTx = MyTransaction({
            to : _to,
            amount : _amount,
            txdata : _data,
            completed : false
        });
        myTransactions.push(tempTx);

        emit SubmitTx(_to, _amount, _data, myTransactions.length - 1);
        return true;
    }

    function approve(uint _idx) 
        external 
        OnlyOwner 
        txExisted(_idx) 
        txNotApproved(_idx) 
        txNotExecuted(_idx) 
        returns(bool){
            approvesList[_idx][msg.sender] = true;
            emit ApproveTx(msg.sender, _idx);
            return true;
    }

    function execute(uint _idx) external  txExisted(_idx) txNotExecuted(_idx) returns(bool){
        require(_isApproved(_idx),"This txIndex needs more approbations");
        MyTransaction storage tmpTx = myTransactions[_idx];
        tmpTx.completed = true;
        (bool success,) = tmpTx.to.call{value : tmpTx.amount}(tmpTx.txdata);
        require(success, "execute transaction fail");
        emit ExecuteTx(msg.sender, _idx);
        return true;
    }

    function revoke(uint _idx) external OnlyOwner txExisted(_idx) txNotExecuted(_idx) returns(bool){
        require(approvesList[_idx][msg.sender] == true, "You didn't approve this tx.");
        approvesList[_idx][msg.sender] = false; 
        emit RevokeTx(msg.sender, _idx); 
        return true;
    } 

}