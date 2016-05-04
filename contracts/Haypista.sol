// First, a simple haypista contract
// Allows to place value on a game

/// @title Haypista
/// @author inasacu
contract Haypista {
  address public manager;
  uint256 public amount;

  uint256 public defaultAmount = 1000 finney;
  uint public feeRate = 45 / 10000;
  bytes32 public name = 'The Pista';
  uint constant threeHours = 10800;

  struct Pista {
      bytes32 homeTeam;
      bytes32 awayTeam;
      uint home;
      uint away;
      bytes32 oneXTwo;
      uint starts;
      uint points;
      uint winners;
      uint256 amount;
      uint256 winnings;
      uint256 fees;
      uint256 remainder;
      mapping(uint => Player) players;
      uint participants;
  }

  struct Player {
      address etherAddr;
      uint256 amount;
      uint home;
      uint away;
      bytes32 oneXTwo;
      uint points;
  }

  mapping(uint256 => Pista) pistas;
  uint public gameId = 0;

  /* default point values */
  uint single = 1;
  uint double = 3;
  uint draw = 5;
  uint difference = 7;
  uint goal = 9;
  uint winner = 12;
  uint max = single + double + draw + difference + goal + winner;

  modifier onlyManager {
    if (manager == msg.sender) _
  }

  modifier onlyPlayer {
    if (manager != msg.sender) _
  }

  modifier hasNotStarted(uint _gameId) {
    if (block.timestamp < pistas[_gameId].starts - threeHours) _
  }

  modifier hasFinished(uint _gameId) {
    if (block.timestamp > pistas[_gameId].starts + threeHours) _
  }

  modifier isValidNumber(uint _numeric) {
    if (_numeric >= 0) _
  }

  /// @notice initializes the smart contract by the Manager
  /// @param _name The name of the game, ex: 'Champions League, Group Stage...'
  function Haypista(bytes32 _name) {
    manager = msg.sender;
    amount = msg.value;
    name = _name;
    setDefaultAmount(amount + (amount * feeRate));
  }

  /// @notice addPista a new pista by manager
  /// @param _homeTeam The name of the home team
  /// @param _awayTeam The name of the away team
  /// @param _starts the pista start time
  function addPista(uint256 _gameId, bytes32 _homeTeam, bytes32 _awayTeam, uint _starts) onlyManager {
    Pista newPista = pistas[gameId];
    newPista.homeTeam = _homeTeam;
    newPista.awayTeam = _awayTeam;
    newPista.starts = _starts;
    newPista.participants = 0;
    newPista.amount = 0;
    newPista.points = 0;
    newPista.winners = 0;
    newPista.amount = 0;
    newPista.winnings = 0;
    newPista.fees = 0;
    newPista.remainder = 0;
    gameId += 1;
  }

  /// @notice setHomeAway name by manager
  /// @param _gameId identifier for the game
  /// @param _homeTeam The name of the home team
  /// @param _awayTeam The name of the away team
  function setHomeAway(uint _gameId, bytes32 _homeTeam, bytes32 _awayTeam) onlyManager {
    Pista thePista = pistas[_gameId];
    thePista.homeTeam = _homeTeam;
    thePista.awayTeam = _awayTeam;
  }

  /// @notice setStarts set pista starts by manager
  /// @param _gameId identifier for the game
  /// @param _starts the start time for the game
  function setStarts(uint _gameId, uint _starts) onlyManager hasNotStarted(_gameId) {
    Pista thePista = pistas[_gameId];
    thePista.starts = _starts;
  }

  /// @notice initialize smart contract by participant
  /// @param _gameId identifier for the game
  /// @param _home The points for the home team
  /// @param _away The points for the away team
  function initialize(uint32 _blockNumber, uint _gameId, uint _home, uint _away) onlyPlayer hasNotStarted(_gameId) isValidNumber(_home) isValidNumber(_away) {
    uint256 initialAmount = msg.value;
    uint256 fees = 0;

    // defaultAmount += defaultAmount * feeRate;

    Pista thePista = pistas[_gameId];
    var allPlayers = thePista.players;

    /* refund and exit if not enough funds */
    if (initialAmount < defaultAmount)
      throw;

    /* prevent same user from participating in same game */
    for (uint idx = 0; idx < thePista.participants; idx++) {
      if (allPlayers[idx].etherAddr == msg.sender)
        throw;
    }

    /* refund amount over the default amount */
    if (initialAmount > defaultAmount) {
      uint256 excessAmount = defaultAmount - initialAmount;
      initialAmount -= excessAmount;
      msg.sender.send(excessAmount);
    }

    /* set payout variables */
    thePista.amount += initialAmount; // update amount
    fees = initialAmount * feeRate; // set fees
    initialAmount -= fees; // remove fees from initialAmount

    /* payout fees to the manager */
    if (fees != 0)
      thePista.fees += fees; //update fees

    allPlayers[thePista.participants].etherAddr = msg.sender;
    allPlayers[thePista.participants].amount = initialAmount;
    allPlayers[thePista.participants].home = _home;
    allPlayers[thePista.participants].away = _away;
    allPlayers[thePista.participants].oneXTwo = setOneXTwo(_home, _away);
    allPlayers[thePista.participants].points = 0;

    thePista.participants++;
  }

  /// @notice processWinning basically allows to complete winning process by manager
  /// @param _gameId identifier for the game
  function processWinning(uint _gameId)  onlyManager hasFinished(_gameId) {
    setPistaScore(_gameId, 0);
    depositPlayerWin(_gameId);
    sendWinnings(_gameId);
  }

  /// basically allows to send a refund by manager
  /// by sending 99999, no winner is declared and all players get amount back
  /// @param _gameId identifier for the game
  function sendRefund(uint _gameId)  onlyManager hasFinished(_gameId) {
    setPistaScore(_gameId, 99999);
    depositPlayerWin(_gameId);
    sendWinnings(_gameId);
  }

  /// @notice setPlayerScore _home, _away by etherAddr
  /// @param _etherAddr The address for etherAddr
  /// @param _gameId identifier for the game
  /// @param _home The points for the home team
  /// @param _away The points for the away team
  function setPlayerScore(address _etherAddr, uint _gameId, uint _home, uint _away) onlyPlayer hasNotStarted(_gameId) isValidNumber(_home) isValidNumber(_away) {
    Pista thePista = pistas[_gameId];
    var allPlayers = thePista.players;

    for (uint idx = 0; idx < thePista.participants; idx++) {
      if (allPlayers[idx].etherAddr == _etherAddr) {
          allPlayers[idx].home = _home;
          allPlayers[idx].away = _away;
          allPlayers[idx].oneXTwo = setOneXTwo(_home, _away);
      }
    }
  }

  /// @notice setPointSystem changes default point system by manager
  /// @param _single The points for getting a single points correctly
  /// @param _double The points for getting a both points correctly
  /// @param _draw The points for getting a draw correctly
  /// @param _difference The points for getting the difference between goals pointsd correctly
  /// @param _goal The points for getting total goals pointsd correctly
  /// @param _winner The points for getting winner correctly
  function setPointSystem(uint _single, uint _double, uint _draw, uint _difference, uint _goal, uint _winner) onlyManager isValidNumber(_single) isValidNumber(_double) isValidNumber(_draw) isValidNumber(_difference) isValidNumber(_goal) isValidNumber(_winner) {
    single = _single;
    double = _double;
    draw = _draw;
    difference = _difference;
    goal = _goal;
    winner = _winner;
    max = single + double + draw + difference + goal + winner;
  }

  /// @notice setDefaultAmount will set minimum amount per etherAddr, set by manager
  /// @param _defaultAmount set as default
  function setDefaultAmount(uint256 _defaultAmount) onlyManager {
    defaultAmount = _defaultAmount;
  }

  /// @notice setFeeRate changes the fee rate
  function setFeeRate(uint _feeRate)  onlyManager {
    feeRate = _feeRate;
  }

  /// @notice setName changes thePista name
  function setName(bytes32 _name) {
    name = _name;
  }

  /// @notice setScore changes or update game result by manager
  /// @param _gameId identifier for the game
  /// @param _home The points for the home team
  /// @param _away The points for the away team
  function setScore(uint _gameId, uint _home, uint _away) onlyManager hasFinished(_gameId) isValidNumber(_home) isValidNumber(_away) {
    Pista thePista = pistas[gameId];
    thePista.home = _home;
    thePista.away = _away;
    thePista.oneXTwo = setOneXTwo(_home, _away);
  }

  /// @notice setPlayerPoints will calculate points based on game results and users input
  /// @param _gameId identifier for the game
  function setPlayerPoints(uint _gameId) onlyManager hasFinished(_gameId) {
      uint goalDiff = 0;
      uint playerGoalDiff = 0;

      Pista thePista = pistas[_gameId];
      var allPlayers = thePista.players;

      /* get game goal difference */
      if ( thePista.oneXTwo != 'X' )
        goalDiff = thePista.home - thePista.away;


      if ( thePista.oneXTwo == 'X' )
        goalDiff = thePista.away - thePista.home;


      for (uint idx = 0; idx < thePista.participants; idx++) {
        playerGoalDiff = 0;
        Player thePlayer = allPlayers[idx];

        /* idx gets exact scoring */
        if (thePlayer.home == thePista.home && thePlayer.away == thePista.away ) {
            thePlayer.points = max;
        }
        else {
           /* if the exactScore was not achieved, check individual results. */
          if ( thePlayer.oneXTwo != 'X' )
            playerGoalDiff = thePlayer.home - thePlayer.away;

          if ( thePlayer.oneXTwo == 'X' )
            playerGoalDiff = thePlayer.away - thePlayer.home;

          /* points for single points */
          if ( thePlayer.home == thePista.home || thePlayer.away == thePista.away )
            thePlayer.points += single;

          /* points for double points */
          if ( thePlayer.home == thePista.away && thePlayer.away == thePista.home )
            thePlayer.points += double;

          /* points for draw */
          if ( thePlayer.oneXTwo == thePista.oneXTwo && thePista.oneXTwo == "X" )
            thePlayer.points += draw;

          /* points for goal difference */
          if ( playerGoalDiff == goalDiff )
            thePlayer.points += difference;

          /* points for goal total */
          if ( thePlayer.home + thePlayer.away == thePista.home + thePista.away )
            thePlayer.points += goal;

          /* points for winner */
          if ( thePlayer.oneXTwo == thePista.oneXTwo && thePista.oneXTwo != "X" )
            thePlayer.points += winner;

        }

      }
  }

  /// @notice setOneXTwo allows to return setOneXTwo from points
  /// @param _home The points for the home team
  /// @param _away The points for the away team
  /// @return The oneXTwo value from _home, _away calculation
  function setOneXTwo(uint _home, uint _away) private returns (bytes32 oneXTwo) {
    if (_home > _away) {
      oneXTwo = '1';
    }
    else if (_home < _away) {
      oneXTwo = '2';
    }
    else {
      oneXTwo = 'X';
    }
  }

  /// @notice setPistaScore sets highscore for _gameId, calculate total winners, transfers individual amount to _gameId amount
  /// @param _gameId identifier for the game
  /// @param _points used as refund for all winners, values 0 or 99999.  99999 is to refund all players
  function setPistaScore (uint _gameId, uint _points) private {
    uint idx = 0;

    Pista thePista = pistas[_gameId];
    var allPlayers = thePista.players;

    thePista.winners = 0;
    thePista.points = _points;

    for (idx; idx < thePista.participants; idx++) {
      thePista.amount += allPlayers[idx].amount;
      allPlayers[idx].amount -= allPlayers[idx].amount;

      if ( allPlayers[idx].points > thePista.points ) {
        thePista.points = allPlayers[idx].points;
        thePista.winners = 1;
      }
      else if ( allPlayers[idx].points == thePista.points ) {
        thePista.winners++;
      }
    }

    if (thePista.winners == 0 ) {
      thePista.winners = thePista.participants;
      thePista.points = 0;
    }
  }

  /// @notice depositPlayerWin spits amount amongst _gameId winners, remainder is saved
  /// @param _gameId identifier for the game
  function depositPlayerWin(uint _gameId) private {
    uint idx = 0;
    Pista thePista = pistas[_gameId];
    var allPlayers = thePista.players;

    uint256 amount = thePista.amount + thePista.remainder;
    uint256 winnings = amount / thePista.winners;

    /* split sums amongst the thepista.winners, amount are split amongst the thepista.winners, winnings */
    for (idx; idx < thePista.participants; idx++) {
       if ( allPlayers[idx].points == thePista.points ) {
            allPlayers[idx].amount = winnings;
            thePista.amount -= winnings;
        }
    }
    thePista.remainder = amount % thePista.winners; // remainder is given to manager
  }


  /// @notice sendWinnings reamount amount to all etherAddrs, winners should have amount while non winners will have zero balance
  /// if the case is where no etherAddr points, original amount are returned minus fees
  /// @param _gameId identifier for the game
  function sendWinnings(uint _gameId) private {
    Pista thePista = pistas[_gameId];
    var allPlayers = thePista.players;

    for (uint idx = 0; idx < thePista.participants; idx++)
        allPlayers[idx].etherAddr.send(allPlayers[idx].amount);

    /* payout remainder to the manager */
    if (thePista.remainder != 0) {
      thePista.fees += thePista.remainder;
      thePista.remainder -= thePista.remainder;
    }

    /* send fees to the manager */
    if (thePista.fees != 0)
      manager.send(thePista.fees);

  }

  /// @notice empty function, appears to be if wrong info is entered, come out without a cost to the called function
  function () { throw; }
}
