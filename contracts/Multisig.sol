// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract Multisig {
    address[] public owners;
    uint public setApprovals;
    struct Transactions {
        address to;
        bool isExecuted;
        uint amount;
        uint noOfApprovals;
    }
    Transactions[] public transactions;

    //checks which owner approved a transaction
    mapping(uint => mapping(address => bool)) approvals;
    mapping(address => bool) public isOwner;

    uint public numberOfTransactions;

    // declare an event that will be ommitted when the transaction is proposed
    event CreateTransaction(
        address indexed to,
        uint indexed amount,
        uint indexed nonce
    );
    event TransactionApproved(uint256 indexed nonce, address indexed owner);
    event TransactionExecuted(
        uint indexed nonce,
        address indexed to,
        uint amount
    );

    constructor(address[] memory _owners, uint _setApprovals) {
        require(_owners.length > 0, "At least one owner");
        require(_setApprovals > 0, "Approvals must be greater than zero");

        for (uint i = 0; i < _owners.length; i++) {
            address owner = _owners[i];

            owners.push(owner);
            isOwner[owner] = true;
        }
        setApprovals = _setApprovals;
    }

    function submitTransaction(address _to, uint _amount) external {
        require(_amount > 0, "amount sent must be greater than zero");
        transactions.push(
            Transactions({
                to: _to,
                isExecuted: false,
                amount: _amount,
                noOfApprovals: 0
            })
        );

        uint nonce = transactions.length - 1;
        emit CreateTransaction(_to, _amount, nonce);
    }

    function approveTransactions(uint _nonce) external {
        require(isOwner[msg.sender], "only owners can approve a transaction");
        approvals[_nonce][msg.sender] = true;
        transactions[_nonce].noOfApprovals += 1;

        emit TransactionApproved(_nonce, msg.sender);
    }

    function executeTransaction(uint _nonce) external {
        require(isOwner[msg.sender], "only owners can execute a transaction");
        require(
            transactions[_nonce].noOfApprovals >= setApprovals,
            "Not enough number of approvals"
        );
        approvals[_nonce][msg.sender] = true;
        transactions[_nonce].isExecuted = true;
        (bool success, ) = transactions[_nonce].to.call{
            value: transactions[_nonce].amount
        }("");
        require(success, "Cannot call");

        emit TransactionExecuted(
            _nonce,
            transactions[_nonce].to,
            transactions[_nonce].amount
        );
    }
}
