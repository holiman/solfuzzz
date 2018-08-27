    contract C {
        function f() external returns (bool) {
            return address(0x4242).staticcall("");
        }
    }
