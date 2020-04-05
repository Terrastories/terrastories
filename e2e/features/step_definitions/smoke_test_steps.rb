When("I go to the homepage") do
  app.go_to_homepage
end

Then("I expect the homepage to have loaded") do
  expect(app.current_page).to be_a(Pages::Home)
  expect(app.current_page).to be_displayed
  expect(app.current_page.title).to eq("Terrastories")
end
