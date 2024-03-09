/**
 *Submitted for verification at Etherscan.io on 2024-03-01
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
  abstract contract abs {
    //No need yet 
 }
 contract owner is abs{
   address public  Owner;
     constructor() {
        Owner=msg.sender;
     }
  modifier OnlyOwner {
    require(Owner==msg.sender,"You are not owner");
    _;
  }

  function ChangeOwner(address NewOwner) external OnlyOwner {
    Owner=NewOwner;
   }
 }
 contract StakingEther is owner {
    uint256 public TotalCirculationPoints;
    uint256 public endTime;
     struct EthStaker{
        address User;
        uint256 point;
        uint256 UserStakedbalance;
        
     }
     EthStaker[] public  Users;
     EthStaker oneUser;
     mapping (address=>uint256) internal  AddBalance;
     constructor() {
        TotalCirculationPoints=0;
        oneUser.User=msg.sender;
        oneUser.point=0;
        oneUser.UserStakedbalance=0;
        endTime=0;
     }
function EndTimeChange(uint256 newTime)  external OnlyOwner{
    endTime=newTime*1 seconds;
}
function mintPoints(uint256 minPoints) internal  {
        TotalCirculationPoints+=minPoints;
}
     function DepositEth() external   payable  {
        require(msg.value>0,"You don't have enough balance");
        payable(address(this)).transfer(msg.value);
        uint256 CPoints= CalculatePoins(msg.value);
        bool userExists = false;
    for (uint256 i = 0; i < Users.length; i++) {
        if (Users[i].User == msg.sender) {
            Users[i].point += CPoints;
            Users[i].UserStakedbalance+=msg.value;
            userExists = true;
            break;
        }
    }
    if (!userExists) {
        Users.push(EthStaker(msg.sender, CPoints,msg.value));
    }
    mintPoints(CPoints);
    LockForaTime();
}
    receive() external payable { }
    function CalculatePoins(uint256 amount) internal pure returns(uint256)  {
      return  amount*1000;
     }
     function GetPoints(address newPoints) external view  returns(uint256) {
        for (uint256 i=0; i<Users.length; i++) 
        {
            if (Users[i].User==newPoints) {
                return (Users[i].point);
            }
        }
        revert("You have 0 Point");
     }

function WithdrawEth(address payable  getAddress,uint256 amount) external OnlyOwner  {
    require(address(this).balance>0 && amount>0 && AddBalance[address(this)]>=amount,"Contarct doesnot have enough balance to send");
     getAddress.transfer(amount);
 }
 function WithdrawEthFromUserAccount(uint256 amount) external {
    for (uint256 i=0; i<Users.length; i++) 
    {
      if (Users[i].User==msg.sender) {
        require(block.timestamp>=endTime,"You need to wait more");
        require(Users[i].UserStakedbalance>=amount,"You don't have enough balance to withdraw");
        Users[i].UserStakedbalance-=amount;
        payable (msg.sender).transfer(amount);
        return;
      }
    }
    revert("You need to more balance");
 }
 function LockForaTime()internal   {
   endTime= block.timestamp+endTime;
 }
 }