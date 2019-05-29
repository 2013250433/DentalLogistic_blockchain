pragma solidity ^0.4.18;
import "github.com/oraclize/ethereum-api/oraclizeAPI_0.4.sol";

contract Temperature is usingOraclize {
    uint public temperature;
    
    event NewOraclizeQuery(string description);
    event NewTemperature(string temperature);
    
    function __callback(bytes32 queryId, string result){
        if(msg.sender != oraclize_cbAddress()) 
            revert();
        NewTemperature(result);
        temperature = parseInt(result);
    }
    
    function update() public payable {
        NewOraclizeQuery("Oraclize query was sent...");
        oraclize_query("WolframAlpha", "temperature in London");
    }
    
    function getSavedTemperature() view returns (uint) {
        return temperature;
    }
}