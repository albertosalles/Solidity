// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;


contract Token{

    uint256 public savedBalance;
    uint256 public pricePerToken;

    //balance for each address
    mapping(address =>uint256) public balance;
    uint256 public totalsuply;


    constructor (uint256 pricePerToken_){
        pricePerToken = pricePerToken_;
    }

    //Las funciones que lo integren tienen que cumplir esta condición
    //si no lo cumplen, no seguirán con la ejecución
    modifier userHasBalance(uint256 amount){
        require(balance[msg.sender]>=amount,"NOT enough");
        _;
    }

    //payable -> Puede enviar tokens
    function buyTokens(uint256 amount) public payable {
        require(msg.value == amount * pricePerToken, "Incorrect value");
        savedBalance += msg.value;
        totalsuply += amount;
        balance[msg.sender] += amount;
    }
    
    function sellTokens(uint256 amount) public userHasBalance(amount){
        //El dinero sale del banco
        require(balance[msg.sender]>=amount,"Not enough balance");
        savedBalance -= amount*pricePerToken;
        totalsuply -=amount;
        balance[msg.sender]-=amount;

        //Se le asigna el dinero al usuario
        //call -> sirve para mandar monea a otra dirección
        //lo que hace es asignarle a la dirección el valor

        (bool success, ) = address(msg.sender).call{value:amount*pricePerToken}("");
        require(success==true,"Transacction failed");
    }

    function transferTokens(address wallet, uint256 amount) public userHasBalance(amount){
        balance[msg.sender]-=amount;
        balance[wallet]+=amount;
    }

}
