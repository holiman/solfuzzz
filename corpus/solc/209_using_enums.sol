    contract test {
        enum ActionChoices { GoLeft, GoRight, GoStraight, Sit }
        constructor() public
        {
            choices = ActionChoices.GoStraight;
        }
        function getChoice() public returns (uint d)
        {
            d = uint256(choices);
        }
        ActionChoices choices;
    }
