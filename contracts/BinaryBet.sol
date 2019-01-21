pragma solidity ^0.5.0;

import "../installed_contracts/zeppelin/contracts/ownership/Ownable.sol";
import "./interface/IBasicBet.sol";
import "./feature/Stageable.sol";

contract BinaryBet is Ownable, IBasicBet, Stageable {
    // user A
    address payable private _userA;
    bool private _choiceA;

    // user B
    address payable private _userB;
    bool private _choiceB;

    // the event result
    bool private _result;

    // zero address
    address constant private ZERO_ADDRESS = 0x0000000000000000000000000000000000000000;

    // constant bet amount
    uint256 constant BET_AMOUNT = 1 ether;

    // the betting contract defaults to being open to bets
    BetStatus public constant defaultStatus = BetStatus.Open;

    function choiceA() public view returns (bool) {
        return _choiceA;
    }

    function choiceB() public view returns (bool) {
        return _choiceB;
    }

    function result() public view returns (bool) {
        return _result;
    }

    constructor() public {
        _status = defaultStatus;
    }

    function addBet(uint256 choice) public payable onlyOpen {
        bool boolChoice = choice != 0; // boolChoice = bool(choice);
        // enforce bet amount
        require(msg.value == BET_AMOUNT, "Fixed bet amount of 1 ether");
        if (_userA == ZERO_ADDRESS) {
            // place bet as userA
            _userA = msg.sender;
            _choiceA = boolChoice;
        }
        else if (_userB == ZERO_ADDRESS)
        {
            // place bet as userB
            _userB = msg.sender;
            _choiceB = boolChoice;

            // both players have placed bets, close the betting
            _status = BetStatus.Closed;
        }
    }

    function finalizeEvent(uint256 result) public onlyOwner onlyClosed {
        bool boolResult = result != 0; // boolResult = bool(result);
        _status = BetStatus.Finalized;
        _result = boolResult;
    }

    function releaseFunds() public onlyOwner onlyFinalized {

        // prevent consecutive (re-entrancy) withdraws, reset game state
        _status = BetStatus.Open;

        // refund when there is no single winner
        if (_choiceA == _choiceB) {
            _userA.transfer(BET_AMOUNT);
            _userB.transfer(BET_AMOUNT);
        }
        else
        {
            if (_choiceA == _result) {
                _userA.transfer(address(this).balance);
            }
            else
            {
                _userB.transfer(address(this).balance);
            }
        }
    }
}