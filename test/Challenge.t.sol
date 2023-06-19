// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../src/Challenge.sol";

contract ChallengeTest is Test {
    Challenge public challenge;

    event AnswerRevealed(address indexed participant, string answer);
    event WinnerRevealed(address indexed winner, string winningAnswer);
    function setUp() public {
        challenge = new Challenge();
    }

    function testCommitAnswer() public {
        // Commit an answer using the commit function.
        challenge.commit(keccak256(abi.encodePacked("test1")));
        //Verify that the commitment is recorded correctly by checking the user's commitment in the users array.
    }

    function testRevealAnswer() public {
        // Start the reveal phase using the startRevealPhase function

        // User reveal an answer using the reveal function.

        // Verify that the revealed answer matches the commitment hash and is recorded correctly in the users array.
    }

    function testGetAnswer() public {
        // Get the answer of a participant using the getAnswer function.

        // Verify that the returned answer matches the revealed answer of the participant.
    }

    function testRevealWinner() public {
        // Commit challenge with correct answer
        vm.prank(address(2));
        challenge.commit(keccak256(abi.encodePacked("correct answer")));
        // Start the reveal phase
        challenge.startRevealPhase();
        // Verify that the winner and the winning answer are recorded correctly.
        vm.expectEmit();
        emit AnswerRevealed(address(2), "correct answer");
        // Reveal the winner using the revealWinner function with a valid secret hash.
        vm.prank(address(2));
        challenge.reveal("correct answer");
    }

    function testRevealWinnerWithoutStartingPhase() public {
        // Verify that the function reverts with the appropriate error message.
        vm.expectRevert("Reveal phase has not started yet");
        // Attempt to reveal the winner using the revealWinner function before starting the reveal phase.
        challenge.reveal("test");
    }

    function testRevealWinnerWithoutCommits() public {
        // Start the reveal phase using the startRevealPhase function.
        challenge.startRevealPhase();
        // Verify that the function reverts with the appropriate error message.
        vm.expectRevert("No commitments found to declare winner");
        // Attempt to reveal the winner using the revealWinner function when no commitments exist.
        challenge.revealWinner(keccak256(abi.encodePacked("test1")));
    }

    function testRevealWinnerIncorrectSecretHash() public {
        // Commit an incorrect answer
        vm.prank(address(1));
        challenge.commit(keccak256(abi.encodePacked("incorrect answer")));
        // Start the reveal phase using the startRevealPhase function.
        challenge.startRevealPhase();
        // Reveal an answer using the reveal function.
        vm.prank(address(1));
        challenge.reveal("incorrect answer");
        //  Verify that the function reverts with the appropriate error message.
        vm.expectRevert("No winner found");
        // Attempt to reveal the winner using the revealWinner function with an correct secret hash.
        challenge.revealWinner(keccak256(abi.encodePacked("correct answer")));
    }

    function testRevealWinnerMultipleTimes() public {
        // Commit some answers
        vm.prank(address(1));
        challenge.commit(keccak256(abi.encodePacked("answer 1")));
        vm.prank(address(2));
        challenge.commit(keccak256(abi.encodePacked("answer 2")));
        //  Start the reveal phase using the startRevealPhase function.
        challenge.startRevealPhase();
        //  Reveal an answer using the reveal function.
        vm.prank(address(1));
        vm.expectEmit();
        emit AnswerRevealed(address(1), "answer 1");
        challenge.reveal("answer 1");
        vm.prank(address(2));
        vm.expectEmit();
        emit AnswerRevealed(address(2), "answer 2");
        challenge.reveal("answer 2");
        //  Reveal the winner using the revealWinner function.
        vm.expectEmit();
        emit WinnerRevealed(address(1), "answer 1");
        challenge.revealWinner(keccak256(abi.encodePacked("answer 1")));
        //  Verify that the function reverts with the appropriate error message.
        vm.expectRevert("Winner already revealed");
        //  Attempt to reveal the winner again.
        challenge.revealWinner(keccak256(abi.encodePacked("again")));
    }

    function testCommitAfterRevealPhaseStarted() public {
        //  Start the reveal phase using the startRevealPhase function.

        //  Attempt to commit an answer using the commit function.

        //  Verify that the function reverts with the appropriate error message.
    }

    function testStartRevealPhase() public {
        //  Attempt to start the reveal phase using a non-owner account.

        //  Verify that the function reverts with the appropriate error message.
    }
}
