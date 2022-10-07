pragma solidity ^0.8.15;

contract SmartBankAccount{
    
    uint totalBankBalance = 0;
   

    function ShowTotalBalance() public view returns(uint){
        return totalBankBalance;
    }

     mapping( address=>uint) Balance;
     mapping(address=>uint) TimeWhileDeposit;

    function addBalance() public payable{
        Balance[msg.sender]=0;
        Balance[msg.sender]=Balance[msg.sender]+msg.value;
        totalBankBalance = totalBankBalance + msg.value;
        TimeWhileDeposit[msg.sender]= block.timestamp;
    }
     
    function ShowBalance(address _userAddress) public view returns(uint){
        return Balance[_userAddress];
    }

    function Intrest(address _userAddress) internal  {
        uint presentTime;
        presentTime = block.timestamp-TimeWhileDeposit[_userAddress];
        Balance[_userAddress] = Balance[_userAddress]+(Balance[_userAddress]* uint(presentTime/(365*24))*7/100);
    }

    function getBalance(address _userAddress) public view returns(uint){ 
       uint presentTime;
       presentTime = block.timestamp-TimeWhileDeposit[_userAddress];
       return Balance[_userAddress]+(Balance[_userAddress]*7*uint(presentTime/(365*24))/100);
    }

    modifier balance(uint _balance, uint _amount) {
           require( _amount <= _balance , "insufficient Balance");
           _;
     }

     function transfer(uint _amount,address _toSend) public payable balance(getBalance(msg.sender),_amount){
         Intrest(msg.sender);
         Intrest(_toSend);
         Balance[msg.sender]=Balance[msg.sender]-_amount;
         Balance[_toSend] = Balance[_toSend] + _amount;
     }

    function Withdraw(uint _amount) public payable balance(getBalance(msg.sender),_amount){
        address payable userAddress = payable(msg.sender);
        Intrest(msg.sender);
        userAddress.transfer(_amount);
        Balance[msg.sender]=Balance[msg.sender]-_amount;
        totalBankBalance = totalBankBalance - _amount;
    }
}
