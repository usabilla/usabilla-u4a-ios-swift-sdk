//
//  ChunkTest.swift
//  UsabillaFeedbackForm
//
//  Created by Giacomo Pinato on 19/05/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Quick
import Nimble


class ChunkTest: QuickSpec {
    
    
    
    override func spec() {
        
        let stringToChunk = "abcdefghilmnopqrst"
        
        beforeSuite {
            
        }
        
        describe("chunking a string") {
            beforeEach {
                //Only for this describe
            }
            
            it("should correctly divide by 3"){
                let stringChunks = stringToChunk.divideInChunksOfSize(3)
                expect(stringChunks.count).to(equal(6))
                expect(stringChunks[5].characters.count).to(equal(3))
                expect(stringChunks[0].characters.count).to(equal(3))
                expect(stringChunks[5]).to(equal("rst"))
                expect(stringChunks[0]).to(equal("abc"))
            }
            
            it("should correctly divide by 4"){
                let stringChunks = stringToChunk.divideInChunksOfSize(4)
                expect(stringChunks.count).to(equal(5))
                expect(stringChunks[4].characters.count).to(equal(2))
                expect(stringChunks[0].characters.count).to(equal(4))
                expect(stringChunks[4]).to(equal("st"))
                expect(stringChunks[0]).to(equal("abcd"))
            }
            
            it("should correctly divide by 5"){
                let stringChunks = stringToChunk.divideInChunksOfSize(5)
                expect(stringChunks.count).to(equal(4))
                expect(stringChunks[3].characters.count).to(equal(3))
                expect(stringChunks[0].characters.count).to(equal(5))
                expect(stringChunks[3]).to(equal("rst"))
                expect(stringChunks[0]).to(equal("abcde"))
            }
        }
    }
}
