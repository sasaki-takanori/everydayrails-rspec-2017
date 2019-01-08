require 'rails_helper'

RSpec.describe Note, type: :model do
  before do
    @user = User.create(
        first_name: "Joe",
        last_name:  "Tester",
        email:      "joetester@example.com",
        password:   "dottle-nouveau-pavilion-tights-furze",
        )

    @project = @user.projects.create(
        name: "Test Project",
        )
  end

  it "有効なノートが作成できること" do
    note = Note.new(
        message: "This is a sample note.",
        user: @user,
        project: @project,
        )
    expect(note).to be_valid
  end

  it "メッセージが空だと無効であること" do
    note = Note.new(message: nil)
    note.valid?
    expect(note.errors[:message]).to include("can't be blank")
  end

  describe "検索結果の検証" do
    before do
      @note1 = @project.notes.create(
          message: "This is the first note.",
          user: @user,
          )
      @note2 = @project.notes.create(
          message: "This is the second note.",
          user: @user,
          )
      @note3 = @project.notes.create(
          message: "First, preheat the oven.",
          user: @user,
          )
    end

    context "検索結果にヒットする時" do
      it "検索文字列に一致するノートを全て返すこと" do
        expect(Note.search("first")).to include(@note1, @note3)
      end

      it "1件だけヒットするノートを返すこと" do
        expect(Note.search("second")).to include(@note2)
      end

    end

    context "検索結果にヒットしない時" do
      it "検索結果が１件も見つからなければからのコレクションを返すこと" do
        # result = Note.search("message")
        # pp result
        expect(Note.search("message")).to be_empty
      end
    end
  end
end
