//SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract PizzaToken is ERC20, AccessControl {
    address public admin;
    bool public paused;

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");

    constructor(string memory name_, string memory symbol_)
        ERC20(name_, symbol_)
    {
        _mint(msg.sender, 10000 * 10**18);
        admin = msg.sender;
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
    }

    modifier setPaused() {
        require(paused == false, "Contract is paused");
        _;
    }

    modifier onlyAdmin() {
        require(_msgSender() == admin, "Not admin");
        _;
    }

    function getPauserRole() public pure returns (bytes32) {
        return PAUSER_ROLE;
    }

    function Pause(bool _paused) public {
        require(_msgSender() == admin, "Only admin can set Pause");
        require(hasRole(PAUSER_ROLE, _msgSender()), "Caller is not a pauser");
        paused = _paused;
    }

    function mint(address to, uint256 amount) external onlyAdmin {
        _mint(to, amount);
        require(hasRole(MINTER_ROLE, _msgSender()), "Caller is not a minter");
    }

    function grantRole(bytes32 role, address account)
        public
        virtual
        override
        onlyRole(getRoleAdmin(role))
    {
        require(_msgSender() == admin, "Only admin can grant Role");
        super.grantRole(role, account);
    }

    function hasRoles(bytes32 _role, address _account)
        public
        view
        returns (bool)
    {
        return (super.hasRole(_role, _account));
    }

    function burn(address account, uint256 amount) public virtual {
        require(hasRole(BURNER_ROLE, _msgSender()), "Caller is not a burner");
        super._burn(account, amount);
    }

    function transfer(address recipient, uint256 amount)
        public
        virtual
        override
        onlyAdmin
        setPaused
        returns (bool)
    {
        super.transfer(recipient, amount);
        return true;
    }

    function allowance(address owner, address spender)
        public
        view
        virtual
        override
        setPaused
        returns (uint256)
    {
        return super.allowance(owner, spender);
    }

    function approve(address spender, uint256 amount)
        public
        virtual
        override
        onlyAdmin
        setPaused
        returns (bool)
    {
        super.approve(spender, amount);
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue)
        public
        virtual
        override
        onlyAdmin
        returns (bool)
    {
        super.increaseAllowance(spender, addedValue);
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue)
        public
        virtual
        override
        onlyAdmin
        returns (bool)
    {
        super.decreaseAllowance(spender, subtractedValue);
        return true;
    }

    function totalSupply() public view virtual override returns (uint256) {
        return super.totalSupply();
    }
}
