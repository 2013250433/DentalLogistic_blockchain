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
    
    constructor(uint pN) public {
        require(pN >= 52);
        
        owner = msg.sender;
        isComplete = false;
        participantNum = pN;
        priceIndex = 0;
        
        oraclize_setProof(proofType_Ledger);
    }
    
    function update() payable public {
        uint N = 7;
        uint delay = 0;
        uint callbackGas = 200000;
        bytes32 queryId = oraclize_newRandomDSQuery(delay,N,callbackGas);
        emit LogNewOraclizeQuery("Oraclize query was sent, standing by for the answer...");
    }
    
    function __callback(
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
            
            allocRanNum(randomNumber);
            
            emit newRandomNumber_uint(randomNumber); // emit the resulting random number (as a uint)
        }
    }
    
    function allocRanNum(uint rN) private{
        
            while(player[rN] != 0){
                if(rN == participantNum-1){
                    rN = 0;
                    if(player[rN] !=0)
                        break;
                }
                
                rN++;
            }
            
            if(priceIndex==0){
                player[rN] = 1;
            }
            
            if(priceIndex==1 || priceIndex==2){
                player[rN] = 2;
            }
            
            if(priceIndex < 52)
                player[rN] = 3;
                
            priceIndex++;
    }
    
    function pickWinner() public {
        require(msg.sender == owner);
        require(isComplete == false);
        
        for(uint i=0;i<3;i++){
            update();
        }
        
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
    
}