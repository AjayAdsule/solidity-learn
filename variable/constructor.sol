
// SPDX-License-Identifier: MIT
pragma solidity >=0.8.20;

contract LearnConstructor{
  int counter = 0;

  constructor (int number){
    counter = number;
  }


    function getCounterValue () public view  returns (int){
        return  counter;
    }

}