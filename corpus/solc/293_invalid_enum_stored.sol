contract C {
    enum X { A, B }
    X public x;

    function test_store() public returns (uint) {
        X garbled = X.A;
        assembly {
            garbled := 5
        }
        x = garbled;
        return 1;
    }
    function test_store_ok() public returns (uint) {
        x = X.A;
        return 1;
    }
}
