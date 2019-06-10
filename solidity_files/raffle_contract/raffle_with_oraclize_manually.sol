/**
 * Oraclize Random Datasource Example
 *
 * This contract uses the random-datasource to securely generate off-chain
 * random bytes.
 *
 * @notice The random datasource is currently only available on the
 * ethereum main-net & public test-nets (Ropsten, Rinkeby & Kovan).
 *
 */
pragma solidity >= 0.5.0 < 0.6.0;

import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";

contract RandomExample is usingOraclize {
    
    uint public randomNumber;
    
    uint public participantNum;
    address public owner;
    bool public isComplete;
    
    mapping(uint=>uint) player;
    uint public givenPrize;
    
    event LogNewOraclizeQuery(string description);
    event newRandomNumber_bytes(bytes);
    event newRandomNumber_uint(uint randomNumber);
    
    constructor(uint pN)
        public payable
    {
        oraclize_setProof(proofType_Ledger); // sets the Ledger authenticity proof in the constructor
        
        owner = msg.sender;
        participantNum = pN;
        isComplete = false;
        givenPrize = 0;
    }

    // the callback function is called by Oraclize when the result is ready
    // the oraclize_randomDS_proofVerify modifier prevents an invalid proof to execute this function code:
    // the proof validity is fully verified on-chain
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
            uint maxRange = participantNum;//2 ** (8 * 7); // N = 7
            uint _randomNumber = uint(keccak256(abi.encodePacked(_result))) % maxRange; // random number in the interval [0, 2^56 - 1]
            
            randomNumber = _randomNumber;
            selectWinner(randomNumber);
            
            emit newRandomNumber_uint(_randomNumber); // emit the resulting random number (as a uint)
        }
    }

    function update()
        payable
        public
    {
        require(msg.sender == owner);
        require(isComplete == false);
        
        uint N = 7; // number of random bytes we want the datasource to return
        uint delay = 5; // number of seconds to wait before the execution takes place
        uint callbackGas = 200000; // amount of gas we want Oraclize to set for the callback function
        bytes32 queryId = oraclize_newRandomDSQuery(delay, N, callbackGas); // this function internally generates the correct oraclize_query and returns its queryId
        emit LogNewOraclizeQuery("Oraclize query was sent, standing by for the answer...");
    }
    
    function selectWinner(uint rN) private {
        
        while(player[rN] != 0){
            if(rN == participantNum-1){ // 0 ~ pN-1
                rN = 0;
                if(player[rN] != 0){ // if(player[0] != 0)
                    break;
                }
            }
                
            rN++;
        }
            
        if(givenPrize==0)
            player[rN] = 1;
        if(givenPrize==1)
            player[rN] = 2;
        if(1 < givenPrize && givenPrize < 52-1)
            player[rN] = 3;
        
        givenPrize++;
        
        if(givenPrize == 52-1){
            isComplete = true;
        }
    }
    
    function checkResult(uint num) public view returns(uint){
    //    require(isComplete == true);
        
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