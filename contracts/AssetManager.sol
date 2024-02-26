// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract AssetManager {

    /*
    First a file must be uploaded from the front-end
    to IPFS, after obtaining its unique path the record
    will be created here;
    */
    struct Asset {
        uint256 id;
        string name;
        string description;
        string filePath;
        string fileType;
        uint256 fileSize;
        address owner;
    }

    event AssetUploaded(
        uint256 id,
        string name,
        string description,
        string filePath,
        string fileType,
        uint256 fileSize,
        address owner
    );

    uint256[] public assetIds;
    uint256 public assetCount = 0;

    // The porpouse of this mapping is to behave as 
    // a "catalog" of the assets uploaded;
    mapping(uint256 => Asset) public assets;

    function uploadAsset(
        string memory _name,
        string memory _description,
        string memory _filePath,
        string memory _fileType,
        uint256 _fileSize
    ) public {

        require(bytes(_name).length > 0);
        require(bytes(_description).length > 0);
        require(bytes(_filePath).length > 0);

        assetCount++;

        assets[assetCount] = Asset(
            assetCount,
            _name,
            _description,
            _filePath,
            _fileType,
            _fileSize,
            payable(msg.sender)
        );

        assetIds.push(assetCount);

        emit AssetUploaded(
            assetCount,
            _name,
            _description,
            _filePath,
            _fileType,
            _fileSize,
            payable(msg.sender)
        );
    }

    function removeAsset(
        uint256 _assetId
    ) public {
        
        require(
            msg.sender == assets[_assetId].owner, 
            "You're not the owner of this asset"
        );
        delete assets[_assetId];

        for (uint256 i = 0; i < assetIds.length; i++) {
            if (assetIds[i] == _assetId) {
                assetIds[i] = assetIds[assetIds.length - 1];
                assetIds.pop();
                break;
            }
        }
    }

}