pragma solidity ^0.4.2;

contract Claims {
    enum ClaimStatus { Pending, Accepted, Rejected }

    struct Claim {
        bytes32 hash;
        ClaimStatus status;
        string amount;
    }

    mapping (bytes32 => Claim) uniqueClaimIdToClaimStruct;
    mapping (bytes32 => uint) relationshipHashToNumberOfClaims;

    mapping (address => uint) customerToNumberOfRejectedClaims;
    mapping (address => uint) customerToNumberOfAcceptedClaims;

    function Claims() {
    }

    function proposeClaim(address company, bytes32 claimDataHash, string amount) returns(bytes32, uint) {
        bytes32 customerCompanyHash = sha3(msg.sender, company);
        uint numberOfClaims = relationshipHashToNumberOfClaims[customerCompanyHash];

        numberOfClaims = numberOfClaims + 1;
        relationshipHashToNumberOfClaims[customerCompanyHash] = numberOfClaims;

        bytes32 claimIdHash = sha3(customerCompanyHash, numberOfClaims);
        uniqueClaimIdToClaimStruct[claimIdHash] = Claim(claimDataHash, ClaimStatus.Pending, amount);
        return (claimIdHash, numberOfClaims);
    }

    function getLastClaimNumber(bytes32 customerCompanyHash) constant returns(uint) {
        return relationshipHashToNumberOfClaims[customerCompanyHash];
    }

    function calculateCustomerCompanyHash(address customer, address company) constant returns(bytes32) {
        return sha3(customer, company);
    }

    function calculateClaimIdHash(bytes32 customerCompanyHash, uint claimNum) constant returns(bytes32) {
        return sha3(customerCompanyHash, claimNum);
    }

    function getClaimStatus(bytes32 claimIdHash) constant returns(ClaimStatus) {
        return uniqueClaimIdToClaimStruct[claimIdHash].status;
    }

    function getClaimAmount(bytes32 claimIdHash) constant returns(string) {
        return uniqueClaimIdToClaimStruct[claimIdHash].amount;
    }

    function acceptClaim(address customer, bytes32 claimIdHash, uint claimNum) {
        if (uniqueClaimIdToClaimStruct[claimIdHash].status != ClaimStatus.Pending) {
            throw;
        }
        if (sha3(sha3(customer, msg.sender), claimNum) == claimIdHash) {
            uniqueClaimIdToClaimStruct[claimIdHash].status = ClaimStatus.Accepted;
            uint acceptedClaims = customerToNumberOfAcceptedClaims[customer];
            customerToNumberOfAcceptedClaims[customer] = acceptedClaims + 1;
        }
    }

    function rejectClaim(address customer, bytes32 claimIdHash, uint claimNum) {
        if (uniqueClaimIdToClaimStruct[claimIdHash].status != ClaimStatus.Pending) {
            throw;
        }
        if (sha3(sha3(customer, msg.sender), claimNum) == claimIdHash) {
            uniqueClaimIdToClaimStruct[claimIdHash].status = ClaimStatus.Rejected;
            uint rejectedClaims = customerToNumberOfRejectedClaims[customer];
            customerToNumberOfRejectedClaims[customer] = rejectedClaims + 1;
        }
    }

    function getNumberOfClaimsHistory(bytes32 customerCompanyHash) constant returns(uint) {
        return relationshipHashToNumberOfClaims[customerCompanyHash];
    }

    function getNumberOfAcceptedClaimsHistory(address customer) constant returns(uint) {
        return customerToNumberOfAcceptedClaims[customer];
    }

    function getNumberOfRejectedClaimsHistory(address customer) constant returns(uint) {
        return customerToNumberOfRejectedClaims[customer];
    }
}
