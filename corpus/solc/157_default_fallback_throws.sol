contract A {
    function f() public returns (bool) {
        return address(this).call("");
    }
}
