require 'rails_helper'

RSpec.describe Note, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:project) { FactoryBot.create(:project, owner: user) }

  it "有効なノートが作成できること" do
    note = Note.new(
        message: "This is a sample note.",
        user: user,
        project: project,
        )
    expect(note).to be_valid
  end

  it "メッセージが空だと無効であること" do
    note = Note.new(message: nil)
    note.valid?
    expect(note.errors[:message]).to include("can't be blank")
  end

  describe "検索結果の検証" do
    let!(:note1) {
      FactoryBot.create(:note,
                        project: project,
                        user: user,
                        message: "This is the first note.",
                        )
    }

    let!(:note2) {
      FactoryBot.create(:note,
                        project: project,
                        user: user,
                        message: "This is the second note.",
                        )
    }

    let!(:note3) {
      FactoryBot.create(:note,
                        project: project,
                        user: user,
                        message: "First, preheat the oven.",
                        )
    }

    context "検索結果にヒットする時" do
      it "検索文字列に一致するノートを全て返すこと" do
        expect(Note.search("first")).to include(note1, note3)
        expect(Note.search("first")).to_not include(note2)
      end

      it "1件だけヒットするノートを返すこと" do
        expect(Note.search("second")).to include(note2)
      end

    end

    context "検索結果にヒットしない時" do
      it "検索結果が１件も見つからなければからのコレクションを返すこと" do
        # result = Note.search("message")
        # pp result
        expect(Note.search("message")).to be_empty
        expect(Note.count).to eq 3
      end
    end
  end
end
