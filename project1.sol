// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LessonPlanMarketplace {
    address public owner;
    uint256 public lessonPlanCount = 0;

    struct LessonPlan {
        uint256 id;
        address payable seller;
        string title;
        string description;
        uint256 price;
        bool sold;
    }

    mapping(uint256 => LessonPlan) public lessonPlans;

    event LessonPlanListed(
        uint256 id,
        address seller,
        string title,
        uint256 price
    );

    event LessonPlanPurchased(
        uint256 id,
        address buyer,
        string title
    );

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function listLessonPlan(
        string memory _title,
        string memory _description,
        uint256 _price
    ) public {
        require(_price > 0, "Price must be greater than 0");

        lessonPlanCount++;
        lessonPlans[lessonPlanCount] = LessonPlan(
            lessonPlanCount,
            payable(msg.sender),
            _title,
            _description,
            _price,
            false
        );

        emit LessonPlanListed(lessonPlanCount, msg.sender, _title, _price);
    }

    function purchaseLessonPlan(uint256 _id) public payable {
        LessonPlan storage lessonPlan = lessonPlans[_id];
        require(_id > 0 && _id <= lessonPlanCount, "Invalid lesson plan ID");
        require(msg.value == lessonPlan.price, "Incorrect price");
        require(!lessonPlan.sold, "Lesson plan already sold");

        lessonPlan.seller.transfer(msg.value);
        lessonPlan.sold = true;

        emit LessonPlanPurchased(_id, msg.sender, lessonPlan.title);
    }

    function getLessonPlan(uint256 _id)
        public
        view
        returns (
            uint256,
            address,
            string memory,
            string memory,
            uint256,
            bool
        )
    {
        LessonPlan memory lessonPlan = lessonPlans[_id];
        return (
            lessonPlan.id,
            lessonPlan.seller,
            lessonPlan.title,
            lessonPlan.description,
            lessonPlan.price,
            lessonPlan.sold
        );
    }
}

