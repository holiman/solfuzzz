contract test {
    constructor() payable public {}
    function a(address addr, uint amount) public returns (uint ret) {
        addr.send(amount);
        return address(this).balance;
    }
}
