pragma solidity ^0.4.25;

contract DLogistic {
    
    string orderNumber;
    string clientName;
    

        bool first;
        bool second;
        bool third;
        bool fourth;
        bool fifth;

    
    constructor (string oN, string cN) public{
        orderNumber = oN;
        clientName = cN;
        
        first = false; second = false;
        third = false; fourth = false;
        fifth = false;
    }
    
    function toggle1() external{
        if(first == false)
            first = true;
        else{ // prevent first to be false when second is already checked
            require(second == false);
            first = false;
        }
    }
    
    function toggle2() external{
        if(second == false){
            require(first == true);
            second = true;
        }
        else{
            require(third == false);
            second = false;
        }
            
    }
    
    function toggle3() external{
        if(third == false){
            require(second == true);
            third = true;
        }
        else{
            require(fourth == false);
            second = false;
        }
    }
    
    function getFirst() view external returns (bool){
        return first;
    }
    
    function getSecond() view external returns (bool){
        return second;
    }
    
    function getThird() view external returns (bool){
        return third;
    }
}