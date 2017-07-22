pragma solidity ^0.4.2;

contract Claims {
    enum ClaimStatus { Pending, Accepted, Rejected }

    struct Claim {
        bytes32 hashedDataOfIncident;
        ClaimStatus status;
    }

    bytes32 lastClaimIdHash;

    mapping (bytes32 => Claim) uniqueClaimIdToClaimStruct;
    mapping (bytes32 => uint) relationshipHashToNumberOfClaims;

    mapping (address => uint) customerToNumberOfRejectedClaims;
    mapping (address => uint) customerToNumberOfAcceptedClaims;

    function Claims() {
    }

    function proposeClaim(address company, bytes32 claimDataHash) returns(bytes32, uint) {
        bytes32 customerCompanyHash = sha3(msg.sender, company);
        uint numberOfClaims = relationshipHashToNumberOfClaims[customerCompanyHash];

        numberOfClaims = numberOfClaims + 1;
        relationshipHashToNumberOfClaims[customerCompanyHash] = numberOfClaims;

        bytes32 claimIdHash = sha3(customerCompanyHash, numberOfClaims);
        uniqueClaimIdToClaimStruct[claimIdHash] = Claim(claimDataHash, ClaimStatus.Pending);
        return (claimIdHash, numberOfClaims);
    }

    function getClaimStatus(bytes32 claimIdHash) returns(ClaimStatus) {
        return uniqueClaimIdToClaimStruct[claimIdHash].status;
    }

    function getLastClaimIdHash() returns(bytes32) {
        return lastClaimIdHash;
    }

    function acceptClaim(address customer, bytes32 claimIdHash, uint claimNum) {
        if (uniqueClaimIdToClaimStruct[claimIdHash].status != ClaimStatus.Pending) {
            throw;
        }

        if (sha3(sha3(msg.sender, customer), claimNum) == claimIdHash) {
            uniqueClaimIdToClaimStruct[claimIdHash].status = ClaimStatus.Accepted;

            uint acceptedClaims = customerToNumberOfAcceptedClaims[customer];
            customerToNumberOfAcceptedClaims[customer] = acceptedClaims + 1;
        }
    }

    function rejectClaim(address customer, bytes32 claimIdHash, uint claimNum) {
        if (sha3(sha3(msg.sender, customer), claimNum) == claimIdHash) {
            uniqueClaimIdToClaimStruct[claimIdHash].status = ClaimStatus.Rejected;

            uint rejectedClaims = customerToNumberOfRejectedClaims[customer];
            customerToNumberOfRejectedClaims[customer] = rejectedClaims + 1;
        }
    }

    function getNumberOfClaimsHistory(bytes32 customerCompanyHash) returns(uint) {
        return relationshipHashToNumberOfClaims[customerCompanyHash];
    }

    function getNumberOfAcceptedClaimsHistory(address customer) returns(uint) {
        return customerToNumberOfAcceptedClaims[customer];
    }

    function getNumberOfRejectedClaimsHistory(address customer) returns(uint) {
        return customerToNumberOfRejectedClaims[customer];
    }
}
