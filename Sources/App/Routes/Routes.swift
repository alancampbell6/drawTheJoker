import Vapor

public func routes(_ router: Router) throws {
    
    let blockchainController = BlockchainController()
    router.get("hello", use: blockchainController.greet)
    router.get("blockchain", use :blockchainController.getBlockchain)
    router.post(Transaction.self, at: "transaction", use: blockchainController.addTransactions)
    router.post(Transaction.self, at: "mine", use: blockchainController.mine)
    router.get("draw", use: blockchainController.draw)
    router.post([BlockchainNode].self, at: "/nodes/register", use: blockchainController.registerNodes)
    router.get("/nodes", use :blockchainController.getNodes)
    router.get("/resolve", use:blockchainController.resolve)
}
