// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.23;

import {Test} from "forge-std/Test.sol";

import {MockPortal} from "omni/core/test/utils/MockPortal.sol";

import {GreetingBook} from "src/GreetingBook.sol";

contract GreetingBookTest is Test {
    address user = address(0x123);
    uint64 gasLimit = 120_000;
    uint64 mockSourceChainId = 1;
    address mockSourceXapp = address(0x456);

    MockPortal portal;
    GreetingBook greetingBook;

    function setUp() public {
        portal = new MockPortal();
        greetingBook = new GreetingBook(address(portal));
    }

    function testXGreet() public {
        string memory greeting = "Hello, world!";
        portal.mockXCall(
            mockSourceChainId,
            mockSourceXapp,
            address(greetingBook),
            abi.encodeCall(GreetingBook.greet, (user, greeting)),
            gasLimit
        );
        GreetingBook.Greeting memory lastGreet;
        (lastGreet.user, lastGreet.message, lastGreet.sourceChainId, lastGreet.timestamp) = greetingBook.lastGreet();
        assertEq(lastGreet.message, greeting);
    }

    function testGreetFailSameChain() public {
        string memory greeting = "Hello, world!";

        vm.expectRevert();
        greetingBook.greet(user, greeting);
    }
}
