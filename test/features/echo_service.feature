Feature: Echo Service
  A user wishes to use a simple json proxy service for fun and profit
  
  Scenario: Cached Message
    Given a server with an echo service
    And a cached message
    When the user retrieves the message
    Then the server should return the message
    
  Scenario: Uncached Message
    Given a server with an echo service
    And an uncached message
    When the user retrieves the message
    Then the server should return a processing response
    When the user polls the service
    Then the server should return the message
    
  Scenario: Forced query with uncached message
    Given a server with an echo service
    And an uncached message
    When the user force retrieves the message
    Then the server should return the message
    

