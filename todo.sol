// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract MyToDo{
    struct task{
        string text;
        bool finished;
    }

    task[] public myTasks;

    modifier indexValid(uint _idx){
        uint len =  myTasks.length;
        require(_idx < len-1,"index out of range");
        _;
    }
    function addTask(string calldata _t) external {
        task memory tmp = task({text: _t, finished: false});
        myTasks.push(tmp);
    }
    function updateTask(uint _idx, string calldata _text) indexValid(_idx) external {

        myTasks[_idx].text = _text;
    }
    function size()external view returns(uint){
        return myTasks.length;
    }

    function toggleCompleted(uint _idx) indexValid(_idx) external {
        myTasks[_idx].finished = !myTasks[_idx].finished;
    }

}

