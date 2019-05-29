pragma solidity ^0.4.25;

contract RankIt {
    
    /// INCOMPLETE CONTRACT DO NOT USE !!! ///
    
    uint32 index;
    
    uint32 minPart;
    uint32 maxPart;
    
    bool isComplete;
    mapping (int=>string) participant;
    mapping (int=>int) rank;
    
    constructor(uint32 min,uint32 max) public{
        index = 0;
        isComplete = false;
        minPart = min;
        maxPart = max;
    }
    
    function pushMember(string pn) public returns(uint32) {
        require(bytes(pn).length==5); //accept last 4 numbers + 
        require(index<maxPart);
        
        participant[index] = pn;
        index++;
        
        return index;
    }
    
    function getIndex() public view returns(uint32){
        return index;
    }
    
    function getParticipant(uint32 idx) public view returns(string){
        if(idx>index)
            return "empty"; //TODO: 0 is not recog as empty 
        else
            return participant[idx];
    }
    
    function chooseWinner() public returns(string){
        require(isComplete == false);
        require(index>=minPart && index>maxPart);
        
        /*TODO
        
            randomize
        
        */
        
        isComplete = true;
        
        return "Winner is chosen!";
    }
}