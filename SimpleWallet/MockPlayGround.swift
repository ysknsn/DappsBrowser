//
//  MockPlayGround.swift
//  WalletWithAPI
//
//  Created by Akifumi Fujita on 2018/08/15.
//  Copyright © 2018年 Akifumi Fujita. All rights reserved.
//

import Foundation
import BitcoinKit

struct MockPlayGround {
    func verifyScript() -> Bool {
        do {
            let result = try MockHelper.testScriptWithSingleKey(lockScript: complexLockScript, unlockScriptBuilder: ComplexUnlockScriptBuilder(), hashType: SighashType.BCH.ALL, key: MockKey.keyB)
            return result
        } catch let error {
            print("Script fail: \(error)")
            return false
        }
    }

    struct UnlockScriptBuilder: SingleKeyScriptBuilder {
        func build(with sigWithHashType: Data, key: MockKey) -> Script {
            return try! Script()
                .appendData(sigWithHashType)
                .appendData(key.pubkey.raw)
        }
    }

    var lockScript: Script {
        let lockScript = try! Script()
            .append(.OP_DUP)
            .append(.OP_HASH160)
            .appendData(MockKey.keyA.pubkeyHash)
            .append(.OP_EQUALVERIFY)
            .append(.OP_CHECKSIG)
        return lockScript
    }
    
    struct ComplexUnlockScriptBuilder: SingleKeyScriptBuilder {
        func build(with sigWithHashType: Data, key: MockKey) -> Script {
            return try! Script()
                .appendData(sigWithHashType)
                .appendData(key.pubkey.raw)
                .append(.OP_FALSE)
        }
    }
    
    var complexLockScript: Script {
        let lockScript = try! Script()
            .append(.OP_IF)
                .append(.OP_DUP)
                .append(.OP_HASH160)
                .appendData(MockKey.keyA.pubkeyHash)
            .append(.OP_ELSE)
                .append(.OP_DUP)
                .append(.OP_HASH160)
                .appendData(MockKey.keyB.pubkeyHash)
            .append(.OP_ENDIF)
            .append(.OP_EQUALVERIFY)
            .append(.OP_CHECKSIG)
        return lockScript
    }
}
