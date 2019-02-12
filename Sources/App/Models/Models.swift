
//: Playground - noun: a place where people can play


import Vapor

final class BlockchainNode :Content {
    
    var address :String
    
    init(address :String) {
        self.address = address
    }
    
}

final class Transaction : Content {
    
    var from :String
    var to :String
    var amount :Double
    
    init(from :String, to :String, amount :Double) {
        self.from = from
        self.to = to
        self.amount = amount
    }
}

final class Block : Content  {
    
    var index :Int = 0
    var previousHash :String = ""
    var hash :String!
    var nonce :Int
    var winner :String = ""
    var cardNumber :String!
    
    private (set) var transactions :[Transaction] = [Transaction]()
    
    var key :String {
        get {
            
            let transactionsData = try! JSONEncoder().encode(self.transactions)
            let transactionsJSONString = String(data: transactionsData, encoding: .utf8)
            
            return String(self.index) + self.previousHash + String(self.nonce) + String(self.winner) + transactionsJSONString!
        }
    }
    
    func addTransaction(transaction :Transaction) {
        self.transactions.append(transaction)
    }
    
    init() {
        self.nonce = 0
    }
    
}

final class Blockchain : Content  {
    
    private (set) var blocks = [Block]()
    private (set) var nodes = [BlockchainNode]()
    
    init(genesisBlock :Block) {
        addBlock(genesisBlock)
    }
    
    func registerNodes(nodes :[BlockchainNode]) -> [BlockchainNode] {
        self.nodes.append(contentsOf: nodes)
        return self.nodes
    }
    
    func addBlock(_ block :Block) {
        
        if self.blocks.isEmpty {
            block.previousHash = "0000000000000000"
            block.hash = generateHash(for :block)
        }
        
        self.blocks.append(block)
    }
    
    func draw() -> Block {
        let block = getPreviousBlock()
        var winner :String = "No Winner"
        if(block.transactions.count>0){
            let randomIndex = Int(arc4random_uniform(UInt32(block.transactions.count)))
            let winningTransaction = block.transactions[randomIndex]
            winner = winningTransaction.from
        }
        block.winner = winner
        return block
    }
    
    func getNextBlock(transactions :[Transaction]) -> Block {
        
        let block = Block()
        transactions.forEach { transaction in
            block.addTransaction(transaction: transaction)
        }
        var winner :String = "No Winner"
        if(block.transactions.count>0){
            let randomIndex = Int(arc4random_uniform(UInt32(block.transactions.count)))
            let winningTransaction = transactions[randomIndex]
            winner = winningTransaction.from
        }
        
        let previousBlock = getPreviousBlock()
        block.index = self.blocks.count
        block.previousHash = previousBlock.hash
        block.hash = generateHash(for: block)
        block.winner = winner
        return block
        
    }
    
    func addTransactions(transactions :[Transaction]) -> Block {
        
        let block = self.blocks[self.blocks.count - 1]
        transactions.forEach { transaction in
            block.addTransaction(transaction: transaction)
        }
        return block
        
    }
    
    private func getPreviousBlock() -> Block {
        return self.blocks[self.blocks.count - 1]
    }
    
    func generateHash(for block :Block) -> String {
        
        var hash = block.key.sha1Hash()
        
        while(!hash.hasPrefix("00")) {
            block.nonce += 1
            hash = block.key.sha1Hash()
            print(hash)
        }
        
        return hash
    }
    
}

// String Extension
extension String {
    
    func sha1Hash() -> String {
        
        let task = Process()
        task.launchPath = "/usr/bin/shasum"
        task.arguments = []
        
        let inputPipe = Pipe()
        
        inputPipe.fileHandleForWriting.write(self.data(using: String.Encoding.utf8)!)
        
        inputPipe.fileHandleForWriting.closeFile()
        
        let outputPipe = Pipe()
        task.standardOutput = outputPipe
        task.standardInput = inputPipe
        task.launch()
        
        let data = outputPipe.fileHandleForReading.readDataToEndOfFile()
        let hash = String(data: data, encoding: String.Encoding.utf8)!
        return hash.replacingOccurrences(of: "  -\n", with: "")
    }
}















