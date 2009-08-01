Feature: Internal Get
  A user wishes to call other services from within a service
  
  Scenario: Uncached Message
    Given a server 
    And a random message
    When the user polls the "double_echo" service
    Then the server should return the double message

