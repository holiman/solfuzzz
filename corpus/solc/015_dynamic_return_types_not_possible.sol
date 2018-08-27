contract C {
    function f(uint) public returns (string memory);
    function g() public {
        string memory x = this.f(2);
        //00000000000000000000000000000000000000000
        bytes(x).length;
    }
}
