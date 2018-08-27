contract test {
    constructor() public payable {}
    function a(address receiver) public returns (uint ret) {
        selfdestruct(receiver);
        return 10;
    }
}
