# @version ^0.2.2
# Plataforma de crowdFunding v0.1.0

struct Passport:
  donor: address # Dono do ingresso
  donation: uint256 # Valor do ingresso
  valid: bool # Indicação se retirou ou nao


donors: public(HashMap[address, Passport])

owner: address
goal: public(uint256)
raised: public(uint256)
timeLimit: public(uint256)
deadline: public(uint256)

@external
def __init__(goal: uint256, timeLimit:uint256):
    # Guarda o Endereço do dono do contrato na variável
    self.owner = msg.sender
    self.goal = goal
    self.raised = 0
    self.deadline = block.timestamp + timeLimit
    self.timeLimit = timeLimit

@external # Habilita para interação externa (função chamável)
@payable # Habilita o recebimento de valores pela função
def donate():
   

    assert self.deadline > block.timestamp
    # Testa se o evento ainda não acabou
    
    
    self.donors[msg.sender].donation += msg.value
    self.donors[msg.sender].donor = msg.sender
    self.donors[msg.sender].valid = True
    self.raised += msg.value
    
    
@external
def cancelDonation():

    assert self.raised < self.goal
    # Testa se o comprador já comprou
    assert self.donors[msg.sender].valid
    
    # Testa se o evento ainda não acabou
    assert self.deadline < block.timestamp
    
    # Anula a compra
    self.donors[msg.sender].valid = False
    # Subtrai 1 do contador de ingressos

    # Devolve 80% do dinheiro (todos os valores tem que ser inteiros)
    send(msg.sender, self.donors[msg.sender].donation)

@external
def finish():
    # Testa se é o dono do contrato
    assert msg.sender == self.owner

    assert self.raised >= self.goal
    
    # Sinaliza e saca o dinheiro do contrato
    send(self.owner, self.balance)