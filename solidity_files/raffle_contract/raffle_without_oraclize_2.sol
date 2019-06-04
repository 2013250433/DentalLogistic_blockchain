pragma solidity ^0.4.25;

contract Raffle{
    
    address public owner;
    bool public isComplete;
    uint32 public participantNum;
    
    mapping(uint32=>uint32) player;
    
    event finishRaffle(address from, bool complete);
    
    constructor(uint32 pN) public {
        require(pN >= 52);
        
        owner = msg.sender;
        isComplete = false;
        participantNum = pN;
    }
    
    function pickWinner() public {
        require(msg.sender == owner);
        require(isComplete == false);
        
        
        /// TODO: Oraclize
        uint32 count = 0;
        for(uint32 i=1;i<=participantNum;i++){
            
            if(i % 3 == 0 && count<50){
                player[i] = 3;
                count++;
            }
                
        }
        
        player[4] = 1;
        player[5] = 2;
        ///
        
        isComplete = true;
        emit finishRaffle(msg.sender, isComplete);
    }
    
    function checkResult(uint32 num) public view returns(uint32){
        require(isComplete == true);
        
        return (player[num]);
    } 
    
}