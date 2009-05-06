Feature: Error hanlding
  A user wishes to be informed of errors so that they can debug and recover from them them
  
  Scenario: Unknown service
    Given a server
    When the user requests an unkown service
    Then the server should return a 404 response
    
  Scenario: Exception in service
    Given a server
    And an uncached message
    When the user polls the exception throwing service
    Then the server should eventualy return an error response
  
