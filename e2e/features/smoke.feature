Feature: smoke tests

Verify that the site is up and that the tests are connecting properly.

Scenario: home page displays
  When I go to the homepage
  Then I expect the homepage to have loaded