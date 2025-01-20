// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract MyEvents{

    event Logmessages(address indexed sender, address indexed receiver, string text);
    event LogmessagesIndexed1(address indexed sender, address receiver, string text);
    event LogmessagesNoIndexed(address sender, address  receiver, string text);

    function sendMessage(address _receiver, string memory _text) external {
        emit Logmessages(msg.sender, _receiver, _text);
        emit LogmessagesIndexed1(msg.sender, _receiver, _text);
        emit LogmessagesNoIndexed(msg.sender, _receiver, _text);
    }
}