pragma solidity ^0.5.0;

import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";

contract Raffle is usingOraclize{
    
    address public owner;
    bool public isComplete;
    uint public participantNum;
    uint private priceIndex;
    
    mapping(uint=>uint) player;
    
    event finishRaffle(address from, bool complete);
    
    event LogNewOraclizeQuery(string description);
    event newRandomNumber_bytes(bytes);
    event newRandomNumber_uint(uint randomNumber);
    
    constructor(uint pN) payable public {
        require(pN >= 52);
        
        owner = msg.sender;
        isComplete = false;
        participantNum = pN;
        priceIndex = 0;
        
        oraclize_setProof(proofType_Ledger);
    }
    
    function update() private {
        uint N = 7;
        uint delay = 0;
        uint callbackGas = 200000;
        bytes32 queryId = oraclize_newRandomDSQuery(delay,N,callbackGas);
        emit LogNewOraclizeQuery("Oraclize query was sent, standing by for the answer...");
    }
    
    function __callback (
        bytes32 _queryId,
        string memory _result,
        bytes memory _proof
    )
        public
    {
        require(msg.sender == oraclize_cbAddress());

        if (oraclize_randomDS_proofVerify__returnCode(_queryId, _result, _proof) != 0) {
            // the proof verification has failed, do we need to take any action here? (depends on the use case)
        } else {
            // the proof verification has passed
            // now that we know that the random number was safely generated, let's use it...

            emit newRandomNumber_bytes(bytes(_result)); // emit the random bytes result

            /**
             * For simplicity of use, let's also convert the random bytes to uint.
             * First, we define the variable maxRange, where maxRange - 1 is the highest uint we
             * want to get. The variable maxRange should never be greater than 2^(8*N), where N is
             * the number of random bytes we had asked the datasource to return.
             * Finally, we perform the modulo maxRange of the sha3 hash of the random bytes cast
             * to uint to obtain a random number in the interval [0, maxRange - 1].
             */
            uint maxRange = participantNum; //2 ** (8 * 7) N = 7
            uint randomNumber = uint(keccak256(abi.encodePacked(_result))) % maxRange; // random number in the interval [0, 2^56 - 1]
            
            emit newRandomNumber_uint(randomNumber); // emit the resulting random number (as a uint)
            
            
            while(player[randomNumber] != 0){
                if(randomNumber == participantNum-1){
                    randomNumber = 0;
                    if(player[randomNumber] !=0)
                        break;
                }
                
                randomNumber++;
            }
            
            if(priceIndex==0){
                player[randomNumber] = 1;
            }
            else if(priceIndex==1 || priceIndex==2){
                player[randomNumber] = 2;
            }
            else {
                player[randomNumber] = 3;
            }
            
            priceIndex++;
            
            if(priceIndex<52-1){
                update();
            }
        }
    }
    
    function pickWinner() public {
        require(msg.sender == owner);
        require(isComplete == false);
        
        update();

        
        /// TODO: Oraclize
        /*
        uint32 count = 0;
        for(uint32 i=1;i<=participantNum;i++){
            
            if(i % 3 == 0 && count<50){
                player[i] = 3;
                count++;
            }
                
        }
        
        player[4] = 1;
        player[5] = 2;
        */
        ///
        
        isComplete = true;
        emit finishRaffle(msg.sender, isComplete);
    }
    
    function checkResult(uint num) public view returns(uint){
        require(isComplete == true);
        
        return (player[num]);
    }
    
    //testcode
    function showTwo() public view returns(uint){
        uint result = 0;
        uint padding = 1;
        for(uint i=0;i<participantNum;i++){
            if(player[i]==2){
                result += i * padding;
                padding = padding * 100;
            }
            if(player[i]==1){
                result += i * padding;
                padding = padding * 1000;
            }
        }
        return result;
    }
    
}