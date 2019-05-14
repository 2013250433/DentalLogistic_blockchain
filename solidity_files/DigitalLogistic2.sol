pragma solidity ^0.4.25;

contract DLogistic {
	// 스마트컨트랙트를 구분하기 위한 ID입니다. 
    string orderNumber; 
    string clientName;
    

        bool first; // 틀니의뢰의 상태를 나타냅니다.
        bool second; // 가공작업중 상태를 나타냅니다.
        bool third; // 작업완료 상태를 나타냅니다.
        bool fourth; // 배송중 상태를 나타냅니다.
        bool fifth; // 배송확인 상태를 나타냅니다.

    
    constructor (string oN, string cN) public{
        orderNumber = oN;
        clientName = cN;
        // 모든 상태를 false로 초기화합니다.
        first = false; second = false;
        third = false; fourth = false;
        fifth = false;
    }
    /*togge1부터 toggle5까지 틀니 의뢰 상태를 변경할 수 있는 함수입니다.
	  true 이면 false로 false이면 true로 변경합니다.
	*/
    function toggle1() external{
        if(first == false)
            first = true;
        else{ // 첫 번째 상태가 참일때만 두 번째 상태도 참이므로, 두 번째 상태가 참일 때 첫 번째 상태를 거짓으로 변경할 수 없습니다.
            require(second == false); //require은 조건문이 거짓일 경우, 이더리움 트랜잭션을 취소합니다. 
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
            third = false;
        }
    }
    
    function toggle4() external{
        if(fourth == false){
            require(third == true);
            fourth = true;
        }
        else{
            require(fifth == false);
            fourth = false;
        }
    }
    
    function toggle5() external{
        if(fifth == false){
            require(fourth == true);
            fifth = true;
        }
        else{
            fifth = false;
        }
    }
    // getFirst~getFifth 틀니 의뢰 상태를 가져올 수 있는 함수입니다.
    function getFirst() view external returns (bool){
        return first;
    }
    
    function getSecond() view external returns (bool){
        return second;
    }
    
    function getThird() view external returns (bool){
        return third;
    }
    
    function getFourth() view external returns (bool){
        return fourth;
    }
    
    function getFive() view external returns (bool){
        return fifth;
    }
}
