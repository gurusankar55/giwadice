// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title GiwaDice - a tiny on-chain dice game on GIWA Sepolia
/// @notice Pick a number 1-6 and roll. Same number = win. Tracks plays, wins and daily streaks.
/// @dev Randomness uses prevrandao + timestamp + sender + nonce. Fine for a testnet game, not for real money.
contract GiwaDice {
    struct Player {
        uint32 plays;
        uint32 wins;
        uint32 streak;
        uint32 bestStreak;
        uint32 todayPlays;
        uint64 lastDay;
    }

    mapping(address => Player) public players;
    address[] public playerList;
    uint256 public totalPlays;
    uint256 public totalWins;
    uint256 private nonce;

    event Rolled(address indexed player, uint8 guess, uint8 result, bool win, uint32 streak);

    function roll(uint8 guess) external returns (uint8 result, bool win) {
        require(guess >= 1 && guess <= 6, "guess must be 1-6");

        Player storage p = players[msg.sender];
        if (p.plays == 0) {
            playerList.push(msg.sender);
        }

        uint64 today = uint64(block.timestamp / 1 days);
        if (p.lastDay != today) {
            if (p.plays > 0 && p.lastDay + 1 == today) {
                p.streak += 1;
            } else {
                p.streak = 1;
            }
            if (p.streak > p.bestStreak) {
                p.bestStreak = p.streak;
            }
            p.lastDay = today;
            p.todayPlays = 0;
        }

        p.todayPlays += 1;
        p.plays += 1;
        nonce += 1;

        result = uint8(uint256(keccak256(abi.encodePacked(block.prevrandao, block.timestamp, msg.sender, nonce))) % 6) + 1;
        win = (result == guess);
        if (win) {
            p.wins += 1;
            totalWins += 1;
        }
        totalPlays += 1;

        emit Rolled(msg.sender, guess, result, win, p.streak);
    }

    function playerCount() external view returns (uint256) {
        return playerList.length;
    }

    /// @notice Returns a page of players with their plays and wins (for the leaderboard).
    function getPlayers(uint256 start, uint256 count)
        external
        view
        returns (address[] memory addrs, uint32[] memory plays, uint32[] memory wins)
    {
        uint256 len = playerList.length;
        if (start >= len) {
            return (new address[](0), new uint32[](0), new uint32[](0));
        }
        uint256 end = start + count;
        if (end > len) {
            end = len;
        }
        uint256 n = end - start;
        addrs = new address[](n);
        plays = new uint32[](n);
        wins = new uint32[](n);
        for (uint256 i = 0; i < n; i++) {
            address a = playerList[start + i];
            addrs[i] = a;
            plays[i] = players[a].plays;
            wins[i] = players[a].wins;
        }
    }
}
