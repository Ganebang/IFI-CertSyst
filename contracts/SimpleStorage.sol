pragma solidity >=0.4.21 <0.7.0;


/**
  *@title smart contract for IFI Certificat Management System
  *@dev Prototyp : Minimum Viable Product
  *@author AMALA Gane Kwada
*/

contract SimpleStorage {
  struct Cert{
    uint id;
    string recipient;
    string certIpfsHash;
    bool valid;
  }
  Cert[] certificats;
  uint public certCount;
  address public issuer;
  
  // @dev Restruction for certificate issuer
    modifier onlyIssuer() {
        require(msg.sender == issuer);
        _;
    }
  /**
    *@dev Registrate the certificate
    *@param _recipient recipient name ou address
    *@param _certIpfsHash hash generate by IPFS
  */
  function registerCert(string memory _recipient, string memory _certIpfsHash) public onlyIssuer{
    certCount++;
    certificats.push(Cert(certCount, _recipient, _certIpfsHash, true));
  }
  /**
    *@dev Check the validity the certificate
    *@param _code ipfs hash or qrCode
  */
  function checkCert(string memory code) public view returns (bool) {
    uint counter = 0;
    bool verified = false;
    while(counter<certCount){
      if((keccak256(abi.encodePacked(certificats[counter].certIpfsHash))==keccak256(abi.encodePacked(code)))&&
      certificats[counter].valid==true){
        verified = true;
      } else {
        verified = false;
      }
      counter ++;
    }
    return verified; 
  }
  /**
    *@dev Change validity the certificate
    *@param _code : ipfs hash or qrCode
  */
  function revokeCert(string memory code) public onlyIssuer{
    uint counter = 0;
    while(counter<certCount){
      if((keccak256(abi.encodePacked(certificats[counter].certIpfsHash))==keccak256(abi.encodePacked(code)))){
        certificats[counter].valid=false;
      }
      counter ++;
    }

  }

  /**
    *@dev Get certificate
    *@param _code : ipfs hash or qrCode
  */
  function getCert(string memory code) public view returns (string memory, string memory, bool){
    uint counter = 0;
    while(counter<certCount){
      if((keccak256(abi.encodePacked(certificats[counter].certIpfsHash))==keccak256(abi.encodePacked(code)))){
        return (certificats[counter].recipient, certificats[counter].certIpfsHash, certificats[counter].valid);
      }
      counter ++;
    }
  }

}
