require 'rails_helper'

RSpec.describe Project, type: :model do
  it "ユーザー単位では重複したプロジェクト名を許可しないこと" do
    user = User.create(
        first_name: "Joe",
        last_name:  "Tester",
        email:      "joetester@example.com",
        password:   "dottle-nouveau-pavilion-tights-furze",
        )

    user.projects.create(
        name: "Test Project",
        )

    new_project = user.projects.build(
        name: "Test Project",
        )

    new_project.valid?
    expect(new_project.errors[:name]).to include("has already been taken")
  end

  it "二人のユーザーが同じプロジェクト名を使うことは許可すること" do
    user = User.create(
        first_name: "Joe",
        last_name:  "Tester",
        email:      "joetester@example.com",
        password:   "dottle-nouveau-pavilion-tights-furze",
        )

    user.projects.create(
        name: "Test Project",
        )

    other_user = User.create(
        first_name: "Jane",
        last_name:  "Tester",
        email:      "janetester@example.com",
        password:   "dottle-nouveau-pavilion-tights-furze",
        )

    other_project = other_user.projects.build(
        name: "Test Project",
        )

    expect(other_project).to be_valid
  end

  describe "遅延ステータス" do
    it "締切日がすぎていれば遅延していること" do
      project = FactoryBot.create(:project, :due_yesterday)
      expect(project).to be_late
    end

    it "締切日が今日なら遅延していないこと" do
      project = FactoryBot.create(:project, :due_today)
      expect(project).to_not be_late
    end

    it "締切日が未来なら遅延していないこと" do
      project = FactoryBot.create(:project, :due_tomorrow)
      expect(project).to_not be_late
    end
  end

  it "複数のメモがついているプロジェクトを作成できること" do
    project = FactoryBot.create(:project, :with_notes, note_count: 5)
    expect(project.notes.length).to eq 5
  end
end
