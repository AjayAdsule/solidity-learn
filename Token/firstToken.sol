// SPDX-License-Identifier: MIT
pragma solidity >=0.8.20;

interface IERC20 {
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address to, uint256 value) external returns (bool);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 value) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);
}

contract FirstToken is IERC20 {
    /*
        we are not dealing with ether, wr are dealing with tokens
        totalSupply --> total tokens in circulation
        balanceOf --> return how many tokens user owns
        transfer --> transfer amount of token to other account
        allowance --> return the approved amount of token that a spender will be able to spend on a certain address
        approve --> approved the spender for spending a certain amount on behalf of msg.sender
        transferFrom --> transfer amount of token to other account on behalf of msg.sender
    */

    uint256 public totalSupply = 10000;
    address payable founder;
    mapping(address => uint256) public usersToken;
    mapping(address => mapping(address => uint256)) public allowances;

    constructor() {
        usersToken[msg.sender] = totalSupply;
    }

    modifier checkUserToken(uint256 value) {
        require(usersToken[msg.sender] >= value, "Insufficent token");
        _;
    }

    function balanceOf(address account) external view returns (uint256) {
        //return the total token users has
        return usersToken[account];
    }

    function approve(address spender, uint256 value) external returns (bool) {
        allowances[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function allowance(address owner, address spender)
        external
        view
        returns (uint256)
    {
        return allowances[owner][spender];
    }

    function transfer(address to, uint256 value)
        external
        checkUserToken(value)
        returns (bool)
    {
        usersToken[msg.sender] -= value;
        usersToken[to] += value;
        emit Transfer(msg.sender, to, value);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool) {
        require(allowances[msg.sender][from] >= value, "Insufficet token");
        usersToken[from] -= value;
        usersToken[to] += value;
        emit Transfer(from, to, value);
        return true;
    }
}
