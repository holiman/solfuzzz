contract C {
    function f(uint a) public returns (uint b) {
        assembly {
            switch a
            case 1 { b := 8 }
            case 2 { b := 9 }
            default { b := 2 }
        }
    }
}
