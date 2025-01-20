// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract MyEnum{

    enum OrderStatus{
        None,       // 0
        Pending,    // 1
        Shipped,    // 2
        Completed,  // 3
        Rejected,   // 4
        Cancelled   // 5
    }

    struct Order{
        address owner;
        OrderStatus status;
    }

    Order[] public orders;

    function addOrder(address _owner) public {
        require(_owner != address(0), "Invalid owner");
        bool found = false;
        for(uint i = 0; i<orders.length;++i){
            if(_owner == orders[i].owner){
                found = true;
                break;
            }
        }
        require(!found, "This owner's order has already exists.");
        Order memory newOrder = Order({owner: _owner, status: OrderStatus.Pending});
        orders.push(newOrder);
    }

    function updateOrderStatus(address _owner, OrderStatus _newStatus)public{
        bool found = false;
        for(uint i = 0; i<orders.length;++i){
            if(_owner == orders[i].owner){
                found = true;
                orders[i].status = _newStatus;
                break;
            }
        }
        require(found, "The order specified by the address is not found.");
    }

    function getOrderStatus(address _owner) public view returns(OrderStatus ret){
        bool found = false;
        for(uint i = 0; i<orders.length;++i){
            if(_owner == orders[i].owner){
                found = true;
                ret = orders[i].status;
                break;
            }
        }
        require(found, "The order specified by the address is not found.");
    }

    function resetOrderStatus(address _owner) public {
       bool found = false;
        for(uint i = 0; i<orders.length;++i){
            if(_owner == orders[i].owner){
                found = true;
                delete orders[i].status;
                break;
            }
        }
    }

    function testmin() public pure returns(OrderStatus){return type(OrderStatus).min;}
    function testmax() public pure returns(OrderStatus){return type(OrderStatus).max;}
}