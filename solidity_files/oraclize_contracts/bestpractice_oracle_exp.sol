pragma solidity ^0.4.18;
import "github.com/oraclize/ethereum-api/oraclizeAPI_0.4.sol";

contract BestPractice is usingOraclize {
    uint public ETHUSD;
    
    event LogPriceUpdated(string price);
    event LogNewOraclizeQuery(string description);
    
    mapping (bytes32 => bool) public pendingQueries;
    
    function BestPractice(){
        //oraclize_setProof(proofType_Android_v2 | proofShield_Ledger);
    }
    
    function __callback(bytes32 queryId, string result){
        if(msg.sender != oraclize_cbAddress()) revert();
        
        // proofShield_Ledger...
        require(pendingQueries[queryId] == true);
        delete pendingQueries[queryId];
        LogPriceUpdated(result);
        ETHUSD = parseInt(result);
    }
    
    function updatePrice() public payable {
        if(oraclize_getPrice("URL") > this.balance){
            LogNewOraclizeQuery("Query was Not sent, add ETH!");
        } else{
            LogNewOraclizeQuery ("Query was sent, wait for response..");
            bytes32 queryId = oraclize_query("URL","json(https://api.gdax.com/products/ETH-USD/ticker).price");
            pendingQueries[queryId] = true;
        }
    }
    
    function checkPrice() public returns(uint){
        return oraclize_getPrice("URL",50000);
    }
    
}