pragma solidity ^0.4.0;

import "oraclize/usingOraclize.sol";

contract Twitter is usingOraclize {
    
    string public followers;
    
    event newOraclizeQuery(string description);
    event newFollowersCount(string followers);

    function Twitter() {
        update();
    }

    function getFollowers() returns(string) {
        return followers;
    }
    
    function __callback(string result) {
        require(msg.sender == oraclize_cbAddress());
        followers = result;
        newFollowersCount(followers);
    }
    
    function update() payable {
        newOraclizeQuery("Oraclize query was sent, standing by for the answer..");
        oraclize_query("URL", "html(https://twitter.com/grupiotr).xpath(//*[contains(@data-nav, 'followers')]/*[contains(@class, 'ProfileNav-value')]/text())");
    }
    
} 
