require 'rails_helper'

RSpec.describe "Projects", type: :system do
  let(:user) { FactoryBot.create(:user) }
  let(:project) { FactoryBot.create(:project, owner: user)}
  before do
    sign_in user
  end

  scenario "ユーザーは新しいプロジェクトを作成する" do
    visit root_path

    expect {
      click_link "New Project"
      fill_in "Name", with: "Test Project"
      fill_in "Description", with: "Trying out Capybara"
      click_button "Create Project"

      aggregate_failures do
        expect(page).to have_content "Project was successfully created"
        expect(page).to have_content "Test Project"
        expect(page).to have_content "Owner: #{user.name}"
      end
    }.to change(user.projects, :count).by(1)
  end

  scenario "ユーザーはプロジェクトを完了する" do
    visit project_path(project)

    expect(page).to_not have_content "Completed"

    click_button "Complete"

    expect(project.reload.completed?).to be true
    expect(page).to \
      have_content "Congratulations, this project is complete!"
    expect(page).to have_content "Completed"
    expect(page).to_not have_button "Complete"
  end

  scenario "ユーザーはプロジェクトを編集する" do
    visit edit_project_path(project)

    fill_in "Name", with: "Edited Project"
    fill_in "Description", with: "Edited Description"
    click_button "Update Project"

    aggregate_failures do
      expect(page).to have_content "Project was successfully updated"
      expect(page).to have_content "Edited Project"
      expect(page).to have_content "Owner: #{user.name}"
    end
  end

  scenario "ユーザーはプロジェクトの編集をキャンセルする", js: true do
    visit edit_project_path(project)

    fill_in "Name", with: "Edited Project"
    fill_in "Description", with: "Edited Description"
    click_link "Cancel"
    page.driver.browser.switch_to.alert.accept

    aggregate_failures do
      expect(page).to have_content project.name
      expect(page).to have_content "Owner: #{user.name}"
    end
  end
end
