contract test {
    mapping(uint256 => bytes4) public to_string_map;
    mapping(uint256 => bool) public to_bool_map;
    mapping(uint256 => uint256) public to_uint_map;
    mapping(uint256 => mapping(uint256 => uint256)) public to_multiple_map;
    constructor() public {
        to_string_map[42] = "24";
        to_bool_map[42] = false;
        to_uint_map[42] = 12;
        to_multiple_map[42][23] = 31;
    }
}
