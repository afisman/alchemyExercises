pragma solidity ^0.8.4;

contract Contract {
    function sumAndAverage(
        uint p1,
        uint p2,
        uint p3,
        uint p4
    ) external pure returns (uint sum, uint average) {
        sum = p1 + p2 + p3 + p4;
        average = sum / 4;
    }
}
