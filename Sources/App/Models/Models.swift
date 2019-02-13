
//: Playground - noun: a place where people can play


import Vapor
import Random

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
    var card :String = ""
    
    private (set) var transactions :[Transaction] = [Transaction]()
    
    var key :String {
        get {
            
            let transactionsData = try! JSONEncoder().encode(self.transactions)
            let transactionsJSONString = String(data: transactionsData, encoding: .utf8)
            
            return String(self.index) + self.previousHash + String(self.nonce) + String(self.winner) + String(self.card) + transactionsJSONString!
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
    var deck = [String]()
    
    
    
    init(genesisBlock :Block) {
        addBlock(genesisBlock)
        initializeDeck()
    }
    
    func initializeDeck(){
        deck.removeAll()
        deck.append("Ace of Hearts")
        deck.append("2 of Hearts")
        deck.append("3 of Hearts")
        deck.append("4 of Hearts")
        deck.append("5 of Hearts")
        deck.append("6 of Hearts")
        deck.append("7 of Hearts")
        deck.append("8 of Hearts")
        deck.append("9 of Hearts")
        deck.append("10 of Hearts")
        deck.append("Jack of Hearts")
        deck.append("Queen of Hearts")
        deck.append("King of Hearts")
        deck.append("Ace of Clubs")
        deck.append("2 of Clubs")
        deck.append("3 of Clubs")
        deck.append("4 of Clubs")
        deck.append("5 of Clubs")
        deck.append("6 of Clubs")
        deck.append("7 of Clubs")
        deck.append("8 of Clubs")
        deck.append("9 of Clubs")
        deck.append("10 of Clubs")
        deck.append("Jack of Clubs")
        deck.append("Queen of Clubs")
        deck.append("King of Clubs")
        deck.append("Ace of Spades")
        deck.append("2 of Spades")
        deck.append("3 of Spades")
        deck.append("4 of Spades")
        deck.append("5 of Spades")
        deck.append("6 of Spades")
        deck.append("7 of Spades")
        deck.append("8 of Spades")
        deck.append("9 of Spades")
        deck.append("10 of Spades")
        deck.append("Ace of Diamonds")
        deck.append("2 of Diamonds")
        deck.append("3 of Diamonds")
        deck.append("4 of Diamonds")
        deck.append("5 of Diamonds")
        deck.append("6 of Diamonds")
        deck.append("7 of Diamonds")
        deck.append("8 of Diamonds")
        deck.append("9 of Diamonds")
        deck.append("10 of Diamonds")
        deck.append("Jack of Diamonds")
        deck.append("Queen of Diamonds")
        deck.append("King of Diamonds")
        deck.append("Joker")
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
            let winningTransaction = block.transactions.randomElement()!
            winner = winningTransaction.from
            
            block.card = self.deck.randomElement()!
            while self.deck.contains(block.card) {
                if let itemToRemoveIndex = self.deck.index(of: block.card) {
                    self.deck.remove(at: itemToRemoveIndex)
                }
            }
            if(block.card == "Joker"){
                initializeDeck()
            }
        }
        block.winner = winner
        getNextBlock()
        return block
    }
    
    func getNextBlock() {
        let block = Block()
        let previousBlock = getPreviousBlock()
        block.index = self.blocks.count
        block.previousHash = previousBlock.hash
        block.hash = generateHash(for: block)
        addBlock(block)
    }
    
    func getNextBlock(transactions :[Transaction]) -> Block {
        let block = Block()
        transactions.forEach { transaction in
            block.addTransaction(transaction: transaction)
        }
        let previousBlock = getPreviousBlock()
        block.index = self.blocks.count
        block.previousHash = previousBlock.hash
        block.hash = generateHash(for: block)
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















