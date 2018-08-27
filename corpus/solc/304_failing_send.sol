contract Helper {
    uint[] data;
    function () external {
        data[9]; // trigger exception
    }
}
contract Main {
    constructor() public payable {}
    function callHelper(address _a) public returns (bool r, uint bal) {
        r = !_a.send(5);
        bal = address(this).balance;
    }
}
