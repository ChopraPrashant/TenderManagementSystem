// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TenderManagement {
    struct Tender {
        uint id;
        string description;
        uint bidAmount;
        address payable contractor;
        bool isClosed;
    }
    
    uint public tenderCounter = 0;
    mapping(uint => Tender) public tenders;
    
    event TenderCreated(uint id, string description, uint bidAmount);
    event TenderBidPlaced(uint id, address contractor, uint bidAmount);
    event TenderClosed(uint id, address contractor);

    function createTender(string memory _description) public {
        tenderCounter++;
        tenders[tenderCounter] = Tender(tenderCounter, _description, 0, payable(address(0)), false);
        emit TenderCreated(tenderCounter, _description, 0);
    }
    
    function placeBid(uint _tenderId, uint _bidAmount) public {
        Tender storage tender = tenders[_tenderId];
        require(!tender.isClosed, "Tender is closed for bidding");
        require(_bidAmount > 0, "Bid amount should be greater than zero");
        
        tender.contractor = payable(msg.sender);
        tender.bidAmount = _bidAmount;
        
        emit TenderBidPlaced(_tenderId, msg.sender, _bidAmount);
    }
    
    function closeTender(uint _tenderId) public {
        Tender storage tender = tenders[_tenderId];
        require(!tender.isClosed, "Tender is already closed");
        tender.isClosed = true;
        
        emit TenderClosed(_tenderId, tender.contractor);
    }
}
