// DO NOT MODIFY
// Automatically generated by Arkana (https://github.com/rogerluan/arkana)

import Foundation
import XCTest
@testable import ArkanaKeys

final class KeysTests: XCTestCase {
    private var salt: [UInt8] = [
        0xee, 0xae, 0x95, 0x69, 0xc1, 0xc3, 0xb9, 0x1b, 0x37, 0xc7, 0xc4, 0xdc, 0x30, 0xac, 0x88, 0x40, 0xbc, 0x97, 0xfa, 0x52, 0x34, 0xd1, 0xa0, 0xec, 0xe0, 0x4, 0xd4, 0xf9, 0xf1, 0xb5, 0x32, 0x36, 0xee, 0x10, 0x1, 0xd0, 0xdd, 0x6a, 0x77, 0xf0, 0xfa, 0xed, 0xf0, 0xe5, 0, 0x7f, 0x90, 0xea, 0xc1, 0x24, 0x12, 0x8c, 0x92, 0x7, 0x6e, 0xd1, 0x93, 0xbf, 0xb3, 0xcd, 0x5d, 0x39, 0x9b, 0x79
    ]

    func test_decodeRandomHexKey_shouldDecode() {
        let encoded: [UInt8] = [
            0xdb, 0x97, 0xf6, 0xa, 0xf4, 0xf5, 0x8d, 0x29, 0x51, 0xf5, 0xf7, 0xe9, 0x3, 0xcf, 0xbc, 0x71, 0x89, 0xf6, 0x9f, 0x6b, 0x50, 0xe6, 0x92, 0xdc, 0x82, 0x3c, 0xec, 0xcf, 0xc5, 0x87, 0xa, 0, 0xd6, 0x72, 0x33, 0xe1, 0xbe, 0x58, 0x4f, 0xc6, 0xc9, 0x8b, 0xc6, 0x87, 0x65, 0x4e, 0xf6, 0x88, 0xf1, 0x17, 0x24, 0xba, 0xf1, 0x66, 0x5f, 0xe5, 0xa3, 0xdd, 0x86, 0xf9, 0x6d, 0x5b, 0xa8, 0x40, 0x8f, 0x9d, 0xa2, 0x5d, 0xf4, 0xa5, 0x89, 0x23, 0x3, 0xa1, 0xf0, 0xe5, 0x2, 0x9d, 0xed, 0x26, 0x8c, 0xa2, 0x9b, 0x6b, 0x2, 0xe5, 0xc5, 0xd8, 0xd9, 0x3d, 0xb2, 0xcf, 0x97, 0xd1, 0x57, 0x57, 0xdc, 0x28, 0x64, 0xb1, 0xeb, 0x5e, 0x41, 0x95, 0x9c, 0x89, 0xc6, 0x83, 0x35, 0x4d, 0xa3, 0xd8, 0xf8, 0x14, 0x2b, 0xbe, 0xa1, 0x64, 0xc, 0xe9, 0xf7, 0x8b, 0xd0, 0xae, 0x68, 0, 0xff, 0x1d
        ]
        XCTAssertEqual(Keys.decode(encoded: encoded, cipher: salt), "59cc5642f2353c415ae9d720b88642868b21c2863f6be1fb0366ca140b540b39a3745f084f4921ef05a964e499f6fdea28ea646efd6f523290923cb8d4cc59dd")
    }

    func test_decodeRandomBase64Key_shouldDecode() {
        let encoded: [UInt8] = [
            0xac, 0xc2, 0xe3, 0x21, 0x84, 0x8b, 0xdb, 0x2c, 0x67, 0x9e, 0xb6, 0xea, 0, 0xf9, 0xcb, 0x18, 0xd0, 0xce, 0x8f, 0x7, 0x56, 0xe8, 0xf0, 0x82, 0xa9, 0x37, 0x85, 0x80, 0xde, 0xd9, 0x51, 0x45, 0x96, 0x53, 0x34, 0xff, 0x87, 0x29, 0x43, 0x87, 0x8d, 0xac, 0x95, 0xd5, 0x50, 0x19, 0xc6, 0x85, 0xf5, 0x14, 0x63, 0xb8, 0xd7, 0x43, 0x5a, 0xa0, 0xe3, 0xc8, 0xda, 0xf4, 0x2b, 0x40, 0xa3, 0x48, 0xa7, 0xff, 0xe4, 0xc, 0xf3, 0x97, 0xfa, 0x2f, 0x73, 0xa1, 0xab, 0xe8, 0x71, 0xc2, 0xe7, 0x31, 0xd9, 0xfe, 0xb0, 0x30, 0x57, 0x80, 0x9d, 0xd1
        ]
        XCTAssertEqual(Keys.decode(encoded: encoded, cipher: salt), "BlvHEHb7PYr60UCXlYuUb9PnI3Qy/lcsxC5/ZC4wwAe0PfVo40q4ED4qpwi9vy81IQqe2TC4Dfo4AnoqeiJbcQ==")
    }

    func test_decodeUUIDKey_shouldDecode() {
        let encoded: [UInt8] = [
            0x8d, 0x9c, 0xa5, 0xa, 0xf3, 0xf5, 0xda, 0x2e, 0x1a, 0xf6, 0xf3, 0xe5, 0x1, 0x81, 0xbc, 0x22, 0x8e, 0xaf, 0xd7, 0x33, 0x2, 0xe6, 0x97, 0xc1, 0xd9, 0x30, 0xb1, 0xcf, 0xc4, 0xd6, 0x56, 0x6, 0xdb, 0x71, 0x38, 0xe1
        ]
        XCTAssertEqual(Keys.decode(encoded: encoded, cipher: salt), "c20c26c5-1791-4b28-a677-94e65cd05a91")
    }
}
