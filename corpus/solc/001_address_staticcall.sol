contract C {
    function i() view public returns (bool) {
        return address(0x4242).staticcall("");
    }
}
