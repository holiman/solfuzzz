contract test {
    /// @author Alex
    /// @param a the parameter a is really nice and very useful
    /// @param second the second parameter is not very useful, it just provides additional confusion
    constructor(uint a, uint second) public { }
    /// @dev Multiplies a number by 7 and adds second parameter
    /// @param a Documentation for the first parameter starts here.
    /// Since it's a really complicated parameter we need 2 lines
    /// @param second Documentation for the second parameter
    /// @return The result of the multiplication
    /// and cookies with nutella
    function mul(uint a, uint second) public returns(uint d) {
        return a * 7 + second;
    }
}
