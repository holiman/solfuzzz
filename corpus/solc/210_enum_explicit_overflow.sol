    contract test {
        enum ActionChoices { GoLeft, GoRight, GoStraight }
        constructor() public
        {
        }
        function getChoiceExp(uint x) public returns (uint d)
        {
            choice = ActionChoices(x);
            d = uint256(choice);
        }
        function getChoiceFromSigned(int x) public returns (uint d)
        {
            choice = ActionChoices(x);
            d = uint256(choice);
        }
        function getChoiceFromNegativeLiteral() public returns (uint d)
        {
            choice = ActionChoices(-1);
            d = uint256(choice);
        }
        ActionChoices choice;
    }
