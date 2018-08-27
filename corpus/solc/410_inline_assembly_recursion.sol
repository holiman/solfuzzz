contract C {
    function f(uint a) public returns (uint b) {
        assembly {
            function fac(n) -> nf {
                switch n
                case 0 { nf := 1 }
                case 1 { nf := 1 }
                default { nf := mul(n, fac(sub(n, 1))) }
            }
            b := fac(a)
        }
    }
}
